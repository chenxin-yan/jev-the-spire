// Jev decider: Effect v4 Decision/DecisionModel over the AI SDK `experimental_evaluate`
// Gateway evaluation model for `typesafe-ai/jev`. One joint classify decision per call.
import { Effect, Schema } from "effect";
import { AiError, Decision, DecisionModel } from "effect/unstable/ai";
import {
  experimental_evaluate,
  InvalidResponseDataError,
  type Experimental_EvaluationModel,
  type Experimental_EvaluationQuestion,
} from "ai";
import type { LegalAction } from "./bridge.ts";

export const JEV_MODEL_ID = "typesafe-ai/jev";

export const INSTRUCTIONS =
  "You are playing Slay the Spire 2. The state is the current visible game snapshot. " +
  "Choose exactly one of the legal actions to take right now.";

// TypeSafe request limits from the cached contract (#6): 64k for state plus all questions,
// 32k for state plus the longest question. Measured in JSON characters; oversize halts, never truncates.
const MAX_TOTAL_CHARS = 64_000;
const MAX_STATE_PLUS_QUESTION_CHARS = 32_000;
// One provider call (including the SDK's own transport retries) must finish within this deadline.
export const INFERENCE_DEADLINE_MS = 60_000;

export interface Decided {
  readonly label: string;
  readonly probabilities: Readonly<Record<string, number>>;
  readonly confidence: number | undefined;
  readonly modelId: string;
  readonly responseId: string | undefined;
  readonly usage: {
    readonly inputTokens: number | undefined;
    readonly outputTokens: number | undefined;
  };
  readonly warnings: ReadonlyArray<unknown>;
}

export type Decider = (
  state: Schema.Json,
  actions: ReadonlyArray<LegalAction>,
  signal: AbortSignal,
) => Promise<Decided>;

export class RequestSizeError extends Error {
  override readonly name = "RequestSizeError";
}

// Invalid model answers (unknown label, bad distribution, wrong model id) get one re-ask per #6.
export const isInvalidAnswer = (error: unknown): boolean =>
  AiError.isAiError(error) && error.reason._tag === "InvalidOutputError";

const invalidInput = (description: string) =>
  AiError.make({
    module: "JevGateway",
    method: "evaluate",
    reason: new AiError.InvalidUserInputError({ description }),
  });

const invalidOutput = (description: string) =>
  AiError.make({
    module: "JevGateway",
    method: "evaluate",
    reason: new AiError.InvalidOutputError({ description }),
  });

const toQuestion = (decision: Decision.Any): Experimental_EvaluationQuestion => {
  switch (decision._tag) {
    case "Classify":
      return { type: "choice", instructions: decision.instructions, criteria: decision.criteria };
    case "Rate":
      return { type: "score", instructions: decision.instructions, criteria: decision.criteria };
    case "Probability":
      return { type: "boolean", instructions: decision.instructions, criteria: decision.criteria };
  }
};

const checkRequestSize = (
  state: Schema.Json,
  questions: Record<string, Experimental_EvaluationQuestion>,
) => {
  const stateChars = JSON.stringify(state).length;
  const questionChars = Object.values(questions).map((question) => JSON.stringify(question).length);
  const total = stateChars + questionChars.reduce((sum, chars) => sum + chars, 0);
  const longest = stateChars + Math.max(0, ...questionChars);
  if (total > MAX_TOTAL_CHARS || longest > MAX_STATE_PLUS_QUESTION_CHARS) {
    throw new RequestSizeError(
      `request too large: state+questions=${total} (limit ${MAX_TOTAL_CHARS}), state+longest=${longest} (limit ${MAX_STATE_PLUS_QUESTION_CHARS})`,
    );
  }
};

export const makeJevDecider =
  (model: Experimental_EvaluationModel, deadlineMs = INFERENCE_DEADLINE_MS): Decider =>
  async (state, actions, signal) => {
    const criteria = Object.fromEntries(
      actions.map((action) => [action.label, action.description]),
    );
    const definition = Decision.make({
      input: Schema.Json,
      decisions: { action: Decision.classify({ instructions: INSTRUCTIONS, criteria }) },
    });
    let meta: Pick<Decided, "modelId" | "responseId" | "warnings"> | undefined;

    const program = Effect.gen(function* () {
      const decisionModel = yield* DecisionModel.make({
        decide: (options) =>
          Effect.tryPromise({
            try: async (fiberSignal) => {
              const questions = Object.fromEntries(
                Object.entries(options.decisions).map(([key, decision]) => [
                  key,
                  toQuestion(decision),
                ]),
              );
              const state = options.state;
              if (typeof state !== "object" || state === null)
                throw invalidInput("snapshot context must be a JSON object");
              checkRequestSize(state, questions);
              const deadline = new AbortController();
              const timer = setTimeout(
                () => deadline.abort(new Error(`inference deadline of ${deadlineMs}ms exceeded`)),
                deadlineMs,
              );
              let result: Awaited<ReturnType<typeof experimental_evaluate<typeof questions>>>;
              try {
                result = await experimental_evaluate({
                  model,
                  state,
                  questions,
                  abortSignal: AbortSignal.any([signal, fiberSignal, deadline.signal]),
                });
              } catch (error) {
                // The SDK's retry backoff reports a generic abort; surface the deadline as the cause.
                throw deadline.signal.aborted ? deadline.signal.reason : error;
              } finally {
                clearTimeout(timer);
              }
              // Requested SDK identity (Gateway echoes the configured model id); guards adapter/config mismatch, not server attestation.
              meta = {
                modelId: result.response.modelId,
                responseId: result.response.id,
                warnings: result.warnings,
              };
              if (result.response.modelId !== JEV_MODEL_ID) {
                throw invalidOutput(`unexpected model id ${result.response.modelId}`);
              }
              const answers: Record<string, DecisionModel.ProviderAnswer> = {};
              for (const [key, answer] of Object.entries(result.answers)) {
                if (answer.type !== "choice") throw invalidOutput(`answer ${key} is not a choice`);
                // Gateway may omit probabilities; DecisionModel then rejects the answer (no invented distribution).
                answers[key] = {
                  _tag: "Classify",
                  label: answer.choice,
                  probabilities: answer.probabilities ?? {},
                };
              }
              return {
                answers,
                usage: {
                  inputTokens: result.usage.inputTokens,
                  outputTokens: result.usage.outputTokens,
                },
              };
            },
            catch: (error) => {
              if (AiError.isAiError(error)) return error;
              if (InvalidResponseDataError.isInstance(error)) return invalidOutput(error.message);
              return AiError.make({
                module: "JevGateway",
                method: "evaluate",
                reason: new AiError.UnknownError({
                  description: error instanceof Error ? error.message : String(error),
                }),
              });
            },
          }),
      });
      return yield* decisionModel.decide(definition, { input: state });
    });

    const response = await Effect.runPromise(program, { signal });
    const answer = response.answers.action;
    return {
      label: answer.label,
      probabilities: answer.probabilities,
      confidence: answer.confidence,
      modelId: meta!.modelId,
      responseId: meta!.responseId,
      usage: { inputTokens: response.usage.inputTokens, outputTokens: response.usage.outputTokens },
      warnings: meta!.warnings,
    };
  };
