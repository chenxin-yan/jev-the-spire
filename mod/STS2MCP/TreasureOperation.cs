using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace STS2_MCP;

// One explicitly opened chest, not a combat lifetime or a general task registry.
internal sealed class TreasureOperation(object owner, object run, object room, object scene, object player, object collection,
    object relics, Task began, Task finished, SelectionOwnership selectors)
{
    internal readonly object Owner = owner, Run = run, Room = room, Scene = scene, Player = player, Collection = collection, Relics = relics;
    internal readonly Task Began = began, Finished = finished;
    internal Task? Root, Skip, Awards, Obtain, Proceed;
    internal object? Pick, ObtainedRelic;
    internal object[]? Holders;
    internal bool MapOpened, OnlyProceed;
    // Native singleplayer OnPicked(null) skips awards, leaving OpenChest/Began/Finished permanently pending.
    // Room exit clears voting state, not these tasks; only the exact pick's AfterFinished receipt authorizes this endpoint.
    internal bool LocalSkip;
    internal int? Index;
    internal bool Executing, AwardsEntered, ObtainEntered, Closed;
    internal volatile bool ExpectedSkipCancellation;
    private volatile bool _awardsRegistered, _unexpectedSkipCancellation;
    private readonly object _skipCancellationGate = new();
    internal string? Failure;
    internal CancellationToken SkipToken;
    internal Func<Task?>? PickWork;
    private readonly Dictionary<object, Task?> _offers = new(ReferenceEqualityComparer.Instance);
    private readonly Dictionary<object, (object Set, TaskCompletionSource Lifetime)> _screens = new(ReferenceEqualityComparer.Instance);
    private readonly List<Func<Task?>> _children = new();
    private int _completed;
    internal void Fail(string reason) => Failure ??= reason;
    internal static bool ClaimInput(ulong now, ulong opened) => unchecked(now - opened) > 200;
    internal static void RequireFresh(bool opened, int count, bool began, bool finished)
    { if (opened || count <= 0 || began || finished) throw new NotSupportedException("treasure_empty_or_reopened_unverified"); }
    internal void Check()
    {
        CheckTasks();
        if (LocalSkip)
        {
            if (AwardsEntered || ObtainEntered || Awards != null || Obtain != null || Began.IsCompleted || Finished.IsCompleted || Root?.IsCompleted == true)
                throw new NotSupportedException("treasure_local_skip_contract_violated");
        }
        else if (PickWork?.Invoke()?.IsCompletedSuccessfully == true && !AwardsEntered
            || Awards?.IsCompletedSuccessfully == true && (!Began.IsCompletedSuccessfully || !Finished.IsCompletedSuccessfully || Index.HasValue && !ObtainEntered))
            throw new NotSupportedException("treasure_gameplay_receipt_missing");
    }
    private void CheckTasks()
    {
        if (Failure != null || Closed) throw new NotSupportedException(Failure ?? "treasure_owner_closed");
        foreach (var task in new[] { Root, Awards, Obtain, Proceed, PickWork?.Invoke(), Began, Finished }.Concat(_offers.Values).Concat(_children.Select(get => get())))
            if (task?.IsFaulted == true || task?.IsCanceled == true)
            { _ = task.Exception; throw new NotSupportedException("treasure_task_failed"); }
        bool cancellationRequested = SkipToken.IsCancellationRequested;
        // CancelAsync requests cancellation before delivering callbacks. Only this owned native
        // cleanup lane may wait for its receipt; neither the token nor picking-finished releases it.
        bool ownedCancellation = cancellationRequested && Pick != null && AwardsEntered && Began.IsCompletedSuccessfully && Root != null;
        if (_unexpectedSkipCancellation || cancellationRequested && !ownedCancellation || ExpectedSkipCancellation && !cancellationRequested)
            throw new NotSupportedException("treasure_skip_cancel_unverified");
        if (Skip?.IsFaulted == true || Skip?.IsCanceled == true && !ownedCancellation)
        { _ = Skip.Exception; throw new NotSupportedException("treasure_skip_task_failed"); }
    }
    // Exact null-index pick whose original CompletionTask/_executionTask finished before any awards; the caller has read the native flag.
    internal void BeginLocalSkip(object action)
    {
        CheckTasks();
        if (LocalSkip || Pick == null || !ReferenceEquals(action, Pick) || Index.HasValue || AwardsEntered || ObtainEntered || Awards != null || Obtain != null
            || Began.IsCompleted || Finished.IsCompleted || Root == null || Root.IsCompleted || Skip?.IsCompletedSuccessfully != true
            || SkipToken.IsCancellationRequested || PickWork?.Invoke()?.IsCompletedSuccessfully != true)
            throw new NotSupportedException("treasure_local_skip_receipt_unverified");
        LocalSkip = true;
    }
    // The session's execution barrier: the parked root can never complete in the local skip lane, so the exact pick work is primary there.
    // Root stays retained and fault/cancel/completion-checked by Check() through the Proceed and map receipts.
    internal Task? Primary => LocalSkip ? PickWork?.Invoke() : Root;
    internal CancellationTokenRegistration RegisterSkipCancellation(CancellationToken token)
    {
        Check();
        if (SkipToken.CanBeCanceled || !token.CanBeCanceled || token.IsCancellationRequested)
            throw new NotSupportedException("treasure_skip_entry_unverified");
        SkipToken = token;
        return token.Register(CancelObserved);
    }
    internal void CancelObserved()
    {
        // CancelAsync can invoke this off-thread: read only the published awards marker and
        // readonly Task receipt, publish flags, and never touch native APIs or main-thread Failure.
        lock (_skipCancellationGate)
        {
            if (Closed) return;
            if (_awardsRegistered && Began.IsCompletedSuccessfully) ExpectedSkipCancellation = true;
            else _unexpectedSkipCancellation = true;
        }
    }
    internal void BindRoot(Task task)
    { if (Root != null) Fail("treasure_open_duplicate"); else Root = task; }
    internal void BindSkip(Task task)
    { if (Skip != null) Fail("treasure_skip_duplicate"); else Skip = task; }
    internal void BindPick(object action, int? index, Func<Task?> work)
    {
        Check();
        if (Pick != null || AwardsEntered || Began.IsCompleted) throw new NotSupportedException("treasure_pick_duplicate_or_late");
        Pick = action; Index = index; PickWork = work;
    }
    internal void BeginAwards(object action, object collection)
    {
        Check();
        if (!ReferenceEquals(action, Pick) || !ReferenceEquals(collection, Collection) || !Executing || AwardsEntered || LocalSkip)
            throw new NotSupportedException("treasure_awards_unowned");
        AwardsEntered = true;
        _awardsRegistered = true; // Release-publish only after exact pick/collection/execution validation.
    }
    internal void BeginObtain(object relic, object player)
    {
        Check();
        if (!AwardsEntered || Awards?.IsCompleted == true || !Index.HasValue || ObtainEntered || !ReferenceEquals(player, Player))
            throw new NotSupportedException("treasure_obtain_unowned");
        ObtainEntered = true; ObtainedRelic = relic;
    }
    internal bool RewardReady()
    { Check(); return Root != null && _offers.Values.All(t => t != null) && ChildrenDone; }
    internal void BeginOffer(object set)
    {
        Check();
        if (LocalSkip || _offers.Values.Any(t => t?.IsCompletedSuccessfully != true) || !_offers.TryAdd(set, null))
            throw new NotSupportedException("nested_treasure_offer_unverified");
    }
    internal void AttachOffer(object set, Task task)
    { if (!_offers.ContainsKey(set) || _offers[set] != null) throw new NotSupportedException("treasure_offer_receipt_unverified"); _offers[set] = task; }
    internal void BindScreen(object set, object screen, bool seen)
    {
        if (!seen) Fail("reward_relic_ftue_completion_unverified");
        Check();
        if (!_offers.ContainsKey(set) || _screens.Count != 0) throw new NotSupportedException("treasure_reward_screen_unverified");
        var lifetime = new TaskCompletionSource(); _screens.Add(screen, (set, lifetime));
        selectors.BeginContinuation(screen, Owner, lifetime.Task, RewardReady);
    }
    internal bool OwnsScreen(object screen) => !Closed && _screens.ContainsKey(screen);
    internal bool OwnsDecision(object screen) => !Closed && (ReferenceEquals(screen, Scene) || OwnsScreen(screen));
    private bool ChildrenDone => _children.All(get => get()?.IsCompletedSuccessfully == true);
    internal void AddChild(Task task) => AddWork(() => task);
    internal void AddWork(Func<Task?> get) { Check(); _children.Add(get); }
    internal bool GameplayDone()
    {
        Check();
        if (LocalSkip)
            return PickWork?.Invoke()?.IsCompletedSuccessfully == true && Skip?.IsCompletedSuccessfully == true
                && _offers.Values.All(t => t?.IsCompletedSuccessfully == true) && ChildrenDone;
        return Root?.IsCompletedSuccessfully == true && Pick != null && PickWork?.Invoke()?.IsCompletedSuccessfully == true
            && Awards?.IsCompletedSuccessfully == true && Finished.IsCompletedSuccessfully
            && (Index.HasValue ? ObtainEntered && Obtain?.IsCompletedSuccessfully == true : !ObtainEntered)
            && (!SkipToken.IsCancellationRequested || ExpectedSkipCancellation)
            && Skip != null && (Skip.IsCompletedSuccessfully || Skip.IsCanceled && ExpectedSkipCancellation)
            && _offers.Values.All(t => t?.IsCompletedSuccessfully == true) && ChildrenDone;
    }
    internal bool RoomReady()
    {
        Check();
        return _screens.Count == 0 && _offers.Values.All(t => t?.IsCompletedSuccessfully == true) && ChildrenDone
            // Claim becomes clickable before native EnableSkipAfterDelay completes; do not publish a temporary singleton.
            && (Pick == null ? Root != null && Skip?.IsCompletedSuccessfully == true && !Began.IsCompleted : GameplayDone());
    }
    internal bool Poll()
    {
        Check();
        if (ChildrenDone)
            foreach (var screen in _screens.Where(p => _offers[p.Value.Set]?.IsCompletedSuccessfully == true).Select(p => p.Key).ToArray())
            { _screens[screen].Lifetime.SetResult(); _screens.Remove(screen); selectors.CloseContinuation(screen, Owner); }
        int completed = _children.Count(get => get()?.IsCompletedSuccessfully == true);
        if (completed != _completed)
        { _completed = completed; foreach (var screen in _screens.Keys) selectors.RenewContinuation(screen, Owner); selectors.RenewContinuation(Scene, Owner); }
        return MapOpened && Proceed?.IsCompletedSuccessfully == true && (OnlyProceed || GameplayDone());
    }
    internal void Close()
    {
        lock (_skipCancellationGate) Closed = true; // Late callback delivery must not revive a closed owner.
        selectors.CloseOwner(Owner);
    }
}
