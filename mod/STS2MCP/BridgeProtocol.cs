using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;

namespace STS2_MCP;

internal static class BridgeProtocol
{
    internal const string NativeAssemblySha256 = "9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4";

    internal static int CheckRequest(string method, string path, string? origin, string? fetchMetadata, string? contentType)
    {
        if (path != "/api/v1/singleplayer") return 404;
        if (method is not ("GET" or "POST")) return 405;
        // Native CLI only: no browser origin parsing or permissive CORS.
        if (origin != null || fetchMetadata != null) return 403;
        if (method == "POST" && !string.Equals(contentType?.Split(';')[0].Trim(),
                "application/json", StringComparison.OrdinalIgnoreCase)) return 415;
        return 0;
    }

    internal static string RequiredText(Func<string?> getter)
    {
        try
        {
            var text = getter();
            if (string.IsNullOrWhiteSpace(text)) throw new InvalidOperationException("Missing required text");
            return text;
        }
        catch (Exception e) { throw new NotSupportedException("required_rules_text_unavailable", e); }
    }

    internal static void ValidateRulesText(JsonElement value)
    {
        if (value.ValueKind == JsonValueKind.Array)
            foreach (var child in value.EnumerateArray()) ValidateRulesText(child);
        if (value.ValueKind != JsonValueKind.Object) return;
        foreach (var field in value.EnumerateObject())
        {
            // A proceed-only event button has a title but no gameplay rules. Other null fields
            // (star_cost, relic counter, unplayable_reason, etc.) remain genuinely optional.
            bool proceed = value.TryGetProperty("is_proceed", out var p) && p.ValueKind == JsonValueKind.True;
            if (field.Name is "description" or "card_description" or "relic_description" or "potion_description"
                && !proceed)
                RequiredText(() => field.Value.ValueKind == JsonValueKind.String ? field.Value.GetString() : null);
            if (field.Name == "body" && value.TryGetProperty("event_id", out _))
                RequiredText(() => field.Value.ValueKind == JsonValueKind.String ? field.Value.GetString() : null);
            ValidateRulesText(field.Value);
        }
    }

    internal static bool IsWaiting(string phase, bool busy, bool combatRoom, bool combat, bool combatReady)
    {
        if (phase == "map") return busy;
        bool selecting = phase is "card_select" or "card_reward" or "bundle_select" or "relic_select" or "hand_select" or "rewards";
        return !selecting && (busy || (combatRoom && !combat) || (combat && !combatReady));
    }

    // Only source-proven synchronous native callbacks; never complete from a later observation.
    internal static Task CaptureSynchronousSignal(object receiver, Action<Action<object>> subscribe,
        Action<Action<object>> unsubscribe, Action click, Func<bool> before, Func<bool> after)
    {
        if (!before()) throw new NotSupportedException("synchronous_input_unavailable");
        int signals = 0;
        bool dispatching = false, listening = true, invalid = false;
        void Signal(object source)
        {
            if (!listening) return;
            if (!dispatching || !ReferenceEquals(source, receiver)) invalid = true;
            else signals++;
        }
        try
        {
            subscribe(Signal);
            dispatching = true;
            click();
            dispatching = false;
            if (invalid || signals != 1 || !after()) throw new NotSupportedException("synchronous_receipt_unverified");
            return Task.CompletedTask;
        }
        finally { listening = dispatching = false; unsubscribe(Signal); }
    }

    internal static bool OrdinaryInput(bool visible, bool enabled, int mouseFilter, bool blocked, bool targeting, bool dead)
        => visible && enabled && mouseFilter is 0 or 1 && !blocked && !targeting && !dead;

    internal static void RequireOrdinaryTutorial(bool seen, string tutorial)
    {
        if (!seen) throw new NotSupportedException("ordinary_tutorial_unverified:" + tutorial);
    }

    internal static void RequireOrdinaryMap(bool inputDisabled, bool traveling, bool startsAct, bool actAnimationActive)
    {
        if (inputDisabled || traveling || startsAct || actAnimationActive)
            throw new NotSupportedException("ordinary_map_readiness_unverified");
    }

    // Owner-approved exception, initial Neow map only. NEventRoom.Proceed calls NMapScreen.Open(false); on the fresh act-0/Neow map
    // (ActFloor 1) that takes the start-of-act branch: a detached StartOfActAnim task nobody awaits natively, which may never finish
    // after a human Tween.Kill. Its only gameplay descendant, InitMapPrompt -> MapFtueCheck, re-reads SeenFtue("map_select_ftue"),
    // so with that flag seen at admission the slide/banner are cosmetic. This exempts startsAct/actAnimationActive only; it claims no
    // animation completion, and merchant/rest/reward proceeds, later acts, restored and foreign rooms keep the full refusal.
    internal static bool InitialOpeningProceed(bool ownedActOpening, int actIndex, bool startedWithNeow, int actFloor)
        => ownedActOpening && actIndex == 0 && startedWithNeow && actFloor == 1;

    // Native RunManager.EnterAct enters the starting Ancient point itself only for act 0 with StartedWithNeow (no map travel);
    // every saved-run setup runs SaveManager.IncrementNumReloads before InitializeShared, so a zero reload count proves a new run.
    // A running GameAction would mean foreign map travel produced this room. Later acts open through ordinary owned travel.
    internal static bool FreshActOpening(int numReloads, int actIndex, bool startedWithNeow, bool atStartingPoint, bool ancientPoint,
        int visitedCoords, bool preFinished, bool finished, bool actionRunning)
        => numReloads == 0 && actIndex == 0 && startedWithNeow && atStartingPoint && ancientPoint && visitedCoords == 1
            && !preFinished && !finished && !actionRunning;

    internal static bool DialogueAdvanced(int before, int after, bool last, bool visible, bool enabled, bool optionsReady)
        => after == before + 1 && (last ? !visible && !enabled && optionsReady : visible && enabled);

    // The ordinary native option protocol is generic: no event-name or callback-name admission.
    // Certifies the current decision only; an unsupported later surface halts through existing diagnostics.
    internal static void RequireEventPolicy(bool shared, bool embeddedCombat)
    {
        if (shared) throw new NotSupportedException("shared_event_unverified");
        if (embeddedCombat) throw new NotSupportedException("event_embedded_combat_unverified");
    }

    internal static void RequireRewardProceed(bool terminal, bool actTransition, bool skip, bool ftueSeen, bool debugOverride)
    {
        if (terminal && debugOverride) throw new NotSupportedException("reward_debug_override_unverified");
        if (terminal && actTransition) throw new NotSupportedException("reward_act_transition_unverified");
        if (terminal && skip && !ftueSeen) throw new NotSupportedException("reward_ftue_completion_unverified");
    }

    internal static void RequireClickCompletion(string label, bool ownedChild)
    {
        if (!ownedChild) throw new NotSupportedException("completion_adapter_unavailable:" + label);
    }

    internal static Task CaptureAppendedTask(List<Task> tasks, Action dispatch)
    {
        var previous = tasks.ToArray();
        foreach (var task in previous)
            if (!task.IsCompletedSuccessfully) throw new NotSupportedException("event_prior_task_incomplete");
        dispatch();
        if (tasks.Count != previous.Length + 1) throw new NotSupportedException("event_task_capture_mismatch");
        for (int i = 0; i < previous.Length; i++)
            if (!ReferenceEquals(previous[i], tasks[i])) throw new NotSupportedException("event_task_capture_mismatch");
        return tasks[previous.Length];
    }

    internal static bool AllowedProfile(bool modded, bool initialized, int profile, bool multiplayer)
        => modded && initialized && profile == 2 && !multiplayer;

    // Ordered context read. v0.111 RunManager.NetService is a bare backing field, null before any run starts,
    // so a no-run menu must not evaluate it; it still halts later as no_active_run/terminal with no actions.
    // A run in progress without a service fails closed rather than defaulting to singleplayer.
    internal static string? ContextHalt(bool modded, bool initialized, int profile, bool runInProgress, Func<bool?> multiplayer)
    {
        if (!AllowedProfile(modded, initialized, profile, false)) return "modded_profile_2_singleplayer_required";
        if (!runInProgress) return null;
        return multiplayer() switch
        {
            null => "run_network_service_unavailable",
            true => "modded_profile_2_singleplayer_required",
            false => null
        };
    }

    // v0.111 NCardHolder._isClickable defaults true; its only false setter is
    // NCardRewardSelectionScreen.DisableCardsForShortTimeAfterOpening, which leaves the alternative buttons enabled.
    // While any offered card is in that window the whole reward decision is not ready. Missing metadata fails closed.
    internal static bool RewardCardsInputDisabled(IEnumerable<bool?> offeredClickable)
    {
        bool disabled = false;
        foreach (var clickable in offeredClickable)
        {
            if (clickable == null) throw new NotSupportedException("card_holder_clickability_unavailable");
            disabled |= !clickable.Value;
        }
        return disabled;
    }

    internal static (string Version, string Label) ParseAction(string body)
    {
        using var doc = JsonDocument.Parse(body);
        if (doc.RootElement.ValueKind != JsonValueKind.Object) throw new JsonException("Expected object");
        var fields = new Dictionary<string, string>();
        foreach (var field in doc.RootElement.EnumerateObject())
        {
            if (field.Name is not ("state_version" or "label") || field.Value.ValueKind != JsonValueKind.String
                || string.IsNullOrWhiteSpace(field.Value.GetString()) || !fields.TryAdd(field.Name, field.Value.GetString()!))
                throw new JsonException("Expected unique state_version and label strings only");
        }
        if (fields.Count != 2) throw new JsonException("Missing state_version or label");
        return (fields["state_version"], fields["label"]);
    }
}

// Accessed only on the Godot main thread. Versions are process-scoped, monotonic and single-use.
// Scoped NodeAdded receipt for one explicitly registered movement. No scene adoption on GET.
internal sealed class OrdinaryRoomEntry(object move, object owner, object run, object player)
{
    private object? _room, _scene;
    private bool _seen, _bound, _finished, _invalid;
    internal void Invalidate() => _invalid = true;
    internal void Bind(object actualMove, object? actualOwner, object actualRun, object? actualPlayer,
        object room, object scene, bool beforeReady, bool seen)
    {
        if (_invalid || _bound || _finished || !beforeReady || !ReferenceEquals(move, actualMove)
            || !ReferenceEquals(owner, actualOwner) || !ReferenceEquals(run, actualRun) || !ReferenceEquals(player, actualPlayer))
        { _invalid = true; return; }
        _room = room; _scene = scene; _seen = seen; _bound = true;
    }
    internal void Finish(object actualMove)
    {
        if (_finished || !_bound || !ReferenceEquals(move, actualMove)) _invalid = true;
        _finished = true;
    }
    internal void Require(object actualRun, object? room, object scene, object actualPlayer)
    {
        if (_invalid || !_bound || !_finished || !ReferenceEquals(run, actualRun) || !ReferenceEquals(player, actualPlayer)
            || !ReferenceEquals(_room, room) || !ReferenceEquals(_scene, scene))
            throw new NotSupportedException("rest_entry_readiness_unverified");
        BridgeProtocol.RequireOrdinaryTutorial(_seen, "rest_site_ftue");
    }
}

internal sealed class BridgeSession : IDisposable
{
    private readonly string _epoch = Guid.NewGuid().ToString("N");
    private long _revision;
    private string? _fingerprint;
    private bool _pending;
    private string? _consumedVersion;
    private object? _owner;
    private Task? _completion;
    private Task? _visual;
    private Func<Task?>? _execution;
    private Func<bool>? _cancelled;
    private Action? _release;
    private Func<bool>? _ready;
    internal void HoldUntil(Func<bool> ready)
    {
        if (_owner == null) throw new InvalidOperationException("No owned operation");
        var previous = _ready;
        _ready = previous == null ? ready : () => previous() & ready();
    }
    internal string? Failure { get; private set; }
    internal object? OperationOwner => _owner;
    internal bool HasCompletion => _completion != null;
    internal bool PrimarySucceeded => _completion?.IsCompletedSuccessfully == true && _visual?.IsCompletedSuccessfully == true
        && _execution?.Invoke()?.IsCompletedSuccessfully == true;
    internal string Version => $"{_epoch}:{_revision}";
    internal bool Pending => _pending;

    internal string Observe(string fingerprint)
    {
        if (_fingerprint != fingerprint)
        {
            _fingerprint = fingerprint;
            _revision++;
            // Freshness is never operation completion.
        }
        return Version;
    }

    internal void Track(object owner, Task completion, Task visual, Func<Task?> execution, Func<bool> cancelled)
    {
        if (!_pending || _owner != null || Failure != null)
            throw new InvalidOperationException("Cannot replace an owned mutation");
        _owner = owner;
        _completion = completion;
        _visual = visual;
        _execution = execution;
        _cancelled = cancelled;
    }

    internal void TrackCancellable<T>(T owner, Task completion, Task visual, Func<Task?> execution,
        Func<bool> isCancelled, Action<Action<T>> subscribe, Action<Action<T>> unsubscribe) where T : class
    {
        bool cancelled = isCancelled();
        void OnCancelled(T source) { if (ReferenceEquals(source, owner)) cancelled = true; }
        subscribe(OnCancelled);
        try
        {
            Track(owner, completion, visual, execution, () => cancelled || isCancelled());
            OnRelease(() => unsubscribe(OnCancelled));
        }
        catch { unsubscribe(OnCancelled); throw; }
    }

    internal void OnRelease(Action release)
    {
        if (_owner == null) throw new InvalidOperationException("No owned operation");
        _release += release;
    }

    private void Release()
    {
        var release = _release;
        _release = null;
        Exception? failure = null;
        foreach (Action cleanup in release?.GetInvocationList() ?? Array.Empty<Delegate>())
            try { cleanup(); } catch (Exception error) { failure ??= error; }
        if (failure != null) throw new InvalidOperationException("Mutation cleanup failed", failure);
    }

    internal void Fail(string reason)
    {
        Failure = reason;
        _pending = true;
        try { Release(); } catch { Failure = "mutation_cleanup_failed"; }
    }

    public void Dispose() => Fail("mutation_abandoned");

    // Main-thread poll of explicitly retained ownership. Task completion never invokes game APIs off-thread.
    internal void Refresh()
    {
        if (!_pending || _completion == null || Failure != null) return;
        try
        {
            var execution = _execution!();
            bool ready = _ready?.Invoke() ?? true;
            if (_cancelled!() || _completion.IsCanceled || _visual!.IsCanceled || execution?.IsCanceled == true)
                Fail("mutation_cancelled");
            else if (_completion.IsFaulted || _visual!.IsFaulted || execution?.IsFaulted == true)
            {
                // Observe faults without mistaking the game's successful CompletionTask for execution success.
                _ = _completion.Exception; _ = _visual.Exception; _ = execution?.Exception;
                Fail("mutation_faulted");
            }
            else if (_completion.IsCompletedSuccessfully && _visual!.IsCompletedSuccessfully
                && execution?.IsCompletedSuccessfully == true && ready)
            {
                Release();
                _pending = false;
                _owner = null; _completion = null; _visual = null; _execution = null; _cancelled = null; _ready = null;
                _revision++; // Fresh decision only after verified completion, even if visible state is unchanged.
            }
        }
        catch (NotSupportedException e) { Fail(e.Message); }
        catch { Fail("mutation_completion_unavailable"); }
    }

    internal int AcceptChild(string version, string label, IReadOnlyCollection<string> legalLabels, object owner)
    {
        if (Failure != null || !_pending || !ReferenceEquals(_owner, owner)
            || version != Version || version == _consumedVersion) return 409;
        if (!System.Linq.Enumerable.Contains(legalLabels, label)) return 422;
        _consumedVersion = version;
        return 0; // Continuation of the retained operation, never replacement/release of it.
    }

    internal int Accept(string version, string label, IReadOnlyCollection<string> legalLabels)
    {
        if (version != Version || version == _consumedVersion) return 409;
        if (_pending || Failure != null) return 409;
        if (!System.Linq.Enumerable.Contains(legalLabels, label)) return 422;
        // Consume before dispatch. Exceptions/timeouts never make the same decision retryable.
        _pending = true;
        _consumedVersion = version;
        return 0;
    }
}

internal sealed class MainThreadRequests
{
    private readonly ConcurrentQueue<Action> _queue = new();

    internal Task<T> Enqueue<T>(Func<T> readOrDispatch, CancellationToken cancellation)
    {
        var completion = new TaskCompletionSource<T>(TaskCreationOptions.RunContinuationsAsynchronously);
        int started = 0;
        var registration = cancellation.Register(() =>
        {
            if (Interlocked.CompareExchange(ref started, 2, 0) == 0)
                completion.TrySetCanceled(cancellation);
        });
        _queue.Enqueue(() =>
        {
            if (Interlocked.CompareExchange(ref started, 1, 0) != 0) { registration.Dispose(); return; }
            registration.Dispose();
            try { completion.TrySetResult(readOrDispatch()); }
            catch (Exception e) { completion.TrySetException(e); }
        });
        return completion.Task;
    }

    internal void Drain(int limit)
    {
        // Test the limit BEFORE dequeue: the upstream order silently dropped request eleven.
        for (int processed = 0; processed < limit && _queue.TryDequeue(out var work); processed++) work();
    }
}
