# Finished-Neow Proceed → initial map: narrow exception — implementation report

Writer scope: `../STS2MCP` only (detached `55e0648`, index empty before/after). App repo untouched (`CONTEXT.md` `0b90a7e6…`, `mise.toml` current owner-changed Bun+dotnet `2fd8e784…`, both identical before/after; `.env` never read/hashed). No Bun invoked. No game HTTP/UI/launch/install/control, no save/profile/settings access, no inference, no staging/commit/push. Installed DLL `0cd0c0bb…` and native `9cb4f1ad…` unchanged. Candidate **not installed**; live acceptance is parent/owner-owned.

Candidate DLL: `/tmp/jev-neow-proceed/release/STS2_MCP.dll` = **`d627dc6d47771d90fe2a8341f88f36e05024944416a55a481a2d6db051eaa61c`** (byte-identical on rebuild). Previous candidate `a7bc16d7…` was the byte-verified starting point (all 19 inventory files matched `/tmp/jev-minimal-ancient/source`).

## Caller trace (done before editing)

`McpMod.RequireOrdinaryMap` (`McpMod.OrdinaryActions.cs:57`) is the only place `startsAct`/`_actAnimTween` are refused. Its callers: `RequireEventOption` IsProceed admission (`EventActions.cs:161`), `DispatchEventOption` Opened postcondition (`:252`), `AddOrdinaryProceed` (merchant/rest, `OrdinaryActions.cs:74/88/89`), treasure (`TreasureActions.cs:173/209/277/308`) and reward hooks (`RewardHooks.cs:187/229`). **Initial-map listing and dispatch never consult it:** `CaptureObservationCore` (`Contract.cs:127–142`) lists `Travelable` + `IsReadableCanvas` points when `state_type == "map"` and `!busy`; `DispatchMap` (`NativeActions.cs:68`) closes `_eventEntry` and calls native `OnMapPointSelectedLocally`, which enqueues the vote without reading `_actAnimTween`/`_canInterruptAnim`/`_isInputDisabled` (`map-input.il`, re-verified by harness call edges). So after an admitted Proceed the existing owned `choose_map_node` route is reached with no further guard change; no unrelated `startsAct` guard was broadened.

## Change (5 files, 73 changed lines, `/tmp/jev-neow-proceed/incremental.diff`; 3 compiler inputs differ)

| File | Change |
|---|---|
| `BridgeProtocol.cs` | new pure predicate `InitialOpeningProceed(ownedActOpening, actIndex, startedWithNeow, actFloor)` = `owned && actIndex == 0 && startedWithNeow && actFloor == 1`, with the native grounding comment. Shared 4-arg `RequireOrdinaryMap` **unchanged**. |
| `McpMod.OrdinaryActions.cs` | `RequireOrdinaryMap(run, map, requireTravel = true, ownedActOpening = false)`: computes `cosmeticStart = InitialOpeningProceed(...)` and passes `startsAct && !cosmeticStart`, `_actAnimTween != null && !cosmeticStart` to the shared guard. Tutorial read (`SeenFtue("map_select_ftue")` → `RequireOrdinaryTutorial`), `_isInputDisabled`, `IsTraveling`, `_runState` identity and `IsTravelEnabled` checks unchanged and still run for the exception. |
| `McpMod.EventActions.cs` | the two Proceed call sites pass `entry.Move is ActOpening` (admission `requireTravel:false`; Opened postcondition `requireTravel:true`). Derived inline from the bound entry inside the closure — not from map/animation state. |
| `tests/check-bridge.sh` | +44 checks (below) |
| `README.md` | Stage 2 paragraph: replaces "Proceed remains a human step" with the exact exception, receipts retained, and the accepted residual. |

`entry.Move is ActOpening` is true only for an entry created by `BeginActOpening` (which required `FreshActOpening`: `_numReloads == 0`, act 0, `StartedWithNeow`, start coordinate, `Ancient`, single visit, unfinished, no running `GameAction`); `RequireEventIdentity` then re-verifies run/room/scene/model/layout/player identity at admission and completion. The predicate re-reads act/Neow/`ActFloor` at Proceed time, so a map that is not the act-0/Neow/floor-1 map is never exempt even with an `ActOpening` entry.

### What is and is not claimed

- **Admitted:** the owned fresh opening's finished-page Proceed. Receipts: unchanged `RequireEventOption` IsProceed checks (finished model, static `NEventRoom.Proceed` single delegate, generation, input, lethal, `BeforeChosen`), exact `EventOption.Chosen` root task via existing `EventChosenPostfix`, synchronous `NMapScreen.Opened` receipt (fires after `RecalculateTravelability`), `IsOpen`, `IsTravelEnabled`, `!_isInputDisabled`, `!IsTraveling`, same `_runState`, entry-time seen `map_select_ftue`. `HoldUntil(operation.Poll() && map.IsOpen)` unchanged.
- **Not claimed:** any completion of `StartOfActAnim`/`NActBanner`. Not hooked, not awaited, `_hasPlayedAnimation` not read anywhere on the path (harness enforces). Both FastMode branches (animation vs banner-only) are covered by the same argument; no profile/settings read.
- **Still refused (unchanged):** merchant/rest/treasure/reward proceeds on any start-of-act map, later-act openings (`actIndex != 0` or `NMapRoom` path), restored/continued rooms (`_numReloads ≥ 1` → no `ActOpening`), foreign-travel rooms, unseen tutorial (`ordinary_tutorial_unverified:map_select_ftue` still thrown first), input-disabled/traveling maps. Shared 4-arg guard truth table retained verbatim.
- **No new Harmony target**, no tutorial acknowledgement/flag write, no `ResetFtues`, no event model/name allowlist (existing "no concrete event model" set still passes).

## Validation (`/tmp/jev-neow-proceed/commands.log`; all .NET only, no Bun, no dotenv)

- Build (frozen isolated recipe from `/tmp/jev-minimal-demo-review/commands.txt`: `--no-restore -t:Rebuild`, imports disabled, `PathMap`, seeded restore assets): exit 0, 0 warnings/errors; rebuild byte-identical `d627dc6d…`.
- **Retained:** unchanged a7bc16d7 harness vs new DLL → PASS **1865** (`check-old-harness.log`); frozen pre-opening harness → PASS **1842** (`check-frozen-generic.log`).
- **RED:** updated harness vs previous candidate `a7bc16d7` → exit 134 `missing compiled production method InitialOpeningProceed: finished-Neow Proceed still refused by the start-of-act map guard` (`regression-before.log`).
- **GREEN:** updated harness vs new DLL → PASS **1909** (`check.log`). New checks: `InitialOpeningProceed` 24-cell truth table (owned × act × Neow × floor 0/1/2; only owned/act0/Neow/floor1 exempt); bridge guard's 4th parameter is `bool` defaulting to `false`; guard still calls `RequireOrdinaryTutorial`/`SeenFtue`/protocol `RequireOrdinaryMap`/`get_ActFloor`/`get_StartedWithNeow`/`get_IsTraveling` and reads `map_select_ftue`/`_isInputDisabled`/`_actAnimTween`/`_runState` but never `_hasPlayedAnimation`; every compiled caller of the bridge guard (methods + closures) enumerated — event Proceed admission/completion and ≥3 non-event proceeds all route through it, and **only** `RequireEventOption` and the `<DispatchEventOption>` closure reference the `ActOpening` stand-in; hook installer contains none of `Open/Proceed/PlayStartOfActAnimation/StartOfActAnim/InitMapPrompt/MapFtueCheck/MarkFtueAsComplete`, and no bridge method calls `MarkFtueAsComplete/ResetFtues/PlayStartOfActAnimation/StartOfActAnim/InitMapPrompt/MapFtueCheck`; pinned native call edges: `NEventRoom.Proceed` → `SetTravelEnabled`+`Open`+`CompletedTask`; `NMapScreen.Open` → `get_ActFloor`/`get_StartedWithNeow`/`PlayStartOfActAnimation`/`RecalculateTravelability`/`EmitSignalOpened`; `<StartOfActAnim>` → `AwaitFinished`+`InitMapPrompt`; `InitMapPrompt` → `SeenFtue`; `<MapFtueCheck>` → `MarkFtueAsComplete`; `PlayStartOfActAnimation` does not call `InitMapPrompt`; `OnMapPointSelectedLocally` → `RequestEnqueue` and no `TryCancelStartOfActAnim`/`DisableInputVeryBriefly`.
- Retained independent suites vs new DLL, all exit 0: late-cleanup 93/0 RED, readiness 50, O1 60, R2 16, cancel-positive 1266, owned-teardown red=0. Known unsupported O2 temporal case 74/2 unchanged (not a pass).
- Two harness-only fixes during development (C# local name clash; generic-definition filter in the new all-callers enumeration) — full failure output read each time; no production fix iterations.

Freeze: `/tmp/jev-neow-proceed/{baseline/ (a7bc16d7 19-file source), source/ (new 19-file inventory), build-inputs/ (26 .cs + csproj), source-before-sha256.log, source-sha256.log, build-inputs-sha256.log, build-inputs-delta.log, incremental.diff, tracked.diff, git-head/index-before/index-after/status-before/status-after logs, protected-hashes-before/after.log, final-hashes.log, build*.log/exit, check*.log/exit, regression-before.log/exit, independent logs/exits, commands.log}`. No `/tmp` recursion, no new IL probes (reused `/tmp/jev-minimal-initial-map/*.il` read-only). VBCSCompiler/MSBuild servers shut down afterwards.

## Separately flagged: map listing during the Open fade (not fixed)

`CaptureObservationCore` filters points with `IsReadableCanvas`. `NMapScreen.Open` sets `_points` **container** modulate to 0 and tweens it up over 0.25 s (`map-open.il` IL0547–0579, IL1102–1136). Because the alpha is container-level, the listed set is **whole or empty, never partial** — so no pruned/partial legal set arises. But a GET inside that window yields `state_type: "map"`, `waiting: false`, `legal_actions_complete: true` and **zero** actions. This is preexisting for every `Open` (merchant/rest/reward proceeds too), not introduced here, and I did not adopt the research's "fewer is fail-safe" framing: an empty-but-complete set is a real observation gap the app loop must not treat as a decision. Recommend the parent check how the CLI handles a complete empty legal set (halt vs. re-observe) before the live gate; no native change made for it.

## Live limits / risks

- Human "reset tutorials" (`NSettingsScreenPopup.OnYesButtonPressed` → `ResetFtues`) after admission would re-arm `MapFtueCheck` on the detached tail; accepted residual per owner ("no tutorial reset during demo"), same class as foreign input.
- If a human opens the map via the map button before Proceed, `_hasPlayedAnimation` becomes true and Proceed's `Open(false)` takes the plain path; the exception still admits it (startsAct is still true by floor), which is strictly safer. Not live-tested.
- Profile-2 `FastMode` unknown offline; both branches characterized, neither read.
- Godot signal delivery, AsyncLocal propagation, Ancient dialogue/option receipts and the whole opening → map path remain untested live; live check needs a new profile-2 run start (replaces the floor-3 checkpoint) — parent decision.
- Later-act/boss transitions untouched and still refused.

```acceptance-report
{
  "criteriaSatisfied": [
    {"id": "criterion-1", "status": "satisfied", "evidence": "5-file, 73-line delta in ../STS2MCP only (3 compiler inputs): pure InitialOpeningProceed predicate, default-false opt-in on the bridge map guard, two event Proceed call sites pass entry.Move is ActOpening; shared 4-arg BridgeProtocol.RequireOrdinaryMap unchanged; no new Harmony target, no tutorial write, no later-act/merchant/rest/reward expansion, no allowlist (harness enforces each). Initial-map listing/dispatch traced and left unchanged."},
    {"id": "criterion-2", "status": "satisfied", "evidence": "/tmp/jev-neow-proceed frozen: baseline/, source/, build-inputs/, hashes, incremental.diff, commands.log, all logs/exits. RED exit 134 vs a7bc16d7 (missing InitialOpeningProceed); GREEN 1909 vs d627dc6d; retained 1865 and 1842; independent 93/0, 50, 60, 16, 1266, red=0; O2 74/2 unchanged. Both git indexes empty; protected hashes unchanged."}
  ],
  "changedFiles": ["../STS2MCP/BridgeProtocol.cs", "../STS2MCP/McpMod.OrdinaryActions.cs", "../STS2MCP/McpMod.EventActions.cs", "../STS2MCP/tests/check-bridge.sh", "../STS2MCP/README.md"],
  "testsAddedOrUpdated": ["../STS2MCP/tests/check-bridge.sh (+44 checks: InitialOpeningProceed truth table, default-false opt-in, guard wiring without _hasPlayedAnimation, exhaustive bridge-guard caller enumeration with ActOpening only on the event Proceed path, no map/animation hook or FTUE write anywhere, pinned native Proceed/Open/StartOfActAnim/InitMapPrompt/MapFtueCheck/OnMapPointSelectedLocally call edges); existing 4-arg RequireOrdinaryMap truth table retained verbatim"],
  "commandsRun": [
    {"command": "mise exec -- dotnet build ../STS2MCP/STS2_MCP.csproj --no-restore -t:Rebuild -c Release -o /tmp/jev-neow-proceed/release ... -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false -p:PathMap=...", "result": "passed", "summary": "exit 0, 0 warnings/errors; rebuild byte-identical d627dc6d47771d90fe2a8341f88f36e05024944416a55a481a2d6db051eaa61c"},
    {"command": "mise exec -- bash /tmp/jev-neow-proceed/baseline/tests/check-bridge.sh <new DLL> sts2.dll", "result": "passed", "summary": "retained a7bc16d7 harness PASS 1865"},
    {"command": "mise exec -- bash /tmp/jev-m2-generic-events/source/tests/check-bridge.sh <new DLL> sts2.dll", "result": "passed", "summary": "retained frozen harness PASS 1842"},
    {"command": "mise exec -- bash ../STS2MCP/tests/check-bridge.sh /tmp/jev-minimal-ancient/release/STS2_MCP.dll sts2.dll", "result": "failed", "summary": "RED as intended: exit 134 missing compiled production method InitialOpeningProceed"},
    {"command": "mise exec -- bash ../STS2MCP/tests/check-bridge.sh /tmp/jev-neow-proceed/release/STS2_MCP.dll sts2.dll", "result": "passed", "summary": "GREEN PASS 1909"},
    {"command": "retained independent Check.dll/Repro.dll suites (late-cleanup, readiness, O1, R2, cancel-positive, owned-teardown) vs new DLL", "result": "passed", "summary": "93/0 RED, 50, 60, 16, 1266, red=0"},
    {"command": "mise exec -- dotnet /tmp/jev-m2-cancelasync-review/targeted/bin/Debug/net9.0/Check.dll <new DLL> sts2.dll temporal", "result": "failed", "summary": "known unsupported O2: 74 checks / 2 failures, unchanged, not a pass"},
    {"command": "git -C ../STS2MCP diff --cached --name-only; git diff --cached --name-only; shasum -a 256 CONTEXT.md mise.toml", "result": "passed", "summary": "both indexes empty; protected hashes unchanged before/after"}
  ],
  "validationOutput": ["build.exit=0; build-rebuild byte-identical", "check-old-harness PASS 1865; check-frozen-generic PASS 1842", "regression-before.exit=134 (missing InitialOpeningProceed)", "check PASS 1909", "independent: 93/0, 50, 60, 16, 1266, red=0; unsupported-o2 74/2 (known)", "incremental.diff 5 files / 73 lines; build-inputs delta 3 files", "CONTEXT.md 0b90a7e6… and mise.toml 2fd8e784… unchanged; installed 0cd0c0bb… and native 9cb4f1ad… unchanged"],
  "residualRisks": [
    "Human reset-tutorials mid-demo re-arms MapFtueCheck on the detached tail (owner-accepted residual; not detectable offline).",
    "Preexisting: a GET during the 0.25 s _points fade after any Open returns a complete-but-empty map legal set (whole-or-empty, not partial); app loop handling should be confirmed before the live gate. Not changed here.",
    "Godot signal delivery/AsyncLocal propagation, Ancient dialogue/option receipts, FastMode branch and the full opening→map path untested live; live check needs a new profile-2 run start.",
    "Later-act/boss transitions remain refused and untested."
  ],
  "noStagedFiles": true,
  "diffSummary": "BridgeProtocol.InitialOpeningProceed predicate; McpMod.RequireOrdinaryMap gains default-false ownedActOpening that masks startsAct/_actAnimTween only for the act-0/Neow/floor-1 owned ActOpening; RequireEventOption and DispatchEventOption Opened postcondition pass entry.Move is ActOpening; harness +44 checks; README Stage 2 note.",
  "reviewFindings": ["no blockers in the delta", "flagged separately (not fixed): preexisting complete-but-empty map legal set during the Open fade window, Contract.cs:131-133 IsReadableCanvas on container-level alpha"],
  "manualNotes": "Candidate d627dc6d NOT installed. No Bun run; no game/profile/settings/.env access; compiler servers shut down. Scratch harness-only fixes: renamed a clashing loop variable and excluded generic definitions from the new caller enumeration."
}
```
