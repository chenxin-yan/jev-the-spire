using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace STS2_MCP;

// One initiating mutation, including its detached native reward tasks and explicit child decisions.
internal sealed class CombatExitOperation(object owner, object run, object room, object combat, object ui, object player,
    Task loop, bool joinLoop, Func<bool> primarySucceeded, SelectionOwnership selectors)
{
    internal readonly object Owner = owner, Run = run, Room = room, Combat = combat, Ui = ui, Player = player;
    internal readonly Task Loop = loop;
    internal bool Closed, Ended, Started;
    internal string? Failure;
    private sealed record Work(Func<Task?> Task, bool BlocksDecision, Func<bool>? Cancelled = null);
    private readonly List<Work> _work = new();
    private readonly Dictionary<object, Task?> _sets = new(ReferenceEqualityComparer.Instance);
    private sealed record Screen(TaskCompletionSource Lifetime, object Set, bool Terminal);
    private readonly Dictionary<object, Screen> _screens = new(ReferenceEqualityComparer.Instance);
    private readonly List<(Task Task, object? Screen, object? Map)> _transitions = new();
    private int _completedChildren;
    internal object? Map;
    internal int TransitionCount { get; private set; }
    private Task? _executionReceipt;
    private Func<Task?>? _roomTransition;
    private object? _travel;
    private Func<bool>? _arrived;
    // 0 none; 1 exact owned travel executing while the old room is current; 2 that travel's native old-room exit observed.
    // Only state 2 authorizes the retained non-join loop's cancellation: CombatRoom.Exit -> CombatManager.Reset(true) ->
    // CombatTurnState.Cancel uses parameterless TrySetCanceled, so no token equality can prove provenance.
    private int _teardown;

    internal void AddMapWork(Func<Task?> task, Func<bool> cancelled)
    {
        if (_roomTransition != null) throw new NotSupportedException("duplicate_reward_map_transition");
        _roomTransition = task;
        AddWork(task, true, cancelled);
    }

    // The exact MoveToMapCoordAction chained under the consumed map continuation; arrived = same run at the exact destination.
    internal void ExpectRoomExit(object travel, Func<bool> arrived)
    {
        if (Closed || _roomTransition == null || _travel != null) throw new NotSupportedException("unowned_map_travel");
        _travel = travel;
        _arrived = arrived;
    }

    // Native BeforeActionExecuted for that travel, before its Execute: old run/room/loop identities must still be current.
    internal void TravelExecuting(object action, object? run, object? room, Func<object?> loop)
    {
        if (_travel == null || !ReferenceEquals(action, _travel)) return;
        if (_teardown != 0 || !Ended || Loop.IsCanceled || !ReferenceEquals(run, Run) || !ReferenceEquals(room, Room) || !ReferenceEquals(loop(), Loop))
        { Fail("map_travel_provenance_unverified"); return; }
        _teardown = 1;
    }

    // Native RunManager.RoomExited: emitted after PopCurrentRoom and the old room's Exit, inside the owned travel's execution.
    // RunManager.CleanUp also resets combat but never emits it, so human teardown cannot reach state 2.
    internal void RoomExited(object? run, object? room, object? executing)
    {
        if (_roomTransition == null) return; // ResumePreviousRoom and other lanes keep their existing receipts unchanged.
        if (_teardown != 1 || !ReferenceEquals(executing, _travel) || !ReferenceEquals(run, Run) || ReferenceEquals(room, Room))
        { Fail("unowned_room_exit"); return; }
        _teardown = 2;
    }

    internal void ValidateReadyIdentity(object? run, object? room)
    {
        // A consumed map continuation stays bound to its original run for the whole travel. Native RunManager.CleanUp
        // (main menu) nulls the run without RoomExited or action cancellation: a vanished/replaced run is permanent,
        // unlike same-run travel that has merely not reached the destination (room changes; run does not).
        if (_roomTransition != null && !ReferenceEquals(Run, run)) throw new NotSupportedException("reward_run_invalidated");
        if (HasDecision && CanDecide() && (!ReferenceEquals(Run, run) || !ReferenceEquals(Room, room)))
            throw new NotSupportedException("reward_decision_identity_changed");
    }

    internal void RequireExecutionReceipt() => AddWork(() => _executionReceipt, true);
    internal void BindExecutionReceipt(object source, Task task)
    {
        if (!ReferenceEquals(source, Owner)) return;
        if (_executionReceipt != null || Closed) { Fail("duplicate_or_late_execution_receipt"); return; }
        _executionReceipt = task;
    }

    internal bool BeginUi()
    {
        if (Closed || Started || Ended) { Fail("duplicate_or_late_reward_ui_entry"); return false; }
        Started = true;
        return true;
    }

    internal void Fail(string reason) => Failure ??= reason;
    internal void Check()
    {
        if (Failure != null) throw new NotSupportedException(Failure);
        if (Loop.IsFaulted) { _ = Loop.Exception; throw new NotSupportedException("combat_loop_faulted"); }
        if (Loop.IsCanceled && (joinLoop || _teardown != 2)) throw new NotSupportedException("combat_loop_cancelled");
        foreach (var work in _work)
        {
            var task = work.Task();
            if (work.Cancelled?.Invoke() == true || task?.IsCanceled == true) throw new NotSupportedException("reward_work_cancelled");
            if (task?.IsFaulted == true) { _ = task.Exception; throw new NotSupportedException("reward_work_faulted"); }
        }
    }

    internal void AddTask(Task task, bool blocksDecision) => AddWork(() => task, blocksDecision);
    internal void AddWork(Func<Task?> task, bool blocksDecision, Func<bool>? cancelled = null)
    {
        if (Closed) throw new NotSupportedException("closed_combat_exit_owner");
        _work.Add(new(task, blocksDecision, cancelled));
    }

    internal void BeginSet(object set)
    {
        if (Closed || !_sets.TryAdd(set, null)) throw new NotSupportedException("duplicate_or_stale_rewards_set");
    }
    internal bool OwnsSet(object set) => !Closed && _sets.ContainsKey(set);
    internal void AttachOffer(object set, Task task)
    {
        if (!OwnsSet(set) || _sets[set] != null) throw new NotSupportedException("unowned_or_duplicate_offer_task");
        _sets[set] = task;
        AddTask(task, false);
    }
    internal bool OwnsScreen(object screen) => !Closed && _screens.ContainsKey(screen);
    internal bool OwnsDecision(object surface) => OwnsScreen(surface) || !Closed && Map != null && ReferenceEquals(Map, surface);
    internal bool HasDecision => !Closed && (_screens.Count != 0 || Map != null);

    internal void BindScreen(object set, object screen, bool terminal, bool relicFtueSeenAtEntry)
    {
        // RelicFtueCheck reads this once before two awaits; a later seen flag cannot settle that task.
        if (!relicFtueSeenAtEntry) Fail("reward_relic_ftue_completion_unverified");
        if (Failure != null) return;
        if (!OwnsSet(set) || _screens.ContainsKey(screen)) throw new NotSupportedException("unowned_reward_screen");
        var lifetime = new TaskCompletionSource();
        _screens.Add(screen, new(lifetime, set, terminal));
        selectors.BeginContinuation(screen, Owner, lifetime.Task, CanDecide);
    }

    internal bool CanDecide()
    {
        Check();
        return !Closed && Ended && primarySucceeded() && (!joinLoop || Loop.IsCompletedSuccessfully)
            && _work.Where(w => w.BlocksDecision).All(w => w.Task()?.IsCompletedSuccessfully == true);
    }

    internal void Transition(Task task, object? screen, object? map)
    {
        if (screen != null && !OwnsScreen(screen)) throw new NotSupportedException("unowned_reward_transition");
        AddTask(task, true);
        _transitions.Add((task, screen, map));
        TransitionCount++;
    }

    internal void CompleteScreen(object screen)
    {
        if (!_screens.Remove(screen, out var lifetime)) throw new NotSupportedException("unowned_reward_screen_completion");
        lifetime.Lifetime.SetResult();
        selectors.CloseContinuation(screen, Owner);
    }

    internal void ConsumeMap()
    {
        if (Map == null || !CanDecide()) throw new NotSupportedException("unowned_reward_map_continuation");
        selectors.CloseContinuation(Map, Owner);
        Map = null;
    }

    internal bool Poll(bool combatInProgress)
    {
        Check();
        // Nonterminal UpdateScreenState removes the screen after its last reward. Require BOTH the exact
        // Offer and every original child task (including GetReward's UI update), not visibility/IsComplete.
        if (_work.Where(w => w.BlocksDecision).All(w => w.Task()?.IsCompletedSuccessfully == true))
            foreach (var screen in _screens.Where(p => !p.Value.Terminal && _sets[p.Value.Set]?.IsCompletedSuccessfully == true).Select(p => p.Key).ToArray())
                CompleteScreen(screen);
        if (_roomTransition?.Invoke()?.IsCompletedSuccessfully == true)
            foreach (var screen in _screens.Keys.ToArray()) CompleteScreen(screen);
        foreach (var transition in _transitions.Where(t => t.Task.IsCompletedSuccessfully).ToArray())
        {
            if (transition.Screen != null && _screens.Remove(transition.Screen, out var lifetime))
            { lifetime.Lifetime.SetResult(); selectors.CloseContinuation(transition.Screen, Owner); }
            if (transition.Map == null) // Exact native ResumePreviousRoom completion, not an inferred room change.
                foreach (var screen in _screens.Keys.ToArray()) CompleteScreen(screen);
            if (transition.Map != null && (_screens.Count != 0 || _work.Any(w => w.Task()?.IsCompletedSuccessfully != true)))
            {
                Map = transition.Map;
                selectors.BeginContinuation(Map, Owner, new TaskCompletionSource().Task, CanDecide);
            }
            _transitions.Remove(transition);
        }
        int completed = _work.Count(w => w.BlocksDecision && w.Task()?.IsCompletedSuccessfully == true);
        if (completed != _completedChildren)
        {
            _completedChildren = completed;
            foreach (var screen in _screens.Keys) selectors.RenewContinuation(screen, Owner);
            if (Map != null) selectors.RenewContinuation(Map, Owner);
        }
        if (!Started && !Ended) return combatInProgress && _work.All(w => w.Task()?.IsCompletedSuccessfully == true);
        return Ended && (!joinLoop || Loop.IsCompletedSuccessfully) && _screens.Count == 0
            && _work.All(w => w.Task()?.IsCompletedSuccessfully == true)
            && (_roomTransition == null || _teardown == 2 && Loop.IsCompleted && _arrived?.Invoke() == true);
    }

    internal void Close() { Closed = true; selectors.CloseOwner(Owner); }
}
