## Review

- **Correct:** The boundary is genuinely new-run-specific. `McpMod.SelectionHooks.cs:92–96` patches `InitializeNewRun`, not `Launch` or observation/retry. Pinned `callers-run-setup.log` separates new setups from saved/replay setups; `il-runmanager-setup.log` shows zero reloads stored before that boundary. Same-run identity is retained at `McpMod.Contract.cs:52`.
- **Correct:** Independent session GUIDs and `Accept`/`AcceptChild` version comparisons reject old-epoch POSTs (`BridgeProtocol.cs:257,393–409`; `McpMod.Contract.cs:329–341`).
- **Correct:** Enchant admission uses exact type equality, retains the existing owned `CardsSelected` lifetime, reads native enchantment labels, and recognizes both preview containers (`McpMod.LegalActions.cs:243–287`; `McpMod.StateBuilder.cs:1866–1900`). Native enchant/command IL supports these contracts. Candidate mismatch halts rather than silently omitting cards; foreign-context and unknown-subclass refusals remain.

### Finding: P1 — Successful-completion cleanup failures do not prevent epoch replacement

**Location:** `BridgeProtocol.cs:328–353,377–385`.

`Release()` clears `_release` before invoking callbacks. When cleanup throws during successful `Refresh()`, its catch calls `Fail("mutation_completion_unavailable")`. That second `Release()` is empty, so the new `_cleanupFailed` flag is never set. `Retire()` consequently returns true and permits a clean epoch despite unsuccessful old cleanup.

This becomes unsafe specifically with the new replacement path; previously the failed session remained process-sticky.

**Existing reproducible fixture:** `tests/check-bridge.sh:640–645` already exercises this path with a throwing cleanup callback, but only checks that some failure exists. Calling `Retire()` on that fixture currently succeeds.

**Smallest remedy:** Latch cleanup failure inside `Release()` itself, irrespective of its caller, and preserve `mutation_cleanup_failed`. Extend that existing fixture to require failed retirement and unchanged epoch across repeated boundaries.

### Finding: P1 — Event-entry cleanup bypasses the sticky retirement result

**Location:** `McpMod.Contract.cs:52–55`; `EventOperation.cs:22–25,68`; `McpMod.EventActions.cs:239–244`.

Event cleanup has two uncovered paths:

- `BeginRunEpoch` calls `_eventEntry.Close()` **after** successful session retirement, outside its cleanup accounting. A throwing cleanup escapes the observation-only Harmony postfix and interrupts native new-run setup.
- `EventEntry.Fail()` swallows `Close()` exceptions. `Close()` nevertheless sets `Closed` and clears `Cleanup`. Retirement’s event-operation callback invokes this swallowing path, allowing immediate epoch replacement despite unsuccessful unsubscribe. A previously failed entry likewise looks successfully closed at the next boundary.

**Smallest remedy:** Preserve event-entry cleanup failure and incorporate it into the session’s sticky retirement decision, including failures occurring before retirement. Do not let cleanup exceptions escape the native postfix.

**Required negative checks:** An idle event entry whose cleanup throws at the boundary, and an entry whose cleanup already threw through `Fail()`. Both must retain the failed epoch, reject replacement repeatedly, and avoid invoking cleanup twice. The current stale-event fixture (`tests/check-bridge.sh:2128–2136`) has no cleanup delegate.

### Finding: P1 — Retirement unsubscribes from replacement native publishers

**Location:** `McpMod.NativeActions.cs:188,204–214`; `McpMod.TreasureActions.cs:187–198`; new boundary at `McpMod.Contract.cs:49–55`.

Map cleanup resolves `manager.ActionQueueSet` when cleanup runs. Treasure cleanup similarly resolves the current `RunManager.Instance.ActionExecutor` and `ActionQueueSet`, rather than retaining the publishers originally subscribed to.

Pinned `il-runmanager-setup.log`, `InitializeShared` IL 0133–0155, creates and assigns **new** queue/executor instances before `InitializeNewRun`. Therefore, when this newly introduced boundary retires a still-pending operation, these callbacks unsubscribe from the new publishers—not their original subscription targets. Successful `Retire()` does not establish the promised old-subscription release.

**Smallest remedy:** Capture queue/executor instances when registering handlers and use those same instances for every unsubscribe, including map `VoteFinished`.

**Required check:** Replace the manager’s publishers before retirement and verify the original publishers lose their handlers exactly once. Generic cleanup-counter fixtures and the “no closure reads `_bridgeSession`” IL check do not exercise publisher identity.

### Verification and limitations

Read-only review; no edits, commands, installation, game requests, or live testing. Examined source, exported diff, native IL, retained fixtures, and build/check logs. Exported logs report build success and 2672 checks; the baseline RED stops at missing hook wiring. Those results do not cover the failures above.

Enchant UI behavior, Harmony application, and live main-thread lifecycle ordering remain unverified. Parent should rerun README gates after adding the targeted negative checks.

**Merge verdict: BLOCK**