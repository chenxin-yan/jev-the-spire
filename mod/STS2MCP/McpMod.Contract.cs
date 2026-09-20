using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Threading.Tasks;
using MegaCrit.Sts2.Core.GameActions;
using MegaCrit.Sts2.Core.Entities.Actions;
using Godot;
using MegaCrit.Sts2.Core.Combat;
using MegaCrit.Sts2.Core.Context;
using MegaCrit.Sts2.Core.Entities.Cards;
using MegaCrit.Sts2.Core.Entities.Creatures;
using MegaCrit.Sts2.Core.Entities.Players;
using MegaCrit.Sts2.Core.Entities.Potions;
using MegaCrit.Sts2.Core.Models;
using MegaCrit.Sts2.Core.Nodes.Combat;
using MegaCrit.Sts2.Core.Nodes.Rooms;
using MegaCrit.Sts2.Core.Nodes.GodotExtensions;
using MegaCrit.Sts2.Core.Nodes.Screens.Map;
using MegaCrit.Sts2.Core.Nodes.Screens;
using MegaCrit.Sts2.Core.Nodes.Screens.CardSelection;
using MegaCrit.Sts2.Core.Nodes.Screens.Overlays;
using MegaCrit.Sts2.Core.Nodes.Screens.GameOverScreen;
using MegaCrit.Sts2.Core.Runs;
using MegaCrit.Sts2.Core.Saves;
using MegaCrit.Sts2.Core.Multiplayer.Game;

namespace STS2_MCP;

public static partial class McpMod
{
    private static readonly BridgeSession _bridgeSession = new();

    private sealed record LegalAction(string Label, string Description,
        [property: JsonIgnore] Func<bool> Dispatch, [property: JsonIgnore] string Identity);
    private sealed record Observation(Dictionary<string, object?> State, List<LegalAction> Actions,
        SelectionOwnership.Lease? Selection = null);

    // Null means allowed. The network service is read only after run presence, never on a no-run menu.
    private static string? ContextHalt()
    {
        var saves = SaveManager.Instance;
        var manager = RunManager.Instance;
        return BridgeProtocol.ContextHalt(UserDataPathProvider.IsRunningModded,
            saves.IsProfileInitialized, saves.IsProfileInitialized ? saves.CurrentProfileId : 0,
            manager.IsInProgress, () => manager.NetService?.Type.IsMultiplayer());
    }

    // Both observation and dispatch call this on the main thread, before accessing player data.
    private static Observation CaptureObservation()
    {
        try { return CaptureObservationCore(); }
        catch (Exception e)
        {
            // Never expose a partial observation with an apparently complete action set.
            return FinishObservation(HaltState($"observation_unavailable:{e.GetType().Name}:{e.Message}"), new(), "");
        }
    }

    private static Observation CaptureObservationCore()
    {
        Dictionary<string, object?> state;
        var actions = new List<LegalAction>();
        string identity = "";
        string? contextHalt = ContextHalt();
        bool allowed = contextHalt == null;
        if (allowed)
        {
            if (_bridgeSession.OperationOwner is { } owner && SelectionOwners.Failed(owner))
                _bridgeSession.Fail("selection_failed");
            _bridgeSession.Refresh();
        }
        else if (_bridgeSession.Pending) _bridgeSession.Dispose();
        var rawOverlay = allowed ? NOverlayStack.Instance?.Peek() : null;
        var selection = allowed ? ResolveObservationSelection(rawOverlay, rawOverlay?.GetType(), IsMapScreenOpenOrVisible(),
            NPlayerHand.Instance?.IsInCardSelection == true ? NPlayerHand.Instance : _treasureOperation?.Scene, _bridgeSession, SelectionOwners,
            _combatExit?.Map is { } mapReceiver && ReferenceEquals(mapReceiver, NMapScreen.Instance) ? mapReceiver : null) : null;
        if (!allowed)
            state = HaltState(contextHalt!);
        else if (_bridgeSession.Failure != null)
            state = HaltState(_bridgeSession.Failure);
        else if (selection?.Stop is { } stop)
            state = stop;
        else
        {
            var manager = RunManager.Instance;
            var run = manager.DebugOnlyGetState();
            var root = ((SceneTree)Engine.GetMainLoop()).Root;
            var overlay = selection!.Overlay;
            var player = run == null ? null : LocalContext.GetMe(run);
            var capstone = MegaCrit.Sts2.Core.Nodes.Screens.Capstones.NCapstoneContainer.Instance?.CurrentCapstoneScreen;
            if (GetOpenModalNode() != null || IsAnyFtueVisible(root)
                || (capstone != null && capstone is not NMapScreen))
                state = HaltState("blocking_modal_or_tutorial");
            else if (overlay is NGameOverScreen gameOver)
                state = new() { ["state_type"] = "game_over", ["terminal"] = true,
                    ["visible_text"] = ReadVisibleText(gameOver), ["seed"] = run?.Rng.StringSeed };
            else if (!manager.IsInProgress || run == null || player == null)
                state = HaltState("no_active_run");
            else if (overlay is MegaCrit.Sts2.Core.Nodes.Events.Custom.CrystalSphere.NCrystalSphereScreen)
                state = HaltState("crystal_sphere_contract_incomplete");
            else if (overlay != null && overlay is not (NRewardsScreen or NCardRewardSelectionScreen
                or NChooseACardSelectionScreen or NCardGridSelectionScreen
                or NChooseABundleSelectionScreen or NChooseARelicSelection))
                state = HaltState($"unsupported_overlay:{overlay.GetType().Name}");
            else
            {
                identity = RuntimeHelpers.GetHashCode(run).ToString();
                // BuildGameState owns effective phase precedence, including rewards lingering below the map.
                state = BuildGameState();
                bool map = state["state_type"] is "map";
                bool combat = CombatManager.Instance.IsInProgress;
                if (map && combat)
                    state = HaltState("combat_map_overlay_contract_incomplete");
                else
                {
                    state["seed"] = run.Rng.StringSeed;
                    state["terminal"] = false;
                    bool busy = manager.ActionExecutor.CurrentlyRunningAction != null || !manager.ActionQueueSet.IsEmpty;
                    bool selecting = state["state_type"] is "card_select" or "card_reward" or "bundle_select" or "relic_select" or "hand_select" or "rewards";
                    state["waiting"] = BridgeProtocol.IsWaiting(state["state_type"]?.ToString() ?? "unknown", busy,
                        run.CurrentRoom is MegaCrit.Sts2.Core.Rooms.CombatRoom, combat,
                        IsPlayPhase(player) && !CombatManager.Instance.PlayerActionsDisabled
                        && NPlayerHand.Instance?.InCardPlay == false
                        && NPlayerHand.Instance?.CurrentMode == NPlayerHand.Mode.Play);
                    if (!busy && map)
                    {
                        var screen = NMapScreen.Instance!;
                        var points = FindAll<NMapPoint>(screen)
                            .Where(p => p.State == MegaCrit.Sts2.Core.Map.MapPointState.Travelable && p.Point != null && IsReadableCanvas(p))
                            .OrderBy(p => p.Point!.coord.col).ToList();
                        for (int i = 0; i < points.Count; i++)
                        {
                            var point = points[i];
                            actions.Add(new($"choose_map_node:{i}",
                                $"Travel to {point.Point!.PointType} at ({point.Point.coord.col},{point.Point.coord.row})",
                                () => DispatchMap(screen, point, run, player),
                                point.GetInstanceId().ToString()));
                        }
                    }
                    else if (!selecting && !busy && combat && IsPlayPhase(player) && !CombatManager.Instance.PlayerActionsDisabled
                        && player.Creature.IsAlive && NPlayerHand.Instance is { InCardPlay: false } hand
                        && hand.CurrentMode == NPlayerHand.Mode.Play)
                    {
                        try { AddCombatActions(player, actions); }
                        catch (NotSupportedException e) { state = HaltState(e.Message); }
                    }
                    try
                    {
                        if (!state.ContainsKey("halt_reason"))
                        {
                            if (!map && state["waiting"] is false && (!combat || selecting))
                                AddNonCombatActions(state, run, player, root, actions);
                            if (state["waiting"] is false && (!_bridgeSession.Pending
                                || selection?.Lease is { } rewardLease && (_combatExit?.OwnsDecision(rewardLease.Selector) == true
                                    || _eventOperation?.OwnsScreen(rewardLease.Selector) == true || _treasureOperation?.OwnsDecision(rewardLease.Selector) == true)))
                                AddPotionActions(player, root, NPlayerHand.Instance?.IsInCardSelection == true
                                    || overlay is MegaCrit.Sts2.Core.Nodes.Screens.CardSelection.ICardSelector, actions);
                        }
                    }
                    catch (NotSupportedException e) { state = HaltState(e.Message); }
                }
            }
        }
        var lease = selection?.Lease;
        if (lease != null) identity += ":selection:" + lease.Generation;
        return FinishObservation(state, actions, identity) with { Selection = lease };
    }

    // Shared with BuildGameState. Type is explicit so the production gate can be checked without constructing Godot nodes.
    private static object? ForegroundOverlay(object? overlay, Type? type, bool mapOpen)
        => mapOpen && type != null && (typeof(NRewardsScreen).IsAssignableFrom(type)
            || typeof(NCardRewardSelectionScreen).IsAssignableFrom(type)
            || typeof(MegaCrit.Sts2.Core.Nodes.Events.Custom.CrystalSphere.NCrystalSphereScreen).IsAssignableFrom(type)) ? null : overlay;

    private sealed record SelectionObservation(object? Overlay, SelectionOwnership.Lease? Lease, Dictionary<string, object?>? Stop);

    private static SelectionObservation ResolveObservationSelection(object? overlay, Type? type, bool mapOpen,
        object? selectingHand, BridgeSession session, SelectionOwnership registry, object? ownedMap = null)
    {
        var foreground = ForegroundOverlay(overlay, type, mapOpen);
        object? selector = foreground != null && type != null && (typeof(ICardSelector).IsAssignableFrom(type)
            || typeof(NCardRewardSelectionScreen).IsAssignableFrom(type) || typeof(NChooseABundleSelectionScreen).IsAssignableFrom(type)
            || typeof(NChooseARelicSelection).IsAssignableFrom(type) || typeof(NRewardsScreen).IsAssignableFrom(type)) ? foreground
                : foreground == null && mapOpen ? ownedMap : foreground == null ? selectingHand : null;
        var lease = selector == null ? null : registry.Find(selector, session.OperationOwner);
        // A dispatched event option may open a surface the bridge cannot own (custom minigame, game over):
        // the existing overlay diagnostics must report it rather than waiting on the pending root forever.
        bool unownedEventSurface = foreground != null && selector == null
            && _eventOperation is { } pendingEvent && ReferenceEquals(session.OperationOwner, pendingEvent.Owner);
        var stop = selector != null && lease == null ? HaltState("unowned_selection_continuation")
            : session.Pending && !unownedEventSurface && (selector == null || lease?.Ready() == false) ? !session.HasCompletion ? HaltState("mutation_completion_unverified")
                : new Dictionary<string, object?> { ["state_type"] = "waiting", ["waiting"] = true, ["terminal"] = false } : null;
        return new(foreground, lease, stop);
    }

    private static Observation FinishObservation(Dictionary<string, object?> state, List<LegalAction> actions, string identity)
    {
        // An incomplete required action invalidates the entire choice set, including earlier entries.
        if (state.ContainsKey("halt_reason")) actions.Clear();
        // Keep nulls during validation: HTTP's WhenWritingNull must not hide a missing rule.
        BridgeProtocol.ValidateRulesText(JsonSerializer.SerializeToElement(state));
        state["legal_actions_complete"] = !state.ContainsKey("halt_reason")
            && !(state.TryGetValue("waiting", out var waiting) && waiting is true);
        state["legal_actions"] = actions;
        // Private identities prevent identical-looking cards/entities from aliasing at dispatch.
        // They are not strategy context and never leave the bridge.
        string fingerprint = JsonSerializer.Serialize(state, _jsonOptions) + identity
            + string.Join("|", actions.Select(a => a.Identity));
        state["state_version"] = _bridgeSession.Observe(fingerprint);
        state["mutation_pending"] = _bridgeSession.Pending;
        return new(state, actions);
    }

    private static HashSet<Creature> VisibleCreatures()
        => FindAll<NCreature>(((SceneTree)Engine.GetMainLoop()).Root)
            .Where(n => IsReadableCanvas(n) && IsReadableCanvas(n.Visuals)).Select(n => n.Entity).ToHashSet();

    private static bool IsReadableCanvas(CanvasItem item)
    {
        if (!IsNodeVisible(item) || item.SelfModulate.A <= 0) return false;
        for (Node? node = item; node != null; node = node.GetParent())
            if (node is CanvasItem canvas && canvas.Modulate.A <= 0) return false;
        return true;
    }

    private static string ReadVisibleText(Node root)
        => string.Join("\n", FindAll<MegaCrit.Sts2.addons.mega_text.MegaLabel>(root)
            .Where(IsReadableCanvas).Select(n => StripRichTextTags(n.Text))
            .Concat(FindAll<MegaCrit.Sts2.addons.mega_text.MegaRichTextLabel>(root)
                .Where(IsReadableCanvas).Select(n => StripRichTextTags(n.Text))));

    private static Dictionary<string, object?> HaltState(string reason)
        => new() { ["state_type"] = "unsupported", ["halt_reason"] = reason, ["terminal"] = false };

    private static void AddCombatActions(Player player, List<LegalAction> actions)
    {
        var combat = player.Creature.CombatState!;
        var visible = VisibleCreatures();
        var cards = player.PlayerCombatState!.Hand.Cards;
        for (int i = 0; i < cards.Count; i++)
        {
            var card = cards[i];
            if (!card.CanPlay()) continue;
            if (card.TargetType is TargetType.Osty or TargetType.TargetedNoCreature)
                throw new NotSupportedException("Unsupported card targeting; halt instead of pruning");
            IEnumerable<Creature?> targets = card.TargetType switch
            {
                TargetType.AnyEnemy => combat.Enemies.Where(c => c.IsAlive).Cast<Creature?>(),
                TargetType.AnyAlly => combat.PlayerCreatures.Where(c => c.IsAlive && c != player.Creature).Cast<Creature?>(),
                _ => new Creature?[] { null }
            };
            foreach (var target in targets)
            {
                if (!card.CanPlayTargeting(target) || (target != null && !visible.Contains(target))) continue;
                string label = $"play_card:{i}:" + (target?.CombatId.ToString() ?? "none");
                string description = $"Play hand[{i}] {SafeGetText(() => card.Title)}"
                    + (target == null ? "" : $" targeting {SafeGetText(() => target.Monster?.Title) ?? "player"} ({target.CombatId})");
                actions.Add(new(label, description, () => DispatchCard(card, target),
                    $"card:{RuntimeHelpers.GetHashCode(card)}:{target?.CombatId}"));
            }
        }
        var end = FindFirst<NEndTurnButton>(NCombatRoom.Instance!);
        // CanTurnBeEnded is private in v0.111; its IL checks InCardPlay/Mode.Play, guarded above.
        if (IsControlVisibleOrActionable(end) && NativeCanEndTurn(end!) && !CombatManager.Instance.IsPlayerReadyToEndTurn(player))
            actions.Add(new("end_turn", "End turn", () => DispatchEndTurn(end!, player), end!.GetInstanceId().ToString()));

    }

    private static bool DispatchCard(CardModel card, Creature? target)
    {
        // Exact v0.111 TryManualPlay -> EnqueueManualPlay sequence, retaining what that wrapper drops.
        if (!card.CanPlayTargeting(target)) return false;
        Task visual = card.OnEnqueuePlayVfx(target);
        var action = new PlayCardAction(card, target);
        TrackGameAction(_bridgeSession, action, visual);
        RunManager.Instance.ActionQueueSynchronizer.RequestEnqueue(action);
        return true;
    }

    private static void TrackGameAction(BridgeSession session, GameAction action, Task visual)
    {
        // Cancel() can be followed by Execute's finally changing Canceled -> Finished.
        // Subscribe before enqueue; polling State alone loses that transient cancellation.
        if (TrackRewardChildAction(session, action, visual)) return;
        session.TrackCancellable(action, action.CompletionTask, visual,
            () => GetInstanceFieldValue(action, "_executionTask") as Task,
            () => action.State == GameActionState.Canceled,
            handler => action.BeforeCancelled += handler,
            handler => action.BeforeCancelled -= handler);
        session.OnRelease(() => SelectionOwners.CloseOwner(action));
        SelectionOwners.RegisterContext(action, action);
        RegisterCombatExit(session, action);
    }

    private static (int Code, object Body) DispatchLabel(string version, string label)
    {
        var current = CaptureObservation();
        if (current.State.ContainsKey("halt_reason"))
            return (409, new { status = "rejected", error = current.State["halt_reason"] });
        var labels = current.Actions.Select(a => a.Label).ToArray();
        int rejection = current.Selection is { } child
            ? SelectionOwners.IsCurrent(child, _bridgeSession.OperationOwner)
                ? _bridgeSession.AcceptChild(version, label, labels, child.Owner!) : 409
            : _bridgeSession.Accept(version, label, labels);
        if (rejection != 0)
            return (rejection, new { status = "rejected", error = "stale, pending, or unknown action" });
        var action = current.Actions.Single(a => a.Label == label);
        // Freshness comparison, consumption and callback are one main-thread critical section.
        bool dispatched;
        try
        {
            using var rewardScope = current.Selection is { } selected && _combatExit?.OwnsDecision(selected.Selector) == true
                ? BeginRewardCapture(_combatExit, 3, selected.Selector, null, false) : null;
            using var eventScope = current.Selection is { } eventSelected && _eventOperation is { } eventOp
                && ReferenceEquals(eventSelected.Owner, eventOp.Owner)
                ? EventScopes.Enter(new EventScope(eventOp, Screen: eventOp.OwnsScreen(eventSelected.Selector) ? eventSelected.Selector : null)) : null;
            using var treasureScope = current.Selection is { } treasureSelected && _treasureOperation is { } treasureOp
                && ReferenceEquals(treasureSelected.Owner, treasureOp.Owner)
                ? TreasureScopes.Enter(new TreasureScope(treasureOp, Screen: treasureOp.OwnsDecision(treasureSelected.Selector) ? treasureSelected.Selector : null)) : null;
            dispatched = action.Dispatch();
        }
        catch
        {
            _bridgeSession.Fail("mutation_dispatch_failed");
            throw;
        }
        if (!dispatched) _bridgeSession.Fail("mutation_dispatch_rejected");
        return dispatched
            ? (202, new { status = "dispatched", state_version = version, label })
            : (409, new { status = "rejected", error = "Game rejected dispatch; halt" });
    }
}
