using System;
using System.Reflection;
using System.Threading.Tasks;
using MegaCrit.Sts2.Core.Combat;
using MegaCrit.Sts2.Core.Context;
using MegaCrit.Sts2.Core.GameActions;
using MegaCrit.Sts2.Core.Entities.Actions;
using MegaCrit.Sts2.Core.Nodes.CommonUi;
using MegaCrit.Sts2.Core.Nodes.GodotExtensions;
using MegaCrit.Sts2.Core.Nodes.Rewards;
using System.Linq;
using MegaCrit.Sts2.Core.Nodes.Combat;
using MegaCrit.Sts2.Core.Nodes.Rooms;
using MegaCrit.Sts2.Core.Nodes.Screens;
using MegaCrit.Sts2.Core.Nodes.Screens.Map;
using MegaCrit.Sts2.Core.Rewards;
using MegaCrit.Sts2.Core.Rooms;
using MegaCrit.Sts2.Core.Runs;

namespace STS2_MCP;

public static partial class McpMod
{
    private static CombatExitOperation? _combatExit;
    private static readonly SelectionOwnership RewardScopes = new();
    private sealed record RewardScope(CombatExitOperation Operation, object? Screen, bool AllowProceed);
    private sealed class RewardCapture(CombatExitOperation? operation, int kind, object? screen, object? map,
        IDisposable context, IDisposable selection, EventOperation? eventOperation = null, IDisposable? eventContext = null, TreasureOperation? treasure = null) : IDisposable
    {
        internal readonly CombatExitOperation? Operation = operation;
        internal readonly EventOperation? Event = eventOperation;
        internal readonly TreasureOperation? Treasure = treasure;
        internal readonly int Kind = kind;
        internal readonly object? Screen = screen, Map = map;
        public void Dispose() { try { eventContext?.Dispose(); context.Dispose(); } finally { selection.Dispose(); } }
    }

    // Local version-pinned shim. Remove when native actions expose owned exit Tasks and reward decision tokens.
    private static void RegisterCombatExit(BridgeSession session, GameAction action)
    {
        if (action is not (PlayCardAction or UsePotionAction or EndPlayerTurnAction) || !CombatManager.Instance.IsInProgress) return;
        var run = RunManager.Instance.DebugOnlyGetState();
        if (run?.CurrentRoom is not CombatRoom room || LocalContext.GetMe(run) is not { } player
            || NCombatRoom.Instance?.Ui is not { } ui || player.Creature.CombatState is not { } state
            || GetInstanceFieldValue(CombatManager.Instance, "_turnLoopTask") is not Task loop)
            throw new NotSupportedException("combat_exit_registration_unavailable");
        if (_combatExit != null) throw new NotSupportedException("overlapping_combat_exit_registration");
        var operation = new CombatExitOperation(action, run, room, state, ui, player, loop,
            action is EndPlayerTurnAction, () => session.PrimarySucceeded, SelectionOwners);
        _combatExit = operation; // Before RequestEnqueue / before the native ActionEnqueued callback returns.
        // ExecuteActions checks victory AFTER each GameAction pass. Its native batch receipt mirrors faults and is captured at the
        // exact registered action's BeforeActionExecuted, never inferred from idle/current executor. GetReadyAction hands the executor
        // WaitingForExecution once, then ReadyToResumeExecuting after each player choice; any other phase there is not a native pass.
        var executor = RunManager.Instance.ActionExecutor;
        operation.RequireExecutionReceipt();
        void Executing(GameAction source)
        {
            if (ReferenceEquals(source, action))
            {
                if (source.State is not (GameActionState.WaitingForExecution or GameActionState.ReadyToResumeExecuting)) operation.Fail("execution_receipt_phase_unverified");
                else operation.BindExecutionReceipt(source, executor.FinishedExecutingActions(), source.State == GameActionState.ReadyToResumeExecuting);
                return;
            }
            // Same native pre-Execute signal arms the owned map travel's old-room teardown window against current identities.
            var current = RunManager.Instance.DebugOnlyGetState();
            operation.TravelExecuting(source, current, current?.CurrentRoom, () => GetInstanceFieldValue(CombatManager.Instance, "_turnLoopTask"));
            if (operation.HasDecision)
            {
                try
                {
                    if (operation.CanDecide() && (RewardScopes.CurrentOwner is not RewardScope scope || !ReferenceEquals(scope.Operation, operation)))
                        operation.Fail("foreign_action_during_reward_decision");
                }
                catch { operation.Fail("reward_input_readiness_failed"); } // Never interrupt the foreign native action.
            }
        }
        executor.BeforeActionExecuted += Executing;
        void Ended(CombatRoom ended)
        {
            if (ReferenceEquals(ended, room)) operation.Ended = true;
            else operation.Fail("foreign_combat_exit");
        }
        CombatManager.Instance.CombatEnded += Ended;
        session.OnRelease(() =>
        {
            CombatManager.Instance.CombatEnded -= Ended;
            executor.BeforeActionExecuted -= Executing;
            operation.Close();
            if (ReferenceEquals(_combatExit, operation)) _combatExit = null;
        });
        session.HoldUntil(() =>
        {
            bool complete = operation.Poll(CombatManager.Instance.IsInProgress);
            var current = RunManager.Instance.DebugOnlyGetState();
            operation.ValidateReadyIdentity(current, current?.CurrentRoom);
            return complete;
        });
    }

    private static RewardCapture BeginRewardCapture(CombatExitOperation? operation, int kind, object? screen, object? map, bool allowProceed)
    {
        if (operation?.Closed == true) operation = null;
        var selection = SelectionOwners.Enter(operation?.Owner);
        var context = RewardScopes.Enter(operation == null ? null : new RewardScope(operation, kind == 1 ? null : screen, allowProceed));
        return new(operation, kind, screen, map, context, selection);
    }

    private static bool MatchesRewardEntry(CombatExitOperation operation, object run, object room, object combat, object ui, object player)
        => !operation.Closed && ReferenceEquals(operation.Run, run) && ReferenceEquals(operation.Room, room)
            && ReferenceEquals(operation.Combat, combat) && ReferenceEquals(operation.Ui, ui) && ReferenceEquals(operation.Player, player);

    private static void RewardUiPrefix(object __instance, object[] __args, MethodBase __originalMethod, out RewardCapture __state)
    {
        var operation = _combatExit;
        bool automatic = __originalMethod.Name == "ProceedWithoutRewards";
        if (operation != null && ReferenceEquals(operation.Ui, __instance))
        {
            var run = RunManager.Instance.DebugOnlyGetState();
            object? room = automatic ? run?.CurrentRoom : __args[0];
            if (run == null || !ReferenceEquals(run.CurrentRoom, room) || room is not CombatRoom combatRoom || LocalContext.GetMe(run) is not { } player
                || !MatchesRewardEntry(operation, run, room, combatRoom.CombatState, __instance, player))
            { operation.Fail("reward_ui_identity_mismatch"); operation = null; }
            else if (!operation.BeginUi()) operation = null;
        }
        else operation = null;
        EnterRewardUi(operation, automatic, out __state);
    }

    private static void EnterRewardUi(object? owner, bool allowProceed, out RewardCapture __state)
        => __state = BeginRewardCapture(owner as CombatExitOperation, 0, null, null, allowProceed);

    // OfferCustom leaves Room unset; the source identity adapter has already verified the live room.
    // A bound reward room must still match, and neither form can substitute another player or run.
    private static bool NonCombatOfferIdentity(RewardsSet set, object? room, object player, object run)
        => room != null && (set.Room == null || ReferenceEquals(set.Room, room))
            && ReferenceEquals(set.Player, player) && ReferenceEquals(set.Player.RunState, run);

    private static void RewardOfferPrefix(RewardsSet __instance, out RewardCapture __state)
    {
        if (TreasureScopes.CurrentOwner is TreasureScope treasure && ReferenceEquals(treasure.Operation, _treasureOperation))
        {
            var op = treasure.Operation;
            try
            {
                RequireTreasureIdentity(op);
                if (treasure.Set != null || treasure.Screen != null || !NonCombatOfferIdentity(__instance, op.Room, op.Player, op.Run))
                    throw new NotSupportedException("treasure_offer_identity_unverified");
                op.BeginOffer(__instance);
            }
            catch { op.Fail("treasure_offer_identity_unverified"); }
            __state = new RewardCapture(null, 1, __instance, null, TreasureScopes.Enter(new TreasureScope(op, Set: __instance)), SelectionOwners.Enter(op.Owner), treasure: op);
            return;
        }
        if (EventScopes.CurrentOwner is EventScope ordinary && ReferenceEquals(ordinary.Operation, _eventOperation))
        {
            var op = ordinary.Operation;
            try
            {
                RequireEventIdentity(op.Entry);
                if (ordinary.Screen != null || ordinary.Set != null || !NonCombatOfferIdentity(__instance, op.Entry.Room, op.Entry.Player, op.Entry.Run))
                    throw new NotSupportedException("event_offer_identity_unverified");
                op.BeginOffer(__instance);
            }
            catch { op.Fail("event_offer_identity_unverified"); }
            __state = new RewardCapture(null, 1, __instance, null, RewardScopes.Enter(null), SelectionOwners.Enter(op.Owner), op,
                EventScopes.Enter(new EventScope(op, Set: __instance)));
            return;
        }
        var scope = RewardScopes.CurrentOwner as RewardScope;
        var operation = scope?.Operation;
        if (operation != null && ReferenceEquals(operation, _combatExit) && !operation.Closed)
        {
            if (scope!.Screen != null)
            { operation.Fail("nested_rewards_set_unverified"); operation = null; }
            else if (!ReferenceEquals(RunManager.Instance.DebugOnlyGetState()?.CurrentRoom, operation.Room)
                || !ReferenceEquals(__instance.Room, operation.Room) || !ReferenceEquals(__instance.Player, operation.Player)
                || !ReferenceEquals(__instance.Player.RunState, operation.Run))
            { operation.Fail("rewards_set_identity_mismatch"); operation = null; }
            else
                try { operation.BeginSet(__instance); } catch { operation.Fail("rewards_set_reentry"); operation = null; }
        }
        else operation = null;
        __state = BeginRewardCapture(operation, 1, __instance, null, false);
    }

    private static void RewardProceedPrefix(object __instance, out RewardCapture __state)
    {
        if (TreasureScopes.CurrentOwner is TreasureScope { Proceed: true } treasure && ReferenceEquals(treasure.Operation, _treasureOperation))
        {
            var op = treasure.Operation;
            try
            {
                RequireTreasureIdentity(op);
                if (!ReferenceEquals(__instance, RunManager.Instance) || op.Proceed != null || op.Pick == null && !op.OnlyProceed || treasure.Screen != null)
                    throw new NotSupportedException("treasure_proceed_identity_unverified");
                var chestMap = NMapScreen.Instance!;
                RequireOrdinaryMap((RunState)op.Run, chestMap, !op.OnlyProceed || ((RunState)op.Run).CurrentRoomCount <= 1);
                if (chestMap.IsOpen) throw new NotSupportedException("treasure_map_already_open");
                void Opened()
                {
                    if (op.MapOpened || TreasureScopes.CurrentOwner is not TreasureScope input || !ReferenceEquals(input.Operation, op))
                        op.Fail("treasure_map_receipt_unverified");
                    else op.MapOpened = true;
                }
                chestMap.Opened += Opened;
                _bridgeSession.OnRelease(() => { if (Godot.GodotObject.IsInstanceValid(chestMap)) chestMap.Opened -= Opened; });
            }
            catch { op.Fail("treasure_proceed_identity_unverified"); }
            __state = new RewardCapture(null, 2, null, NMapScreen.Instance, TreasureScopes.Enter(treasure), SelectionOwners.Enter(op.Owner), treasure: op);
            return;
        }
        var scope = RewardScopes.CurrentOwner as RewardScope;
        var operation = scope?.Operation;
        object? map = null;
        if (operation != null && ReferenceEquals(operation, _combatExit) && !operation.Closed && scope!.AllowProceed)
        {
            var run = RunManager.Instance.DebugOnlyGetState();
            if (!ReferenceEquals(__instance, RunManager.Instance) || run == null || !ReferenceEquals(run, operation.Run)
                || !ReferenceEquals(run.CurrentRoom, operation.Room))
            { operation.Fail("reward_proceed_identity_mismatch"); operation = null; }
            else if (!(run.CurrentRoomCount > 1 && run.CurrentRoom is CombatRoom room && room.ShouldResumeParentEventAfterCombat))
                map = NMapScreen.Instance ?? throw new NotSupportedException("reward_map_receiver_unavailable");
        }
        else operation = null;
        __state = BeginRewardCapture(operation, 2, scope?.Screen, map, true);
    }

    private static void RewardTaskPostfix(Task __result, RewardCapture __state)
    {
        if (__state.Treasure is { } chest)
        {
            try
            {
                if (__state.Kind == 1) chest.AttachOffer(__state.Screen!, __result);
                else if (chest.Proceed != null) chest.Fail("treasure_proceed_duplicate");
                else
                {
                    chest.Proceed = __result;
                    RequireOrdinaryMap((RunState)chest.Run, (NMapScreen)__state.Map!);
                    if (!chest.MapOpened || !((NMapScreen)__state.Map!).IsOpen) chest.Fail("treasure_map_receipt_missing");
                }
            }
            catch { chest.Fail("treasure_reward_capture_failed"); }
            return;
        }
        if (__state.Event is { } ordinary)
        {
            try { ordinary.AttachOffer(__state.Screen!, __result); }
            catch { ordinary.Fail("event_offer_capture_failed"); }
            return;
        }
        var operation = __state.Operation;
        if (operation == null || operation.Closed) return;
        try
        {
            if (__state.Kind == 2) operation.Transition(__result, __state.Screen, __state.Map);
            else if (__state.Kind == 1) operation.AttachOffer(__state.Screen!, __result);
            else operation.AddTask(__result, false); // UI ancestors can await this exact screen's human decision; retain, do not deadlock it.
        }
        catch { operation.Fail("reward_task_capture_failed"); }
    }

    private static Exception? RewardTaskFinalizer(Exception? __exception, RewardCapture? __state)
    {
        if (__exception != null) { __state?.Operation?.Fail("reward_native_entry_failed"); __state?.Event?.Fail("event_offer_failed"); __state?.Treasure?.Fail("treasure_reward_entry_failed"); }
        __state?.Dispose();
        return __exception;
    }

    // Same already-pinned ShowScreen boundary, before Push/_Ready starts the detached RelicFtueCheck.
    // Do not substitute a later flag read or modal visibility for its seen-at-entry early return.
    private static void RewardScreenPrefix(out bool __state)
    {
        __state = false;
        if (TreasureScopes.CurrentOwner is TreasureScope treasure && ReferenceEquals(treasure.Operation, _treasureOperation))
        {
            try { __state = MegaCrit.Sts2.Core.Saves.SaveManager.Instance.SeenFtue("obtain_relic_ftue"); }
            catch { treasure.Operation.Fail("reward_relic_ftue_readiness_unavailable"); }
            return;
        }
        if (EventScopes.CurrentOwner is EventScope ordinary && ReferenceEquals(ordinary.Operation, _eventOperation))
        {
            try { __state = MegaCrit.Sts2.Core.Saves.SaveManager.Instance.SeenFtue("obtain_relic_ftue"); }
            catch { ordinary.Operation.Fail("reward_relic_ftue_readiness_unavailable"); }
            return;
        }
        if (RewardScopes.CurrentOwner is not RewardScope scope || !ReferenceEquals(scope.Operation, _combatExit) || scope.Operation.Closed) return;
        try { __state = MegaCrit.Sts2.Core.Saves.SaveManager.Instance.SeenFtue("obtain_relic_ftue"); }
        catch { scope.Operation.Fail("reward_relic_ftue_readiness_unavailable"); }
    }

    // Seen at entry only proves this screen skipped its tutorial lane; live modal guards still apply.
    private static void RewardScreenPostfix(object[] __args, NRewardsScreen __result, bool __state)
    {
        if (TreasureScopes.CurrentOwner is TreasureScope treasure && ReferenceEquals(treasure.Operation, _treasureOperation))
        {
            var op = treasure.Operation;
            try
            {
                RequireTreasureIdentity(op);
                if (!ReferenceEquals(__args[0], treasure.Set) || !ReferenceEquals(__args[2], op.Run) || (bool)__args[1])
                    throw new NotSupportedException("treasure_reward_screen_identity_unverified");
                op.BindScreen(__args[0], __result, __state);
                foreach (var button in FindAll<NRewardButton>(__result).Cast<NClickableControl>().Concat(FindAll<NProceedButton>(__result)))
                {
                    void Released(NClickableControl source)
                    {
                        if (!ReferenceEquals(source, button) || TreasureScopes.CurrentOwner is not TreasureScope input
                            || !ReferenceEquals(input.Operation, op) || !ReferenceEquals(input.Screen, __result)) op.Fail("foreign_treasure_reward_input");
                    }
                    button.Released += Released;
                    _bridgeSession.OnRelease(() => { if (Godot.GodotObject.IsInstanceValid(button)) button.Released -= Released; });
                }
            }
            catch { op.Fail("treasure_reward_screen_binding_failed"); }
            return;
        }
        if (EventScopes.CurrentOwner is EventScope ordinary && ReferenceEquals(ordinary.Operation, _eventOperation))
        {
            var op = ordinary.Operation;
            try
            {
                RequireEventIdentity(op.Entry);
                if (!ReferenceEquals(__args[2], op.Entry.Run) || !ReferenceEquals(__args[0], ordinary.Set))
                    throw new NotSupportedException("event_reward_screen_identity_unverified");
                op.BindScreen(__args[0], __result, (bool)__args[1], __state);
                foreach (var button in FindAll<NRewardButton>(__result).Cast<NClickableControl>().Concat(FindAll<NProceedButton>(__result)))
                {
                    void Released(NClickableControl _)
                    {
                        if (EventScopes.CurrentOwner is not EventScope input || !ReferenceEquals(input.Operation, op)
                            || !ReferenceEquals(input.Screen, __result)) op.Fail("foreign_event_reward_input");
                    }
                    button.Released += Released;
                    _bridgeSession.OnRelease(() => { if (Godot.GodotObject.IsInstanceValid(button)) button.Released -= Released; });
                }
            }
            catch { op.Fail("event_reward_screen_binding_failed"); }
            return;
        }
        if (RewardScopes.CurrentOwner is not RewardScope scope || !ReferenceEquals(scope.Operation, _combatExit) || scope.Operation.Closed) return;
        var operation = scope.Operation;
        try
        {
            if (!ReferenceEquals(__args[2], operation.Run) || !operation.OwnsSet(__args[0])
                || !ReferenceEquals(RunManager.Instance.DebugOnlyGetState()?.CurrentRoom, operation.Room))
                throw new NotSupportedException("unowned_reward_screen");
            operation.BindScreen(__args[0], __result, (bool)__args[1], __state);
            if (operation.Failure != null) return;
            foreach (var button in FindAll<NRewardButton>(__result).Cast<NClickableControl>().Concat(FindAll<NProceedButton>(__result)))
            {
                void Released(NClickableControl _) => RewardInputObserved(operation, __result);
                button.Released += Released;
                _bridgeSession.OnRelease(() => { if (Godot.GodotObject.IsInstanceValid(button)) button.Released -= Released; });
            }
        }
        catch { operation.Fail("reward_screen_binding_failed"); }
    }

    private static void RewardInputObserved(CombatExitOperation operation, object surface)
    {
        if (operation.Closed) return;
        if (RewardScopes.CurrentOwner is not RewardScope scope || !ReferenceEquals(scope.Operation, operation)
            || !ReferenceEquals(scope.Screen, surface) || !operation.OwnsDecision(surface))
            operation.Fail("foreign_reward_input"); // Revoke bridge permission, not the human/native callback.
    }

    private static bool TrackRewardChildAction(BridgeSession session, GameAction action, Task visual)
    {
        if (TreasureScopes.CurrentOwner is TreasureScope treasure && treasure.Screen != null)
        {
            var op = treasure.Operation;
            if (!ReferenceEquals(op, _treasureOperation) || !op.OwnsDecision(treasure.Screen)
                || !(ReferenceEquals(treasure.Screen, op.Scene) ? op.RoomReady() : op.RewardReady())) throw new NotSupportedException("treasure_child_action_unowned");
            bool canceled = false;
            void Canceled(GameAction source) { if (ReferenceEquals(source, action)) canceled = true; }
            action.BeforeCancelled += Canceled;
            session.OnRelease(() => action.BeforeCancelled -= Canceled);
            SelectionOwners.RegisterContext(action, op.Owner);
            Task? treasureJoined = null;
            op.AddWork(() =>
            {
                if (canceled) throw new NotSupportedException("treasure_child_action_cancelled");
                var execution = GetInstanceFieldValue(action, "_executionTask") as Task;
                foreach (var task in new[] { action.CompletionTask, visual, execution })
                    if (task?.IsFaulted == true || task?.IsCanceled == true) return task;
                return execution == null ? null : treasureJoined ??= Task.WhenAll(action.CompletionTask, visual, execution);
            });
            return true;
        }
        if (EventScopes.CurrentOwner is EventScope ordinary && ordinary.Screen != null)
        {
            var op = ordinary.Operation;
            if (!ReferenceEquals(op, _eventOperation) || !op.OwnsScreen(ordinary.Screen) || !op.CanDecide())
                throw new NotSupportedException("event_reward_action_unowned");
            bool stopped = action.State == GameActionState.Canceled;
            void Stopped(GameAction source) { if (ReferenceEquals(source, action)) stopped = true; }
            action.BeforeCancelled += Stopped;
            session.OnRelease(() => action.BeforeCancelled -= Stopped);
            SelectionOwners.RegisterContext(action, op.Owner);
            Task? eventJoined = null;
            op.AddWork(() =>
            {
                if (stopped) throw new NotSupportedException("event_reward_action_cancelled");
                var execution = GetInstanceFieldValue(action, "_executionTask") as Task;
                foreach (var task in new[] { action.CompletionTask, visual, execution })
                    if (task?.IsFaulted == true || task?.IsCanceled == true) return task;
                return execution == null ? null : eventJoined ??= Task.WhenAll(action.CompletionTask, visual, execution);
            });
            return true;
        }
        if (RewardScopes.CurrentOwner is not RewardScope scope || !ReferenceEquals(scope.Operation, _combatExit)
            || scope.Screen == null || !scope.Operation.OwnsDecision(scope.Screen)) return false;
        var operation = scope.Operation;
        bool cancelled = action.State == GameActionState.Canceled;
        void Cancelled(GameAction source) { if (ReferenceEquals(source, action)) cancelled = true; }
        action.BeforeCancelled += Cancelled;
        session.OnRelease(() => action.BeforeCancelled -= Cancelled);
        SelectionOwners.RegisterContext(action, operation.Owner);
        Task? joined = null;
        operation.AddWork(() =>
        {
            var execution = GetInstanceFieldValue(action, "_executionTask") as Task;
            foreach (var task in new[] { action.CompletionTask, visual, execution })
                if (task?.IsFaulted == true || task?.IsCanceled == true) return task;
            return execution == null ? null : joined ??= Task.WhenAll(action.CompletionTask, visual, execution);
        }, true, () => cancelled || action.State == GameActionState.Canceled);
        return true;
    }

    private static bool DispatchRewardProceed(NRewardsScreen screen, NProceedButton button)
    {
        var operation = _combatExit ?? throw new NotSupportedException("reward_owner_unavailable");
        bool terminal = GetInstanceFieldValue(screen, "_isTerminal") is true;
        int receipts = operation.TransitionCount;
        return DispatchRewardChild(screen, () =>
        {
            button.ForceClick(); // Preserve terminal/skip/FTUE/native validation branches.
            if (terminal)
            {
                if (operation.TransitionCount != receipts + 1) throw new NotSupportedException("reward_proceed_receipt_unavailable");
            }
            else operation.CompleteScreen(screen); // Native synchronous SkipLocalRewardsSet + Remove; Offer Task is still retained.
            return Task.CompletedTask; // Only this synchronous callback is done; captured transition/Offer tasks remain barriers.
        }, true);
    }

    private static bool DispatchRewardChild(object screen, Func<Task> start, bool proceed)
    {
        var operation = _combatExit ?? throw new NotSupportedException("reward_owner_unavailable");
        if (!operation.OwnsDecision(screen) || !operation.CanDecide()) throw new NotSupportedException("reward_child_not_ready");
        using var capture = BeginRewardCapture(operation, 3, screen, null, proceed);
        var task = start();
        operation.AddTask(task, true); // Preserve parent; never call BridgeSession.Track for a child.
        return true;
    }
}
