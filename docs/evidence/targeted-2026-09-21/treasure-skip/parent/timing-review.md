## Review — callback timing follow-up

**The immediate `LocalSkip` requirement is not proven safe. Remove only that requirement; retain the synchronous enqueue/Proceed receipts and asynchronous ownership checks.**

### Finding: P1 — dispatch incorrectly requires synchronous execution
`mod/STS2MCP/McpMod.TreasureActions.cs:284` conflates “exact pick enqueued” with “exact pick finished.”

Evidence:
- Observation checks `CurrentlyRunningAction` and queue emptiness, **not batch completion** (`McpMod.Contract.cs:144–146`; `BridgeProtocol.cs:55–59`). `RoomReady` adds no batch barrier (`TreasureOperation.cs:159–164`).
- Native `IsRunning` means the batch’s `_queueTaskCompletionSource` is unfinished (`/tmp/jev-autonomous-2026-09-20/resume-receipt/implementation/il-executor.log:492–509`).
- Native `AfterActionFinished` clears `CurrentlyRunningAction` independently of batch completion (`/tmp/jev-m2-owned-teardown/executor-finish.il`, IL 0117–0124). `ExecuteActions` can still be awaiting its ProcessFrame continuation before advancing the queue and completing that batch (`implementation/native-executeactions.il`, IL 0503–0618, 1124–1165).
- While that batch remains running, `ActionQueueChanged` does **not** start another executor (`implementation/native-actionqueuechanged.il`, IL 0000–0037).

Thus current admission does not exclude an interleaving where prior work finishes, the room becomes ready before the executor continuation resumes, and Skip is enqueued but executes later. The 2.5-second Skip timer establishes no exclusion. This is a source-supported scheduling case, **not a claim that the recorded live failure followed it**.

**Smallest correction:** delete only `|| picking && !index.HasValue && !op.LocalSkip` from the post-click condition.

### Correct: existing ownership supports the delay
With pending/unstarted pick work:
- `Check()` does not assert completed-pick-without-awards.
- `Primary` remains the parked root; early Proceed/map receipts cannot release ownership.
- The retained exact-action `AfterFinished` callback needs no surviving dispatch scope. It verifies current identities/native receipt and admits `LocalSkip`; subsequent polling can release.
- Root, pick, token, Proceed, and latched failures remain checked (`TreasureOperation.cs:39–78,146–175`; `McpMod.RewardHooks.cs:186–245`).

### Regression needed
Add the proposed real `BridgeSession`/`TreasureOperation` delayed-success case:
1. Bind exact pick with unavailable, then pending execution work.
2. Supply successful Proceed and map receipts; refresh must remain pending without failure.
3. Complete original pick work and deliver the exact receipt before the next poll; refresh releases while root remains parked.
4. Preserve negative variants for faults/cancellation and prior latched failure.

The existing `pending_pick` case deliberately fails admission and latches failure; it does **not** cover delayed success (`tests/check-bridge.sh:400–415`).

Importantly, an operation/session test alone already bypasses the offending dispatch check. Update the compiled dispatch wiring assertion (`:2170`) and include a check that fails if the immediate `LocalSkip` requirement returns.

**Merge verdict: OK with notes, qualified** — retain the original review’s other conclusions, but make this narrow correction and validate it before installation. Corrected live behavior remains unverified. No edits or commands performed.