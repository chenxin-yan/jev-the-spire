# Minimal Jev CLI — implementation report

Repo: `/Users/yanchenxin/dev/github.com/chenxin-yan/jev-slay-the-spire-2` (sole writer; nothing staged, no commits).
Freeze: `/tmp/jev-minimal-cli/` (src, test, package.json, bun.lock, tsconfig.json, .gitignore, README.md, docs/minimal-demo.md, test/typecheck/CLI outputs, exits.txt, commands.txt, bun-version.txt, SHA256SUMS). No .env/node_modules/secrets.

## Files added / changed

- `package.json` — pinned `effect@4.0.0-rc.116`, `ai@7.0.107`, `@ai-sdk/gateway@4.0.87`; dev `typescript@5.9.3`, `@types/bun@1.4.2`. Scripts `test`/`typecheck` use `--no-env-file`.
- `bun.lock`, `tsconfig.json`, `.gitignore` (`.env`, `.env.*`, `node_modules/`, `logs/`, `dist/`, `*.log`).
- `src/bridge.ts` — Snapshot/LegalAction types + `parseSnapshot` (required fields, string label/description, duplicate-label rejection); `observe` GET with ≤3 attempts on network/429/5xx honoring `Retry-After`, no retry on 4xx/malformed; `dispatch` POST `{state_version,label}` sent exactly once, never retried; both use `AbortSignal.any([signal, timeout 10s])`.
- `src/jev.ts` — `makeJevDecider(model)`: `Decision.make({ input: Schema.Json, decisions: { action: Decision.classify({ instructions, criteria: label→description }) } })` answered via `DecisionModel.make({ decide })` whose `decide` calls `ai.experimental_evaluate({ model, state, questions:{action:{type:"choice",…}} })` on the Gateway evaluation model. Maps `answer.choice/probabilities` → `{_tag:"Classify", label, probabilities}` (missing probabilities → `{}` → DecisionModel InvalidOutputError; nothing invented). Validates `response.modelId === "typesafe-ai/jev"`. Enforces 64k total / 32k state+longest-question JSON-char limits before any request (halt, no truncation). `isInvalidAnswer` = AiError with `InvalidOutputError` reason (AI SDK `InvalidResponseDataError` is mapped to it).
- `src/loop.ts` — `runLoop(deps)` with injected `observe/dispatch/decide/log/print/signal/maxActions/waitMs/pollMs`. Ready = complete && !waiting && actions>0 (mutation_pending ignored). Bounded poll (500 ms / 30 s default) → `wait_timeout`. `terminal`/`halt_reason` stop with summary. ≥2 actions → one Jev classify (one re-ask on invalid answer, then halt). 1 action → forced `singleton_only` without inference (owner decision B). Abort check after inference, then freshness re-GET; version change → `stale` record and back to observation. `decision` record logged synchronously before POST; POST error → `dispatch_uncertain` halt (aborted if signal aborted). Summary counts `dispatched`, `model_calls`, `forced`, seed/act/floor/tokens when present.
- `src/main.ts` — args `--max-actions N` (default 10, positive integer), `--log`, `--bridge`; SIGINT → abort; JSONL via `appendFileSync`; exit 0 terminal/max_actions, 1 halt/abort, 2 bad args. Uses `gateway.evaluation("typesafe-ai/jev")` (reads `AI_GATEWAY_API_KEY` itself).
- `test/loop.test.ts` (17), `test/jev.test.ts` (6), `test/bridge.test.ts` (7).
- `README.md` (new), `docs/minimal-demo.md` (added owner singleton decision paragraph under Retained essentials).

Protected files unchanged: `CONTEXT.md` `0b90a7e6…88e3b7`, `mise.toml` `9193ec10…76aad`. `.env` never read.

## Owner decision applied mid-run

Singleton legal set: execute directly, no Jev/Decision.classify (Effect `Decision.js:33` two-label guard), logged `source:"singleton_only"`, no model fields invented, counted toward the action bound, distinguished (`forced` vs `model_calls`) in summary; if version/legal set changes before dispatch the loop re-observes and, with ≥2 actions, asks Jev. Recorded in `docs/minimal-demo.md` and README.

## Validation

- `bun --no-env-file test` → 30 pass / 0 fail (113 expects). Fixtures: waiting→ready→terminal; singleton no inference + provenance; singleton→multiple freshness; stale between inference and POST; owned child pending but ready; invalid answer re-ask once / second halts; non-answer failure no re-ask; unsupported halt; wait_timeout; dispatch timeout never retried; 409 halt; abort during pending inference → no POST; abort while waiting; log failure blocks POST; action bound with forced+model. Provider mapping through real `@ai-sdk/gateway` + real `ai.evaluate` over a fake fetch (request URL/headers/body and answer mapping; unknown label; missing probabilities; malformed body; oversize; abort). Bridge transport through a local `Bun.serve` fake (no origin/sec-fetch headers, retry/no-retry, exact POST body, 409 passthrough, parseSnapshot).
- `bunx --no-env-file tsc --noEmit` → clean.
- `bun --no-env-file run src/main.ts --max-actions 0` → exit 2, no network, no log dir created.
- No game HTTP, no Gateway calls, no inference, no installs beyond the pinned packages.

## API references (installed sources read)

- `node_modules/effect/dist/unstable/ai/Decision.js` (classify guard), `DecisionModel.js` (probabilities required, sum 1e-6, confidence optional), `AiError.d.ts` (`make`, `InvalidOutputError`, `UnknownError`, `InvalidUserInputError`).
- `node_modules/ai/dist/index.js` `evaluate` (maxRetries default 2, argmax + distribution validation, `response.modelId` fallback to model.modelId), `index.d.ts` `EvaluationResult`.
- `node_modules/@ai-sdk/gateway/dist/index.js` `GatewayEvaluationModel.doEvaluate` (POST `${baseURL}/evaluation-model`, headers `ai-model-id`, `ai-evaluation-model-specification-version: 4`), `index.d.ts` `GatewayProviderSettings` (`AI_GATEWAY_API_KEY` default, `fetch` seam).
- Bridge: `/tmp/jev-m2-generic-events/source/McpMod.Contract.cs` (`DispatchLabel` 202/409/422, `FinishObservation`), `BridgeProtocol.cs` (`CheckRequest` 403 on origin/fetch-metadata, 415 on non-JSON, `ParseAction` exact two string fields), evidence `combat-ready.json`, `event-ready.json`, `event-complete.json`, `map-after-combat.json`, `final-map.json`, `*-immediate.json`.

## Known limits / risks

- Live Gateway behavior for `typesafe-ai/jev` is unverified here (no inference allowed): if it omits `probabilities`, every decision fails validation → re-ask → halt. Surfaced with a clear diagnostic, not worked around.
- `confidence` is not part of the evaluate answer; logged `null`. Cost not available; not reported.
- Request-size limits enforced in JSON characters (the cached contract does not name units); conservative.
- `AI_GATEWAY_API_KEY` is loaded by the Gateway SDK at request time; the owner's live run should use plain `bun run src/main.ts` (Bun auto-loads `.env`) or export the variable.
- Halts do not resume; the CLI must be restarted manually. Rewards/shop/other families depend on the bridge's existing label enumeration; the CLI hardcodes no action family.
