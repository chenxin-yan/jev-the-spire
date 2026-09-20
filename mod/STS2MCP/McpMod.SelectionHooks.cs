using System;
using System.Linq;
using System.IO;
using System.Security.Cryptography;
using System.Reflection;
using System.Threading.Tasks;
using HarmonyLib;
using MegaCrit.Sts2.Core.Commands;
using MegaCrit.Sts2.Core.GameActions.Multiplayer;
using MegaCrit.Sts2.Core.Nodes.Combat;
using MegaCrit.Sts2.Core.Nodes.Screens.CardSelection;
using MegaCrit.Sts2.Core.Nodes.Screens;
using MegaCrit.Sts2.Core.Rewards;
using MegaCrit.Sts2.Core.Runs;

namespace STS2_MCP;

public static partial class McpMod
{
    internal static readonly SelectionOwnership SelectionOwners = new();

    // v0.111-only local shim; remove when upstream UI selectors carry an explicit owner token.
    // These hooks only observe selection boundaries. They do not intercept general Tasks or choose cards.
    private static void InstallSelectionOwnershipHooks()
    {
        using (var native = File.OpenRead(typeof(CardSelectCmd).Assembly.Location))
            if (!Convert.ToHexString(SHA256.HashData(native)).Equals(BridgeProtocol.NativeAssemblySha256, StringComparison.OrdinalIgnoreCase))
                throw new NotSupportedException("selection_hooks_require_verified_v0.111_assembly");
        var harmony = new Harmony("com.sts2mcp.selection-ownership");
        var flags = BindingFlags.Static | BindingFlags.NonPublic;
        HarmonyMethod Patch(string name) => new(typeof(McpMod).GetMethod(name, flags)!);
        var contextualNames = new[] { "FromHand", "FromHandForDiscard", "FromHandForUpgrade", "FromSimpleGrid",
            "FromSimpleGridForRewards", "FromChooseACardScreen", "FromCombatPile" };
        try
        {
            foreach (string name in contextualNames)
            {
                var methods = typeof(CardSelectCmd).GetMethods(BindingFlags.Static | BindingFlags.Public)
                    .Where(m => m.Name == name && m.GetParameters().Any(p => p.ParameterType == typeof(PlayerChoiceContext))).ToArray();
                if (methods.Length == 0) throw new NotSupportedException("selection_context_api_changed:" + name);
                foreach (var method in methods)
                    harmony.Patch(method, prefix: Patch(nameof(SelectionContextPrefix)), finalizer: Patch(nameof(SelectionContextFinalizer)));
            }
            foreach (var (type, name) in new[] { (typeof(NPlayerHand), "SelectCards"), (typeof(NCardGridSelectionScreen), "CardsSelected"),
                (typeof(NChooseACardSelectionScreen), "CardsSelected"), (typeof(NCardRewardSelectionScreen), "OptionSelected"),
                (typeof(NChooseABundleSelectionScreen), "CardsSelected"), (typeof(NChooseARelicSelection), "RelicsSelected") })
            {
                var method = type.GetMethod(name, BindingFlags.Instance | BindingFlags.Public)
                    ?? throw new NotSupportedException("selection_boundary_api_changed:" + name);
                if (!typeof(Task).IsAssignableFrom(method.ReturnType)) throw new NotSupportedException("selection_task_api_changed");
                harmony.Patch(method, prefix: Patch(nameof(SelectionBoundaryPrefix)), postfix: Patch(nameof(SelectionBoundaryPostfix)),
                    finalizer: Patch(nameof(SelectionBoundaryFinalizer)));
            }
            foreach (var (type, name, prefix) in new[] {
                (typeof(NCombatUi), "ShowRewards", nameof(RewardUiPrefix)),
                (typeof(NCombatUi), "ProceedWithoutRewards", nameof(RewardUiPrefix)),
                (typeof(RewardsSet), "Offer", nameof(RewardOfferPrefix)),
                (typeof(RunManager), "ProceedFromTerminalRewardsScreen", nameof(RewardProceedPrefix)) })
            {
                var method = type.GetMethod(name, BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic)
                    ?? throw new NotSupportedException("reward_capture_api_changed:" + name);
                if (method.ReturnType != typeof(Task)) throw new NotSupportedException("reward_task_api_changed:" + name);
                harmony.Patch(method, prefix: Patch(prefix), postfix: Patch(nameof(RewardTaskPostfix)), finalizer: Patch(nameof(RewardTaskFinalizer)));
            }
            harmony.Patch(typeof(MegaCrit.Sts2.Core.Nodes.Rooms.NEventRoom).GetMethod("SetupLayout", BindingFlags.Instance | BindingFlags.NonPublic)
                ?? throw new NotSupportedException("event_setup_boundary_changed"), prefix: Patch(nameof(EventSetupPrefix)),
                postfix: Patch(nameof(EventSetupPostfix)), finalizer: Patch(nameof(EventSetupFinalizer)));
            harmony.Patch(typeof(MegaCrit.Sts2.Core.Events.EventOption).GetMethod("Chosen", BindingFlags.Instance | BindingFlags.Public)
                ?? throw new NotSupportedException("event_chosen_boundary_changed"), postfix: Patch(nameof(EventChosenPostfix)));
            foreach (var (type, name, prefix) in new[] {
                (typeof(MegaCrit.Sts2.Core.Nodes.Rooms.NTreasureRoom), "OpenChest", nameof(TreasureOpenPrefix)),
                (typeof(MegaCrit.Sts2.Core.Nodes.Rooms.NTreasureRoom), "EnableSkipAfterDelay", nameof(TreasureSkipPrefix)),
                (typeof(MegaCrit.Sts2.Core.Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection), "AnimateRelicAwards", nameof(TreasureAwardsPrefix)) })
            {
                var method = type.GetMethod(name, BindingFlags.Instance | BindingFlags.NonPublic)
                    ?? throw new NotSupportedException("treasure_capture_api_changed:" + name);
                if (method.ReturnType != typeof(Task)) throw new NotSupportedException("treasure_task_api_changed");
                harmony.Patch(method, prefix: Patch(prefix), postfix: Patch(nameof(TreasureTaskPostfix)), finalizer: Patch(nameof(TreasureTaskFinalizer)));
            }
            var obtain = typeof(RelicCmd).GetMethods(BindingFlags.Static | BindingFlags.Public).Single(m => m.Name == "Obtain" && !m.IsGenericMethod
                && m.GetParameters().Select(p => p.ParameterType).SequenceEqual(new[] { typeof(MegaCrit.Sts2.Core.Models.RelicModel), typeof(MegaCrit.Sts2.Core.Entities.Players.Player), typeof(int) }));
            harmony.Patch(obtain, prefix: Patch(nameof(TreasureObtainPrefix)), postfix: Patch(nameof(TreasureTaskPostfix)), finalizer: Patch(nameof(TreasureTaskFinalizer)));
            harmony.Patch(typeof(NRewardsScreen).GetMethod("ShowScreen", BindingFlags.Static | BindingFlags.Public)
                ?? throw new NotSupportedException("reward_screen_boundary_api_changed"),
                prefix: Patch(nameof(RewardScreenPrefix)), postfix: Patch(nameof(RewardScreenPostfix)));
            // Observation only: retains the exact detached post-select Task under the owned rest dispatch (see DispatchRestOption).
            var restPostSelect = typeof(MegaCrit.Sts2.Core.Nodes.Rooms.NRestSiteRoom).GetMethod("AfterSelectingOptionAsync", BindingFlags.Instance | BindingFlags.NonPublic)
                ?? throw new NotSupportedException("rest_post_select_boundary_changed");
            if (restPostSelect.ReturnType != typeof(Task)) throw new NotSupportedException("rest_post_select_task_api_changed");
            harmony.Patch(restPostSelect, postfix: Patch(nameof(RestPostSelectPostfix)));
        }
        catch { harmony.UnpatchAll("com.sts2mcp.selection-ownership"); throw; }
    }

    private static void SelectionContextPrefix(object[] __args, out IDisposable __state)
        => __state = SelectionOwners.Enter(ContextualSelectionOwner(__args.OfType<PlayerChoiceContext>().Single(), RequireTreasureIdentity, RequireEventIdentity));

    // One policy for every contextual CardSelectCmd overload. A GameAction context resolves only through explicit registration.
    // Pinned v0.111: BlockingPlayerChoiceContext is the context the shared EventModel grid helper and relic AfterObtained lanes create;
    // it inherits only the retained operation whose own dispatch flow is executing, after that source's identity adapter passes.
    // Branching/Hook/Throwing contexts and any other flow mask inherited tokens; OwnerId/model-stack identity is never authority.
    private static object? ContextualSelectionOwner(PlayerChoiceContext context, Action<TreasureOperation> requireTreasure, Action<EventEntry> requireEvent)
    {
        if (context is GameActionPlayerChoiceContext action) return SelectionOwners.ResolveContext(action.Action);
        if (context is not BlockingPlayerChoiceContext) return null;
        switch (OwnedContextualRoot())
        {
            case TreasureOperation treasure: requireTreasure(treasure); return treasure.Owner;
            case EventOperation operation: requireEvent(operation.Entry); return operation.Owner;
            default: return null;
        }
    }

    // The retained operation whose own dispatch flow is executing: its source scope and the ambient selection owner must both name it.
    private static object? OwnedContextualRoot()
    {
        if (TreasureScopes.CurrentOwner is TreasureScope { Obtain: true, Operation: { Closed: false } treasure } && ReferenceEquals(treasure, _treasureOperation)
            && ReferenceEquals(SelectionOwners.CurrentOwner, treasure.Owner)) return treasure;
        if (EventScopes.CurrentOwner is EventScope { Operation: { Closed: false } operation } && ReferenceEquals(operation, _eventOperation)
            && ReferenceEquals(SelectionOwners.CurrentOwner, operation.Owner)) return operation;
        return null;
    }

    private static Exception? SelectionContextFinalizer(Exception? __exception, IDisposable? __state)
    {
        __state?.Dispose(); // Restore caller immediately; async method captured its own ExecutionContext.
        return __exception;
    }

    private static void SelectionBoundaryPrefix(object __instance, out SelectionOwnership.Lease? __state)
        => __state = SelectionOwners.BeginBoundary(__instance);

    private static void SelectionBoundaryPostfix(Task __result, SelectionOwnership.Lease? __state)
    {
        if (__state != null) SelectionOwners.Attach(__state, __result);
    }

    private static Exception? SelectionBoundaryFinalizer(Exception? __exception, SelectionOwnership.Lease? __state)
    {
        if (__exception != null && __state != null) SelectionOwners.Fault(__state);
        return __exception;
    }
}
