import { describe, expect, test } from "bun:test";
import { Cause, Effect, Exit } from "effect";
import { AiError } from "effect/unstable/ai";
import type { DispatchResult, Snapshot } from "../src/bridge.ts";
import type { Decided } from "../src/jev.ts";
import { contextOf, runLoop, runLoopEffect, type LoopDeps } from "../src/loop.ts";

const EPOCH = "c8a9facc8e01492790c35b596ab1970a";
const v = (revision: number) => `${EPOCH}:${revision}`;

const snap = (revision: number, overrides: Partial<Snapshot> = {}): Snapshot => ({
  state_type: "monster",
  terminal: false,
  waiting: false,
  legal_actions_complete: true,
  legal_actions: [
    { label: "play_card:3:1", description: "Play hand[3] Strike targeting Leaf Slime (S) (1)" },
    { label: "play_card:3:2", description: "Play hand[3] Strike targeting Twig Slime (M) (2)" },
    { label: "play_card:4:1", description: "Play hand[4] Strike targeting Leaf Slime (S) (1)" },
    { label: "end_turn", description: "End turn" },
  ],
  state_version: v(revision),
  mutation_pending: false,
  seed: "YXRKN2F6AQHC",
  run: { act: 1, floor: 2, ascension: 0 },
  ...overrides,
});

// Shapes copied from docs/evidence/m2/generic-live (immediate post-dispatch observation, game over).
const waiting = (revision: number, mutationPending = true): Snapshot => ({
  state_type: "waiting",
  waiting: true,
  terminal: false,
  legal_actions_complete: false,
  legal_actions: [],
  state_version: v(revision),
  mutation_pending: mutationPending,
});

const gameOver = (revision: number): Snapshot => ({
  state_type: "game_over",
  terminal: true,
  visible_text: "Defeated",
  seed: "YXRKN2F6AQHC",
  legal_actions_complete: true,
  legal_actions: [],
  state_version: v(revision),
  mutation_pending: false,
});

const decidedFor = (label: string, labels: ReadonlyArray<string>): Decided => ({
  label,
  probabilities: Object.fromEntries(
    labels.map((l) => [l, l === label ? 1 - 0.1 * (labels.length - 1) : 0.1]),
  ),
  confidence: undefined,
  modelId: "typesafe-ai/jev",
  responseId: "resp_1",
  usage: { inputTokens: 100, outputTokens: 4 },
  warnings: [],
});

const invalidOutput = () =>
  AiError.make({
    module: "JevGateway",
    method: "evaluate",
    reason: new AiError.InvalidOutputError({ description: "Provider returned an unknown label" }),
  });

interface Harness {
  readonly deps: LoopDeps;
  readonly logs: Array<Record<string, unknown>>;
  readonly posts: Array<{ stateVersion: string; label: string }>;
  readonly decideCalls: number;
  readonly controller: AbortController;
}

const harness = (
  observations: ReadonlyArray<Snapshot | (() => Snapshot)>,
  options: {
    decide?: LoopDeps["decide"];
    dispatch?: LoopDeps["dispatch"];
    log?: LoopDeps["log"];
    maxActions?: number;
    waitMs?: number;
  } = {},
): Harness => {
  const logs: Array<Record<string, unknown>> = [];
  const posts: Array<{ stateVersion: string; label: string }> = [];
  const controller = new AbortController();
  let observed = 0;
  const state = { decideCalls: 0 };
  const deps: LoopDeps = {
    observe: async () => {
      // Real transport always yields to the event loop; a purely microtask fake would starve timers/abort.
      await new Promise((resolve) => setTimeout(resolve, 0));
      const next = observations[Math.min(observed, observations.length - 1)]!;
      observed++;
      return typeof next === "function" ? next() : next;
    },
    dispatch:
      options.dispatch ??
      (async (stateVersion, label) => {
        posts.push({ stateVersion, label });
        return { status: 202, body: { status: "dispatched", state_version: stateVersion, label } };
      }),
    decide: async (stateInput, actions, signal) => {
      state.decideCalls++;
      if (options.decide) return options.decide(stateInput, actions, signal);
      return decidedFor(
        actions[0]!.label,
        actions.map((a) => a.label),
      );
    },
    log: options.log ?? ((record) => logs.push(record)),
    print: () => {},
    signal: controller.signal,
    maxActions: options.maxActions ?? 1,
    waitMs: options.waitMs ?? 200,
    pollMs: 5,
  };
  return {
    deps,
    logs,
    posts,
    controller,
    get decideCalls() {
      return state.decideCalls;
    },
  };
};

const ofType = (logs: ReadonlyArray<Record<string, unknown>>, type: string) =>
  logs.filter((r) => r.type === type);

describe("runLoop", () => {
  test("waits through zero-action observations, decides once, dispatches, then stops on terminal", async () => {
    const h = harness([waiting(3, false), snap(4), snap(4), waiting(5), gameOver(6)], {
      maxActions: 5,
    });
    const summary = await runLoop(h.deps);
    expect(h.posts).toEqual([{ stateVersion: v(4), label: "play_card:3:1" }]);
    expect(summary.outcome).toBe("terminal");
    expect(summary.dispatched).toBe(1);
    expect(summary.model_calls).toBe(1);
    expect(summary.forced).toBe(0);
    expect(summary.seed).toBe("YXRKN2F6AQHC");
    expect(summary.visible_text).toBe("Defeated");
    expect(summary.input_tokens).toBe(100);
    expect(ofType(h.logs, "wait").map((r) => r.state_version)).toEqual([v(3), v(5)]);
    const decision = ofType(h.logs, "decision")[0]!;
    expect(decision.source).toBe("model");
    expect(decision.model_id).toBe("typesafe-ai/jev");
    expect(decision.label).toBe("play_card:3:1");
    expect(decision.legal_actions).toEqual(snap(4).legal_actions);
    expect(decision.confidence).toBeNull();
    expect(ofType(h.logs, "dispatch")[0]).toMatchObject({ http_status: 202, state_version: v(4) });
    expect(h.logs.at(-1)!.type).toBe("summary");
  });

  test("contextOf strips bridge bookkeeping but keeps the snapshot", () => {
    const context = contextOf(snap(4)) as Record<string, unknown>;
    expect(Object.keys(context).sort()).toEqual([
      "run",
      "seed",
      "state_type",
      "terminal",
      "waiting",
    ]);
  });

  test("singleton legal set dispatches directly without inference and logs singleton_only", async () => {
    const proceed = { label: "choose_event_option:0", description: "Proceed: " };
    const single = snap(51, {
      state_type: "event",
      legal_actions: [proceed],
      run: { act: 1, floor: 3, ascension: 0 },
    });
    const h = harness([single, single, gameOver(52)]);
    const summary = await runLoop(h.deps);
    expect(h.decideCalls).toBe(0);
    expect(h.posts).toEqual([{ stateVersion: v(51), label: "choose_event_option:0" }]);
    const decision = ofType(h.logs, "decision")[0]!;
    expect(decision.source).toBe("singleton_only");
    expect(decision.model_id).toBeNull();
    expect(decision.probabilities).toBeNull();
    expect(decision.confidence).toBeNull();
    expect(ofType(h.logs, "inference")).toHaveLength(0);
    expect(summary).toMatchObject({ dispatched: 1, forced: 1, model_calls: 0 });
    expect(summary.input_tokens).toBeUndefined();
  });

  test("singleton that grows to multiple actions before dispatch is re-decided by Jev", async () => {
    const single = snap(45, {
      state_type: "map",
      legal_actions: [{ label: "choose_map_node:0", description: "Travel to Unknown at (3,2)" }],
      mutation_pending: true,
    });
    const multi = snap(54, {
      state_type: "map",
      legal_actions: [
        { label: "choose_map_node:0", description: "Travel to Monster at (2,3)" },
        { label: "choose_map_node:1", description: "Travel to Shop at (3,3)" },
      ],
    });
    const h = harness([single, multi, multi, multi, gameOver(55)], {
      decide: async (_state, actions) =>
        decidedFor(
          "choose_map_node:1",
          actions.map((a) => a.label),
        ),
    });
    const summary = await runLoop(h.deps);
    expect(h.decideCalls).toBe(1);
    expect(h.posts).toEqual([{ stateVersion: v(54), label: "choose_map_node:1" }]);
    expect(ofType(h.logs, "stale")[0]).toMatchObject({
      decided_version: v(45),
      current_version: v(54),
      source: "singleton_only",
    });
    expect(ofType(h.logs, "decision")).toHaveLength(1);
    expect(ofType(h.logs, "decision")[0]!.source).toBe("model");
    expect(summary).toMatchObject({ dispatched: 1, forced: 0, model_calls: 1 });
  });

  test("state change between inference and POST never dispatches the old choice", async () => {
    const h = harness([snap(4), snap(7), snap(7), snap(7), gameOver(8)], {
      decide: async (_state, actions) =>
        decidedFor(
          "end_turn",
          actions.map((a) => a.label),
        ),
    });
    await runLoop(h.deps);
    expect(h.decideCalls).toBe(2);
    expect(h.posts).toEqual([{ stateVersion: v(7), label: "end_turn" }]);
    expect(ofType(h.logs, "stale")[0]).toMatchObject({
      decided_version: v(4),
      current_version: v(7),
      source: "model",
    });
  });

  test("owned child decision is actionable while the parent mutation is pending", async () => {
    const reward = snap(30, {
      state_type: "card_reward",
      mutation_pending: true,
      legal_actions: [
        { label: "take_card:0", description: "Take Cleave" },
        { label: "skip_card", description: "Skip" },
      ],
    });
    const h = harness([reward, reward, gameOver(31)]);
    const summary = await runLoop(h.deps);
    expect(h.posts).toEqual([{ stateVersion: v(30), label: "take_card:0" }]);
    expect(summary.dispatched).toBe(1);
  });

  test("invalid answer is re-asked once, then dispatched", async () => {
    let calls = 0;
    const h = harness([snap(4), snap(4), gameOver(5)], {
      decide: async (_state, actions) => {
        calls++;
        if (calls === 1) throw invalidOutput();
        return decidedFor(
          "end_turn",
          actions.map((a) => a.label),
        );
      },
    });
    await runLoop(h.deps);
    expect(ofType(h.logs, "inference").map((r) => [r.attempt, r.ok])).toEqual([
      [1, false],
      [2, true],
    ]);
    expect(h.posts).toEqual([{ stateVersion: v(4), label: "end_turn" }]);
  });

  test("second invalid answer halts without dispatch", async () => {
    const h = harness([snap(4)], {
      decide: async () => {
        throw invalidOutput();
      },
    });
    const summary = await runLoop(h.deps);
    expect(h.decideCalls).toBe(2);
    expect(h.posts).toEqual([]);
    expect(summary.outcome).toBe("halted");
    expect(summary.halt_reason).toContain("unknown label");
    expect(summary.model_calls).toBe(2);
  });

  test("non-answer model failure halts without re-ask or dispatch", async () => {
    const h = harness([snap(4)], {
      decide: async () => {
        throw new Error("RequestSizeError: request too large");
      },
    });
    const summary = await runLoop(h.deps);
    expect(h.decideCalls).toBe(1);
    expect(h.posts).toEqual([]);
    expect(summary.halt_reason).toContain("request too large");
  });

  test("unsupported state halts without inference or dispatch", async () => {
    const h = harness([
      snap(9, {
        state_type: "unsupported",
        halt_reason: "unsupported_overlay:NShopScreen",
        legal_actions: [],
        legal_actions_complete: false,
      }),
    ]);
    const summary = await runLoop(h.deps);
    expect(summary).toMatchObject({
      outcome: "halted",
      halt_reason: "unsupported_overlay:NShopScreen",
      dispatched: 0,
    });
    expect(h.decideCalls).toBe(0);
    expect(h.posts).toEqual([]);
  });

  test("bounded wait on persistent waiting halts with wait_timeout", async () => {
    const h = harness([waiting(5)], { waitMs: 30 });
    const summary = await runLoop(h.deps);
    expect(summary).toMatchObject({
      outcome: "halted",
      halt_reason: "wait_timeout",
      dispatched: 0,
    });
    expect(ofType(h.logs, "wait")).toHaveLength(1);
  });

  test("dispatch timeout is never retried and halts as uncertain", async () => {
    let dispatches = 0;
    const h = harness([snap(4), snap(4), snap(4)], {
      maxActions: 3,
      dispatch: async () => {
        dispatches++;
        throw new DOMException("The operation timed out.", "TimeoutError");
      },
    });
    const summary = await runLoop(h.deps);
    expect(dispatches).toBe(1);
    expect(summary).toMatchObject({
      outcome: "halted",
      halt_reason: "dispatch_uncertain",
      dispatched: 0,
    });
    expect(ofType(h.logs, "dispatch")[0]).toMatchObject({
      uncertain: true,
      label: "play_card:3:1",
    });
  });

  test("409 rejection halts after one POST", async () => {
    const h = harness([snap(4), snap(4)], {
      maxActions: 3,
      dispatch: async (): Promise<DispatchResult> => ({
        status: 409,
        body: { status: "rejected", error: "stale, pending, or unknown action" },
      }),
    });
    const summary = await runLoop(h.deps);
    expect(summary).toMatchObject({
      outcome: "halted",
      halt_reason: "dispatch_rejected:409",
      dispatched: 0,
    });
  });

  test("abort while inference is pending prevents dispatch even when the answer arrives", async () => {
    let resolveDecide!: (d: Decided) => void;
    const h = harness([snap(4), snap(4)], {
      decide: () =>
        new Promise<Decided>((resolve) => {
          resolveDecide = resolve;
        }),
    });
    const run = runLoop(h.deps);
    await new Promise((r) => setTimeout(r, 10));
    h.controller.abort(new Error("SIGINT"));
    resolveDecide(
      decidedFor(
        "end_turn",
        snap(4).legal_actions.map((a) => a.label),
      ),
    );
    const summary = await run;
    expect(summary.outcome).toBe("aborted");
    expect(h.posts).toEqual([]);
    expect(ofType(h.logs, "decision")).toHaveLength(0);
  });

  test("abort while waiting stops polling without dispatch and reports the abort reason", async () => {
    const h = harness([waiting(5)], { waitMs: 5_000 });
    const run = runLoop(h.deps);
    await new Promise((r) => setTimeout(r, 15));
    h.controller.abort(new Error("SIGINT"));
    const summary = await run;
    expect(summary).toMatchObject({ outcome: "aborted", halt_reason: "SIGINT" });
    expect(h.posts).toEqual([]);
  });

  test("abort ends repeated stale snapshots even when observe ignores the signal", async () => {
    // Every observation is a fresh version, so each decision is stale forever; cancellation must still work.
    let revision = 0;
    const h = harness([() => snap(++revision)], { maxActions: 5 });
    const run = runLoop(h.deps);
    setTimeout(() => h.controller.abort(new Error("SIGINT")), 30);
    const summary = await run;
    expect(summary).toMatchObject({
      outcome: "aborted",
      halt_reason: "SIGINT",
      dispatched: 0,
    });
    expect(h.posts).toEqual([]);
    expect(ofType(h.logs, "stale").length).toBeGreaterThan(0);
  });

  test("a logging failure before dispatch prevents the POST", async () => {
    const h = harness([snap(4), snap(4)], {
      log: (record) => {
        if (record.type === "decision") throw new Error("disk full");
      },
    });
    const summary = await runLoop(h.deps);
    expect(h.posts).toEqual([]);
    expect(summary.outcome).toBe("halted");
    expect(summary.halt_reason).toContain("disk full");
  });

  test("stops at the action bound counting forced and model actions", async () => {
    const single = snap(1, { legal_actions: [{ label: "end_turn", description: "End turn" }] });
    const h = harness([single, single, snap(2), snap(2), snap(3)], { maxActions: 2 });
    const summary = await runLoop(h.deps);
    expect(summary).toMatchObject({
      outcome: "max_actions",
      dispatched: 2,
      forced: 1,
      model_calls: 1,
    });
    expect(h.posts.map((p) => p.stateVersion)).toEqual([v(1), v(2)]);
  });
});

describe("runLoopEffect", () => {
  // Run exactly as @crustjs/effect's handler does: Crust's signal interrupts the fiber via runPromiseExit.
  test("an in-flight dispatch aborted by Crust's signal logs its uncertain record and the summary before the fiber settles", async () => {
    const dispatchStarted = Promise.withResolvers<void>();
    const h = harness([snap(4), snap(4)], {
      dispatch: (_stateVersion, _label, signal) =>
        new Promise<DispatchResult>((_, reject) => {
          // Like an aborted fetch, the rejection lands later than the abort itself.
          signal.addEventListener("abort", () => setTimeout(() => reject(signal.reason), 20), {
            once: true,
          });
          dispatchStarted.resolve();
        }),
    });
    const exit = Effect.runPromiseExit(runLoopEffect(h.deps), { signal: h.controller.signal });
    await dispatchStarted.promise;
    h.controller.abort(new DOMException("Interrupted by SIGINT.", "AbortError"));
    const settled = await exit;
    expect(Exit.isFailure(settled) && Cause.hasInterruptsOnly(settled.cause)).toBe(true);
    expect(ofType(h.logs, "dispatch")).toMatchObject([{ uncertain: true }]);
    expect(h.logs.at(-1)).toMatchObject({
      type: "summary",
      outcome: "aborted",
      halt_reason: "Interrupted by SIGINT.",
    });
  });

  test("without cancellation the summary is the fiber's success value", async () => {
    const h = harness([gameOver(1)]);
    const summary = await Effect.runPromise(runLoopEffect(h.deps));
    expect(summary.outcome).toBe("terminal");
  });
});
