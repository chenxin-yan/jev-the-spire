## Review

- **Fixed — original P1 #1:** `BridgeProtocol.cs:328–362` now latches failure inside `Release()`, preserves `mutation_cleanup_failed`, and prevents subsequent retirement. The extended completion-cleanup fixture and `parent/cleanup-red.log` directly cover the original defect.
- **Fixed — original P1 #3:** Map and treasure subscriptions now retain their original publishers (`McpMod.NativeActions.cs:91–92,190,205,215`; `McpMod.TreasureActions.cs:164–165,190–191,199–200`). Production-closure tests exercise publisher replacement, preservation of replacement handlers, and no repeated unsubscribe. The publisher mutation fails the intended assertion.
- **Partially fixed — original P1 #2:** Cleanup during the boundary now runs inside the isolated release chain; historical failure on the retained entry also blocks retirement (`McpMod.Contract.cs:52–58`; `EventOperation.cs:68–75`). Neither tested cleanup exception escapes native setup. However, the historical failure can still be discarded before that boundary.

### Finding: P1 — Event turnover can erase historical cleanup failure

**Evidence:**
- `EventEntry.Fail()` intentionally swallows cleanup exceptions; the failure is recorded only on that entry (`EventOperation.cs:22–25,68–75`).
- `DispatchMap` calls `Close()` and then unconditionally clears `_eventEntry` (`McpMod.NativeActions.cs:95`). For an already-closed entry with `CleanupFailed=true`, `Close()` returns normally.
- Only `BeginRunEpoch` checks `CleanupFailed` (`McpMod.Contract.cs:57`). After map dispatch discards the entry, this check cannot see its failure.

**Reachable sequence:** While the bridge is idle, foreign event input invokes `entry.Fail()` (`McpMod.EventActions.cs:72–75`), with cleanup throwing and being swallowed. Native input is not interrupted and can proceed to the map. Map observations do not check the old entry (`McpMod.Contract.cs:156–171`); subsequent bridge map dispatch drops it. A later fresh run can then replace the session despite failed historical cleanup.

This is the remaining portion of original finding #2, not an unrelated refactor request.

**Smallest remedy:** Before discarding an event entry, reject its historical cleanup failure and retain it for failed retirement; alternatively, latch cleanup failure immediately into its originating session. Add a negative fixture covering failed-entry turnover before the fresh-run boundary. Current fixtures (`tests/check-bridge.sh:2163–2178`) leave the failed entry installed until retirement, so they miss this sequence.

### Verification and residual notes

The new-run discriminator, stale-version rejection, and exact enchant-selector contract remain unchanged by these corrections.

Inspected source, complete diff, RED/mutation logs, and final gate records. Final logs report 2692 native checks and successful build/app/lint/format/typecheck gates; I did not execute them. No source writes, game requests, installation, or live testing occurred. Harmony application and live Godot lifecycle/UI behavior remain unverified. This candidate has no installation or live-run approval.

**Merge verdict: BLOCK**