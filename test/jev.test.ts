import { describe, expect, test } from "bun:test";
import { createGateway } from "@ai-sdk/gateway";
import { INSTRUCTIONS, isInvalidAnswer, JEV_MODEL_ID, makeJevDecider } from "../src/jev.ts";

// Duplicate card names and multi-target labels from docs/evidence/m2/generic-live/combat-ready.json.
const actions = [
  { label: "play_card:0:none", description: "Play hand[0] Defend" },
  { label: "play_card:1:none", description: "Play hand[1] Defend" },
  { label: "play_card:3:1", description: "Play hand[3] Strike targeting Leaf Slime (S) (1)" },
  { label: "play_card:3:2", description: "Play hand[3] Strike targeting Twig Slime (M) (2)" },
  { label: "play_card:4:1", description: "Play hand[4] Strike targeting Leaf Slime (S) (1)" },
  { label: "end_turn", description: "End turn" },
];
const state = {
  state_type: "monster",
  run: { act: 1, floor: 2, ascension: 0 },
  player: { hp: 80 },
  terminal: false,
};

interface Captured {
  url: string;
  headers: Record<string, string>;
  body: Record<string, unknown>;
}

// Real @ai-sdk/gateway evaluation model + real `ai` evaluate over a fake transport. No network.
let lastRequestSignal: AbortSignal | undefined;

const decider = (
  respond: (captured: Captured) => Response | Promise<Response>,
  deadlineMs?: number,
) => {
  const calls: Captured[] = [];
  const fakeFetch = async (input: string | URL | Request, init?: RequestInit) => {
    const request = new Request(input, init);
    lastRequestSignal = request.signal;
    const headers: Record<string, string> = {};
    request.headers.forEach((value, key) => {
      headers[key] = value;
    });
    const captured = { url: request.url, headers, body: await request.json() };
    calls.push(captured);
    return respond(captured);
  };
  const gateway = createGateway({ apiKey: "fake-test-key", fetch: fakeFetch as typeof fetch });
  return { decide: makeJevDecider(gateway.evaluation(JEV_MODEL_ID), deadlineMs), calls };
};

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { "content-type": "application/json" } });

describe("makeJevDecider", () => {
  test("maps a joint classify decision to one Gateway choice question and back", async () => {
    const probabilities = {
      "play_card:0:none": 0.05,
      "play_card:1:none": 0.05,
      "play_card:3:1": 0.5,
      "play_card:3:2": 0.2,
      "play_card:4:1": 0.1,
      end_turn: 0.1,
    };
    const { decide, calls } = decider(() =>
      json({
        answers: { action: { type: "choice", choice: "play_card:3:1", probabilities } },
        usage: { inputTokens: 1234, outputTokens: 7 },
      }),
    );
    const decided = await decide(state, actions, new AbortController().signal);

    expect(calls).toHaveLength(1);
    const request = calls[0]!;
    expect(request.url).toBe("https://ai-gateway.vercel.sh/v4/ai/evaluation-model");
    expect(request.headers["ai-model-id"]).toBe("typesafe-ai/jev");
    expect(request.headers["ai-evaluation-model-specification-version"]).toBe("4");
    expect(request.headers["authorization"]).toBe("Bearer fake-test-key");
    expect(request.body.state).toEqual(state);
    expect(request.body.questions).toEqual({
      action: {
        type: "choice",
        instructions: INSTRUCTIONS,
        criteria: Object.fromEntries(actions.map((a) => [a.label, a.description])),
      },
    });

    expect(decided.label).toBe("play_card:3:1");
    expect(decided.probabilities).toEqual(probabilities);
    expect(decided.confidence).toBeUndefined();
    expect(decided.modelId).toBe("typesafe-ai/jev");
    expect(decided.usage).toEqual({ inputTokens: 1234, outputTokens: 7 });
  });

  test("unknown label from the provider is an invalid answer (re-askable), never dispatched", async () => {
    const { decide } = decider(() =>
      json({ answers: { action: { type: "choice", choice: "play_card:9:9" } } }),
    );
    const error = await decide(state, actions, new AbortController().signal).catch((e) => e);
    expect(isInvalidAnswer(error)).toBe(true);
  });

  test("missing probabilities is an invalid answer rather than an invented distribution", async () => {
    const { decide } = decider(() =>
      json({ answers: { action: { type: "choice", choice: "end_turn" } } }),
    );
    const error = await decide(state, actions, new AbortController().signal).catch((e) => e);
    expect(isInvalidAnswer(error)).toBe(true);
    expect(String(error)).toContain("no probability");
  });

  test("malformed response body is not an invalid answer and is not retried as one", async () => {
    const { decide, calls } = decider(() => json({ nonsense: true }));
    const error = await decide(state, actions, new AbortController().signal).catch((e) => e);
    expect(error).toBeDefined();
    expect(isInvalidAnswer(error)).toBe(false);
    expect(calls).toHaveLength(1);
  });

  test("oversized snapshot halts before any request", async () => {
    const { decide, calls } = decider(() => json({}));
    const huge = { ...state, filler: "x".repeat(40_000) };
    const error = await decide(huge, actions, new AbortController().signal).catch((e) => e);
    expect(String(error)).toContain("request too large");
    expect(isInvalidAnswer(error)).toBe(false);
    expect(calls).toHaveLength(0);
  });

  test("abort while the provider call is pending rejects without an answer", async () => {
    const controller = new AbortController();
    const { decide } = decider(
      (captured) =>
        new Promise<Response>((_, reject) => {
          // The AI SDK forwards the abort signal to fetch; mirror a real aborted fetch.
          controller.signal.addEventListener("abort", () => reject(controller.signal.reason));
          void captured;
        }),
    );
    const pending = decide(state, actions, controller.signal);
    setTimeout(() => controller.abort(new Error("SIGINT")), 10);
    const error = await pending.catch((e) => e);
    expect(error).toBeDefined();
    expect(isInvalidAnswer(error)).toBe(false);
  });

  test("a provider call that never answers is cut off by the inference deadline", async () => {
    const { decide, calls } = decider(
      () =>
        new Promise<Response>((_, reject) => {
          const signal = lastRequestSignal!;
          signal.addEventListener("abort", () => reject(signal.reason), { once: true });
        }),
      30,
    );
    const started = Date.now();
    const error = await decide(state, actions, new AbortController().signal).then(
      () => undefined,
      (e) => e,
    );
    expect(Date.now() - started).toBeLessThan(2_000);
    expect(calls).toHaveLength(1);
    expect(String(error)).toContain("inference deadline");
    expect(isInvalidAnswer(error)).toBe(false);
  });
});
