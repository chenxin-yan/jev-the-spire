# Treasure Skip ownership halt — diagnosis and repair (2026-09-21)

Parent-corrected report. The original worker report is preserved verbatim in `implementation-original.md`; initial review is `initial-review.md`. Corrections below address the exception, cancellation-token, dispatch-acceptance, and historical-coverage statements, not production behavior.

Worktree: `/Users/yanchenxin/dev/github.com/chenxin-yan/jev-slay-the-spire-2` @ `b2046f2` (main), dirty. Parent readiness baseline (`/tmp/jev-treasure-skip-2026-09-21/baseline.diff`) verified byte-identical before work and preserved in the final diff.
Native: sts2.dll v0.111.0 `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4` (re-hashed; `implementation/sts2-dll.sha256`).
Artifacts: `/tmp/jev-treasure-skip-2026-09-21/implementation/` (all logs, exits, IL dumps, final diff, candidate DLL). No commit/push/install/live/game interaction. Supervisor decision obtained before implementing (contract approved with adjustments; all adjustments applied below).

## Confirmed root cause (native IL, not inferred)

Live halt `treasure_proceed_identity_unverified` at `:298` is the *first* `Fail` on the operation (`Failure ??=`), raised from the `catch` in `RewardProceedPrefix` (McpMod.RewardHooks.cs:186–211). Inside that `try`, `RequireTreasureIdentity(op)` → `TreasureOperation.Check()` threw `treasure_gameplay_receipt_missing` because the exact `PickRelicAction`'s work had already completed successfully with `AwardsEntered == false`.

Why the pick was already complete, and why no awards ever came (all inside the single `ForceClick(ProceedButton)`):

| step | native site (IL dump) | fact |
|---|---|---|
| 1 | `NTreasureRoom.OnProceedButtonPressed` (`native-ntreasureroom.il` 0006–0068) | `IsSkip` → `SkipRelicLocally` → **then** `Players.Count==1` → `SetTravelEnabled(true)` → `ProceedFromTerminalRewardsScreen()` |
| 2 | `TreasureRoomRelicSynchronizer.SkipRelicLocally/PickRelicLocally(null)` (`native-synchronizer.il`) | builds `PickRelicAction(localPlayer, null)` → `ActionQueueSynchronizer.RequestEnqueue` |
| 3 | `RequestEnqueue` / `EnqueueAction` (`native-queue-synchronizer.il`) | `NetGameType.Singleplayer=1` → local `EnqueueAction` → `ActionQueueSet.EnqueueWithoutSynchronizing` |
| 4 | `EnqueueWithoutSynchronizing` (`native-queueset-enqueue.il` 0170–0188) | invokes `ActionEnqueued` synchronously (mod `Enqueued` → `BindPick`) then queue add → `ActionQueueChanged`. A 202 establishes dispatch acceptance, not gameplay completion; the preserved first failure distinguishes the later proceed invariant from an earlier pick-receipt failure |
| 5 | `ActionExecutor.ActionQueueChanged` → `ExecuteActions` (`native-actionqueuechanged.il`, `native-executeactions.il`, `native-waitforunpause.il`) | not running → `ExecuteActions` runs synchronously: `WaitForUnpause` completes (no AutoSlayer/TestMode), `BeforeActionExecuted` (mod `Executing=true`), `CurrentlyRunningAction=pick`, `pick.Execute()`; only *after* that does it `await ToSignal(ProcessFrame)` |
| 6 | `PickRelicAction.ExecuteAction` (`native-pickrelicaction.il`) | `synchronizer.OnPicked(_player, _relicIndex)`; returns `Task.CompletedTask` |
| 7 | **`TreasureRoomRelicSynchronizer.OnPicked`** (`native-synchronizer.il` 0333–0368) | `if (!index.HasValue && _playerCollection.Players.Count == 1) { _singleplayerSkipped = true; return; }` — **no vote, no `VotesChanged`, no `AwardRelics`, no `RelicsAwarded`** (the indexed/multiplayer branch at 0369+ records the vote and calls `AwardRelics` when all votes are in) |
| 8 | `GameAction.Execute` (`gameaction-execute.il` 0459–0586) | `_executionTask` (RunSafely→LogTaskExceptions, sync for a completed task) complete → `State=Finished` → `JustBeforeFinished` → `_completionSource.TrySetResult()` → `AfterFinished` (mod `Finished` → `Executing=false`). Entire action lifecycle finished synchronously. |
| 9 | `NTreasureRoomRelicCollection` (`native-callers.log`, `native-animaterelicawards.il`) | `_relicPickingBeganTaskCompletionSource.SetResult` (IL 117) and `…Complete….SetResult` (IL 2264) exist **only** in `AnimateRelicAwards`, which is reached **only** via `RelicsAwarded` → `OnRelicsAwarded`. Never raised in step 7. |
| 10 | `NTreasureRoom.OpenChest` (`native-openchest.il` 0486–0517) | `_hasChestBeenOpened=true; await RelicPickingBegan()` (state 2) — the mod's `Root` is parked here permanently for a singleplayer skip. Later `TreasureRoom.Exit → OnRoomExited → EndRelicVoting` only nulls `_currentRelics` and resets `_singleplayerSkipped`; nothing completes the TCS. |
| 11 | `RunManager.ProceedFromTerminalRewardsScreen` prefix | first `Check()` after step 8 → `PickWork().IsCompletedSuccessfully && !AwardsEntered` → throw → `Fail("treasure_proceed_identity_unverified")` |

Eliminated premises (with evidence): map pre-opened (`treasure_room.tscn` has no `[connection]`; `OnProceedButtonReleased` is only reachable through `InvokeGodotClassMethod` — `pck-treasure-scan.log`, `native-callers.log`); Pick unbound / receipt failure (would have produced `treasure_pick_receipt_unverified` first or no 202); Skip-token cancellation (OpenChest creates a separate local `cancelSource`, passes its token to EnableSkip, and reaches `CancelAsync` only after picking begins; this lane never reaches that point. The room `_cts` is a different cancellation source); `IsTravelEnabled` (native `SetTravelEnabled(true)` precedes the hooked call; `Hook.ShouldProceedToNextMapPoint` default true).

The claim lane keeps the invariant: `OnPicked(index)` → `AwardRelics` → `RelicsAwarded` → `AnimateRelicAwards` (prefix `BeginAwards`) synchronously inside `Execute`, before any `Check()`. Only the singleplayer-null-index lane diverges, and it was never modeled. Without a model, even removing the throw leaves `GameplayDone`/`Poll`/`BridgeSession.Track(() => op.Root)` waiting on `Root`/`Awards`/`Finished` that natively never complete → permanent `waiting`.

## Change (approved contract, supervisor adjustments applied)

`mod/STS2MCP/TreasureOperation.cs`
- `LocalSkip` receipt flag (native comment cites OnPicked/AnimateRelicAwards/OpenChest/EndRelicVoting).
- `Check()` = `CheckTasks()` (unchanged failure/closed/faulted/cancelled/skip-cancel checks) + lane invariant: non-lane keeps the exact old `treasure_gameplay_receipt_missing` rule; `LocalSkip` refuses `AwardsEntered || ObtainEntered || Awards/Obtain bound || Began/Finished completed || Root completed` as `treasure_local_skip_contract_violated` (a successfully completed root in this lane contradicts the native model → latched refusal, not a hang).
- `BeginLocalSkip(action)`: `CheckTasks()` then requires exact `Pick` identity, `Index == null`, no awards/obtain, `Began/Finished` incomplete, `Root` bound and still pending, `Skip` succeeded, token not cancelled, `PickWork()` completed successfully, not already admitted. No generic bypass flag; this is the only path that skips the awards invariant, and only because it *is* the awards-substitute receipt (adjustment 1).
- `Primary => LocalSkip ? PickWork() : Root` — Root is never dropped: `CheckTasks` still faults/cancels on it and the lane invariant refuses its completion through Proceed+map (adjustment 4).
- `BeginAwards`/`BeginOffer` refuse under `LocalSkip` (no new capability; `BeginObtain` already requires `AwardsEntered`).
- `GameplayDone()` lane branch: pick work + Skip success + offers/children done (Root/Awards/Finished/Obtain are non-lane).
- Parent readiness hunk in `RoomReady()` untouched.

`mod/STS2MCP/McpMod.TreasureActions.cs`
- `RequireTreasureIdentity` = `op.Check()` + new boolean `TreasureIdentityCurrent(op)` (same predicates, same `treasure_identity_changed`). The receipt path uses the predicate only, so admission does not route through the invariant it resolves.
- `TreasureRelicsCurrent(current, relics)`: ordered `ReferenceEquals` of relic models (now shared by `AddTreasureActions` and the receipt; adjustment 2 — no copied-array reference equality, no id equality).
- `TreasureSkipReceipt(op, skipped)`: canonical `RunManager.Instance.TreasureRoomRelicSynchronizer` with `_playerCollection == op.Run`, `_localPlayerId == player.NetId`, relics still current (proves `EndRelicVoting` has not run → current-room provenance), and `_singleplayerSkipped == skipped`.
- `DispatchTreasurePick`: Skip pre-click requires `TreasureSkipReceipt(op, false)` (`treasure_skip_state_unverified`), so a stale historic `true` never authorizes the lane. The exact pick's `AfterFinished` handler (`Finished`) — for `index == null` only — requires `pick.State == Finished` and `TreasureSkipReceipt(op, true)` then `op.BeginLocalSkip(pick)`; any failure latches `treasure_local_skip_receipt_unverified`. Post-click receipt check adds `picking && index == null && !op.LocalSkip` → `treasure_choice_receipt_missing`. Ordering validated from `gameaction-execute.il`: `_executionTask` complete → `TrySetResult` (0567) → `AfterFinished` (0586) (adjustment 3).
- `DispatchTreasureOpen`: `Track(..., () => op.Primary, ...)`.
- Claim / unopened-proceed / extra-reward / RewardHooks flows: no code change.

`mod/STS2MCP/tests/check-bridge.sh` (+88 checks; parent's 13 readiness checks intact)
- 17-lane regression on the real `TreasureOperation` + real `BridgeSession.Track/HoldUntil/Refresh` with a parked root: `release` (no release before exact Proceed, then before map receipt; releases afterward; root still pending; owner closed), `no_receipt`, `pending_pick`, `pick_fault`, `foreign_receipt`, `indexed_receipt`, `late_receipt`, `duplicate_receipt`, `awards_after`, `offer_after`, `root_fault`, `root_cancel`, `root_complete`, `skip_cancel`, `proceed_fault`, `proceed_cancel`, `child_pending` (adjustment 5).
- Native IL pins (metadata only): `OnPicked` stores `_singleplayerSkipped` after the `Players.Count` test with `ldc.i4.1; stfld; ret` and before `AwardRelics`; exactly 3 synchronizer methods touch the flag; `SkipRelicLocally→PickRelicLocally`; `PickRelicAction.ExecuteAction→OnPicked`; `OnRoomExited→EndRelicVoting` (which writes the flag); `AnimateRelicAwards` is the only `TaskCompletionSource.SetResult` site in the collection; `OpenChest` awaits `RelicPickingBegan`; `Execute` orders `TrySetResult` before `AfterFinished`.
- Production wiring pins: the compiled `<DispatchTreasurePick>g__Finished|` closure calls `BeginLocalSkip`, `TreasureSkipReceipt`, `GameAction.get_State`; `TreasureSkipReceipt` uses `TreasureIdentityCurrent` + `TreasureRelicsCurrent`, never `Check`/`RequireTreasureIdentity`; `RequireTreasureIdentity` still calls `Check`; `DispatchTreasurePick` reads `LocalSkip` and calls `TreasureSkipReceipt`; `DispatchTreasureOpen` closure calls `get_Primary`; `AddTreasureActions` uses the shared relic predicate.

## RED / GREEN / mutations (all logs + exits in `implementation/`)

| run | DLL | exit | result |
|---|---|---|---|
| `check-baseline` | parent readiness candidate `e63469e5…` | 0 | 2844 checks (baseline intact) |
| `check-red` (regression added, production unchanged) | `e63469e5…` | 134 | `production Check accepts the receipted singleplayer skip whose pick finished with no awards (live treasure_gameplay_receipt_missing)` — reproduces the live gate |
| `check-red-final-test` (final test text vs `/tmp/jev-treasure-readiness-2026-09-21/readiness-candidate.dll`) | `e63469e5…` | 134 | same assertion |
| `build-green` / `check-green` | fixed | 0 / 0 | 0 warnings; 2932 checks |
| mutation M1 `check-mutation-check-guard`: `Check()` lane branch removed (old invariant unconditional) | mutant | 134 | same RED assertion |
| mutation M2 `check-mutation-unwired-callback`: `Finished` sets `op.LocalSkip = true` directly, no receipt/`BeginLocalSkip` | mutant | 134 | wiring pin fails |
| mutation M3 `check-mutation-track-root`: `Track(() => op.Root)` | mutant | 134 | wiring pin fails |
| `build-final` / `check-final` (sources restored, verified identical to GREEN copies) | `fcde9f67a79e3ea68bdb8c5170bc8b04deef4f2d5e92b894a51f0528806487a0` | 0 / 0 | 0 warnings; 2932 checks |
| `bun --no-env-file test` / `lint` / `fmt:check` / `typecheck` | — | 0/0/0/0 | 57 tests, 210 asserts |

`git diff --check` clean. Final diff: `implementation/final.diff` (3 files, +214/−12). Candidate DLL copy: `implementation/skip-candidate.dll` (not installed).

Exact build/check commands used are the ones from the task (Release, `STS2GameDir`, `ImportDirectoryBuildProps/Targets=false`; `check-bridge.sh <mod dll> <sts2.dll>`).

## Remaining uncertainty / risks

- Offline fixtures never execute Godot/Harmony: the live delivery of `AfterFinished` before the hooked `ProceedFromTerminalRewardsScreen` prefix is established from IL (`ExecuteActions`/`Execute`/`EnqueueWithoutSynchronizing`) and the observed 202+3 ms halt, not from a runtime fixture (prior callback fixture exit 139 remains unexplained; not attempted).
- `OnPicked` is called synchronously before `ExecuteAction` returns its task, and before `RunSafely` is invoked. `LogTaskExceptions` also rethrows/sets its returned task's exception. The native `_singleplayerSkipped` false→true receipt proves the exact Skip branch was taken; it is not compensation for swallowed exceptions.
- After the lane releases, the human closing the map back onto the room hits the existing `treasure_empty_or_reopened_unverified` refusal (pre-existing behaviour for reopened rooms; native leaves the Skip button visible with the parked OpenChest).
- No corrected-candidate live acceptance exists yet. The old installed build did complete a claim and subsequent leave/map return in autonomous run 4, but that claim used the defective temporary singleton catalog rather than Jev inference. Targeted QA records an accepted Skip followed by the old ownership halt. This repair changes the Skip lane and shared identity/relic predicates, alongside the preserved parent readiness fix.

## Proposed bounded live validation (parent-owned; never the failed run)

Fresh legal run, Profile 2, reach a treasure room: `open_treasure` → wait until `claim_treasure_relic:0` and `proceed` (Skip) appear together with `legal_actions_complete=true` → dispatch `proceed` once → expect 202, then `state_type=map` with `mutation_pending=false` (no `waiting`, no halt), then a normal `choose_map_node`. Negative expectation preserved: if the room shows any relic-award animation or `halt_reason ∈ {treasure_local_skip_receipt_unverified, treasure_local_skip_contract_violated, treasure_skip_state_unverified}`, stop and report. Separately (another chest), validate the claim lane still completes (`claim_treasure_relic:0` → relic obtained → `proceed` "Leave treasure room" → map).
