import { readFileSync } from "node:fs";
import { gateway } from "/Users/yanchenxin/dev/github.com/chenxin-yan/jev-slay-the-spire-2/node_modules/@ai-sdk/gateway/dist/index.js";
import { parseSnapshot } from "/Users/yanchenxin/dev/github.com/chenxin-yan/jev-slay-the-spire-2/src/bridge.ts";
import { contextOf } from "/Users/yanchenxin/dev/github.com/chenxin-yan/jev-slay-the-spire-2/src/loop.ts";
import { makeJevDecider, JEV_MODEL_ID, isInvalidAnswer } from "/Users/yanchenxin/dev/github.com/chenxin-yan/jev-slay-the-spire-2/src/jev.ts";

const fixture = "/Users/yanchenxin/dev/github.com/chenxin-yan/jev-slay-the-spire-2/docs/evidence/m2/generic-live/combat-ready.json";
const snapshot = parseSnapshot(JSON.parse(readFileSync(fixture, "utf8")));
if (!snapshot.legal_actions_complete || snapshot.waiting || snapshot.legal_actions.length < 2) throw new Error("fixture is not ready");
const started = Date.now();
try {
  const result = await makeJevDecider(gateway.evaluation(JEV_MODEL_ID))(
    contextOf(snapshot), snapshot.legal_actions, new AbortController().signal,
  );
  console.log(JSON.stringify({ ok: true, application_evaluations: 1, fixture,
    duration_ms: Date.now() - started, configured_model: JEV_MODEL_ID,
    label: result.label, probabilities: result.probabilities, confidence: result.confidence ?? null,
    usage: result.usage, warning_count: result.warnings.length,
  }));
} catch (error) {
  // Preserve only fixed diagnostic flags, never SDK payloads/headers or arbitrary error text.
  const message = String(error).toLowerCase();
  console.log(JSON.stringify({ ok: false, application_evaluations: 1,
    duration_ms: Date.now() - started, invalid_answer: isInvalidAnswer(error),
    diagnostics: {
      authentication: /authentication|unauthorized|api.key|credential|401/.test(message),
      payment: /payment|credit|balance|402/.test(message),
      probability: /probabilit|distribution/.test(message),
      deadline: /deadline|timeout|timed out/.test(message),
      policy: /forbidden|policy|403/.test(message),
    }, error_payload: "omitted",
  }));
  process.exitCode = 1;
}
