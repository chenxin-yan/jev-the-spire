// Sequential observe -> decide -> validate -> dispatch -> re-observe loop with a finite action bound.
import type { Schema } from "effect";
import type { DispatchResult, LegalAction, Snapshot } from "./bridge.ts";
import { isInvalidAnswer, type Decided, type Decider } from "./jev.ts";

export interface LoopDeps {
  readonly observe: (signal: AbortSignal) => Promise<Snapshot>;
  readonly dispatch: (
    stateVersion: string,
    label: string,
    signal: AbortSignal,
  ) => Promise<DispatchResult>;
  readonly decide: Decider;
  /** Appends one JSONL record. Must throw on failure: an unlogged action never dispatches. */
  readonly log: (record: Record<string, unknown>) => void;
  readonly print: (line: string) => void;
  readonly signal: AbortSignal;
  /** Demo bound on dispatched actions (model-chosen and forced singleton alike). */
  readonly maxActions: number;
  readonly waitMs?: number;
  readonly pollMs?: number;
}

export interface Summary {
  readonly outcome: "terminal" | "max_actions" | "aborted" | "halted";
  readonly halt_reason?: string;
  readonly dispatched: number;
  readonly model_calls: number;
  readonly forced: number;
  readonly seed?: string;
  readonly act?: number;
  readonly floor?: number;
  readonly last_state_type?: string;
  readonly visible_text?: string;
  readonly input_tokens?: number;
  readonly output_tokens?: number;
  readonly wall_ms: number;
}

const DEFAULT_WAIT_MS = 30_000;
const DEFAULT_POLL_MS = 500;

// Bridge bookkeeping is not gameplay context; legal actions travel as the decision criteria.
const BOOKKEEPING_KEYS = [
  "legal_actions",
  "legal_actions_complete",
  "state_version",
  "mutation_pending",
];

export const contextOf = (snapshot: Snapshot): Schema.Json => {
  const context: Record<string, unknown> = {};
  for (const [key, value] of Object.entries(snapshot)) {
    if (!BOOKKEEPING_KEYS.includes(key)) context[key] = value;
  }
  return context as Schema.Json;
};

const describeError = (error: unknown): string =>
  error instanceof Error ? `${error.name}: ${error.message}` : String(error);

// Abort reasons are set by main (SIGINT / demo_deadline) and reported verbatim in the summary.
const abortReason = (signal: AbortSignal): string =>
  signal.reason instanceof Error ? signal.reason.message : String(signal.reason);

const sleep = (ms: number, signal: AbortSignal) =>
  new Promise<void>((resolve, reject) => {
    // An already-aborted signal never fires "abort"; fail immediately instead of waiting out the timer.
    if (signal.aborted) return reject(signal.reason);
    const timer = setTimeout(() => {
      signal.removeEventListener("abort", onAbort);
      resolve();
    }, ms);
    const onAbort = () => {
      clearTimeout(timer);
      reject(signal.reason);
    };
    signal.addEventListener("abort", onAbort, { once: true });
  });

const formatActions = (actions: ReadonlyArray<LegalAction>) =>
  actions.map((action) => `  ${action.label}  ${action.description}`).join("\n");

const formatDistribution = (decided: Decided) =>
  Object.entries(decided.probabilities)
    .sort(([, a], [, b]) => b - a)
    .map(([label, probability]) => `${label}=${probability}`)
    .join(" ");

interface Ready {
  readonly kind: "ready" | "terminal" | "halt" | "timeout";
  readonly snapshot: Snapshot;
}

// Owner decision (docs/minimal-demo.md): a singleton legal set executes directly without a model call.
type Choice =
  | {
      readonly source: "model";
      readonly label: string;
      readonly decided: Decided;
    }
  | { readonly source: "singleton_only"; readonly label: string };

export const runLoop = async (deps: LoopDeps): Promise<Summary> => {
  const { signal, log, print } = deps;
  const waitMs = deps.waitMs ?? DEFAULT_WAIT_MS;
  const pollMs = deps.pollMs ?? DEFAULT_POLL_MS;
  const started = Date.now();
  let dispatched = 0;
  let modelCalls = 0;
  let forced = 0;
  let inputTokens: number | undefined;
  let outputTokens: number | undefined;
  let last: Snapshot | undefined;

  const finish = (outcome: Summary["outcome"], haltReason?: string): Summary => {
    const summary: Summary = {
      outcome,
      ...(haltReason === undefined ? {} : { halt_reason: haltReason }),
      dispatched,
      model_calls: modelCalls,
      forced,
      ...(last?.seed === undefined ? {} : { seed: last.seed }),
      ...(last?.run === undefined ? {} : { act: last.run.act, floor: last.run.floor }),
      ...(last === undefined ? {} : { last_state_type: last.state_type }),
      ...(last?.visible_text === undefined ? {} : { visible_text: last.visible_text }),
      ...(inputTokens === undefined ? {} : { input_tokens: inputTokens }),
      ...(outputTokens === undefined ? {} : { output_tokens: outputTokens }),
      wall_ms: Date.now() - started,
    };
    log({ type: "summary", ts: new Date().toISOString(), ...summary });
    print(`summary: ${JSON.stringify(summary)}`);
    return summary;
  };

  const awaitReady = async (): Promise<Ready> => {
    const deadline = Date.now() + waitMs;
    let loggedVersion: string | undefined;
    while (true) {
      const snapshot = await deps.observe(signal);
      last = snapshot;
      if (snapshot.terminal) return { kind: "terminal", snapshot };
      if (snapshot.halt_reason !== undefined) return { kind: "halt", snapshot };
      // Complete, non-waiting and non-empty. mutation_pending alone never blocks: owned child decisions are actionable.
      if (
        snapshot.legal_actions_complete &&
        snapshot.waiting !== true &&
        snapshot.legal_actions.length > 0
      ) {
        return { kind: "ready", snapshot };
      }
      if (snapshot.state_version !== loggedVersion) {
        loggedVersion = snapshot.state_version;
        log({
          type: "wait",
          ts: new Date().toISOString(),
          state_version: snapshot.state_version,
          state_type: snapshot.state_type,
          waiting: snapshot.waiting ?? null,
          legal_actions_complete: snapshot.legal_actions_complete,
          action_count: snapshot.legal_actions.length,
          mutation_pending: snapshot.mutation_pending,
        });
        print(
          `waiting: ${snapshot.state_type} ${snapshot.state_version} actions=${snapshot.legal_actions.length}`,
        );
      }
      if (Date.now() >= deadline) return { kind: "timeout", snapshot };
      await sleep(pollMs, signal);
    }
  };

  const inferOnce = async (state: Schema.Json, snapshot: Snapshot, attempt: number) => {
    const t0 = Date.now();
    modelCalls++;
    try {
      const decided = await deps.decide(state, snapshot.legal_actions, signal);
      log({
        type: "inference",
        ts: new Date().toISOString(),
        state_version: snapshot.state_version,
        attempt,
        ok: true,
        latency_ms: Date.now() - t0,
        model_id: decided.modelId,
        response_id: decided.responseId ?? null,
        usage: decided.usage,
        warnings: decided.warnings,
      });
      if (decided.usage.inputTokens !== undefined)
        inputTokens = (inputTokens ?? 0) + decided.usage.inputTokens;
      if (decided.usage.outputTokens !== undefined)
        outputTokens = (outputTokens ?? 0) + decided.usage.outputTokens;
      return decided;
    } catch (error) {
      log({
        type: "inference",
        ts: new Date().toISOString(),
        state_version: snapshot.state_version,
        attempt,
        ok: false,
        latency_ms: Date.now() - t0,
        error: describeError(error),
      });
      throw error;
    }
  };

  // Invalid answers get exactly one re-ask against the same snapshot (#6); anything else propagates.
  const infer = async (snapshot: Snapshot): Promise<Decided> => {
    const state = contextOf(snapshot);
    try {
      return await inferOnce(state, snapshot, 1);
    } catch (error) {
      if (!isInvalidAnswer(error) || signal.aborted) throw error;
      print(`invalid answer, re-asking once: ${describeError(error)}`);
      return await inferOnce(state, snapshot, 2);
    }
  };

  const choose = async (snapshot: Snapshot): Promise<Choice> => {
    const sole = snapshot.legal_actions.length === 1 ? snapshot.legal_actions[0] : undefined;
    if (sole !== undefined) {
      print(`singleton legal set: ${sole.label}  ${sole.description} (no inference)`);
      return { source: "singleton_only", label: sole.label };
    }
    print(
      `[action ${dispatched + 1}/${deps.maxActions}] legal actions:\n${formatActions(snapshot.legal_actions)}`,
    );
    const decided = await infer(snapshot);
    print(
      `Jev (${decided.modelId}): ${decided.label}` +
        `  confidence=${decided.confidence ?? "not returned"}\n  distribution: ${formatDistribution(decided)}`,
    );
    return { source: "model", label: decided.label, decided };
  };

  try {
    while (true) {
      signal.throwIfAborted();
      if (dispatched >= deps.maxActions) return finish("max_actions");
      const ready = await awaitReady();
      const snapshot = ready.snapshot;
      print(
        `observed: ${snapshot.state_type} ${snapshot.state_version}` +
          (snapshot.run ? ` act ${snapshot.run.act} floor ${snapshot.run.floor}` : "") +
          ` actions=${snapshot.legal_actions.length}`,
      );
      if (ready.kind === "terminal") return finish("terminal");
      if (ready.kind === "halt") return finish("halted", snapshot.halt_reason);
      if (ready.kind === "timeout") return finish("halted", "wait_timeout");

      const choice = await choose(snapshot);

      // Ctrl-C or the demo deadline during inference must prevent the POST even though the answer arrived.
      if (signal.aborted) return finish("aborted", abortReason(signal));

      // Freshness: the choice is only valid against the exact snapshot it was made on.
      // A changed version (e.g. alternatives appearing after a singleton) goes back through observation.
      const fresh = await deps.observe(signal);
      last = fresh;
      if (fresh.state_version !== snapshot.state_version) {
        log({
          type: "stale",
          ts: new Date().toISOString(),
          decided_version: snapshot.state_version,
          current_version: fresh.state_version,
          source: choice.source,
          label: choice.label,
        });
        print(
          `stale: state changed before dispatch (${snapshot.state_version} -> ${fresh.state_version}); re-observing`,
        );
        continue;
      }
      if (!snapshot.legal_actions.some((action) => action.label === choice.label)) {
        return finish("halted", `unknown_label:${choice.label}`);
      }

      const decided = choice.source === "model" ? choice.decided : undefined;
      log({
        type: "decision",
        ts: new Date().toISOString(),
        state_version: snapshot.state_version,
        state_type: snapshot.state_type,
        run: snapshot.run ?? null,
        legal_actions: snapshot.legal_actions,
        source: choice.source,
        label: choice.label,
        probabilities: decided?.probabilities ?? null,
        confidence: decided?.confidence ?? null,
        model_id: decided?.modelId ?? null,
      });

      const t0 = Date.now();
      let result: DispatchResult;
      try {
        result = await deps.dispatch(snapshot.state_version, choice.label, signal);
      } catch (error) {
        // Outcome unknown (timeout/network/abort mid-flight): never retry a mutation.
        log({
          type: "dispatch",
          ts: new Date().toISOString(),
          state_version: snapshot.state_version,
          label: choice.label,
          uncertain: true,
          latency_ms: Date.now() - t0,
          error: describeError(error),
        });
        return finish(
          signal.aborted ? "aborted" : "halted",
          signal.aborted ? abortReason(signal) : "dispatch_uncertain",
        );
      }
      log({
        type: "dispatch",
        ts: new Date().toISOString(),
        state_version: snapshot.state_version,
        label: choice.label,
        http_status: result.status,
        body: result.body,
        latency_ms: Date.now() - t0,
      });
      print(`POST ${result.status} ${JSON.stringify(result.body)}`);
      if (result.status !== 202) return finish("halted", `dispatch_rejected:${result.status}`);
      dispatched++;
      if (choice.source === "singleton_only") forced++;
    }
  } catch (error) {
    if (signal.aborted) return finish("aborted", abortReason(signal));
    return finish("halted", describeError(error));
  }
};
