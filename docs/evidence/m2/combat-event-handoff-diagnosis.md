# Combat → skipped reward → map → event handoff diagnosis

**Verdict: production-reachable false halt established. No implementation. Full M2 remains BLOCK.**

The retained old combat loop can legitimately become **Canceled during normal owned map travel**. `CombatExitOperation.Check()` rejects that unconditionally before inspecting the travel receipts. This explains the observed `combat_loop_cancelled` at floor 3; cancellation is not, by itself, evidence of failed travel or human intervention. Conversely, victory plus cancellation is not sufficient authority to accept it.

## Evidence and scope

Read-only analysis of frozen source and pinned native metadata; no native/Godot objects, game HTTP/UI, gameplay, deployment, protected files, repository changes or subagents. New probe/test files are only under `/tmp/jev-m2-handoff-diagnosis/` (R below), plus this report.

Fresh hashes (`R/hashes.log`) match supplied pins:

- Frozen release DLL: `71ebec737f466c87800262475c94024a70c61dd3bb496229f2386ed5b2dac8bd`.
- Installed `sts2.dll`: `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`.

Parent's live evidence remains the only live execution. `unknown-room.json` explicitly reports unsupported / `combat_loop_cancelled`, pending true, no actions. The native UI's Byrdonis Nest display does **not** prove all travel or destination tasks completed. Historical Task/token identities were not recorded in these JSON snapshots; this diagnosis establishes the matching native production path, not retrospective per-task telemetry.

## Exact production/native causal flow

1. The lethal **PlayCardAction** registers `CombatExitOperation` before execution, retaining the exact `_turnLoopTask`, run/room/combat/UI/player identities and post-action executor receipt. `joinLoop` is **false** for this action (`McpMod.RewardHooks.cs:39–86`), unlike end-turn actions. Its exact `CombatEnded(room)` marks Ended. Detached ShowRewards/Offer tasks and explicit claim children remain owned.
2. Native `EndCombatInternal` sets IsInProgress false, invokes CombatWon (which starts rewards), then CombatEnded. It does **not** cancel or wake the waiting end-turn signal. A loop already suspended awaiting that signal can remain pending after victory. `CanDecide()` deliberately permits that for non-end-turn actions.
3. Skipping the card leaves the card reward unclaimed. Terminal Proceed opens the map; it does not exit the combat room or finish the outstanding Offer. Native `ProceedFromTerminalRewardsScreen` opens map at IL0217 in the ordinary single-room branch (`/tmp/jev-m2-exit/proceed-body.il`). Production `Transition`/`Poll` transfers a map continuation while retaining the Offer.
4. `DispatchMap` consumes that exact continuation under the original owner, adds map work, and observes one exact vote → movement chain (`McpMod.NativeActions.cs:68–186`). It checks player/source/destination/generation; `QueuedActionChain.AddChild` requires the currently executing original vote as cause. Both original completion and execution tasks of both actions remain barriers. The destination's event setup is separately retained, not adopted as old reward work.
5. Native non-test movement awaits `NMapScreen.TravelToMapCoord` (MoveToMapCoordAction IL0268). Travel awaits `RunManager.EnterMapCoord` (IL1011), which routes to `EnterMapPointInternal`; that awaits **ExitCurrentRooms before entering the destination** (IL0122 versus later room-entry calls). See `R/travel.il`, `map-travel.il`, `map-entry.il`.
6. `ExitCurrentRoom` calls `RewardsSetSynchronizer.BeforeLeavingRoom` (IL0038), pops the old room (IL0050), then awaits its `Exit` (IL0072), and only afterward emits RoomExited (IL0171). BeforeLeavingRoom skips remaining rewards through `SkipRewardsSet`/`CompleteRewardsSet`, settling the native reward-set completion; this does not replace awaiting the original Offer and children. See `R/run-exit.il`, `reward-leave-complete.il`, and prior `reward-completion.il`.
7. **CombatRoom.Exit unconditionally calls CombatManager.Reset(true) at IL0006.** Reset retains the old turn state, nulls manager `_turnState` (IL0110), then calls that old state's Cancel (IL0208). It does not replace `_turnLoopTask` (`R/room.il`, `manager.il`).
8. `CombatTurnState.Cancel` clears both signal-source fields under ReadyLock, sets IsInProgress false, calls private `_cts.Cancel()` (IL0063), then **parameterless** TrySetCanceled on the retained end-turn and begin-enemy-turn sources (IL0072, IL0082). A loop suspended on the former receives OCE through AwaitTurnEndAndSwitchSides → StartCombatInternal → RunTurnLoopAfter. The latter explicitly logs “turn loop died of cancellation (combat torn down)” and **rethrows** (IL0506), so its original builder produces a canceled Task, not successful completion (`R/turnstate.il`, `turn-flow.il`, `manager.il`).
9. Production `Poll` starts with `Check`; lines 60–61 fault/reject the old loop before any map completion processing. `BridgeSession.Refresh` catches this and calls Fail, keeping pending true and running cleanup: old ownership closes and event movement fails/closes. Hence the event can visibly exist while the bridge has already irreversibly halted.

**Why previous checks missed it:** `tests/check-bridge.sh:865–925` uses joinLoop=true and calls `exitLoop.SetResult()` before reaching the map. It tests retained Offer/map work but not the native pending non-join loop that is canceled by old-room exit.

## Native cancellation authority—not an arbitrary CTS invariant

Fresh decoded-member scan (`R/references.log`) covered **50,815 bodies / 534,084 resolved operands / zero unresolved**:

- `_turnLoopTask` is written only by AfterCombatRoomLoaded, with the original RunTurnLoopAfter Task; RunSafely receives it afterward. The bridge retains the original, not that wrapper.
- CombatTurnState owns a private, separately allocated CTS. Its only field accesses are construction, Ct getter, IsLive getter and Cancel. No source escape, linking, timeout or second source writer was found. Ct exposes observation, not cancellation authority.
- **The only native call to CombatTurnState.Cancel is Reset.** Reset's three native callers are CombatRoom.Exit, RunManager.CleanUp and MockResetCombatOnShufflePower.AfterCardChangedPiles.
- Both turn signal sources are created by StartTurn. Their other native consumers are readiness setters (TrySetResult), AwaitTurnEndAndSwitchSides (await) and Cancel (TrySetCanceled). The source cancellation does not originate from card reward Skip.
- CleanUp is independently reachable from NRun notification, ReturnToMainMenu, GoToTimeline, continue-failure and debug file-drop paths. Room-exit callers also include enter-act, debug entry and ResumePreviousRoom. **These are not equivalent to authorized map movement.**

The bridge itself has no writer for the native loop/turn CTS; its request-queue cancellation is unrelated. Cancellation can also propagate from awaited work; an arbitrary OCE must not be classified as expected merely because Ended is true. The exhaustive reference scan proves direct source authority, not that every arbitrary content callback is incapable of throwing OCE.

Important constraint: **do not require the canceled loop's exception token to equal the turn CTS token.** Native TrySetCanceled is parameterless on the awaited signal sources. That proposed invariant would reject the legitimate path. Similarly, no callback-time/request-time temporal reconstruction is warranted. This is an ordered native lifecycle contract, not a general externally controlled CTS contract.

## Minimal repair boundary recommended for parent

Keep this in the existing combat-exit/map ownership controller and registration/dispatch wiring. **No new Harmony target appears necessary for this bounded path; none was added.** Do not simply delete the cancellation guard or use `Ended && Loop.IsCanceled`.

- Preserve strict loop-fault rejection everywhere and cancellation rejection before authorized movement. Preserve `joinLoop` readiness for end-turn victory; do not relax that unrelated lane.
- Arm a narrow teardown window only for the exact consumed parent map continuation and verified vote → movement, with the original run/room/combat/loop identities. Reuse existing action-execution/finish receipts and, if needed, scoped native RoomExited signal plus read-only original turn-state/token capture. Validate old-room identity before owned execution and same-run/exact destination after it. A queued vote, visible map or arbitrary room change is insufficient.
- **During expected teardown, cancellation means pending, not success.** Retain original loop identity, reject its faults, inspect every Offer/child/map task and sticky action-cancellation latch even when the loop is canceled. Await the exact movement completion/execution and destination setup/identity/readiness receipts. No timeout, idle heuristic or successful wrapper substitutes for them.
- **Final success** requires proven owned normal old-room exit plus all original required work and destination barriers succeeding, with the retained loop settled as success or the specifically authorized teardown cancellation. It must not release during the canceled-loop/pending-movement interval. Human exit/cleanup, wrong run/room/action/destination, failed entry, canceled map/Offer/child, or later faults must stay sticky and clean up normally.

Existing `AddMapWork` stores only a task provider and cancellation flag: it is not yet explicit proof of the reset cause or destination identity. Carry/check the necessary lifecycle evidence; do not treat `_roomTransition != null` alone as cancellation authority. If exact old-room provenance cannot be established through existing action/room signals and capture, **stop for parent approval of the precise additional target**, rather than weakening the requirement. This report does not certify a yet-unwritten no-hook implementation.

## Faithful production-controller red reproduction

`R/repro/Program.cs` loads the unchanged release DLL and runs actual **BridgeSession, CombatExitOperation, SelectionOwnership and QueuedActionChain**. Managed identity objects and original managed receipt tasks drive the same registration → reward screen → retained Offer → Proceed/map → owned vote/move sequence. The non-join loop awaits a signal that is canceled without a token, matching the native propagation above. No native method or Godot constructor is invoked.

`R/repro.log`: **6 PASS / 2 RED; exit 1**:

- RED owned-teardown-pending: expected pending without failure; actual `combat_loop_cancelled`, pending true, owner closed.
- RED owned-teardown-final: expected release after all successful owned receipts; actual same sticky halt.
- PASS normal successful loop, unowned cancellation rejection, map fault/cancel rejection, Offer fault rejection and delayed Offer retention. Failure remains sticky after later task completion.

These are production-controller tests driven by native-proven receipt ordering, **not live bridge verification** or a proof of yet-unimplemented provenance guards. They intentionally omit destination policy to isolate the old-combat defect.

Commands (offline; deployment imports disabled):

```sh
TMPDIR=/tmp/jev-m2-handoff-diagnosis mise exec -- dotnet build /tmp/jev-m2-handoff-diagnosis/metadata/Probe.csproj -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false
TMPDIR=/tmp/jev-m2-handoff-diagnosis mise exec -- dotnet /tmp/jev-m2-handoff-diagnosis/metadata/bin/Debug/net9.0/Probe.dll '/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2/SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64/sts2.dll'
TMPDIR=/tmp/jev-m2-handoff-diagnosis mise exec -- dotnet /tmp/jev-m1-safety-code/IlProbe.dll '/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2/SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64/sts2.dll' MegaCrit.Sts2.Core.Combat.CombatTurnState .ctor Cancel get_Ct get_IsLive
TMPDIR=/tmp/jev-m2-handoff-diagnosis mise exec -- dotnet build /tmp/jev-m2-handoff-diagnosis/repro/Repro.csproj -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false
TMPDIR=/tmp/jev-m2-handoff-diagnosis mise exec -- dotnet /tmp/jev-m2-handoff-diagnosis/repro/bin/Debug/net9.0/Repro.dll /tmp/jev-m2-live-readiness/release/STS2_MCP.dll
```

Metadata builds, successful API/IL probes, scan and hashes exited 0; repro build exited 0 with no warnings/errors; repro exited 1 as above. Two preliminary probe errors are not evidence: the first shell-variable invocation passed an empty assembly path (probe 134 / combined command 1); one guessed nonexistent `SkipAllRewards` method caused exit 134 after printing BeforeLeavingRoom. Corrected explicit-path/SkipRewardsSet probes exited 0; complete reward evidence is `reward-leave-complete.il`.

## Targeted next gates / separate event blocker

Regression additions should cover pending non-join loop teardown with delayed movement/Offer/destination setup; wrong/foreign/duplicate movement; early or unowned cancellation; loop fault; each original map/Offer/child task fault/cancel; sticky human cleanup; late receipts; owner/selector cleanup; successful loop control; unchanged end-turn joining. Include the native parameterless signal cancellation path, not only CTS-tagged canceled tasks.

Parent-only live gates after separately authorized repair/rebuild/review: zero-human-input lethal card and potion exits, take versus Skip/unclaimed reward, exact map continuation, delayed travel and event setup, fresh versions, no overlap, supported destination input, and normal cancellation/cleanup failures. Map display and destination display are not acceptance receipts. The prior UI cleanup is not bridge verification and cannot be reused as a fallback.

**ByrdonisNest is a separate unsupported event model.** `EventInputsReady` and `RequireEventOption` allow unfinished non-proceed gameplay only for TinkerTime (`McpMod.EventActions.cs:118–129,158–163`). Fixing old-loop handoff should not expose Eat Egg or Take Egg; the next legitimate halt may be `event_model_tasks_unverified`. ByrdonisNest needs separately audited option/model-task implementation. No scope expansion here; leave the current live game untouched. **Full M2 remains BLOCK.**
