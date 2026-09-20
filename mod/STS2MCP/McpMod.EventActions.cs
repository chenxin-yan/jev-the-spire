using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Godot;
using MegaCrit.Sts2.Core.Context;
using MegaCrit.Sts2.Core.Events;
using MegaCrit.Sts2.Core.Models;
using MegaCrit.Sts2.Core.Nodes.Events;
using MegaCrit.Sts2.Core.Nodes.GodotExtensions;
using MegaCrit.Sts2.Core.Nodes.Rooms;
using MegaCrit.Sts2.Core.Nodes.Screens.Map;
using MegaCrit.Sts2.Core.Rooms;
using MegaCrit.Sts2.Core.Runs;

namespace STS2_MCP;

public static partial class McpMod
{
    private static EventEntry? _eventEntry;
    private static EventOperation? _eventOperation;
    private static readonly SelectionOwnership EventScopes = new();
    private sealed record EventScope(EventOperation Operation, object? Set = null, object? Screen = null, object? Proceed = null);

    private static void ClearEventEntry()
    {
        _eventEntry?.Close();
        if (_eventEntry?.CleanupFailed == true) throw new NotSupportedException("event_cleanup_failed");
        _eventEntry = null;
    }

    // Genuine initial opening: the native run start created this Ancient room itself, so no owned map travel exists to bind.
    // Restored, resumed and foreign-travel rooms return null and keep the existing event_setup_unowned refusal.
    private static EventEntry? BeginActOpening(NEventRoom scene)
    {
        if (_eventEntry?.CleanupFailed == true) return null;
        var manager = RunManager.Instance;
        if (manager.DebugOnlyGetState() is not RunState run || run.CurrentRoom is not EventRoom room
            || GetInstanceFieldValue(scene, "_event") is not EventModel model || run.CurrentMapCoord is not MegaCrit.Sts2.Core.Map.MapCoord coord
            || GetInstanceFieldValue(manager, "_numReloads") is not int reloads || LocalContext.GetMe(run) is not { } player) return null;
        if (!BridgeProtocol.FreshActOpening(reloads, run.CurrentActIndex, run.ExtraFields.StartedWithNeow, coord == run.Map.StartingMapPoint.coord,
                run.CurrentMapPoint?.PointType == MegaCrit.Sts2.Core.Map.MapPointType.Ancient, run.VisitedMapCoords.Count,
                room.IsPreFinished, model.IsFinished, manager.ActionExecutor.CurrentlyRunningAction != null)) return null;
        return _eventEntry = new EventEntry(new ActOpening(coord), new object(), run, player);
    }
    private static MegaCrit.Sts2.Core.Map.MapCoord? EntryDestination(EventEntry entry)
        => (entry.Move is ActOpening opening ? opening.Destination : GetInstanceFieldValue(entry.Move, "_destination")) as MegaCrit.Sts2.Core.Map.MapCoord?;
    private static void EventSetupPrefix(NEventRoom __instance, out IDisposable __state)
    {
        var ambient = SelectionOwners.CurrentOwner;
        __state = SelectionOwners.Enter(null);
        var entry = _eventEntry;
        if (entry is null or { Closed: true } && ambient == null && BeginActOpening(__instance) is { } opening)
        { entry = opening; ambient = opening.Owner; }
        if (entry == null || entry.Closed) return;
        try
        {
            var run = RunManager.Instance.DebugOnlyGetState();
            if (!ReferenceEquals(ambient, entry.Owner) || !ReferenceEquals(run, entry.Run)
                || run?.CurrentRoom is not EventRoom room || !ReferenceEquals(NEventRoom.Instance, __instance)
                || EntryDestination(entry) is not MegaCrit.Sts2.Core.Map.MapCoord destination || run.CurrentMapCoord != destination
                || GetInstanceFieldValue(__instance, "_event") is not EventModel model || !ReferenceEquals(room.LocalMutableEvent, model)
                || !ReferenceEquals(model.Owner, entry.Player) || !ReferenceEquals(GetInstanceFieldValue(__instance, "_runState"), run)
                || __instance.Layout is not { } layout || __instance.CustomEventNode != null || __instance.EmbeddedCombatRoom != null)
            { entry.Fail("event_setup_identity_unverified"); return; }
            entry.Bind(ambient!, room, __instance, model, layout);
            entry.Check();
            void Changed(EventModel source) => entry.Changed(source, SelectionOwners.CurrentOwner);
            void Combat() => entry.Fail("event_embedded_combat_unverified");
            var tree = __instance.GetTree();
            var inputCleanup = new List<Action>();
            void Added(Node node)
            {
                if (node is NEventOptionButton button && ReferenceEquals(button.Event, model))
                {
                    if (!layout.IsAncestorOf(button)) { entry.Fail("event_button_layout_mismatch"); return; }
                    entry.Input(button, button.Option, SelectionOwners.CurrentOwner, button.MouseFilter == Control.MouseFilterEnum.Ignore);
                    if (entry.Closed) return;
                    void Released(NClickableControl source)
                    {
                        if (!ReferenceEquals(source, button) || !entry.OwnsScope(SelectionOwners.CurrentOwner)) entry.Fail("foreign_event_input");
                    }
                    button.Released += Released;
                    inputCleanup.Add(() => { if (GodotObject.IsInstanceValid(button)) button.Released -= Released; });
                }
            }
            void Exiting() => entry.Close();
            entry.Cleanup = () =>
            {
                model.StateChanged -= Changed; model.EnteringEventCombat -= Combat;
                foreach (var cleanup in inputCleanup) cleanup(); inputCleanup.Clear();
                if (GodotObject.IsInstanceValid(tree)) tree.NodeAdded -= Added;
                if (GodotObject.IsInstanceValid(__instance)) __instance.TreeExiting -= Exiting;
            };
            model.StateChanged += Changed;
            model.EnteringEventCombat += Combat;
            tree.NodeAdded += Added;
            __instance.TreeExiting += Exiting;
            __state.Dispose(); __state = SelectionOwners.Enter(entry.Owner);
        }
        catch { entry.Fail("event_setup_capture_failed"); }
    }
    private static void EventSetupPostfix(NEventRoom __instance, Task __result)
    {
        if (_eventEntry is { } entry && ReferenceEquals(entry.Scene, __instance)) entry.Attach(__result);
    }
    private static Exception? EventSetupFinalizer(Exception? __exception, IDisposable? __state)
    {
        if (__exception != null) _eventEntry?.Fail("event_setup_failed");
        __state?.Dispose(); return __exception;
    }
    private static void EventChosenPostfix(EventOption __instance, Task __result)
    {
        if (!__instance.IsProceed || EventScopes.CurrentOwner is not EventScope scope || !ReferenceEquals(scope.Proceed, __instance)) return;
        if (scope.Operation.Root != null) scope.Operation.Fail("event_proceed_receipt_duplicate");
        else scope.Operation.Root = __result;
    }

    private static void RequireEventIdentity(EventEntry entry)
    {
        entry.Check();
        if (entry.Run is not RunState run || !ReferenceEquals(RunManager.Instance.DebugOnlyGetState(), run)
            || !ReferenceEquals(run.CurrentRoom, entry.Room) || !ReferenceEquals(NEventRoom.Instance, entry.Scene)
            || entry.Scene is not NEventRoom scene || !ReferenceEquals(scene.Layout, entry.Layout)
            || !ReferenceEquals(GetInstanceFieldValue(scene, "_event"), entry.Model) || !ReferenceEquals(GetInstanceFieldValue(scene, "_runState"), run)
            || run.CurrentRoom is not EventRoom room || !ReferenceEquals(room.LocalMutableEvent, entry.Model)
            || entry.Model is not EventModel model || !ReferenceEquals(model.Owner, entry.Player) || !ReferenceEquals(model.Owner.RunState, run)
            || !ReferenceEquals(LocalContext.GetMe(run), entry.Player)
            || scene.CustomEventNode != null || scene.EmbeddedCombatRoom != null)
            throw new NotSupportedException("event_identity_changed");
    }
    private static bool EventInputsReady(EventEntry entry)
    {
        RequireEventIdentity(entry);
        if (entry.Setup?.IsCompletedSuccessfully != true) return false;
        var layout = (NEventLayout)entry.Layout!;
        if (layout.GetType() != typeof(NEventLayout) && layout.GetType() != typeof(NAncientEventLayout))
            throw new NotSupportedException("custom_event_layout_unverified");
        if (layout is NAncientEventLayout ancient && ancient.GetNodeOrNull<NClickableControl>("%DialogueHitbox") is { } hitbox
            && IsControlVisibleOrActionable(hitbox)) return OrdinaryInput(hitbox);
        var model = (EventModel)entry.Model!;
        BridgeProtocol.RequireEventPolicy(model.IsShared, model.CanonicalEncounter != null);
        var buttons = layout.OptionButtons.ToArray();
        return buttons.Length > 0 && buttons.All(button => button.Option.IsLocked || entry.InputReady(button, button.Option, entry.Generation,
            button.MouseFilter == Control.MouseFilterEnum.Stop && button.IsEnabled, layout is NAncientEventLayout));
    }
    private static void RequireEventOption(EventEntry entry, NEventOptionButton button, int generation)
    {
        RequireEventIdentity(entry); entry.RequireGeneration(generation);
        var model = (EventModel)entry.Model!;
        BridgeProtocol.RequireEventPolicy(model.IsShared, model.CanonicalEncounter != null);
        if (!ReferenceEquals(button.Event, model) || !((NEventLayout)entry.Layout!).OptionButtons.Contains(button)
            || button.Option.IsLocked || OrdinaryBool(button.Option, "<DisableOnChosen>k__BackingField") && button.Option.WasChosen)
            throw new NotSupportedException("event_option_identity_changed");
        if (!entry.InputReady(button, button.Option, generation, OrdinaryInput(button) && button.MouseFilter == Control.MouseFilterEnum.Stop,
            entry.Layout is NAncientEventLayout)) throw new NotSupportedException("event_input_not_enabled");
        if (typeof(NEventOptionButton).GetMethod("WillKillPlayer", BindingFlags.Instance | BindingFlags.NonPublic)!.Invoke(button, null) is true)
            throw new NotSupportedException("event_lethal_confirmation_unverified");
        var before = GetInstanceFieldValue(button.Option, "BeforeChosen") as Delegate;
        if (before == null || before.GetInvocationList().Length != 1 || before.GetInvocationList().Any(d => !ReferenceEquals(d.Target, entry.Scene) || d.Method.Name != "BeforeOptionChosen"))
            throw new NotSupportedException("event_before_chosen_unverified");
        if (button.Option.IsProceed)
        {
            var chosen = GetInstanceFieldValue(button.Option, "<OnChosen>k__BackingField") as Delegate;
            if (!model.IsFinished || chosen?.Method.DeclaringType != typeof(NEventRoom) || chosen.Method.Name != "Proceed"
                || chosen.GetInvocationList().Length != 1 || !chosen.Method.IsStatic || chosen.Target != null)
                throw new NotSupportedException("event_proceed_unverified");
            RequireOrdinaryMap((RunState)entry.Run, NMapScreen.Instance!, false, entry.Move is ActOpening);
        }
        else
        {
            var sync = RunManager.Instance.EventSynchronizer;
            int index = EventOptionIndex(button);
            if (sync.IsShared || sync.Events.Count != 1 || !ReferenceEquals(sync.Events[0], model)
                || !ReferenceEquals(GetInstanceFieldValue(sync, "_playerCollection"), entry.Run)
                || !Equals(GetInstanceFieldValue(sync, "_localPlayerId"), model.Owner!.NetId)
                || index < 0 || index >= model.CurrentOptions.Count || !ReferenceEquals(model.CurrentOptions[index], button.Option))
                throw new NotSupportedException("event_synchronizer_identity_unverified");
            // Native Chosen awaits whatever single callback the model supplied; a multicast Func<Task> returns only its last task.
            if (GetInstanceFieldValue(button.Option, "<OnChosen>k__BackingField") is not Delegate chosen || chosen.GetInvocationList().Length != 1)
                throw new NotSupportedException("event_option_callback_unverified");
        }
    }
    // Native layout index passed to NEventOptionButton.Create and EventSynchronizer.ChooseLocalOption; shared by snapshot and dispatch.
    private static int EventOptionIndex(NEventOptionButton button) => (int)GetInstanceFieldValue(button, "<Index>k__BackingField")!;
    private static void AddEventActions(Dictionary<string, object?> state, List<LegalAction> actions)
    {
        var entry = _eventEntry ?? throw new NotSupportedException("event_setup_unowned");
        RequireEventIdentity(entry);
        if (!EventInputsReady(entry)) { state["waiting"] = true; actions.Clear(); return; }
        int generation = entry.Generation;
        var layout = (NEventLayout)entry.Layout!;
        var dialogue = (layout as NAncientEventLayout)?.GetNodeOrNull<NClickableControl>("%DialogueHitbox");
        if (IsControlVisibleOrActionable(dialogue))
        {
            int line = (int)GetInstanceFieldValue(layout, "_currentDialogueLine")!;
            actions.Add(new("advance_dialogue", "Advance visible dialogue", () => DispatchOwnedTask(() =>
            {
                Action<object>? signal = null;
                void Released(NClickableControl source) => signal!(source);
                return BridgeProtocol.CaptureSynchronousSignal(dialogue!,
                    s => { signal = s; dialogue!.Released += Released; },
                    _ => { if (GodotObject.IsInstanceValid(dialogue)) dialogue!.Released -= Released; }, () => dialogue!.ForceClick(),
                    () => { RequireEventIdentity(entry); entry.RequireGeneration(generation); return OrdinaryInput(dialogue) && (int)GetInstanceFieldValue(layout, "_currentDialogueLine")! == line; },
                    () =>
                    {
                        RequireEventIdentity(entry);
                        bool last = (bool)typeof(NAncientEventLayout).GetProperty("IsDialogueOnLastLine", BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic)!.GetValue(layout)!;
                        bool optionsReady = !last || layout.OptionButtons.All(button => button.Option.IsLocked
                            || entry.InputReady(button, button.Option, generation, button.IsEnabled && button.MouseFilter == Control.MouseFilterEnum.Stop, true));
                        return entry.Generation == generation && BridgeProtocol.DialogueAdvanced(line, (int)GetInstanceFieldValue(layout, "_currentDialogueLine")!,
                            last, IsNodeVisible(dialogue!), dialogue!.IsEnabled, optionsReady) && (last || OrdinaryInput(dialogue));
                    });
            }), $"{dialogue!.GetInstanceId()}:{generation}:{line}"));
            return;
        }
        foreach (var button in layout.OptionButtons)
        {
            if (button.Option.IsLocked) continue;
            RequireEventOption(entry, button, generation); // Any unsupported alternative clears the entire observation.
            actions.Add(new($"choose_event_option:{EventOptionIndex(button)}", $"{SafeGetText(() => button.Option.Title)}: {SafeGetText(() => button.Option.Description)}",
                () => DispatchEventOption(entry, button, generation), $"{button.GetInstanceId()}:{generation}"));
        }
    }
    private static bool DispatchEventRewardChild(object screen, Func<Task> start)
    {
        var operation = _eventOperation ?? throw new NotSupportedException("event_reward_owner_unavailable");
        RequireEventIdentity(operation.Entry);
        if (!operation.OwnsScreen(screen) || !operation.CanDecide()) throw new NotSupportedException("event_reward_not_ready");
        using var selection = SelectionOwners.Enter(operation.Owner);
        using var context = EventScopes.Enter(new EventScope(operation, Screen: screen));
        operation.AddChild(start());
        return true;
    }

    private static bool DispatchEventOption(EventEntry entry, NEventOptionButton button, int generation)
    {
        RequireEventOption(entry, button, generation);
        var session = _bridgeSession;
        var operation = new EventOperation(new object(), entry, SelectionOwners);
        _eventOperation = operation; entry.ActiveOwner = operation.Owner;
        bool proceed = button.Option.IsProceed;
        var map = NMapScreen.Instance;
        session.Track(operation.Owner, Task.CompletedTask, Task.CompletedTask, () => operation.Root, () => false);
        session.HoldUntil(() => { RequireEventIdentity(entry); return operation.Poll() && (proceed ? map?.IsOpen == true : EventInputsReady(entry)); });
        session.OnRelease(() =>
        {
            operation.Close(); entry.ActiveOwner = null;
            if (session.Failure != null) entry.Fail(session.Failure);
            if (ReferenceEquals(_eventOperation, operation)) _eventOperation = null;
        });
        using var selection = SelectionOwners.Enter(operation.Owner);
        using var context = EventScopes.Enter(new EventScope(operation, Proceed: proceed ? button.Option : null));
        if (proceed)
        {
            Action<object>? signal = null;
            void Opened() => signal!(map!);
            BridgeProtocol.CaptureSynchronousSignal(map!, s => { signal = s; map!.Opened += Opened; },
                _ => { if (GodotObject.IsInstanceValid(map)) map!.Opened -= Opened; }, () => button.ForceClick(),
                () => !map!.IsOpen, () => { RequireOrdinaryMap((RunState)entry.Run, map!, true, entry.Move is ActOpening); return operation.Root != null && map!.IsOpen; });
        }
        else
        {
            var sync = RunManager.Instance.EventSynchronizer;
            if (!sync.Events.Contains((EventModel)entry.Model!) || GetInstanceFieldValue(sync, "_pendingOptionTasks") is not List<Task> tasks)
                throw new NotSupportedException("event_task_list_identity_unavailable");
            operation.Root = BridgeProtocol.CaptureAppendedTask(tasks, () => button.ForceClick());
        }
        return true;
    }
}
