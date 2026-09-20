# Neow finished-page Proceed → initial map: completion/authority facts

Read-only IL/metadata investigation of pinned `sts2.dll` `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`. No repo edits (native index clean, 19 preexisting working-tree files untouched), no game HTTP/UI/install, no save/profile/settings access, no native construction or invocation. Evidence: `/tmp/jev-minimal-initial-map/` (`commands.log`, `*.il`, `callers.log`, `field-writers.log`). This is investigation, not authorization; the boss/later-act `EnterNextAct`/`NMapRoom` path is out of scope and only mentioned to keep it separate.

**Correction accepted:** `NEventRoom.Proceed` = `SetTravelEnabled(true)` (IL0005–0006), **`Open(false)`** (IL0016 `ldc.i4.0`, IL0017), returns `Task.CompletedTask` (IL0023). My earlier "Open(true)" was wrong; the correction strengthens the blocker (see §1).

## 1. Exact branch taken on the first Neow Proceed

`NMapScreen.Open(bool skipAnim)` (`map-open.il`):

- IL0179–0240 `startsAct = (CurrentActIndex == 0 && StartedWithNeow) ? ActFloor == 1 : ActFloor == 0`. At the Neow room `ActFloor == 1` (row 0 + 1; live `start-map.json` floor 1) → true.
- IL0247–0253: only if `!_hasPlayedAnimation`. `_hasPlayedAnimation` is set false by `SetMap` IL0062 (act map build) and true only by `Open` IL0320 / `PlayStartOfActAnimation` IL0022 (`field-writers.log`); no `Open` precedes the Neow room on this map, so it is false.
- IL0258 `ldarg.1; brtrue.s 302`: argument **false** does *not* skip. IL0261–0277: if `PrefsSave.FastMode < 2` → animate (loc2 = 1). Else IL0279–0297: animate iff `!SeenFtue("map_select_ftue")`.
- IL0304–0313 → `PlayStartOfActAnimation()`; else IL0318–0433 banner-only path (`_hasPlayedAnimation = true`, container y = −600, `NActBanner` added, **no task**).

So with normal (non-fastest) FastMode the **animation path is unconditional** on this Proceed, regardless of the FTUE flag. Only fastest FastMode + seen FTUE yields the taskless banner path. The bridge cannot pick the branch; it can only characterize both.

## 2. Full descendant inventory of `Proceed`

Synchronous, inside the click (`proceed.il`, `map-open.il`):

1. `SetTravelEnabled(true)`: `Hook.ShouldProceedToNextMapPoint(_runState)` → `IsTravelEnabled`, `RefreshAllPointVisuals()`.
2. `Open(false)`: `IsOpen = true`, visible, back button (ActFloor > 0), `ProcessMode`, top-bar oscillation, `CombatManager.Pause()` (singleplayer), branch (§1), then common tail: `_tween` fades (0.25 s; `_points`/`_backstop`/`_mapLegend`/`_drawingTools` modulate set to 0 at IL0546–0649 and tweened up), **`RecalculateTravelability()` IL1157** (sets every `NMapPoint.State`), marker, SFX, `ActiveScreenContext.Update()`, **`EmitSignalOpened()` IL1383**, focus.
3. `PlayStartOfActAnimation()` (`map-open.il`): `_hasPlayedAnimation = true` (IL0022); `NActBanner.Create` + `AddChildSafely` (IL0049–0077); `StartOfActAnim().RunSafely()` with the Task **dropped** (IL0083–0093 `pop`). Nothing stores that Task.

Detached (`<StartOfActAnim>d__112`): `_mapContainer.Position = (0, 1800)` (IL0041); kill any old `_actAnimTween`; create `_actAnimTween` (IL0065–0076) = interval `_mapAnimStartDelay` → `position:y` → −600 over `_mapAnimDuration` → callback `SetInterruptable` (`_canInterruptAnim = true`) at 0.25·duration; `_targetDragPos = (0,−600)`; `await TweenHelper.AwaitFinished(_actAnimTween, this)` (IL0250). Result true → `_actAnimTween = null` (IL0348), **`InitMapPrompt()` (IL0354)**. Result false → return (IL0344), nothing else.

`InitMapPrompt` (IL0000–0037): `if (TestMode.IsOn || SaveManager.SeenFtue("map_select_ftue")) return;` (IL0007–0024) else `MapFtueCheck().RunSafely()`.

`<MapFtueCheck>d__114`: `Task.Delay(100)`, `NMapSelectFtue.Create(_startingPointNode)`, `NModalContainer.Add(modal, true)` (IL0128–0135), `MarkFtueAsComplete("map_select_ftue")` (IL0150, writes progress save), `await WaitForPlayerToConfirm()`. **This is the only game-state/input descendant of the whole Proceed tail.**

`NActBanner` (`actbanner.il`): `_Ready` fills two labels and starts `AnimateVfx().RunSafely()`: modulate/position tweens, reads `FastMode` for interval, `AwaitFinished`, `QueueFreeSafely(this)`. No input handling, no save, no hooks, no game-state reads beyond `ActModel.Title`. Purely cosmetic.

## 3. What each signal/task proves

- **`Opened` (IL1383, synchronous inside the click).** Proves `Open` ran past the branch: `RecalculateTravelability` done, `IsOpen == true`, `_hasPlayedAnimation == true`, and on the animation path `_actAnimTween` already assigned (StartOfActAnim runs synchronously to its first await at IL0255–0297, after IL0076). The existing `CaptureSynchronousSignal` receipt already captures this exact signal for event Proceed (`McpMod.EventActions.cs:245–252`).
- **`EventOption.Chosen` root task** (existing `EventChosenPostfix`): awaits `BeforeChosen` + `NEventRoom.Proceed` = `CompletedTask`. Proves the finished-event side only.
- **`Proceed`'s returned Task**: `CompletedTask` — proves nothing about the map. Hooking it would add no information.
- **`StartOfActAnim`'s Task (would need a new Harmony target on `PlayStartOfActAnimation`/`StartOfActAnim`)**: `TweenHelper.AwaitFinishedInternal` (`tweenhelper.il`) resolves **true only on `Tween.Finished`** (IL0080–0091 subscribe; `OnFinished` `TrySetResult(true)`) and **false only on owner `TreeExiting`** (IL0103–0114; `OnExiting` `TrySetResult(false)`), with an immediate true if the tween is not running at subscribe time (IL0120–0146). A `Tween.Kill()` emits no `Finished`. `TryCancelStartOfActAnim` (human drag/scroll/controller input after `_canInterruptAnim`, callers `ProcessMouseEvent` IL0149, `ProcessScrollEvent` IL0068, `ProcessControllerEvent` IL0057/0121) does exactly `Kill()`, `_actAnimTween = null`, `_canInterruptAnim = false`, `DisableInputVeryBriefly().RunSafely()` (IL0016–0086). Therefore on any human interruption the `StartOfActAnim` Task **never completes** while the map screen stays in the tree (the map screen is `NGlobalUi.MapScreen`, a run-lifetime singleton; `Close` does not touch `_actAnimTween`, `map-close-setmap.il`). **That Task is not a valid completion receipt**: waiting on it can hang for the whole run without any fault. This is the decisive reason a new hook is the wrong tool, independent of authorization.
- **`_actAnimTween == null` / `_hasPlayedAnimation` / visibility**: not completion evidence (agreed); `_actAnimTween` is also nulled by the interrupt path, and stays stale-non-null on the false branch.

## 4. Does entry-time seen FTUE account for every descendant? Yes, by branch exclusion at the read site

`SeenFtue(name)` = `!Progress.EnableFtues || Progress.FtueCompleted.Contains(name)` (`progress-ftue.il` IL0001–0027). Writers that could turn a true result false: only `ProgressSaveManager.ResetFtues` (← `SaveManager.ResetFtues` ← **`NSettingsScreenPopup.OnYesButtonPressed`** only) and `SetFtuesEnabled(true)` (no caller passes true: `NAcceptTutorialsFtue.NoTutorials` passes false; `AutoSlayer` is debug) — `callers.log`. `MarkFtueAsComplete` only adds. So within a bridge session the flag is monotone unless a human uses the settings "reset tutorials" confirmation.

Both post-`Opened` routes that could reach `MapFtueCheck` pass through `InitMapPrompt` IL0007–0024, which re-reads the flag at that moment: natural tween finish (`StartOfActAnim` IL0354) and human interrupt (`DisableInputVeryBriefly` IL0141 after a 200 ms input disable). With the flag already true at admission, both return at IL0024. This is **not** "a later seen flag heals a detached FTUE path": no FTUE task is ever created; the entry-time value is the value read later because nothing but human settings UI can lower it. The existing `RequireOrdinaryTutorial(SeenFtue("map_select_ftue"))` in `McpMod.OrdinaryActions.cs:61` is exactly that admission read.

Everything else in the tail is cosmetic: `_mapContainer` slide, banner fades, `_canInterruptAnim`, `_isInputDisabled` toggled for 200 ms only on human interrupt. Faults in these `RunSafely` tasks go to `TaskHelper.LogTaskExceptions` (`runsafely.il`) and propagate nowhere; the `false` (TreeExiting) branch only skips `InitMapPrompt`. No cancellation tokens are involved.

## 5. Consequences for the bridge's *next* decision (map choice)

`DispatchMap` calls `NMapScreen.OnMapPointSelectedLocally(point)` (`map-input.il` IL0000–0275): it reads votes, builds `MapLocation`/`MapVote` and `RequestEnqueue(VoteForMapCoordAction)`. It reads **none** of `_actAnimTween`, `_canInterruptAnim`, `_isInputDisabled`; those gate only human `CanScroll`/drag (`map-input2.il`). Point `State == Travelable` was set synchronously by `RecalculateTravelability` before `Opened`. `SetTravelEnabled(true)` ran first. So a vote dispatched during the slide is native-valid; the ongoing `_actAnimTween` then finishes on the (closed) global map screen → `InitMapPrompt` → seen → return.

Existing bridge listing (`McpMod.Contract.cs:131–133`) filters points by `IsReadableCanvas` (modulate alpha), so during the common 0.1–0.35 s `_points` fade the map observation may list fewer/zero points — a preexisting property of **every** `Open`, not new to Neow, and fail-safe (never a wrong dispatch). Live `start-map.json` shows the first map exposing three `choose_map_node` after the human Proceed.

## 6. Minimal safe path (facts, not authorization)

1. **No new Harmony target is needed or useful.** The only detached task (`StartOfActAnim`) may legitimately never complete (§3), its Task is discarded natively, and its sole game-state descendant is excluded by the already-required entry-time FTUE read (§4). Hooking `PlayStartOfActAnimation`/`StartOfActAnim`/`InitMapPrompt` would add a hang-prone or redundant receipt.
2. **Sufficient completion receipt = what the event Proceed path already captures**: `RequireEventOption` IsProceed checks (finished model, static `NEventRoom.Proceed` delegate), the exact `Chosen` root task, the synchronous `Opened` signal, `IsOpen == true`, same `_runState`, `!IsTraveling`, `!_isInputDisabled`, and entry-time `SeenFtue("map_select_ftue")`. Requiring `_actAnimTween == null` or `startsAct == false` is the only thing standing between the current code and this receipt.
3. **The blocker is precisely `BridgeProtocol.RequireOrdinaryMap`'s `startsAct || actAnimationActive` refusal** (`BridgeProtocol.cs:95–99`, called at admission `McpMod.EventActions.cs:144` with `requireTravel:false` and in the Opened postcondition `:252`). Admission refuses before `ForceClick`, so today's failure is clean (no half-applied Proceed). The narrowest authorization the parent could grant is: *for the IsProceed event branch bound to an `ActOpening` entry (act 0, `StartedWithNeow`, `ActFloor == 1`, `_hasPlayedAnimation == false` at admission), accept `startsAct`/active `_actAnimTween` as cosmetic given entry-time seen `map_select_ftue`*, leaving the shared helper unchanged for merchant/rest/reward proceeds and for later acts. Whether to accept the "human resets tutorials in settings mid-run" residual (same class as existing foreign-input revocation) is the owner's call.
4. **Later-act openings stay separate**: `NMapRoom._Ready` also calls `Open(false)` (`nmaproom.il` IL0005–0006) and adds its own `NActBanner`; that path is reached only via the refused boss/`EnterNextAct` transition and was not analyzed further.

Residual, not resolvable by metadata: `PrefsSave.FastMode` value on profile 2 (determines animation vs banner-only branch; both are covered above), and actual Godot signal delivery/AsyncLocal propagation, which remain live gates as before.

```acceptance-report
{
  "criteriaSatisfied": [
    {"id": "criterion-1", "status": "satisfied", "evidence": "Read-only IL trace of NEventRoom.Proceed (Open(false) confirmed IL0016), NMapScreen.Open branch IL0179-0433, PlayStartOfActAnimation, <StartOfActAnim>d__112, InitMapPrompt, <MapFtueCheck>d__114, TryCancelStartOfActAnim, DisableInputVeryBriefly, TweenHelper.AwaitFinishedInternal, NActBanner, ProgressSaveManager FTUE writers/callers, OnMapPointSelectedLocally; no repo edits, no game access."},
    {"id": "criterion-2", "status": "satisfied", "evidence": "Determined: no additional Harmony target is needed (StartOfActAnim task may never complete on human interrupt; its only game-state descendant MapFtueCheck is excluded at InitMapPrompt IL0007-0024 by the entry-time seen flag whose only lowering writer is the human settings popup). Blocker isolated to RequireOrdinaryMap startsAct/actAnimationActive at EventActions.cs:144/252. Evidence frozen at /tmp/jev-minimal-initial-map/."}
  ],
  "changedFiles": ["/tmp/jev-minimal-initial-map/* (scratch evidence only)", "/Users/yanchenxin/.pi/agent/sessions/--Users-yanchenxin-dev-github.com-chenxin-yan-jev-slay-the-spire-2--/subagent-artifacts/outputs/e8636f38-aaf8-4eb2-86c5-2b1dd1946796/research/initial-map-completion.md"],
  "testsAddedOrUpdated": [],
  "commandsRun": [
    {"command": "mise exec -- dotnet IlProbe.dll sts2.dll NEventRoom Proceed / NMapScreen Open PlayStartOfActAnimation <StartOfActAnim>d__112 InitMapPrompt <MapFtueCheck>d__114 TryCancelStartOfActAnim SetTravelEnabled ...", "result": "passed", "summary": "IL excerpts frozen: proceed.il, map-open.il, map-input.il, map-input2.il, map-close-setmap.il"},
    {"command": "mise exec -- dotnet IlProbe.dll sts2.dll TweenHelper AwaitFinished/AwaitFinishedInternal/OnFinished/OnExiting; NActBanner Create/_Ready/AnimateVfx; SaveManager+ProgressSaveManager FTUE methods; TaskHelper.RunSafely; NMapRoom._Ready", "result": "passed", "summary": "tweenhelper.il, actbanner.il, savemanager-ftue.il, progress-ftue.il, runsafely.il, nmaproom.il"},
    {"command": "mise exec -- dotnet Callers.dll sts2.dll <14 targets>; dotnet build+run probe/FieldWriters.csproj for _hasPlayedAnimation _actAnimTween _isInputDisabled _canInterruptAnim", "result": "passed", "summary": "callers.log, field-writers.log; FTUE lowering writers = NSettingsScreenPopup.OnYesButtonPressed only"},
    {"command": "git diff --cached --quiet (../STS2MCP); shasum CONTEXT.md mise.toml", "result": "passed", "summary": "native index clean, 19 preexisting working-tree files untouched; protected hashes unchanged"}
  ],
  "validationOutput": ["Open(false) at Proceed IL0016 confirmed", "animation branch unconditional when FastMode<2 (Open IL0258-0313)", "AwaitFinished true only on Tween.Finished, false only on owner TreeExiting; Kill() never resolves", "InitMapPrompt re-reads SeenFtue at IL0017 on both natural and interrupt routes", "OnMapPointSelectedLocally reads no animation/input-disable fields"],
  "residualRisks": [
    "Human 'reset tutorials' via NSettingsScreenPopup mid-run could re-arm MapFtueCheck after admission; same class as existing foreign-input interference.",
    "Profile-2 FastMode value unknown offline; both branches characterized.",
    "Godot signal delivery/AsyncLocal propagation remain live gates.",
    "Preexisting IsReadableCanvas fade window may briefly list zero map points after any Open (fail-safe)."
  ],
  "noStagedFiles": true,
  "diffSummary": "No repository diff; scratch evidence and this report only.",
  "reviewFindings": ["Blocker is exactly BridgeProtocol.RequireOrdinaryMap startsAct||actAnimationActive at McpMod.EventActions.cs:144 (admission) and :252 (Opened postcondition); no new hook needed; authorization decision is owner's."],
  "manualNotes": "Investigation only; no guard loosened, no implementation. Later-act/boss transitions explicitly out of scope."
}
```
