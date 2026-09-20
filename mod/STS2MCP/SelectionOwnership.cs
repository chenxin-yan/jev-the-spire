using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Threading;
using System.Threading.Tasks;

namespace STS2_MCP;

// Local shim until the game exposes explicit selector-owner tokens. No visibility/timing inference.
internal sealed class SelectionOwnership
{
    private readonly AsyncLocal<object?> _ambient = new();
    // Re-validation of the admission that installed the ambient owner; every lease begun under it inherits it as Ready.
    private readonly AsyncLocal<Func<bool>?> _ambientReady = new();
    private long _generation;
    private readonly Dictionary<object, Lease> _selectors = new(ReferenceEqualityComparer.Instance);
    private readonly Dictionary<object, Lease> _continuations = new(ReferenceEqualityComparer.Instance);
    private readonly Dictionary<object, object> _contexts = new(ReferenceEqualityComparer.Instance);
    private readonly ConditionalWeakTable<object, object> _closedOwners = new();
    private readonly HashSet<object> _failedOwners = new(ReferenceEqualityComparer.Instance);
    internal object? CurrentOwner => _ambient.Value;

    internal sealed class Lease(long generation, object selector, object? owner)
    {
        internal readonly long Generation = generation;
        internal readonly object Selector = selector;
        internal readonly object? Owner = owner;
        internal Task? Task;
        internal bool Closed;
        internal Func<bool> Ready = () => true;
    }

    private sealed class Scope(SelectionOwnership registry, object? previous, Func<bool>? previousReady) : IDisposable
    {
        private bool _disposed;
        public void Dispose()
        {
            if (_disposed) return;
            _disposed = true;
            registry._ambient.Value = previous;
            registry._ambientReady.Value = previousReady;
        }
    }

    internal IDisposable Enter(object? owner, Func<bool>? ready = null)
    {
        var scope = new Scope(this, _ambient.Value, _ambientReady.Value);
        _ambient.Value = owner;
        _ambientReady.Value = owner == null ? null : ready;
        return scope;
    }

    internal void RegisterContext(object context, object owner)
    {
        lock (_selectors)
        {
            if (_closedOwners.TryGetValue(owner, out _) || !_contexts.TryAdd(context, owner))
                throw new NotSupportedException("stale_or_duplicate_selection_context");
        }
    }

    internal object? ResolveContext(object? context)
    {
        lock (_selectors)
            return context != null && _contexts.TryGetValue(context, out var owner) ? owner : null;
    }

    internal Lease? BeginBoundary(object selector)
    {
        if (CurrentOwner != null) return Begin(selector);
        lock (_selectors)
        {
            // A persistent hand/grid node can be reused by a human or foreign operation.
            // Retire our prior permission without interfering with that native entry.
            if (_selectors.TryGetValue(selector, out var previous)) Fault(previous);
        }
        return null;
    }

    internal Lease Begin(object selector)
    {
        lock (_selectors)
        {
            if (CurrentOwner is { } owner && _closedOwners.TryGetValue(owner, out _))
                throw new NotSupportedException("stale_selection_owner");
            foreach (var old in _selectors.Values.Where(s => s.Task?.IsCompleted == true).ToArray()) Close(old);
            // ponytail: one active selector per operation; nested overlapping UIs halt until their protocol is grounded.
            if (_selectors.ContainsKey(selector) || _selectors.Values.Any(s => ReferenceEquals(s.Owner, CurrentOwner)))
            {
                if (CurrentOwner != null) _failedOwners.Add(CurrentOwner);
                throw new NotSupportedException("overlapping_selection_ownership");
            }
            var lease = new Lease(++_generation, selector, CurrentOwner) { Ready = _ambientReady.Value ?? (() => true) };
            _selectors.Add(selector, lease);
            return lease;
        }
    }

    internal void Attach(Lease lease, Task task)
    {
        lock (_selectors)
        {
            if (lease.Closed || lease.Task != null || !_selectors.TryGetValue(lease.Selector, out var current)
                || !ReferenceEquals(lease, current)) throw new NotSupportedException("stale_selection_ownership");
            lease.Task = task ?? throw new NotSupportedException("selection_task_unavailable");
        }
    }

    internal Lease BeginContinuation(object selector, object owner, Task lifetime, Func<bool> ready)
    {
        lock (_selectors)
        {
            if (_closedOwners.TryGetValue(owner, out _) || _continuations.ContainsKey(selector))
                throw new NotSupportedException("stale_or_duplicate_continuation");
            var lease = new Lease(++_generation, selector, owner) { Task = lifetime, Ready = ready };
            _continuations.Add(selector, lease);
            return lease;
        }
    }

    internal void CloseContinuation(object selector, object owner)
    {
        lock (_selectors)
            if (_continuations.TryGetValue(selector, out var lease) && ReferenceEquals(lease.Owner, owner))
            { lease.Closed = true; _continuations.Remove(selector); }
    }

    internal void RenewContinuation(object selector, object owner)
    {
        lock (_selectors)
            if (_continuations.TryGetValue(selector, out var lease) && ReferenceEquals(lease.Owner, owner))
            {
                CloseContinuation(selector, owner);
                BeginContinuation(selector, owner, lease.Task!, lease.Ready);
            }
    }

    internal Lease? Find(object selector, object? owner)
    {
        lock (_selectors)
            return owner != null && (_selectors.TryGetValue(selector, out var lease) || _continuations.TryGetValue(selector, out lease)) && !lease.Closed
                && ReferenceEquals(owner, lease.Owner) && lease.Task is { IsCompleted: false } ? lease : null;
    }

    internal bool IsCurrent(Lease lease, object? owner) => ReferenceEquals(Find(lease.Selector, owner), lease) && lease.Ready();

    internal bool Failed(object owner)
    {
        lock (_selectors)
            return _failedOwners.Contains(owner) || _selectors.Values.Any(s => ReferenceEquals(s.Owner, owner)
                && s.Task is { IsCompleted: true, IsCompletedSuccessfully: false });
    }

    internal void Fault(Lease lease)
    {
        lock (_selectors)
        {
            if (lease.Owner != null) _failedOwners.Add(lease.Owner);
            Close(lease);
        }
    }

    internal void Close(Lease lease)
    {
        lock (_selectors)
        {
            if (lease.Owner != null && lease.Task is { IsCompleted: true, IsCompletedSuccessfully: false })
            {
                _ = lease.Task.Exception;
                _failedOwners.Add(lease.Owner);
            }
            lease.Closed = true;
            if (_selectors.TryGetValue(lease.Selector, out var current) && ReferenceEquals(current, lease))
                _selectors.Remove(lease.Selector);
        }
    }

    internal void CloseOwner(object owner)
    {
        lock (_selectors)
        {
            foreach (var lease in _selectors.Values.Where(s => ReferenceEquals(s.Owner, owner)).ToArray()) Close(lease);
            foreach (var selector in _continuations.Where(p => ReferenceEquals(p.Value.Owner, owner)).Select(p => p.Key).ToArray()) CloseContinuation(selector, owner);
            foreach (var context in _contexts.Where(p => ReferenceEquals(p.Value, owner)).Select(p => p.Key).ToArray()) _contexts.Remove(context);
            _failedOwners.Remove(owner);
            _closedOwners.GetValue(owner, _ => new object());
        }
    }
}
