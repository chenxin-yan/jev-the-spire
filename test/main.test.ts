import { afterAll, describe, expect, test } from "bun:test";
import { existsSync, mkdtempSync, readFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";

// Real CLI process (Crust root command) against a local fake bridge. Never the game; no inference
// (no fixture ever reaches a multi-action legal set, so no Gateway key is needed or set).
const ROOT = join(import.meta.dir, "..");
const OUT = mkdtempSync(join(tmpdir(), "jev-main-test-"));
const KILL_AFTER_MS = 15_000;

const terminal = {
  state_type: "game_over",
  terminal: true,
  visible_text: "Defeated",
  legal_actions_complete: true,
  legal_actions: [],
  state_version: "epoch:1",
  mutation_pending: false,
};
const halted = {
  ...terminal,
  state_type: "unsupported",
  terminal: false,
  halt_reason: "unsupported_state",
};
// Never ready: each poll sees a new version, so only an external abort ends the loop.
let version = 0;
const waiting = () => ({
  ...terminal,
  state_type: "combat",
  terminal: false,
  waiting: true,
  state_version: `epoch:${++version}`,
});

let gets = 0;
let posts = 0;
let onGet: ((request: Request) => Response | Promise<Response>) | undefined;
let firstGet: (() => void) | undefined;
const server = Bun.serve({
  hostname: "127.0.0.1",
  port: 0,
  fetch: (request) => {
    if (request.method === "POST") {
      posts++;
      return Response.json({ error: "unexpected" }, { status: 500 });
    }
    gets++;
    firstGet?.();
    return onGet!(request);
  },
});
afterAll(async () => {
  await server.stop(true);
  rmSync(OUT, { recursive: true, force: true });
});
const bridge = `http://127.0.0.1:${server.port}/api/v1/singleplayer`;

interface RunOptions {
  readonly respond?: (request: Request) => Response | Promise<Response>;
  readonly preload?: string;
  /** Called once the first GET reaches the fake bridge, with the running process. */
  readonly onFirstGet?: (proc: ReturnType<typeof Bun.spawn>) => void;
}

const runCli = async (args: ReadonlyArray<string>, logName: string, options: RunOptions = {}) => {
  gets = 0;
  posts = 0;
  onGet = options.respond ?? (() => Response.json(terminal));
  const logPath = join(OUT, logName);
  const preload = options.preload === undefined ? [] : [`--preload=${options.preload}`];
  const proc = Bun.spawn(
    [
      process.execPath,
      "--no-env-file",
      ...preload,
      "run",
      join(ROOT, "src/main.ts"),
      "--bridge",
      bridge,
      "--log",
      logPath,
      ...args,
    ],
    { cwd: OUT, stdout: "pipe", stderr: "pipe", env: { PATH: process.env.PATH ?? "" } },
  );
  firstGet = options.onFirstGet === undefined ? undefined : () => options.onFirstGet!(proc);
  // A hung CLI must fail the test instead of stalling the suite.
  const killer = setTimeout(() => proc.kill("SIGKILL"), KILL_AFTER_MS);
  const code = await proc.exited;
  clearTimeout(killer);
  firstGet = undefined;
  const stderr = await new Response(proc.stderr).text();
  const stdout = await new Response(proc.stdout).text();
  const log = existsSync(logPath)
    ? readFileSync(logPath, "utf8")
        .trim()
        .split("\n")
        .map((l) => JSON.parse(l))
    : undefined;
  return { code, gets, posts, stderr, stdout, log, logPath };
};

describe("main CLI arguments (Crust strict parsing)", () => {
  test.each([
    [["--max-actions"], "missing value"],
    [["--max-actions="], "empty value"],
    [["--max-actions", "0"], "zero"],
    [["--max-actions", "1.5"], "non-integer"],
    [["--max-actions", "-2"], "negative"],
    [["--max-actions", "9007199254740993"], "unsafe integer"],
    [["--max-actions", "1", "--unknown"], "unknown flag"],
    [["--max-actions", "1", "stray"], "positional"],
    [["--max-actions", "1", "--", "stray"], "raw args after --"],
    [["--help"], "no help extension installed"],
  ])("rejects %j (%s) with exit 1 before any log or bridge request", async (args, name) => {
    const result = await runCli(args, `${name}.jsonl`);
    expect(result.code).toBe(1);
    expect(result.gets).toBe(0);
    expect(result.log).toBeUndefined();
    expect(result.stderr).toStartWith("Error: ");
  });

  test("accepts --max-actions 1 and exits 0 on the terminal snapshot", async () => {
    const result = await runCli(["--max-actions", "1"], "ok.jsonl");
    expect(result.code).toBe(0);
    expect(result.gets).toBe(1);
    expect(result.log?.at(-1)).toMatchObject({
      type: "summary",
      outcome: "terminal",
      dispatched: 0,
      visible_text: "Defeated",
    });
  });

  test("defaults the bound to 10 actions", async () => {
    const result = await runCli([], "default.jsonl");
    expect(result.code).toBe(0);
    expect(result.stdout).toContain(" max-actions=10 ");
  });
});

describe("main CLI exit status", () => {
  test("a halted summary exits 1 with the reason on stderr", async () => {
    const result = await runCli(["--max-actions", "1"], "halted.jsonl", {
      respond: () => Response.json(halted),
    });
    expect(result.code).toBe(1);
    expect(result.posts).toBe(0);
    expect(result.log?.at(-1)).toMatchObject({
      type: "summary",
      outcome: "halted",
      halt_reason: "unsupported_state",
    });
    expect(result.stderr).toContain("Error: halted: unsupported_state");
  });

  test("Ctrl-C during a pending bridge read exits 130 with an aborted summary and no POST", async () => {
    const result = await runCli(["--max-actions", "1"], "sigint.jsonl", {
      // The GET never answers; the CLI must abort it on SIGINT rather than wait for the HTTP timeout.
      respond: () => new Promise<Response>(() => {}),
      onFirstGet: (proc) => proc.kill("SIGINT"),
    });
    expect(result.code).toBe(130);
    expect(result.gets).toBe(1);
    expect(result.posts).toBe(0);
    expect(result.log?.at(-1)).toMatchObject({
      type: "summary",
      outcome: "aborted",
      halt_reason: "SIGINT",
    });
    expect(result.stderr).toContain("Ctrl-C: stopping; no further dispatch");
    expect(result.stderr).not.toContain("Error:");
  });

  test("the whole-demo deadline aborts an endlessly waiting bridge and exits 1", async () => {
    const result = await runCli(["--max-actions", "1"], "deadline.jsonl", {
      respond: () => Response.json(waiting()),
      preload: join(import.meta.dir, "deadline-preload.ts"),
    });
    expect(result.code).toBe(1);
    expect(result.posts).toBe(0);
    expect(result.gets).toBeGreaterThan(0);
    expect(result.log?.at(-1)).toMatchObject({
      type: "summary",
      outcome: "aborted",
      halt_reason: "demo_deadline",
    });
    expect(result.stderr).toContain("demo deadline of 300000ms reached");
    expect(result.stderr).toContain("Error: aborted: demo_deadline");
  });
});
