# Minimal playable demo — original approved scope

The owner has since made the CLI action limit opt-in and removed the whole-run deadline. See the [README](../README.md#run-owners-mac-game-running-with-the-modded-profile-2-bridge) for current usage. Budgets and checkpoint statements below describe the original demo, not the current CLI defaults.

The owner confirmed that the three starting choices mean **Ancient/Neow choices at each act opening**, and selected **Build the minimal demo** rather than finish broad bridge coverage first.

## Priority

1. Support the shared Ancient opening interaction, including the initial Neow entry, without an event-name allowlist. Do not confuse existing option/dialogue support with ownership of a newly started or resumed room.
2. Connect Jev to the existing bridge through one bounded Bun CLI. Reuse Effect v4 `Decision`/`DecisionModel` and the already selected `ai.experimental_evaluate` Gateway integration for `typesafe-ai/jev`.
3. Verify with focused fixtures, stop-control checks and a short parent-supervised live demo. No full autonomous M5 run is authorized.

Broader M2 coverage, unusual/custom interactions and exhaustive fixtures are deferred. M2 remains incomplete; its remaining coverage no longer blocks developing M3. Do not build a new framework, dashboard, scheduler, policy language or general recovery system.

## Current checkpoint

- The CLI and mod source are now colocated: [`../mod/STS2MCP`](../mod/STS2MCP/README.md) is the authoritative bridge copy. Local pre-move checkpoints preserve both repositories; original evidence paths remain historical. No mod behavior changed during the source import.
- Crust migration is implemented and [independently reviewed](evidence/m3/crust-neow-review.md): `@crustjs/core@0.3.3`, `@crustjs/effect@0.1.0`, Effect rc.116, project-local Bun 1.4.2 and TypeScript 7.0.2. The dotnet setting and loop/provider/transport are preserved. Parent rerun: 50 tests and typecheck exit 0; 43/43 reviewed source hashes match. Exit contract: success 0, errors/deadline 1, Ctrl-C 130. No help extension. See [implementation](evidence/m3/crust-implementation.md).
- Fresh initial Ancient entry plus the narrow finished-Neow Proceed exception is [implemented](evidence/m2/neow-proceed-implementation.md), offline-reviewed and independently rebuilt byte-identically: candidate `d627dc6d47771d90fe2a8341f88f36e05024944416a55a481a2d6db051eaa61c`, not installed. Independent current harness: 1909 checks; retained suites pass. Parent reran 93 retained checks with zero RED. The exception requires the owned fresh `ActOpening`, map tutorial already completed at admission and no tutorial reset during the demo. Exact task/signal/input checks remain; no new hook or broader act-transition support. [Native analysis](evidence/m2/initial-map-completion.md) corrects the original report to `Open(false)`.
- Procedure exception: the app writer reported Bun 1.4.2 `install` loading `.env` despite `--no-env-file`, and bypassed the package minimum-release-age delay once without separate approval. No credential values were reported, but no-access compliance cannot be claimed. Do not repeat installs in the protected root or bypass package-age checks without approval; the flag behavior belongs upstream in Bun, not a local monkey patch. This exception does not invalidate the offline code tests.
- No real Jev inference, new live demo, game-mod installation or checkpoint reset has occurred. Transient map visibility/potion whole-set behavior is not live-certified by the offline empty-map test.

## Retained essentials

- Modded profile 2 only; original profile 1 remains off-limits.
- Jev selects from the full current legal set. No host strategist, pruning, search or hidden future outcomes; context is the current public snapshot, not decision history.
- **Singleton legal sets (owner decision, supersedes the #6 "singleton still asks Jev" rule):** a current complete, non-waiting legal set with exactly one action is executed directly without a model call, because `effect@4.0.0-rc.116` `Decision.classify` rejects fewer than two labels. The log records `source: "singleton_only"` with no invented model id, distribution, confidence or tokens; forced actions count toward the demo bound and are reported separately from model calls. Freshness, uncertainty and kill-switch checks still apply; if the legal set or version changes before dispatch the loop returns to normal observation/decision logic.
- Native input/ownership/task safeguards stay. A changed state version alone does not prove completion; waiting/incomplete observations are not model decisions. Supported owned child decisions may be actionable while their parent remains pending.
- Validate Jev's label and freshness before one POST. Never retry uncertain mutations. Stop clearly on unsupported states, errors or bounded timeout; Ctrl-C must prevent further dispatch.
- Record decisions, model identity/distribution/confidence, dispatch results, timing and usage. Demonstrate a working path rather than claiming every event or act transition works.
- No credential values read/printed by agents. Preserve `.env`, `CONTEXT.md`, the approved `mise.toml` tool pins and existing evidence. Child work performs no inference, game-mod installation or game requests/control. Package/toolchain operations require explicit scope and must not load protected credentials.

The opening-entry work may use a narrowly proven extension of the existing authorized SetupLayout observation. New interception targets, arbitrary adoption of preexisting/restored events, or broader selector authority still require a precise approval request. If a required lifecycle receipt is missing, report that small blocker rather than rebuilding the bridge.

Current live checkpoint is the previously documented diagnostic floor-3 map, not a Jev-owned run. Human setup actions from that run remain excluded from autonomous evidence. See [generic live diagnostic](evidence/m2/generic-live/README.md) and [approved generic-event contract](research/generalized-events.md).
