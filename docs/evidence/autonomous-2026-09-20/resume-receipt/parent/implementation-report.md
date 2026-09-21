# Resume receipt repair — offline native diagnosis + implementation

Repo: `/Users/yanchenxin/dev/github.com/chenxin-yan/jev-slay-the-spire-2`, base HEAD `7b58630`, uncommitted working tree (nothing staged, no commit/install/live request).
Native: sts2.dll SHA `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4` (verified with `shasum`), read-only metadata/IL probes only, no game initialization.
Scratch artifacts: `/tmp/jev-autonomous-2026-09-20/resume-receipt/implementation/` (IL logs, callers, build/check logs+exits, per-mutation diffs/logs, `final.diff`, `candidate.sha256`).

## 1. Native lifecycle proof (managed IL of the pinned sts2.dll — not live Godot/Harmony proof)

Probes: `/tmp/jev-rest-repair-2026-09-20/{api.sh,il.sh,callers.sh}`; logs `il-executor.log`, `il-gameaction.log`, `il-gameaction-enqueue.log`, `il-queueset.log`, `callers.log`, `api-*.log`.

`MegaCrit.Sts2.Core.Entities.Actions.GameActionState`: None=0, WaitingForExecution=1, Executing=2, GatheringPlayerChoice=3, ReadyToResumeExecuting=4, Finished=5, Canceled=6.

`ActionExecutor+<ExecuteActions>d__28.MoveNext` (one invocation = one batch):
- IL 0018–0035 (initial state only): `_queueTaskCompletionSource = new TaskCompletionSource<bool>()`, `_actionCancelToken = new CTS()`.
- Loop: `readyAction = _actionQueueSet.GetReadyAction()`; `await WaitForUnpause()`; state 6 → skip; log "Executing action: "; **IL 0266–0283 `BeforeActionExecuted?.Invoke(readyAction)`**; `CurrentlyRunningAction = readyAction`; `actionTask = readyAction.Execute()`; per-ProcessFrame poll until `actionTask.IsCompleted || _actionCancelToken.IsCancellationRequested`; IL 0738–0896: if `CombatManager.IsInProgress` and action is not `EndPlayerTurnAction`/`ReadyToBeginEnemyTurnAction` → `await CheckWinCondition()`; IL 0902–1073: state==5 → "Completed execution of action", else → **"Paused execution of action … (state is …), attempting to find new action"**; remove JustBeforeFinished/AfterFinished; `GetReadyAction()` again.
- After loop IL 1152–1165: `_queueTaskCompletionSource?.SetResult(true)`. OperationCanceledException → `SetException(InvalidOperationException("ActionExecutor.ExecuteActions should never be canceled!"))`; other exception → `SetException` + rethrow.

`ActionExecutor.FinishedExecutingActions()`: `_queueTaskCompletionSource?.Task ?? Task.CompletedTask` — the receipt is per batch.
`ActionExecutor.get_IsRunning`: `_queueTaskCompletionSource.Task` exists and `!IsCompleted`.
`ActionExecutor.ActionQueueChanged()`: `if (!IsRunning) RunSafely(ExecuteActions())` — sole caller of `ExecuteActions` (`callers.log`), so a new `_queueTaskCompletionSource` is created only after the prior batch task completed.

`GameAction+<Execute>d__45.MoveNext`: `_pauseForPlayerChoiceTaskSource = new`; state 1 → State=Executing, `BeforeExecuted`, `_executionTask = RunSafely(ExecuteAction())`; state 4 → State=Executing, `_executeAfterResumptionTaskSource.SetResult()`; else throw "Attempted to execute GameAction … from invalid state …! Expected WaitingForExecution or ReadyToResumeExecuting". Then `await TaskHelper.WhenAny(_executionTask, _pauseForPlayerChoiceTaskSource.Task)`: execution finished → Finished(5), JustBeforeFinished, `_completionSource.TrySetResult()`, AfterFinished; otherwise log " paused execution" and **Execute() returns successfully with the action in GatheringPlayerChoice(3)**.
`GameAction.PauseForPlayerChoice` (requires Executing): `_executeAfterResumptionTaskSource = new`, `BeforePausedForPlayerChoice`, State=3, `_pauseForPlayerChoiceTaskSource.SetResult()`. Callers: `GameActionPlayerChoiceContext.SignalPlayerChoiceBegun`, `HookPlayerChoiceContext.SignalPlayerChoiceBegun` via `ActionQueueSet.PauseActionForPlayerChoice`.
`GameAction.ResumeAfterGatheringPlayerChoice(newId)` (requires 3): sets new `Id`, `BeforeReadyToResumeAfterPlayerChoice`, State=4.
`GameAction.OnEnqueued`: State=1, registers `PopAction` on AfterFinished. `GameAction.CompletionTask` = `_completionSource.Task`; `Cancel` → deferred `TrySetCanceled`.

`ActionQueueSet.GetReadyAction` IL 0643–0758: front action in state 3 → "… is waiting for player choice" → that queue yields nothing; only states 1 or 4 are handed to the executor; anything else throws "is in invalid state".
`ActionQueueSet.ResumeActionWithoutSynchronizing(id)` (caller `ActionQueueSynchronizer.ResumeActionAfterPlayerChoice`): `TryGetAction` + state 3 → `ResumeAfterGatheringPlayerChoice(newId)` then `ActionQueueChanged?.Invoke()`.

### Resulting lifecycle for the halt (Headbutt → NCombatPileCardSelectScreen → select_card Taunt)
1. Batch A (`ExecuteActions`, TCS A): `BeforeActionExecuted(Headbutt)` with State=1 → bridge binds receipt A. `Execute()` runs; Headbutt's pile selection calls `PauseForPlayerChoice` → `Execute()` returns (State 3). Executor awaits `CheckWinCondition()`, logs "Paused execution…", `GetReadyAction` skips the paused front action → loop ends → **TCS A.SetResult(true)**: receipt A completes successfully while the action is still paused. (Session stays pending because `action.CompletionTask`/`_executionTask` are incomplete — existing `BridgeSession.PrimarySucceeded`.)
2. Selection accepted → `ResumeActionAfterPlayerChoice` → State=4 → `ActionQueueChanged` → `!IsRunning` → **new ExecuteActions, new TCS B** → `GetReadyAction` returns Headbutt (state 4) → **`BeforeActionExecuted(Headbutt)` fires a second time** with `FinishedExecutingActions()` = TCS B.Task → `Execute()` from state 4 releases `_executeAfterResumptionTaskSource` → action finishes → `CheckWinCondition` → TCS B completes.
3. d0e2944 `CombatExitOperation.BindExecutionReceipt` rejected the second receipt (`_executionReceipt != null`) → `Fail("duplicate_or_late_execution_receipt")` → sticky halt at `:225`. Parent hypothesis confirmed by IL. Variant also proven: if the resume lands while batch A is still running (e.g. inside its `CheckWinCondition` await), the same loop picks the action up again and `FinishedExecutingActions()` returns the **same** TCS A task.

Native contract the repair relies on: at `BeforeActionExecuted` the exact action's State is 1 for its first pass and 4 for every resumed pass; a resumed pass's batch task is either identical to the previous pass's batch task or the previous batch task has already completed; every pass ends with the batch's `CheckWinCondition`.

## 2. Change (scope: exactly the three approved files)

`mod/STS2MCP/CombatExitOperation.cs`
- `_executionReceipt` → `List<Task> _executionReceipts` (one per native pass).
- `RequireExecutionReceipt()` blocks on the first pass's batch until bound (unchanged semantics).
- `BindExecutionReceipt(object source, Task task, bool resumedAfterPlayerChoice)`:
  - foreign `source` ignored (unchanged);
  - `Closed`, or a non-resumed second receipt, or a resumed receipt after `Ended` → `Fail("duplicate_or_late_execution_receipt")` (kept reason);
  - resumed receipt without a prior pass, or whose previous batch is neither the identical Task nor `IsCompletedSuccessfully` (pending/faulted/cancelled) → `Fail("unproven_execution_resume_receipt")`; earlier faulted/cancelled batches remain in `_work` as evidence;
  - identical still-running batch → accepted as one batch (no duplicate work);
  - new completed-previous batch → `AddTask(task, true)` (blocking receipt) and recorded.
- No blanket ignoring, no overwriting, no Task interception, no card/potion special cases, first-pass semantics unchanged.

`mod/STS2MCP/McpMod.RewardHooks.cs` `RegisterCombatExit.Executing`: for the exact registered action, State must be `WaitingForExecution` or `ReadyToResumeExecuting` (the only phases `GetReadyAction` hands over) else `Fail("execution_receipt_phase_unverified")`; binds `executor.FinishedExecutingActions()` with `resumed = State == ReadyToResumeExecuting`. Ownership still by `ReferenceEquals(source, action)` only.

`mod/STS2MCP/tests/check-bridge.sh`
- Receipt block (~line 918): `BindReceipt` helper invokes the 3-arg binding, falling back to the prior 2-arg binding so the resume scenario is behavioral against old DLLs (repo precedent for "prior DLL" checks). Scenarios: foreign ignored; first batch pending/complete; resumed pass in new batch not a failure and remains blocking; same still-running batch accepted once; foreign resumed action ignored; duplicate first-pass receipt still refused. Actual `BridgeSession` readiness: completed first batch cannot release a paused action; finished action still waits for the resumed batch; then releases without failure. Negative loop: `resume-without-pass`, `resume-during-other-batch`, `resume-after-first-fault`, `resume-after-first-cancel` → `unproven_execution_resume_receipt`; `resume-after-ended`, `resume-after-close`, `second-first-pass` → `duplicate_or_late_execution_receipt`; `resumed-batch-fault`/`resumed-batch-cancel` → work fault/cancel halt with `Failure == null` (evidence retained); later completion cannot heal.
- Teardown scenario loop: first-pass bind now passes `false`.
- Native pins (~line 1988, metadata/IL only): `GameActionState` values; `ExecuteActions` state machine references `BeforeActionExecuted`, `_queueTaskCompletionSource`, `GetReadyAction`, `GameAction.Execute`, `CheckWinCondition`, "Paused execution of action "; `FinishedExecutingActions`/`ActionQueueChanged` shape; `GameAction.Execute` resumption/pause sources and messages; `GetReadyAction` " is waiting for player choice"; `ResumeActionWithoutSynchronizing` → `ResumeAfterGatheringPlayerChoice` + `ActionQueueChanged`; compiled `RegisterCombatExit` closure calls `BindExecutionReceipt`, `FinishedExecutingActions`, `GameAction.get_State`.

## 3. Commands and exits

Build: `mise exec -- dotnet build mod/STS2MCP/STS2_MCP.csproj -c Release -p:STS2GameDir="/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2" -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false` (csproj derives `data_sts2_macos_arm64` from `STS2GameDir` on macOS — pass the install dir, not the data dir).
Check: `mise exec -- bash mod/STS2MCP/tests/check-bridge.sh mod/STS2MCP/bin/Release/net9.0/STS2_MCP.dll "<…>/data_sts2_macos_arm64/sts2.dll"`.

| phase | build | check | notes |
|---|---|---|---|
| baseline (HEAD source) | 0, 0 warnings | 0, `PASS: 2770` | DLL `c1a85482…735c1ee` |
| RED (tests only, baseline DLL) | — | **134**: `owned action resuming after its own player choice is a second native pass, not a duplicate or late receipt` | behavioral: old 2-arg binding halted the resumed pass |
| GREEN | 0, 0 warnings | 0, `PASS: 2830` | DLL `64ffe78e…9792d` |
| mutation `ignore-duplicate` (drop non-resumed duplicate Fail) | 0 | 134 `duplicate receipt cannot replace native task identity` | restored |
| mutation `accept-any-resume` (drop previous-batch proof) | 0 | 134 `resume-during-other-batch: … actual none` | restored |
| mutation `drop-resumed-batch` (no AddTask) | 0 | 134 `resumed pass's batch … remains a blocking receipt` | restored |
| mutation `ignore-ended` | 0 | 134 `resume-after-ended: … actual none` | restored |
| mutation `hooks-first-pass-only` (RewardHooks always `false`, no phase read) | 0 | 134 `compiled RegisterCombatExit binds each pass's … native phase` | restored |
| final (restored sources) | 0, 0 warnings | 0, `PASS: 2830` | candidate DLL SHA `64ffe78e81c3f88fd840fbb3a31699fb604e9594355b775269748b68b7a9792d` (identical to GREEN) |

App gates (`mise exec -- bun --no-env-file …`): `test` exit 0 (57 pass, 0 fail, 210 expect); `run lint` 0; `run fmt:check` 0; `run typecheck` 0.
`git diff --cached --quiet` → no staged files. `git status`: only the three approved files modified. Source restore verified by SHA (`source-green.sha256`), `final.diff` saved.

## 4. Boundary contract (after change)

Per owned combat mutation (card/potion/end-turn): one blocking batch receipt per native executor pass over the exact `GameAction` instance. First pass must arrive with State=WaitingForExecution; each further pass must arrive with State=ReadyToResumeExecuting and its batch must be the identical running batch or follow a successfully completed previous batch; passes after `Ended`/`Closed`, non-resumed duplicates, foreign actions (ignored), and unproven/ambiguous resumes never bind. Completion still requires the action's own `CompletionTask`/`_executionTask`/visual (BridgeSession) plus every bound batch (`CheckWinCondition` after the final pass). Failure evidence is additive (`Fail` is `??=`; faulted batches stay in `_work`). No session/run reset, no selection guard relaxation.

## 5. Limits / remaining live acceptance

- Proof is managed IL of the pinned DLL; the live Godot/Harmony ordering (BeforeActionExecuted on the resumed frame, `select_card` continuation lease still current) is not proven offline. Live acceptance: fresh native run replaying a pausing card (Headbutt/pile select) → selection accepted → action finishes → no `duplicate_or_late_execution_receipt`, `check-halt.py` style readback exits 0.
- A mutation that keeps the `State` read but passes a constant `false` is not caught offline (IL pins can't see the bool); live resume acceptance covers it.
- `Ended` is only a late-guard for resumed passes; first-pass semantics intentionally unchanged.
- Test helper keeps a 2-arg fallback for prior DLLs (repo precedent); can be dropped when the installed bridge is superseded.
- Multi-pause actions (several player choices in one action) follow the same per-pass rule; not separately live-tested.

Changed files: `mod/STS2MCP/CombatExitOperation.cs`, `mod/STS2MCP/McpMod.RewardHooks.cs`, `mod/STS2MCP/tests/check-bridge.sh`. Nothing committed, installed, or sent to the game.
