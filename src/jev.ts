// Jev decider: one joint Gateway choice evaluation, executed with Effect.
import { Effect, Schema } from "effect";
import { AiError } from "effect/unstable/ai";
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
    const questions = {
      action: { type: "choice", instructions: INSTRUCTIONS, criteria },
    } as const;
    const program = Effect.tryPromise({
      try: async (fiberSignal) => {
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
          // Effect rc.116 DecisionModel cannot express declared rounding. Use the SDK's validation without
          // renormalizing; the duplicate validator can return only when upstream supports that metadata.
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
        if (result.response.modelId !== JEV_MODEL_ID)
          throw invalidOutput(`unexpected model id ${result.response.modelId}`);
        const answer = result.answers.action;
        // The SDK allows omitted probabilities; this adapter requires the provider's full distribution.
        if (answer.probabilities === undefined)
          throw invalidOutput("answer action has no probability distribution");
        return {
          label: answer.choice,
          probabilities: answer.probabilities,
          confidence: undefined,
          modelId: result.response.modelId,
          responseId: result.response.id,
          usage: { inputTokens: result.usage.inputTokens, outputTokens: result.usage.outputTokens },
          warnings: result.warnings,
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
    });
    return Effect.runPromise(program, { signal });
  };
