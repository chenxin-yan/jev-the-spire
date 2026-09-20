# M2 live recheck — menu/reward fixes pass; combat-to-event handoff blocked

2026-09-20 UTC. Controlled parent diagnostics, **modded profile 2 only**, seed `F8AG9S4KZ3GG`. No Jev inference, autonomous run, or M4/M5 credit. **M2 remains open and blocked.**

## Checkpoint

- Installed DLL: `71ebec737f466c87800262475c94024a70c61dd3bb496229f2386ed5b2dac8bd` from `/tmp/jev-m2-live-readiness/release/STS2_MCP.dll`.
- Native game: v0.111.0 / `41cef1ea`; assembly SHA256 `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`.
- Bounded independent source/managed review: PASS, byte-identical rebuild, 1553 supplied + 50 independent checks; retained 16/60/1266-check suites pass. These are not native-scene acceptance. Reports: [implementation](../live-readiness-implementation.md), [review](../live-readiness-review.md).
- Parent byte-compared 19 candidate source files and 28 build inputs before installation and again after these live tests; all match the frozen checkpoint. No source changes during live testing. `git diff --check` exit 0; protected app hashes unchanged.
- Previous installed M2 `dff158c2…be34ed` backed up under `/tmp/jev-m2-live-recheck/previous-install/`. Original accepted M1 remains backed up under `/tmp/jev-m2-live/m1-backup/`. Only the mod DLL was replaced after confirming the previous process/listener exited. Normal quit again returned AppleEvent -128 despite actual process exit; no force kill.
- Loader/listener and Profile 2/modded UI confirmed (`loader-excerpt.log`, `listener.txt`, `profile2-menu.png`).

## Resume boundary and explicit one-off UI permission

Resume reconstructed the floor-1 pre-claim reward screen, rather than the map left before restart: native UI showed 68 HP, 99 gold, deck 10. `resumed-get.json` correctly refused it as `unowned_selection_continuation`, with no actions. Original task/selector ownership is not adopted after restart.

The parent stopped and asked. The user explicitly selected **“Allow one-off UI cleanup”**: reclaim the same gold and Setup Strike on disposable profile 2, then return to bridge-only testing. Four native UI clicks claimed 19 gold, opened the card choice, selected the visibly matching Setup Strike, and proceeded to map. `map-before-move.json` confirms 68 HP, 118 gold, deck 11.

**That cleanup is not bridge verification and is not permission for a general UI fallback.** It is separate from the 19 accepted diagnostic POSTs below. No tutorial acknowledgement, save edits, profile switching, or original-profile access occurred.

## Live results

| Test | Evidence | Result |
|---|---|---|
| Clean menu refusal | `menu-get.*` | `no_active_run`, no actions; no null-reference exception. Parent assertion passed. |
| Actual next map move | `map-move-1.*`, `map-move-settled.*` | One 202 POST choosing Monster `(1,1)`; immediate pending/incomplete/no actions, then floor-2 combat with matching native UI. Later map explicitly confirms current `(1,1)` and visited route. |
| Multi-target combat / self-target | `f2-*.json`, `multitarget-self-buff.png` | Three enemies with distinct IDs; targeted plays, Defend, temporary Strength and end turns produced matching effects. |
| Waiting-version rejection | `waiting-version.*` | HTTP 409 for an end-turn request using a pending/no-actions snapshot version. Response does not distinguish pending from stale, so this is not claimed as exhaustive concurrency proof. |
| Dead-target rejection | `dead-target.*` | HTTP 422; killed target absent from the current legal set. |
| Reward readiness — initial window | `f2-open-card-immediate.*` | Actual `card_reward`, all three card descriptions, `waiting:true`, `legal_actions_complete:false`, **zero actions**, `mutation_pending:true`. |
| Early Skip rejection | `early-skip.*` | HTTP 422 using that waiting snapshot's version. No reward consumed. |
| Reward readiness — input ready | `f2-card-ready.*`, `f2-card-ready.png` | Same card descriptions; all three takes + Skip, complete/non-waiting, fresh version; parent still pending. Assertions passed. |
| Waiting-era version after readiness | `stale-reward-wait.*` | HTTP 409. |
| Ready Skip / gold / proceed | `f2-skip-card-*`, `f2-claim-gold-*`, `f2-proceed-*` | Ready Skip accepted; card reward remains unclaimed in native reward list. Gold 118→130, deck remains 11. Proceed supplies owned map continuation while parent remains pending. |
| Map before Unknown | `f2-map-ready.*`, `f2-map-ready.png` | Current `(1,1)`, one visible Unknown destination `(0,2)`, complete legal label, retained parent. |
| Unknown entry / handoff | `enter-unknown.*`, `unknown-room.*`, `unknown-room.png` | One 202 travel POST, immediate waiting. UI visibly enters Byrdonis Nest on floor 3; subsequent bridge observation **halts `combat_loop_cancelled`**, pending, zero actions. Handoff not accepted. |

Exactly **19 accepted diagnostic POSTs**: 10 card plays, 3 end turns, 4 reward actions, 2 map choices. All explicitly selected by the parent, not a strategy loop. “Accepted” means HTTP 202—not that every operation completed successfully: the final handoff failed.

## Historical blocker and limits

**Superseded checkpoint:** the later [generic-event live diagnostic](../generic-live/README.md) resolves this combat-to-event handoff on a fresh owner-approved profile-2 run and verifies one ordinary event effect. The observations below preserve the original failure, not the current game state.

The game is stopped at **Byrdonis Nest**, floor 3, **57/80 HP, 130 gold, 11 cards**. Native options visibly offer Eat the Egg (+7 Max HP) or Take the Egg (add Byrdonis Egg). **Neither option was selected or submitted.** No further UI cleanup is authorized or attempted.

The bridge reports `combat_loop_cancelled` after leaving combat through an unclaimed-card reward map continuation. [Independent diagnosis](../combat-event-handoff-diagnosis.md) established a matching production-reachable false halt: normal owned movement exits the combat room, whose `Reset(true)` cancels the retained old turn loop; `CombatExitOperation.Check()` rejects it before processing travel receipts. Historical Task identities were not recorded in the live JSON, so this is native-path grounding rather than retrospective task telemetry. The parent independently reran the unchanged production-controller reproduction: 6 PASS / 2 RED, exit 1, reproducing the pending and completed owned-teardown false halts.

Repair workflow `9d75ca9b-af49-4dd1-8b10-cb698e44a92f` produced candidate `0d539f85…1c4b2c`, but [independent review](../owned-teardown-review.md) requires one late-cleanup correction. The original expected teardown reproduction now passes, yet returning to the menu or replacing the run after completed owned movement can leave the retained owner/observers waiting indefinitely. Parent reproduced the unchanged review driver: 91 checks / 2 RED, exit 1. This candidate is **not installed or accepted**. Follow-up workflow `d82ec1a7-d421-4b35-9585-b283966ff990` fixed run invalidation through existing scoped validation, with no new hooks/global cleanup changes. [Independent review](../late-run-invalidation-review.md): bounded source/managed **PASS**, 1809 supplied checks, unchanged independent driver 93 checks / 0 RED, six compiled-wiring checks, and byte-identical rebuild `3828de49ec906f8e22502452b7cf30d8f429df48e4e7e68fb8a8317640c6f67a`. Parent compared all 19 frozen source files and 28 build inputs to current source and reran the unchanged driver: exit 0 ([log](../late-cleanup-parent-after.log)). This repair is accepted offline only; not installed or live-verified.

The [Byrdonis Nest audit](../byrdonis-audit.md) is complete. The user requested generalized event handling rather than event-by-event hardcoding. Accordingly, bounded implementation workflow `d2763058-ac7d-4f5a-a301-a6f56a3e1c05` was stopped before independent review. Its partial changes to `BridgeProtocol.cs`, `McpMod.EventActions.cs` and `tests/check-bridge.sh` remain unaccepted/uninstalled and are preserved at `/tmp/jev-m2-byrdonis-paused/` with the delta against the accepted offline late-cleanup snapshot. No rollback or deletion occurred. Read-only research workflow `5b251d5d-ebdc-48b4-8ef7-094a3c0718a0` subsequently found the neutral-listener preflight unnecessarily restrictive for the native task contract. The owner approved generic current-decision support with a possible halt after an unsupported follow-up, even after an initial effect/cost. The [research and subsequent implementation/live results](../../../research/generalized-events.md) replace that per-event direction; these original captures are unchanged.

Even after resolving the handoff, Byrdonis Nest lies outside the current TinkerTime-only ordinary non-proceed event policy. **Unknown-room entry was observed, but event handoff and option execution are not verified.** Map travel has one successful ordinary combat destination; do not generalize it to every destination/continuation. Shop/rest/treasure/potion/death and broader event gates remain outstanding.

## Evidence integrity and verification limits

Original captures: `/tmp/jev-m2-live-recheck/`. This directory preserves sanitized HTTP bodies/headers, screenshots, manual diagnostic helper, installation hashes and loader excerpt. No mod/game binaries or raw account-bearing save/log data are included. `SHA256SUMS` covers captures, not this narrative.

All parent diagnostic scripts/curl calls shown in captures completed without transport failures. Menu/readiness/deck-state assertions passed. `action-once.py` refuses a reused request filename and never retries mutation; it performs a fresh observation, one explicitly named POST and one immediate GET. It is not the future Bun/Effect/Jev runner. Do not replay captures/scripts against another run.

No production tests or source builds were rerun by the parent during gameplay; the independently reviewed build was used unchanged. Managed checks do not prove native scene coverage. The review qualifies the implementation report's broad clickability-writer claim: generated Godot property/restoration writers also exist; the readiness reasoning is scoped to the inspected ordinary reward initialization path.

At this checkpoint `71ebec…` remained installed; the [later diagnostic](../generic-live/README.md) records its replacement and backup. M1 and previous-M2 rollback copies remain local. M3/M4 remain gated; M5 requires separate approval.
