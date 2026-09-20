# Jev the Spire

One Bun process, running until victory, defeat, a technical failure, or Ctrl-C: observe the STS2MCP bridge → one joint Jev choice over the legal actions → validate freshness → one POST → re-observe. See `docs/minimal-demo.md` for scope.

## Repository layout

- `src/`, `test/`: Bun / Crust / Effect CLI and its offline checks.
- [`mod/STS2MCP/`](mod/STS2MCP/README.md): C# bridge source, license, build instructions and native checks.
- `docs/`: shared scope, research and preserved verification evidence.

The CLI and mod are versioned together. The old sibling mod checkout is a checkpoint backup,
not a second working copy. Native builds require locally installed game assemblies; those
binaries are never committed or downloaded by CI.

## Run (owner's Mac, game running with the modded profile 2 bridge)

```sh
mise install                            # Bun from package.json's packageManager; .NET from mise.toml
bun install
bun run src/main.ts                       # no action-count or total runtime cap
bun run src/main.ts --max-actions 3       # optional positive integer action bound
bun run src/main.ts --log logs/demo.jsonl --bridge http://127.0.0.1:15526/api/v1/singleplayer
```

`AI_GATEWAY_API_KEY` must be set in the environment (Bun auto-loads `.env`; only `@ai-sdk/gateway` reads it). The CLI is one Crust root command (`@crustjs/core`) whose action is an Effect program (`@crustjs/effect` `handler`). Flags are parsed strictly by Crust: unknown flags, positionals, anything after `--`, a missing value or a non-positive/non-safe-integer `--max-actions` (string flag with a local validator) print `Error: …` and exit 1 before any log or network I/O. There is no `--help` (no help extension installed); this file is the usage. Ctrl-C stops the loop and prevents any further POST. There is no default action limit or whole-run deadline. Only an explicit `--max-actions N` limits the action count; per-request, inference and readiness timeouts still stop technical failures.

Exit status (Crust's native contract): 0 on `terminal` or `max_actions`; 130 on Ctrl-C (the aborted summary is still logged and printed, then the Effect is interrupted, which Crust reports silently); 1 on `halted` (`Error: <outcome>: <halt_reason>` on stderr after the summary) and on bad arguments. Crust supplies no process signal: `src/main.ts` owns the SIGINT listener and releases it before Crust cleanup.

## Behavior

- Ready = `legal_actions_complete && !waiting && legal_actions.length > 0`. Otherwise poll every 500 ms for up to 30 s, then halt `wait_timeout`. `mutation_pending` alone never blocks (owned child decisions are actionable); a version change alone is not completion.
- ≥2 legal actions: one Effect `Decision.classify` over label→description, answered by `typesafe-ai/jev` through `ai.experimental_evaluate` on the Vercel AI Gateway. The top label is dispatched. Context is the current snapshot minus bridge bookkeeping (`legal_actions`, `legal_actions_complete`, `state_version`, `mutation_pending`); no history, no host scoring/pruning.
- 1 legal action: dispatched directly without a model call, logged `source: "singleton_only"` (owner decision, see `docs/minimal-demo.md`). No model id/distribution/tokens are invented.
- Before every POST the state is re-observed; a changed `state_version` discards the choice and goes back through observation. Unknown label, missing/invalid distribution or unexpected model id → one re-ask, then halt. Snapshot + questions over 64k / 32k JSON chars → halt, never truncate.
- One model call must finish within 60 s or the loop halts (`inference deadline`). GET retries ≤3 on network/429/5xx; `Retry-After` (delta-seconds or HTTP-date) is honored up to 10 s, beyond that the loop halts instead of waiting. POST is sent once; a timeout/network error/abort mid-flight halts as `dispatch_uncertain`. Non-202 halts. `halt_reason`, `terminal` and unsupported states halt/stop cleanly with a summary; no auto-resume.
- Every record is appended synchronously to the JSONL log before the POST; a log write failure prevents dispatch.

## Log (JSONL)

Record types: `wait`, `inference` (application attempt, latency, model id, response id, usage, warnings — `model_calls` counts application attempts, not the SDK's underlying HTTP retries; `model_id` is the requested SDK identity echoed by the Gateway adapter, not server attestation), `stale`, `decision` (version, state type, act/floor, full legal action list, source, label, probabilities, confidence, model id), `dispatch` (status, body or `uncertain`), `summary` (outcome, halt reason, dispatched/model_calls/forced counts, seed, act/floor, tokens when reported, wall time). No headers or credentials are logged. Cost is not reported by the evaluate API and is not invented.

## Dependencies (pinned)

`effect@4.0.0-rc.116` (`effect/unstable/ai` Decision/DecisionModel), `ai@7.0.107` (`experimental_evaluate`), `@ai-sdk/gateway@4.0.87` (`gateway.evaluation("typesafe-ai/jev")`), `@crustjs/core@0.3.3` + `@crustjs/effect@0.1.0` (CLI boundary; peer `effect ^4.0.0-rc.115`). Dev: `typescript@7.0.2` (Crust's optional peer `^7`), `@types/bun@1.4.2`. The Bun runtime version is pinned only in `package.json`'s `packageManager` field. `mise.toml` enables Bun's idiomatic version-file discovery so local development and CI read that same pin.

## Checks

```sh
bun run check       # lint, formatting, typecheck, then tests (read-only)
bun run lint:fix    # apply safe lint fixes
bun run fmt         # format supported files
```

Individual checks: `bun run lint`, `bun run fmt:check`, `bun run typecheck`, `bun run test`. Tests use fake transport/fixtures only; they never contact the game or the Gateway.

[Oxlint](https://oxc.rs/docs/guide/usage/linter/quickstart.html) uses correctness rules and [type-aware linting](https://oxc.rs/docs/guide/usage/linter/type-aware.html) via `oxlint-tsgolint`. Warnings and unused suppressions fail the check. The existing TypeScript compiler remains the typecheck gate; experimental Oxlint type checking is not enabled.

[Oxfmt](https://oxc.rs/docs/guide/usage/formatter/quickstart.html) uses its defaults (100 columns, two spaces, double quotes, semicolons). Both tools respect Git ignores and exclude downloaded `.agent-sources/` and captured `docs/evidence/` artifacts. Oxfmt also preserves the imported `mod/STS2MCP/UPSTREAM.md` archive unchanged. Configuration lives in `.oxlintrc.json` and `.oxfmtrc.json`; tool versions are pinned in `package.json` and `bun.lock`.

VS Code/Cursor users: install the recommended [Oxc extension](https://marketplace.visualstudio.com/items?itemName=oxc.oxc-vscode). Workspace settings enable formatting on save and safe lint fixes on explicit save; type-aware linting comes from the shared config. Other editors can use the [official editor setup](https://oxc.rs/docs/guide/usage/linter/editors.html).

GitHub Actions runs `bun run check` on pull requests and pushes to `main`, using mise to read the Bun version from `package.json`'s `packageManager`, a frozen lockfile, SHA-pinned actions, and read-only repository permissions. No credentials or game installation are needed. Git hooks are not installed; CI enforces the checks without another dependency.

`test/main.test.ts` spawns the real CLI against a local fake bridge. It verifies play beyond ten actions without a flag, explicit action limits, terminal/error exits and Ctrl-C. A test-only preload accelerates the former five-minute timer if it is reintroduced, catching an unintended whole-run deadline without a five-minute test.

## Limits

Unlimited default runtime does not imply exhaustive bridge coverage. Safety bounds remain: 30 s ready-wait, 60 s per inference and 10 s max server backoff; an optional action count is set with `--max-actions`. Ctrl-C is reported in the summary `halt_reason`. Request-size limits are enforced in JSON characters (not UTF-8 bytes; live provider units unverified). `confidence` is not part of the evaluate answer and is logged as absent. `202` is acceptance, not completion of the last action; the summary at `max_actions` reflects the last pre-dispatch observation. Halts leave the game where it is; restart the CLI manually after fixing the cause.
