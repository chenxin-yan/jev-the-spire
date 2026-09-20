## Review

- **Fixed — remaining P1 #2:** `ClearEventEntry` preserves failed cleanup history before clearing the entry (`McpMod.EventActions.cs:26–30`). `DispatchMap` uses this guard before travel (`McpMod.NativeActions.cs:95`); `BeginActOpening` refuses to overwrite failed history without throwing (`McpMod.EventActions.cs:37`).
- **Correct:** `BeginRunEpoch` runs the same helper through `Retire` (`McpMod.Contract.cs:49–55`). Cleanup errors are caught and latched by the existing release chain, preventing replacement without escaping native setup (`BridgeProtocol.cs:328–360`).
- **Verified checks:** Retained tests exercise failed-entry turnover, repeated boundary refusal, exact-once cleanup, and successful turnover (`tests/check-bridge.sh:2167–2197`). The genuine RED fails the intended turnover assertion. Inspected `parent/final-v2` logs report 2694 native checks, zero-warning build, and all gates exiting zero.
- **Prior dispositions:** Original P1 #1 and #3 remain accepted as fixed. Selector/new-run proof is unchanged.

No issues found.

Read-only review; no tests executed by this reviewer or live verification performed. Harmony/Godot behavior remains unverified, and this candidate has no installation or live-run approval.

**Merge verdict: OK with notes**