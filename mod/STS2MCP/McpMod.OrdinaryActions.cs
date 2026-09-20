using System;
using System.Threading.Tasks;
using Godot;
using MegaCrit.Sts2.Core.Context;
using MegaCrit.Sts2.Core.Entities.Players;
using MegaCrit.Sts2.Core.Entities.RestSite;
using MegaCrit.Sts2.Core.Nodes.CommonUi;
using MegaCrit.Sts2.Core.Nodes.GodotExtensions;
using MegaCrit.Sts2.Core.Nodes.RestSite;
using MegaCrit.Sts2.Core.Nodes.Rooms;
using MegaCrit.Sts2.Core.Nodes.Screens.Map;
using MegaCrit.Sts2.Core.Nodes.Screens.Shops;
using MegaCrit.Sts2.Core.Runs;
using MegaCrit.Sts2.Core.Saves;

namespace STS2_MCP;

public static partial class McpMod
{
    private static OrdinaryRoomEntry? _restEntry;
    // v0.111 SelectOption returns without awaiting successful selection's AfterSelectingOptionAsync(...).RunSafely() work.
    // Retain that exact detached Task under the dispatched room/option; human selections carry no scope. A declined selection
    // skips this producer, waits a frame and re-enables options, so absence of a receipt alone is not failure.
    private static readonly SelectionOwnership RestScopes = new();
    private sealed class RestScope(object run, object player, object room, object button, object option)
    {
        internal readonly object Run = run, Player = player, Room = room, Button = button, Option = option;
        internal bool Captured;
        internal string? Failure;
    }

    private static bool DispatchRestOption(RunState run, Player player, NRestSiteRoom room, NRestSiteButton button)
    {
        var scope = new RestScope(run, player, room, button, button.Option);
        using var entered = RestScopes.Enter(scope);
        bool dispatched = DispatchUiTask(button, typeof(NRestSiteButton), "SelectOption", button.Option);
        _bridgeSession.HoldUntil(() => scope.Failure == null ? true : throw new NotSupportedException(scope.Failure));
        return dispatched;
    }

    private static void RestPostSelectPostfix(NRestSiteRoom __instance, RestSiteOption __0, Task __result)
    {
        if (RestScopes.CurrentOwner is not RestScope scope) return; // Foreign/human lane: never adopted, never blocked.
        try
        {
            if (scope.Captured || !ReferenceEquals(__instance, scope.Room) || !ReferenceEquals(__0, scope.Option)
                || !ReferenceEquals(((NRestSiteButton)scope.Button).Option, __0) || !ReferenceEquals(NRestSiteRoom.Instance, __instance))
                throw new NotSupportedException("rest_post_select_identity_unverified");
            scope.Captured = true;
            RequireRest((RunState)scope.Run, (Player)scope.Player, __instance);
            RetainOrdinaryWork(__result);
        }
        catch (Exception e) { scope.Failure ??= e is NotSupportedException ? e.Message : "rest_post_select_capture_failed"; }
    }

    private static bool OrdinaryBool(object receiver, string field)
        => GetInstanceFieldValue(receiver, field) is bool value ? value : throw new NotSupportedException("ordinary_field_unavailable:" + field);

    private static bool OrdinaryInput(NClickableControl? button)
    {
        if (!IsControlVisibleOrActionable(button)) return false;
        if (!BridgeProtocol.OrdinaryInput(true, true, (int)button!.MouseFilter, false, false, false))
            throw new NotSupportedException("ordinary_mouse_input_unverified"); // Do not prune a possibly hotkey-accessible choice.
        return true;
    }

    private static bool OrdinaryIdentity(RunState run, object? room, Player player)
        => room != null && ReferenceEquals(RunManager.Instance.DebugOnlyGetState(), run) && ReferenceEquals(run.CurrentRoom, room)
            && ReferenceEquals(LocalContext.GetMe(run), player);

    private static void RequireShop(NMerchantRoom room, Player player)
    {
        BridgeProtocol.RequireOrdinaryTutorial(SaveManager.Instance.SeenFtue("merchant_ftue"), "merchant_ftue");
        if (room.Inventory.Inventory == null) throw new NotSupportedException("merchant_inventory_unavailable");
        if (room.Inventory.MouseFilter != (room.Inventory.IsOpen ? Control.MouseFilterEnum.Stop : Control.MouseFilterEnum.Ignore))
            throw new NotSupportedException("merchant_input_filter_unverified");
        if (OrdinaryBool(room.Inventory, "_isInputBlocked")
            || GetInstanceFieldValue(room.Inventory, "_inputBlocker") is not Control blocker || blocker.MouseFilter != Control.MouseFilterEnum.Ignore)
            throw new NotSupportedException("merchant_input_blocked");
        if (!BridgeProtocol.OrdinaryInput(true, true, 0, false, OrdinaryBool(room.MerchantButton, "_focusedWhileTargeting"),
            room.MerchantButton.IsLocalPlayerDead || player.Creature.IsDead))
            throw new NotSupportedException("merchant_targeting_or_dead");
    }

    private static void RequireRest(RunState run, Player player, NRestSiteRoom room)
    {
        // Captured at owned NodeAdded before _Ready, never from a later seen flag or room observation.
        if (_restEntry == null || !ReferenceEquals(GetInstanceFieldValue(room, "_room"), run.CurrentRoom))
            throw new NotSupportedException("rest_entry_readiness_unverified");
        _restEntry.Require(run, run.CurrentRoom, room, player);
        if (player.Creature.IsDead || OrdinaryBool(room, "_roomExiting")) throw new NotSupportedException("rest_input_unavailable");
    }

    private static void RequireOrdinaryMap(RunState run, NMapScreen map, bool requireTravel = true, bool ownedActOpening = false)
    {
        bool startsAct = run.CurrentActIndex == 0 && run.ExtraFields.StartedWithNeow ? run.ActFloor == 1 : run.ActFloor == 0;
        // StartOfActAnim has an unowned MapFtueCheck tail. Do not equate _hasPlayedAnimation with completion.
        BridgeProtocol.RequireOrdinaryTutorial(SaveManager.Instance.SeenFtue("map_select_ftue"), "map_select_ftue");
        // Only the owned fresh ActOpening's finished-Neow Proceed passes ownedActOpening (BridgeProtocol.InitialOpeningProceed).
        bool cosmeticStart = BridgeProtocol.InitialOpeningProceed(ownedActOpening, run.CurrentActIndex, run.ExtraFields.StartedWithNeow, run.ActFloor);
        BridgeProtocol.RequireOrdinaryMap(OrdinaryBool(map, "_isInputDisabled"), map.IsTraveling,
            startsAct && !cosmeticStart, GetInstanceFieldValue(map, "_actAnimTween") != null && !cosmeticStart);
        if (!ReferenceEquals(GetInstanceFieldValue(map, "_runState"), run) || requireTravel && !map.IsTravelEnabled)
            throw new NotSupportedException("ordinary_map_receiver_unavailable");
    }

    private static void AddOrdinaryProceed(System.Collections.Generic.List<LegalAction> actions, RunState run, Player player,
        Node room, NProceedButton button, Action requireRoom)
    {
        if (!OrdinaryInput(button)) return;
        requireRoom();
        var map = NMapScreen.Instance ?? throw new NotSupportedException("ordinary_map_unavailable");
        RequireOrdinaryMap(run, map);
        if (map.IsOpen) throw new NotSupportedException("ordinary_map_already_open");
        var modelRoom = run.CurrentRoom;
        actions.Add(new("proceed", "Leave room", () => DispatchOwnedTask(() =>
        {
            Action<object>? signal = null;
            void Opened() => signal!(map);
            bool Identity() => OrdinaryIdentity(run, modelRoom, player) && ReferenceEquals(NMapScreen.Instance, map)
                && (room is NMerchantRoom merchant ? ReferenceEquals(NMerchantRoom.Instance, merchant) && ReferenceEquals(merchant.ProceedButton, button)
                    : room is NRestSiteRoom rest && ReferenceEquals(NRestSiteRoom.Instance, rest) && ReferenceEquals(rest.ProceedButton, button));
            return BridgeProtocol.CaptureSynchronousSignal(map,
                s => { signal = s; map.Opened += Opened; },
                _ => { if (GodotObject.IsInstanceValid(map)) map.Opened -= Opened; },
                () => button.ForceClick(),
                () => { requireRoom(); RequireOrdinaryMap(run, map); return Identity() && !map.IsOpen && OrdinaryInput(button); },
                () => { RequireOrdinaryMap(run, map); return Identity() && map.IsOpen; });
        }), button.GetInstanceId().ToString()));
    }

    private static bool DispatchShopToggle(RunState run, Player player, NMerchantRoom room, bool open)
    {
        var inventory = room.Inventory;
        var merchant = room.MerchantButton;
        var proceed = room.ProceedButton;
        var inventoryModel = inventory.Inventory ?? throw new NotSupportedException("merchant_inventory_unavailable");
        var back = GetInstanceFieldValue(inventory, "_backButton") as NBackButton
            ?? throw new NotSupportedException("merchant_back_unavailable");
        NClickableControl button = open ? merchant : back;
        var modelRoom = run.CurrentRoom;
        return DispatchOwnedTask(() =>
        {
            Action<object>? signal = null;
            void Opened(NMerchantButton source) => signal!(source);
            void Closed() => signal!(inventory);
            bool Identity() => OrdinaryIdentity(run, modelRoom, player) && ReferenceEquals(room.Room, modelRoom)
                && ReferenceEquals(NMerchantRoom.Instance, room) && ReferenceEquals(room.Inventory, inventory)
                && ReferenceEquals(room.MerchantButton, merchant) && ReferenceEquals(room.ProceedButton, proceed)
                && ReferenceEquals(inventory.Inventory, inventoryModel) && ReferenceEquals(GetInstanceFieldValue(inventory, "_backButton"), back);
            return BridgeProtocol.CaptureSynchronousSignal(open ? merchant : inventory,
                s => { signal = s; if (open) merchant.MerchantOpened += Opened; else inventory.InventoryClosed += Closed; },
                _ => { if (open) { if (GodotObject.IsInstanceValid(merchant)) merchant.MerchantOpened -= Opened; }
                    else if (GodotObject.IsInstanceValid(inventory)) inventory.InventoryClosed -= Closed; },
                () => button.ForceClick(),
                () => { RequireShop(room, player); return Identity() && inventory.IsOpen != open && OrdinaryInput(button)
                    && inventory.MouseFilter == (open ? Control.MouseFilterEnum.Ignore : Control.MouseFilterEnum.Stop); },
                () =>
                {
                    RequireShop(room, player);
                    return Identity() && inventory.IsOpen == open
                        && inventory.MouseFilter == (open ? Control.MouseFilterEnum.Stop : Control.MouseFilterEnum.Ignore)
                        && (open ? OrdinaryInput(back) && !merchant.IsEnabled && !proceed.IsEnabled
                            : !back.IsEnabled && OrdinaryInput(merchant) && OrdinaryInput(proceed));
                });
        });
    }
}
