# M2 live-readiness slice: menu ordered context + card-reward input readiness

**Not accepted, not installed, not live-verified. M2 remains BLOCKED** (event-family coverage, unexecuted live/native gates). Parent owns installation, live control, acceptance and publication. No game HTTP, live/native object construction, launch, install, save/profile/settings/.env/credential access, inference, GitHub, staging, commits or subagents were used. The installed baseline is untouched. Metadata-only IL/reflection probes were the only game-assembly reads.

## Checkpoint

- Path: `/tmp/jev-m2-live-readiness/` (distinct from all prior paths).
- DLL: `/tmp/jev-m2-live-readiness/release/STS2_MCP.dll`, SHA256 `71ebec737f466c87800262475c94024a70c61dd3bb496229f2386ed5b2dac8bd`.
- Baseline DLL `dff158c2…be34ed` re-hashed and untouched at `/tmp/jev-m2-cancelasync/release/`.
- External HEAD detached `55e064850a68f3b4cde7e5fd525bf9b2dec4e885`; app `main` `d1bbc90dce5fe5af2aee561e351a02fbfad0255b`; both indexes empty; app tracked tree clean; `CONTEXT.md`/`mise.toml` hashes unchanged; installed `sts2.dll` still `9cb4f1ad…bf12b4`.
- All 19 candidate files frozen in `source/`, all 28 compiler inputs in `build-inputs/`, with SHA256 manifests re-verified by `shasum -c` (exit 0). `incremental.diff` = exact five-file delta versus `/tmp/jev-m2-cancelasync/source`; `tracked.diff`, head/status/index logs, `commands.log` (exact commands + exits), all `.log`/`.exit` files, `freeze.py`, `audit.log` (exit 0).
- New metadata evidence: `il/holder-ctor.il`, `il/grid-holder.il`, `il/grid-pool.il`, `il/setclickable-callers.log`, `wiring-old-vs-new.log`; probe sources under `probe/`.

## Changed files (five, all in `../STS2MCP`)

1. **`BridgeProtocol.cs`** — two pure helpers:
   - `ContextHalt(modded, initialized, profile, runInProgress, Func<bool?> multiplayer)` → `null` (allowed) or halt reason. Order: profile gates (`modded_profile_2_singleplayer_required`) → no run in progress returns `null` **without invoking** the service read → service `null` → `run_network_service_unavailable` (fail closed, not singleplayer) → `true` → `modded_profile_2_singleplayer_required` → `false` → allowed.
   - `RewardCardsInputDisabled(IEnumerable<bool?> offeredClickable)` → true if any offered holder is unclickable; `null` (missing `_isClickable`) throws `card_holder_clickability_unavailable`; empty sequence → false (alternative-only stays ready).
2. **`McpMod.Contract.cs`** — `IsAllowedContext()` replaced by `ContextHalt()` which passes `manager.IsInProgress` and a deferred `() => manager.NetService?.Type.IsMultiplayer()`; `CaptureObservationCore` halts with the returned reason. The later `game_over` (terminal) → `no_active_run` ordering is untouched, so a no-run menu now reaches the intended `no_active_run` halt (or terminal) with zero actions instead of `observation_unavailable:NullReferenceException`. Pending-session disposal on disallowed context is unchanged.
3. **`McpMod.LegalActions.cs`** — at the existing `card_reward` observation branch, before any take/alternative is enumerated: if `RewardCardsInputDisabled` over holders with a `CardModel` is true, set `state["waiting"] = true` and `break`. `FinishObservation` then reports `legal_actions_complete:false`, `legal_actions:[]`; the following `AddPotionActions` is already gated on `waiting is false`, so no sibling label exists either. Otherwise the branch is unchanged (takes + alternatives together, existing `AddCardClick` guards, missing metadata still throws → whole-observation halt).
4. **`tests/check-bridge.sh`** — 131 new assertions (1422 → 1553), see below.
5. **`README.md`** — one paragraph describing the two readiness semantics.

No new Harmony targets, task interception, tutorial writes, sleeps, force-enables, `OptionSelected` awaits, or user-facing API changes. Map completion/readability behavior untouched. No app/M3/M4 changes.

## Grounding

- Menu: `menu.il` (audit) — `get_NetService` returns the bare backing field; `get_IsInProgress` = `State != null`. The old compiled `IsAllowedContext` called `get_NetService → get_Type → IsMultiplayer` unconditionally (`wiring-old-vs-new.log`).
- Card reward, new metadata-only probes: `NCardHolder..ctor` sets `_isClickable = true` (`holder-ctor.il`); `NGridCardHolder.OnReturnedFromPool` calls `SetClickable(true)` (`grid-pool.il`); a whole-assembly caller scan (`setclickable-callers.log`) finds **only** `NCardRewardSelectionScreen.<DisableCardsForShortTimeAfterOpening>.MoveNext` (IL 54 false / IL 244 true), plus the Godot dispatch stub and the pool re-enable. Therefore, inside an ordinary `NCardRewardSelectionScreen`, an unclickable offered holder is exactly the native initial-disable window the audit identified, and the gate cannot become a permanent false-wait through any other native setter. The audit's `card-boundaries.il` already established that this window leaves the alternative (Skip) buttons enabled.
- Live witness: `open-card-reward-immediate.json` (Skip-only, `waiting:false`, `legal_actions_complete:true`, `mutation_pending:true`) vs `card-reward-settled.json` (3 takes + Skip, version 29 → 30). No live actions were taken; these files were only read.

## Tests (production-wired, compiled DLL)

- **Ordered context** (no game DLL needed): 2×2×2×2×3 = 48 combinations of `ContextHalt` with a counting `Func<bool?>`; asserts the exact halt reason and that the service read count is 1 only for an in-progress run in the allowed profile, 0 otherwise (no-run menu never reads it). Negatives: profile 1, uninitialized, unmodded, multiplayer `true`, missing service.
- **Compiled control flow** (game-DLL section, reusing the existing IL scan refactored into a `CalledMethods` local): `CaptureObservationCore` calls `McpMod.ContextHalt` and `IsAllowedContext` no longer exists; `McpMod.ContextHalt` calls `BridgeProtocol.ContextHalt` and `get_IsInProgress` and does **not** directly call `get_NetService`/`get_Type`/`IsMultiplayer` (they live only in the deferred lambda); `AddNonCombatActions` calls `RewardCardsInputDisabled` (wiring proof, not an unused helper).
- **Card-reward readiness sequence**: an actual `BridgeSession` owned by a parent operation + `SelectionOwnership` lease on an `NCardRewardSelectionScreen`-typed selector with an attached pending selection task. Production `ResolveObservationSelection` admits it (ownership precedes readiness). Phases `disabled [F,F,F]`, `partial [T,F,T]`, `ready [T,T,T]`, `alternative_only []`, `missing [T,null,T]` run through the production readiness helper and production `FinishObservation`: disabled/partial → `card_reward`, `waiting:true`, incomplete, zero labels, `AcceptChild` rejects Skip **and** a take; ready/alternative-only → complete, exact label set (`4` / Skip-only), fresh production `state_version`, waiting-era version → 409, current version → 0 with parent still pending and same lease/owner; missing → halt with zero labels and no `waiting` (fail closed, not false-wait, not pruned). No callback is ever invoked.
- Old-DLL regression: final script against the frozen baseline DLL exits **134** at `old context gate dereferences RunManager.NetService before checking run presence`. The script stops at first failure, so `wiring-old-vs-new.log` separately witnesses that the old `AddNonCombatActions` has no readiness call and the old `IsAllowedContext` eagerly dereferences the service.

## Commands and results

See `/tmp/jev-m2-live-readiness/commands.log` for exact argv. Summary:

| Step | Exit |
|---|---|
| Metadata IL probes / caller scan (offline, game assembly reflection only) | 0 |
| `check-bridge.sh` (final script) vs baseline DLL — expected fail | **134** (intended) |
| Deployment-disabled rebuild (`ImportDirectoryBuildProps/Targets=false`, explicit `STS2GameDir`, `--no-restore -t:Rebuild`) | 0, 0 warnings, 0 errors |
| `check-bridge.sh` vs new DLL | 0, **1553** checks (first attempt exited 134 on a fixture bug — `waiting` key absent from a halt state — fixed once in the test fixture, not production) |
| Retained R2 independent checks (`/tmp/jev-m2-relic-review/extra`) | 0, 16 |
| Retained O1 independent checks (`/tmp/jev-m2-ordinary-review/extra`) | 0, 60 |
| `freeze.py` audit (inventory, manifests, HEADs, indexes, whitespace, exits) | 0 |
| `shasum -c` source and build-input manifests | 0 / 0 |
| `git diff --check` both repos; `git diff --cached` both empty | 0 |

## Support limits and test limitations (honest)

- The full Godot scene (native `NCardRewardSelectionScreen`, holders, 0.35 s native `Cmd.Wait`) **cannot be constructed offline**; the branch itself was not executed. Coverage is: pure helper semantics + production ownership gate + production `FinishObservation`/session versioning + compiled-IL wiring proof. Whether `FindAllSortedByPosition<NCardHolder>` ever includes a non-`_cardRow` holder is unverifiable offline; such a holder would default clickable and cannot cause a false wait.
- If native `Cmd.Wait`'s token is cancelled before the re-enable (screen teardown), holders stay unclickable and the observation keeps waiting; that screen is going away, so no decision is lost, but it is a wait rather than a halt. Not a new ceiling vs. before.
- The live menu JSON had no stack trace; `NetService` is the grounded, now-verified-in-IL eager dereference, but another singleton read on a no-run menu is not excluded. It would now surface as the same safe `observation_unavailable` halt.
- `IsMultiplayerRun()` (HTTP-thread best-effort guard in `McpMod.cs`) and multiplayer-state builders still dereference `NetService` inside their own try/catch or `IsInProgress` guard; unchanged, out of this slice's contract route.
- Saved-snapshot files were read for grounding only; no assertion claims they test repaired code.
- No live re-observation of the reward-to-ready transition was performed; that remains a parent-authorized gate.

```acceptance-report
{
  "criteriaSatisfied": [
    {"id":"criterion-1","status":"satisfied","evidence":"Only the two adjudicated fixes: ordered no-run/missing-service context read before NetService dereference (fail-closed, terminal handling preserved) and card-reward whole-set waiting during the native initial input-disable window at its existing observation branch. Five-file delta; map behavior, event coverage, hooks, API untouched; no install/live/inference/staging."},
    {"id":"criterion-2","status":"satisfied","evidence":"Frozen /tmp/jev-m2-live-readiness with 19 sources, 28 build inputs, manifests, incremental.diff, commands.log with exits, build.log (0 warnings/errors), check.log (1553), r2/extra logs, regression-before exit 134, wiring-old-vs-new.log, new IL evidence (only SetClickable(false) caller), DLL SHA256 71ebec737f466c87800262475c94024a70c61dd3bb496229f2386ed5b2dac8bd."}
  ],
  "changedFiles": ["../STS2MCP/BridgeProtocol.cs","../STS2MCP/McpMod.Contract.cs","../STS2MCP/McpMod.LegalActions.cs","../STS2MCP/README.md","../STS2MCP/tests/check-bridge.sh"],
  "testsAddedOrUpdated": ["../STS2MCP/tests/check-bridge.sh: +131 checks (1422 -> 1553): ordered ContextHalt matrix with service-read counting, compiled IL wiring/control-flow checks, owned card-reward readiness sequence through production gate/FinishObservation/AcceptChild incl. partial, alternative-only and missing-metadata cases"],
  "commandsRun": [
    {"command":"mise exec -- dotnet IlProbe/FindCallers (metadata-only) on installed sts2.dll","result":"passed","summary":"_isClickable defaults true; only false setter is DisableCardsForShortTimeAfterOpening"},
    {"command":"check-bridge.sh (final) vs /tmp/jev-m2-cancelasync/release/STS2_MCP.dll","result":"failed","summary":"Intended exit 134: old DLL lacks ordered context gate (menu NRE witness)"},
    {"command":"dotnet build ../STS2MCP/STS2_MCP.csproj --no-restore -t:Rebuild -c Release -o /tmp/jev-m2-live-readiness/release -p:STS2GameDir=... -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false","result":"passed","summary":"Exit 0, 0 warnings, 0 errors"},
    {"command":"check-bridge.sh /tmp/jev-m2-live-readiness/release/STS2_MCP.dll <sts2.dll>","result":"passed","summary":"Exit 0; PASS: 1553 actual-DLL checks (one fixture fix after an initial KeyNotFound in the new test)"},
    {"command":"dotnet run /tmp/jev-m2-relic-review/extra and /tmp/jev-m2-ordinary-review/extra vs new DLL","result":"passed","summary":"R2 16 and O1 60 independent checks, exit 0"},
    {"command":"python3 /tmp/jev-m2-live-readiness/freeze.py; shasum -c manifests; git diff --check; git diff --cached","result":"passed","summary":"Inventory/HEAD/index/hash audits exit 0; five-file delta confirmed"}
  ],
  "validationOutput": ["PASS: 1553 actual-DLL checks; no game initialization or HTTP.","regression-before exit 134: old context gate dereferences RunManager.NetService before checking run presence","wiring-old-vs-new.log: old IsAllowedContext -> get_NetService/get_Type/IsMultiplayer; new ContextHalt -> get_IsInProgress + BridgeProtocol.ContextHalt (deferred lambda); new AddNonCombatActions -> RewardCardsInputDisabled"],
  "residualRisks": ["Godot scene branch not executed offline; readiness proven via helper + production gate/finalizer + compiled wiring only","Menu NRE had no stack trace; NetService is the grounded cause, other no-run singleton reads not excluded (would still halt safely)","Cancelled native disable wait at screen teardown yields a wait, not a halt","Live reward-to-ready transition and menu refusal not re-observed; M2 remains BLOCKED"],
  "noStagedFiles": true,
  "diffSummary": "Two BridgeProtocol helpers (ordered ContextHalt, RewardCardsInputDisabled); Contract reads context through ContextHalt with deferred NetService read; card_reward branch sets waiting and withholds all actions while any offered holder is unclickable; +131 tests; README paragraph.",
  "reviewFindings": ["no blockers; reviewer gate still required before any installation"],
  "manualNotes": "Checkpoint /tmp/jev-m2-live-readiness; DLL SHA256 71ebec737f466c87800262475c94024a70c61dd3bb496229f2386ed5b2dac8bd. Not installed. Parent's next live gate: menu GET should now halt no_active_run (not observation_unavailable); immediate card reward GET should show card_reward waiting:true with zero actions, then takes+Skip together with a fresh version and the same mutation_pending owner."
}
```
