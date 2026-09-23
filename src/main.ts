// Play until terminal/failure or Ctrl-C: `bun run src/main.ts [--max-actions N] [--log PATH] [--bridge URL]`
// Requires AI_GATEWAY_API_KEY in the environment (read by @ai-sdk/gateway, never by this code).
import { appendFileSync, mkdirSync } from "node:fs";
import { dirname } from "node:path";
import { gateway } from "@ai-sdk/gateway";
import { Crust } from "@crustjs/core";
import { handler } from "@crustjs/effect";
import { Effect } from "effect";
import { BRIDGE_URL, dispatch, observe } from "./bridge.ts";
import { JEV_MODEL_ID, makeJevDecider } from "./jev.ts";
import { runLoopEffect } from "./loop.ts";

// Crust's `number` type accepts "", 0, negatives and floats; the bound needs a positive safe integer.
const parsePositiveInteger = (raw: string): number => {
  const value = Number(raw);
  if (raw.trim() === "" || !Number.isSafeInteger(value) || value <= 0) {
    throw new Error(`expected a positive integer, got ${JSON.stringify(raw)}`);
  }
  return value;
};

// Unknown/missing flags and positionals are rejected by Crust before this action runs (exit 1).
const app = new Crust("jev")
  .flags(
    {
      name: "max-actions",
      type: "string",
      parse: parsePositiveInteger,
    },
    { name: "log", type: "string" },
    { name: "bridge", type: "string", default: BRIDGE_URL },
  )
  .action(
    handler(({ flags, rawArgs, signal }) =>
      Effect.gen(function* () {
        // No raw passthrough: anything after `--` is a mistake, refused before any log or bridge I/O.
        if (rawArgs.length > 0)
          return yield* Effect.fail(
            new Error(`unexpected arguments after "--": ${rawArgs.join(" ")}`),
          );
        const maxActions = flags["max-actions"];
        const bridgeUrl = flags.bridge;
        const logPath =
          flags.log ?? `logs/run-${new Date().toISOString().replace(/[:.]/g, "-")}.jsonl`;
        mkdirSync(dirname(logPath), { recursive: true });
        console.log(
          `bridge=${bridgeUrl} model=${JEV_MODEL_ID} max-actions=${maxActions ?? "unlimited"} log=${logPath}`,
        );

        // Crust aborts `signal` on the first Ctrl-C (a second one force-quits); the loop stops through
        // pending I/O and inference and never dispatches afterwards.
        const onAbort = () => console.error("\nCtrl-C: stopping; no further dispatch");
        signal.addEventListener("abort", onAbort, { once: true });
        const summary = yield* Effect.ensuring(
          runLoopEffect({
            observe: (signal) => observe(bridgeUrl, signal),
            dispatch: (stateVersion, label, signal) =>
              dispatch(bridgeUrl, stateVersion, label, signal),
            decide: makeJevDecider(gateway.evaluation(JEV_MODEL_ID)),
            // Synchronous append: a failed write throws before any dispatch.
            log: (record) => appendFileSync(logPath, JSON.stringify(record) + "\n"),
            print: (line) => console.log(line),
            signal,
            maxActions,
          }),
          Effect.sync(() => signal.removeEventListener("abort", onAbort)),
        );
        // The summary is already logged and printed; only the exit status is decided here.
        if (summary.outcome === "terminal" || summary.outcome === "max_actions") return summary;
        // Ctrl-C is Effect interruption, which Crust reports silently as exit 130.
        if (summary.outcome === "aborted") return yield* Effect.interrupt;
        return yield* Effect.fail(new Error(`${summary.outcome}: ${summary.halt_reason}`));
      }),
    ),
  );

// execute() renders failures, runs Crust cleanup and sets process.exitCode (0, 1, or 130 on Ctrl-C).
await app.execute();
