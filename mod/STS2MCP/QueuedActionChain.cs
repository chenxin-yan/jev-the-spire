using System;
using System.Threading.Tasks;

namespace STS2_MCP;

// A map vote synchronously enqueues one downstream travel action. Their tasks are distinct.
internal sealed class QueuedActionChain(object destination)
{
    private sealed record Work(object Identity, Task Completion, Func<Task?> Execution);
    private Work? _root;
    private Work? _child;
    private Task? _joined;
    internal object? Root => _root?.Identity;
    internal bool HasChild => _child != null;

    internal void AddRoot(object root, Task completion, Func<Task?> execution)
    {
        if (_root != null) throw new NotSupportedException("duplicate_map_vote");
        _root = new(root, completion, execution);
    }

    internal void AddChild(object? cause, object actualDestination, object child, Task completion, Func<Task?> execution)
    {
        if (_root == null || !ReferenceEquals(cause, _root.Identity) || !Equals(destination, actualDestination) || _child != null)
            throw new NotSupportedException("unowned_map_travel");
        _child = new(child, completion, execution);
    }

    internal Task? Poll()
    {
        if (_root == null) throw new NotSupportedException("map_vote_not_enqueued");
        var rootExecution = _root.Execution();
        if (_root.Completion.IsFaulted || _root.Completion.IsCanceled) return _root.Completion;
        if (rootExecution?.IsFaulted == true || rootExecution?.IsCanceled == true) return rootExecution;
        if (_child == null)
        {
            if (_root.Completion.IsCompleted) throw new NotSupportedException("map_vote_without_travel");
            return null;
        }
        var childExecution = _child.Execution();
        if (_child.Completion.IsFaulted || _child.Completion.IsCanceled) return _child.Completion;
        if (childExecution?.IsFaulted == true || childExecution?.IsCanceled == true) return childExecution;
        if (rootExecution == null || childExecution == null) return null;
        return _joined ??= Task.WhenAll(_root.Completion, rootExecution, _child.Completion, childExecution);
    }
}
