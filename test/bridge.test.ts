import { afterAll, describe, expect, test } from "bun:test";
import { dispatch, MalformedSnapshotError, observe, parseSnapshot } from "../src/bridge.ts";

// Local fake bridge on an ephemeral port. Never the game.
const seen: Array<{ method: string; headers: Headers; body: string }> = [];
let script: Array<() => Response> = [];
const server = Bun.serve({
  port: 0,
  hostname: "127.0.0.1",
  fetch: async (request) => {
    seen.push({ method: request.method, headers: request.headers, body: await request.text() });
    const next = script.shift();
    return next ? next() : new Response("no script", { status: 500 });
  },
});
afterAll(() => server.stop(true));
const url = `http://127.0.0.1:${server.port}/api/v1/singleplayer`;
const signal = () => new AbortController().signal;

const ready = {
  state_type: "map",
  terminal: false,
  waiting: false,
  legal_actions_complete: true,
  legal_actions: [{ label: "choose_map_node:0", description: "Travel to Monster at (2,3)" }],
  state_version: "epoch:54",
  mutation_pending: false,
};
const json = (body: unknown, status = 200, headers: Record<string, string> = {}) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { "content-type": "application/json", ...headers },
  });

describe("bridge transport", () => {
  test("GET sends no browser origin/fetch-metadata headers and parses the snapshot", async () => {
    seen.length = 0;
    script = [() => json(ready)];
    const snapshot = await observe(url, signal());
    expect(snapshot.state_version).toBe("epoch:54");
    expect(seen[0]!.method).toBe("GET");
    expect(seen[0]!.headers.get("origin")).toBeNull();
    expect(seen[0]!.headers.get("sec-fetch-mode")).toBeNull();
  });

  test("GET retries a 5xx a bounded number of times, then succeeds", async () => {
    seen.length = 0;
    script = [
      () => new Response("boom", { status: 503, headers: { "retry-after": "0" } }),
      () => json(ready),
    ];
    const snapshot = await observe(url, signal());
    expect(snapshot.state_type).toBe("map");
    expect(seen).toHaveLength(2);
  });

  test("GET gives up after three transport failures", async () => {
    seen.length = 0;
    script = [
      () => new Response("", { status: 500 }),
      () => new Response("", { status: 500 }),
      () => new Response("", { status: 500 }),
    ];
    const started = Date.now();
    expect(observe(url, signal())).rejects.toThrow("bridge GET returned 500");
    expect(seen).toHaveLength(3);
    expect(Date.now() - started).toBeGreaterThanOrEqual(1_900);
  }, 10_000);

  test("GET does not retry a 4xx or a malformed body", async () => {
    seen.length = 0;
    script = [() => new Response("nope", { status: 404 })];
    expect(observe(url, signal())).rejects.toThrow("bridge GET returned 404");
    script = [() => json({ state_type: "map" })];
    expect(observe(url, signal())).rejects.toBeInstanceOf(MalformedSnapshotError);
    expect(seen).toHaveLength(2);
  });

  test("POST sends exactly {state_version,label} as JSON once and returns status/body", async () => {
    seen.length = 0;
    script = [
      () =>
        json({ status: "dispatched", state_version: "epoch:54", label: "choose_map_node:0" }, 202),
    ];
    const result = await dispatch(url, "epoch:54", "choose_map_node:0", signal());
    expect(result.status).toBe(202);
    expect(result.body).toEqual({
      status: "dispatched",
      state_version: "epoch:54",
      label: "choose_map_node:0",
    });
    expect(seen).toHaveLength(1);
    expect(seen[0]!.method).toBe("POST");
    expect(seen[0]!.headers.get("content-type")).toBe("application/json");
    expect(JSON.parse(seen[0]!.body)).toEqual({
      state_version: "epoch:54",
      label: "choose_map_node:0",
    });
  });

  test("POST rejection body is returned, not retried", async () => {
    seen.length = 0;
    script = [() => json({ status: "rejected", error: "stale, pending, or unknown action" }, 409)];
    const result = await dispatch(url, "epoch:53", "choose_map_node:0", signal());
    expect(result).toEqual({
      status: 409,
      body: { status: "rejected", error: "stale, pending, or unknown action" },
    });
    expect(seen).toHaveLength(1);
  });

  test("GET halts instead of waiting when Retry-After exceeds the demo budget", async () => {
    seen.length = 0;
    script = [() => new Response("", { status: 503, headers: { "retry-after": "120" } })];
    expect(observe(url, signal())).rejects.toThrow("Retry-After");
    expect(seen).toHaveLength(1);
  });

  test("GET honors an HTTP-date Retry-After that is already due", async () => {
    seen.length = 0;
    script = [
      () =>
        new Response("", {
          status: 503,
          headers: { "retry-after": new Date(Date.now() - 1_000).toUTCString() },
        }),
      () => json(ready),
    ];
    const started = Date.now();
    const snapshot = await observe(url, signal());
    expect(snapshot.state_type).toBe("map");
    expect(seen).toHaveLength(2);
    expect(Date.now() - started).toBeLessThan(900);
  });

  test("parseSnapshot rejects wrongly typed optional fields the loop consumes", () => {
    expect(() => parseSnapshot({ ...ready, waiting: "true" })).toThrow(MalformedSnapshotError);
    expect(() => parseSnapshot({ ...ready, halt_reason: 7 })).toThrow(MalformedSnapshotError);
    expect(() => parseSnapshot({ ...ready, run: null })).toThrow(MalformedSnapshotError);
    expect(() => parseSnapshot({ ...ready, run: { act: "1", floor: 3 } })).toThrow(
      MalformedSnapshotError,
    );
    expect(() => parseSnapshot({ ...ready, seed: 42 })).toThrow(MalformedSnapshotError);
    expect(() => parseSnapshot({ ...ready, visible_text: ["Defeated"] })).toThrow(
      MalformedSnapshotError,
    );
    expect(
      parseSnapshot({
        ...ready,
        waiting: true,
        halt_reason: "x",
        run: { act: 1, floor: 3, ascension: 0 },
        seed: "S",
        visible_text: "t",
      }).seed,
    ).toBe("S");
  });

  test("parseSnapshot rejects duplicate labels and missing fields", () => {
    expect(() =>
      parseSnapshot({ ...ready, legal_actions: [ready.legal_actions[0], ready.legal_actions[0]] }),
    ).toThrow(MalformedSnapshotError);
    expect(() => parseSnapshot({ ...ready, legal_actions: [{ label: "x" }] })).toThrow(
      MalformedSnapshotError,
    );
    expect(() => parseSnapshot({ ...ready, state_version: undefined })).toThrow(
      MalformedSnapshotError,
    );
    expect(() => parseSnapshot("[]")).toThrow(MalformedSnapshotError);
  });
});
