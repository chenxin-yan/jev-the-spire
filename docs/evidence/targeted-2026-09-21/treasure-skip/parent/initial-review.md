## Review

**No source-code defects found in the reviewed diff. Two P2 corrections are needed in the diagnosis report.**

### Correct
- **Root cause:** Native single-player `OnPicked(null)` sets `_singleplayerSkipped` and returns before awards (`implementation/native-synchronizer.il`, IL 0333–0368). `OpenChest` remains awaiting `RelicPickingBegan` (`native-openchest.il`, IL 0492–0550). The former completed-pick/requires-awards invariant therefore rejects this legitimate lane; merely removing the generic catch reason would not resolve ownership.
- **Exact ownership:** `McpMod.TreasureActions.cs:38–69,237–275` preserves current run/room/player/collection identity, ordered relic-reference identity, false→true native receipt, exact action identity, original completion/execution tasks, and cancellation history. Native `GameAction.Execute` publishes completion before `AfterFinished` (IL 0567–0586).
- **Bounded release:** `TreasureOperation.cs:39–78,146–175` retains root fault/cancellation checks and rejects unexpected root completion, awards, or obtain work. Successful Skip still requires Proceed, map, and child-work completion. `McpMod.RewardHooks.cs:186–245` retains early-map, duplicate-Proceed, identity, and task guards.
- **Baseline and sibling paths:** Frozen readiness changes remain present (`TreasureOperation.cs:159–164`; `tests/check-bridge.sh:311–333,2080–2087`). Claims, OnlyProceed, extra rewards, and cancellation-delivery handling retain their existing barriers.
- **Tests:** Actual production-operation/session tests cover successful release and refused/faulted/cancelled cases (`tests/check-bridge.sh:378–473`), supplemented by compiled wiring/native IL checks (`:2139–2173`). Recorded original-behavior RED and M1 fail the intended behavioral assertion; M2/M3 fail wiring checks. These are not Godot/Harmony runtime tests.

### Findings
- **P2 — Incorrect exception-swallowing claim.** Worker `treasure-skip/implementation.md:76` says `OnPicked` exceptions can yield successful `_executionTask`. However, `native-pickrelicaction.il:15–16` calls `OnPicked` synchronously before returning a task, and `gameaction-execute.il:54–56` invokes `RunSafely` only afterward. Additionally, `native-logtaskexceptions.il:62,71` explicitly rethrows and sets the returned task’s exception. **Smallest fix:** correct the report; retain the positive native receipt for provenance, not as compensation for the claimed swallowing.
- **P2 — Wrong cancellation source in the elimination argument.** Worker `implementation.md:27` cites room `_cts.Cancel()` to exclude Skip-token cancellation. `native-openchest.il:139,154–155,198–199` instead creates a separate local `cancelSource`, passes its token to EnableSkip, and calls `CancelAsync` after picking begins. **Smallest fix:** cite that exact token and ordering. Production correctly retains the passed token; no code change is indicated.

### Validation boundary
Read recorded logs: warning-free build, **2,932 actual-DLL checks**, **57 application tests / 210 assertions**, and successful lint/format/typecheck. No commands, edits, installation, live interactions, or replay performed.

The historical journal establishes the old installed build’s accepted Skip followed by halt (`journal.jsonl:535–537`). It does **not** establish corrected live behavior. Candidate Skip release and claim-path live acceptance remain outstanding.

**Merge verdict: OK with notes** — source/managed/IL review passes; correct the diagnostic statements and keep live acceptance explicitly separate.