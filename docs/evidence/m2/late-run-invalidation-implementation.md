# M2 late run invalidation (review P2) — one-line guard in the existing scoped validation path

**Scope: only the accepted P2 (`cleanup-after-exit` / `replacement-run-after-exit`). The owned-teardown design and cancellation authority are unchanged. No new callbacks/hooks/state, no ContextHalt broadening, no global no-run disposal, no event coverage. Not installed, not live-verified. Full M2 remains BLOCK.**

Frozen checkpoint: `/tmp/jev-m2-late-cleanup/` — `release/STS2_MCP.dll` SHA256 **`3828de49ec906f8e22502452b7cf30d8f429df48e4e7e68fb8a8317640c6f67a`** (prior candidate `0d539f85…c4b2c` and installed baseline `71ebec73…2dac8bd` untouched; native `9cb4f1ad…3fbf12b4` re-hashed in `final-hashes.log`).

## Change (3 files; 1 compiler input)

`CombatExitOperation.ValidateReadyIdentity` — the per-poll check `RegisterCombatExit` already calls right after `Poll` — gains one guard ahead of the existing decision check:

```csharp
if (_roomTransition != null && !ReferenceEquals(Run, run)) throw new NotSupportedException("reward_run_invalidated");
```

Semantics: once the map continuation is consumed (`_roomTransition != null`), the operation is bound to its original `RunState` for the rest of the travel. A null run (native `RunManager.CleanUp` via main menu: no `RoomExited`, no action cancellation, `State = null` in its finally) or a different run object is permanent → `BridgeSession.Refresh` catches the `NotSupportedException`, calls `Fail("reward_run_invalidated")`, which runs `Release` exactly once (the existing `OnRelease` chain: `CombatEnded`/`BeforeActionExecuted`/`RoomExited`/NodeAdded unsubscriptions, `operation.Close()`, owner disposal). `Failure` stays set, so later polls return early: sticky. Only the run is compared — the current room legitimately changes during same-run travel, and "same run, not yet at destination" still goes through `Poll` returning false with no throw (pending, never false-fail).

Other files: `tests/check-bridge.sh` (regressions below), `README.md` (one sentence in the existing combat-exit contract paragraph). Full delta vs `/tmp/jev-m2-owned-teardown/source`: `/tmp/jev-m2-late-cleanup/incremental.diff`.

## Red first, then fix

- Reviewer's production driver copied **byte-identical** (`independent-sha256.log`) into `/tmp/jev-m2-late-cleanup/independent/` and run vs prior candidate `0d539f85`: **exit 1, 91 checks / 2 RED** (`independent-before.log`) — same as parent's rerun.
- Same unchanged driver vs new DLL: **exit 0, 93 checks / 0 RED**; `cleanup-after-exit: failure=reward_run_invalidated pending=True releases=1`, `replacement-run-after-exit: failure=reward_run_invalidated pending=True releases=1`, sticky-once checks pass (`independent-after.log`).
- Extended supplied harness vs prior candidate: **exit 134** at named assertion `run-cleanup-after-exit halts as reward_run_invalidated, actual none releases=0` (`regression-before.log`).

## Supplied regression coverage added (`tests/check-bridge.sh`, teardown block)

- The block's `HoldUntil` now uses the exact `RegisterCombatExit` shape (`Poll` then `ValidateReadyIdentity(currentRun, currentRoom)`); `OnRelease` counts releases; `ExpectHalt` now asserts `releases == 1` at halt, then re-polls after all later receipts **and** after restoring the original run **and** after a brand-new run, asserting the failure name, pending, and `releases == 1` (no healing, exactly-once disposal). Successful scenarios assert `releases == 1` at release.
- New scenarios: `run-cleanup-after-exit` (menu after valid exit + successful movement, before next observation), `run-replaced-after-exit`, `run-cleanup-before-arrival` (first proves same-run room change with `arrived=false` stays pending with `releases == 0`, then run null → sticky halt), `run-cleanup-armed` (CleanUp while armed, no `RoomExited`), `run-cleanup-before-travel`.
- All 22 prior scenarios retained unchanged in behavior (delayed Offer/arrival, parameterless cancellation order, loop faults, joinLoop controls, exit/executing provenance negatives, movement faults/cancel/sticky-cancel, offer fault), now additionally under the room-changing `currentRoom` and release-count assertions.

## Validation (offline; `commands.log` has exact commands and exits)

| Check | Result |
|---|---|
| Deployment-disabled rebuild | exit 0, 0 warnings, 0 errors |
| Supplied `check-bridge.sh` vs new DLL | exit 0, **1809** checks (was 1758; +51) |
| Supplied harness vs prior candidate | exit 134, named late-cleanup assertion |
| Reviewer driver (unchanged) prior / new | 91/2 RED exit 1 → 93/0 RED exit 0 |
| Retained O1 / R2 / live-readiness / cancellation-positive | 60 / 16 / 50 / 1266, exit 0 each |
| Writer teardown repro prior / new | 0 RED / 0 RED |
| Original no-receipt diagnosis repro vs new | 3 RED by design (unchanged) |
| Freeze/audit `freeze.py` | exit 0: 19-file exhaustive Git inventory, 28 inputs (27 byte-identical), delta exactly `CombatExitOperation.cs`/`README.md`/`tests/check-bridge.sh`; HEADs `55e06485…`/`d1bbc90d…`, empty indexes, app tracked diff empty, `CONTEXT.md`/`mise.toml` hashes unchanged, `git diff --check` clean |

No failed fix attempts; harness passed on first run after the guard.

## Limitations

- Managed production-controller evidence only; installed hook delivery and actual `RunManager.State` timing after `CleanUp` are parent-only live gates.
- The guard fires at the next bridge poll, i.e. the next observation/`Refresh` on the main thread; between CleanUp and that poll the subscriptions exist exactly as before (no new polling/timer was added by design).
- The guard applies only after `ConsumeMap`; before consumption the pre-existing `HasDecision && CanDecide()` identity check is unchanged.
- No installation, no M2 acceptance; ByrdonisNest/event model unchanged; the current live game is untouched.

```acceptance-report
{
  "criteriaSatisfied": [
    {"id": "criterion-1", "status": "satisfied", "evidence": "One guard line in existing CombatExitOperation.ValidateReadyIdentity; delta exactly CombatExitOperation.cs, README.md, tests/check-bridge.sh (freeze.py audit exit 0); no new hooks/callbacks/state, no ContextHalt change, no event coverage"},
    {"id": "criterion-2", "status": "satisfied", "evidence": "Unchanged reviewer driver 91/2 RED on 0d539f85 -> 93/0 RED on 3828de49; supplied harness 1809 exit 0 on new DLL and exit 134 named assertion on prior; O1/R2/readiness/cancel-positive exit 0; all logs, exits, manifests and hashes under /tmp/jev-m2-late-cleanup/"}
  ],
  "changedFiles": ["../STS2MCP/CombatExitOperation.cs", "../STS2MCP/tests/check-bridge.sh", "../STS2MCP/README.md"],
  "testsAddedOrUpdated": ["../STS2MCP/tests/check-bridge.sh (teardown block: exact Poll+ValidateReadyIdentity shape, release counter, 5 run-invalidation scenarios, no-heal after restored/new run)"],
  "commandsRun": [
    {"command": "dotnet run independent/Check.csproj -- /tmp/jev-m2-owned-teardown/release/STS2_MCP.dll", "result": "failed", "summary": "expected red-first: 91 checks / 2 RED, exit 1"},
    {"command": "dotnet build STS2_MCP.csproj -t:Rebuild -c Release -o /tmp/jev-m2-late-cleanup/release (imports disabled, explicit game dir)", "result": "passed", "summary": "0 warnings, 0 errors"},
    {"command": "dotnet run independent/Check.csproj -- /tmp/jev-m2-late-cleanup/release/STS2_MCP.dll", "result": "passed", "summary": "93 checks / 0 RED"},
    {"command": "bash tests/check-bridge.sh /tmp/jev-m2-late-cleanup/release/STS2_MCP.dll sts2.dll", "result": "passed", "summary": "PASS: 1809 actual-DLL checks"},
    {"command": "bash tests/check-bridge.sh /tmp/jev-m2-owned-teardown/release/STS2_MCP.dll sts2.dll", "result": "failed", "summary": "expected: exit 134 at run-cleanup-after-exit assertion"},
    {"command": "O1 / R2 / readiness / cancel-positive retained suites vs new DLL", "result": "passed", "summary": "60 / 16 / 50 / 1266 checks, exit 0"},
    {"command": "python3 /tmp/jev-m2-late-cleanup/freeze.py", "result": "passed", "summary": "inventory/manifests/HEADs/hashes audit exit 0"}
  ],
  "validationOutput": [
    "cleanup-after-exit: failure=reward_run_invalidated pending=True releases=1",
    "replacement-run-after-exit: failure=reward_run_invalidated pending=True releases=1",
    "PASS: 1809 actual-DLL checks; no game initialization or HTTP.",
    "release sha256 3828de49ec906f8e22502452b7cf30d8f429df48e4e7e68fb8a8317640c6f67a"
  ],
  "residualRisks": [
    "Guard fires at the next main-thread poll; subscriptions persist between native CleanUp and that poll exactly as before (no new polling by design)",
    "Managed evidence only; installed delivery/RunManager.State timing after CleanUp are parent-only live gates",
    "Full M2 remains BLOCK; no installation performed"
  ],
  "noStagedFiles": true,
  "diffSummary": "CombatExitOperation.ValidateReadyIdentity: fail consumed-map operation (reward_run_invalidated) when original run is null/replaced; harness: exact callback shape, release counting, 5 run-invalidation scenarios, no-heal on restored/new run; README: one contract sentence",
  "reviewFindings": ["no blockers"],
  "manualNotes": "Sole writer of ../STS2MCP; nothing staged/committed; app repo untouched; installed 71ebec candidate and live game at ByrdonisNest untouched."
}
```
