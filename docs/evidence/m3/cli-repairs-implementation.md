# Minimal CLI repairs (A1/A2/A3) — report

Repo `/Users/yanchenxin/dev/github.com/chenxin-yan/jev-slay-the-spire-2`, sole app writer. Nothing staged/committed. `CONTEXT.md` `0b90a7e6…88e3b7`, `mise.toml` `9193ec10…76aad` unchanged; `.env` untouched. No game HTTP, inference, UI/install, save/profile access; every Bun invocation `--no-env-file`, fake transports only. Native repo not touched.

Freeze: `/tmp/jev-minimal-cli-repairs/` — `delta.patch` (472 lines vs `/tmp/jev-minimal-cli` freeze), full `src/`, `test/`, `package.json`, `bun.lock`, `tsconfig.json`, `README.md`, `test-output.txt`, `independent-output.txt`, `typecheck-output.txt`, `commands.txt`, `exits.txt`, `SHA256SUMS`.

## Changed paths

- `src/main.ts` — A1: `node:util.parseArgs` strict (`allowPositionals:false`), `--max-actions` must be a positive **safe** integer (`""`, missing value, `=0`, `1.5`, `-2`, `2^53+1`, unknown flag, positional → stderr usage + exit 2 before `mkdirSync`/network). **Interim** parser only — owner's Crust direction noted; no migration (Bun ≥1.4 / TS7 toolchain decision pending parent). Also one total demo deadline: `setTimeout(5 min)` aborting the shared controller with `Error("demo_deadline")`, cleared after `runLoop`; SIGINT aborts with `Error("SIGINT")`.
- `src/bridge.ts` — A2: `parseSnapshot` now rejects wrongly typed **present** optional fields consumed by the loop/summary: `waiting` boolean, `halt_reason`/`seed`/`visible_text` string, `run` non-null object with numeric `act`/`floor` (`run: null` rejected). No full game schema. A3: `retryAfterMs()` parses delta-seconds **or HTTP-date** (RFC 9110); delay > 10 s halts with an explicit error instead of waiting. Fix: `sleep` rejects immediately if the signal is already aborted.
- `src/jev.ts` — A3: `makeJevDecider(model, deadlineMs = INFERENCE_DEADLINE_MS /*60 s*/)`; own `AbortController` + `setTimeout`, composed via `AbortSignal.any([signal, fiberSignal, deadline.signal])`, timer cleared in `finally`; if the deadline fired, the deadline `Error` is rethrown (the SDK's retry backoff otherwise reports only "Delay was aborted"). Comment records that `modelId` is the requested SDK identity echoed by the Gateway adapter, not server attestation.
- `src/loop.ts` — `signal.throwIfAborted()` at the top of each iteration; abort outcomes now carry `halt_reason` = abort reason (`SIGINT` / `demo_deadline`), including the late-inference and dispatch-uncertain paths; `sleep` already-aborted fix. Singleton forced path, freshness-to-multiple, single invalid-output re-ask, missing-probabilities refusal, mutation_pending child readiness, never-retry POST all unchanged and still covered.
- `test/main.test.ts` (new, 8) — real CLI spawned against a local fake terminal bridge: 7 rejection cases assert exit 2, 0 GETs, no log file; one accepted run exits 0 with `summary.outcome=terminal`.
- `test/bridge.test.ts` (+3) — Retry-After over budget halts after one GET; past HTTP-date Retry-After retries promptly; typed optional-field rejection.
- `test/jev.test.ts` (+1) — never-answering provider cut off by a 30 ms deadline; error names the inference deadline; not treated as invalid output.
- `test/loop.test.ts` (+1, 1 updated) — abort reason reported; repeated ever-stale snapshots ended by an external `demo_deadline` abort (fixture observe now yields a macrotask like real transport — the earlier microtask-only fixture starved timers and hung the run; that was the >4 min bash the parent terminated).
- `README.md` — limits: strict interim flags, 60 s inference deadline, 10 s Retry-After cap, 5 min total deadline, `model_calls` = application attempts (not SDK HTTP retries), `model_id` = requested identity, chars-not-bytes size limits, `202` ≠ completion.

## Gate results

| Command | Exit | Result |
|---|---:|---|
| `bunx --no-env-file tsc --noEmit` | 0 | clean |
| `bun --no-env-file test` | 0 | **43 pass / 0 fail**, 163 assertions (was 30) |
| `bun --no-env-file test /tmp/jev-minimal-demo-review/independent.test.ts` (unchanged, sha256 `ecde46f7…d766`) | 0 | **9 pass / 0 fail** (was 7/2: A1 missing-value and A2 `waiting:"true"` now pass) |

Red-before evidence: new A2/A3 bridge tests and abort-reason loop test failed before the fixes (Retry-After test waited the full 120 s; `waiting:"true"` accepted; `halt_reason` absent); A1 was red in the independent test. All green after.

## Remaining live limits

- Gateway/Jev may omit or round `probabilities`; Effect requires a complete distribution summing to 1 within 1e-6 → re-ask once → halt. Not verifiable offline; nothing normalized or invented.
- `model_id` equality protects adapter/config mismatch only. `confidence` absent by API. No cost data.
- Size limits are JSON characters, not UTF-8 bytes; live provider units unverified.
- The 60 s inference deadline includes the SDK's two default transport retries; `model_calls` does not count those retries.
- Parser is interim (`parseArgs`); Crust migration awaits parent toolchain decision (Bun ≥1.4, TS7).
- Native N1 (Neow finished-page Proceed refused by start-of-act map guard) is untouched and remains the integration blocker; no live gate authorized here.
