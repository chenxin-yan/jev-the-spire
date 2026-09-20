# Independent minimal CLI safety-repair review

## Verdict

**PASS for the scoped app repairs, offline only.** A1/A2's original independent failures now pass unchanged; A3's finite inference/backoff/whole-demo controls are present and independently exercised. No new blocking app defect found. **Actual provider/Godot integration remains unverified; no installation, game control, new hook or live-demo authority is granted.**

No repository edits, native rebuild, game/provider requests, UI/install/control, save/profile/settings access, credentials/`.env` access, environment dump, staging/commit/publication, or delegated workers. Only scratch evidence and this report were written. Required CLI subprocess tests used local fake bridges; SDK tests used explicit fake keys/transports. Every Bun invocation included `--no-env-file`; validation processes received only PATH and a fake Gateway key (some repository CLI tests intentionally remove that key).

## Verified behavior

- **A1:** strict argument parsing rejects missing/invalid action bounds, unknown flags and positionals before bridge/log I/O. Original missing-value regression is green, not rewritten.
- **A2:** present malformed `waiting`, `halt_reason`, `seed`, `visible_text` and dereferenced `run` fields fail closed. **53 actual public generic-live snapshot fixtures** parse unchanged, including waiting, event, map, combat and reward observations. This is deliberately not a full gameplay schema.
- **Inference:** an unanswered fake SDK fetch receives the deadline abort; a separate 503 with `Retry-After: 120` is interrupted during SDK backoff. Both halt with the inference-deadline reason, not invalid-answer re-asks. Production default remains 60 seconds; focused checks inject 30 ms.
- **Read backoff:** numeric and HTTP-date parsing checked; future date over the 10-second allowance halts after one GET. Both pending-backoff cancellation and the already-aborted-before-sleep race stop without retry.
- **Whole demo:** real unchanged `src/main.ts` exercised against endlessly changing fake snapshots. A scratch preload changes **only its 300000-ms timer delay to 100 ms**. Actual CLI exits 1 with `demo_deadline`, zero inference and zero POSTs. This verifies timer wiring/cancellation, **not an elapsed five-minute endurance run**. The repository stale-loop check also passes.
- **Abort boundaries:** real HTTP transport cancellation at readiness and freshness sends zero POSTs; abort during an already-received POST logs uncertainty and never replays it. A freshness function deliberately returning after abort still sends zero requests through the real POST transport. The original real-CLI SIGINT check remains green. Cancellation does not undo a mutation already accepted by the server.
- **Retained behavior/logging:** unchanged original tests cover complete/non-waiting readiness, pending-parent child decisions, full legal choices, singleton-to-multiple freshness, one invalid-output re-ask, missing-distribution refusal, mutation uncertainty/rejection without retries, synchronous pre-dispatch logging, and forced/model action accounting. Singleton logs invent no identity/distribution/tokens. Requested Gateway identity and application-attempt `model_calls` are now accurately documented; SDK transport retries are separate.

## Commands and actual results

Working directory: `/Users/yanchenxin/dev/github.com/chenxin-yan/jev-slay-the-spire-2`. Scratch: `/tmp/jev-minimal-cli-repairs-review/` (`S` below). Exact argument arrays/exits: `S/commands.json`; complete outputs retained.

| Command | Exit | Actual result |
|---|---:|---|
| `bun --no-env-file test` | 0 | 43 pass, 0 fail, 163 assertions (`app-test.log`) |
| `bun --no-env-file node_modules/typescript/bin/tsc --noEmit` | 0 | Clean (`typecheck.log`, empty) |
| `bun --no-env-file test /tmp/jev-minimal-demo-review/independent.test.ts` | 0 | 9 pass, 0 fail, 57 assertions (`independent.log`) |
| `bun --no-env-file test /tmp/jev-minimal-cli-repairs-review/retained/test` | 0 | Original 30 tests byte-identical, against current source: 30 pass, 0 fail, 113 assertions (`retained.log`) |
| `bun --no-env-file test /tmp/jev-minimal-cli-repairs-review/targeted.test.ts` — first run | 1 | 9 pass, 1 scratch-harness failure: wrong Bun preload argument order printed usage and exited 0, so CLI deadline assertion failed (`targeted.log.first`, `whole-demo.stdout.first`) |
| Same targeted command after one scratch-only argument-order correction | 0 | 10 pass, 0 fail, 88 assertions (`targeted.log`) |

Full failure output and usage were read before the single harness correction; no application fixes attempted. Corrected internal CLI command: `bun --no-env-file run --preload=/tmp/jev-minimal-cli-repairs-review/deadline-preload.ts <repo>/src/main.ts --bridge http://127.0.0.1:<ephemeral-port> --log /tmp/jev-minimal-cli-repairs-review/whole-demo.jsonl --max-actions 3` → expected exit 1. Stdout/stderr retained. Original independent test's historical title claiming “no deadline signal” is stale: its unchanged assertions verify short pending wait plus explicit abort, **not absence of the newly added deadline**.

Original independent file SHA256 remains `ecde46f7a9ba96b01430db2a62272ecc4991fb4676b7c5030f7650d287f0d766`. Its preexisting scratch CLI logs were backed up and restored, preserving earlier evidence.

## Source inventory and preservation

Read all four `src/{main,bridge,jev,loop}.ts`, all four `test/{main,bridge,jev,loop}.test.ts`, `AGENTS.md`, `docs/minimal-demo.md`, `README.md`, `package.json`, initial review and both supplied new reports. Explicit inventory hashes additionally cover `bun.lock`, `tsconfig.json`, `CONTEXT.md`, `mise.toml`; `inventory-before.json` and `inventory-after.json` are identical. **12/12 available writer-freeze app files match** (`freeze-comparison.json`); retained original tests match byte-for-byte (`retained-comparison.json`). Fixture names: `fixtures.json`.

Installed API semantics checked in `node_modules/ai/dist/index.js` (evaluation validation, retry/abort forwarding), `@ai-sdk/gateway/dist/index.js` (evaluation transport and configured identity), `@ai-sdk/provider-utils/dist/index.js` (abortable retry delay), and `effect/dist/unstable/ai/DecisionModel.js` (complete finite distributions, 1e-6 sum tolerance). No dependency/toolchain change requested.

Protected hashes remain:
- `CONTEXT.md`: `0b90a7e6f3825158ab4d15458b216148c5a7c5c46c70e345864fef051088e3b7`
- `mise.toml`: `9193ec101cad14715bb4679c0c3e6acaf5a5e16702ed876e81d52c0d6a76daad`

`git -C <app> diff --cached --name-only` and `git -C ../STS2MCP diff --cached --name-only` both exit 0, empty (`app-staged.log`, `native-staged.log`). Installed DLL and live checkpoint were not accessed or changed; no fresh byte-verification claim about either or `.env` is made.

## Native report: authority recommendation, not approval

No broad native audit/rebuild repeated. Spot-checked supplied `proceed.il`, `map-open.il`, `tweenhelper.il`, `progress-ftue.il`, `callers.log`, plus current `McpMod.EventActions.cs` and relevant shared-helper callers. `Open(false)`, detached animation, the later `InitMapPrompt` seen-FTUE guard, and synchronous `Opened` after travelability recalculation are supported. Current admission still refuses at `McpMod.EventActions.cs:161` and completion still uses the guard at `:252`.

The new evidence supports **asking the owner for the narrow ActOpening/finished-Proceed exception**, with existing exact root/signal/identity receipts and entry-time seen-FTUE prerequisite retained, rather than authorizing a new animation hook. Do not treat `_hasPlayedAnimation`, null tween, or `Opened` alone as descendant completion. The no-FTUE-descendant argument remains conditional on the flag not being reset by foreign settings input; the owner must explicitly accept/control that residual. A hook, should one prove necessary, remains unapproved. Shared ordinary guards, later-act/boss authority and the existing checkpoint must not be broadened by implication.

## Remaining real risks

Gateway/Jev availability and complete/unrounded probabilities remain unverified; safe refusal is intentional. Identity is SDK configuration, not server attestation; size limits are JSON characters, not UTF-8 bytes. Timers depend on a responsive event loop and abort-respecting installed transports, not an external watchdog. `202` and `max_actions` summarize acceptance, not completion of the final native action. Initial-map Proceed remains blocked in current native code; Godot signal/AsyncLocal behavior and a continuous autonomous opening→gameplay path remain unproven.
