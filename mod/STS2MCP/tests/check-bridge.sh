#!/usr/bin/env bash
# Offline: actual compiled bridge types, no game initialization or HTTP.
set -euo pipefail
DLL="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
cat > "$TMP/Check.csproj" <<'XML'
<Project Sdk="Microsoft.NET.Sdk"><PropertyGroup><OutputType>Exe</OutputType><TargetFramework>net9.0</TargetFramework><Nullable>enable</Nullable></PropertyGroup></Project>
XML
cat > "$TMP/Program.cs" <<'CS'
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Reflection.Emit;
using System.Runtime.Loader;
using System.IO;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Threading;
using System.Threading.Tasks;

var assembly = Assembly.LoadFrom(args[0]);
var flags = BindingFlags.Static | BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Public;
var protocol = assembly.GetType("STS2_MCP.BridgeProtocol", true)!;
int checks = 0;
void Check(bool passed, string message) { Interlocked.Increment(ref checks); if (!passed) throw new Exception(message); }
object? Call(Type type, object? instance, string name, params object?[] values)
    => type.GetMethod(name, flags)!.Invoke(instance, values);
// Stage 1: production synchronous-receipt helper; no native/Godot object construction.
void CheckOrdinaryReceipts()
{
if (protocol.GetMethod("CaptureSynchronousSignal", flags) == null)
{
    bool oldRootSupported = false;
    try { Call(protocol, null, "RequireClickCompletion", "open_shop", false); oldRootSupported = true; }
    catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { Console.WriteLine("Old production root gate: " + e.InnerException.Message); }
    Check(oldRootSupported, "Stage1 guarded native open_shop must have a completion adapter; old root gate refuses before dispatch");
}
foreach (var scenario in new[] { "success", "absent", "duplicate", "foreign", "early", "throw", "postcondition", "guard" })
{
    var receiver = new object(); Action<object>? signal = null; Action<object>? late = null;
    bool clicked = false, unsubscribed = false, returned = false, failed = false;
    try
    {
        var receipt = (Task)Call(protocol, null, "CaptureSynchronousSignal", receiver,
            (Action<Action<object>>)(s => { signal = late = s; if (scenario == "early") s(receiver); }),
            (Action<Action<object>>)(_ => { unsubscribed = true; signal = null; }),
            (Action)(() => {
                clicked = true;
                if (scenario != "absent") signal!(scenario == "foreign" ? new object() : receiver);
                if (scenario == "duplicate") signal!(receiver);
                if (scenario == "throw") throw new InvalidOperationException("native callback failed after signal");
                returned = true;
            }), (Func<bool>)(() => scenario != "guard"), (Func<bool>)(() => returned && scenario != "postcondition"))!;
        Check(receipt.IsCompletedSuccessfully && returned, "receipt requires synchronous successful callback return");
    }
    catch (TargetInvocationException) { failed = true; }
    Check(failed == (scenario != "success"), "exact native signal scenario: " + scenario);
    Check(scenario == "guard" ? !clicked && !unsubscribed : clicked && unsubscribed, "guard before subscription/click; cleanup on every dispatched outcome: " + scenario);
    late?.Invoke(receiver); // A late event cannot heal the already rejected absent/foreign/throw receipt.
    Check(failed == (scenario != "success"), "no completion latch from late native signal: " + scenario);
}
foreach (bool visible in new[] { false, true }) foreach (bool enabled in new[] { false, true })
foreach (int filter in new[] { 0, 1, 2 }) foreach (bool blocked in new[] { false, true })
foreach (bool targeting in new[] { false, true }) foreach (bool dead in new[] { false, true })
    Check((bool)Call(protocol, null, "OrdinaryInput", visible, enabled, filter, blocked, targeting, dead)!
        == (visible && enabled && filter != 2 && !blocked && !targeting && !dead), "ordinary native input gate excludes mouse Ignore/blocker/targeting/dead, not just ForceClick IsEnabled");
foreach (bool disabled in new[] { false, true }) foreach (bool traveling in new[] { false, true })
foreach (bool starts in new[] { false, true }) foreach (bool animation in new[] { false, true })
{
    bool rejected = false;
    try { Call(protocol, null, "RequireOrdinaryMap", disabled, traveling, starts, animation); }
    catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { rejected = true; }
    Check(rejected == (disabled || traveling || starts || animation), "Opened alone does not authorize map start/tutorial/input-disabled branches");
}
var entryType = assembly.GetType("STS2_MCP.OrdinaryRoomEntry", true)!;
foreach (var scenario in new[] { "success", "unseen", "lateflag", "foreign", "missing", "duplicate", "afterready", "cancel", "wrongrun", "wrongroom", "wrongnode", "wrongmove", "wrongplayer", "beforefinish", "latebind" })
{
    object move = new(), owner = new(), run = new(), player = new(), room = new(), node = new();
    var entry = Activator.CreateInstance(entryType, flags, null, new[] { move, owner, run, player }, null)!;
    bool cachedSeen = scenario is not "unseen" and not "lateflag";
    void Bind() => Call(entryType, entry, "Bind", scenario == "wrongmove" ? new object() : move,
        scenario == "foreign" ? new object() : owner, scenario == "wrongrun" ? new object() : run,
        scenario == "wrongplayer" ? new object() : player, room, node, scenario != "afterready", cachedSeen);
    if (scenario == "latebind") Call(entryType, entry, "Finish", move);
    if (scenario != "missing") Bind();
    cachedSeen = true; // A later flag cannot replace the original pre-_Ready snapshot.
    if (scenario == "duplicate") Bind();
    if (scenario == "cancel") Call(entryType, entry, "Invalidate");
    if (scenario != "beforefinish") Call(entryType, entry, "Finish", move);
    bool rejected = false;
    try { Call(entryType, entry, "Require", run, scenario == "wrongroom" ? new object() : room,
        scenario == "wrongnode" ? new object() : node, player); }
    catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { rejected = true; }
    Check(rejected == (scenario != "success"), "exact pre-Ready entry receipt: " + scenario);
}
var shopSessionType = assembly.GetType("STS2_MCP.BridgeSession", true)!;
var shopSession = Activator.CreateInstance(shopSessionType, true)!;
int proceedClicks = 0; bool shopOpen = false;
foreach (string label in new[] { "open_shop", "close_shop", "proceed" })
{
    string version = (string)Call(shopSessionType, shopSession, "Observe", "shop:" + shopOpen)!;
    Check((int)Call(shopSessionType, shopSession, "Accept", version, label, new[] { label })! == 0, "accept separate native shop operation: " + label);
    object receiver = new(); Action<object>? signal = null;
    var task = (Task)Call(protocol, null, "CaptureSynchronousSignal", receiver,
        (Action<Action<object>>)(s => signal = s), (Action<Action<object>>)(_ => signal = null),
        (Action)(() => { if (label == "proceed") proceedClicks++; else shopOpen = label == "open_shop"; signal!(receiver); }),
        (Func<bool>)(() => true), (Func<bool>)(() => label == "proceed" || shopOpen == (label == "open_shop")))!;
    Call(shopSessionType, shopSession, "Track", receiver, task, Task.CompletedTask, (Func<Task?>)(() => task), (Func<bool>)(() => false));
    Call(shopSessionType, shopSession, "Refresh");
    Check((int)Call(shopSessionType, shopSession, "Accept", version, label, new[] { label })! == 409, "successful synchronous receipt does not rearm stale version: " + label);
    Check(proceedClicks == (label == "proceed" ? 1 : 0), "close is independent of proceed");
}
}
CheckOrdinaryReceipts();
void CheckEventReceipts()
{
    var entryType = assembly.GetType("STS2_MCP.EventEntry");
    if (entryType == null)
    {
        try { Call(protocol, null, "RequireEventReadiness"); }
        catch (TargetInvocationException e) { Console.WriteLine("Old production event gate: " + e.InnerException?.Message); }
        Check(false, "Stage2 requires an owned original SetupLayout receipt, not blanket event refusal");
    }
    Check((bool)Call(protocol, null, "DialogueAdvanced", 0, 1, false, true, true, false)!, "middle dialogue line permits native-safe input without a focus tween receipt");
    Check((bool)Call(protocol, null, "DialogueAdvanced", 1, 2, true, false, false, true)!, "last dialogue line disables hitbox and enables options synchronously");
    Check(!(bool)Call(protocol, null, "DialogueAdvanced", 1, 1, true, false, false, true)!, "unchanged dialogue line is not a receipt");
    Check(!(bool)Call(protocol, null, "DialogueAdvanced", 1, 2, true, false, false, false)!, "last line cannot release before actual input enabling");
    Check(!(bool)Call(protocol, null, "DialogueAdvanced", 0, 1, false, false, false, true)!, "wrong dialogue control state refuses completion");
    var opType = assembly.GetType("STS2_MCP.EventOperation", true)!;
    var registryType = assembly.GetType("STS2_MCP.SelectionOwnership", true)!;
    object NewEntry(object move, object owner, object run, object player) => Activator.CreateInstance(entryType!, flags, null, new[] { move, owner, run, player }, null)!;
    bool Reject(Action test) { try { test(); return false; } catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { return true; } }
    foreach (string outcome in new[] { "success", "fault", "cancel" })
    {
        object move = new(), owner = new(), run = new(), player = new(), room = new(), scene = new(), model = new(), layout = new(), button = new(), option = new();
        var entry = NewEntry(move, owner, run, player); var setup = new TaskCompletionSource();
        Call(entryType!, entry, "Bind", owner, room, scene, model, layout);
        Call(entryType!, entry, "Input", button, option, owner, true);
        Call(entryType!, entry, "Attach", setup.Task);
        Check(!(bool)Call(entryType!, entry, "InputReady", button, option, 0, true, false)!, "delayed setup blocks even enabled visible options");
        if (outcome == "fault") setup.SetException(new Exception("setup")); else if (outcome == "cancel") setup.SetCanceled(); else setup.SetResult();
        if (outcome != "success")
        { Check(Reject(() => Call(entryType!, entry, "InputReady", button, option, 0, true, false)), "original setup " + outcome); continue; }
        Check(!(bool)Call(entryType!, entry, "InputReady", button, option, 0, false, false)!, "original setup success does not imply native EnableButton ran");
        Check((bool)Call(entryType!, entry, "InputReady", button, option, 0, true, false)!, "owned disabled-to-enabled native input boundary");
        object actionOwner = new(); entryType!.GetField("ActiveOwner", flags)!.SetValue(entry, actionOwner);
        Call(entryType!, entry, "Changed", model, actionOwner);
        Check(Reject(() => Call(entryType!, entry, "RequireGeneration", 0)), "stale option generation rejected");
        Check(!(bool)Call(entryType!, entry, "InputReady", button, option, 1, true, false)!, "StateChanged alone never reauthorizes old buttons");
        object newButton = new(); Call(entryType!, entry, "Input", newButton, option, actionOwner, false);
        Check(Reject(() => Call(entryType!, entry, "InputReady", newButton, option, 1, true, false)), "unverified initial prefab filter halts, not completion");
        Call(entryType!, entry, "Changed", model, new object());
        Check(Reject(() => Call(entryType!, entry, "Check")), "foreign state mutation revokes entry");
    }
    foreach (bool seen in new[] { false, true })
    {
        object move = new(), owner = new(), run = new(), player = new(), set = new(), screen = new();
        var entry = NewEntry(move, owner, run, player);
        Call(entryType!, entry, "Bind", owner, new object(), new object(), new object(), new object());
        Call(entryType!, entry, "Attach", Task.CompletedTask);
        var registry = Activator.CreateInstance(registryType, true)!;
        var operation = Activator.CreateInstance(opType, flags, null, new[] { owner, entry, registry }, null)!;
        var root = new TaskCompletionSource(); var offer = new TaskCompletionSource(); var child = new TaskCompletionSource();
        opType.GetField("Root", flags)!.SetValue(operation, root.Task);
        Call(opType, operation, "BeginOffer", set);
        bool rejected = Reject(() => Call(opType, operation, "BindScreen", set, screen, false, seen));
        Check(rejected == !seen, "event Offer preserves sticky obtain_relic_ftue entry refusal");
        if (!seen)
        { Check(Reject(() => Call(opType, operation, "BindScreen", set, new object(), false, true)), "later seen flag never heals event reward failure"); continue; }
        Call(opType, operation, "AttachOffer", set, offer.Task);
        Check((bool)Call(opType, operation, "CanDecide")!, "exact reward yield does not await the root that awaits Offer");
        var parentType = assembly.GetType("STS2_MCP.BridgeSession", true)!;
        var parent = Activator.CreateInstance(parentType, true)!;
        var version = (string)Call(parentType, parent, "Observe", "event root")!;
        Call(parentType, parent, "Accept", version, "event", new[] { "event" });
        Call(parentType, parent, "Track", owner, Task.CompletedTask, Task.CompletedTask, (Func<Task?>)(() => root.Task), (Func<bool>)(() => false));
        var childVersion = (string)Call(parentType, parent, "Observe", "owned rewards")!;
        Check((int)Call(parentType, parent, "AcceptChild", childVersion, "claim", new[] { "claim" }, owner)! == 0
            && ReferenceEquals(parentType.GetProperty("OperationOwner", flags)!.GetValue(parent), owner), "event reward child does not replace pending original parent");
        Check((int)Call(parentType, parent, "AcceptChild", childVersion, "claim", new[] { "claim" }, owner)! == 409, "event child cannot replay consumed generation");
        Check(!(bool)Call(opType, operation, "Poll")!, "parent remains pending across reward yield");
        Call(opType, operation, "AddChild", child.Task);
        Check(!(bool)Call(opType, operation, "CanDecide")!, "pending child blocks sibling reward choices");
        root.SetResult(); offer.SetResult();
        Check(!(bool)Call(opType, operation, "Poll")!, "Offer/root completion cannot omit child UI completion");
        child.SetResult(); Check((bool)Call(opType, operation, "Poll")!, "original root Offer and child jointly release");
    }
    foreach (string failure in new[] { "root_fault", "root_cancel", "child_fault", "child_cancel", "foreign_setup", "duplicate_setup" })
    {
        object move = new(), owner = new(), run = new(), player = new(), room = new(), scene = new(), model = new(), layout = new();
        var entry = NewEntry(move, owner, run, player);
        Call(entryType!, entry, "Bind", failure == "foreign_setup" ? new object() : owner, room, scene, model, layout);
        if (failure == "duplicate_setup") Call(entryType!, entry, "Bind", owner, room, scene, model, layout);
        if (failure.EndsWith("setup")) { Check(Reject(() => Call(entryType!, entry, "Check")), "exact setup binding: " + failure); continue; }
        Call(entryType!, entry, "Attach", Task.CompletedTask);
        var registry = Activator.CreateInstance(registryType, true)!;
        var operation = Activator.CreateInstance(opType, flags, null, new[] { owner, entry, registry }, null)!;
        var task = new TaskCompletionSource();
        opType.GetField("Root", flags)!.SetValue(operation, failure.StartsWith("root") ? task.Task : Task.CompletedTask);
        if (failure.StartsWith("child")) Call(opType, operation, "AddChild", task.Task);
        if (failure.EndsWith("fault")) task.SetException(new Exception("original event task")); else task.SetCanceled();
        Check(Reject(() => Call(opType, operation, "Poll")), "event original task failure cannot release parent: " + failure);
    }
    {
        object owner = new(); var entry = NewEntry(new object(), owner, new object(), new object()); int cleaned = 0;
        entryType!.GetField("Cleanup", flags)!.SetValue(entry, (Action)(() => cleaned++));
        Call(entryType!, entry, "Fail", "foreign event"); Call(entryType!, entry, "Close");
        Check(cleaned == 1 && !(bool)Call(entryType!, entry, "OwnsScope", owner)!, "failure closes entry observers once and late owned context cannot revive them");
    }
    {
        // Generic multipage option: the callback publishes a new page (StateChanged) before its task finishes; a later fault stays sticky.
        object move = new(), owner = new(), run = new(), player = new(), model = new();
        var entry = NewEntry(move, owner, run, player);
        Call(entryType!, entry, "Bind", owner, new object(), new object(), model, new object());
        Call(entryType!, entry, "Attach", Task.CompletedTask);
        var registry = Activator.CreateInstance(registryType, true)!;
        var operation = Activator.CreateInstance(opType, flags, null, new[] { owner, entry, registry }, null)!;
        var root = new TaskCompletionSource(); opType.GetField("Root", flags)!.SetValue(operation, root.Task);
        entryType!.GetField("ActiveOwner", flags)!.SetValue(entry, owner);
        var pageSessionType = assembly.GetType("STS2_MCP.BridgeSession", true)!;
        var pageSession = Activator.CreateInstance(pageSessionType, true)!;
        var pageVersion = (string)Call(pageSessionType, pageSession, "Observe", "page one")!;
        Call(pageSessionType, pageSession, "Accept", pageVersion, "choose_event_option:0", new[] { "choose_event_option:0" });
        Call(pageSessionType, pageSession, "Track", owner, Task.CompletedTask, Task.CompletedTask, (Func<Task?>)(() => root.Task), (Func<bool>)(() => false));
        Call(pageSessionType, pageSession, "HoldUntil", (Func<bool>)(() =>
        { try { return (bool)Call(opType, operation, "Poll")!; } catch (TargetInvocationException e) when (e.InnerException != null) { throw e.InnerException; } }));
        Call(pageSessionType, pageSession, "OnRelease", (Action)(() => { if (pageSessionType.GetProperty("Failure", flags)!.GetValue(pageSession) is string reason) Call(entryType!, entry, "Fail", reason); }));
        Call(entryType!, entry, "Changed", model, owner);
        object nextButton = new(), nextOption = new(); Call(entryType!, entry, "Input", nextButton, nextOption, owner, true);
        Call(pageSessionType, pageSession, "Refresh");
        Check((bool)pageSessionType.GetProperty("Pending", flags)!.GetValue(pageSession)! && (bool)Call(entryType!, entry, "InputReady", nextButton, nextOption, 1, true, false)!,
            "new page input becomes ready while the original option task still runs; a page change is not completion");
        root.SetException(new Exception("effect after page change failed"));
        Call(pageSessionType, pageSession, "Refresh");
        Check(pageSessionType.GetProperty("Failure", flags)!.GetValue(pageSession) is "event_task_failed" or "mutation_faulted" && Reject(() => Call(entryType!, entry, "Check")),
            "root fault after the new page fails the operation and revokes the entry");
        Call(entryType!, entry, "Changed", model, owner);
        Check(Reject(() => Call(entryType!, entry, "InputReady", nextButton, nextOption, 2, true, false))
            && (int)Call(pageSessionType, pageSession, "Accept", (string)Call(pageSessionType, pageSession, "Observe", "page two")!, "choose_event_option:0", new[] { "choose_event_option:0" })! == 409,
            "later pages and fresh versions cannot rearm the faulted event operation");
    }
    {
        // Ordinary awaited effects need no listener names: the root stays pending through nested work, and a deck selector
        // opened from an awaited continuation still belongs to the option owner and is findable before the root completes.
        var registry = Activator.CreateInstance(registryType, true)!;
        object owner = new(); var entry = NewEntry(new object(), owner, new object(), new object());
        Call(entryType!, entry, "Bind", owner, new object(), new object(), new object(), new object()); Call(entryType!, entry, "Attach", Task.CompletedTask);
        var operation = Activator.CreateInstance(opType, flags, null, new[] { owner, entry, registry }, null)!;
        var effect = new TaskCompletionSource(); var deckSelection = new TaskCompletionSource(); object deckSelector = new(); object? deckLease = null;
        var pendingTasks = new List<Task>();
        async Task Callback()
        {
            await effect.Task; // e.g. an awaited card-pile add with its listener chain
            deckLease = Call(registryType, registry, "BeginBoundary", deckSelector); Call(registryType, registry, "Attach", deckLease, deckSelection.Task);
            await deckSelection.Task;
        }
        Task root;
        using ((IDisposable)Call(registryType, registry, "Enter", owner)!)
            root = (Task)Call(protocol, null, "CaptureAppendedTask", pendingTasks, (Action)(() => pendingTasks.Add(Callback())))!;
        opType.GetField("Root", flags)!.SetValue(operation, root);
        Check(!(bool)Call(opType, operation, "Poll")! && deckLease == null && registryType.GetProperty("CurrentOwner", flags)!.GetValue(registry) == null,
            "root pending through an awaited nested effect; caller scope already restored");
        effect.SetResult();
        Check(deckLease != null && ReferenceEquals(Call(registryType, registry, "Find", deckSelector, owner), deckLease) && !root.IsCompleted && !(bool)Call(opType, operation, "Poll")!,
            "deck selector created after an awaited effect belongs to the option owner and is exposed before root completion");
        Check(Call(registryType, registry, "Find", deckSelector, new object()) == null, "foreign owner cannot claim the event's deck selector");
        deckSelection.SetResult();
        Check(root.IsCompletedSuccessfully && (bool)Call(opType, operation, "Poll")!, "root releases only after its awaited selector and effects settle");
    }
    // Scope exists before the original callback's synchronous first segment creates a selector.
    var selectors = Activator.CreateInstance(registryType, true)!;
    object optionOwner = new(), selector = new(); var chosen = new TaskCompletionSource(); var selection = new TaskCompletionSource();
    var pending = new List<Task>(); object? lease = null;
    using ((IDisposable)Call(registryType, selectors, "Enter", optionOwner)!)
    {
        var receipt = (Task)Call(protocol, null, "CaptureAppendedTask", pending, (Action)(() => {
            lease = Call(registryType, selectors, "BeginBoundary", selector);
            Call(registryType, selectors, "Attach", lease, selection.Task);
            pending.Add(chosen.Task);
        }))!;
        Check(ReferenceEquals(receipt, chosen.Task), "non-proceed retains exact appended native task");
    }
    Check(lease != null && ReferenceEquals(Call(registryType, selectors, "Find", selector, optionOwner), lease), "synchronous selector belongs to original option owner");
    Check(registryType.GetProperty("CurrentOwner", flags)!.GetValue(selectors) == null, "event callback scope restored");
}
CheckEventReceipts();
void CheckTreasureReceipts()
{
    var type = assembly.GetType("STS2_MCP.TreasureOperation");
    if (type == null)
    {
        try { Call(protocol, null, "RequireClickCompletion", "open_treasure", false); }
        catch (TargetInvocationException e) { Console.WriteLine("Old production treasure gate: " + e.InnerException?.Message); }
        Check(false, "treasure requires retained OpenChest/awards/Obtain ownership");
    }
    var registryType = assembly.GetType("STS2_MCP.SelectionOwnership", true)!;
    bool Reject(Action f) { try { f(); return false; } catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { return true; } }
    void Set(object op, string field, object? value) => type!.GetField(field, flags)!.SetValue(op, value);
    foreach (ulong elapsed in new ulong[] { 0, 199, 200, 201, 400 })
        Check((bool)Call(type!, null, "ClaimInput", 1000UL + elapsed, 1000UL)! == (elapsed > 200), "native anti-click guard is strict input validation, not completion");
    foreach (var state in new[] { (false, 1, false, false), (true, 1, false, false), (false, 0, false, false), (false, 1, true, false), (false, 1, false, true) })
        Check(Reject(() => Call(type!, null, "RequireFresh", state.Item1, state.Item2, state.Item3, state.Item4))
            == (state.Item1 || state.Item2 == 0 || state.Item3 || state.Item4), "empty/reopened/completed collection cannot be adopted");
    foreach (string branch in new[] { "claim", "skip", "obtain_fault", "obtain_cancel", "awards_fault", "awards_cancel", "unexpected_cancel", "duplicate", "foreign" })
    {
        object owner = new(), run = new(), room = new(), scene = new(), player = new(), collection = new(), action = new();
        var registry = Activator.CreateInstance(registryType, true)!;
        var began = new TaskCompletionSource(); var finished = new TaskCompletionSource(); var root = new TaskCompletionSource();
        var awards = new TaskCompletionSource(); var obtain = new TaskCompletionSource(); var pick = new TaskCompletionSource(); var skip = new TaskCompletionSource();
        var op = Activator.CreateInstance(type!, flags, null, new object[] { owner, run, room, scene, player, collection, new object(), began.Task, finished.Task, registry }, null)!;
        Call(type!, op, "BindRoot", root.Task); Call(type!, op, "BindSkip", skip.Task);
        if (branch == "duplicate") { Call(type!, op, "BindRoot", root.Task); Check(Reject(() => Call(type!, op, "Poll")), "duplicate root permanently refuses"); continue; }
        using var cts = new System.Threading.CancellationTokenSource(); Set(op, "SkipToken", cts.Token);
        using var registration = cts.Token.Register(() => Call(type!, op, "CancelObserved"));
        if (branch == "unexpected_cancel") { cts.Cancel(); skip.SetResult(); Check(Reject(() => Call(type!, op, "Poll")), "unexplained token cancellation cannot be healed by successful skip Task"); continue; }
        int? index = branch == "skip" ? null : 0;
        Call(type!, op, "BindPick", action, index, (Func<Task?>)(() => pick.Task)); Set(op, "Executing", true);
        if (branch == "foreign") { Check(Reject(() => Call(type!, op, "BeginAwards", new object(), collection)), "foreign executing action never owns awards"); continue; }
        Call(type!, op, "BeginAwards", action, collection); Set(op, "Awards", awards.Task);
        began.SetResult(); cts.Cancel(); skip.SetCanceled();
        Check((bool)type!.GetField("ExpectedSkipCancellation", flags)!.GetValue(op)!, "exact post-picking token cancellation is expected");
        if (index.HasValue)
        {
            Call(type!, op, "BeginObtain", new object(), player);
            object selector = new(); object? lease;
            using ((IDisposable)Call(registryType, registry, "Enter", owner)!)
            { lease = Call(registryType, registry, "BeginBoundary", selector); Call(registryType, registry, "Attach", lease, obtain.Task); }
            Check(ReferenceEquals(Call(registryType, registry, "Find", selector, owner), lease), "AfterObtained selector belongs to retained parent before Obtain Task returns");
            Set(op, "Obtain", obtain.Task);
        }
        root.SetResult(); finished.SetResult(); pick.SetResult(); Set(op, "Proceed", Task.CompletedTask); Set(op, "MapOpened", true);
        if (branch.StartsWith("awards_"))
        { if (branch == "awards_fault") awards.SetException(new Exception("awards")); else awards.SetCanceled(); Check(Reject(() => Call(type!, op, "Poll")), "picking finished does not hide awards failure"); continue; }
        awards.SetResult();
        if (index.HasValue) Check(!(bool)Call(type!, op, "Poll")!, "early map/root/picking completion cannot omit detached Obtain gameplay");
        if (branch == "obtain_fault") obtain.SetException(new Exception("AfterObtained"));
        else if (branch == "obtain_cancel") obtain.SetCanceled(); else obtain.SetResult();
        if (branch.StartsWith("obtain_")) Check(Reject(() => Call(type!, op, "Poll")), "retained AfterObtained failure: " + branch);
        else Check((bool)Call(type!, op, "Poll")!, "all original tasks release " + branch + " continuation");
        Call(type!, op, "Close");
        Check(Reject(() => Call(type!, op, "RoomReady")), "closed owner cannot leave orphan room permission");
    }
    {
        var registry = Activator.CreateInstance(registryType, true)!;
        var op = Activator.CreateInstance(type!, flags, null, new object[] { new object(), new object(), new object(), new object(), new object(), new object(), new object(), new TaskCompletionSource().Task, new TaskCompletionSource().Task, registry }, null)!;
        Set(op, "OnlyProceed", true); Set(op, "Root", Task.CompletedTask); Set(op, "Proceed", Task.CompletedTask);
        Check(!(bool)Call(type!, op, "Poll")!, "unopened proceed still needs exact native map receipt");
        Set(op, "MapOpened", true); Check((bool)Call(type!, op, "Poll")!, "unopened proceed does not invent an OpenChest or awards lifetime");
        Call(type!, op, "Close");
    }
    foreach (bool seen in new[] { false, true })
    {
        object owner = new(), scene = new(), player = new(), set = new(), screen = new();
        var registry = Activator.CreateInstance(registryType, true)!;
        var root = new TaskCompletionSource(); var began = new TaskCompletionSource(); var finished = new TaskCompletionSource();
        var offer = new TaskCompletionSource(); var child = new TaskCompletionSource();
        var op = Activator.CreateInstance(type!, flags, null, new object[] { owner, new object(), new object(), scene, player, new object(), new object(), began.Task, finished.Task, registry }, null)!;
        Call(type!, op, "BindRoot", root.Task); Call(type!, op, "BeginOffer", set);
        Check(Reject(() => Call(type!, op, "BindScreen", set, screen, seen)) == !seen, "treasure extra reward preserves entry FTUE refusal");
        if (!seen) { Check(Reject(() => Call(type!, op, "BindScreen", set, new object(), true)), "later tutorial flag cannot heal treasure owner"); continue; }
        Call(type!, op, "AttachOffer", set, offer.Task);
        Check((bool)Call(type!, op, "RewardReady")! && !(bool)Call(type!, op, "Poll")!, "extra rewards yield while OpenChest awaits Offer");
        Call(type!, op, "AddChild", child.Task);
        Check(!(bool)Call(type!, op, "RewardReady")!, "pending reward child blocks sibling decisions");
        offer.SetResult(); Check(!(bool)Call(type!, op, "Poll")!, "Offer completion alone cannot release chest");
        child.SetResult(); Call(type!, op, "Poll");
        Check(!(bool)Call(type!, op, "OwnsScreen", screen)!, "completed extra reward lease retires");
        Call(type!, op, "Close");
    }
}
CheckTreasureReceipts();
async Task CheckTreasureCancelAsync()
{
    var treasure = assembly.GetType("STS2_MCP.TreasureOperation", true)!;
    var sessions = assembly.GetType("STS2_MCP.BridgeSession", true)!;
    var registries = assembly.GetType("STS2_MCP.SelectionOwnership", true)!;
    object New(Type t, params object[] values) => Activator.CreateInstance(t, flags, null, values, null)!;
    void Set(object op, string name, object? value) => treasure.GetField(name, flags)!.SetValue(op, value);
    bool Expected(object op) => (bool)treasure.GetField("ExpectedSkipCancellation", flags)!.GetValue(op)!;
    bool Pending(object session) => (bool)sessions.GetProperty("Pending", flags)!.GetValue(session)!;
    string? Failure(object session) => (string?)sessions.GetProperty("Failure", flags)!.GetValue(session);
    bool Refused(Action action) { try { action(); return false; } catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { return true; } }
    foreach (string mode in new[] { "skip_success", "skip_cancel", "receipt_before_cancelasync_complete", "early_pick", "early_awards", "early_began",
        "foreign_token", "root_fault", "root_cancel", "awards_fault", "awards_cancel", "obtain_fault", "obtain_cancel", "skip_fault", "late_close", "dispose_registration" })
    {
        object owner = new(), pick = new(), collection = new(), player = new();
        var registry = New(registries);
        var began = new TaskCompletionSource(); var finished = new TaskCompletionSource();
        var cleanup = new TaskCompletionSource(); var skip = new TaskCompletionSource(); var awards = new TaskCompletionSource();
        var obtain = new TaskCompletionSource(); var pickWork = new TaskCompletionSource();
        var op = New(treasure, owner, new object(), new object(), new object(), player, collection, new object(), began.Task, finished.Task, registry);
        using var cts = new CancellationTokenSource();
        using var entered = new ManualResetEventSlim(); using var release = new ManualResetEventSlim();
        void DelayDelivery() { entered.Set(); if (!release.Wait(TimeSpan.FromSeconds(10))) throw new Exception("test callback gate timed out"); }
        // Older registration runs after the production callback in this variant. Both use actual CancelAsync.
        using var older = mode == "receipt_before_cancelasync_complete" ? cts.Token.Register(DelayDelivery) : default;
        using var registration = (CancellationTokenRegistration)Call(treasure, op, "RegisterSkipCancellation", cts.Token)!;
        Check(Refused(() => Call(treasure, op, "RegisterSkipCancellation", cts.Token)), "duplicate production cancellation registration rejected");
        using var newer = mode == "receipt_before_cancelasync_complete" ? default : cts.Token.Register(DelayDelivery);
        Task? cancellation = null;
        async Task OriginalCleanup()
        {
            await began.Task;
            cancellation = cts.CancelAsync();
            await cancellation; // Same required native OpenChest ordering, not synchronous Cancel().
            await cleanup.Task;
        }
        bool early = mode.StartsWith("early_");
        var root = early || mode == "foreign_token" ? cleanup.Task : OriginalCleanup();
        Call(treasure, op, "BindRoot", root); Call(treasure, op, "BindSkip", skip.Task);
        if (mode != "early_pick") Call(treasure, op, "BindPick", pick, 0, (Func<Task?>)(() => pickWork.Task));
        if (mode != "early_pick" && mode != "early_awards")
        {
            Set(op, "Executing", true); Call(treasure, op, "BeginAwards", pick, collection); Set(op, "Awards", awards.Task);
        }
        if (!early)
        { Call(treasure, op, "BeginObtain", new object(), player); Set(op, "Obtain", obtain.Task); }
        var session = New(sessions);
        var version = Call(sessions, session, "Observe", "owned treasure");
        Call(sessions, session, "Accept", version, "open_treasure", new[] { "open_treasure" });
        Call(sessions, session, "Track", owner, Task.CompletedTask, Task.CompletedTask, (Func<Task?>)(() => root), (Func<bool>)(() => false));
        Call(sessions, session, "HoldUntil", (Func<bool>)(() => (bool)Call(treasure, op, "Poll")!));
        Call(sessions, session, "OnRelease", (Action)(() => Call(treasure, op, "Close")));
        if (mode == "dispose_registration") Call(sessions, session, "OnRelease", (Action)registration.Dispose);
        Set(op, "MapOpened", true); Set(op, "Proceed", Task.CompletedTask);
        if (mode == "foreign_token")
        {
            began.SetResult();
            using var foreign = new CancellationTokenSource();
            using var foreignRegistration = foreign.Token.Register(() => Call(treasure, op, "CancelObserved"));
            await foreign.CancelAsync();
            Check(!cts.IsCancellationRequested, "foreign callback does not cancel the owned token");
            Call(sessions, session, "Refresh");
            Check(Failure(session) != null && Pending(session), "foreign-token callback cannot grant expected cancellation permission");
            continue;
        }
        if (early) cancellation = cts.CancelAsync(); else began.SetResult();
        try
        {
            Check(entered.Wait(TimeSpan.FromSeconds(5)), "CancelAsync callback gate entered");
            Check(cts.IsCancellationRequested && cancellation?.IsCompleted == false, "real requested-token / pending-CancelAsync window");
            Check(Expected(op) == (mode == "receipt_before_cancelasync_complete"), "actual production callback delivery boundary");
            if (mode == "skip_cancel") skip.SetCanceled(cts.Token);
            else if (mode == "skip_fault") skip.SetException(new Exception("skip"));
            else skip.SetResult();
            if (!early)
            {
                finished.SetResult(); pickWork.SetResult();
                if (mode == "awards_fault") awards.SetException(new Exception("awards"));
                else if (mode == "awards_cancel") awards.SetCanceled(); else awards.SetResult();
                if (mode == "obtain_fault") obtain.SetException(new Exception("obtain"));
                else if (mode == "obtain_cancel") obtain.SetCanceled();
                if (mode == "root_fault") Set(op, "Root", Task.FromException(new Exception("root")));
                else if (mode == "root_cancel") Set(op, "Root", Task.FromCanceled(new CancellationToken(true)));
            }
            if (mode is "late_close" or "dispose_registration") Call(sessions, session, "Fail", "test_abandonment");
            else Call(sessions, session, "Refresh");
            bool failed = early || mode.EndsWith("_fault") || mode is "root_cancel" or "awards_cancel" or "obtain_cancel" or "late_close" or "dispose_registration";
            Check((Failure(session) != null) == failed, "CancelAsync window preserves failure classification: " + mode);
            Check(Pending(session), "map/root cannot release in cancellation delivery window: " + mode);
            if (!failed)
            {
                Check(!(bool)Call(treasure, op, "Poll")!, "actual Poll holds original cancellation/root/Obtain cleanup");
                // Even forged successful cleanup cannot turn the token alone into a delivered receipt.
                if (!Expected(op))
                {
                    Set(op, "Root", Task.CompletedTask); obtain.TrySetResult();
                    Check(!(bool)Call(treasure, op, "GameplayDone")!, "callback receipt required even with successful Skip and other tasks");
                    Set(op, "Root", root);
                }
            }
        }
        finally { release.Set(); }
        await cancellation!;
        if (Failure(session) != null)
        {
            Check(!Expected(op), "callback delivered after close cannot revive expected-cancellation state: " + mode);
            Call(sessions, session, "Refresh"); Check(Failure(session) != null && Pending(session), "failure remains sticky after late callback");
        }
        else
        {
            Check(Expected(op), "normal off-thread production callback publishes expected receipt");
            Call(sessions, session, "Refresh"); Check(Failure(session) == null && Pending(session), "delivered receipt alone does not release original cleanup");
            cleanup.SetResult(); await root;
            if (!obtain.Task.IsCompleted)
            { Call(sessions, session, "Refresh"); Check(Pending(session), "native cleanup cannot omit AfterObtained"); obtain.SetResult(); }
            Set(op, "MapOpened", false);
            Call(sessions, session, "Refresh"); Check(Pending(session), "all gameplay still needs exact map receipt");
            Set(op, "MapOpened", true); Call(sessions, session, "Refresh");
            Check(Failure(session) == null && !Pending(session), "expected cancellation and all original barriers release safely");
            Check((bool)treasure.GetField("Closed", flags)!.GetValue(op)!, "normal release closes operation");
        }
    }
}
await CheckTreasureCancelAsync();
int Request(string method, string path = "/api/v1/singleplayer", string? origin = null,
    string? fetchSite = null, string? contentType = "application/json") =>
    (int)Call(protocol, null, "CheckRequest", method, path, origin, fetchSite, contentType)!;
Check(Request("GET", contentType: null) == 0, "GET");
Check(Request("POST", contentType: "Application/Json; charset=utf-8") == 0, "JSON charset");
foreach (var path in new[] { "/", "/api/v1/profiles", "/api/v1/profile", "/api/v1/multiplayer", "/api/v1/wiki", "/api/v1/compendium", "/api/v1/singleplayer/", "/api/v1/SINGLEPLAYER", "/api/v1/profiles/delete", "/api/v1/profiles/switch" })
    foreach (var method in new[] { "GET", "POST" }) Check(Request(method, path) == 404, "route " + path);
foreach (var method in new[] { "OPTIONS", "PUT", "DELETE", "HEAD", "post" }) Check(Request(method) == 405, method);
foreach (var origin in new[] { "https://evil.example", "null", "http://localhost:15526", "", "malformed" })
    foreach (var method in new[] { "GET", "POST" }) Check(Request(method, origin: origin) == 403, "browser");
foreach (var site in new[] { "cross-site", "same-origin", "none", "" }) Check(Request("POST", fetchSite: site) == 403, "fetch");
foreach (var contentType in new string?[] { null, "", "text/plain", "application/x-www-form-urlencoded", "multipart/form-data", "application/jsonp" })
    Check(Request("POST", contentType: contentType) == 415, "media type");
foreach (var modded in new[] { false, true }) foreach (var initialized in new[] { false, true })
foreach (var multiplayer in new[] { false, true }) foreach (var profile in new[] { 0, 1, 2, 3 })
    Check((bool)Call(protocol, null, "AllowedProfile", modded, initialized, profile, multiplayer)!
        == (modded && initialized && profile == 2 && !multiplayer), "profile isolation");
// Ordered context read: the recorded main-menu GET halted with observation_unavailable:NullReferenceException because
// RunManager.NetService.Type was evaluated before run presence. No-run menus never read the service; running runs without one fail closed.
Check(protocol.GetMethod("ContextHalt", flags) != null, "old context gate dereferences RunManager.NetService before checking run presence (live menu-get.json NullReferenceException)");
foreach (var modded in new[] { false, true }) foreach (var initialized in new[] { false, true }) foreach (var profile in new[] { 1, 2 })
foreach (var inProgress in new[] { false, true }) foreach (var service in new bool?[] { null, false, true })
{
    int serviceReads = 0;
    var halt = (string?)Call(protocol, null, "ContextHalt", modded, initialized, profile, inProgress, (Func<bool?>)(() => { serviceReads++; return service; }));
    bool profileAllowed = modded && initialized && profile == 2;
    string? expected = !profileAllowed ? "modded_profile_2_singleplayer_required" : !inProgress ? null
        : service == null ? "run_network_service_unavailable" : service == true ? "modded_profile_2_singleplayer_required" : null;
    Check(halt == expected, $"ordered context halt modded={modded} initialized={initialized} profile={profile} run={inProgress} service={service}");
    Check(serviceReads == (profileAllowed && inProgress ? 1 : 0), "network service type is read only for an in-progress run in the allowed profile, never on a no-run menu");
}
var parsed = ((string Version, string Label))Call(protocol, null, "ParseAction", "{\"state_version\":\"v1\",\"label\":\"play_card:0:7\"}")!;
Check(parsed == ("v1", "play_card:0:7"), "opaque label parse");
foreach (var body in new[] { "", "{", "null", "[]", "0", "{}", "{\"action\":\"choose_map_node\",\"index\":0}",
    "{\"state_version\":1,\"label\":\"a\"}", "{\"state_version\":\"v\",\"label\":null}",
    "{\"state_version\":\"v\",\"label\":\"\"}", "{\"state_version\":\"v\",\"label\":\"a\",\"label\":\"b\"}",
    "{\"state_version\":\"v\",\"label\":\"a\",\"action\":\"quit\"}" }) {
    bool rejected = false;
    try { Call(protocol, null, "ParseAction", body); } catch (TargetInvocationException e) when (e.InnerException is JsonException) { rejected = true; }
    Check(rejected, "invalid body " + body);
}
var sessionType = assembly.GetType("STS2_MCP.BridgeSession", true)!;
var session = Activator.CreateInstance(sessionType, true)!;
string Observe(string fingerprint) => (string)Call(sessionType, session, "Observe", fingerprint)!;
int Accept(string version, string label, string[] legal) => (int)Call(sessionType, session, "Accept", version, label, legal)!;
var v = Observe("state A");
Check(v == Observe("state A"), "stable reads");
Check(Accept(v, "a", Array.Empty<string>()) == 422, "empty legal set");
foreach (var label in new[] { "menu_select", "quit", "abandon", "delete", "switch", "unknown" })
    Check(Accept(v, label, new[] { "a" }) == 422, "unknown/dangerous label");
Check(Accept("stale", "a", new[] { "a" }) == 409, "stale rejected");
Check(Accept(v, "a", new[] { "a" }) == 0, "accepted singleton");
Check(Accept(v, "a", new[] { "a" }) == 409, "duplicate/inflight rejected");
Check(v == Observe("state A"), "dispatch isn't proof of state change");
Check(Accept(v, "a", new[] { "a" }) == 409, "GET doesn't rearm consumed version");
var next = Observe("state B");
Check(Accept(next, "a", new[] { "a" }) == 409, "intermediate observation must not clear in-flight mutation without completion");
Check(next != v, "observed change advances");
Check(Accept(v, "a", new[] { "a" }) == 409, "stale after change");
var returned = Observe("state A");
Check(returned != v && returned != next, "ABA has fresh revision");
Check(Accept(returned, "a", new[] { "a" }) == 409, "unknown completion stays latched across ABA");
// No completed-task/child-selection API exists yet: these must NOT rearm an unowned callback.
foreach (var fingerprint in new[] { "child selection", "task complete-looking state", "fault", "timeout", "state A" })
    Check(Accept(Observe(fingerprint), "a", new[] { "a" }) == 409, "unverified boundary stays latched: " + fingerprint);
var other = Activator.CreateInstance(sessionType, true)!;
Check((string)Call(sessionType, other, "Observe", "state A")! != returned, "restart/session epoch");

// Actual BridgeSession controller with retained task/owner identity, not a copied legality model.
object OwnedSession(object owner, Task completion, Task visual, Func<Task?> execution, Func<bool>? cancelled = null)
{
    var s = Activator.CreateInstance(sessionType, true)!;
    var version = (string)Call(sessionType, s, "Observe", "same-looking card")!;
    Check((int)Call(sessionType, s, "Accept", version, "play_card:0:none", new[] { "play_card:0:none" })! == 0, "accept before ownership");
    Call(sessionType, s, "Track", owner, completion, visual, execution, cancelled ?? (() => false));
    return s;
}
bool Pending(object s) => (bool)sessionType.GetProperty("Pending", flags)!.GetValue(s)!;
string? Failure(object s) => (string?)sessionType.GetProperty("Failure", flags)!.GetValue(s);
var cardA = new object(); var cardB = new object();
var completion = new TaskCompletionSource(); var visual = new TaskCompletionSource();
Task? executionTask = null;
var owned = OwnedSession(cardA, completion.Task, visual.Task, () => executionTask);
Check(ReferenceEquals(sessionType.GetProperty("OperationOwner", flags)!.GetValue(owned), cardA), "exact duplicate-card owner retained");
Call(sessionType, owned, "Refresh"); Check(Pending(owned), "delayed enqueue is not completion");
var intermediate = (string)Call(sessionType, owned, "Observe", "changed inventory/hand")!;
Check((int)Call(sessionType, owned, "Accept", intermediate, "b", new[] { "b" })! == 409, "new revision while owned task incomplete");
bool replacementRejected = false;
try { Call(sessionType, owned, "Track", cardB, Task.CompletedTask, Task.CompletedTask, (Func<Task?>)(() => Task.CompletedTask), (Func<bool>)(() => false)); }
catch (TargetInvocationException e) when (e.InnerException is InvalidOperationException) { replacementRejected = true; }
Check(replacementRejected, "same-looking second owner cannot replace first operation");
completion.SetResult(); executionTask = Task.CompletedTask;
Call(sessionType, owned, "Refresh"); Check(Pending(owned), "VFX still owned after gameplay finishes");
visual.SetResult(); Call(sessionType, owned, "Refresh");
Check(!Pending(owned) && Failure(owned) == null, "verified task completion releases ownership");
var completedVersion = (string)sessionType.GetProperty("Version", flags)!.GetValue(owned)!;
Check(completedVersion != intermediate, "completion advances decision revision");
Check((int)Call(sessionType, owned, "Accept", intermediate, "b", new[] { "b" })! == 409, "intermediate version remains stale");
Check((int)Call(sessionType, owned, "Accept", completedVersion, "b", new[] { "b" })! == 0, "next decision accepted after completion");
foreach (var (task, reason) in new[] {
    (Task.FromException(new Exception("execution failure")), "mutation_faulted"),
    (Task.FromCanceled(new CancellationToken(true)), "mutation_cancelled") })
{
    var faulted = OwnedSession(new object(), Task.CompletedTask, Task.CompletedTask, () => task);
    Call(sessionType, faulted, "Refresh");
    Check(Pending(faulted) && Failure(faulted) == reason, "successful game CompletionTask cannot hide " + reason);
    var revision = (string)Call(sessionType, faulted, "Observe", "later state")!;
    Check((int)Call(sessionType, faulted, "Accept", revision, "a", new[] { "a" })! == 409, "fault/cancel never rearms");
}
foreach (var visualFailure in new[] { Task.FromException(new Exception("VFX failure")), Task.FromCanceled(new CancellationToken(true)) })
{
    var s = OwnedSession(new object(), Task.CompletedTask, visualFailure, () => Task.CompletedTask);
    Call(sessionType, s, "Refresh"); Check(Pending(s) && Failure(s) != null, "VFX faults/cancellation do not release mutation");
}
var purchaseTask = new TaskCompletionSource();
var purchase = OwnedSession(new object(), purchaseTask.Task, Task.CompletedTask, () => purchaseTask.Task);
Call(sessionType, purchase, "Observe", "restocked before AfterItemPurchased"); Call(sessionType, purchase, "Refresh");
Check(Pending(purchase), "shop inventory change does not complete purchase hooks");
purchaseTask.SetResult(); Call(sessionType, purchase, "Refresh"); Check(!Pending(purchase), "full purchase task completion rearms");
var purchaseVersion = (string)sessionType.GetProperty("Version", flags)!.GetValue(purchase)!;
Call(sessionType, purchase, "Refresh");
Check((string)sessionType.GetProperty("Version", flags)!.GetValue(purchase)! == purchaseVersion, "completion is single-use, not a revision ticker");
var canceledBeforeStart = OwnedSession(new object(), new TaskCompletionSource().Task, Task.CompletedTask, () => null, () => true);
Call(sessionType, canceledBeforeStart, "Refresh"); Check(Failure(canceledBeforeStart) == "mutation_cancelled", "cancel before executor starts");
var unknownExecution = OwnedSession(new object(), Task.CompletedTask, Task.CompletedTask, () => throw new Exception("field missing"));
Call(sessionType, unknownExecution, "Refresh"); Check(Failure(unknownExecution) == "mutation_completion_unavailable", "ownership extraction fails closed");
var timedOut = OwnedSession(new object(), new TaskCompletionSource().Task, Task.CompletedTask, () => null);
Call(sessionType, timedOut, "Observe", "timeout then child-looking screen"); Call(sessionType, timedOut, "Refresh");
Check(Pending(timedOut), "timeout/child-looking state does not release operation");
Call(sessionType, timedOut, "Fail", "mutation_dispatch_failed");
Call(sessionType, timedOut, "Refresh"); Check(Pending(timedOut) && Failure(timedOut) == "mutation_dispatch_failed", "dispatch exception stays latched");

bool nextNativeDecision = false;
var turnBarrier = OwnedSession(new object(), Task.CompletedTask, Task.CompletedTask, () => Task.CompletedTask);
Call(sessionType, turnBarrier, "HoldUntil", (Func<bool>)(() => nextNativeDecision));
Call(sessionType, turnBarrier, "Observe", "enemy animation"); Call(sessionType, turnBarrier, "Refresh");
Check(Pending(turnBarrier), "end-turn action completion cannot bypass native next-decision boundary");
nextNativeDecision = true; Call(sessionType, turnBarrier, "Refresh");
Check(!Pending(turnBarrier), "native next-decision boundary releases completed action without joining whole combat loop");
var loopFault = OwnedSession(new object(), new TaskCompletionSource().Task, Task.CompletedTask, () => Task.CompletedTask);
Call(sessionType, loopFault, "HoldUntil", (Func<bool>)(() => throw new Exception("retained loop failed")));
Call(sessionType, loopFault, "Refresh"); Check(Pending(loopFault) && Failure(loopFault) != null, "retained loop fault halts even before action completion");
int cleanupCount = 0;
var multipleCleanup = OwnedSession(new object(), Task.CompletedTask, Task.CompletedTask, () => Task.CompletedTask);
Call(sessionType, multipleCleanup, "OnRelease", (Action)(() => { cleanupCount++; throw new Exception("cleanup failed"); }));
Call(sessionType, multipleCleanup, "OnRelease", (Action)(() => cleanupCount++));
Call(sessionType, multipleCleanup, "Refresh");
Check(cleanupCount == 2 && Pending(multipleCleanup) && Failure(multipleCleanup) != null, "all scoped subscriptions cleaned despite one cleanup exception");

foreach (string unsupported in new[] { "open_shop", "close_shop", "proceed", "advance_dialogue", "open_treasure", "claim_treasure_relic:0" })
{
    bool stopped = false;
    try { Call(protocol, null, "RequireClickCompletion", unsupported, false); }
    catch (TargetInvocationException e) when (e.InnerException is NotSupportedException error && error.Message == "completion_adapter_unavailable:" + unsupported) { stopped = true; }
    Check(stopped, "unsupported root callback rejected while enumerating, before mutation: " + unsupported);
    Call(protocol, null, "RequireClickCompletion", unsupported, true);
}
var eventTasks = new List<Task> { Task.CompletedTask };
var chosenTask = new TaskCompletionSource(); int eventDispatches = 0;
var capturedEvent = (Task)Call(protocol, null, "CaptureAppendedTask", eventTasks, (Action)(() => { eventDispatches++; eventTasks.Add(chosenTask.Task); }))!;
Check(ReferenceEquals(capturedEvent, chosenTask.Task) && eventDispatches == 1 && !capturedEvent.IsCompleted, "native event adapter retains exact appended task after original callback returns");
chosenTask.SetException(new Exception("event failed")); Check(capturedEvent.IsFaulted, "native event task faults cannot be replaced by successful callback return");
foreach (int additions in new[] { 0, 2 })
{
    bool mismatch = false; var candidateTasks = new List<Task>();
    try { Call(protocol, null, "CaptureAppendedTask", candidateTasks, (Action)(() => { for (int i = 0; i < additions; i++) candidateTasks.Add(Task.CompletedTask); })); }
    catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { mismatch = true; }
    Check(mismatch, "event adapter rejects missing or ambiguous native task receipt");
}
bool busyEvent = false; int busyDispatches = 0;
try { Call(protocol, null, "CaptureAppendedTask", new List<Task> { new TaskCompletionSource().Task }, (Action)(() => busyDispatches++)); }
catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { busyEvent = true; }
Check(busyEvent && busyDispatches == 0, "existing event operation blocks callback before mutation");

var chainType = assembly.GetType("STS2_MCP.QueuedActionChain", true)!;
object Chain() => Activator.CreateInstance(chainType, flags, null, new object[] { "destination" }, null)!;
var vote = new object(); var move = new object();
var voteDone = new TaskCompletionSource(); var moveDone = new TaskCompletionSource();
var moveExecution = new TaskCompletionSource(); var chain = Chain();
Call(chainType, chain, "AddRoot", vote, voteDone.Task, (Func<Task?>)(() => voteDone.Task));
Check(Call(chainType, chain, "Poll") == null, "vote without downstream action stays pending");
foreach (var pair in new[] { (Cause: new object(), Destination: "destination"), (Cause: vote, Destination: "wrong") })
{
    bool rejected = false;
    try { Call(chainType, chain, "AddChild", pair.Cause, pair.Destination, move, moveDone.Task, (Func<Task?>)(() => moveExecution.Task)); }
    catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { rejected = true; }
    Check(rejected, "map chain rejects wrong executing vote or destination");
}
Call(chainType, chain, "AddChild", vote, "destination", move, moveDone.Task, (Func<Task?>)(() => moveExecution.Task));
voteDone.SetResult();
Check(((Task)Call(chainType, chain, "Poll")!).IsCompleted == false, "vote completion is not map travel completion");
moveDone.SetResult(); Check(((Task)Call(chainType, chain, "Poll")!).IsCompleted == false, "map completion signal cannot hide pending execution task");
moveExecution.SetException(new Exception("travel failed"));
Check(((Task)Call(chainType, chain, "Poll")!).IsFaulted, "map execution failure surfaces despite successful completion signals");
var noTravel = Chain(); Call(chainType, noTravel, "AddRoot", vote, Task.CompletedTask, (Func<Task?>)(() => Task.CompletedTask));
bool missingTravel = false;
try { Call(chainType, noTravel, "Poll"); } catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { missingTravel = true; }
Check(missingTravel, "completed vote without owned travel fails closed");
var successfulChain = Chain();
Call(chainType, successfulChain, "AddRoot", vote, Task.CompletedTask, (Func<Task?>)(() => Task.CompletedTask));
Call(chainType, successfulChain, "AddChild", vote, "destination", move, Task.CompletedTask, (Func<Task?>)(() => Task.CompletedTask));
Check(((Task)Call(chainType, successfulChain, "Poll")!).IsCompletedSuccessfully, "both map actions and execution tasks permit release");
bool duplicateTravel = false;
try { Call(chainType, successfulChain, "AddChild", vote, "destination", new object(), Task.CompletedTask, (Func<Task?>)(() => Task.CompletedTask)); }
catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { duplicateTravel = true; }
Check(duplicateTravel, "a second downstream map action is not silently adopted");
var unsupportedExit = OwnedSession(new object(), Task.CompletedTask, Task.CompletedTask, () => Task.CompletedTask);
Call(sessionType, unsupportedExit, "HoldUntil", (Func<bool>)(() => throw new NotSupportedException("missing_owned_exit_receipt")));
Call(sessionType, unsupportedExit, "Refresh");
Check(Pending(unsupportedExit) && Failure(unsupportedExit) == "missing_owned_exit_receipt", "missing owned exit receipt is a named safe halt, not success");

var ownershipType = assembly.GetType("STS2_MCP.SelectionOwnership", true)!;
var ownership = Activator.CreateInstance(ownershipType, true)!;
object? Own(string method, params object?[] values) => Call(ownershipType, ownership, method, values);
object selectionOwner = new(); object selector = new(); var selectionTask = new TaskCompletionSource();
object lease;
using ((IDisposable)Own("Enter", selectionOwner)!)
{
    lease = Own("Begin", selector)!;
    Own("Attach", lease, selectionTask.Task);
    bool overlap = false;
    try { Own("Begin", new object()); } catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { overlap = true; }
    Check(overlap, "overlapping/nested selector fails closed rather than guessing ownership");
}
Check(ownershipType.GetProperty("CurrentOwner", flags)!.GetValue(ownership) == null, "selection scope restored synchronously");
Check(ReferenceEquals(Own("Find", selector, selectionOwner), lease), "exact selector/owner token retained");
Check(Own("Find", selector, new object()) == null && Own("Find", new object(), selectionOwner) == null, "foreign owner and wrong selector rejected");
var parentTask = new TaskCompletionSource();
var parentSession = OwnedSession(selectionOwner, parentTask.Task, Task.CompletedTask, () => parentTask.Task);
var childVersion = (string)Call(sessionType, parentSession, "Observe", "child prompt")!;
Check((int)Call(sessionType, parentSession, "AcceptChild", childVersion, "select", new[] { "select" }, new object())! == 409, "foreign child cannot enter parent operation");
Check((int)Call(sessionType, parentSession, "AcceptChild", childVersion, "not-legal", new[] { "select" }, selectionOwner)! == 422, "owned child still requires a currently legal label");
Check((int)Call(sessionType, parentSession, "AcceptChild", childVersion, "select", new[] { "select" }, selectionOwner)! == 0, "owned child continues pending parent");
Check(Pending(parentSession) && (int)Call(sessionType, parentSession, "AcceptChild", childVersion, "select", new[] { "select" }, selectionOwner)! == 409, "child consumes version without completing parent");
selectionTask.SetResult(); Check(Own("Find", selector, selectionOwner) == null, "completed selector is not dispatchable");
using ((IDisposable)Own("Enter", selectionOwner)!)
{
    var newer = Own("Begin", selector)!; Own("Attach", newer, new TaskCompletionSource().Task);
    Check(!(bool)Own("IsCurrent", lease, selectionOwner)!, "reused hand node does not resurrect old selector generation");
    var generationField = lease.GetType().GetField("Generation", flags)!;
    Check((long)generationField.GetValue(newer)! > (long)generationField.GetValue(lease)!, "identical sequential selector UI receives a fresh observation identity");
}
var actionContext = new object(); Own("RegisterContext", actionContext, selectionOwner);
Check(ReferenceEquals(Own("ResolveContext", actionContext), selectionOwner) && Own("ResolveContext", new object()) == null, "only explicitly registered native action contexts resolve to operation owner");
Own("CloseOwner", selectionOwner); Check(Own("Find", selector, selectionOwner) == null && Own("ResolveContext", actionContext) == null, "parent cleanup clears selector and native context ownership");
bool staleScope = false;
using ((IDisposable)Own("Enter", selectionOwner)!)
    try { Own("Begin", new object()); } catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { staleScope = true; }
Check(staleScope, "late async continuation cannot revive a completed or abandoned owner");
parentTask.SetResult(); Call(sessionType, parentSession, "Refresh");
Check(!Pending(parentSession) && (int)Call(sessionType, parentSession, "AcceptChild", childVersion, "select", new[] { "select" }, selectionOwner)! == 409, "completed parent cannot accept stale child");
var flowGate = new TaskCompletionSource(TaskCreationOptions.RunContinuationsAsynchronously);
async Task<object?> ScopeFlow(object owner)
{
    using ((IDisposable)Own("Enter", owner)!)
    {
        await flowGate.Task;
        using ((IDisposable)Own("Enter", (object?)null)!)
            Check(ownershipType.GetProperty("CurrentOwner", flags)!.GetValue(ownership) == null, "foreign contextual scope masks inherited merchant token");
        return ownershipType.GetProperty("CurrentOwner", flags)!.GetValue(ownership);
    }
}
var owner1 = new object(); var owner2 = new object();
var flow1 = ScopeFlow(owner1); var flow2 = ScopeFlow(owner2);
Check(ownershipType.GetProperty("CurrentOwner", flags)!.GetValue(ownership) == null, "async entry does not leak owner to caller");
flowGate.SetResult();
Check(ReferenceEquals(await flow1, owner1) && ReferenceEquals(await flow2, owner2), "parallel async continuations preserve distinct owners");
foreach (var task in new[] { Task.FromException(new Exception("selector failed")), Task.FromCanceled(new CancellationToken(true)) })
{
    var o = new object();
    using ((IDisposable)Own("Enter", o)!) { var l = Own("Begin", new object())!; Own("Attach", l, task); }
    Check((bool)Own("Failed", o)!, "selector fault/cancel cannot be ignored even if parent catches it");
    Own("CloseOwner", o);
}

var queueType = assembly.GetType("STS2_MCP.MainThreadRequests", true)!;
var queue = Activator.CreateInstance(queueType, true)!;
var enqueue = queueType.GetMethod("Enqueue", flags)!.MakeGenericMethod(typeof(int));
Task<int> Enqueue(Func<int> work, CancellationToken token = default) => (Task<int>)enqueue.Invoke(queue, new object[] { work, token })!;
void Drain(int count) => Call(queueType, queue, "Drain", count);
int ran = 0;
var tasks = Enumerable.Range(0, 21).Select(i => Enqueue(() => { ran++; return i; })).ToArray();
Drain(10); Check(ran == 10 && !tasks[10].IsCompleted, "eleventh request retained");
Drain(10); Check(ran == 20 && !tasks[20].IsCompleted, "twenty-first retained");
Drain(10); Check(ran == 21 && tasks.Select(t => t.Result).SequenceEqual(Enumerable.Range(0, 21)), "all work once in order");
using var cancel = new CancellationTokenSource();
var canceled = Enqueue(() => { ran++; return -1; }, cancel.Token);
cancel.Cancel(); Drain(10);
Check(canceled.IsCanceled && ran == 21, "expired queued mutation never executes");
using var executingCancel = new CancellationTokenSource();
var started = Enqueue(() => { executingCancel.Cancel(); return 42; }, executingCancel.Token);
Drain(10); Check(started.Result == 42, "started mutation not falsely canceled/retried");
var failed = Enqueue(() => throw new InvalidOperationException("test"));
var afterFailure = Enqueue(() => 43); Drain(10);
Check(failed.IsFaulted && afterFailure.Result == 43, "fault doesn't drop next work");
if (args.Length > 1)
{
    string gameDir = Path.GetDirectoryName(args[1])!;
    AssemblyLoadContext.Default.Resolving += (_, name) => {
        var path = Path.Combine(gameDir, name.Name + ".dll");
        return File.Exists(path) ? AssemblyLoadContext.Default.LoadFromAssemblyPath(path) : null;
    };
    var game = AssemblyLoadContext.Default.LoadFromAssemblyPath(args[1]);
    foreach (var (name, fields) in new (string, string[])[] {
        ("GameActions.GameAction", new[] { "_executionTask" }),
        ("GameActions.VoteForMapCoordAction", new[] { "_player", "_source", "_destination" }),
        ("GameActions.MoveToMapCoordAction", new[] { "_player", "_destination" }),
        ("GameActions.EndPlayerTurnAction", new[] { "_player", "_turnNumber" }),
        ("Combat.CombatManager", new[] { "_turnLoopTask" }),
        ("Multiplayer.Game.EventSynchronizer", new[] { "_pendingOptionTasks" }),
        ("Nodes.RestSite.NRestSiteButton", new[] { "_isUnclickable" }),
        ("Nodes.Rooms.NMerchantButton", new[] { "_focusedWhileTargeting" }),
        ("Nodes.Screens.Shops.NMerchantInventory", new[] { "_isInputBlocked", "_inputBlocker", "_backButton" }),
        ("Nodes.Rooms.NRestSiteRoom", new[] { "_room", "_runState", "_roomExiting", "_proceedButton" }),
        ("Nodes.Rooms.NTreasureRoom", new[] { "_room", "_runState", "_relicCollection", "_chestButton", "_hasChestBeenOpened", "_isRelicCollectionOpen" }),
        ("Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection", new[] { "_runState", "_holdersInUse", "_openedTicks", "_relicPickingBeganTaskCompletionSource", "_relicPickingCompleteTaskCompletionSource" }),
        ("GameActions.PickRelicAction", new[] { "_player", "_relicIndex", "<TestSynchronizer>k__BackingField" }),
        ("Multiplayer.Game.TreasureRoomRelicSynchronizer", new[] { "_playerCollection", "_localPlayerId" }),
        ("Nodes.Rooms.NEventRoom", new[] { "_event", "_runState" }),
        ("Nodes.Events.NAncientEventLayout", new[] { "_dialogueContainer", "_currentDialogueLine" }),
        ("Events.EventOption", new[] { "BeforeChosen", "<OnChosen>k__BackingField", "<DisableOnChosen>k__BackingField" }),
        ("Nodes.Events.NEventOptionButton", new[] { "<Index>k__BackingField" }),
        ("Multiplayer.Game.EventSynchronizer", new[] { "_playerCollection", "_localPlayerId" }),
        ("Nodes.Cards.Holders.NCardHolder", new[] { "_isClickable" }),
        ("Nodes.Combat.NPlayerHand", new[] { "_prefs", "_selectedCards", "_currentSelectionFilter" }),
        ("Nodes.Potions.NPotionHolder", new[] { "_isUsable" }),
        ("Nodes.Combat.NIntent", new[] { "_intent", "_targets" }),
        ("Nodes.Screens.Map.NMapScreen", new[] { "_paths", "_runState", "_isInputDisabled", "_actAnimTween" }),
        ("Nodes.Screens.CardSelection.NDeckCardSelectScreen", new[] { "_prefs", "_selectedCards" }),
        ("Nodes.Screens.CardSelection.NSimpleCardSelectScreen", new[] { "_prefs", "_selectedCards" }),
        ("Nodes.Screens.CardSelection.NDeckUpgradeSelectScreen", new[] { "_prefs", "_selectedCards" }),
        ("Nodes.Screens.CardSelection.NDeckTransformSelectScreen", new[] { "_prefs", "_selectedCards" }),
        ("Nodes.Screens.CardSelection.NCardRewardAlternativeButton", new[] { "_label" })
    }) foreach (string field in fields)
        Check(game.GetType("MegaCrit.Sts2.Core." + name, true)!.GetField(field, flags) != null, name + "." + field);

    foreach (var (typeName, signalName, argument) in new[] {
        ("Nodes.Rooms.NMerchantButton", "MerchantOpened", "MegaCrit.Sts2.Core.Nodes.Rooms.NMerchantButton"),
        ("Nodes.Screens.Shops.NMerchantInventory", "InventoryClosed", ""),
        ("Nodes.Screens.Map.NMapScreen", "Opened", ""),
        ("Runs.RunManager", "RoomExited", "") })
    {
        var signal = game.GetType("MegaCrit.Sts2.Core." + typeName, true)!.GetEvent(signalName, flags)!;
        var parameters = signal.EventHandlerType!.GetMethod("Invoke")!.GetParameters();
        Check(signal.AddMethod != null && signal.RemoveMethod != null && (argument == "" ? parameters.Length == 0
            : parameters.Length == 1 && parameters[0].ParameterType.FullName == argument), "exact ordinary native signal ABI: " + signalName);
    }
    var godot = Assembly.Load("GodotSharp");
    Check(godot.GetType("Godot.SceneTree", true)!.GetEvent("NodeAdded")!.EventHandlerType!.GetMethod("Invoke")!.GetParameters()[0].ParameterType.FullName == "Godot.Node",
        "scoped NodeAdded native signal supplies exact node identity (metadata, not native execution)");
    foreach (var (type, name, parameters) in new[] {
        ("Nodes.Rooms.NTreasureRoom", "OpenChest", Type.EmptyTypes),
        ("Nodes.Rooms.NTreasureRoom", "EnableSkipAfterDelay", new[] { typeof(float), typeof(System.Threading.CancellationToken) }),
        ("Nodes.Screens.TreasureRoomRelic.NTreasureRoomRelicCollection", "AnimateRelicAwards", new[] { typeof(List<>).MakeGenericType(game.GetType("MegaCrit.Sts2.Core.Entities.TreasureRelicPicking.RelicPickingResult", true)!) }) })
    {
        var method = game.GetType("MegaCrit.Sts2.Core." + type, true)!.GetMethod(name, flags)!;
        Check(method.ReturnType == typeof(Task) && method.GetParameters().Select(p => p.ParameterType).SequenceEqual(parameters), "approved treasure Task ABI: " + name);
    }
    var obtainMethod = game.GetType("MegaCrit.Sts2.Core.Commands.RelicCmd", true)!.GetMethods(flags).Single(m => m.Name == "Obtain" && !m.IsGenericMethod);
    Check(obtainMethod.GetParameters().Select(p => p.ParameterType).SequenceEqual(new[] { game.GetType("MegaCrit.Sts2.Core.Models.RelicModel", true)!, game.GetType("MegaCrit.Sts2.Core.Entities.Players.Player", true)!, typeof(int) })
        && obtainMethod.ReturnType == typeof(Task<>).MakeGenericType(game.GetType("MegaCrit.Sts2.Core.Models.RelicModel", true)!), "only exact non-generic Obtain ABI");
    Check(game.GetType("MegaCrit.Sts2.Core.Nodes.Events.NAncientEventLayout", true)!.GetProperty("IsDialogueOnLastLine", flags)!.PropertyType == typeof(bool), "native last-line input branch predicate ABI");
    Check(game.GetType("MegaCrit.Sts2.Core.Nodes.Rooms.NEventRoom", true)!.GetMethod("Proceed", flags)!.IsStatic, "standard finished-event proceed delegate target ABI");
    foreach (var (type, name) in new[] { ("Nodes.Rooms.NEventRoom", "SetupLayout"), ("Events.EventOption", "Chosen") })
        Check(game.GetType("MegaCrit.Sts2.Core." + type, true)!.GetMethod(name, flags)!.ReturnType == typeof(Task)
            && game.GetType("MegaCrit.Sts2.Core." + type, true)!.GetMethod(name, flags)!.GetParameters().Length == 0,
            "exact approved event original Task ABI: " + name);
    using (var native = File.OpenRead(args[1]))
        Check(Convert.ToHexString(System.Security.Cryptography.SHA256.HashData(native)).Equals(
            (string)protocol.GetField("NativeAssemblySha256", flags)!.GetRawConstantValue()!, StringComparison.OrdinalIgnoreCase),
            "selection hooks pinned to inspected native assembly bytes");
    var commands = game.GetType("MegaCrit.Sts2.Core.Commands.CardSelectCmd", true)!;
    foreach (string name in new[] { "FromHand", "FromHandForDiscard", "FromHandForUpgrade", "FromSimpleGrid", "FromSimpleGridForRewards", "FromChooseACardScreen", "FromCombatPile" })
        Check(commands.GetMethods(BindingFlags.Static | BindingFlags.Public).Any(m => m.Name == name && m.GetParameters().Any(p => p.ParameterType.Name == "PlayerChoiceContext")), "contextual hook target signature: " + name);
    foreach (var (type, name) in new[] { ("Nodes.Combat.NPlayerHand", "SelectCards"), ("Nodes.Screens.CardSelection.NCardGridSelectionScreen", "CardsSelected"),
        ("Nodes.Screens.CardSelection.NChooseACardSelectionScreen", "CardsSelected"), ("Nodes.Screens.CardSelection.NCardRewardSelectionScreen", "OptionSelected"),
        ("Nodes.RestSite.NRestSiteButton", "SelectOption"), ("Nodes.Rewards.NRewardButton", "GetReward") })
        Check(typeof(Task).IsAssignableFrom(game.GetType("MegaCrit.Sts2.Core." + type, true)!.GetMethod(name, flags)!.ReturnType), "retained native Task signature: " + type + "." + name);
    foreach (var (type, name) in new[] { ("Nodes.Combat.NCombatUi", "ShowRewards"), ("Nodes.Combat.NCombatUi", "ProceedWithoutRewards"),
        ("Rewards.RewardsSet", "Offer"), ("Runs.RunManager", "ProceedFromTerminalRewardsScreen"), ("GameActions.ActionExecutor", "FinishedExecutingActions") })
        Check(game.GetType("MegaCrit.Sts2.Core." + type, true)!.GetMethod(name, flags)!.ReturnType == typeof(Task), "exact owned reward/queue Task API: " + name);
    Check(game.GetType("MegaCrit.Sts2.Core.Nodes.Screens.NRewardsScreen", true)!.GetMethod("ShowScreen", flags)!.GetParameters().Length == 3,
        "exact static reward decision boundary takes RewardsSet/terminal/run identity");
    Check(game.GetType("MegaCrit.Sts2.Core.GameActions.ActionExecutor", true)!.GetEvent("BeforeActionExecuted", flags) != null,
        "native action-reference event exists for post-action batch receipt registration");
    Check(game.GetType("MegaCrit.Sts2.Core.GameActions.ActionExecutor", true)!.GetProperty("CurrentlyRunningAction", flags)!.PropertyType.Name == "GameAction"
        && game.GetType("MegaCrit.Sts2.Core.Runs.RunManager", true)!.GetMethod("ExitCurrentRoom", flags) != null
        && game.GetType("MegaCrit.Sts2.Core.Combat.CombatTurnState", true)!.GetMethod("Cancel", flags)!.GetParameters().Length == 0,
        "old-room exit provenance ABI: executing action identity, RunManager.ExitCurrentRoom, parameterless CombatTurnState.Cancel");
    Check(game.GetType("MegaCrit.Sts2.Core.Nodes.Combat.NEndTurnButton", true)!.GetProperty("CanTurnBeEnded", flags)!.GetMethod!.IsPrivate,
        "end-turn native predicate is private and reflected deliberately");
    var merchantSelection = game.GetType("MegaCrit.Sts2.Core.Nodes.Screens.Shops.NMerchantSlot", true)!.GetMethod("OnSelected", flags)!;
    Check(merchantSelection.IsPrivate && merchantSelection.ReturnType == typeof(Task), "version-grounded merchant Task adapter");
    var bridge = assembly.GetType("STS2_MCP.McpMod", true)!;
    // Production foreground/ownership gate; native Type metadata, managed selector identities only.
    var idleGateSession = Activator.CreateInstance(sessionType, true)!;
    var gateRegistry = Activator.CreateInstance(ownershipType, true)!;
    object Gate(object? overlay, Type? type, bool map, object? hand, object s, object r, object? ownedMap = null)
        => Call(bridge, null, "ResolveObservationSelection", overlay, type, map, hand, s, r, ownedMap)!;
    object? GateValue(object result, string property) => result.GetType().GetProperty(property)!.GetValue(result);
    var exitType = assembly.GetType("STS2_MCP.CombatExitOperation", true)!;
    (object Operation, object[] Identities) NewExit(object operationOwner, Task retainedLoop, bool join, Func<bool> primary, object registry)
    {
        object[] identities = { operationOwner, new object(), new object(), new object(), new object(), new object() };
        var arguments = identities.Concat(new object[] { retainedLoop, join, primary, registry }).ToArray();
        return (Activator.CreateInstance(exitType, flags, null, arguments, null)!, identities);
    }
    var duplicateUi = NewExit(new object(), Task.CompletedTask, false, () => true, Activator.CreateInstance(ownershipType, true)!).Operation;
    Check((bool)Call(exitType, duplicateUi, "BeginUi")!, "first exact exit UI boundary registers before original entry");
    Check(!(bool)Call(exitType, duplicateUi, "BeginUi")! && exitType.GetField("Failure", flags)!.GetValue(duplicateUi) != null,
        "duplicate same-UI entry invalidates old authority without blocking foreign callback");
    var lateUi = NewExit(new object(), Task.CompletedTask, false, () => true, Activator.CreateInstance(ownershipType, true)!).Operation;
    exitType.GetField("Ended", flags)!.SetValue(lateUi, true);
    Check(!(bool)Call(exitType, lateUi, "BeginUi")!, "source order forbids first reward entry after CombatEnded; terminal/death cannot adopt late UI");
    var receiptOwner = new object();
    var receiptRegistry = Activator.CreateInstance(ownershipType, true)!;
    var receiptOperation = NewExit(receiptOwner, Task.CompletedTask, false, () => true, receiptRegistry).Operation;
    Call(exitType, receiptOperation, "RequireExecutionReceipt");
    Call(exitType, receiptOperation, "BindExecutionReceipt", new object(), Task.CompletedTask);
    Check(!(bool)Call(exitType, receiptOperation, "Poll", true)!, "foreign action batch receipt cannot release completed card/potion before post-action win check");
    var nativeBatch = new TaskCompletionSource();
    Call(exitType, receiptOperation, "BindExecutionReceipt", receiptOwner, nativeBatch.Task);
    Check(!(bool)Call(exitType, receiptOperation, "Poll", true)!, "exact native batch remains pending beyond successful GameAction");
    nativeBatch.SetResult();
    Check((bool)Call(exitType, receiptOperation, "Poll", true)!, "only original successful post-action batch receipt permits normal combat continuation");
    Call(exitType, receiptOperation, "BindExecutionReceipt", receiptOwner, Task.CompletedTask);
    bool duplicateReceiptRefused = false;
    try { Call(exitType, receiptOperation, "Check"); } catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { duplicateReceiptRefused = true; }
    Check(duplicateReceiptRefused, "duplicate receipt cannot replace native task identity");
    var exitRegistry = Activator.CreateInstance(ownershipType, true)!;
    var exitOwner = new object(); var exitLoop = new TaskCompletionSource(); var exitPrimary = new TaskCompletionSource();
    var exitSession = OwnedSession(exitOwner, exitPrimary.Task, Task.CompletedTask, () => exitPrimary.Task);
    var (exitOperation, exitIdentities) = NewExit(exitOwner, exitLoop.Task, true,
        () => (bool)sessionType.GetProperty("PrimarySucceeded", flags)!.GetValue(exitSession)!, exitRegistry);
    Call(sessionType, exitSession, "HoldUntil", (Func<bool>)(() => (bool)Call(exitType, exitOperation, "Poll", false)!));
    Call(sessionType, exitSession, "OnRelease", (Action)(() => Call(exitType, exitOperation, "Close")));
    Check((bool)Call(bridge, null, "MatchesRewardEntry", new object[] { exitOperation }.Concat(exitIdentities.Skip(1)).ToArray())!, "exact registered run/room/combat/UI/player tuple matches");
    for (int mismatchIndex = 1; mismatchIndex < exitIdentities.Length; mismatchIndex++)
    {
        var wrong = exitIdentities.Skip(1).ToArray(); wrong[mismatchIndex - 1] = new object();
        Check(!(bool)Call(bridge, null, "MatchesRewardEntry", new object[] { exitOperation }.Concat(wrong).ToArray())!, "wrong native reward identity rejected at production binding");
    }
    var exitPreparation = new TaskCompletionSource(); var exitOffer = new TaskCompletionSource();
    exitType.GetField("Started", flags)!.SetValue(exitOperation, true);
    Call(exitType, exitOperation, "AddTask", exitPreparation.Task, false);
    var backgroundSet = new object(); var backgroundScreen = new object();
    Call(exitType, exitOperation, "BeginSet", backgroundSet); Call(exitType, exitOperation, "AttachOffer", backgroundSet, Task.CompletedTask);
    Call(exitType, exitOperation, "BindScreen", backgroundSet, backgroundScreen, true, true);
    var exitSet = new object(); var exitScreen = new object();
    Call(exitType, exitOperation, "BeginSet", exitSet); Call(exitType, exitOperation, "AttachOffer", exitSet, exitOffer.Task);
    Call(exitType, exitOperation, "BindScreen", exitSet, exitScreen, true, true);
    var rewardScreenType = game.GetType("MegaCrit.Sts2.Core.Nodes.Screens.NRewardsScreen", true)!;
    Check(GateValue(Gate(exitScreen, rewardScreenType, false, null, exitSession, exitRegistry), "Stop") != null,
        "owned reward screen waits for initiating gameplay and teardown; visibility is insufficient");
    exitPrimary.SetResult(); exitLoop.SetResult();
    Call(sessionType, exitSession, "Refresh"); Check(Pending(exitSession), "successful tasks without exact CombatEnded receipt cannot release exit");
    exitType.GetField("Ended", flags)!.SetValue(exitOperation, true);
    Call(sessionType, exitSession, "Refresh");
    var exitDecision = Gate(exitScreen, rewardScreenType, false, null, exitSession, exitRegistry);
    var firstRewardLease = GateValue(exitDecision, "Lease")!;
    Check(Pending(exitSession) && GateValue(exitDecision, "Stop") == null && !exitOffer.Task.IsCompleted && !exitPreparation.Task.IsCompleted,
        "owned reward decision is available without deadlocking on original UI ancestors/Offer spanning human choices");
    exitPreparation.SetResult(); Call(sessionType, exitSession, "Refresh");
    Call(exitType, exitOperation, "ValidateReadyIdentity", exitIdentities[1], exitIdentities[2]);
    bool foreignRoomRefused = false;
    try { Call(exitType, exitOperation, "ValidateReadyIdentity", exitIdentities[1], new object()); }
    catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { foreignRoomRefused = true; }
    Check(foreignRoomRefused, "foreign room change cannot leave an old ready reward decision authorized");
    var exitChild = new TaskCompletionSource(); Call(exitType, exitOperation, "AddTask", exitChild.Task, true);
    Check(GateValue(Gate(exitScreen, rewardScreenType, false, null, exitSession, exitRegistry), "Stop") != null,
        "pending child claim blocks another root reward claim");
    var exitCardSelector = new object(); object exitCardLease;
    using ((IDisposable)Call(ownershipType, exitRegistry, "Enter", exitOwner)!) exitCardLease = Call(ownershipType, exitRegistry, "Begin", exitCardSelector)!;
    Call(ownershipType, exitRegistry, "Attach", exitCardLease, exitChild.Task);
    var exitCardType = game.GetType("MegaCrit.Sts2.Core.Nodes.Screens.CardSelection.NCardRewardSelectionScreen", true)!;
    Check(GateValue(Gate(exitCardSelector, exitCardType, false, null, exitSession, exitRegistry), "Stop") == null,
        "claim's exact card selector remains actionable while parent claim and Offer are pending");
    exitChild.SetResult(); Call(sessionType, exitSession, "Refresh");
    var nextRewardLease = GateValue(Gate(exitScreen, rewardScreenType, false, null, exitSession, exitRegistry), "Lease");
    Check(nextRewardLease != null && !ReferenceEquals(firstRewardLease, nextRewardLease)
        && !(bool)Call(ownershipType, exitRegistry, "IsCurrent", firstRewardLease, exitOwner)!, "sequential reward choices renew generation and reject late child permission");
    var exitProceed = new TaskCompletionSource(); var exitMap = new object();
    Call(exitType, exitOperation, "Transition", exitProceed.Task, exitScreen, exitMap);
    exitProceed.SetResult(); Call(sessionType, exitSession, "Refresh");
    Check(Pending(exitSession) && Call(ownershipType, exitRegistry, "Find", exitScreen, exitOwner) == null
        && GateValue(Gate(null, null, true, null, exitSession, exitRegistry, exitMap), "Stop") == null,
        "native proceed Task transfers explicit permission to map while outstanding Offer is retained");
    Call(exitType, exitOperation, "ConsumeMap");
    var exitMove = new TaskCompletionSource(); var exitTravel = new object();
    Call(exitType, exitOperation, "AddMapWork", (Func<Task?>)(() => exitMove.Task), (Func<bool>)(() => false));
    Check(new[] { "ExpectRoomExit", "TravelExecuting", "RoomExited" }.All(name => exitType.GetMethod(name, flags) != null),
        "controller must carry owned old-room exit receipts; the prior DLL falsely halted combat_loop_cancelled on legitimate owned map travel");
    Call(exitType, exitOperation, "ExpectRoomExit", exitTravel, (Func<bool>)(() => true));
    exitOffer.SetResult(); Call(sessionType, exitSession, "Refresh"); Check(Pending(exitSession), "room-exit reward skip cannot hide pending owned movement");
    Call(exitType, exitOperation, "TravelExecuting", exitTravel, exitIdentities[1], exitIdentities[2], (Func<object?>)(() => exitLoop.Task));
    exitMove.SetResult(); Call(sessionType, exitSession, "Refresh");
    Check(Pending(exitSession) && Failure(exitSession) == null, "successful joined loop and movement tasks without the owned old-room exit receipt stay pending, even for end-turn victory");
    Call(exitType, exitOperation, "RoomExited", exitIdentities[1], new object(), exitTravel);
    Call(sessionType, exitSession, "Refresh");
    Check(!Pending(exitSession) && Call(ownershipType, exitRegistry, "Find", exitMap, exitOwner) == null
        && Call(ownershipType, exitRegistry, "Find", backgroundScreen, exitOwner) == null, "owned room-entry completion closes old-room reward backdrops; all original parent/child lanes complete and cleanup invalidates map continuation");
    Check(!(bool)Call(bridge, null, "MatchesRewardEntry", new object[] { exitOperation }.Concat(exitIdentities.Skip(1)).ToArray())!, "closed operation rejects late native entry");
    var sequentialRegistry = Activator.CreateInstance(ownershipType, true)!; var sequentialOwner = new object();
    var sequentialFlow = NewExit(sequentialOwner, Task.CompletedTask, false, () => true, sequentialRegistry).Operation;
    exitType.GetField("Ended", flags)!.SetValue(sequentialFlow, true); exitType.GetField("Started", flags)!.SetValue(sequentialFlow, true);
    var sequentialSet = new object(); var sequentialScreen = new object(); var sequentialOffer = new TaskCompletionSource(); var sequentialChild = new TaskCompletionSource();
    Call(exitType, sequentialFlow, "BeginSet", sequentialSet);
    Call(exitType, sequentialFlow, "AttachOffer", sequentialSet, sequentialOffer.Task);
    Call(exitType, sequentialFlow, "BindScreen", sequentialSet, sequentialScreen, false, true);
    Call(exitType, sequentialFlow, "AddTask", sequentialChild.Task, true);
    sequentialOffer.SetResult();
    Check(!(bool)Call(exitType, sequentialFlow, "Poll", false)! && (bool)Call(exitType, sequentialFlow, "OwnsScreen", sequentialScreen)!, "completed nonterminal Offer cannot outrun original GetReward child UI update");
    sequentialChild.SetResult();
    Check((bool)Call(exitType, sequentialFlow, "Poll", false)! && !(bool)Call(exitType, sequentialFlow, "OwnsScreen", sequentialScreen)!, "native nonterminal auto-close follows both original Offer and child completion, not scene visibility");
    var inputRegistry = Activator.CreateInstance(ownershipType, true)!;
    var inputFlow = NewExit(new object(), Task.CompletedTask, false, () => true, inputRegistry).Operation;
    var inputSet = new object(); var inputScreen = new object();
    Call(exitType, inputFlow, "BeginSet", inputSet); Call(exitType, inputFlow, "BindScreen", inputSet, inputScreen, true, true);
    using ((IDisposable)Call(bridge, null, "BeginRewardCapture", inputFlow, 3, inputScreen, null, true)!)
        Call(bridge, null, "RewardInputObserved", inputFlow, inputScreen);
    Check(exitType.GetField("Failure", flags)!.GetValue(inputFlow) == null, "native owned button release preserves explicit dispatch authority");
    Call(bridge, null, "RewardInputObserved", inputFlow, inputScreen);
    Check((string?)exitType.GetField("Failure", flags)!.GetValue(inputFlow) == "foreign_reward_input", "human input on same reward screen invalidates bridge permission without blocking native callback");
    Call(exitType, inputFlow, "Close");
    foreach (var failedChild in new[] { Task.FromException(new Exception("claim failed")), Task.FromCanceled(new CancellationToken(true)) })
    {
        var faultRegistry = Activator.CreateInstance(ownershipType, true)!; var faultOwner = new object();
        var faultSession = OwnedSession(faultOwner, Task.CompletedTask, Task.CompletedTask, () => Task.CompletedTask);
        var faultOperation = NewExit(faultOwner, Task.CompletedTask, false, () => true, faultRegistry).Operation;
        Call(exitType, faultOperation, "AddTask", failedChild, true);
        Call(sessionType, faultSession, "HoldUntil", (Func<bool>)(() => (bool)Call(exitType, faultOperation, "Poll", false)!));
        Call(sessionType, faultSession, "Refresh");
        Check(Pending(faultSession) && Failure(faultSession) != null, "child failure/cancellation permanently blocks parent release");
    }
    foreach (bool join in new[] { false, true })
    {
        var terminalRegistry = Activator.CreateInstance(ownershipType, true)!; var terminalOwner = new object();
        var terminalLoop = new TaskCompletionSource();
        var terminalSession = OwnedSession(terminalOwner, Task.CompletedTask, Task.CompletedTask, () => Task.CompletedTask);
        var terminalOperation = NewExit(terminalOwner, terminalLoop.Task, join, () => true, terminalRegistry).Operation;
        Call(sessionType, terminalSession, "HoldUntil", (Func<bool>)(() => (bool)Call(exitType, terminalOperation, "Poll", false)!));
        Call(sessionType, terminalSession, "Refresh"); Check(Pending(terminalSession), "card/potion/end-turn cannot infer exit from combat flag alone");
        exitType.GetField("Ended", flags)!.SetValue(terminalOperation, true);
        Call(sessionType, terminalSession, "Refresh");
        Check(Pending(terminalSession) == join, "death receipt plus original gameplay tasks distinguishes card/potion from owned end-turn loop");
        terminalLoop.SetResult(); Call(sessionType, terminalSession, "Refresh");
        Check(!Pending(terminalSession), "source-grounded terminal receipt releases to terminal observation, not technical failure");
    }
    // Retained non-join loop legitimately cancelled by the owned map travel's native old-room exit:
    // MoveToMapCoordAction -> EnterMapPointInternal -> ExitCurrentRoom -> CombatRoom.Exit -> Reset(true) -> CombatTurnState.Cancel
    // (parameterless TrySetCanceled) -> RoomExited. Production BridgeSession/CombatExitOperation/QueuedActionChain receipts only.
    foreach (string scenario in new[] { "final", "delayed-offer", "delayed-arrival", "loop-success-missing-exit", "cancel-before-map", "cancel-before-travel",
        "cancel-armed-without-exit", "exit-before-executing", "exit-foreign-action", "exit-wrong-run", "exit-room-still-current", "exit-duplicate",
        "executing-wrong-room", "executing-wrong-run", "executing-wrong-loop", "executing-early-cancel", "loop-fault-after-exit",
        "movement-fault", "movement-cancel", "movement-sticky-cancel", "offer-fault", "join-loop-cancel",
        "run-cleanup-after-exit", "run-replaced-after-exit", "run-cleanup-before-arrival", "run-cleanup-armed", "run-cleanup-before-travel" })
    {
        var teardownRegistry = Activator.CreateInstance(ownershipType, true)!; var teardownOwner = new object();
        var endSignal = new TaskCompletionSource();
        async Task RetainedLoop() { await endSignal.Task; }
        var loop = RetainedLoop();
        var teardownSession = OwnedSession(teardownOwner, Task.CompletedTask, Task.CompletedTask, () => Task.CompletedTask);
        var (op, ids) = NewExit(teardownOwner, loop, scenario == "join-loop-cancel",
            () => (bool)sessionType.GetProperty("PrimarySucceeded", flags)!.GetValue(teardownSession)!, teardownRegistry);
        object run = ids[1], room = ids[2]; object? currentRun = run, currentRoom = room; int releases = 0;
        object? Op(string name, params object?[] values) // Unwrapped: BridgeSession.Refresh must observe the controller's own NotSupportedException names.
        {
            try { return Call(exitType, op, name, values); }
            catch (TargetInvocationException e) { System.Runtime.ExceptionServices.ExceptionDispatchInfo.Capture(e.InnerException!).Throw(); throw; }
        }
        void Refresh() => Call(sessionType, teardownSession, "Refresh");
        bool Refused(Action attempt)
        {
            try { attempt(); return false; }
            catch (NotSupportedException) { return true; }
        }
        var offer = new TaskCompletionSource(); object set = new(), screen = new(), map = new();
        var travelChain = Chain(); object teardownVote = new(), travel = new();
        var travelDone = new TaskCompletionSource(); var travelExecution = new TaskCompletionSource();
        bool travelCancelled = false, arrived = scenario is not ("delayed-arrival" or "run-cleanup-before-arrival");
        async Task Settle() { try { await loop; } catch (Exception) { } }
        void ExpectHalt(string reason)
        {
            Refresh();
            Check(Failure(teardownSession) == reason && Pending(teardownSession) && (bool)exitType.GetField("Closed", flags)!.GetValue(op)! && releases == 1, scenario + " halts as " + reason + ", actual " + (Failure(teardownSession) ?? "none") + " releases=" + releases);
            offer.TrySetResult(); travelDone.TrySetResult(); travelExecution.TrySetResult(); arrived = true; endSignal.TrySetResult();
            currentRun = run; currentRoom = new object(); Refresh(); // Restored/original run identity cannot heal either.
            currentRun = new object(); Refresh();
            Check(Failure(teardownSession) == reason && Pending(teardownSession) && releases == 1, scenario + ": later receipts, a restored run or a new run cannot heal the halt; cleanup ran exactly once");
        }
        Op("RequireExecutionReceipt"); Op("BindExecutionReceipt", teardownOwner, Task.CompletedTask);
        Call(sessionType, teardownSession, "OnRelease", (Action)(() => { releases++; Op("Close"); }));
        // Exact RegisterCombatExit callback shape: Poll, then ValidateReadyIdentity against the current run/room.
        Call(sessionType, teardownSession, "HoldUntil", (Func<bool>)(() => { bool done = (bool)Op("Poll", false)!; Op("ValidateReadyIdentity", currentRun, currentRoom); return done; }));
        Check((bool)Op("BeginUi")!, scenario + ": reward UI entry");
        exitType.GetField("Ended", flags)!.SetValue(op, true);
        Op("BeginSet", set); Op("AttachOffer", set, offer.Task); Op("BindScreen", set, screen, true, true);
        Refresh(); Op("Transition", Task.CompletedTask, screen, map); Refresh();
        Check(ReferenceEquals(exitType.GetField("Map", flags)!.GetValue(op), map) && Pending(teardownSession) && Failure(teardownSession) == null, scenario + ": terminal proceed retains the map continuation");
        Check(Refused(() => Op("ExpectRoomExit", travel, (Func<bool>)(() => arrived))), scenario + ": travel without a consumed map continuation is unowned");
        if (scenario is "cancel-before-map" or "join-loop-cancel") { endSignal.TrySetCanceled(); await Settle(); ExpectHalt("combat_loop_cancelled"); continue; }
        Op("ConsumeMap"); Op("AddMapWork", (Func<Task?>)(() => (Task?)Call(chainType, travelChain, "Poll")), (Func<bool>)(() => travelCancelled));
        Call(chainType, travelChain, "AddRoot", teardownVote, Task.CompletedTask, (Func<Task?>)(() => Task.CompletedTask));
        Call(chainType, travelChain, "AddChild", teardownVote, "destination", travel, travelDone.Task, (Func<Task?>)(() => travelExecution.Task));
        Op("ExpectRoomExit", travel, (Func<bool>)(() => ReferenceEquals(currentRun, run) && arrived));
        Check(Refused(() => Op("ExpectRoomExit", new object(), (Func<bool>)(() => true))), scenario + ": a second travel is not adopted");
        Refresh(); Check(Pending(teardownSession) && Failure(teardownSession) == null, scenario + ": queued owned teardownVote/travel stays pending without failure");
        if (scenario == "run-cleanup-before-travel") { currentRun = null; currentRoom = null; ExpectHalt("reward_run_invalidated"); continue; }
        if (scenario == "cancel-before-travel") { endSignal.TrySetCanceled(); await Settle(); ExpectHalt("combat_loop_cancelled"); continue; }
        if (scenario == "exit-before-executing") { Op("RoomExited", run, null, travel); ExpectHalt("unowned_room_exit"); continue; }
        if (scenario == "executing-early-cancel") { endSignal.TrySetCanceled(); await Settle(); }
        Op("TravelExecuting", new object(), run, room, (Func<object?>)(() => loop)); // Foreign executing action is ignored, never armed.
        Op("TravelExecuting", travel, scenario == "executing-wrong-run" ? new object() : run, scenario == "executing-wrong-room" ? new object() : room,
            (Func<object?>)(() => scenario == "executing-wrong-loop" ? Task.CompletedTask : loop));
        if (scenario.StartsWith("executing-")) { ExpectHalt("map_travel_provenance_unverified"); continue; }
        Refresh(); Check(Pending(teardownSession) && Failure(teardownSession) == null, scenario + ": armed travel stays pending without failure");
        if (scenario == "run-cleanup-armed") { currentRun = null; currentRoom = null; ExpectHalt("reward_run_invalidated"); continue; } // CleanUp: no RoomExited, run nulled.
        if (scenario == "cancel-armed-without-exit") { endSignal.TrySetCanceled(); await Settle(); ExpectHalt("combat_loop_cancelled"); continue; }
        if (scenario == "loop-success-missing-exit")
        {
            endSignal.SetResult(); await Settle(); offer.SetResult(); travelDone.SetResult(); travelExecution.SetResult(); Refresh();
            Check(Pending(teardownSession) && Failure(teardownSession) == null && loop.IsCompletedSuccessfully, scenario + ": successful loop and movement without the owned old-room exit receipt never release");
            continue;
        }
        if (scenario == "offer-fault") offer.SetException(new Exception("original offer")); // BeforeLeavingRoom settles the skipped Offer before Exit.
        else if (scenario != "delayed-offer") offer.SetResult();
        currentRoom = null; Op("RoomExited", scenario == "exit-wrong-run" ? new object() : run, scenario == "exit-room-still-current" ? room : null,
            scenario == "exit-foreign-action" ? new object() : travel);
        if (scenario == "exit-duplicate") Op("RoomExited", run, null, travel);
        if (scenario.StartsWith("exit-")) { ExpectHalt("unowned_room_exit"); continue; }
        if (scenario == "loop-fault-after-exit") { endSignal.SetException(new Exception("loop died")); await Settle(); ExpectHalt("combat_loop_faulted"); continue; }
        endSignal.TrySetCanceled(); await Settle(); // Native CombatTurnState.Cancel: no token.
        Check(loop.IsCanceled, scenario + ": retained loop is cancelled by the native signal");
        if (scenario == "offer-fault") { ExpectHalt("reward_work_faulted"); continue; } // Original Offer faults are still inspected while the loop is cancelled.
        Refresh(); Check(Pending(teardownSession) && Failure(teardownSession) == null && !(bool)exitType.GetField("Closed", flags)!.GetValue(op)!, scenario + ": authorized teardown cancellation waits for the movement, never completes");
        if (scenario == "movement-sticky-cancel") travelCancelled = true;
        travelDone.SetResult();
        if (scenario == "movement-fault") travelExecution.SetException(new Exception("original travel"));
        else if (scenario == "movement-cancel") travelExecution.SetCanceled();
        else travelExecution.SetResult();
        if (scenario == "movement-fault") { ExpectHalt("reward_work_faulted"); continue; }
        if (scenario is "movement-cancel" or "movement-sticky-cancel") { ExpectHalt("reward_work_cancelled"); continue; }
        currentRoom = new object(); // Valid same-run travel changes the current room; only the run identity is permanent.
        if (scenario == "run-cleanup-before-arrival") { Refresh(); Check(Pending(teardownSession) && Failure(teardownSession) == null && releases == 0, scenario + ": same-run travel not yet at the destination stays pending"); currentRun = null; currentRoom = null; ExpectHalt("reward_run_invalidated"); continue; }
        if (scenario == "run-cleanup-after-exit") { currentRun = null; currentRoom = null; ExpectHalt("reward_run_invalidated"); continue; } // Main menu after successful movement, before the next observation.
        if (scenario == "run-replaced-after-exit") { currentRun = new object(); ExpectHalt("reward_run_invalidated"); continue; }
        if (scenario == "delayed-offer") { Refresh(); Check(Pending(teardownSession) && Failure(teardownSession) == null, scenario + ": unfinished original Offer still blocks release"); offer.SetResult(); }
        if (scenario == "delayed-arrival") { Refresh(); Check(Pending(teardownSession) && Failure(teardownSession) == null, scenario + ": same-run exact destination is required before release"); arrived = true; }
        Refresh();
        Check(!Pending(teardownSession) && Failure(teardownSession) == null && (bool)exitType.GetField("Closed", flags)!.GetValue(op)!
            && Call(ownershipType, teardownRegistry, "Find", map, teardownOwner) == null && releases == 1, scenario + ": owned old-room exit plus all original receipts release and clean up exactly once");
    }
    foreach (bool join in new[] { false, true })
    {
        // Even the fully observed old-room exit never authorizes a cancelled end-turn (joined) loop; the non-join lane may only wait.
        var guarded = NewExit(new object(), Task.FromCanceled(new CancellationToken(true)), join, () => true, Activator.CreateInstance(ownershipType, true)!).Operation;
        exitType.GetField("Ended", flags)!.SetValue(guarded, true); exitType.GetField("_teardown", flags)!.SetValue(guarded, 2);
        Call(exitType, guarded, "AddMapWork", (Func<Task?>)(() => Task.CompletedTask), (Func<bool>)(() => false));
        bool cancelledRefused = false;
        try { Call(exitType, guarded, "Poll", false); } catch (TargetInvocationException e) when (e.InnerException is NotSupportedException { Message: "combat_loop_cancelled" }) { cancelledRefused = true; }
        Check(cancelledRefused == join, "joined end-turn loop cancellation is never authorized; authorized non-join cancellation waits: join=" + join);
    }
    var lingering = new object();
    var rewardType = game.GetType("MegaCrit.Sts2.Core.Nodes.Screens.CardSelection.NCardRewardSelectionScreen", true)!;
    var mapGate = Gate(lingering, rewardType, true, new object(), idleGateSession, gateRegistry);
    Check(GateValue(mapGate, "Overlay") == null && GateValue(mapGate, "Stop") == null && GateValue(mapGate, "Lease") == null,
        "observation gate ignores lingering reward and hand beneath foreground map");
    Check(GateValue(Gate(lingering, rewardType, false, null, idleGateSession, gateRegistry), "Stop") != null,
        "foreground unowned reward selector still halts");
    foreach (string typeName in new[] { "NCardGridSelectionScreen", "NChooseACardSelectionScreen" })
    {
        var nativeType = game.GetType("MegaCrit.Sts2.Core.Nodes.Screens.CardSelection." + typeName, true)!;
        var selectorIdentity = new object(); var gateOwner = new object();
        var gateParent = OwnedSession(gateOwner, new TaskCompletionSource().Task, Task.CompletedTask, () => null);
        Check(GateValue(Gate(selectorIdentity, nativeType, true, null, gateParent, gateRegistry), "Stop") != null,
            "real selection type remains above map and requires ownership: " + typeName);
        object gateLease;
        using ((IDisposable)Call(ownershipType, gateRegistry, "Enter", gateOwner)!) gateLease = Call(ownershipType, gateRegistry, "Begin", selectorIdentity)!;
        Call(ownershipType, gateRegistry, "Attach", gateLease, new TaskCompletionSource().Task);
        var ownedGate = Gate(selectorIdentity, nativeType, true, null, gateParent, gateRegistry);
        Check(GateValue(ownedGate, "Stop") == null && ReferenceEquals(GateValue(ownedGate, "Lease"), gateLease)
            && ReferenceEquals(GateValue(ownedGate, "Overlay"), selectorIdentity), "owned foreground selection survives map precedence: " + typeName);
        Call(ownershipType, gateRegistry, "CloseOwner", gateOwner);
    }
    foreach (string phase in new[] { "card_select", "card_reward", "map", "rewards" })
    {
        var snapshot = new Dictionary<string, object?> { ["state_type"] = phase };
        var visibleBattle = new Dictionary<string, object?> { ["enemies"] = new[] { new { hp = 12, block = 3, powers = new[] { "visible power" }, intents = new[] { "visible attack" } } }, ["round"] = 2 };
        int builds = 0;
        Call(bridge, null, "AddSelectionBattleContext", snapshot, true, (Func<Dictionary<string, object?>>)(() => { builds++; return visibleBattle; }));
        bool selectionPhase = phase is "card_select" or "card_reward";
        Check(builds == (selectionPhase ? 1 : 0) && (!selectionPhase || ReferenceEquals(snapshot["battle"], visibleBattle)),
            "production combat-selection branch retains full observed battle context: " + phase);
        var inactive = new Dictionary<string, object?> { ["state_type"] = phase };
        Call(bridge, null, "AddSelectionBattleContext", inactive, false, (Func<Dictionary<string, object?>>)(() => throw new Exception("inactive combat read")));
        Check(!inactive.ContainsKey("battle"), "no battle disclosure outside active combat: " + phase);
    }
    // Production readiness helper + production FinishObservation, no copied waiting/completeness formula.
    var mapState = new Dictionary<string, object?> { ["state_type"] = "map" };
    mapState["waiting"] = Call(protocol, null, "IsWaiting", "map", false, true, false, false);
    var legalType = bridge.GetNestedType("LegalAction", BindingFlags.NonPublic)!;
    var mapActions = (System.Collections.IList)Activator.CreateInstance(typeof(List<>).MakeGenericType(legalType))!;
    var legalCtor = legalType.GetConstructors(flags).Single(c => c.GetParameters().Length == 4);
    // Waiting must remove executable siblings too: DispatchLabel consumes Observation.Actions, not the completeness flag.
    var partialActions = (System.Collections.IList)Activator.CreateInstance(typeof(List<>).MakeGenericType(legalType))!;
    partialActions.Add(legalCtor.Invoke(new object[] { "discard_potion:0", "Discard potion", (Func<bool>)(() => throw new Exception("observation dispatched")), "potion" }));
    var partialState = new Dictionary<string, object?> { ["state_type"] = "map", ["waiting"] = true };
    var partialObservation = Call(bridge, null, "FinishObservation", partialState, partialActions, "waiting map with potion")!;
    Check(partialState["legal_actions_complete"] is false && partialActions.Count == 0,
        "waiting map must withhold the potion sibling from both wire and executable action sets");
    // Production gate + finalizer + session acceptance; booleans stand for native reads, not Godot nodes.
    // Exercise earlier AND later siblings, and a ready input after an unreadable one (must not heal the decision).
    foreach (var (name, inputs, siblings) in new (string, bool[], string[])[] {
        ("map fade with discard", new[] { false, false, false }, new[] { "discard_potion:0" }),
        ("partial map with usable potion", new[] { true, false, true }, new[] { "discard_potion:0", "use_potion:0:none" }),
        ("hidden usable potion holder", new[] { false, true }, new[] { "choose_map_node:0", "discard_potion:1" }),
        ("valid unreadable potion target", new[] { true, false, true }, new[] { "end_turn", "discard_potion:0" }),
        ("ready map and potion", new[] { true, true, true }, new[] { "discard_potion:0", "use_potion:0:none" }),
        ("no eligible inputs", Array.Empty<bool>(), new[] { "discard_potion:0" }) })
    {
        var decisionState = new Dictionary<string, object?> { ["state_type"] = "map", ["waiting"] = false };
        var decisionActions = (System.Collections.IList)Activator.CreateInstance(typeof(List<>).MakeGenericType(legalType))!;
        int callbackCount = 0;
        void AddDecisionAction(string label) => decisionActions.Add(legalCtor.Invoke(new object[] { label, label,
            (Func<bool>)(() => { callbackCount++; return true; }), label }));
        AddDecisionAction(siblings[0]);
        for (int i = 0; i < inputs.Length; i++)
            if ((bool)Call(bridge, null, "DecisionInputReady", decisionState, inputs[i])!) AddDecisionAction("choice:" + i);
        foreach (var label in siblings.Skip(1)) AddDecisionAction(label);
        int offered = decisionActions.Count;
        var decisionObservation = Call(bridge, null, "FinishObservation", decisionState, decisionActions, name)!;
        bool ready = inputs.All(x => x);
        var decisionLabels = decisionActions.Cast<object>().Select(a => (string)legalType.GetProperty("Label")!.GetValue(a)!).ToArray();
        Check((decisionState["waiting"] is true) == !ready && (decisionState["legal_actions_complete"] is true) == ready
            && decisionActions.Count == (ready ? offered : 0) && callbackCount == 0,
            "whole decision readiness, never sibling pruning: " + name);
        Check(ReferenceEquals(decisionObservation.GetType().GetProperty("Actions")!.GetValue(decisionObservation), decisionActions)
            && ReferenceEquals(decisionState["legal_actions"], decisionActions), "wire and POST use the same withheld set: " + name);
        var decisionSession = Activator.CreateInstance(sessionType, true)!;
        string decisionVersion = (string)Call(sessionType, decisionSession, "Observe", (string)decisionState["state_version"]!)!;
        Check(((int)Call(sessionType, decisionSession, "Accept", decisionVersion, siblings[0], decisionLabels)! == 0) == ready,
            "POST cannot consume a sibling from an unreadable current decision: " + name);
        object decisionOwner = new(); var decisionRoot = new TaskCompletionSource();
        var childSession = OwnedSession(decisionOwner, Task.CompletedTask, Task.CompletedTask, () => decisionRoot.Task);
        string decisionChildVersion = (string)Call(sessionType, childSession, "Observe", name)!;
        Check(((int)Call(sessionType, childSession, "AcceptChild", decisionChildVersion, siblings[0], decisionLabels, decisionOwner)! == 0) == ready
            && Pending(childSession), "same whole-set gate applies to an owned child without releasing its parent: " + name);
        if (!ready)
        {
            var withheldVersion = (string)decisionState["state_version"]!;
            // A new observation, not elapsed time or a cosmetic completion receipt, re-exposes the complete set.
            var nextState = new Dictionary<string, object?> { ["state_type"] = "map", ["waiting"] = false };
            foreach (var label in siblings.Concat(Enumerable.Range(0, inputs.Length).Select(i => "choice:" + i))) AddDecisionAction(label);
            Call(bridge, null, "FinishObservation", nextState, decisionActions, name);
            Check(nextState["legal_actions_complete"] is true && decisionActions.Count == siblings.Length + inputs.Length
                && !Equals(nextState["state_version"], withheldVersion), "all alternatives return together with a fresh version: " + name);
        }
    }
    // R2: exercise the actual screen binder, session/selection gate and whole-set finalizer.
    // The old ABI fallback lets this safety regression demonstrate the old DLL's unsafe permission.
    void BindTutorialScreen(object flow, object set, object screen, bool seenAtEntry)
    {
        object?[] args = exitType.GetMethod("BindScreen", flags)!.GetParameters().Length == 3
            ? new object?[] { set, screen, true } : new object?[] { set, screen, true, seenAtEntry };
        Call(exitType, flow, "BindScreen", args);
    }
    foreach (bool seenAtEntry in new[] { false, true })
    {
        var tutorialRegistry = Activator.CreateInstance(ownershipType, true)!;
        var tutorialOwner = new object(); var tutorialScreen = new object(); var tutorialSet = new object();
        var tutorialSession = OwnedSession(tutorialOwner, Task.CompletedTask, Task.CompletedTask, () => Task.CompletedTask);
        var tutorialFlow = NewExit(tutorialOwner, Task.CompletedTask, false, () => true, tutorialRegistry).Operation;
        exitType.GetField("Started", flags)!.SetValue(tutorialFlow, true);
        exitType.GetField("Ended", flags)!.SetValue(tutorialFlow, true);
        Call(exitType, tutorialFlow, "BeginSet", tutorialSet);
        Call(exitType, tutorialFlow, "AttachOffer", tutorialSet, new TaskCompletionSource().Task);
        var tutorialPoll = (Func<bool, bool>)exitType.GetMethod("Poll", flags)!.CreateDelegate(typeof(Func<bool, bool>), tutorialFlow);
        Call(sessionType, tutorialSession, "HoldUntil", (Func<bool>)(() => tutorialPoll(false)));
        Call(sessionType, tutorialSession, "OnRelease", (Action)(() => Call(exitType, tutorialFlow, "Close")));
        // Current flags can flip either way; only the entry snapshot proves this screen's early return.
        bool seenNow = !seenAtEntry;
        BindTutorialScreen(tutorialFlow, tutorialSet, tutorialScreen, seenAtEntry);
        Call(sessionType, tutorialSession, "Refresh");
        var tutorialGate = Gate(tutorialScreen, rewardScreenType, false, null, tutorialSession, tutorialRegistry);
        var tutorialState = Failure(tutorialSession) is { } reason
            ? (Dictionary<string, object?>)Call(bridge, null, "HaltState", reason)!
            : (Dictionary<string, object?>?)GateValue(tutorialGate, "Stop") ?? new() { ["state_type"] = "rewards" };
        int tutorialDispatches = 0;
        var tutorialActions = (System.Collections.IList)Activator.CreateInstance(typeof(List<>).MakeGenericType(legalType))!;
        foreach (var label in new[] { "claim_reward:0", "proceed" })
            tutorialActions.Add(legalCtor.Invoke(new object[] { label, label, (Func<bool>)(() => { tutorialDispatches++; return true; }), label }));
        var tutorialObservation = Call(bridge, null, "FinishObservation", tutorialState, tutorialActions, "tutorial fixture")!;
        var tutorialOutput = (Dictionary<string, object?>)tutorialObservation.GetType().GetProperty("State")!.GetValue(tutorialObservation)!;
        Check((tutorialOutput["legal_actions_complete"] is true) == seenAtEntry
            && ((System.Collections.ICollection)tutorialOutput["legal_actions"]!).Count == (seenAtEntry ? 2 : 0),
            "R2: unseen obtain_relic_ftue at entry must reject ALL reward choices; seen entry preserves both choices");
        Check(tutorialDispatches == 0, "tutorial refusal/observation never executes a reward callback");
        if (!seenAtEntry)
        {
            Check(Failure(tutorialSession) == "reward_relic_ftue_completion_unverified", "separate relic tutorial refusal, not combat_reward_ftue skip readiness");
            BindTutorialScreen(tutorialFlow, tutorialSet, tutorialScreen, seenNow);
            Check(Call(ownershipType, tutorialRegistry, "Find", tutorialScreen, tutorialOwner) == null,
                "later seen flag cannot reopen a screen/operation with unresolved detached tutorial work");
            var tutorialVersion = (string)Call(sessionType, tutorialSession, "Observe", "flag changed; modal not yet visible")!;
            Check((int)Call(sessionType, tutorialSession, "AcceptChild", tutorialVersion, "claim_reward:0", new[] { "claim_reward:0" }, tutorialOwner)! == 409,
                "entry refusal remains sticky before any modal becomes visible");
        }
        else
        {
            var modalObservation = Call(bridge, null, "FinishObservation", Call(bridge, null, "HaltState", "blocking_modal_or_tutorial"), tutorialActions, "existing modal fixture")!;
            var modalState = (Dictionary<string, object?>)modalObservation.GetType().GetProperty("State")!.GetValue(modalObservation)!;
            Check(modalState["legal_actions_complete"] is false && ((System.Collections.ICollection)modalState["legal_actions"]!).Count == 0,
                "seen entry does not override the existing blocking-modal halt or prune it into a partial legal set");
            Call(exitType, tutorialFlow, "Close");
        }
    }
    string? PolicyReason(bool shared, bool embedded)
    {
        try { Call(protocol, null, "RequireEventPolicy", shared, embedded); return null; }
        catch (TargetInvocationException e) { return e.InnerException!.Message; }
    }
    // Any unsupported CURRENT alternative (policy, callback shape, lethal confirmation) clears the whole decision; no per-event admission remains.
    foreach (var reason in new[] { PolicyReason(true, false), PolicyReason(false, true), "event_option_callback_unverified", "event_lethal_confirmation_unverified" })
    {
        Check(reason != null, "unsupported current alternative has a diagnostic");
        int callbacks = 0;
        var eventActions = (System.Collections.IList)Activator.CreateInstance(typeof(List<>).MakeGenericType(legalType))!;
        eventActions.Add(legalCtor.Invoke(new object[] { "choose_event_option:0", "earlier choice", (Func<bool>)(() => { callbacks++; return true; }), "event" }));
        var refused = Call(bridge, null, "FinishObservation", Call(bridge, null, "HaltState", reason!), eventActions, "event policy fixture")!;
        var output = (Dictionary<string, object?>)refused.GetType().GetProperty("State")!.GetValue(refused)!;
        Check(output["legal_actions_complete"] is false && ((System.Collections.ICollection)output["legal_actions"]!).Count == 0 && callbacks == 0,
            "unsupported event branch clears earlier alternatives without invoking a callback");
    }
    foreach (var tutorial in new[] { "merchant_ftue", "rest_site_ftue", "map_select_ftue" })
    {
        string? reason = null;
        try { Call(protocol, null, "RequireOrdinaryTutorial", false, tutorial); }
        catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { reason = e.InnerException.Message; }
        Check(reason == "ordinary_tutorial_unverified:" + tutorial, "specific unsupported ordinary tutorial");
        int calls = 0;
        var ordinaryActions = (System.Collections.IList)Activator.CreateInstance(typeof(List<>).MakeGenericType(legalType))!;
        foreach (var label in new[] { "open_shop", "close_shop", "choose_rest_option:0", "proceed" })
            ordinaryActions.Add(legalCtor.Invoke(new object[] { label, label, (Func<bool>)(() => { calls++; return true; }), label }));
        var refused = Call(bridge, null, "FinishObservation", Call(bridge, null, "HaltState", reason), ordinaryActions, "ordinary fixture")!;
        var output = (Dictionary<string, object?>)refused.GetType().GetProperty("State")!.GetValue(refused)!;
        Check(output["legal_actions_complete"] is false && ((System.Collections.ICollection)output["legal_actions"]!).Count == 0 && calls == 0,
            "unsupported ordinary tutorial invalidates ALL alternatives before any click");
        Call(protocol, null, "RequireOrdinaryTutorial", true, tutorial);
    }
    mapActions.Add(legalCtor.Invoke(new object[] { "choose_map_node:0", "Travel to visible node", (Func<bool>)(() => true), "map-node" }));
    var mapObservation = Call(bridge, null, "FinishObservation", mapState, mapActions, "fixture-run")!;
    var finishedMap = (Dictionary<string, object?>)mapObservation.GetType().GetProperty("State", flags)!.GetValue(mapObservation)!;
    Check(finishedMap["state_type"] is "map" && finishedMap["waiting"] is false
        && finishedMap["legal_actions_complete"] is true && ((System.Collections.IList)finishedMap["legal_actions"]!).Count == 1,
        "effective map above completed combat is ready, complete, and retains travel label");
    var rejectedObservation = Call(bridge, null, "FinishObservation", Call(bridge, null, "HaltState", "completion_adapter_unavailable:proceed"), mapActions, "unsupported fixture")!;
    var rejectedState = (Dictionary<string, object?>)rejectedObservation.GetType().GetProperty("State")!.GetValue(rejectedObservation)!;
    Check(rejectedState["legal_actions_complete"] is false && ((System.Collections.ICollection)rejectedState["legal_actions"]!).Count == 0,
        "production observation finalizer removes ALL earlier choices when a required callback lacks completion");
    Check((bool)Call(protocol, null, "IsWaiting", "monster", false, true, false, false)!, "completed combat without map/rewards still waits");
    Check((bool)Call(protocol, null, "IsWaiting", "map", true, true, false, false)!, "busy map still waits");

    // Card-reward readiness: recorded open-card-reward-immediate.json exposed only Skip as a complete decision while native
    // DisableCardsForShortTimeAfterOpening held the offered holders unclickable. Ownership is checked first; the production
    // readiness helper then withholds the whole set, and the ready set later appears under the same retained owner/lease.
    Check(protocol.GetMethod("RewardCardsInputDisabled", flags) != null, "old card-reward branch presents the native initial-disable Skip-only window as a ready decision");
    var readinessRegistry = Activator.CreateInstance(ownershipType, true)!;
    var readinessOwner = new object(); var readinessParent = new TaskCompletionSource();
    var readinessSession = OwnedSession(readinessOwner, readinessParent.Task, Task.CompletedTask, () => readinessParent.Task);
    var readinessSelector = new object(); object readinessLease;
    using ((IDisposable)Call(ownershipType, readinessRegistry, "Enter", readinessOwner)!) readinessLease = Call(ownershipType, readinessRegistry, "Begin", readinessSelector)!;
    var readinessChoice = new TaskCompletionSource<int?>();
    Call(ownershipType, readinessRegistry, "Attach", readinessLease, readinessChoice.Task);
    Call(sessionType, readinessSession, "Refresh");
    var readinessGate = Gate(readinessSelector, exitCardType, false, null, readinessSession, readinessRegistry);
    Check(GateValue(readinessGate, "Stop") == null && ReferenceEquals(GateValue(readinessGate, "Lease"), readinessLease),
        "ownership precedes readiness: exact owned pending card-reward selector is admitted before card input is checked");
    var readinessLabels = new[] { "select_card_reward:0", "select_card_reward:1", "select_card_reward:2", "card_reward_alternative:0" };
    string? waitingVersion = null, waitingSessionVersion = null;
    foreach (var (phase, clickable) in new (string, bool?[])[] { ("disabled", new bool?[] { false, false, false }), ("partial", new bool?[] { true, false, true }),
        ("ready", new bool?[] { true, true, true }), ("alternative_only", Array.Empty<bool?>()), ("missing", new bool?[] { true, null, true }) })
    {
        int rewardDispatches = 0;
        var rewardActions = (System.Collections.IList)Activator.CreateInstance(typeof(List<>).MakeGenericType(legalType))!;
        var rewardState = new Dictionary<string, object?> { ["state_type"] = "card_reward", ["waiting"] = Call(protocol, null, "IsWaiting", "card_reward", false, true, false, false) };
        string? refusal = null; bool disabled = false;
        try { disabled = (bool)Call(protocol, null, "RewardCardsInputDisabled", clickable)!; }
        catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { refusal = e.InnerException.Message; }
        Check(disabled == (phase is "disabled" or "partial") && refusal == (phase == "missing" ? "card_holder_clickability_unavailable" : null),
            "any offered holder in native initial input-disable withholds the decision; zero-card/alternative-only stays ready; missing metadata fails closed: " + phase);
        if (disabled) rewardState["waiting"] = true;
        if (refusal != null) rewardState = (Dictionary<string, object?>)Call(bridge, null, "HaltState", refusal)!;
        if (!disabled) foreach (var label in readinessLabels.Skip(phase == "alternative_only" ? 3 : 0))
            rewardActions.Add(legalCtor.Invoke(new object[] { label, label, (Func<bool>)(() => { rewardDispatches++; return true; }), label }));
        var rewardObservation = Call(bridge, null, "FinishObservation", rewardState, rewardActions, "reward fixture:selection:" + ownershipType.GetNestedType("Lease", BindingFlags.NonPublic)!.GetField("Generation", flags)!.GetValue(readinessLease))!;
        var rewardOutput = (Dictionary<string, object?>)rewardObservation.GetType().GetProperty("State")!.GetValue(rewardObservation)!;
        var rewardLabels = ((System.Collections.IEnumerable)rewardOutput["legal_actions"]!).Cast<object>().Select(a => (string)legalType.GetProperty("Label")!.GetValue(a)!).ToArray();
        var rewardVersion = (string)rewardOutput["state_version"]!;
        string sessionVersion = (string)Call(sessionType, readinessSession, "Observe", "reward fixture:" + phase + ":" + string.Join("|", rewardLabels) + ":" + rewardOutput.GetValueOrDefault("waiting"))!;
        Check(Pending(readinessSession) && (bool)Call(ownershipType, readinessRegistry, "IsCurrent", readinessLease, readinessOwner)!
            && ReferenceEquals(GateValue(Gate(readinessSelector, exitCardType, false, null, readinessSession, readinessRegistry), "Lease"), readinessLease),
            "parent operation and exact child lease are retained across the readiness window: " + phase);
        if (disabled)
        {
            Check(rewardOutput["state_type"] is "card_reward" && rewardOutput["waiting"] is true && rewardOutput["legal_actions_complete"] is false && rewardLabels.Length == 0,
                "initial-disable window is a waiting, incomplete card_reward observation with no alternatives: " + phase);
            Check((int)Call(sessionType, readinessSession, "AcceptChild", sessionVersion, "card_reward_alternative:0", rewardLabels, readinessOwner)! != 0
                && (int)Call(sessionType, readinessSession, "AcceptChild", sessionVersion, "select_card_reward:0", rewardLabels, readinessOwner)! != 0,
                "waiting reward observation cannot dispatch Skip or any sibling label: " + phase);
            waitingVersion = rewardVersion; waitingSessionVersion = sessionVersion;
        }
        else if (refusal != null)
            Check(rewardOutput["legal_actions_complete"] is false && rewardLabels.Length == 0 && !(rewardOutput.GetValueOrDefault("waiting") is true),
                "missing clickability metadata halts the whole observation instead of a permanent wait or pruned choices");
        else
        {
            Check(rewardOutput["waiting"] is false && rewardOutput["legal_actions_complete"] is true
                && rewardLabels.SequenceEqual(readinessLabels.Skip(phase == "alternative_only" ? 3 : 0)),
                "ready holders expose takes and Skip together; alternative-only rewards stay actionable: " + phase);
            Check(waitingVersion != null && rewardVersion != waitingVersion, "production fingerprint gives the ready decision a fresh version: " + phase);
            Check((int)Call(sessionType, readinessSession, "AcceptChild", waitingSessionVersion!, "card_reward_alternative:0", rewardLabels, readinessOwner)! == 409,
                "a choice made against the waiting version is rejected once the set is ready: " + phase);
            Check((int)Call(sessionType, readinessSession, "AcceptChild", sessionVersion, "card_reward_alternative:0", rewardLabels, readinessOwner)! == 0
                && Pending(readinessSession), "ready Skip is accepted as a child continuation without releasing the parent: " + phase);
        }
        Check(rewardDispatches == 0, "observation never executes a reward callback: " + phase);
    }

    // Production event-binding/latch helper with a controlled event source. No native GameAction instantiation.
    var bindCancellation = sessionType.GetMethod("TrackCancellable", flags)!.MakeGenericMethod(typeof(object));
    var events = new Dictionary<object, Action<object>?>();
    var canceledStates = new Dictionary<object, bool>();
    object BindAction(object a)
    {
        events[a] = null; canceledStates[a] = false;
        var s = Activator.CreateInstance(sessionType, true)!;
        var version = (string)Call(sessionType, s, "Observe", "card decision")!;
        Check((int)Call(sessionType, s, "Accept", version, "card", new[] { "card" })! == 0, "accept event-bound card");
        bindCancellation.Invoke(s, new object[] { a, Task.CompletedTask, Task.CompletedTask,
            (Func<Task?>)(() => Task.CompletedTask), (Func<bool>)(() => canceledStates[a]),
            (Action<Action<object>>)(handler => events[a] += handler),
            (Action<Action<object>>)(handler => events[a] -= handler) });
        Check(events[a] != null, "production cancellation helper subscribes");
        return s;
    }
    var transientAction = new object(); var transientSession = BindAction(transientAction);
    canceledStates[transientAction] = true;
    events[transientAction]!(transientAction);
    canceledStates[transientAction] = false; // Native Execute can overwrite Canceled with Finished.
    Call(sessionType, transientSession, "Refresh");
    Check(Pending(transientSession) && Failure(transientSession) == "mutation_cancelled", "event cancellation survives Canceled-to-Finished between polls");
    Check(events[transientAction] == null, "cancellation failure unsubscribes");
    foreach (var cleanup in new[] { "Refresh", "Fail", "Dispose" })
    {
        var a = new object(); var s = BindAction(a);
        events[a]!(new object()); // A different duplicate-looking action cannot cancel this owner.
        if (cleanup == "Fail") Call(sessionType, s, cleanup, "dispatch failure");
        else Call(sessionType, s, cleanup);
        Check(events[a] == null, "subscription cleanup on " + cleanup);
        if (cleanup == "Refresh") Check(!Pending(s) && Failure(s) == null, "different action identity cannot cancel owner");
    }
    // Invoke the actual selection boundary hook callbacks, not a second ownership model.
    var hookedRegistry = bridge.GetField("SelectionOwners", flags)!.GetValue(null)!;
    var hookOwner = new object(); var hookSelector = new object(); var hookTask = new TaskCompletionSource();
    object?[] hookArgs = { hookSelector, null };
    using ((IDisposable)Call(ownershipType, hookedRegistry, "Enter", hookOwner)!)
        bridge.GetMethod("SelectionBoundaryPrefix", flags)!.Invoke(null, hookArgs);
    Call(bridge, null, "SelectionBoundaryPostfix", hookTask.Task, hookArgs[1]);
    Check(ReferenceEquals(Call(ownershipType, hookedRegistry, "Find", hookSelector, hookOwner), hookArgs[1]), "production boundary hook binds exact selector to async owner");
    Call(bridge, null, "SelectionBoundaryFinalizer", new Exception("boundary failure"), hookArgs[1]);
    Check((bool)Call(ownershipType, hookedRegistry, "Failed", hookOwner)! && Call(ownershipType, hookedRegistry, "Find", hookSelector, hookOwner) == null, "production finalizer faults and invalidates lease");
    Call(ownershipType, hookedRegistry, "CloseOwner", hookOwner);
    // Harmony detours only this managed fixture; never initialize or invoke a game selector.
    var harmonyAssembly = AssemblyLoadContext.Default.LoadFromAssemblyPath(Path.Combine(gameDir, "0Harmony.dll"));
    var harmonyType = harmonyAssembly.GetType("HarmonyLib.Harmony", true)!;
    var harmonyMethodType = harmonyAssembly.GetType("HarmonyLib.HarmonyMethod", true)!;
    const string testPatchId = "sts2mcp.offline-selection-boundary-check";
    var patcher = Activator.CreateInstance(harmonyType, testPatchId)!;
    object Hook(string name) => Activator.CreateInstance(harmonyMethodType, bridge.GetMethod(name, flags)!)!;
    try
    {
        var target = typeof(ManagedSelectorFixture).GetMethod("Select")!;
        harmonyType.GetMethod("Patch")!.Invoke(patcher, new[] { target, Hook("SelectionBoundaryPrefix"), Hook("SelectionBoundaryPostfix"), null, Hook("SelectionBoundaryFinalizer") });
        var fixture = new ManagedSelectorFixture(); var gate = new TaskCompletionSource<int>(); var fixtureOwner = new object();
        using ((IDisposable)Call(ownershipType, hookedRegistry, "Enter", fixtureOwner)!)
            Check(ReferenceEquals(fixture.Select(gate), gate.Task), "Harmony boundary preserves actual generic Task result");
        Check(Call(ownershipType, hookedRegistry, "Find", fixture, fixtureOwner) != null, "real Harmony prefix/postfix retain selector lease");
        gate.SetResult(1); Check(Call(ownershipType, hookedRegistry, "Find", fixture, fixtureOwner) == null, "real Harmony task completion invalidates lease");
        Call(ownershipType, hookedRegistry, "CloseOwner", fixtureOwner);
        var capture = typeof(ManagedSelectorFixture).GetMethod("Capture")!;
        harmonyType.GetMethod("Patch")!.Invoke(patcher, new[] { capture, Hook("SelectionContextEnter"), null, null, Hook("SelectionContextFinalizer") });
        ManagedSelectorFixture.CurrentOwner = () => ownershipType.GetProperty("CurrentOwner", flags)!.GetValue(hookedRegistry);
        var context1 = new object(); var context2 = new object(); var owned1 = new object(); var owned2 = new object();
        Call(ownershipType, hookedRegistry, "RegisterContext", context1, owned1);
        Call(ownershipType, hookedRegistry, "RegisterContext", context2, owned2);
        var contextGate = new TaskCompletionSource(TaskCreationOptions.RunContinuationsAsynchronously);
        var captured1 = fixture.Capture(context1, contextGate.Task); var captured2 = fixture.Capture(context2, contextGate.Task);
        Check(ManagedSelectorFixture.CurrentOwner() == null, "real Harmony context finalizer restores caller before returned Tasks complete");
        contextGate.SetResult();
        Check(ReferenceEquals(await captured1, owned1) && ReferenceEquals(await captured2, owned2), "real Harmony scopes retain exact independent async owners across await");
        Call(ownershipType, hookedRegistry, "CloseOwner", owned1); Call(ownershipType, hookedRegistry, "CloseOwner", owned2);
        // Same production entry/postfix/finalizer used by the native reward hooks, detouring managed code only.
        var rewardCapture = typeof(ManagedSelectorFixture).GetMethod("CaptureReward")!;
        harmonyType.GetMethod("Patch")!.Invoke(patcher, new[] { rewardCapture, Hook("EnterRewardUi"), Hook("RewardTaskPostfix"), null, Hook("RewardTaskFinalizer") });
        var rewardScopes = bridge.GetField("RewardScopes", flags)!.GetValue(null)!;
        ManagedSelectorFixture.CurrentRewardOwner = () => {
            var frame = ownershipType.GetProperty("CurrentOwner", flags)!.GetValue(rewardScopes);
            return frame?.GetType().GetProperty("Operation")!.GetValue(frame);
        };
        var hookFlow1 = NewExit(new object(), Task.CompletedTask, false, () => true, Activator.CreateInstance(ownershipType, true)!).Operation;
        var hookFlow2 = NewExit(new object(), Task.CompletedTask, false, () => true, Activator.CreateInstance(ownershipType, true)!).Operation;
        var rewardGate = new TaskCompletionSource(TaskCreationOptions.RunContinuationsAsynchronously);
        var retained1 = fixture.CaptureReward(hookFlow1, false, rewardGate.Task);
        Check(ReferenceEquals(fixture.SeenAtEntry, hookFlow1), "reward owner installed BEFORE synchronous native-equivalent entry");
        var retained2 = fixture.CaptureReward(hookFlow2, false, rewardGate.Task);
        Check(ManagedSelectorFixture.CurrentRewardOwner() == null, "reward caller scope restores before native-equivalent Tasks finish");
        object FirstWork(object flow) => ((System.Collections.IEnumerable)exitType.GetField("_work", flags)!.GetValue(flow)!).Cast<object>().Single();
        var work1 = FirstWork(hookFlow1);
        Check(ReferenceEquals(((Func<Task?>)work1.GetType().GetProperty("Task")!.GetValue(work1)!)(), retained1), "production postfix retains ORIGINAL generic native Task object");
        rewardGate.SetResult();
        Check(ReferenceEquals(await retained1, hookFlow1) && ReferenceEquals(await retained2, hookFlow2), "separate reward async flows preserve exact owner across await");
        Call(exitType, hookFlow1, "Close");
        Check(await fixture.CaptureReward(hookFlow1, false, Task.CompletedTask) == null, "late callback cannot resurrect closed reward scope");
        Check(await fixture.CaptureReward(new object(), false, Task.CompletedTask) == null, "foreign native-equivalent entry remains unowned and unblocked");
        var faultGate = new TaskCompletionSource();
        var faultCapture = fixture.CaptureReward(hookFlow2, false, faultGate.Task);
        faultGate.SetException(new Exception("native reward failure"));
        try { await faultCapture; } catch (Exception) { }
        bool hookFailure = false;
        try { Call(exitType, hookFlow2, "Check"); } catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { hookFailure = true; }
        Check(hookFailure, "production task hook surfaces asynchronous native failure");
        Call(exitType, hookFlow2, "Close");
    }
    finally { harmonyType.GetMethod("UnpatchAll")!.Invoke(patcher, new object[] { testPatchId }); }
    var reusedSelector = new object(); var reusedOwner = new object();
    object?[] reusedArgs = { reusedSelector, null };
    using ((IDisposable)Call(ownershipType, hookedRegistry, "Enter", reusedOwner)!)
        bridge.GetMethod("SelectionBoundaryPrefix", flags)!.Invoke(null, reusedArgs);
    Call(bridge, null, "SelectionBoundaryPostfix", new TaskCompletionSource().Task, reusedArgs[1]);
    object?[] foreignReuse = { reusedSelector, null };
    bridge.GetMethod("SelectionBoundaryPrefix", flags)!.Invoke(null, foreignReuse);
    Call(bridge, null, "SelectionBoundaryPostfix", new TaskCompletionSource().Task, foreignReuse[1]);
    Check(foreignReuse[1] == null && !(bool)Call(ownershipType, hookedRegistry, "IsCurrent", reusedArgs[1], reusedOwner)!
        && (bool)Call(ownershipType, hookedRegistry, "Failed", reusedOwner)!, "foreign reentry on SAME selector invalidates old child dispatch without blocking foreign callback");
    var reusedParent = OwnedSession(reusedOwner, new TaskCompletionSource().Task, Task.CompletedTask, () => null);
    var rejectedReuse = Gate(null, null, false, reusedSelector, reusedParent, hookedRegistry);
    Check(GateValue(rejectedReuse, "Lease") == null && GateValue(rejectedReuse, "Stop") != null,
        "actual observation gate offers no child permission after foreign same-hand reuse");
    Call(ownershipType, hookedRegistry, "CloseOwner", reusedOwner);
    object?[] foreignArgs = { new object(), null };
    bridge.GetMethod("SelectionBoundaryPrefix", flags)!.Invoke(null, foreignArgs);
    Check(foreignArgs[1] == null, "foreign/human selector is neither instrumented nor blocked");
    var liveSession = bridge.GetField("_bridgeSession", flags)!.GetValue(null)!;
    var nativeTask = new TaskCompletionSource();
    var nativeVersion = (string)Call(sessionType, liveSession, "Observe", "native task fixture")!;
    Call(sessionType, liveSession, "Accept", nativeVersion, "start", new[] { "start" });
    object? taskOwner = null;
    Check((bool)Call(bridge, null, "DispatchOwnedTask", (Func<Task>)(() => {
        taskOwner = ownershipType.GetProperty("CurrentOwner", flags)!.GetValue(hookedRegistry);
        return nativeTask.Task;
    }))!, "actual native-task adapter starts original task");
    Check(taskOwner != null && ReferenceEquals(taskOwner, sessionType.GetProperty("OperationOwner", flags)!.GetValue(liveSession)), "native-task adapter retains exact per-operation owner");
    Call(sessionType, liveSession, "Refresh"); Check(Pending(liveSession), "native-task adapter cannot release pending original task");
    nativeTask.SetResult(); Call(sessionType, liveSession, "Refresh"); Check(!Pending(liveSession), "native-task adapter releases successful original task");
    var controllerVersion = (string)Call(sessionType, liveSession, "Observe", "owned reward controller fixture")!;
    Call(sessionType, liveSession, "Accept", controllerVersion, "start", new[] { "start" });
    Call(bridge, null, "DispatchOwnedTask", (Func<Task>)(() => Task.CompletedTask));
    var controllerOwner = sessionType.GetProperty("OperationOwner", flags)!.GetValue(liveSession)!;
    var controllerFlow = NewExit(controllerOwner, Task.CompletedTask, false,
        () => (bool)sessionType.GetProperty("PrimarySucceeded", flags)!.GetValue(liveSession)!, hookedRegistry).Operation;
    exitType.GetField("Started", flags)!.SetValue(controllerFlow, true); exitType.GetField("Ended", flags)!.SetValue(controllerFlow, true);
    var controllerSet = new object(); var controllerScreen = new object(); var controllerOffer = new TaskCompletionSource();
    Call(exitType, controllerFlow, "BeginSet", controllerSet); Call(exitType, controllerFlow, "BindScreen", controllerSet, controllerScreen, true, true);
    Call(exitType, controllerFlow, "AttachOffer", controllerSet, controllerOffer.Task);
    bridge.GetField("_combatExit", flags)!.SetValue(null, controllerFlow);
    Call(sessionType, liveSession, "HoldUntil", (Func<bool>)(() => (bool)Call(exitType, controllerFlow, "Poll", false)!));
    Call(sessionType, liveSession, "OnRelease", (Action)(() => { Call(exitType, controllerFlow, "Close"); bridge.GetField("_combatExit", flags)!.SetValue(null, null); }));
    var controllerChild = new TaskCompletionSource();
    using ((IDisposable)Call(bridge, null, "BeginRewardCapture", controllerFlow, 3, controllerScreen, null, false)!)
        Call(bridge, null, "DispatchOwnedTask", (Func<Task>)(() => controllerChild.Task));
    Check(ReferenceEquals(sessionType.GetProperty("OperationOwner", flags)!.GetValue(liveSession), controllerOwner),
        "ACTUAL DispatchOwnedTask reward-child routing cannot replace the retained parent owner");
    Check(ReferenceEquals(sessionType.GetField("_completion", flags)!.GetValue(liveSession), Task.CompletedTask),
        "ACTUAL child controller preserves original parent's completion Task");
    Call(sessionType, liveSession, "Refresh"); Check(Pending(liveSession), "actual controller retains pending child Task");
    controllerChild.SetResult(); Call(sessionType, liveSession, "Refresh");
    Check(Pending(liveSession) && (bool)Call(exitType, controllerFlow, "CanDecide")!, "actual completed child returns to retained parent decision without dropping Offer");
    Call(exitType, controllerFlow, "CompleteScreen", controllerScreen); controllerOffer.SetResult(); Call(sessionType, liveSession, "Refresh");
    Check(!Pending(liveSession) && bridge.GetField("_combatExit", flags)!.GetValue(null) == null, "actual session release cleans reward owner and registrations");
    bool rejectedTips = false;
    var tips = Array.CreateInstance(game.GetType("MegaCrit.Sts2.Core.HoverTips.IHoverTip", true)!, 1);
    try { Call(bridge, null, "BuildHoverTips", (object)tips); }
    catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { rejectedTips = true; }
    Check(rejectedTips, "a failing hover-tip must halt, not return a partial list");
    foreach (var json in new[] { "{\"deck\":[{\"description\":null}]}", "{\"relic_description\":\"\"}",
        "{\"keywords\":[{\"description\":null}]}", "{\"event_id\":\"e\",\"body\":null}" })
    {
        using var doc = JsonDocument.Parse(json);
        bool rejectedText = false;
        try { Call(protocol, null, "ValidateRulesText", doc.RootElement); }
        catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { rejectedText = true; }
        Check(rejectedText, "missing required text " + json);
    }
    using (var doc = JsonDocument.Parse("{\"deck\":[{\"description\":\"Deal 6 damage.\",\"star_cost\":null}],\"counter\":null,\"unplayable_reason\":null}"))
        Call(protocol, null, "ValidateRulesText", doc.RootElement);
    Check(Call(bridge, null, "SafeGetText", (Func<object?>)(() => null)) == null, "optional null remains optional");
    bool getterRejected = false;
    try { Call(protocol, null, "RequiredText", (Func<string?>)(() => throw new Exception("getter failed"))); }
    catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { getterRejected = true; }
    Check(getterRejected, "required getter failure halts");
    var opcodes = typeof(OpCodes).GetFields(BindingFlags.Public | BindingFlags.Static)
        .Where(f => f.FieldType == typeof(OpCode)).Select(f => (OpCode)f.GetValue(null)!)
        .ToDictionary(op => unchecked((ushort)op.Value));
    List<MethodBase> CalledMethods(string name) => CalledBy(bridge.GetMethod(name, flags) ?? throw new Exception("missing compiled production method " + name));
    // Compiler-generated closures of one production method: local functions (g__) and lambdas (b__).
    List<MethodBase> CalledInClosures(string name) => bridge.GetNestedTypes(flags).SelectMany(t => t.GetMethods(flags))
        .Where(m => m.Name.StartsWith("<" + name + ">")).SelectMany(CalledBy).ToList();
    List<MethodBase> CalledBy(MethodBase method) => Operands(method).OfType<MethodBase>().ToList();
    // Resolved method, type (typeof/isinst/castclass) and string operands of one compiled method body.
    List<object> Operands(MethodBase method)
    {
        var bytes = method.GetMethodBody()!.GetILAsByteArray()!;
        var operands = new List<object>();
        for (int i = 0; i < bytes.Length;)
        {
            ushort value = bytes[i++];
            if (value == 0xfe) value = (ushort)(0xfe00 + bytes[i++]);
            var op = opcodes[value];
            if (op.OperandType == OperandType.InlineMethod)
                operands.Add(method.Module.ResolveMethod(BitConverter.ToInt32(bytes, i))!);
            else if (op.OperandType == OperandType.InlineType)
                operands.Add(method.Module.ResolveType(BitConverter.ToInt32(bytes, i)));
            else if (op.OperandType == OperandType.InlineTok && method.Module.ResolveMember(BitConverter.ToInt32(bytes, i)) is Type token)
                operands.Add(token);
            else if (op.OperandType == OperandType.InlineString)
                operands.Add(method.Module.ResolveString(BitConverter.ToInt32(bytes, i)));
            i += op.OperandType switch {
                OperandType.InlineNone => 0,
                OperandType.ShortInlineI or OperandType.ShortInlineBrTarget or OperandType.ShortInlineVar => 1,
                OperandType.InlineVar => 2,
                OperandType.InlineI8 or OperandType.InlineR => 8,
                OperandType.InlineSwitch => 4 + 4 * BitConverter.ToInt32(bytes, i),
                _ => 4
            };
        }
        return operands;
    }
    // Regression against the three upstream GET mutations, inspecting the built methods rather than a copied implementation.
    foreach (string name in new[] { "BuildGameState", "BuildShopState", "BuildFakeMerchantState", "BuildTreasureState" })
        foreach (var called in CalledMethods(name))
            Check(called.Name is not ("OpenInventory" or "ForceClick" or "EmitSignal" or "OnMerchantOpened"), name + " must not mutate UI");
    // Compiled control flow: the ordered context helper and reward readiness helper are wired into actual observation.
    Check(CalledMethods("CaptureObservationCore").Any(m => m.Name == "ContextHalt" && m.DeclaringType == bridge) && bridge.GetMethod("IsAllowedContext", flags) == null,
        "observation reads context through the ordered helper, not the eager IsAllowedContext");
    var contextCalls = CalledMethods("ContextHalt");
    Check(contextCalls.Any(m => m.Name == "ContextHalt" && m.DeclaringType == protocol) && contextCalls.Any(m => m.Name == "get_IsInProgress")
        && !contextCalls.Any(m => m.Name is "get_NetService" or "get_Type" or "IsMultiplayer"),
        "compiled context read evaluates run presence eagerly and the network service only through the ordered helper's deferred read");
    Check(CalledMethods("AddNonCombatActions").Any(m => m.Name == "RewardCardsInputDisabled" && m.DeclaringType == protocol),
        "card-reward observation branch is wired to the production readiness helper");
    // Actual compiled map predicate and both potion visibility sites must route into the same whole-decision gate.
    var mapPredicate = bridge.GetNestedTypes(flags).SelectMany(t => t.GetMethods(flags))
        .Single(m => m.Name.StartsWith("<CaptureObservationCore>") && CalledBy(m).Any(c => c.Name == "IsReadableCanvas"));
    var mapPredicateCalls = CalledBy(mapPredicate);
    Check(mapPredicateCalls.Any(m => m.Name == "get_State") && mapPredicateCalls.Any(m => m.Name == "get_Point")
        && mapPredicateCalls.Any(m => m.Name == "DecisionInputReady" && m.DeclaringType == bridge),
        "real travelable-point enumeration cannot silently filter an unreadable point");
    var potionCalls = CalledMethods("AddPotionActions");
    Check(potionCalls.Count(m => m.Name == "DecisionInputReady" && m.DeclaringType == bridge) == 2
        && potionCalls.Any(m => m.Name == "IsNodeVisible") && potionCalls.Any(m => m.Name == "IsValidTarget")
        && potionCalls.Any(m => m.Name == "get_CanUseOrRemovePotions") && potionCalls.Any(m => m.Name == "get_IsQueued")
        && potionCalls.Any(m => m.Name == "get_PassesCustomUsabilityCheck")
        && Operands(bridge.GetMethod("AddPotionActions", flags)!).OfType<string>().Contains("_isUsable"),
        "real potion holder and valid-target filters mark whole-decision waiting without removing native eligibility guards");
    Check(bridge.GetMethod("AddPotionActions", flags)!.GetParameters()[0].ParameterType == typeof(Dictionary<string, object?>)
        && CalledMethods("CaptureObservationCore").Any(m => m.Name == "AddPotionActions"),
        "potion readiness receives the observation dictionary from the actual observation path");
    Check(CalledMethods("DispatchLabel").Any(m => m.Name == "CaptureObservation")
        && CalledMethods("CaptureObservationCore").Any(m => m.Name == "FinishObservation"),
        "POST re-captures through the same readiness and whole-set finalizer");
    // Pinned native map fade does not disable potion eligibility. Metadata only, never invoke native UI.
    var nativeMap = game.GetType("MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen", true)!;
    var nativeHolder = game.GetType("MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder", true)!;
    var nativePotion = game.GetType("MegaCrit.Sts2.Core.Models.PotionModel", true)!;
    Check(CalledBy(nativeMap.GetMethod("Open", flags)!).Any(m => m.Name == "set_Modulate")
        && CalledBy(nativeMap.GetMethod("Open", flags)!).Any(m => m.Name == "RecalculateTravelability")
        && !CalledBy(nativeMap.GetMethod("Open", flags)!).Any(m => m.Name == "set_CanUseOrRemovePotions"),
        "pinned map Open fades points and recalculates native travelability independently of potion permission");
    Check(!CalledBy(nativeHolder.GetMethod("OpenPotionPopup", flags)!).Any(m => m.DeclaringType == nativeMap)
        && !CalledBy(nativePotion.GetMethod("IsValidTarget", flags)!).Any(m => m.Name is "get_Modulate" or "get_Visible" or "IsVisibleInTree"),
        "native potion popup/target validity supplies no map-fade or target-alpha exclusion");
    // Owned old-room teardown receipts come from the existing registration/dispatch callbacks, not from test helpers.
    var registrationCallbacks = CalledInClosures("RegisterCombatExit");
    Check(registrationCallbacks.Any(m => m.Name == "TravelExecuting" && m.DeclaringType == exitType) && registrationCallbacks.Any(m => m.Name == "DebugOnlyGetState")
        && registrationCallbacks.Any(m => m.Name == "get_CurrentRoom") && CalledMethods("RegisterCombatExit").Any(m => m.Name == "add_BeforeActionExecuted"),
        "RegisterCombatExit's existing BeforeActionExecuted callback arms the owned travel against the current run/room and retained turn loop");
    var dispatchCallbacks = CalledInClosures("DispatchMap");
    Check(dispatchCallbacks.Any(m => m.Name == "ExpectRoomExit" && m.DeclaringType == exitType) && dispatchCallbacks.Any(m => m.Name == "RoomExited" && m.DeclaringType == exitType)
        && dispatchCallbacks.Any(m => m.Name == "get_CurrentlyRunningAction") && dispatchCallbacks.Any(m => m.Name == "remove_RoomExited")
        && CalledMethods("DispatchMap").Any(m => m.Name == "add_RoomExited") && CalledMethods("DispatchMap").Any(m => m.Name == "ConsumeMap" && m.DeclaringType == exitType),
        "DispatchMap binds the exact queued travel and a continuation-scoped native RoomExited receipt with release cleanup");
    var actionType = bridge.GetNestedType("LegalAction", BindingFlags.NonPublic)!;
    foreach (var property in new[] { "Dispatch", "Identity" })
        Check(actionType.GetProperty(property)!.GetCustomAttribute<JsonIgnoreAttribute>() != null, "private action data never serialized");
    // Generic native event path (compiled wiring, not live gameplay): admission, snapshot and dispatch reference no concrete
    // EventModel subclass, so previously unlisted producers with any callback shape are admitted by the option protocol alone.
    var eventModelType = game.GetType("MegaCrit.Sts2.Core.Models.EventModel", true)!;
    foreach (string producer in new[] { "TinkerTime", "ByrdonisNest", "AbyssalBaths", "ColossalFlower" })
    {
        var model = game.GetType("MegaCrit.Sts2.Core.Models.Events." + producer, true)!;
        Check(!model.IsAbstract && eventModelType.IsAssignableFrom(model), "pinned concrete event producer exists: " + producer);
    }
    List<object> EventPathOperands(string name) => Operands(bridge.GetMethod(name, flags) ?? throw new Exception("missing compiled production method " + name))
        .Concat(bridge.GetNestedTypes(flags).SelectMany(t => t.GetMethods(flags)).Where(m => m.Name.StartsWith("<" + name + ">")).SelectMany(Operands)).ToList();
    bool ConcreteEventModel(Type? type) => type != null && !type.IsAbstract && type != eventModelType && eventModelType.IsAssignableFrom(type);
    foreach (string name in new[] { "EventInputsReady", "RequireEventOption", "AddEventActions", "DispatchEventOption", "BuildEventState", "EventSetupPrefix", "BeginActOpening" })
    {
        var operands = EventPathOperands(name);
        Check(!operands.OfType<Type>().Any(ConcreteEventModel) && !operands.OfType<MethodBase>().Any(m => ConcreteEventModel(m.DeclaringType)),
            name + " references no concrete event model: no event-name or callback-owner allowlist");
    }
    // Genuine act-opening creation (initial Neow): the existing SetupLayout capture may bind the room the native run start created
    // itself. Provenance comes from the pinned native lifecycle, not from the visible screen: RunManager.InitializeShared stores the
    // reload count that every saved-run setup increments first, and EnterAct enters the starting Ancient point only for act 0 with Neow.
    var runManagerType = game.GetType("MegaCrit.Sts2.Core.Runs.RunManager", true)!;
    Check(runManagerType.GetField("_numReloads", flags)?.FieldType == typeof(int) && runManagerType.GetMethod("InitializeShared", flags)!.GetParameters().Last().ParameterType == typeof(int),
        "native reload count is an int field assigned from InitializeShared's last argument");
    List<MethodBase> GameStateMachineCalls(Type type, string method) => type.GetNestedTypes(flags).Where(t => t.Name.StartsWith("<" + method + ">"))
        .SelectMany(t => t.GetMethods(flags | BindingFlags.DeclaredOnly)).Where(m => m.Name == "MoveNext").SelectMany(CalledBy).ToList();
    var savedSetup = GameStateMachineCalls(runManagerType, "SetUpSavedSingleplayer");
    Check(savedSetup.Any(m => m.Name == "IncrementNumReloads") && savedSetup.Any(m => m.Name == "get_NumReloads") && savedSetup.Any(m => m.Name == "InitializeShared"),
        "saved singleplayer setup increments and passes the persisted reload count before initializing the run");
    Check(GameStateMachineCalls(runManagerType, "SetUpSavedMultiplayer").Any(m => m.Name == "IncrementNumReloads"), "saved multiplayer setup also increments the reload count");
    var enterAct = GameStateMachineCalls(runManagerType, "EnterAct");
    Check(enterAct.Any(m => m.Name == "get_StartedWithNeow") && enterAct.Any(m => m.Name == "get_StartingMapPoint") && enterAct.Any(m => m.Name == "EnterMapCoord")
        && enterAct.Any(m => m.Name == "EnterRoomInternal"),
        "EnterAct enters the starting map point directly on the Neow branch and otherwise opens the act through a MapRoom");
    Check(GameStateMachineCalls(runManagerType, "LoadIntoLatestMapCoord").Any(m => m.Name == "EnterMapCoordInternal")
        && !GameStateMachineCalls(runManagerType, "LoadIntoLatestMapCoord").Any(m => m.Name == "EnterAct"),
        "saved runs re-enter their latest coordinate without the fresh EnterAct opening path");
    Check(game.GetType("MegaCrit.Sts2.Core.Runs.ExtraRunFields", true)!.GetProperty("StartedWithNeow", flags)!.PropertyType == typeof(bool)
        && game.GetType("MegaCrit.Sts2.Core.Rooms.AbstractRoom", true)!.GetProperty("IsPreFinished", flags)!.PropertyType == typeof(bool)
        && game.GetType("MegaCrit.Sts2.Core.Map.MapPointType", true)!.GetField("Ancient")!.GetRawConstantValue() is 8,
        "opening provenance reads pinned public run/room/map-point ABI");
    foreach (var (scenario, fresh) in new[] { ("fresh", true), ("reloaded", false), ("later_act", false), ("no_neow_map_first", false), ("not_start", false),
        ("not_ancient", false), ("revisit", false), ("unvisited", false), ("prefinished", false), ("finished", false), ("foreign_travel", false) })
    {
        bool accepted = (bool)Call(protocol, null, "FreshActOpening", scenario == "reloaded" ? 1 : 0, scenario == "later_act" ? 1 : 0, scenario != "no_neow_map_first",
            scenario != "not_start", scenario != "not_ancient", scenario == "revisit" ? 2 : scenario == "unvisited" ? 0 : 1,
            scenario == "prefinished", scenario == "finished", scenario == "foreign_travel")!;
        Check(accepted == fresh, "fresh act-opening provenance: " + scenario);
    }
    var openingType = assembly.GetType("STS2_MCP.ActOpening", true)!;
    var eventEntryType = assembly.GetType("STS2_MCP.EventEntry", true)!;
    var openingEntry = Activator.CreateInstance(eventEntryType, flags, null, new[] { Activator.CreateInstance(openingType, new object())!, new object(), new object(), new object() }, null)!;
    Check(Call(bridge, null, "EntryDestination", openingEntry) == null && Call(bridge, null, "EntryDestination", Activator.CreateInstance(eventEntryType, flags, null, new[] { new object(), new object(), new object(), new object() }, null)!) == null,
        "a stand-in opening or travel without an exact MapCoord destination never satisfies the destination check");
    var coordType = game.GetType("MegaCrit.Sts2.Core.Map.MapCoord", true)!;
    var coord = Activator.CreateInstance(coordType)!; // plain value struct, no game state or Godot object
    var coordEntry = Activator.CreateInstance(eventEntryType, flags, null, new[] { Activator.CreateInstance(openingType, coord)!, new object(), new object(), new object() }, null)!;
    Check(Equals(Call(bridge, null, "EntryDestination", coordEntry), coord), "opening entries bind the exact starting coordinate the native run start entered");
    var beginOpening = CalledMethods("BeginActOpening");
    Check(beginOpening.Any(m => m.Name == "FreshActOpening" && m.DeclaringType == protocol) && Operands(bridge.GetMethod("BeginActOpening", flags)!).OfType<string>().Contains("_numReloads")
        && beginOpening.Any(m => m.Name == "get_CurrentlyRunningAction") && beginOpening.Any(m => m.Name == "get_StartedWithNeow") && beginOpening.Any(m => m.Name == "get_StartingMapPoint")
        && beginOpening.Any(m => m.Name == "get_VisitedMapCoords") && beginOpening.Any(m => m.Name == "get_IsPreFinished") && beginOpening.Any(m => m.Name == "get_IsFinished")
        && beginOpening.Any(m => m.Name == "GetMe"),
        "opening bootstrap reads the native reload count, act/Neow branch, starting point, first visit, room/model state and executor idleness");
    Check(CalledMethods("EventSetupPrefix").Any(m => m.Name == "BeginActOpening" && m.DeclaringType == bridge) && CalledMethods("EventSetupPrefix").Any(m => m.Name == "EntryDestination" && m.DeclaringType == bridge)
        && CalledMethods("EventSetupPrefix").Any(m => m.Name == "get_CurrentOwner") && !CalledMethods("BeginActOpening").Any(m => m.Name is "Track" or "HoldUntil" or "ForceClick"),
        "SetupLayout capture consults the opening bootstrap only through the existing prefix and grants no session/dispatch authority");
    Check(!Operands(bridge.GetMethod("InstallSelectionOwnershipHooks", flags)!).OfType<string>().Any(s => s is "Launch" or "EnterAct" or "EnterMapCoord" or "EnterRoomInternal")
        && !assembly.GetTypes().Where(t => !t.IsGenericTypeDefinition).SelectMany(t => t.GetMethods(flags)).Where(m => !m.IsGenericMethodDefinition && m.GetMethodBody() != null)
            .SelectMany(CalledBy).Any(m => m.Name is "add_RunStarted" or "add_ActEntered" or "add_RoomEntered"),
        "no new Harmony targets or run-lifecycle observers for the opening");
    // Owner-approved finished-Neow Proceed exception: only the owned fresh ActOpening on the act-0/Neow/ActFloor-1 map exempts the
    // start-of-act refusal; the shared four-argument guard above is unchanged for every other map alternative.
    Check(protocol.GetMethod("InitialOpeningProceed", flags) != null, "missing compiled production method InitialOpeningProceed: finished-Neow Proceed still refused by the start-of-act map guard");
    foreach (bool ownedOpening in new[] { false, true }) foreach (int actIndex in new[] { 0, 1 }) foreach (bool neow in new[] { false, true }) foreach (int floor in new[] { 0, 1, 2 })
        Check((bool)Call(protocol, null, "InitialOpeningProceed", ownedOpening, actIndex, neow, floor)! == (ownedOpening && actIndex == 0 && neow && floor == 1),
            $"initial-opening proceed exemption truth table: owned={ownedOpening} act={actIndex} neow={neow} floor={floor}");
    var mapGuard = bridge.GetMethod("RequireOrdinaryMap", flags)!;
    Check(mapGuard.GetParameters().Length == 4 && mapGuard.GetParameters()[3].ParameterType == typeof(bool) && mapGuard.GetParameters()[3].HasDefaultValue
        && mapGuard.GetParameters()[3].DefaultValue is false, "the bridge map guard exempts the opening only through an explicit opt-in that defaults to the full refusal");
    var mapGuardCalls = CalledBy(mapGuard);
    Check(mapGuardCalls.Any(m => m.Name == "InitialOpeningProceed" && m.DeclaringType == protocol) && mapGuardCalls.Any(m => m.Name == "RequireOrdinaryMap" && m.DeclaringType == protocol)
        && mapGuardCalls.Any(m => m.Name == "RequireOrdinaryTutorial" && m.DeclaringType == protocol) && mapGuardCalls.Any(m => m.Name == "SeenFtue")
        && mapGuardCalls.Any(m => m.Name == "get_ActFloor") && mapGuardCalls.Any(m => m.Name == "get_StartedWithNeow") && mapGuardCalls.Any(m => m.Name == "get_IsTraveling")
        && Operands(mapGuard).OfType<string>().Contains("map_select_ftue") && Operands(mapGuard).OfType<string>().Contains("_isInputDisabled")
        && Operands(mapGuard).OfType<string>().Contains("_actAnimTween") && Operands(mapGuard).OfType<string>().Contains("_runState")
        && !Operands(mapGuard).OfType<string>().Contains("_hasPlayedAnimation"),
        "the bridge map guard keeps the entry-time tutorial read, input-disabled, traveling and receiver checks and claims no animation completion");
    bool CallsMapGuard(MethodBase method) => !method.IsGenericMethodDefinition && method.GetMethodBody() != null
        && CalledBy(method).Any(m => m.MetadataToken == mapGuard.MetadataToken && m.Module == mapGuard.Module);
    var mapGuardCallers = bridge.GetMethods(flags).Cast<MethodBase>().Concat(bridge.GetNestedTypes(flags).Where(t => !t.IsGenericTypeDefinition).SelectMany(t => t.GetMethods(flags)))
        .Where(CallsMapGuard).ToList();
    Check(mapGuardCallers.Any(m => m.Name == "RequireEventOption") && mapGuardCallers.Any(m => m.Name.StartsWith("<DispatchEventOption>"))
        && mapGuardCallers.Any(m => m.Name == "AddOrdinaryProceed" || m.Name.StartsWith("<AddOrdinaryProceed>")) && mapGuardCallers.Count(m => !m.Name.Contains("Event")) >= 3,
        "event Proceed admission/completion and the ordinary merchant/rest/treasure/reward proceeds all route through the same bridge map guard");
    foreach (var caller in mapGuardCallers)
        Check(Operands(caller).Contains(openingType) == (caller.Name == "RequireEventOption" || caller.Name.StartsWith("<DispatchEventOption>")),
            "only the owned event Proceed path consults the opening stand-in for map readiness: " + caller.Name);
    Check(EventPathOperands("DispatchEventOption").Contains(openingType) && CalledMethods("RequireEventOption").Any(m => m.MetadataToken == mapGuard.MetadataToken)
        && !EventPathOperands("DispatchEventOption").OfType<string>().Contains("_hasPlayedAnimation") && !EventPathOperands("RequireEventOption").OfType<string>().Contains("_hasPlayedAnimation"),
        "the event Proceed dispatch derives the opening flag from the bound entry's stand-in, not from map or animation state");
    Check(!Operands(bridge.GetMethod("InstallSelectionOwnershipHooks", flags)!).OfType<string>()
            .Any(s => s is "Open" or "Proceed" or "PlayStartOfActAnimation" or "StartOfActAnim" or "InitMapPrompt" or "MapFtueCheck" or "MarkFtueAsComplete")
        && !assembly.GetTypes().Where(t => !t.IsGenericTypeDefinition).SelectMany(t => t.GetMethods(flags)).Where(m => !m.IsGenericMethodDefinition && m.GetMethodBody() != null)
            .SelectMany(CalledBy).Any(m => m.Name is "MarkFtueAsComplete" or "PlayStartOfActAnimation" or "StartOfActAnim" or "InitMapPrompt" or "MapFtueCheck" or "ResetFtues"),
        "the opening exception adds no map/animation Harmony target and never acknowledges or resets a tutorial itself");
    // Pinned native facts the exception rests on (call edges only, no invocation): Proceed enables travel then Open(false); Open branches on
    // act/Neow/floor, detaches the animation and emits Opened after RecalculateTravelability; the tail's only gameplay step re-reads the FTUE flag.
    var eventRoomType = game.GetType("MegaCrit.Sts2.Core.Nodes.Rooms.NEventRoom", true)!;
    var proceedCalls = CalledBy(eventRoomType.GetMethod("Proceed", flags)!);
    Check(proceedCalls.Any(m => m.Name == "SetTravelEnabled") && proceedCalls.Any(m => m.Name == "Open") && proceedCalls.Any(m => m.Name == "get_CompletedTask"),
        "native finished-event Proceed enables travel, opens the map and returns CompletedTask (no map receipt of its own)");
    var mapScreenType = game.GetType("MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen", true)!;
    var openCalls = CalledBy(mapScreenType.GetMethod("Open", flags)!);
    Check(openCalls.Any(m => m.Name == "get_ActFloor") && openCalls.Any(m => m.Name == "get_StartedWithNeow") && openCalls.Any(m => m.Name == "PlayStartOfActAnimation")
        && openCalls.Any(m => m.Name == "RecalculateTravelability") && openCalls.Any(m => m.Name == "EmitSignalOpened"),
        "native Open takes the start-of-act branch from act/Neow/floor and emits Opened after recalculating travelability");
    Check(GameStateMachineCalls(mapScreenType, "StartOfActAnim").Any(m => m.Name == "AwaitFinished") && GameStateMachineCalls(mapScreenType, "StartOfActAnim").Any(m => m.Name == "InitMapPrompt")
        && CalledBy(mapScreenType.GetMethod("InitMapPrompt", flags)!).Any(m => m.Name == "SeenFtue")
        && GameStateMachineCalls(mapScreenType, "MapFtueCheck").Any(m => m.Name == "MarkFtueAsComplete")
        && !CalledBy(mapScreenType.GetMethod("PlayStartOfActAnimation", flags)!).Any(m => m.Name == "InitMapPrompt"),
        "native start-of-act animation reaches the map tutorial only through InitMapPrompt's SeenFtue re-read after the awaited tween");
    Check(CalledBy(mapScreenType.GetMethod("OnMapPointSelectedLocally", flags)!).Any(m => m.Name == "RequestEnqueue")
        && !CalledBy(mapScreenType.GetMethod("OnMapPointSelectedLocally", flags)!).Any(m => m.Name is "TryCancelStartOfActAnim" or "DisableInputVeryBriefly"),
        "native owned map selection enqueues the vote without consulting the human-only animation interrupt path");
    Check(CalledMethods("EventInputsReady").Any(m => m.Name == "RequireEventPolicy" && m.DeclaringType == protocol && m.GetParameters().Length == 2)
        && CalledMethods("RequireEventOption").Any(m => m.Name == "RequireEventPolicy" && m.DeclaringType == protocol && m.GetParameters().Length == 2)
        && !CalledMethods("EventInputsReady").Any(m => m.Name == "get_IsFinished"),
        "readiness and per-option checks use the two-argument shared/embedded policy and never infer readiness from IsFinished");
    Check(CalledMethods("RequireEventOption").Any(m => m.Name == "GetInvocationList") && Operands(bridge.GetMethod("RequireEventOption", flags)!).OfType<string>().Contains("WillKillPlayer")
        && CalledMethods("RequireEventOption").Any(m => m.Name == "get_CurrentOptions") && CalledMethods("RequireEventOption").Any(m => m.Name == "RequireGeneration"),
        "single-callback, lethal-confirmation, exact CurrentOptions[index] and generation guards are retained on the generic path");
    // Observation and dispatch bind options through the same owned layout surface and native index; no scene-tree traversal numbering.
    foreach (string name in new[] { "BuildEventState", "AddEventActions", "RequireEventOption" })
        Check(CalledMethods(name).Any(m => m.Name == "EventOptionIndex" && m.DeclaringType == bridge) && CalledMethods(name).Any(m => m.Name == "get_OptionButtons"),
            name + " binds options through NEventLayout.OptionButtons and the shared native index helper");
    Check(!CalledMethods("BuildEventState").Any(m => m.Name == "FindAll"), "event snapshot no longer numbers options by scene-tree traversal order");
    Check(Operands(bridge.GetMethod("EventOptionIndex", flags)!).OfType<string>().Contains("<Index>k__BackingField")
        && game.GetType("MegaCrit.Sts2.Core.Nodes.Events.NEventLayout", true)!.GetProperty("OptionButtons", flags)!.PropertyType == typeof(IEnumerable<>).MakeGenericType(game.GetType("MegaCrit.Sts2.Core.Nodes.Events.NEventOptionButton", true)!),
        "shared index helper reads the exact native NEventOptionButton index bound at NEventLayout.AddOptions");
    // A pending event root under a foreground surface the bridge cannot own (custom minigame overlay) falls through to the
    // existing unsupported-overlay diagnostics instead of waiting forever; other families keep their existing waiting gate.
    var sphereType = game.GetType("MegaCrit.Sts2.Core.Nodes.Events.Custom.CrystalSphere.NCrystalSphereScreen", true)!;
    var eventOperationField = bridge.GetField("_eventOperation", flags)!;
    object sphereOwner = new();
    var sphereEntry = Activator.CreateInstance(assembly.GetType("STS2_MCP.EventEntry", true)!, flags, null, new[] { new object(), sphereOwner, new object(), new object() }, null)!;
    var sphereOperation = Activator.CreateInstance(assembly.GetType("STS2_MCP.EventOperation", true)!, flags, null, new[] { sphereOwner, sphereEntry, Activator.CreateInstance(ownershipType, true)! }, null)!;
    var sphereSession = OwnedSession(sphereOwner, Task.CompletedTask, Task.CompletedTask, () => new TaskCompletionSource().Task);
    var sphereRegistry = Activator.CreateInstance(ownershipType, true)!;
    Dictionary<string, object?>? Stop(object? overlay, Type? type) => (Dictionary<string, object?>?)GateValue(Gate(overlay, type, false, null, sphereSession, sphereRegistry), "Stop");
    try
    {
        Check(Stop(new object(), sphereType)?["state_type"] is "waiting", "non-event pending operation keeps its existing waiting gate under an unrelated overlay");
        eventOperationField.SetValue(null, sphereOperation);
        Check(Stop(new object(), sphereType) == null, "pending event root under an unowned custom overlay exposes the existing unsupported-overlay halt instead of waiting forever");
        Check(Stop(null, null)?["state_type"] is "waiting", "pending event root with no foreground surface still waits for its retained task and native input");
        Check(Stop(new object(), exitCardType)?["halt_reason"] is "unowned_selection_continuation", "unowned selector during a pending event root still halts as unowned continuation");
        var otherSession = OwnedSession(new object(), Task.CompletedTask, Task.CompletedTask, () => new TaskCompletionSource().Task);
        Check(((Dictionary<string, object?>?)GateValue(Gate(new object(), sphereType, false, null, otherSession, sphereRegistry), "Stop"))?["state_type"] is "waiting",
            "a different pending owner is unaffected by the retained event operation");
    }
    finally { eventOperationField.SetValue(null, null); }
    Console.WriteLine("PASS: installed API private-field compatibility and built GET mutation regressions (metadata only).");
}
Check(protocol.GetMethod("RequireEventPolicy", flags)!.GetParameters().Length == 2, "event policy takes no per-model audited/allowlist argument");
foreach (bool shared in new[] { false, true }) foreach (bool embedded in new[] { false, true })
{
    bool refused = false;
    try { Call(protocol, null, "RequireEventPolicy", shared, embedded); }
    catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { refused = true; }
    Check(refused == (shared || embedded), "shared-in-singleplayer and embedded-combat alternatives halt before dispatch; ordinary unlisted models are admitted by the native option protocol");
}
foreach (bool terminal in new[] { false, true }) foreach (bool act in new[] { false, true })
foreach (bool skip in new[] { false, true }) foreach (bool seen in new[] { false, true }) foreach (bool debug in new[] { false, true })
{
    bool refused = false;
    try { Call(protocol, null, "RequireRewardProceed", terminal, act, skip, seen, debug); }
    catch (TargetInvocationException e) when (e.InnerException is NotSupportedException) { refused = true; }
    Check(refused == (terminal && (debug || act || skip && !seen)), "unsupported debug/act/FTUE proceed branches refuse full observation before any native dispatch");
}
Console.WriteLine($"PASS: {checks} actual-DLL checks; no game initialization or HTTP.");

sealed class ManagedSelectorFixture
{
    public static Func<object?> CurrentOwner = null!;
    public static Func<object?> CurrentRewardOwner = null!;
    public object? SeenAtEntry;
    [System.Runtime.CompilerServices.MethodImpl(System.Runtime.CompilerServices.MethodImplOptions.NoInlining)]
    public async Task<object?> CaptureReward(object owner, bool allowProceed, Task gate)
    { SeenAtEntry = CurrentRewardOwner(); await gate; return CurrentRewardOwner(); }
    [System.Runtime.CompilerServices.MethodImpl(System.Runtime.CompilerServices.MethodImplOptions.NoInlining)]
    public async Task<object?> Capture(object owner, Task gate) { await gate; return CurrentOwner(); }
    [System.Runtime.CompilerServices.MethodImpl(System.Runtime.CompilerServices.MethodImplOptions.NoInlining)]
    public Task<int> Select(TaskCompletionSource<int> gate) => gate.Task;
}
CS
dotnet run --project "$TMP/Check.csproj" -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false -- "$DLL" "${@:2}"
