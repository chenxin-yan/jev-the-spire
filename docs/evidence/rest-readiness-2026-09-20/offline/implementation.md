# Rest-entry readiness repair (live full-3 `ordinary_mouse_input_unverified`)

Repo `main` HEAD `3443707`, working tree edits only (nothing staged, nothing committed, nothing installed).
Scratch: `/tmp/jev-rest-repair-2026-09-20`. No game requests, UI, launch, saves, credentials or env were touched.

## Symptom (evidence preserved, unmodified)

`docs/evidence/live-2026-09-20/full-3.jsonl` / `full-3-stdout.txt`: `choose_map_node:1` (RestSite (4,6)) accepted at
`:230` → `waiting :231` (mutation_pending) → `unsupported :233 ordinary_mouse_input_unverified` → CLI halt.
The parent's later read-only `full-final-readback.json` (`:234`) is a ready `rest_site`, floor 7, `Rest`+`Smith`,
`legal_actions_complete: true`, HP 32/80. No rest option was ever dispatched.

## Cause (confirmed from the pinned binary + shipped scene; not inferred from the readback)

Pinned `sts2.dll` verified: `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4` (`sts2-dll.sha256`).

1. `scenes/rest_site/rest_site_button.tscn` (text scene read straight out of `Slay the Spire 2.pck`, offset from the
   pck directory; `rest_site_button.tscn.log`): root `RestSiteButton` has `mouse_filter = 2` (**Ignore**), `focus_mode = 2`.
2. `NRestSiteButton._Ready` (`il-rest-button.log`): `ConnectSignals`; `Modulate = transparentBlack`; `AnimateIn()` fired
   through `TaskHelper.RunSafely` (unawaited); `Reload()`.
3. `NRestSiteButton.<AnimateIn>d__21.MoveNext`: `CreateTween().TweenProperty(modulate → White, 0.5s)`, `await AwaitFinished`,
   then `if IsValid: set_MouseFilter(0 /*Stop*/)`. This is the **only** `set_MouseFilter` call in `NRestSiteButton`,
   `NRestSiteRoom`, `NClickableControl` and `NButton` (`callers-set_MouseFilter-restsite.log`, and the new harness check).
4. `NClickableControl..ctor`: `_isEnabled = true` by default; `NRestSiteRoom._Ready` never `Disable()`s the option buttons
   (it only `Disable()`s `_proceedButton`), and `rest_site_ftue` seen ⇒ `ShowFtueIfNeeded` returns immediately.
   ⇒ For ~0.5 s after the room's `_Ready`, every rest button is **visible-in-tree, IsEnabled, MouseFilter Ignore**.
5. Bridge `McpMod.OrdinaryInput` (`McpMod.OrdinaryActions.cs:22`): `IsControlVisibleOrActionable` passes (visible+enabled),
   then `BridgeProtocol.OrdinaryInput(..., mouseFilter=2, ...)` is false ⇒ `throw NotSupportedException("ordinary_mouse_input_unverified")`
   ⇒ `CaptureObservationCore` catch ⇒ `HaltState`. The rest branch (`McpMod.LegalActions.cs` `case "rest_site"`) is the
   only caller reachable in that state; `ProceedButton` is `Disable()`d so its `OrdinaryInput` returns false silently.
6. Timing: `DispatchMap` releases the owned travel as soon as `MoveToMapCoordAction` completes (`chain.Poll`); `NRestSiteRoom._Ready`
   runs synchronously inside that action, so the first post-release observation (`:233`) lands inside the fade window.
   `:234` a moment later saw `Stop`. The `rest_site` branch is also entered from any later GET, so a `DispatchMap`-side
   hold would not have covered it.
7. Not a hotkey-accessible or pruned choice: `NRestSiteButton.get_Hotkeys` returns `Array.Empty<string>()`
   (`il-rest-button-hotkeys.log`) so `NButton.RegisterHotkeys` binds nothing; focus is grabbed only in `EnableOptions` /
   `AfterSelectingOptionAsync` (`callers-TryGrabFocus-rest.log`), i.e. after an option, not at entry. `_GuiInput` mouse
   handling is gated by Godot's mouse filter. During the window no human input reaches the button either.
8. Recurrence: `AfterSelectingOptionAsync` → `UpdateRestSiteOptions()` recreates every `NRestSiteButton` (`Create` → `_Ready`
   → `AnimateIn`), so the same window recurs after every rest option (`callers-UpdateRestSiteOptions.log`, `il-rest-room-after.log`).

Ranked hypotheses at start → outcome: H1 rest button mouse-Ignore fade window — **confirmed** (above). H2 `ProceedButton` —
ruled out (disabled in `_Ready`, silent false). H3 rest-entry/tutorial receipt — ruled out (different reasons:
`rest_entry_readiness_unverified`, `ordinary_tutorial_unverified:rest_site_ftue`).

## Fix (minimal, existing authority only)

No new Harmony/interception targets, selector authority, adoption, tutorial bypass, delays, retries or pruning.

- `mod/STS2MCP/BridgeProtocol.cs`: pure predicate `RestOptionsInputDisabled(IEnumerable<int> mouseFilters) => Contains(2)`,
  with the native-lifecycle constraint comment (mirrors `RewardCardsInputDisabled`).
- `mod/STS2MCP/McpMod.LegalActions.cs` `case "rest_site"`: after `RequireRest` (ownership/tutorial unchanged) and before the
  per-button loop, if any `NRestSiteButton.MouseFilter` is Ignore → `state["waiting"] = true; break;`. Existing
  `FinishObservation` then clears every sibling (options, Proceed, potions) and reports `legal_actions_complete: false`;
  the CLI (`src/loop.ts awaitReady`) already polls on `waiting: true`, so no CLI change.
- Shared `McpMod.OrdinaryInput` is untouched: callers traced (`McpMod.LegalActions.cs` rest/shop, `McpMod.OrdinaryActions.cs`
  proceed/shop toggle, `McpMod.TreasureActions.cs`, `McpMod.EventActions.cs`) keep the hotkey-safety halt for mouse-Ignore.
  Model-disabled options (`Option.IsEnabled`/`_isUnclickable`), `Pass`(1) filters and the `proceed` sibling behave as before
  once the fade ends.

## Regression (`mod/STS2MCP/tests/check-bridge.sh`, native block)

1. Predicate + `FinishObservation` fixture: `entry [2,2]`, `partial [0,2]` ⇒ waiting `rest_site`, incomplete, 0 labels, no
   halt; `ready [0,0]`, `pass [1,0]`, `none []` ⇒ complete with `choose_rest_option:0/1` + `proceed`; no callback executed.
2. Compiled wiring/order in `AddNonCombatActions` IL: `RequireRest` < `RestOptionsInputDisabled` < `OrdinaryInput`, and the
   closure reads `get_MouseFilter`; shared `OrdinaryInput` still contains `ordinary_mouse_input_unverified`.
3. Native pins (metadata only): `_Ready` → `set_Modulate`+`AnimateIn`+`RunSafely`; `AnimateIn` state machine →
   `TweenProperty`+`AwaitFinished`+`set_MouseFilter`; exactly one `set_MouseFilter` across `NRestSiteButton`+`NRestSiteRoom`
   (incl. nested); `get_Hotkeys` → `Array.Empty`; `AfterSelectingOptionAsync` → `UpdateRestSiteOptions` → `NRestSiteButton.Create`.

Red before fix (unchanged HEAD DLL `edaf7bc3…`): `check-red.log`, exit 134, "old rest_site branch halts on the native
AnimateIn mouse-Ignore window instead of waiting". Mutation check (predicate present, branch not wired, DLL `f75b1201…`):
`check-mutation-unwired.log`, exit 134 at the wiring/order check. Green: `check-final.log`, exit 0, `PASS: 1972` checks
(baseline `check-baseline.log`: 1950).

Limitations: offline compiled-IL/metadata + fixture checks only. They cannot construct Godot nodes, so the 0.5 s window
itself, the version bump from waiting → ready, and the CLI re-poll are not exercised live. **Not live-certified.**

## Commands (exact; logs in scratch)

```sh
# build + check (mod/STS2MCP/README.md), no install:  /tmp/jev-rest-repair-2026-09-20/build.sh <label>
GAME_DIR="/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2"
DOTNET_CLI_TELEMETRY_OPTOUT=1 mise exec -- dotnet build mod/STS2MCP/STS2_MCP.csproj -c Release \
  -p:STS2GameDir="$GAME_DIR" -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false
mise exec -- bash mod/STS2MCP/tests/check-bridge.sh mod/STS2MCP/bin/Release/net9.0/STS2_MCP.dll \
  "$GAME_DIR/SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64/sts2.dll"
```

| step | DLL sha256 | build | check |
|---|---|---|---|
| baseline (HEAD src, HEAD test) | `edaf7bc3cc640b9613959b42a4d1bf677caba5b5031bdcc847d6e04cde9dc568` | 0 | 0, 1950 checks |
| red (HEAD DLL, new test) | same | – | 134 (`check-red.log`) |
| mutation (predicate only, unwired) | `f75b1201a3c0d58d51b591bf9a60bb58e98d9a522bdf51384a842fe7bb130025` | 0 | 134 (`check-mutation-unwired.log`) |
| final (fix + test) | `a105a689977a0f887af8dcef688800536a4f11d450ad7de9bc91118b08925a48` | 0, 0 warnings | 0, 1972 checks (`check-final.log`) |

Native inspection helpers (offline reflection/IL only, existing probes reused): `il.sh` → `/tmp/jev-m1-safety-code/IlProbe.dll`,
`api.sh` → `ApiProbe.dll`, `callers.sh` → new `FindCallers/` (lists sts2 methods calling a named method), `pckscan.py` /
`rest_site_button.tscn.log` (pck directory + scene text). Outputs: `il-rest-button*.log`, `il-rest-room*.log`, `il-clickable.log`,
`il-nbutton.log`, `api-*.log`, `callers-*.log`, `pck-scan.log`.

## Changed files

- `mod/STS2MCP/BridgeProtocol.cs` (+6)
- `mod/STS2MCP/McpMod.LegalActions.cs` (+7)
- `mod/STS2MCP/tests/check-bridge.sh` (+53)

## Residual risks / uncertainty

- If `AnimateIn` never reaches its tail (tween killed / `_cts` cancelled — only `_ExitTree` paths found; or `IsValid` false), the
  bridge waits instead of halting; the CLI wait deadline bounds this, and no human input works in that state either.
- Post-option flow (`SelectOption` task, `HideChoices`/`ShowChoices`, `ShowProceedButton`, potential card-select overlay) was
  read but not verified end-to-end; the same predicate covers the recreated buttons, but other post-option seams remain
  unproven live.
- Filter `Pass`(1) is treated as ready, consistent with `OrdinaryInput`; no rest scene uses it.
- Build output `mod/STS2MCP/bin/` is gitignored and was not installed; live trial is parent-only.

## Recommended next step

Fresh review of the three-file diff, then parent-only install + live re-entry of a rest site (watch for `waiting rest_site`
followed by a complete set; confirm `choose_rest_option:*` dispatch and the post-option sequence).
