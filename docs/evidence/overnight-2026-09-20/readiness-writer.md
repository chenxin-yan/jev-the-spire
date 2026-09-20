# Whole-current-decision readiness — writer result

**Implemented, offline checks pass; independent review and live acceptance remain pending.** No installation or gameplay authority is implied.

- Baseline: `main`, `d89dfdadc18056cbd977e546f54ab7002f48b5e0`, initially clean tree/index.
- Canonical source only: `mod/STS2MCP`. Sibling backup untouched.
- Native assembly freshly rehashed: **`9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`**.
- Candidate: `mod/STS2MCP/bin/Release/net9.0/STS2_MCP.dll`, SHA256 **`4b5b756f2022a52d88b7338ad977fc70c82fa90718fa019b0a3485a7f791bcf3`**. Also frozen as `/tmp/jev-overnight-readiness/candidate.dll`. **Not installed.**
- Evidence root: **`/tmp/jev-overnight-readiness`** (abbreviated **S** below). `commands.jsonl` retains exact argv/exits; individual `.log`/`.exit` files retain output; `final.diff`, `source/`, `baseline-source/`, `manifest.json`, `status.log`, `index.log` freeze the result.

## Reachability: map fade plus potion is not excluded by native guards

Read the required handoff/scope/evidence documents, both focused handoff audits, CLI observation/decision/dispatch flow, and actual native bridge callers. Fresh metadata probes used the pinned installed assembly; no native scene was constructed or invoked.

1. **`NMapScreen.Open` deliberately returns before points become readable.** `S/map-open.il`: `_points.Modulate.A = 0` at IL0547–0579; `TweenProperty("modulate:a", 1, 0.25)` at IL1102–1136, **delay 0.1 s** at IL1141–1150. `RecalculateTravelability` executes synchronously at IL1157 and `EmitSignalOpened` at IL1383. Thus travelability and `Opened` coexist with an unreadable points container. This is not confined to initial Neow.
2. **A valid owned Proceed need not remain busy during that window.** `S/proceed.log`: native `NEventRoom.Proceed` calls `SetTravelEnabled(true)`, **`Open(false)`**, and returns `Task.CompletedTask`. Existing `DispatchEventOption` retains its original root and synchronous `Opened` checks; no fade completion is part of that receipt. `BridgeProtocol.IsWaiting("map", ...)` returns only `busy`. `S/map-selection.log` confirms native travel enumeration/selection; no new map input authority is needed.
3. **Potion permission is independent of that fade.** `S/container.log`: `NPotionContainer.GrowPotionHolders` passes **true** to `NPotionHolder.Create` (IL0031–0032). `S/holder-create.log` shows this initializes `_isUsable`. `S/potion-writers.log` identifies Create plus generated Godot serialization/property setters as its writers—not a map-opening readiness transition. `Player._canUseOrRemovePotions` defaults true (`S/native-player.log`, IL0045–0046); its gameplay setter callers are three event before/finished pairs, not map opening (`S/potion-callers.log`). `CombatManager.Pause` does nothing outside active combat (`S/combat-pause.log`).
4. **Discard remains a genuine native alternative on a noncombat map.** `S/popup.log`: popup discard is not disabled for CombatOnly usage; `_Ready` separately refuses queued/dead/player-permission cases, and `RefreshButtons` enables discard at IL0033–0039 independently of combat use. `NPotionHolder.OpenPotionPopup` checks potion presence, game over and `_disabledUntilPotionRemoved`, not map alpha (`S/holder.il`). A normal unqueued local potion can therefore remain available while map points fade. For a concrete combat-only example, `FirePotion.get_Usage` returns 1 (CombatOnly), target 2 (AnyEnemy): `S/fire-potion.log`.
5. **The old bridge then produces the wrong decision.** `CaptureObservationCore` removed unreadable travelable points, left map `waiting=false`, and could append `discard_potion:0`. `FinishObservation` advertised completeness. The unchanged CLI accepts any complete/nonwaiting/nonempty set and directly executes a singleton. Neither a usable holder nor native potion permission proves map readability. A later freshness GET does not make two reads inside the zero-alpha interval impossible.

This establishes a reachable pinned-native control-flow combination, **not an observed live incident or an engine-timed reproduction**. No inference/game requests were used.

### Potion holder and target filters

- `_isUsable=false` is the holder's configured noninteractive role, not a temporary map fade flag. Its existing exclusion remains unchanged. Dead/player-disabled/queued, usage, custom-usability and invalid-target exclusions also remain unchanged.
- A usable holder omitted by `IsNodeVisible`, or a **native-valid** target omitted by `VisibleCreatures`, previously left its siblings ready. Both now invalidate readiness of the whole observation rather than prune it. Missing holder/usability metadata still follows the existing whole-observation halt.
- `PotionModel.IsValidTarget` tests null/type, alive, side, player/self identity—not canvas visibility (`S/potion-model.log`). Native `NPotionHolder.TargetNode` routes through `NTargetManager`; `AllowedToTargetNode/Creature` likewise has no alpha guard (`S/target-guards.log`). There is no native validity implication that makes the bridge's visibility filter redundant.
- The probe does **not** certify every engine scheduling path that could hide a holder or target. Those cases are covered as conditional unreadable-input boundaries, not claimed as separate live reproductions. The fix does not guess when such an input becomes visible or grant permission to dispatch it invisibly.

## Minimal change

Only **three files**, **two compiler inputs**; 102 insertions / 7 deletions overall (86 added test lines; production 16 additions / 7 deletions).

| File | Change |
|---|---|
| `McpMod.Contract.cs:133,201–210` | Existing map predicate calls `DecisionInputReady(state, IsReadableCanvas(p))`. The six-line helper returns the existing readiness result and sets `waiting=true` on failure; later ready inputs cannot reset it. `FinishObservation` clears **all** actions on waiting as well as halt. |
| `McpMod.LegalActions.cs:305,318,338` | Pass current observation dictionary into existing private potion builder; use the same readiness gate at usable-holder visibility and native-valid-target visibility exclusions. |
| `tests/check-bridge.sh:1201–1258,1658–1691` | Managed compiled-production regression plus compiled map/potion/POST/native wiring checks. |

Clearing actions in the finalizer is necessary for **server-side** safety: `DispatchLabel` re-captures the observation, then supplies `Observation.Actions` to `BridgeSession.Accept/AcceptChild`; it does not reject solely on the completeness flag. Both serialized and executable sets now remain empty during incomplete readiness. A fresh complete observation restores all eligible alternatives with a fresh fingerprint. No task/owner receipt is released by this gate.

No timers/delays, potion disabling/removal, strategy, interception targets, selector widening, restored adoption, tutorial changes, provider changes, upstream patches or new dependency were added. Existing readability still means alpha > 0; this is not a full-animation-completion claim.

## Regression and validation

The safe offline seam is the **compiled production readiness helper + `FinishObservation` + real `BridgeSession.Accept/AcceptChild`**, combined with IL checks on the actual map predicate, both potion sites and POST re-capture. Native-read boolean fixtures do not initialize Godot. This is explicitly not execution of `CaptureObservationCore` against a real scene tree.

- **RED before production edits:** the real baseline finalizer retained a potion action even with `waiting=true`; updated check failed with `waiting map must withhold the potion sibling from both wire and executable action sets`, **exit 134**, `red-waiting-sibling.log`. This proves the executable-set boundary defect; the native/bridge caller trace above establishes the upstream missing-wait condition.
- **Final RED against preserved baseline DLL** `f1762a3f…`: same assertion, **exit 134**, `final-red-fixed.log`.
- **GREEN:** **1950 actual-DLL checks**, exit **0**, `final-green-fixed.log` (**41 checks beyond baseline**, including assertions inside the reused owned-session fixture).
- **Retained original harness:** **1909 checks**, exit **0**, `retained.log`.
- **Build:** .NET **9.0.318**, exit **0**, **0 warnings / 0 errors**, `build.log`. Used existing restore assets and disabled parent Directory.Build imports; no deployment/packages installed.
- `git diff --check`: exit **0**. `git diff --cached --exit-code`: exit **0**; empty index. Final status contains exactly the three files above.

New cases include all unreadable map points with discard, a partially readable map with discard/use siblings, a hidden usable holder, a native-valid unreadable target with earlier/later siblings, an entirely ready map/potion set, and no eligible inputs (legitimate singleton retained). They check sticky-per-observation waiting, zero executable/serialized alternatives, no callbacks during observation, rejection by normal and owned-child acceptance, retained pending parents, and complete next observations receiving a fresh version. Compiled wiring checks ensure the map visibility predicate and **both** potion visibility branches use the gate while native eligibility checks remain present.

### Reproduction commands

From the repository root; `G` and `D` below are documentation abbreviations (the retained runner supplies literal argv):

```sh
G='/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2/SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64/sts2.dll'
D='mod/STS2MCP/bin/Release/net9.0/STS2_MCP.dll'

mise exec -- dotnet build mod/STS2MCP/STS2_MCP.csproj --no-restore -c Release \
  '-p:STS2GameDir=/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2' \
  -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false \
  -p:UseSharedCompilation=false --disable-build-servers
# exit 0
mise exec -- bash mod/STS2MCP/tests/check-bridge.sh "$D" "$G"
# exit 0, 1950 checks
mise exec -- bash /tmp/jev-overnight-readiness/baseline-check.sh "$D" "$G"
# exit 0, 1909 retained checks
mise exec -- bash mod/STS2MCP/tests/check-bridge.sh /tmp/jev-overnight-readiness/baseline.dll "$G"
# expected exit 134, actual finalizer regression
```

All fresh metadata probe argv/exits are in `S/commands.jsonl`. Read probe sources before reuse: existing `IlProbe`, `ApiProbe`, `Callers` and `FieldWriters` inspect assembly metadata only. First direct probes and initial setup are recorded in `S/pre-run-notes.md`.

Failures are retained, not hidden: an early shell-variable probe batch supplied an empty path (five exit-134 argument errors, rerun successfully with literal paths); adding owned-child test coverage briefly caused a harness-only `childVersion` local-name clash (two exit-1 compilations, fixed by renaming). Earlier green was 1938 checks; final green is 1950. No production fix iteration was required after its first successful build.

## Limits and preservation

- **Fresh independent review is still required.** This report is the writer's evidence, not that review.
- No game requests, UI/control/install, inference, credential/`.env`/environment inspection, save/settings access, commit, push/publication or child agents. No Bun/package installation. Native assemblies were used only for compilation/metadata; Sentry's existing “GDExtension not loaded; skipping” message is retained, not engine initialization evidence.
- Godot scheduling, scene visibility and fresh-Neow lifecycle/provider acceptance remain parent-owned live gates. If a required input stays unreadable, the observation stays incomplete and the existing CLI ready-wait timeout stops it; no timing guess or invisible dispatch bypass was introduced.
- This scoped change does not certify every other action surface's readiness or solve later-act/unsupported continuation gates.
- Historical evidence is untouched. In particular the withdrawn artificial O2 temporal case **remains previously failing (74 checks / 2 failures), not rerun or relabeled green**.
- `CONTEXT.md`, current `mise.toml`, app source/tests and sibling backup were not edited. Final tracked diff and empty index are frozen in S.

```acceptance-report
{
  "criteriaSatisfied": [
    {"id":"criterion-1","status":"satisfied","evidence":"Pinned-native map/potion guard trace establishes the readiness overlap. Exactly two production files plus existing harness changed; whole-observation waiting suppresses all executable siblings without delays, potion removal, new hooks or authority expansion."},
    {"id":"criterion-2","status":"satisfied","evidence":"/tmp/jev-overnight-readiness retains exact commands/exits, native IL, baseline/current sources and DLL hashes, expected RED 134, GREEN 1950 checks, retained 1909 checks, clean build and final diff/index evidence. Independent review remains required."}
  ],
  "changedFiles": [
    "mod/STS2MCP/McpMod.Contract.cs",
    "mod/STS2MCP/McpMod.LegalActions.cs",
    "mod/STS2MCP/tests/check-bridge.sh"
  ],
  "testsAddedOrUpdated": ["mod/STS2MCP/tests/check-bridge.sh: +41 checks across production readiness/finalization/session acceptance and actual compiled map/potion/POST/native wiring"],
  "commandsRun": [
    {"command":"mise exec -- dotnet build mod/STS2MCP/STS2_MCP.csproj --no-restore -c Release '-p:STS2GameDir=/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2' -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false -p:UseSharedCompilation=false --disable-build-servers","result":"passed","summary":"exit 0, 0 warnings/errors; candidate SHA256 4b5b756f2022a52d88b7338ad977fc70c82fa90718fa019b0a3485a7f791bcf3"},
    {"command":"mise exec -- bash mod/STS2MCP/tests/check-bridge.sh \"$D\" \"$G\" (paths defined above; exact argv in commands.jsonl, final-green-fixed)","result":"passed","summary":"exit 0, 1950 actual-DLL checks"},
    {"command":"mise exec -- bash /tmp/jev-overnight-readiness/baseline-check.sh \"$D\" \"$G\"","result":"passed","summary":"exit 0, 1909 retained checks"},
    {"command":"mise exec -- bash mod/STS2MCP/tests/check-bridge.sh /tmp/jev-overnight-readiness/baseline.dll \"$G\"","result":"failed","summary":"expected RED exit 134: waiting baseline finalizer retains executable potion sibling"},
    {"command":"metadata/IL probes listed with literal argv in /tmp/jev-overnight-readiness/commands.jsonl","result":"passed","summary":"pinned native guards, field writers and callers inspected offline; all corrected probes exit 0"},
    {"command":"intermediate final-green/final-red harness attempts; see commands.jsonl and pre-run-notes.md","result":"failed","summary":"two exit-1 harness compilation attempts from local name clash; corrected final runs retained separately"},
    {"command":"git diff --check; git diff --cached --exit-code","result":"passed","summary":"both exit 0; no staged files"}
  ],
  "validationOutput": ["RED 134 -> GREEN 1950; retained 1909", "Native build 0 warnings/errors", "3 files, 102 insertions / 7 deletions; only 2 compiler inputs changed", "No installation or live requests"],
  "residualRisks": ["Independent reviewer gate remains pending", "Managed production/IL checks do not execute Godot scene observation; live timing and UI parity remain unverified", "Hidden holder/target scheduling is not exhaustively proven; conditional unreadable inputs conservatively withhold the decision and may reach the existing wait timeout", "Existing alpha > 0 readability is retained, not full-animation completion", "Historical withdrawn O2 failures remain unchanged and are not included in the passing count"],
  "noStagedFiles": true,
  "diffSummary":"Shared per-observation readiness gate at map and potion visibility filters; finalizer clears all waiting actions; focused compiled-production and native-wiring regressions.",
  "reviewFindings":["No writer self-review blocker found in the scoped diff; fresh independent review required before parent acceptance"],
  "manualNotes":"Exact native and candidate hashes, frozen diff/source, command logs and limitations are retained in /tmp/jev-overnight-readiness. Candidate is not installed. App baseline/live work intentionally left to parent. Historical failing evidence preserved."
}
```
