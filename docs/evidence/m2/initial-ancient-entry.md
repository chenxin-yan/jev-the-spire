# Minimal Ancient opening entry — implementation report

Writer scope: `../STS2MCP` only (detached `55e0648`, index empty). App root, docs, `.env`, `CONTEXT.md` (`0b90a7e6…`) and `mise.toml` (`9193ec10…`) untouched (`/tmp/jev-minimal-ancient/protected-hashes.log`). Installed DLL `0cd0c0bb…` and native `9cb4f1ad…` unchanged. No game HTTP/UI/launch/install, no save/profile access, no inference, no git staging/commit/push. Candidate **not installed**; live acceptance is parent-owned. Current live floor-3 checkpoint untouched.

Candidate DLL: `/tmp/jev-minimal-ancient/release/STS2_MCP.dll` = `a7bc16d70f4fa76284d5f69d771de5bac77d5aaf08e3311fb09fb078adbf6bdc` (byte-identical on rebuild).

## What was implemented (initial opening only)

Generic extension of the existing `NEventRoom.SetupLayout` capture: when no owned map-travel entry exists (`_eventEntry` null or closed) and no ambient bridge owner is present, `BeginActOpening` binds the room **only if native lifecycle state proves the run start created it itself**. No event-name check; the Ancient model type is never referenced (harness check `BeginActOpening references no concrete event model`). Everything downstream (dialogue advance, option identity/generation/input receipts, appended-task capture, foreign input/state-change revocation, scene-exit close, replacement on next owned map move) is the unchanged existing code.

Five-file delta, 87 changed lines (`/tmp/jev-minimal-ancient/incremental.diff`):

| File | Change |
|---|---|
| `BridgeProtocol.cs` | pure predicate `FreshActOpening(numReloads, actIndex, startedWithNeow, atStartingPoint, ancientPoint, visitedCoords, preFinished, finished, actionRunning)` |
| `EventOperation.cs` | `record ActOpening(object Destination)` — stand-in for the owned `MoveToMapCoordAction` in `EventEntry.Move` |
| `McpMod.EventActions.cs` | `BeginActOpening(NEventRoom)`, `EntryDestination(EventEntry)`; `EventSetupPrefix` consults the bootstrap before its existing identity checks and otherwise behaves exactly as before |
| `tests/check-bridge.sh` | +23 checks (see Validation) |
| `README.md` | Stage 2 paragraph: opening provenance, ceilings, Proceed limitation |

### Provenance receipt (metadata-grounded, native v0.111.0 / `9cb4f1ad…`)

Fresh vs saved/restored is decided by `RunManager._numReloads` (private `Int32`, `FIELD` in `RunManager`):

- New run: `NGame.StartRun → RunManager.Launch → EnterAct(0)`; `SetUpNewSingleplayer` IL0059 `ldc.i4.0` → `InitializeShared(..., Int32)` → IL0653 `stfld _numReloads` (`initialize-shared.il`). So `_numReloads == 0`.
- Saved run: `NMainMenu.OnContinueButtonPressedAsync → SetUpSavedSingleplayer`: IL0061 `SaveManager.IncrementNumReloads(save,…)` (`save.NumReloads = save.NumReloads + 1`, `increment-reloads.il` IL0034–0043), then IL0219 `get_NumReloads` → IL0224 `InitializeShared` (`saved-setup.il`). `SetUpSavedMultiplayer` likewise (IL0096/0260). So `_numReloads ≥ 1` for every restored run, including a `LoadRun` whose serialized room is null and therefore re-rolls a fresh-looking room through `CreateRoom`.
- Opening shape: `EnterAct` IL0375–0472 (`run-start.il`): `if (currentActIndex == 0 && State.ExtraFields.StartedWithNeow) EnterMapCoord(State.Map.StartingMapPoint.coord) else EnterRoomInternal(new MapRoom())`. `EnterMapCoord` → `AddVisitedMapCoord` (first visit → `VisitedMapCoords.Count == 1`) → `EnterMapPointInternal(preFinishedRoom=null)` → `CreateRoom(Event, Ancient)` → `ActModel.PullAncient()` → `new EventRoom` → `EnterRoomInternal` → `EventRoom.EnterInternal` → `NEventRoom.Create` → `NRun.SetCurrentRoom` → `_Ready` → `SetupLayout` (`enter-map-point.il`, `eventroom.il`; `SetupLayout` sole caller is `_Ready`, `callers-run-entry.log`). No `GameAction` is involved, so `ActionExecutor.CurrentlyRunningAction == null`; any human/foreign map travel runs inside `MoveToMapCoordAction.ExecuteAction` (IL0148 `EnterMapCoord`) and is excluded by that field and by the start-coordinate requirement.
- Restored room: `LoadIntoLatestMapCoord` → `EnterMapCoordInternal(lastVisited, preFinishedRoom, false)` → `EnterRoomInternal(preFinishedRoom)` — same scene path, refused by `_numReloads`.

Runtime fields read: `RunManager._numReloads` (private), `RunState.CurrentActIndex/ExtraFields.StartedWithNeow/CurrentMapCoord/CurrentMapPoint.PointType/Map.StartingMapPoint.coord/VisitedMapCoords/CurrentRoom`, `AbstractRoom.IsPreFinished`, `EventModel.IsFinished`, `ActionExecutor.CurrentlyRunningAction`, `NEventRoom._event` (already pinned), `LocalContext.GetMe`. All public except `_numReloads` and `_event`.

Live floor-3 evidence corroborates the shape: `start-map.json` shows `current_position (3,0) type Ancient`, `visited` = one entry, floor 1.

## Clearly separated claims

1. **Initial opening support (implemented, offline-checked, not live-verified).** Fresh Neow room is bound; restored/continued, resumed, later-act, foreign-travel and any non-start rooms keep `event_setup_unowned`. Once bound, readiness/dispatch is the existing dialogue/option protocol.
2. **Reusable option handling (unchanged).** Ancient dialogue (`%DialogueHitbox` advance, synchronous option enabling) and generic option dispatch are the pre-existing code. The Ancient layout has **never been live-driven through the bridge**; only ordinary `NEventLayout` (The Legends Were True) is live-verified. Neow's options route through `OnModifierOptionSelected(Func<Task>, int)`; the existing single-callback/generation/lethal checks apply unchanged and would refuse rather than guess.
3. **Later-act openings (not implemented, not claimed).** For `actIndex > 0` the native game opens a `MapRoom` first; the act's Ancient is reached by ordinary map travel to `StartingMapPoint` (`MapPointType.Ancient`), i.e. the already-owned `DispatchMap → MoveToMapCoordAction → SetupLayout` path, so no bootstrap is needed there. Reachability depends on the boss → `ActChangeSynchronizer.MoveToNextAct → EnterNextAct` transition, which current guards refuse and which this task did not touch. Untested.

## Blocker discovered (not patched): Neow's Proceed → first map

`NEventRoom.Proceed` = `NMapScreen.SetTravelEnabled(true); NMapScreen.Open(true)` (`neventroom.il`). `Open` IL0180–0313 (`map-open.il`) takes the start-of-act branch exactly when `(actIndex == 0 && StartedWithNeow ? ActFloor == 1 : ActFloor == 0) && !_hasPlayedAnimation`: it detaches `StartOfActAnim().RunSafely()` (tween + `InitMapPrompt` → `MapFtueCheck` tail) or adds `NActBanner`. At Neow `ActFloor == 1` (row 0 + 1; live `start-map.json` floor 1). The existing deliberate guard `McpMod.OrdinaryActions.RequireOrdinaryMap` (`startsAct`, `_actAnimTween`) — used by `RequireEventOption` for `IsProceed` and by the Proceed completion predicate — therefore refuses Neow's finished-page Proceed with `ordinary_map_readiness_unverified`, invalidating that whole observation (Proceed is the only alternative on the finished page). Jev's three-option choice itself is unaffected; the Proceed would need a human click (which then revokes the entry via `foreign_event_input`, harmlessly, and the next owned map move replaces it).

Smallest missing authorization: accept the finished-event Proceed on the act-start map branch. Candidate receipt without a new Harmony target: existing `NMapScreen.Opened` signal (already captured) + wait for `_hasPlayedAnimation == true` and `_actAnimTween == null` + seen `map_select_ftue` (already required) before exposing map choices. Whether the detached `StartOfActAnim` tail (`InitMapPrompt`/`MapFtueCheck`) can be treated as cosmetic-with-tutorial-guard is a parent/owner decision; I did not enable it.

## Validation

All commands in `/tmp/jev-minimal-ancient/commands.log`; every Bun-free (.NET only), no dotenv involved.

- Build (frozen recipe, isolated obj, `ImportDirectoryBuild*=false`, `--no-restore`): exit 0, 0 warnings/errors; rebuild byte-identical `a7bc16d7…`.
- **Retained regressions:** unchanged frozen harness vs new DLL → PASS 1842 (`check-old-harness.log`).
- **RED:** updated harness vs installed baseline `0cd0c0bb…` → exit 134 `missing compiled production method BeginActOpening` (`regression-before.log`).
- **GREEN:** updated harness vs new DLL → PASS 1865 (`check.log`). New checks: `FreshActOpening` truth table (fresh accepted; reloaded / later act / no-Neow / non-start / non-Ancient / revisit / unvisited / prefinished / finished / foreign-travel each refused); `EntryDestination` null for stand-ins without an exact `MapCoord` and exact for an `ActOpening` (one default value struct, no game state); native IL wiring: `SetUpSavedSingleplayer`/`SetUpSavedMultiplayer` call `IncrementNumReloads` before `InitializeShared`, `EnterAct` has the `StartedWithNeow`/`StartingMapPoint`/`EnterMapCoord` vs `EnterRoomInternal` branches, `LoadIntoLatestMapCoord` bypasses `EnterAct`; `_numReloads` int field / `InitializeShared` last param int / `StartedWithNeow`, `IsPreFinished`, `MapPointType.Ancient == 8` ABI; `BeginActOpening` reads reload count, executor idleness, Neow branch, starting point, visited count, room/model state, local player and grants no `Track/HoldUntil/ForceClick`; `EventSetupPrefix` wires `BeginActOpening`/`EntryDestination`/ambient owner; no `Launch/EnterAct/EnterMapCoord/EnterRoomInternal` Harmony targets and no `RunStarted/ActEntered/RoomEntered` subscriptions anywhere in the bridge; `BeginActOpening` in the no-concrete-event-model set.
- Independent retained suites vs new DLL, all exit 0: late-cleanup reviewer 93/0 RED, readiness 50, O1 60, R2 16, cancel-positive 1266, owned-teardown repro red=0. Known O2 unsupported case still 74/2 (not a pass, unchanged).

Freeze: `/tmp/jev-minimal-ancient/{source/ (19-file git inventory), build-inputs/ (compiler inputs), source-sha256.log, build-inputs-sha256.log, incremental.diff, tracked.diff, git-head/index/status logs, final-hashes.log, protected-hashes.log, *.il, callers-*.log, probe/ (metadata-only Callers.cs)}`.

## Live limits / risks

- Live check requires a **new run start** on modded profile 2 (human Embark; run-start automation unauthorized) — that replaces the current floor-3 checkpoint. Not done; parent decision.
- `CurrentlyRunningAction == null` at fresh `SetupLayout` and AsyncLocal propagation through `SetupLayout`'s `await Cmd.Wait` continuation are IL-grounded, not live-verified; a false negative yields the safe `event_setup_unowned`, not adoption.
- Ancient dialogue/option receipts untested live through the bridge (see claim 2). Neow modifier/curse option callbacks untested; multicast callbacks would be refused.
- Neow Proceed refused by the existing start-of-act map guard (see Blocker). Later-act reachability unchanged/untested.
- A stale open entry from an earlier room in the same process is not replaced unless closed; scene exit closes it, so this only matters if a scene leaves without `TreeExiting`.

## Acceptance report

```acceptance-report
{
  "criteriaSatisfied": [
    {"id": "criterion-1", "status": "satisfied", "evidence": "Five-file, 87-line delta in ../STS2MCP only: FreshActOpening predicate, ActOpening record, BeginActOpening/EntryDestination and a two-line EventSetupPrefix consult; no new Harmony targets, observers, routes, selector authority or act-transition changes (harness checks enforce). Proceed/act-transition blockers reported, not patched."},
    {"id": "criterion-2", "status": "satisfied", "evidence": "/tmp/jev-minimal-ancient frozen: source/, build-inputs/, hashes, incremental.diff, commands.log, build/check/regression/independent logs+exits, IL excerpts (run-start.il, saved-setup.il, increment-reloads.il, initialize-shared.il, enter-map-point.il, eventroom.il, setup-layout.il, neventroom.il, map-open.il), callers logs; RED 134 vs baseline 0cd0c0bb, GREEN 1865 vs a7bc16d7."}
  ],
  "changedFiles": ["../STS2MCP/BridgeProtocol.cs", "../STS2MCP/EventOperation.cs", "../STS2MCP/McpMod.EventActions.cs", "../STS2MCP/tests/check-bridge.sh", "../STS2MCP/README.md"],
  "testsAddedOrUpdated": ["../STS2MCP/tests/check-bridge.sh (+23 checks: FreshActOpening truth table, EntryDestination, native reload/EnterAct/LoadIntoLatestMapCoord IL wiring, BeginActOpening/EventSetupPrefix wiring, no new hooks/observers)"],
  "commandsRun": [
    {"command": "mise exec -- dotnet build ../STS2MCP/STS2_MCP.csproj --no-restore -t:Rebuild -c Release -o /tmp/jev-minimal-ancient/release ... -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false", "result": "passed", "summary": "0 warnings/0 errors; rebuild byte-identical a7bc16d7…"},
    {"command": "mise exec -- bash ../STS2MCP/tests/check-bridge.sh (frozen harness) /tmp/jev-minimal-ancient/release/STS2_MCP.dll sts2.dll", "result": "passed", "summary": "PASS 1842 retained checks"},
    {"command": "mise exec -- bash ../STS2MCP/tests/check-bridge.sh (updated) /tmp/jev-m2-generic-events/release/STS2_MCP.dll sts2.dll", "result": "failed", "summary": "RED as expected: exit 134 missing BeginActOpening on installed baseline 0cd0c0bb"},
    {"command": "mise exec -- bash ../STS2MCP/tests/check-bridge.sh (updated) /tmp/jev-minimal-ancient/release/STS2_MCP.dll sts2.dll", "result": "passed", "summary": "PASS 1865 checks"},
    {"command": "retained independent Check.dll/Repro.dll suites (late-cleanup, readiness, O1, R2, cancel-positive, owned-teardown) vs new DLL", "result": "passed", "summary": "93/0, 50, 60, 16, 1266, red=0; O2 known-unsupported 74/2 unchanged (not a pass)"},
    {"command": "metadata-only probes: ApiProbe/IlProbe/Callers.dll on sts2.dll", "result": "passed", "summary": "IL excerpts and call edges frozen under /tmp/jev-minimal-ancient"}
  ],
  "validationOutput": ["build.exit=0", "check-old-harness: PASS 1842", "regression-before.exit=134 (missing compiled production method BeginActOpening)", "check: PASS 1865", "independent-after 93/0 RED; readiness 50; o1 60; r2 16; cancel-positive 1266; writer-repro red=0; unsupported-o2 74/2 (known)", "protected CONTEXT.md/mise.toml hashes match; installed 0cd0c0bb and native 9cb4f1ad unchanged"],
  "residualRisks": [
    "Neow finished-page Proceed opens the map through the start-of-act branch (StartOfActAnim/NActBanner, MapFtueCheck tail) which the existing startsAct guard refuses; Proceed stays a human step until separately authorized.",
    "Ancient dialogue/option path and Neow modifier-option callbacks never live-driven through the bridge; CurrentlyRunningAction==null and AsyncLocal propagation at fresh SetupLayout are IL-grounded only (false negative = safe event_setup_unowned).",
    "Later-act openings are ordinary owned map travel but unreachable while boss/act transition guards refuse; not tested or claimed.",
    "Live check needs a new profile-2 run start, replacing the current floor-3 checkpoint; not performed."
  ],
  "noStagedFiles": true,
  "diffSummary": "Bridge: FreshActOpening predicate (BridgeProtocol), ActOpening record (EventOperation), BeginActOpening/EntryDestination + EventSetupPrefix consult (EventActions); harness +23 checks; README Stage 2 note.",
  "reviewFindings": ["no blockers in the delta; blocker outside scope: Neow Proceed refused by existing start-of-act map guard (McpMod.OrdinaryActions.cs:59, BridgeProtocol.RequireOrdinaryMap)"],
  "manualNotes": "Candidate a7bc16d7 not installed. Metadata-only research; one default MapCoord value struct constructed in the harness (no game state/Godot). Probe helper /tmp/jev-minimal-ancient/probe/Callers.cs is scratch, not in repo."
}
```
