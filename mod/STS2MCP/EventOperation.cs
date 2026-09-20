using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace STS2_MCP;

// Stands in for the owned MoveToMapCoordAction when the native run start created the act's opening Ancient room itself.
internal sealed record ActOpening(object Destination);

// A setup receipt survives map completion; it grants no selector authority by itself.
internal sealed class EventEntry(object move, object owner, object run, object player)
{
    internal readonly object Move = move, Owner = owner, Run = run, Player = player;
    internal object? Room, Scene, Model, Layout, ActiveOwner;
    internal Task? Setup;
    internal int Generation;
    internal bool Bound, Closed, CleanupFailed;
    internal string? Failure;
    internal Action? Cleanup;
    private readonly Dictionary<object, (object Option, int Generation, bool Disabled)> _inputs = new(ReferenceEqualityComparer.Instance);
    internal void Fail(string reason)
    {
        Failure ??= reason;
        try { Close(); } catch { /* Permission stays revoked; never interrupt a foreign native callback. */ }
    }
    internal void Check()
    {
        if (Closed || Failure != null) throw new NotSupportedException(Failure ?? "event_entry_closed");
        if (Setup?.IsFaulted == true || Setup?.IsCanceled == true)
        { _ = Setup.Exception; throw new NotSupportedException("event_setup_failed"); }
    }
    internal void Bind(object actualOwner, object room, object scene, object model, object layout)
    {
        if (Closed || Bound || !ReferenceEquals(actualOwner, Owner)) { Fail("event_setup_identity_unverified"); return; }
        Room = room; Scene = scene; Model = model; Layout = layout; Bound = true;
    }
    internal void Attach(Task task)
    {
        if (!Bound || Setup != null) { Fail("event_setup_receipt_duplicate"); return; }
        Setup = task;
    }
    internal bool OwnsScope(object? actualOwner) => !Closed && Failure == null && actualOwner != null &&
        (ReferenceEquals(actualOwner, ActiveOwner) || ReferenceEquals(actualOwner, Owner) && Setup?.IsCompleted != true);
    internal void Changed(object source, object? actualOwner)
    {
        if (!ReferenceEquals(source, Model) || !OwnsScope(actualOwner)) Fail("foreign_event_state_change");
        Generation++; _inputs.Clear(); // Generation is not completion.
    }
    internal void Input(object node, object option, object? actualOwner, bool initiallyDisabled)
    {
        if (!OwnsScope(actualOwner) || _inputs.ContainsKey(node)) { Fail("foreign_or_reused_event_input"); return; }
        _inputs.Add(node, (option, Generation, initiallyDisabled));
    }
    internal bool InputReady(object node, object option, int generation, bool nativeEnabled, bool synchronousLayout)
    {
        Check();
        if (!Bound || Setup?.IsCompletedSuccessfully != true || generation != Generation
            || !_inputs.TryGetValue(node, out var input) || input.Generation != generation || !ReferenceEquals(input.Option, option)) return false;
        if (!synchronousLayout && !input.Disabled) throw new NotSupportedException("event_initial_input_filter_unverified");
        return nativeEnabled;
    }
    internal void RequireGeneration(int generation)
    {
        Check();
        if (Setup?.IsCompletedSuccessfully != true || generation != Generation) throw new NotSupportedException("event_generation_not_ready");
    }
    internal void Close()
    {
        if (Closed) return;
        Closed = true;
        try { Cleanup?.Invoke(); }
        catch { CleanupFailed = true; throw; }
        finally { Cleanup = null; }
    }
}

// Ordinary event tasks have their own prerequisites; no combat-lifetime simulation.
internal sealed class EventOperation(object owner, EventEntry entry, SelectionOwnership selectors)
{
    internal readonly object Owner = owner;
    internal readonly EventEntry Entry = entry;
    internal Task? Root;
    internal bool Closed;
    internal string? Failure;
    private readonly Dictionary<object, Task?> _offers = new(ReferenceEqualityComparer.Instance);
    private readonly Dictionary<object, (object Set, TaskCompletionSource Lifetime)> _screens = new(ReferenceEqualityComparer.Instance);
    private readonly List<Func<Task?>> _children = new();
    private int _completed;
    internal void Fail(string reason) { Failure ??= reason; Entry.Fail(reason); }
    internal void Check()
    {
        Entry.Check();
        if (Failure != null || Closed) throw new NotSupportedException(Failure ?? "event_operation_closed");
        foreach (var task in new[] { Root }.Concat(_offers.Values).Concat(_children.Select(get => get())))
            if (task?.IsFaulted == true || task?.IsCanceled == true)
            { _ = task.Exception; throw new NotSupportedException("event_task_failed"); }
    }
    internal void BeginOffer(object set)
    {
        Check();
        if (_offers.Values.Any(task => task?.IsCompletedSuccessfully != true) || !_offers.TryAdd(set, null)) throw new NotSupportedException("nested_event_offer_unverified");
    }
    internal bool OwnsSet(object set) => !Closed && _offers.ContainsKey(set);
    internal void AttachOffer(object set, Task task)
    {
        if (!OwnsSet(set) || _offers[set] != null) throw new NotSupportedException("event_offer_receipt_unverified");
        _offers[set] = task;
    }
    internal void BindScreen(object set, object screen, bool terminal, bool seenAtEntry)
    {
        if (!seenAtEntry) Fail("reward_relic_ftue_completion_unverified");
        if (terminal) Fail("event_terminal_rewards_unverified");
        Check();
        if (!OwnsSet(set) || _screens.ContainsKey(screen)) throw new NotSupportedException("event_reward_screen_unverified");
        var lifetime = new TaskCompletionSource();
        _screens.Add(screen, (set, lifetime));
        selectors.BeginContinuation(screen, Owner, lifetime.Task, CanDecide);
    }
    internal bool OwnsScreen(object screen) => !Closed && _screens.ContainsKey(screen);
    private bool ChildrenDone => _children.All(get => get()?.IsCompletedSuccessfully == true);
    internal bool CanDecide() { Check(); return Entry.Bound && Entry.Setup?.IsCompletedSuccessfully == true && Root != null && _offers.Values.All(t => t != null) && ChildrenDone; }
    internal void AddChild(Task task) => AddWork(() => task);
    internal void AddWork(Func<Task?> get) { Check(); _children.Add(get); }
    internal bool Poll()
    {
        Check();
        if (ChildrenDone)
            foreach (var screen in _screens.Where(p => _offers[p.Value.Set]?.IsCompletedSuccessfully == true).Select(p => p.Key).ToArray())
            { _screens[screen].Lifetime.SetResult(); _screens.Remove(screen); selectors.CloseContinuation(screen, Owner); }
        int completed = _children.Count(get => get()?.IsCompletedSuccessfully == true);
        if (completed != _completed)
        { _completed = completed; foreach (var screen in _screens.Keys) selectors.RenewContinuation(screen, Owner); }
        return Root?.IsCompletedSuccessfully == true && _screens.Count == 0 && _offers.Values.All(t => t?.IsCompletedSuccessfully == true)
            && ChildrenDone;
    }
    internal void Close() { Closed = true; selectors.CloseOwner(Owner); }
}
