using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using Godot;
using MegaCrit.Sts2.Core.CardSelection;
using MegaCrit.Sts2.Core.Combat;
using MegaCrit.Sts2.Core.Commands;
using MegaCrit.Sts2.Core.Entities.Cards;
using MegaCrit.Sts2.Core.Entities.Creatures;
using MegaCrit.Sts2.Core.Entities.Players;
using MegaCrit.Sts2.Core.Entities.Merchant;
using MegaCrit.Sts2.Core.Hooks;
using MegaCrit.Sts2.Core.Entities.Potions;
using MegaCrit.Sts2.Core.Models;
using MegaCrit.Sts2.Core.Nodes.Cards;
using MegaCrit.Sts2.Core.Nodes.Cards.Holders;
using MegaCrit.Sts2.Core.Nodes.CommonUi;
using MegaCrit.Sts2.Core.Nodes.Combat;
using MegaCrit.Sts2.Core.Nodes.Events;
using MegaCrit.Sts2.Core.Nodes.GodotExtensions;
using MegaCrit.Sts2.Core.Nodes.Potions;
using MegaCrit.Sts2.Core.Nodes.RestSite;
using MegaCrit.Sts2.Core.Nodes.Rooms;
using MegaCrit.Sts2.Core.Nodes.Rewards;
using MegaCrit.Sts2.Core.Nodes.Relics;
using MegaCrit.Sts2.Core.Rewards;
using MegaCrit.Sts2.Core.Nodes.Screens;
using MegaCrit.Sts2.Core.Nodes.Screens.CardSelection;
using MegaCrit.Sts2.Core.Nodes.Screens.Overlays;
using MegaCrit.Sts2.Core.Nodes.Screens.Shops;
using MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic;
using MegaCrit.Sts2.Core.Runs;

namespace STS2_MCP;

public static partial class McpMod
{
    private static void AddClick(List<LegalAction> actions, string label, string description, NClickableControl? button)
    {
        if (IsControlVisibleOrActionable(button))
        {
            // An unsupported required choice invalidates the whole observation, never a pruned legal set.
            BridgeProtocol.RequireClickCompletion(label, _bridgeSession.Pending && _bridgeSession.OperationOwner != null);
            actions.Add(new(label, description, () => { button!.ForceClick(); return true; }, button!.GetInstanceId().ToString()));
        }
    }

    private static void AddCardClick(List<LegalAction> actions, string label, string description, NCardHolder holder)
    {
        // NCardHolder.EmitPressed is gated by this field in the shipped UI.
        if (GetInstanceFieldValue(holder, "_isClickable") is not bool clickable)
            throw new NotSupportedException("card_holder_clickability_unavailable");
        if (clickable && IsNodeVisible(holder) && IsControlVisibleOrActionable(holder.Hitbox))
            actions.Add(new(label, description, () => { holder.EmitSignal(NCardHolder.SignalName.Pressed, holder); return true; },
                $"{holder.GetInstanceId()}:{RuntimeHelpers.GetHashCode(holder.CardModel)}"));
    }

    private static void AddNonCombatActions(Dictionary<string, object?> state, RunState run, Player player,
        Node root, List<LegalAction> actions)
    {
        var overlay = NOverlayStack.Instance?.Peek();
        string phase = state["state_type"]?.ToString() ?? "unknown";
        switch (phase)
        {
            case "event":
            {
                AddEventActions(state, actions);
                break;
            }
            case "shop":
                AddShopActions(run, player, actions);
                break;
            case "rest_site":
            {
                var room = NRestSiteRoom.Instance!;
                RequireRest(run, player, room);
                var buttons = FindAll<NRestSiteButton>(room);
                // Native AnimateIn window: visible and IsEnabled but mouse Ignore until the fade ends (live full-3 :233).
                // Wait for the whole set rather than halting on OrdinaryInput or exposing a partial decision.
                if (BridgeProtocol.RestOptionsInputDisabled(buttons.Select(b => (int)b.MouseFilter)))
                {
                    state["waiting"] = true;
                    break;
                }
                for (int i = 0; i < buttons.Count; i++)
                {
                    var button = buttons[i];
                    if (button.Option.IsEnabled && GetInstanceFieldValue(button, "_isUnclickable") is false
                        && OrdinaryInput(button))
                        actions.Add(new($"choose_rest_option:{i}", $"{SafeGetText(() => button.Option.Title)}: {SafeGetText(() => button.Option.Description)}",
                            () => DispatchRestOption(run, player, room, button), button.GetInstanceId().ToString()));
                }
                AddOrdinaryProceed(actions, run, player, room, room.ProceedButton, () => RequireRest(run, player, room));
                break;
            }
            case "treasure":
            {
                AddTreasureActions(state, run, player, actions);
                break;
            }
            case "rewards" when overlay is NRewardsScreen rewards:
            {
                if (_combatExit?.OwnsScreen(rewards) != true && _eventOperation?.OwnsScreen(rewards) != true && _treasureOperation?.OwnsScreen(rewards) != true)
                    throw new NotSupportedException("unowned_rewards_decision");
                bool terminal = GetInstanceFieldValue(rewards, "_isTerminal") is true;
                var proceed = FindFirst<NProceedButton>(rewards);
                BridgeProtocol.RequireRewardProceed(terminal,
                    run.CurrentRoom?.RoomType == MegaCrit.Sts2.Core.Rooms.RoomType.Boss || run.CurrentRoom?.IsVictoryRoom == true,
                    proceed?.IsSkip == true, !terminal || proceed?.IsSkip != true || MegaCrit.Sts2.Core.TestSupport.TestMode.IsOn
                        || MegaCrit.Sts2.Core.Saves.SaveManager.Instance.SeenFtue("combat_reward_ftue"),
                    GetInstanceFieldValue(RunManager.Instance, "debugAfterCombatRewardsOverride") != null);
                if (FindAll<NLinkedRewardSet>(rewards).Any(IsNodeVisible)) throw new NotSupportedException("linked_reward_contract_incomplete");
                var buttons = FindAll<NRewardButton>(rewards);
                for (int i = 0; i < buttons.Count; i++)
                {
                    var item = buttons[i].Reward;
                    if (item == null || item.SuccessfullySelected) continue;
                    if (item is PotionReward potion && !CanProcurePotion(player, potion.Potion)) continue;
                    var button = buttons[i];
                    if (IsControlVisibleOrActionable(button))
                        actions.Add(new($"claim_reward:{i}", SafeGetText(() => item.Description) ?? "Claim reward",
                            () => DispatchUiTask(button, typeof(NRewardButton), "GetReward"), button.GetInstanceId().ToString()));
                }
                if (IsControlVisibleOrActionable(proceed))
                    actions.Add(new("proceed", "Leave rewards", () => _treasureOperation?.OwnsScreen(rewards) == true
                        ? DispatchTreasureRewardChild(rewards, () => { proceed!.ForceClick(); return System.Threading.Tasks.Task.CompletedTask; })
                        : _eventOperation?.OwnsScreen(rewards) == true
                        ? DispatchEventRewardChild(rewards, () => { proceed!.ForceClick(); return System.Threading.Tasks.Task.CompletedTask; })
                        : DispatchRewardProceed(rewards, proceed!), proceed!.GetInstanceId().ToString()));
                break;
            }
            case "card_reward" when overlay is NCardRewardSelectionScreen reward:
            {
                var holders = FindAllSortedByPosition<NCardHolder>(reward);
                // Skip is already native-clickable during the initial card-input disable; that alternative-only set
                // is not a ready reward decision. Wait under the retained owner until takes and Skip are exposed together.
                if (BridgeProtocol.RewardCardsInputDisabled(holders.Where(h => h.CardModel != null)
                        .Select(h => GetInstanceFieldValue(h, "_isClickable") as bool?)))
                {
                    state["waiting"] = true;
                    break;
                }
                for (int i = 0; i < holders.Count; i++)
                    AddCardClick(actions, $"select_card_reward:{i}", $"Take {SafeGetText(() => holders[i].CardModel?.Title)}", holders[i]);
                var alternatives = FindAll<NCardRewardAlternativeButton>(reward);
                for (int i = 0; i < alternatives.Count; i++)
                {
                    var button = alternatives[i];
                    var label = GetInstanceFieldValue(button, "_label") as Node;
                    if (label == null) throw new NotSupportedException("reward_alternative_text_unavailable");
                    AddClick(actions, $"card_reward_alternative:{i}", StripRichTextTags(label.Get("text").AsString()), button);
                }
                break;
            }
            case "card_select" when overlay is NChooseACardSelectionScreen choose:
            {
                var holders = FindAllSortedByPosition<NGridCardHolder>(choose);
                for (int i = 0; i < holders.Count; i++)
                    AddCardClick(actions, $"select_card:{i}", $"Choose {SafeGetText(() => holders[i].CardModel?.Title)}", holders[i]);
                AddClick(actions, "cancel_selection", "Skip card choice", choose.GetNodeOrNull<NClickableControl>("SkipButton"));
                break;
            }
            case "card_select" when overlay is NCardGridSelectionScreen grid:
                AddGridActions(state, grid, actions);
                break;
            case "bundle_select" when overlay is NChooseABundleSelectionScreen bundleScreen:
            {
                var preview = bundleScreen.GetNodeOrNull<Control>("%BundlePreviewContainer");
                if (preview?.Visible != true)
                {
                    var bundles = FindAll<NCardBundle>(bundleScreen);
                    for (int i = 0; i < bundles.Count; i++)
                        AddClick(actions, $"select_bundle:{i}", $"Select bundle[{i}]: {ReadVisibleText(bundles[i])}", bundles[i].Hitbox);
                }
                AddClick(actions, "confirm_bundle_selection", "Take selected bundle", bundleScreen.GetNodeOrNull<NConfirmButton>("%Confirm"));
                AddClick(actions, "cancel_bundle_selection", "Cancel bundle preview", bundleScreen.GetNodeOrNull<NBackButton>("%Cancel"));
                break;
            }
            case "relic_select" when overlay is NChooseARelicSelection relicScreen:
            {
                var holders = FindAll<NRelicBasicHolder>(relicScreen);
                for (int i = 0; i < holders.Count; i++)
                    AddClick(actions, $"select_relic:{i}", $"Take {SafeGetText(() => holders[i].Relic?.Model?.Title)}", holders[i]);
                AddClick(actions, "skip_relic_selection", "Skip relic choice", relicScreen.GetNodeOrNull<NClickableControl>("SkipButton"));
                break;
            }
            case "hand_select":
                AddHandSelection(state, NPlayerHand.Instance!, actions);
                break;
            default:
                throw new NotSupportedException($"legal_action_contract_incomplete:{phase}");
        }
    }

    private static void AddShopActions(RunState run, Player player, List<LegalAction> actions)
    {
        var room = NMerchantRoom.Instance;
        if (room == null) throw new NotSupportedException("fake_merchant_contract_incomplete");
        if (!ReferenceEquals(room.Room, run.CurrentRoom)) throw new NotSupportedException("merchant_room_identity_unavailable");
        RequireShop(room, player);
        var inventory = room.Inventory;
        if (!inventory.IsOpen)
        {
            if (OrdinaryInput(room.MerchantButton))
                actions.Add(new("open_shop", "Open merchant inventory", () => DispatchShopToggle(run, player, room, true), room.MerchantButton.GetInstanceId().ToString()));
            AddOrdinaryProceed(actions, run, player, room, room.ProceedButton, () => RequireShop(room, player));
            return;
        }
        var model = inventory.Inventory ?? throw new NotSupportedException("merchant_inventory_unavailable");
        var entries = model.AllEntries.ToList();
        foreach (var slot in FindAll<NMerchantSlot>(inventory))
        {
            var entry = slot.Entry;
            if (entry == null || !entry.IsStocked || !entry.EnoughGold) continue;
            if (entry is MerchantPotionEntry potion && !CanProcurePotion(player, potion.Model)) continue;
            int index = entries.IndexOf(entry);
            if (index < 0) throw new NotSupportedException("merchant_entry_identity_unavailable");
            string? name = entry switch
            {
                MerchantCardEntry card => SafeGetText(() => card.CreationResult?.Card.Title),
                MerchantRelicEntry relic => SafeGetText(() => relic.Model?.Title),
                MerchantPotionEntry potionEntry => SafeGetText(() => potionEntry.Model?.Title),
                MerchantCardRemovalEntry => "card removal",
                _ => throw new NotSupportedException("unknown_merchant_entry")
            };
            if (OrdinaryInput(slot.Hitbox))
                actions.Add(new($"shop_purchase:{index}", $"Buy {name} for {entry.Cost} gold",
                    () => DispatchShopPurchase(slot), slot.GetInstanceId().ToString()));
        }
        // Closing is its own mutation; never close-and-proceed in one host-selected action.
        var back = GetInstanceFieldValue(inventory, "_backButton") as NBackButton
            ?? throw new NotSupportedException("merchant_back_unavailable");
        if (OrdinaryInput(back))
            actions.Add(new("close_shop", "Close merchant inventory", () => DispatchShopToggle(run, player, room, false), back.GetInstanceId().ToString()));
    }

    private static bool DispatchShopPurchase(NMerchantSlot slot)
        // v0.111 uses MouseReleased -> OnSelected, NOT ForceClick's Released signal.
        => DispatchUiTask(slot, typeof(NMerchantSlot), "OnSelected");

    private static void AddGridActions(Dictionary<string, object?> state, NCardGridSelectionScreen screen, List<LegalAction> actions)
    {
        // Exact v0.111 types whose OnCardClicked/Confirm/Cancel/Close handlers and preview containers were inspected; the shared
        // CardsSelected boundary owns each. Enchant: FromDeckForEnchantment -> ShowScreen(cards, enchantment, amount, prefs) -> CardsSelected.
        var type = screen.GetType();
        if (type != typeof(NDeckCardSelectScreen) && type != typeof(NSimpleCardSelectScreen)
            && type != typeof(NDeckUpgradeSelectScreen) && type != typeof(NDeckTransformSelectScreen) && type != typeof(NDeckEnchantSelectScreen))
            throw new NotSupportedException($"unverified_grid_subclass:{type.Name}");
        if (GetInstanceFieldValue(screen, "_selectedCards") is not IEnumerable<CardModel> selection
            || GetInstanceFieldValue(screen, "_prefs") is not CardSelectorPrefs prefs
            || GetInstanceFieldValue(screen, "_cards") is not IReadOnlyList<CardModel> candidates)
            throw new NotSupportedException("grid_selection_predicates_unavailable");
        var selected = selection.ToHashSet();
        var holders = FindAllSortedByPosition<NGridCardHolder>(screen);
        // NCardGrid.InitGrid(Task) awaits cancellation/animate-out before allocating any holder: an empty grid for a non-empty
        // candidate list is that native window. Any other difference is the sliding-window allocation hiding legal alternatives.
        var shown = holders.Select(h => h.CardModel).Where(card => card != null).Cast<object>().ToList();
        if (shown.Count == 0 && candidates.Count > 0) { state["waiting"] = true; return; }
        if (!BridgeProtocol.SameCards(candidates, shown)) throw new NotSupportedException("grid_candidates_incomplete");
        var detail = (Dictionary<string, object?>)state["card_select"]!;
        detail["selected_indices"] = holders.Select((h, i) => (h, i)).Where(x => selected.Contains(x.h.CardModel)).Select(x => x.i).ToList();
        detail["min_select"] = prefs.MinSelect;
        detail["max_select"] = prefs.MaxSelect;
        bool preview = detail["preview_showing"] is true;
        if (!preview)
            for (int i = 0; i < holders.Count; i++)
            {
                var holder = holders[i];
                bool deselect = selected.Contains(holder.CardModel);
                if (deselect || selected.Count < prefs.MaxSelect)
                    AddCardClick(actions, $"{(deselect ? "deselect_card" : "select_card")}:{i}",
                        $"{(deselect ? "Deselect" : "Select")} {SafeGetText(() => holder.CardModel?.Title)}", holder);
            }
        // Actual visible buttons distinguish main selection/preview confirm and cancel.
        var confirms = FindAll<NConfirmButton>(screen);
        for (int i = 0; i < confirms.Count; i++)
            AddClick(actions, $"confirm_selection:{i}", preview ? "Confirm preview" : "Confirm selection", confirms[i]);
        var cancels = FindAll<NBackButton>(screen);
        for (int i = 0; i < cancels.Count; i++)
            AddClick(actions, $"cancel_selection:{i}", preview ? "Cancel preview" : "Cancel selection", cancels[i]);
    }

    private static void AddHandSelection(Dictionary<string, object?> state, NPlayerHand hand, List<LegalAction> actions)
    {
        if (hand.CurrentMode is not (NPlayerHand.Mode.SimpleSelect or NPlayerHand.Mode.UpgradeSelect))
            throw new NotSupportedException("unverified_hand_selection_mode");
        if (GetInstanceFieldValue(hand, "_prefs") is not CardSelectorPrefs prefs
            || GetInstanceFieldValue(hand, "_selectedCards") is not IEnumerable<CardModel> selected)
            throw new NotSupportedException("hand_selection_predicates_unavailable");
        var detail = (Dictionary<string, object?>)state["hand_select"]!;
        detail["min_select"] = prefs.MinSelect;
        detail["max_select"] = prefs.MaxSelect;
        detail["selected_cards"] = selected.Select(card => BuildCardInfo(card)).ToList();
        var previewCards = new List<Dictionary<string, object?>>();
        AddPreviewCardsFromContainer(hand.GetNodeOrNull<Control>("%UpgradePreviewContainer"), previewCards);
        detail["preview_cards"] = previewCards;
        // Shipped SimpleSelect replaces the last selection at the cap; do not prune those choices.
        var filter = GetInstanceFieldValue(hand, "_currentSelectionFilter") as Func<CardModel, bool>;
        for (int i = 0; i < hand.ActiveHolders.Count; i++)
        {
            var holder = hand.ActiveHolders[i];
            if (holder.CardModel != null && (filter == null || filter(holder.CardModel)))
                AddCardClick(actions, $"combat_select_card:{i}", $"Select {SafeGetText(() => holder.CardModel.Title)}", holder);
        }
        var container = hand.GetNodeOrNull<Control>("%SelectedHandCardContainer");
        if (container != null)
        {
            var holders = FindAll<NSelectedHandCardHolder>(container);
            for (int i = 0; i < holders.Count; i++)
                AddCardClick(actions, $"combat_deselect_card:{i}", $"Deselect {SafeGetText(() => holders[i].CardModel?.Title)}", holders[i]);
        }
        AddClick(actions, "combat_confirm_selection", "Confirm hand selection", hand.GetNodeOrNull<NConfirmButton>("%SelectModeConfirmButton"));
    }

    private static bool CanProcurePotion(Player player, PotionModel? potion)
        => potion != null && player.PotionSlots.Any(p => p == null)
            && Hook.ShouldProcurePotion(player.RunState, player.Creature.CombatState, potion, player);

    private static void AddPotionActions(Dictionary<string, object?> state, Player player, Node root, bool selecting, List<LegalAction> actions)
    {
        if (!player.Creature.IsAlive || !player.CanUseOrRemovePotions) return;
        var holders = FindAll<NPotionHolder>(root);
        var visible = VisibleCreatures();
        for (int i = 0; i < player.PotionSlots.Count; i++)
        {
            var potion = player.PotionSlots[i];
            if (potion == null || potion.IsQueued) continue;
            var holder = holders.SingleOrDefault(h => h.Potion?.Model == potion);
            if (holder == null) throw new NotSupportedException("potion_ui_holder_unavailable");
            if (GetInstanceFieldValue(holder, "_isUsable") is not bool usable)
                throw new NotSupportedException("potion_ui_usability_unavailable");
            if (!usable || !DecisionInputReady(state, IsNodeVisible(holder))) continue;
            string name = SafeGetText(() => potion.Title) ?? "potion";
            actions.Add(new($"discard_potion:{i}", $"Discard slot[{i}] {name}",
                () => DispatchOwnedTask(() => PotionCmd.Discard(potion)), $"potion:{RuntimeHelpers.GetHashCode(potion)}"));
            // Mirrors NPotionPopup._Ready / RefreshButtons without creating or opening UI on GET.
            bool canUse = potion.Usage == PotionUsage.AnyTime || (potion.Usage == PotionUsage.CombatOnly
                && CombatManager.Instance.IsInProgress && IsPlayPhase(player) && !selecting && !CombatManager.Instance.PlayerActionsDisabled);
            if (!canUse || !potion.PassesCustomUsabilityCheck) continue;
            var combat = player.Creature.CombatState;
            IEnumerable<Creature?> targets = potion.TargetType switch
            {
                TargetType.AnyEnemy => combat?.Enemies.Cast<Creature?>() ?? Array.Empty<Creature?>(),
                TargetType.AnyAlly or TargetType.AnyPlayer => combat?.PlayerCreatures.Cast<Creature?>() ?? new Creature?[] { player.Creature },
                TargetType.Self => new Creature?[] { player.Creature },
                TargetType.None or TargetType.AllEnemies or TargetType.RandomEnemy or TargetType.AllAllies or TargetType.TargetedNoCreature => new Creature?[] { null },
                _ => throw new NotSupportedException("unverified_potion_target_type")
            };
            int slotIndex = i;
            foreach (var target in targets)
                if (potion.IsValidTarget(target)
                    && DecisionInputReady(state, target == null || target == player.Creature || visible.Contains(target)))
                    actions.Add(new($"use_potion:{i}:{target?.CombatId.ToString() ?? "none"}",
                        $"Use slot[{i}] {name}" + (target == null ? "" : $" on {SafeGetText(() => target.Monster?.Title) ?? "player"} ({target.CombatId})"),
                        () => DispatchPotion(potion, slotIndex, target), $"potion:{RuntimeHelpers.GetHashCode(potion)}:{target?.CombatId}"));
        }
    }
}
