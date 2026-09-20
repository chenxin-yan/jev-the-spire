# Morphic Grove halt and battle-reward audit

## Identity and reproduction

- Installed reviewed DLL: `f16fd24269faac9ffdeca7c0566d9bc9aa088284f5b55bc96e981620dcdf11ef`.
- Native v0.111 assembly: `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`.
- User log: `run-2026-09-20T21-39-37-380Z.jsonl`; screenshot preserved as `user.png`.
- Read-only GET reproduced `shared_event_unverified` at epoch `0c940da5f3624b0586ed753feeb3074c:102`, pending, no legal actions.
- `python3 /tmp/jev-morphic-2026-09-20/check-live-halt.py` exited 1 on the exact unsupported-event assertion. The game was not advanced. No fix is installed, so this assertion remains red.

## Confirmed cause

`MorphicGrove.get_IsShared` is constant true (`ldc.i4.1; ret`), including singleplayer. `BridgeProtocol.RequireEventPolicy` explicitly rejects that flag; both `EventInputsReady` and `RequireEventOption` use it, and per-option synchronizer identity independently rejects `sync.IsShared`. The guard originates in commit `4f62de6d`, predates the installed update, and was not changed by `1288b01`. This is a missing bridge capability, not evidence of an upstream game bug or regression in the new-run/enchant patch.

Native shared choices follow `ChooseLocalOption -> PlayerVotedForSharedOptionIndex -> ChooseSharedEventOption -> ChooseOptionForSharedEvent -> ChooseOptionForEvent -> EventOption.Chosen -> _pendingOptionTasks.Add`. That path tracks page-indexed votes, rejects client authority, and dispatches for each player. Supporting it safely needs proof of a sole local player, exact synchronizer/page/model ownership and original task capture; removing the two shared guards alone is not a verified implementation. Reuse the native path, not a Morphic Grove name exception. The approved ordinary-event scope explicitly excluded shared voting (see `docs/research/generalized-events.md`). Scope expansion is presented for approval before implementation.

Ranked alternatives considered: intentional shared-event refusal (confirmed); wrong model classification/binding (not needed to explain the failure; native Morphic Grove itself is shared); new-build regression (the relevant guard predates the update and is unchanged).

Metadata probe correction: initial ApiProbe calls with unqualified type names failed with TypeLoadException/exit 134. Reading ApiProbe's exact-type contract and supplying fully qualified native names succeeded; no game code was executed by these metadata probes.

## Rewards

`python3 /tmp/jev-morphic-2026-09-20/audit-rewards.py` exited 0. All reward decisions were matched to exactly one accepted dispatch and the next map decision; full recorded legal alternatives were retained.

| Floor | Offered | Jev chose | Result |
|---|---|---|---|
| 2 | 10 gold, Strength Potion, card reward | Proceed, probability 0.35 | All unclaimed; matching 202, then map |
| 3 | 10 gold, card reward | Proceed, probability 0.40 | All unclaimed; matching 202, then map |

There were zero claim_reward dispatches in this run. This skipped 20 gold, one potion and two card-selection opportunities. It is not evidence of a failed claim action: no such action was requested. The source forwards the provider's chosen label; multi-choice rewards do not use singleton bypass. `Leave rewards` invokes native Proceed, which opens the map rather than calling reward GetReward. Native evidence from the prior audit is reusable because the installed native assembly hash is unchanged (`docs/evidence/run-boundary-2026-09-20/rewards/{rewards-proceed,terminal-proceed-body}.il`).

Screenshot shows 249 gold, 10-card deck and empty potion slots, consistent with the audit. Exact historical inventory deltas cannot be independently checked because the JSONL stores legal actions, selected labels and dispatch receipts rather than full player snapshots. Model reasoning and exact historical request payloads are not logged. Terse reward wording might contribute, but that cause is not established. Optional neutral wording improvement: explicitly describe Proceed as skipping all remaining unclaimed rewards. Do not auto-claim, hide Proceed or impose strategy.

## Boundaries

No source changes, builds, provider calls, game clicks, restarts, installations, save/settings changes or gameplay occurred. Source tree remains clean. Only bounded read-only bridge observations were made; this is investigation, not permission to resume monitoring or runs. Current log remains a technical stop after 33 dispatches (25 model calls, 8 singleton actions), not a completed run.
