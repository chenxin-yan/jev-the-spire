# Headbutt owned-selection continuation: diagnosis and offline repair

Repo `/Users/yanchenxin/dev/github.com/chenxin-yan/jev-slay-the-spire-2`, branch `main`, baseline `3e06aab` (clean at start).
Source is frozen; nothing staged/committed. Full diff: `/tmp/jev-autonomous-2026-09-20/headbutt/implementation/final.diff` (`git diff --binary HEAD`, 329 lines).

## Cause (engine IL proof, not fixture inference)

Native `sts2.dll` SHA256 `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4` (v0.111.0, re-hashed: `implementation/native-sha.txt`).

1. `PlayCardAction.<ExecuteAction>d__25` creates `new GameActionPlayerChoiceContext(this)` (IL 0872) and calls `CardModel.OnPlayWrapper(context, …)` (IL 0904). `this` is the exact `PlayCardAction` the bridge enqueued: `ActionQueueSynchronizer.RequestEnqueue` calls `EnqueueAction(action, NetId)` directly in singleplayer (`il-requestenqueue.log`), and the bridge already registers it (`TrackGameAction` → `SelectionOwners.RegisterContext(action, action)`).
2. `CardModel.<OnPlayWrapper>d__339` (IL 1589–1624) wraps that context: `new BranchingPlayerChoiceContext(model, localNetId, actionType, originalContext)` → `PushModel` → `OnPlay(branchingContext, cardPlay)` → `branching.AssignTaskAndWaitForPauseOrCompletion(task)`. Every card `OnPlay` therefore receives a **BranchingPlayerChoiceContext**, never the registered `GameActionPlayerChoiceContext`. `PotionModel.<OnUseWrapper>d__75` / `UsePotionAction.<ExecuteAction>d__25` have the identical shape (`il-onusewrapper.log`, `il-usepotionaction.log`).
3. `Headbutt.<OnPlay>d__3` awaits the attack, then `CardSelectCmd.FromCombatPile(choiceContext, discardPile, owner, prefs)` (IL 0257) with that Branching context.
4. `CardSelectCmd.<FromCombatPile>d__20`: `ReserveChoiceId` → `await context.SignalPlayerChoiceBegun(player, options)` → (production, no test selector) `NPlayerHand.CancelAllCardPlay()` → `NCombatPileCardSelectScreen.Create(pile, prefs, filter)` → `NOverlayStack.Push` → `await screen.CardsSelected()` (base `NCardGridSelectionScreen.CardsSelected`, not overridden — hooked boundary).
5. `BranchingPlayerChoiceContext.<SignalPlayerChoiceBegun>d__15`: if `!_originalContext.OwnerId.HasValue || chooser.NetId == _originalContext.OwnerId` it forwards to `_originalContext.SignalPlayerChoiceBegun` (→ `GameActionPlayerChoiceContext`: `PauseActionForPlayerChoice`, returns `Task.CompletedTask`, synchronous). Otherwise it creates a `HookPlayerChoiceContext` into `_createdContext`, completes `_pausedCompletionSource`, and the action detaches from the card task. `SignalPlayerChoiceEnded` and `OwnerId` also forward to `_originalContext`. `AssignTaskAndWaitForPauseOrCompletion` = `WhenAny(task, paused)`: unbranched, the `PlayCardAction` keeps awaiting the selection.
6. Bridge: `ContextualSelectionOwner` masked every `BranchingPlayerChoiceContext` (`return null` for anything that is not GameAction/Blocking). So the `FromCombatPile` prefix entered owner `null`; at `CardsSelected`, `BeginBoundary` saw no ambient owner, retired nothing, created no lease; `ResolveObservationSelection` found the `NCombatPileCardSelectScreen` overlay with no lease → `unowned_selection_continuation`, `mutation_pending=true` (the `PlayCardAction` is legitimately still executing). Exactly the saved readback (`headbutt/readback.json`, `:25`).

Parent hypotheses: (1) **partly true** — the mismatch is the *wrapper* identity, not the action identity; (2) **false** — `SignalPlayerChoiceBegun` completes synchronously in this lane, the ExecutionContext never yields before the boundary; (3) **false** — `NCombatPileCardSelectScreen` does not override the hooked `CardsSelected`. Not a shared-event regression: the shared-event fix only touched the Blocking lane.

Second gate found behind the first (would have been the next live halt): `AddGridActions` admits an exact grid-subclass list; `NCombatPileCardSelectScreen` was absent → `unverified_grid_subclass:NCombatPileCardSelectScreen`. Its `Create` stores `Array.Empty` into `_cards` forever; `UpdatePileContents` renders `_pile.Cards` (`.Where(_filter)` when `_filter != null`), re-runs on `CardPile.ContentsChanged`, and auto-`CompleteSelection`s on an empty/fully-selected pile. `%Confirm` (`NConfirmButton`) → `CompleteSelection` (`SetResult` + overlay `Remove`); no back/close button; `OnCardClicked` toggles `_selectedCards` under `MaxSelect` and `CheckIfSelectionComplete` auto-completes when manual confirmation is off. `AfterOverlayOpened` → detached `FlashRelicsOnModifiedCards`: `AwaitProcessFrame` then `RelicModel.Flash`/`NCard.FlashRelicOnCard` over `_cardResults` (null from `Create`) — pure VFX, no command/input/selection effect. Supervisor approved admitting exactly this type (decision A).

## Fix (production, 4 files)

- `mod/STS2MCP/McpMod.SelectionHooks.cs`
  - `ContextualSelectionOwner`: a `BranchingPlayerChoiceContext` that has **not** branched (`_createdContext == null`) and whose `_originalContext` is a `GameActionPlayerChoiceContext` resolves through the **same** `SelectionOwners.ResolveContext(original.Action)` registration. Branched, Hook, Throwing, nested Branching, unregistered or closed actions still yield `null`. No OwnerId/model-stack, no allowlist, no Task interception.
  - `SelectionContextPrefix`: passes `() => Unbranched(branching)` as the admission's readiness so the lease created at the boundary re-validates the route on every observation/dispatch (`IsCurrent`/`Ready`). Closes the window "wrapper branches after admission (inside `SignalPlayerChoiceBegun`) but before the detached action completes": the lease turns not-ready → observation reports `waiting`, no actions; once the detached action completes the owner is released → `unowned_selection_continuation`.
- `mod/STS2MCP/SelectionOwnership.cs`: `Enter(owner, ready = null)` stores an `AsyncLocal<Func<bool>?>` alongside the ambient owner; `Begin` copies it into `Lease.Ready`; `Scope.Dispose` restores both. Owner `null` never carries readiness.
- `mod/STS2MCP/McpMod.LegalActions.cs`: `AddGridActions` admits exact `NCombatPileCardSelectScreen`; candidates come from new `GridCandidates(screen)` = `_pile.Cards` (`.Where(_filter)` when set) for that type, `_cards` for every other grid. `SameCards` reference/multiplicity completeness, empty-window `waiting`, `grid_candidates_incomplete`, confirm/cancel discovery via visible native buttons and the original `CardsSelected` task are unchanged.
- `mod/STS2MCP/McpMod.StateBuilder.cs`: `screen_type` `"combat_pile"` for that screen (was the raw class name).

## Tests (`mod/STS2MCP/tests/check-bridge.sh`, 2735 → 2770 checks)

Behavioral, through the real Harmony-patched `SelectionContextPrefix`/finalizer with real native context objects (bare, no Godot):
- unbranched Branching over registered action → exact registered owner (**the live RED**); over unregistered action → null; already branched (`_createdContext` set) → null; over a Hook context → null; nested Branching → null; bare Hook → null; after `CloseOwner` → null.
- `CaptureSelecting` fixture reproduces the native order (boundary runs synchronously inside the admitted scope): lease is findable/current and the gate is decidable; setting `_createdContext` afterwards makes `IsCurrent` false and the actual `ResolveObservationSelection` gate return `waiting` (no dispatch window).
- `GridCandidates` over a real uninitialized `CardPile` (`_cards` list) and `NCombatPileCardSelectScreen`: live pile (not empty `_cards`), honours `_filter`, null without `_pile`; other grids keep `_cards`.
IL pins: `OnPlayWrapper`/`OnUseWrapper` construct Branching and await through it; Branching begin/end forward to `_originalContext` unless a Hook context is created; `FromCombatPile` signals before `Create`/`CardsSelected`; policy operands (Branching type, `_originalContext`, `Unbranched`/`_createdContext`, `Enter` 2-arg); grid allowlist now six exact types; `NCombatPileCardSelectScreen` fields/handlers/`%Confirm`/no close lane/`ContentsChanged`/VFX-only flash lane.
Test helper `Call` now pads optional parameters (`Type.Missing`) — needed for `Enter(owner, ready = null)`.

## Commands and exits (all under `/tmp/jev-autonomous-2026-09-20/headbutt/implementation/`)

`gates.py` = copy of `/tmp/jev-morphic-2026-09-20/parent/gates.py` with the output base corrected (prior evidence untouched). Native build: `dotnet build mod/STS2MCP/STS2_MCP.csproj -c Release -p:STS2GameDir=…`; native check: `bash mod/STS2MCP/tests/check-bridge.sh <mod dll> <sts2.dll>`; app gates: `bun --no-env-file test|run lint|fmt:check|typecheck` (via `mise exec`).

| stage | build | check | note |
|---|---|---|---|
| `baseline/` | 0 | 0 | 2735 checks; DLL `ae691f18…aba7` |
| `check-red.log/.exit` | — | 134 | RED on baseline DLL: "an unbranched Branching wrapper over a registered GameAction context installs exactly that registered owner (live Headbutt unowned_selection_continuation)" |
| `green/` | 0 | 0 | ownership fix only, 2746 |
| `mutation-unbranched-check/` | 0 | 134 | dropped `_createdContext == null` → caught by "already branched … grants nothing" |
| `green2/` | 0 | 0 | restored, 2746; DLL `ff3c54b8…d5c2` |
| `green3/` | 0 | 134→0 | grid admission + re-validation; first run failed on test-harness issues (optional param / foreign ambient assertion), fixed in test only; `native-check-3.log` PASS 2770 |
| `mutation-grid-empty-cards/` | 0 | 134 | IL pin caught |
| `mutation-grid-empty-cards-behavior/` | 0 | 134 | caught by "combat pile candidates are the live pile, never the empty _cards list" |
| `mutation-lease-ignores-branch/` | 0 | 134 | `Ready = () => true` in `Begin` → caught by "a wrapper that branched after admission stops being actionable…" |
| `final/` (`--all`) | 0 | 0 | 2770 checks; bun test 51 pass / 0 fail; lint 0; fmt:check 0; typecheck 0 |

Hashes: native `sts2.dll` `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`; candidate `mod/STS2MCP/bin/Release/net9.0/STS2_MCP.dll` (final source) `37157f738b1b1bcd69d22b8f83c1de087f23c971ca7f1cbd4f6a16986e915e9d` (`final/dll.sha256`). Installed DLL `f84591d9…` was built from `f2490c9`; note the baseline rebuild here produced `ae691f18…`, so the build is not byte-reproducible across machines/runs — compare by source, not DLL hash. Native IL was never modified; all IL/API probe logs (`il-*.log`, `api-*.log`, `callers-branching.log`) are preserved.

Files changed: `mod/STS2MCP/McpMod.SelectionHooks.cs`, `mod/STS2MCP/SelectionOwnership.cs`, `mod/STS2MCP/McpMod.LegalActions.cs`, `mod/STS2MCP/McpMod.StateBuilder.cs`, `mod/STS2MCP/tests/check-bridge.sh`. Green copies of each production file also saved under `implementation/*.green.cs` and `check-bridge.green.sh`.

## Remaining uncertainty / live limitations (parent's live gate)

- **Not proved live.** Offline proves policy, lease semantics and candidate derivation with real native objects; the engine walk of `FromCombatPile` (holder allocation timing, `%Confirm` visibility, `_isClickable`, auto-complete after one click with `MaxSelect=1` and no manual confirmation) still needs the parent's Headbutt run. Expect after `play_card` → `card_select` (`screen_type: combat_pile`) with `select_card:i` and, if native enables it, `confirm_selection:i`; a single `select_card` should complete via `CheckIfSelectionComplete`.
- Pile can change while the grid is open (`ContentsChanged`); each observation re-derives candidates from the live pile, and `SameCards` halts if holders lag — a transient halt is possible but fail-closed.
- Nested Branching wrappers (a card that plays another card that selects) remain refused by design; would surface as `unowned_selection_continuation`.
- Hand selectors reached from card plays (`FromHand*`, `NPlayerHand.SelectCards`) now get an owner through the same policy; their `AddHandSelection` path was not re-audited here (mode check `SimpleSelect/UpgradeSelect` still gates it).
- Multiplayer remains refused earlier by `ContextHalt`; the `chooser != owner` branch is therefore only reachable in refused contexts, but the lease re-validation covers it regardless.
