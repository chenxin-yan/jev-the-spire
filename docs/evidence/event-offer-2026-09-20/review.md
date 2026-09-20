## Review

- **Correct:** Minimal shared fix at `mod/STS2MCP/McpMod.RewardHooks.cs:129–158`: accepts null native offer room while retaining exact player/run agreement and rejecting non-null foreign rooms. Native evidence confirms `OfferCustom` constructs a set without assigning Room (`/tmp/jev-event-offer-2026-09-20/offer-custom-state.il:10–16`, `rewards-ctor.il:1–28`, `rewards-paths.il:1–7`).
- **Correct:** Live run/room/scene/player checks remain (`McpMod.EventActions.cs:112–123`, `McpMod.TreasureActions.cs:38–49`). Ambient-operation matching, nested-offer refusal and closed-operation checks remain (`McpMod.RewardHooks.cs:135–178`, `EventOperation.cs:84–96`, `TreasureOperation.cs:34–36,99–103`). No blanket adoption of human/foreign scopes or scenario-specific exceptions. Combat remains strictly room-bound.
- **Finding: P2 — Run-mismatch tests do not isolate run identity.** `mod/STS2MCP/tests/check-bridge.sh:2014,2019–2020` supplies a different Player in both foreign-run cases. Player comparison already rejects them; deleting only the helper’s run comparison would survive these new checks. Smallest fix: invoke the helper with the same set/player and room, but a different expected run; assert rejection.

### Evidence and limitations

- RED is genuine: `scratch/extracted-offer.il:1–19` contains the strict room/player/run predicate, wired into both branches. `scratch/check-red.log:2–5` fails the null-room assertion—not symbol lookup. GREEN reports 2042 checks; final build reports zero errors.
- Fixtures and compiled wiring are **not Godot UI certification**. Scope propagation, native screen creation and the complete live reward interaction were not exercised.
- Null Room definitively explains a rejection under the old predicate. It does **not** independently exclude other simultaneous failures: `McpMod.RewardHooks.cs:152–159` collapses identity/nesting exceptions into the same error, contrary to the handoff’s “different failure” claim.
- Reviewed existing artifacts only; no tests, game/provider calls or writes performed.

**Merge verdict: OK with notes.** No production correctness defect found; add the isolated run-mismatch check.