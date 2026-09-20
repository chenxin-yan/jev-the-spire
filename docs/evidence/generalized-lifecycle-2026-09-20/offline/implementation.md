# Generalized selection-ownership / decision-readiness repair — implementation handoff

Recovery of run f1285af4 (worker). This report was written after the original session timed out at handoff; **no source, build, native, install, game, credential, commit or push activity occurred during recovery** — only read-only `git status`/`shasum`/file existence checks and one `sed` of an already-pinned IL dump.

## Actual state (verified read-only at recovery)

- Repo `/Users/yanchenxin/dev/github.com/chenxin-yan/jev-slay-the-spire-2`, `main`, HEAD `96af9eb`.
- Seven modified tracked files, **0 staged, 0 untracked**, nothing committed/installed:
  `mod/STS2MCP/McpMod.Contract.cs`, `McpMod.LegalActions.cs`, `McpMod.NativeActions.cs`, `McpMod.OrdinaryActions.cs`, `McpMod.SelectionHooks.cs`, `SelectionOwnership.cs`, `tests/check-bridge.sh`.
- `git diff 96af9eb --stat`: 7 files, +347 / −23 (production ≈ +92/−21; tests +255/−2).
- Reviewer artifacts (reviewer has no bash): `/tmp/jev-generalized-2026-09-20/repair/review.diff` (542 lines; verified identical to `git diff 96af9eb` at recovery) and `status.txt`. Parent also holds `/tmp/jev-generalized-2026-09-20/recovery/partial.diff`, `status.txt`.
- Candidate DLL `mod/STS2MCP/bin/Release/net9.0/STS2_MCP.dll` sha256 `defad43796b942d96c0b16695aeb27ba5cd83844ae65e0218de0c6b823e97094` (copy: `repair/STS2_MCP.candidate.dll`). Baseline DLL (96af9eb) `5a2ac678ef4f5d1c479f085d2587ca860df0eb875303167076937c44ae697ce1` (`repair/STS2_MCP.baseline.dll`). Native `sts2.dll` sha256 `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4` (verified before every probe).
- Scratch: `/tmp/jev-generalized-2026-09-20/repair/` (logs, probes, `src-candidate/` copies of the seven files).

## Supervisor coordination

Design brief sent via `contact_supervisor` before editing. Supervisor **approved**: (1) scoped observation-only postfix on `NRestSiteRoom.AfterSelectingOptionAsync(RestSiteOption)` retaining the ORIGINAL Task, capture established before `start()`; (2) reusing existing boundary handlers for `NChooseABundleSelectionScreen.CardsSelected` / `NChooseARelicSelection.RelicsSelected`; A (contextual authority) with `RequireEventIdentity` enforced at admission and explicit Blocking-only admission after auditing subclasses; B (combat target whole-set gate) with a behavioral fixture.

## Proven causal chain (pinned IL + code, matches live seed79675RSRGBWQ `:49→:50`)

`DispatchEventOption` enters `SelectionOwners(op.Owner)` + `EventScopes(EventScope(op))`, captures the exact appended synchronizer task, `ForceClick` → native shared helper `EventModel.SelectCardsToAddToDeckFromGrid` (`/tmp/jev-general-events-native/event-core.il:228-236`, not Brain-Leech-specific) does `newobj BlockingPlayerChoiceContext` → `CardSelectCmd.FromSimpleGridForRewards`. Baseline `SelectionContextPrefix` resolved only `GameActionPlayerChoiceContext.Action` (or exact treasure Obtain) and entered `null` for everything else → `BeginBoundary` saw no owner → no grid lease → `unowned_selection_continuation` (`trial-2-observation.json`). `BlockingPlayerChoiceContext` carries no action/owner token (`repair/choice-context-api.log`: bare ctor; only `OwnerId`, model stack, signal methods).

## What was implemented (production)

### A. One shared contextual-ownership policy (`McpMod.SelectionHooks.cs`)
- `SelectionContextPrefix` → `SelectionOwners.Enter(ContextualSelectionOwner(context, RequireTreasureIdentity, RequireEventIdentity))`.
- `ContextualSelectionOwner(PlayerChoiceContext, Action<TreasureOperation>, Action<EventEntry>)`:
  - `GameActionPlayerChoiceContext` → only `SelectionOwners.ResolveContext(action.Action)` (explicit registration; unchanged semantics).
  - **Only** `BlockingPlayerChoiceContext` may inherit; every other subclass returns `null` (masked).
  - Inherits only from `OwnedContextualRoot()`: the retained `_treasureOperation` (scope `Obtain: true`, not Closed) or retained `_eventOperation` (not Closed) **and** `SelectionOwners.CurrentOwner` must be that same operation's owner (both AsyncLocals are set only by our own dispatch flow). Then the source identity adapter runs (`RequireTreasureIdentity` / `RequireEventIdentity` — current run/player/room/scene/model/layout, same as dispatch) before the owner is admitted; refusal throws into the prefix (Harmony finalizer restores state; the throw propagates to the native caller as before for treasure).
  - Never `OwnerId`, model-stack, visibility, node-name or timing.
- Removed superseded `SelectionOwnership.EnterRegisteredContext` and `SelectionContextEnter` (no compat shim).
- Native subclass audit (`repair/choice-context-subtypes.log`, `choice-context-ctor-sites.log`): v0.111 subclasses = Blocking, Branching, GameAction, Hook, Throwing. Blocking ctor sites (18): the shared EventModel grid helper, several relic `AfterObtained`/turn hooks, powers, KnowledgeDemon, SealedDeck, AttackCommand, dev/autoslay. Throwing (291 sites) both signal methods throw `NotImplementedException` (`throwing-context.il`) — not an owner token. Branching/Hook are combat/card/potion/CombatManager lanes — deliberately not admitted (no owned root modelled for them).
- **Semantics summary:** ordinary Blocking context = admitted iff created inside the retained operation's own dispatch flow, exact operation identity, source identity adapter passes. Foreign/human Blocking context (no AsyncLocal) = `null`, no throw, not blocked. Closed/released operation = `null`. Wrong ambient owner or different operation in scope = `null`.

### Selector boundary families (`McpMod.SelectionHooks.cs`)
Added `(NChooseABundleSelectionScreen, CardsSelected)` and `(NChooseARelicSelection, RelicsSelected)` to the existing `SelectionBoundaryPrefix/Postfix/Finalizer` list (public, parameterless, `Task`-returning — `repair/target-visibility.log`; awaited by `CardSelectCmd.FromChooseABundleScreen` per `deck-select.il:1020-1023`; relic backed by `_completionSource`). Same invariants: lease at entry only under an ambient owner, exact returned Task attached, fault sticky.

### Ordinary detached work (`McpMod.NativeActions.cs`)
- `DispatchOwnedTask` owner is now `OrdinaryOwner { List<Task> Work; bool Closed }` created **before** `start()`; `_bridgeSession.HoldUntil(() => OrdinaryWorkDone(owner))`; release closes it.
- `RetainOrdinaryWork(Task)`: refuses (`ordinary_work_owner_unverified`) unless `SelectionOwners.CurrentOwner` is an open `OrdinaryOwner`. `OrdinaryWorkDone`: fault/cancel → `ordinary_work_failed` (sticky via session Fail); success requires all retained tasks `IsCompletedSuccessfully`.
- No general Task/`RunSafely` interception.

### Rest post-select receipt (`McpMod.OrdinaryActions.cs`, `McpMod.LegalActions.cs`)
- `RestScopes` (AsyncLocal) + `RestScope(run, player, room, button, option)`; `DispatchRestOption` enters the scope around the existing tracked `DispatchUiTask(... SelectOption ...)` and `HoldUntil(scope.Failure == null)`.
- Harmony **postfix** on private `NRestSiteRoom.AfterSelectingOptionAsync(RestSiteOption)` (approved target): inert without a `RestScope` (human/foreign lane ignored, never adopted or blocked); inside the scope requires exact `__instance == scope.Room == NRestSiteRoom.Instance`, `__0 == scope.Option == button.Option`, first capture only, then `RequireRest(run, player, room)` (entry receipt, tutorial, not exiting, not dead) and `RetainOrdinaryWork(__result)` — the ORIGINAL returned Task. Any mismatch → `scope.Failure` → session fails at next Refresh (`rest_post_select_identity_unverified` / `rest_post_select_capture_failed`).
- Pinned reason (`ownership/rest-select-state.il`, `rest-after-select.il`, `rest-after-state.il`, `repair/rest-room-api.log`): `SelectOption` awaits `ChooseLocalOption`, then `AfterSelectingOption` drops `AfterSelectingOptionAsync().RunSafely()` (=`LogTaskExceptions`) and returns one process frame later; the detached lane does HideChoices/VFX → `UpdateRestSiteOptions` (recreates buttons) → `ShowProceedButton` → `ShowChoices`.

### Rest Smith actual native context path (proven, no guess)
`SmithRestSiteOption.OnSelect` (`repair/rest-option-onselect.log`) builds `CardSelectorPrefs` and calls **`CardSelectCmd.FromDeckForUpgrade(Player, CardSelectorPrefs)`** — a context-free overload (no `PlayerChoiceContext` parameter, `repair/cardselectcmd-api.log`) whose state machine awaits the already-hooked `NCardGridSelectionScreen.CardsSelected` (`deck-select.il:444-447`). `ChooseLocalOption → ChooseOption → option.OnSelect()` is awaited inside `SelectOption`, i.e. inside the owned `DispatchOwnedTask` flow, so the `OrdinaryOwner` AsyncLocal flows to the grid boundary and the grid lease is found for `session.OperationOwner` while `SelectOption` is pending (parent-pending child; `DispatchLabel.AcceptChild`). **No contextual prefix and no event/name branch is involved for Smith.** Cook uses `FromDeckForRemoval` (same shape). Mend uses `NTargetManager.SelectionFinished` (not a hooked boundary → would fail closed as before). Dig/Hatch use `RelicCmd.Obtain` (existing Obtain prefix is inert outside treasure Awards scope → any Blocking selector there stays unowned/fail-closed).

### B. Combat target whole-set gate (`McpMod.Contract.cs`)
`AddCombatActions(state, player, actions)`; an unreadable native-legal target now routes through `DecisionInputReady(state, visible.Contains(target))` (whole decision waits, `FinishObservation` withholds every sibling) instead of silently pruning that target. `CanPlay`/`CanPlayTargeting`/`IsAlive` remain the semantic filters.

## Generalization coverage (adapter vs. hardcode)

| Surface / lane | Mechanism | Kind |
|---|---|---|
| Ordinary event option → Blocking grid (Brain Leech-like, any EventModel using the shared helper) | shared policy + `RequireEventIdentity` + existing grid boundary + `EventOperation.CanDecide` | generic seam (no event/card name) |
| Treasure Obtain → Blocking selector | same policy, treasure adapter (replaces prior special-case branch) | generic seam |
| Rest Smith/Cook → deck grid | AsyncLocal flow to existing grid boundary; no context | generic (already covered by boundary) |
| Rest post-select lane | scoped postfix on exact native producer | inevitable native surface adapter (pinned detached RunSafely) |
| Bundle / relic selectors | existing boundary handlers, two new exact targets | generic UI family |
| Combat unreadable target | `DecisionInputReady` | shared gate |
| Branching/Hook/Throwing contexts, unregistered GameAction, foreign/human flows, closed owners | masked → `unowned_selection_continuation`/refusal | fail-closed, unchanged |

## Tests (`mod/STS2MCP/tests/check-bridge.sh`, native block; all use the actual compiled bridge, no Godot init)

Added behavior tests: real `SelectionContextPrefix`/finalizer with real `BlockingPlayerChoiceContext`/`ThrowingPlayerChoiceContext` instances (bare ctors) inside a retained `EventOperation` + `EventScope` + ambient owner — baseline masks silently, candidate reaches `RequireEventIdentity` (`event_identity_changed` with plain-object fixture) and, through the shared policy with fixture identity adapters (`ContextGuards`), admits exactly the retained owner, guards first, Throwing never; parent-pending grid child lease found/`IsCurrent`/`AcceptChild` without root completion; foreign second selector halts whole observation; nested overlap rejected; grid completion retires lease, root completion releases; different-operation scope, foreign ambient owner, closed operation, post-release → masked. Real Harmony detour of the real prefix with real `GameActionPlayerChoiceContext` over uninitialized `MoveToMapCoordAction` (registered vs. unregistered). Ordinary work lanes `sync`/`delayed`/`none` through the actual `DispatchOwnedTask` + live `_bridgeSession`; late/foreign `RetainOrdinaryWork` refused; fault/cancel sticky `ordinary_work_failed`. `RestPostSelectPostfix` inert without scope; identity mismatch fails scope. Bundle/relic exact-screen lease vs. foreign-screen halt. Combat matrix row `("unreadable combat target beside a readable one", [true,false], …)` in the existing whole-set fixture. Compiled-wiring/metadata pins: policy operands (Blocking type, `OwnedContextualRoot`, `ResolveContext`, no `get_OwnerId`/model stack), audited subclass set, EventModel helper `newobj Blocking` + `FromSimpleGridForRewards`, rest `SelectOption→ChooseLocalOption/AfterSelectingOption→AfterSelectingOptionAsync+RunSafely`, exact new Install targets (no `RunSafely`/`LogTaskExceptions`/`AfterSelectingOption`/`UpdateRestSiteOptions`), rest branch → `DispatchRestOption` → scope + `HoldUntil`, postfix → `RequireRest` + `RetainOrdinaryWork`, `DispatchOwnedTask` → `OrdinaryOwner` ctor + `HoldUntil`, Smith `OnSelect → FromDeckForUpgrade` (context-free) → grid `CardsSelected`, `AddCombatActions` wiring. No existing tests removed; one existing Harmony-detour test updated from the deleted `SelectionContextEnter` to the real prefix.

## Exact commands and results (all from repo root; `GAME_DIR="$HOME/Library/Application Support/Steam/steamapps/common/Slay the Spire 2"`, `NATIVE="$GAME_DIR/SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64/sts2.dll"`, `R=/tmp/jev-generalized-2026-09-20/repair`)

Build (every run): `mise exec -- dotnet build mod/STS2MCP/STS2_MCP.csproj -c Release -p:STS2GameDir="$GAME_DIR" -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false`
Check (every run): `mise exec -- bash mod/STS2MCP/tests/check-bridge.sh <dll> "$NATIVE"`

| Step | DLL | Build exit / log | Check exit / log | Result |
|---|---|---|---|---|
| Baseline (96af9eb, old tests) | `5a2ac678…` | 0, `$R/build-baseline.log` | 0, `$R/check-baseline.log` | `PASS: 1972` |
| **Red** (new tests vs baseline DLL) | `5a2ac678…` | — | **134**, `$R/check-red-baseline-dll.log` | first failure: "Blocking context created inside the owned event dispatch flow reaches the exact event identity adapter instead of being masked (live unowned_selection_continuation)" |
| Green iterations | candidate | 0, `$R/build-candidate.log` (0 warnings) | 134→134→0, `$R/check-green-1..3.log` | test-harness fixes only (arg type, wiring assertion), no production change |
| **Final** | `defad437…` | 0, `$R/build-final.log`, 0 `warning CS` | **0**, `$R/check-final.log` | `PASS: 2032 actual-DLL checks; no game initialization or HTTP.` |
| Mutation a: drop ambient-owner agreement in event lane | mutant | 0 | 134, `$R/check-mutation-a-ambient-owner.log` | "an ambient selection owner that is not the retained operation owner is masked" |
| Mutation b: remove `HoldUntil(OrdinaryWorkDone)` | mutant | 0 | 134, `…-b-no-work-hold.log` | "primary Task completion releases only when no owner-scoped detached work is retained: sync" |
| Mutation c: restore silent combat target prune | mutant | 0 | 134, `…-c-combat-prune.log` | "combat target visibility routes into the whole-decision gate…" |
| Mutation d: admit any non-GameAction context | mutant | 0 | 134, `…-d-any-context.log` | "Throwing context is not an owner token even inside the owned event flow" |
| Mutation e: rest dispatch without `RestScope` | mutant | 0 | 134, `…-e-rest-unscoped.log` | "rest options dispatch through the owned rest scope" |

Process note: after mutation a I mistakenly ran `git checkout` on `McpMod.SelectionHooks.cs` (reverted to HEAD), then re-applied the three edits; rebuild produced a byte-identical DLL `defad437…` (`$R/build-candidate-restored.log`). Mutations b–e were reverted from `$R/src-candidate/` copies and `cmp` confirmed restoration. Final build+check ran on the restored tree.

Native metadata probes (offline reflection/IL only, SHA verified): `repair/choice-context-api.log`, `choice-context-subtypes.log`, `choice-context-ctor-sites.log`, `cardselectcmd-api.log`, `rest-room-api.log`, `rest-sync-api.log`, `rest-option-api.log`, `rest-option-onselect.log`, `rest-option-subtypes.log`, `target-visibility.log`; plus pre-existing `/tmp/jev-general-events-native/` and `/tmp/jev-generalized-2026-09-20/ownership/`.

## Open question flagged for reviewer: release without `scope.Captured`

**Current code:** `DispatchRestOption` holds only on `scope.Failure == null`; `OrdinaryWorkDone` is trivially true when nothing was retained. So if the postfix never fires, the session releases when the `SelectOption` Task completes successfully — exactly the baseline (030edf1) behavior.

**Pinned fact (`/tmp/jev-generalized-2026-09-20/ownership/rest-select-state.il` IL 0275–0298):** `AfterSelectingOption` is called only when the local `<success>5__2` — the `bool` result of `RestSiteSynchronizer.ChooseLocalOption` — is true (`ldfld <success>5__2; brfalse.s 298`). When `ChooseLocalOption` returns **false**, `SelectOption` skips the post-select lane, still `AwaitProcessFrame` + `EnableOptions`, and completes successfully. In that path the option was **not** chosen natively, no Captured receipt exists, and the bridge would report the mutation complete.

**Verdict:** absence of `Captured` is **not** proven to be a legitimate outcome; it is an **unverified missing receipt**. The candidate is strictly not weaker than baseline here, but it does not close this gap. Recommended follow-up (not applied — no source changes permitted in recovery): in `DispatchRestOption`, hold until `scope.Captured`, and once the primary `SelectOption` Task has completed without capture fail with e.g. `rest_post_select_receipt_missing` (the `success == false` branch has no bridge-legal outcome). I did not decode why `ChooseLocalOption` can return false (its `ChooseOption` IL shows `InvalidOperationException` throws and a completion-source `IsCompleted` check at 0067–0072; the false-return branch was not traced) — left for the reviewer/next investigation.

## Remaining limits (explicit)

- Offline only: managed fixtures + compiled IL/metadata. Cannot construct `NCardGridSelectionScreen`, `NRestSiteRoom`, `RunState`; the `RequireEventIdentity`/`RequireRest` success paths are exercised only via fixture adapters and wiring checks. **Not live-certified**; rest fix 030edf1 also remains live-uncertified.
- The rest postfix success path depends on Harmony patching a private async method's outer stub (`AfterSelectingOptionAsync` returns the builder Task synchronously — `rest-after.il`), standard for the existing Task postfixes but unproven live.
- Generic card/grid/hand `AddCardClick` still silently omits `_isClickable == false` holders (readiness scout gap #2) — untouched; no pinned native setter lifecycle beyond card-reward, no universal MouseFilter rule added.
- Potion actions during any pending-owner selector are omitted unless combat-exit/event/treasure owns the decision (pre-existing; rest Smith grid child inherits that omission).
- Mend (`NTargetManager`), Dig/Hatch relic `AfterObtained` Blocking selectors outside treasure, Branching/Hook contexts: fail closed as before; not supported.
- Exhaustive event/relic coverage is not claimed; only the shared Blocking-context seam and the audited subclass set are covered.

## Recommended live QA (parent-controlled only)

1. Fresh seed reaching an ordinary event with a Blocking grid (e.g. Brain Leech "Share Knowledge"): expect `card_select` with owned lease, select+confirm, parent root completes, event proceeds.
2. Rest site: choose Rest → expect waiting through the detached lane, then a fresh complete `rest_site` (Proceed + rebuilt options after AnimateIn). Choose Smith → grid child owned under the rest owner → upgrade → same post-select wait. Observe whether any `rest_post_select_*` failure or release-without-capture occurs (see open question).
3. A bundle or relic-choice screen under an owned reward/event: expect lease instead of `unowned_selection_continuation`.
4. Combat with a fading/offscreen enemy: expect `waiting` for the whole hand, not a missing target.

Implemented: shared Blocking-context ownership policy + two approved boundary targets + approved rest post-select receipt + combat whole-set gate.
Changed files: the seven listed above.
Validation: build exit 0 (0 warnings); check-bridge red 134 → green 0 (1972 → 2032); mutations a–e all 134.
Open risks/questions: rest release without `scope.Captured` (see section above); Godot-only success paths unverified; card-holder clickability gap untouched.
Recommended next step: independent review of `$R/review.diff` + `status.txt`; decide the `Captured` hold before any live rest QA.

```acceptance-report
{
  "criteriaSatisfied": [
    {
      "id": "criterion-1",
      "status": "satisfied",
      "evidence": "Seven-file diff vs 96af9eb (+347/-23, production ≈ +92/-21): shared ContextualSelectionOwner/OwnedContextualRoot policy replacing the prior special-case prefix and removing EnterRegisteredContext; two approved boundary targets; approved scoped rest post-select postfix + OrdinaryOwner work retention; AddCombatActions DecisionInputReady. No event/card-name branches, no global Task/RunSafely interception, no new hooks beyond the supervisor-approved targets (asserted by compiled check)."
    },
    {
      "id": "criterion-2",
      "status": "satisfied",
      "evidence": "Exact commands, exits and logs in /tmp/jev-generalized-2026-09-20/repair/ (build-*.log, check-baseline/red/final/mutation-*.log), review.diff verified identical to working tree, status.txt, candidate sha256 defad4379…, baseline 5a2ac678…, native 9cb4f1ad…; red 134 on baseline DLL, final 0 with PASS 2032, five mutations each 134 with named failing assertion."
    }
  ],
  "changedFiles": [
    "mod/STS2MCP/McpMod.Contract.cs",
    "mod/STS2MCP/McpMod.LegalActions.cs",
    "mod/STS2MCP/McpMod.NativeActions.cs",
    "mod/STS2MCP/McpMod.OrdinaryActions.cs",
    "mod/STS2MCP/McpMod.SelectionHooks.cs",
    "mod/STS2MCP/SelectionOwnership.cs",
    "mod/STS2MCP/tests/check-bridge.sh"
  ],
  "testsAddedOrUpdated": [
    "mod/STS2MCP/tests/check-bridge.sh"
  ],
  "commandsRun": [
    { "command": "mise exec -- dotnet build mod/STS2MCP/STS2_MCP.csproj -c Release -p:STS2GameDir=\"$GAME_DIR\" -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false (baseline 96af9eb)", "result": "passed", "summary": "exit 0; DLL 5a2ac678…; /tmp/jev-generalized-2026-09-20/repair/build-baseline.log" },
    { "command": "mise exec -- bash mod/STS2MCP/tests/check-bridge.sh $R/STS2_MCP.baseline.dll \"$NATIVE\" (old tests)", "result": "passed", "summary": "exit 0, PASS: 1972; check-baseline.log" },
    { "command": "mise exec -- bash mod/STS2MCP/tests/check-bridge.sh $R/STS2_MCP.baseline.dll \"$NATIVE\" (new tests, RED)", "result": "failed", "summary": "exit 134 at 'Blocking context created inside the owned event dispatch flow reaches the exact event identity adapter instead of being masked'; check-red-baseline-dll.log" },
    { "command": "mise exec -- dotnet build … (candidate, final)", "result": "passed", "summary": "exit 0, 0 warning CS; DLL defad43796b942d96c0b16695aeb27ba5cd83844ae65e0218de0c6b823e97094; build-final.log" },
    { "command": "mise exec -- bash mod/STS2MCP/tests/check-bridge.sh mod/STS2MCP/bin/Release/net9.0/STS2_MCP.dll \"$NATIVE\" (final)", "result": "passed", "summary": "exit 0, PASS: 2032 actual-DLL checks; check-final.log" },
    { "command": "mutation a (drop ambient-owner agreement) build+check", "result": "failed", "summary": "exit 134 'an ambient selection owner that is not the retained operation owner is masked'; check-mutation-a-ambient-owner.log" },
    { "command": "mutation b (remove HoldUntil(OrdinaryWorkDone)) build+check", "result": "failed", "summary": "exit 134 'primary Task completion releases only when no owner-scoped detached work is retained: sync'; check-mutation-b-no-work-hold.log" },
    { "command": "mutation c (silent combat target prune) build+check", "result": "failed", "summary": "exit 134 'combat target visibility routes into the whole-decision gate…'; check-mutation-c-combat-prune.log" },
    { "command": "mutation d (admit any non-GameAction context) build+check", "result": "failed", "summary": "exit 134 'Throwing context is not an owner token even inside the owned event flow'; check-mutation-d-any-context.log" },
    { "command": "mutation e (rest dispatch without RestScope) build+check", "result": "failed", "summary": "exit 134 'rest options dispatch through the owned rest scope'; check-mutation-e-rest-unscoped.log" },
    { "command": "git status --short; git diff --cached --name-only | wc -l; shasum -a 256 DLLs; diff <(git diff 96af9eb) $R/review.diff (recovery, read-only)", "result": "passed", "summary": "7 modified, 0 staged, HEAD 96af9eb, candidate defad437…, review.diff matches working tree" }
  ],
  "validationOutput": [
    "check-final.log: PASS: 2032 actual-DLL checks; no game initialization or HTTP.",
    "check-red-baseline-dll.log: Unhandled exception. System.Exception: Blocking context created inside the owned event dispatch flow reaches the exact event identity adapter instead of being masked (live unowned_selection_continuation)",
    "mutations a–e each exit 134 with the named assertion above",
    "sts2.dll sha256 9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4 verified before probes"
  ],
  "residualRisks": [
    "Rest release without scope.Captured: pinned IL shows AfterSelectingOption runs only when ChooseLocalOption returned true; a false return completes SelectOption without any receipt and the bridge would release (same as baseline). Unverified missing receipt, not proven legitimate; follow-up should hold on Captured / fail rest_post_select_receipt_missing.",
    "Offline only: Godot node/RunState success paths of RequireEventIdentity/RequireRest and the private async postfix are covered by fixtures and compiled wiring, not live. Not live-certified.",
    "Generic card/grid/hand _isClickable==false holders are still silently omitted (pre-existing gap, no pinned lifecycle).",
    "Mend/Dig/Hatch rest options, Branching/Hook contexts, non-treasure relic AfterObtained selectors remain fail-closed/unsupported.",
    "Process: one accidental git checkout of McpMod.SelectionHooks.cs during mutation testing; re-applied and rebuilt to a byte-identical DLL."
  ],
  "noStagedFiles": true,
  "diffSummary": "Shared contextual-ownership policy (Blocking-only, retained-operation + identity adapter), removal of EnterRegisteredContext/SelectionContextEnter, bundle/relic boundary targets, OrdinaryOwner detached-work retention with rest post-select scoped postfix and DispatchRestOption, combat unreadable-target whole-set gate; +60 behavioral/wiring checks in check-bridge.sh.",
  "reviewFindings": [
    "flag: mod/STS2MCP/McpMod.OrdinaryActions.cs DispatchRestOption HoldUntil guards only scope.Failure; a successful SelectOption with ChooseLocalOption==false leaves Captured false and releases without receipt — reviewer decision needed before live rest QA",
    "no other blockers found in self-review of review.diff"
  ],
  "manualNotes": "Recovery run made no source/build/native/game changes; only read-only verification. review.diff and status.txt in /tmp/jev-generalized-2026-09-20/repair/ are current. Historical evidence untouched. Parent alone controls live/install."
}
```
