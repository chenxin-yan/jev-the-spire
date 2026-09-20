using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using MegaCrit.Sts2.Core.Combat;
using MegaCrit.Sts2.Core.Entities.Creatures;
using MegaCrit.Sts2.Core.Entities.Actions;
using MegaCrit.Sts2.Core.Models;
using MegaCrit.Sts2.Core.Entities.Players;
using MegaCrit.Sts2.Core.GameActions;
using MegaCrit.Sts2.Core.Map;
using MegaCrit.Sts2.Core.Multiplayer.Game;
using MegaCrit.Sts2.Core.Nodes.Combat;
using MegaCrit.Sts2.Core.Nodes.Screens.Map;
using MegaCrit.Sts2.Core.Runs;

namespace STS2_MCP;

public static partial class McpMod
{
    // An ordinary owned mutation plus the detached native work a scoped hook retains under it (e.g. the rest post-select lane).
    // It exists before start() so a synchronous producer is captured, and closes with the owner so late producers are refused.
    private sealed class OrdinaryOwner { internal readonly List<Task> Work = new(); internal bool Closed; }

    private static bool DispatchOwnedTask(Func<Task> start)
    {
        if (TreasureScopes.CurrentOwner is TreasureScope treasureChild && treasureChild.Screen != null)
            return DispatchTreasureRewardChild(treasureChild.Screen, start);
        if (EventScopes.CurrentOwner is EventScope eventChild && eventChild.Screen != null)
            return DispatchEventRewardChild(eventChild.Screen, start);
        if (RewardScopes.CurrentOwner is RewardScope child && ReferenceEquals(child.Operation, _combatExit) && child.Screen != null)
            return DispatchRewardChild(child.Screen, start, false);
        var owner = new OrdinaryOwner();
        var session = _bridgeSession;
        using var scope = SelectionOwners.Enter(owner);
        try
        {
            var task = start() ?? throw new NotSupportedException("native_task_unavailable");
            session.Track(owner, task, Task.CompletedTask, () => task, () => false);
            session.HoldUntil(() => OrdinaryWorkDone(owner));
            session.OnRelease(() => { owner.Closed = true; SelectionOwners.CloseOwner(owner); });
            return true;
        }
        catch { owner.Closed = true; SelectionOwners.CloseOwner(owner); throw; }
    }

    private static void RetainOrdinaryWork(Task task)
    {
        if (SelectionOwners.CurrentOwner is not OrdinaryOwner { Closed: false } owner) throw new NotSupportedException("ordinary_work_owner_unverified");
        owner.Work.Add(task ?? throw new NotSupportedException("ordinary_work_task_unavailable"));
    }

    private static bool OrdinaryWorkDone(OrdinaryOwner owner)
    {
        foreach (var task in owner.Work)
            if (task.IsFaulted || task.IsCanceled) { _ = task.Exception; throw new NotSupportedException("ordinary_work_failed"); }
        return owner.Work.All(task => task.IsCompletedSuccessfully);
    }

    private static bool DispatchUiTask(object node, Type declaring, string name, params object?[] arguments)
        => DispatchOwnedTask(() => InvokeUiTask(node, declaring, name, arguments));

    private static Task InvokeUiTask(object node, Type declaring, string name, params object?[] arguments)
        => declaring.GetMethod(name, BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic)
            ?.Invoke(node, arguments) as Task ?? throw new NotSupportedException("native_ui_task_unavailable:" + name);

    private static bool DispatchPotion(PotionModel potion, int index, Creature? target)
    {
        var queues = RunManager.Instance.ActionQueueSet;
        var session = _bridgeSession;
        UsePotionAction? owned = null;
        void OnEnqueued(GameAction action)
        {
            if (action is not UsePotionAction use) return;
            if (owned != null || !ReferenceEquals(use.Player, potion.Owner) || use.PotionIndex != index
                || !ReferenceEquals(potion.Owner.PotionSlots[index], potion))
            { session.Fail("unowned_potion_action"); return; }
            owned = use;
            TrackGameAction(session, use, Task.CompletedTask);
        }
        queues.ActionEnqueued += OnEnqueued;
        try { potion.EnqueueManualUse(target); } // Preserve BeforeUse, target normalization and IsQueued.
        finally { queues.ActionEnqueued -= OnEnqueued; }
        if (owned == null) throw new NotSupportedException("potion_action_not_enqueued");
        return true;
    }

    private static bool DispatchMap(NMapScreen screen, NMapPoint point, RunState run, Player player)
    {
        var manager = RunManager.Instance;
        var queue = manager.ActionQueueSet;
        var executor = manager.ActionExecutor;
        var session = _bridgeSession;
        ClearEventEntry();
        EventEntry? eventEntry = null;
        var destination = point.Point.coord;
        var source = new MapLocation(run.CurrentMapCoord, run.CurrentActIndex);
        int generation = manager.MapSelectionSynchronizer.MapGenerationCount;
        var chain = new QueuedActionChain(destination);
        var parent = _combatExit;
        bool child = parent?.Map != null && ReferenceEquals(parent.Map, screen) && ReferenceEquals(session.OperationOwner, parent.Owner);
        var owner = child ? parent!.Owner : new object();
        var actions = new List<GameAction>();
        bool cancelled = false, dispatching = true;
        GameAction? entering = null;
        OrdinaryRoomEntry? entry = null;
        _restEntry = null;
        var runNode = MegaCrit.Sts2.Core.Nodes.NRun.Instance ?? throw new NotSupportedException("map_run_scene_unavailable");
        var tree = screen.GetTree();
        void NodeAdded(Godot.Node node)
        {
            if (node is not MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom scene || entering == null || entry == null) return;
            try
            {
                // NSceneContainer assigns CurrentScene before AddChild. _Ready assigns _proceedButton
                // before starting ShowFtueIfNeeded. Requiring null proves this is pre-FTUE, even if
                // engine ordering changes. NodeAdded -> _Ready is synchronous on the native main thread.
                if (cancelled || !ReferenceEquals(MegaCrit.Sts2.Core.Nodes.NRun.Instance, runNode)
                    || !ReferenceEquals(runNode.RestSiteRoom, scene) || !ReferenceEquals(manager.DebugOnlyGetState(), run)
                    || run.CurrentMapCoord != destination || run.CurrentRoom is not MegaCrit.Sts2.Core.Rooms.RestSiteRoom model
                    || !ReferenceEquals(GetInstanceFieldValue(scene, "_room"), model)
                    || !ReferenceEquals(GetInstanceFieldValue(scene, "_runState"), run))
                { entry.Invalidate(); return; }
                entry.Bind(entering, SelectionOwners.CurrentOwner, run, MegaCrit.Sts2.Core.Context.LocalContext.GetMe(run), model, scene,
                    MegaCrit.Sts2.Core.Nodes.NGame.IsMainThread() && runNode.IsNodeReady() && scene.GetParent().IsNodeReady()
                        && !scene.IsNodeReady() && GetInstanceFieldValue(scene, "_proceedButton") == null,
                    MegaCrit.Sts2.Core.Saves.SaveManager.Instance.SeenFtue("rest_site_ftue"));
            }
            catch { entry.Invalidate(); }
        }
        void RoomEntered(GameAction action)
        {
            if (ReferenceEquals(action, entering)) entry?.Finish(action);
            // Existing map receipt also joins original completion/execution and sticky cancellation.
        }
        void OnCancelled(GameAction action)
        {
            if (actions.Exists(owned => ReferenceEquals(owned, action))) { cancelled = true; entry?.Invalidate(); }
        }
        void Watch(GameAction action)
        {
            actions.Add(action); action.BeforeCancelled += OnCancelled;
            cancelled |= action.State == GameActionState.Canceled;
            SelectionOwners.RegisterContext(action, owner);
        }
        void OnEnqueued(GameAction action)
        {
            try
            {
                if (action is VoteForMapCoordAction)
                {
                    if (!dispatching || !ReferenceEquals(GetInstanceFieldValue(action, "_player"), player)
                        || GetInstanceFieldValue(action, "_source") is not MapLocation actualSource || actualSource != source
                        || GetInstanceFieldValue(action, "_destination") is not MapVote vote
                        || vote.coord != destination || vote.mapGenerationCount != generation)
                        throw new NotSupportedException("unowned_map_vote");
                    chain.AddRoot(action, action.CompletionTask, () => GetInstanceFieldValue(action, "_executionTask") as Task);
                    Watch(action);
                    action.AfterFinished += VoteFinished;
                }
                else if (action is MoveToMapCoordAction)
                {
                    if (!ReferenceEquals(GetInstanceFieldValue(action, "_player"), player)
                        || GetInstanceFieldValue(action, "_destination") is not MapCoord coord)
                        throw new NotSupportedException("map_travel_identity_unavailable");
                    // Vote.ExecuteAction synchronously invokes MapSelectionSynchronizer.MoveToMapCoord.
                    // This exact executing vote + destination is the causal seam, not an arbitrary later map change.
                    chain.AddChild(executor.CurrentlyRunningAction, coord, action, action.CompletionTask,
                        () => GetInstanceFieldValue(action, "_executionTask") as Task);
                    Watch(action);
                    // This exact travel exits the old combat room (Reset(true) -> loop cancel) before entering the destination.
                    if (child) parent!.ExpectRoomExit(action, () => ReferenceEquals(manager.DebugOnlyGetState(), run) && run.CurrentMapCoord == destination);
                    entering = action;
                    _eventEntry = eventEntry = new EventEntry(action, owner, run, player);
                    session.HoldUntil(() =>
                    {
                        eventEntry.Check();
                        return !eventEntry.Bound || EventInputsReady(eventEntry);
                    });
                    _restEntry = entry = new OrdinaryRoomEntry(action, owner, run, player);
                    action.AfterFinished += RoomEntered; // Before queue insertion/execution can enter _Ready.
                }
            }
            catch { session.Fail("map_action_chain_mismatch"); }
        }
        void VoteFinished(GameAction vote)
        {
            if (!ReferenceEquals(vote, chain.Root) || !chain.HasChild) session.Fail("map_vote_without_owned_travel");
            queue.ActionEnqueued -= OnEnqueued;
        }
        // Existing native RoomExited, scoped to this consumed continuation: after PopCurrentRoom and the old room's Exit,
        // while the owned travel is the currently running action. CleanUp resets combat without emitting it.
        void Exited()
        {
            var state = manager.DebugOnlyGetState();
            parent!.RoomExited(state, state?.CurrentRoom, executor.CurrentlyRunningAction);
        }
        if (child)
        {
            parent!.ConsumeMap();
            parent.AddMapWork(chain.Poll, () => cancelled);
            manager.RoomExited += Exited;
        }
        else session.Track(owner, Task.CompletedTask, Task.CompletedTask, chain.Poll, () => cancelled);
        session.OnRelease(() => queue.ActionEnqueued -= OnEnqueued);
        session.OnRelease(() =>
        {
            if (child) manager.RoomExited -= Exited;
            if (Godot.GodotObject.IsInstanceValid(tree)) tree.NodeAdded -= NodeAdded;
            if (cancelled || session.Failure != null) { entry?.Invalidate(); eventEntry?.Fail("event_movement_failed"); eventEntry?.Close(); }
            if (eventEntry?.Bound == false) eventEntry.Close();
            foreach (var action in actions) { action.BeforeCancelled -= OnCancelled; action.AfterFinished -= VoteFinished; action.AfterFinished -= RoomEntered; }
            if (!child) SelectionOwners.CloseOwner(owner);
        });
        queue.ActionEnqueued += OnEnqueued;
        tree.NodeAdded += NodeAdded;
        using var selectionScope = SelectionOwners.Enter(owner);
        // The owned map continuation is not authority to adopt destination-room reward tasks.
        using var rewardScope = RewardScopes.Enter(null);
        try { screen.OnMapPointSelectedLocally(point); }
        finally { dispatching = false; }
        if (chain.Root == null) throw new NotSupportedException("map_vote_not_enqueued");
        return true;
    }

    private static bool NativeCanEndTurn(NEndTurnButton button)
        => (typeof(NEndTurnButton).GetProperty("CanTurnBeEnded", BindingFlags.Instance | BindingFlags.NonPublic)
            ?? throw new NotSupportedException("end_turn_predicate_unavailable")).GetValue(button) is true;

    private static bool DispatchEndTurn(NEndTurnButton button, Player player)
    {
        var manager = RunManager.Instance;
        var session = _bridgeSession;
        var combat = CombatManager.Instance;
        var playerState = player.PlayerCombatState ?? throw new NotSupportedException("player_combat_state_unavailable");
        int turn = playerState.TurnNumber;
        var combatState = player.Creature.CombatState ?? throw new NotSupportedException("combat_state_unavailable");
        bool nextTurnStarted = false;
        void OnTurnStarted(CombatState state)
        {
            if (!ReferenceEquals(state, combatState)) { session.Fail("end_turn_combat_changed"); return; }
            if (playerState.TurnNumber > turn && IsPlayPhase(player)) nextTurnStarted = true;
        }
        var loop = GetInstanceFieldValue(combat, "_turnLoopTask") as Task ?? throw new NotSupportedException("combat_loop_unavailable");
        if (!NativeCanEndTurn(button) || combat.IsPlayerReadyToEndTurn(player)) return false;
        EndPlayerTurnAction? owned = null;
        void OnEnqueued(GameAction action)
        {
            if (action is not EndPlayerTurnAction) return;
            if (owned != null || !ReferenceEquals(GetInstanceFieldValue(action, "_player"), player)
                || GetInstanceFieldValue(action, "_turnNumber") is not int actualTurn || actualTurn != turn)
            { session.Fail("unowned_end_turn"); return; }
            owned = (EndPlayerTurnAction)action;
            TrackGameAction(session, action, Task.CompletedTask);
            combat.TurnStarted += OnTurnStarted;
            session.OnRelease(() => combat.TurnStarted -= OnTurnStarted);
            session.HoldUntil(() =>
            {
                // The loop spans the entire combat, including future human decision waits: never join it here.
                // TurnStarted(player) follows awaited setup, auto-pre-play and CheckWinCondition;
                // Play + a higher turn alone could precede that final asynchronous win check.
                if (loop.IsFaulted) { _ = loop.Exception; throw new NotSupportedException("combat_loop_faulted"); }
                if (loop.IsCanceled) throw new NotSupportedException("combat_loop_cancelled");
                // The separately retained exit operation requires the exact CombatEnded event and all owned lanes.
                if (!combat.IsInProgress) return _combatExit?.Ended == true && loop.IsCompletedSuccessfully;
                if (!ReferenceEquals(GetInstanceFieldValue(combat, "_turnLoopTask"), loop) || !ReferenceEquals(player.PlayerCombatState, playerState))
                    throw new NotSupportedException("combat_loop_identity_changed");
                return nextTurnStarted && playerState.TurnNumber > turn && IsPlayPhase(player) && !combat.PlayerActionsDisabled
                    && !combat.IsPlayerReadyToEndTurn(player);
            });
        }
        manager.ActionQueueSet.ActionEnqueued += OnEnqueued;
        try { button.ForceClick(); } // Preserve native guard, button state and exact End/Undo branch.
        finally { manager.ActionQueueSet.ActionEnqueued -= OnEnqueued; }
        if (owned == null) throw new NotSupportedException("end_turn_not_enqueued");
        return true;
    }
}
