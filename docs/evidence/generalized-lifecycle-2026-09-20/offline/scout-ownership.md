# Code Context

## Files Retrieved
1. `mod/STS2MCP/McpMod.SelectionHooks.cs:20-121` - current Harmony target census and context/boundary ownership flow.
2. `mod/STS2MCP/SelectionOwnership.cs:10-187` - AsyncLocal owner, selector leases, continuation leases, context registry, stale/foreign/nested rejection.
3. `mod/STS2MCP/McpMod.EventActions.cs:218-260` - ordinary event child dispatch and exact appended `_pendingOptionTasks` root capture.
4. `mod/STS2MCP/EventOperation.cs:1-128` - event root/offer/child/screen lifetime and continuation readiness.
5. `mod/STS2MCP/McpMod.NativeActions.cs:68-180` - map movement ownership and scoped NodeAdded room receipts.
6. `mod/STS2MCP/McpMod.LegalActions.cs:59-100,117-190` - ordinary rest, rewards, bundle, relic, hand decision publication.
7. `mod/STS2MCP/McpMod.OrdinaryActions.cs:48-92` - rest readiness/proceed gates and tracked `SelectOption` dispatch.
8. `mod/STS2MCP/BridgeProtocol.cs:206-233` - fail-closed `OrdinaryRoomEntry` provenance.
9. `/tmp/jev-general-events-native/event-core.il:228-236` - native Brain Leech-like card-choice producer.
10. `/tmp/jev-general-events-native/deck-select.il:600-605,904-906,` and `1023-1030` - contextual selector signal boundaries and bundle selector await.
11. `/tmp/jev-generalized-2026-09-20/ownership/rest-select-state.il:112-298` - rest `SelectOption` receipt and detached callback.
12. `/tmp/jev-generalized-2026-09-20/ownership/rest-after-select.il:1-13` - `AfterSelectingOption` drops `AfterSelectingOptionAsync().RunSafely()`.
13. `/tmp/jev-generalized-2026-09-20/ownership/rest-after-state.il:27-115` - rest async work awaits hide/VFX and rebuilds choices.
14. `/tmp/jev-generalized-2026-09-20/ownership/bundle-select.il:1-18` - bundle `CardsSelected` task signature.
15. `/tmp/jev-generalized-2026-09-20/ownership/relic-api.log` - pinned `NChooseARelicSelection.RelicsSelected` API and `_completionSource`.
16. `docs/evidence/rest-readiness-2026-09-20/README.md:57-67` and `docs/evidence/rest-readiness-2026-09-20/live/trial-2-observation.json:1-11` - immutable live Brain Leech refusal; no selection/retry occurred.
17. `mod/STS2MCP/tests/check-bridge.sh:700-790,1390-1510` - existing behavior tests for ownership, stale/foreign/nested leases, exact boundary task receipt, and rest readiness (but not event Blocking context or detached rest child).

## Key Code

### Proven Brain Leech causal chain
- `DispatchEventOption` creates `EventOperation`, sets `entry.ActiveOwner`, tracks the exact event synchronizer task, enters both `SelectionOwners.Enter(operation.Owner)` and `EventScopes.Enter(...)`, then captures the uniquely appended native event task (`McpMod.EventActions.cs:229-260`).
- Pinned native IL creates `BlockingPlayerChoiceContext` and immediately calls `CardSelectCmd.FromSimpleGridForRewards` (`event-core.il:228-236`). The event method awaits that selector before its later card-pile additions; this is not a name-specific event mechanism.
- `CardSelectCmd`'s contextual overloads are all targeted (`McpMod.SelectionHooks.cs:32-42`). However, `SelectionContextPrefix` deliberately calls `SelectionContextEnter((context as GameActionPlayerChoiceContext)?.Action, ...)`; a `BlockingPlayerChoiceContext` therefore resolves to null and masks the inherited operation owner (`McpMod.SelectionHooks.cs:89-101`).
- The selector boundary then sees no ambient owner: `BeginBoundary` only calls `Begin` when `CurrentOwner != null`; otherwise it faults any prior permission and returns null (`SelectionOwnership.cs:67-77`). Result: visible `NCardGridSelectionScreen` has no lease, and `ResolveObservationSelection` reports `unowned_selection_continuation` (`McpMod.Contract.cs:181-196`).
- Live evidence confirms the exact outcome after Share Knowledge: accepted `choose_event_option:0`, then state version `:50`, `halt_reason:unowned_selection_continuation`, no legal actions, mutation still pending (`docs/evidence/rest-readiness-2026-09-20/live/trial-2-observation.json:1-11`). The live record does not prove a card selection, retry, or rest reachability.

### Existing ownership invariants worth preserving
`SelectionOwnership` uses reference identity, monotonically fresh generations, exact selector+owner matching, incomplete-task leases, explicit context registration, closed-owner rejection, and sticky failure on fault/cancel (`SelectionOwnership.cs:13-20,50-65,79-105,137-186`). Existing tests cover foreign owner/wrong selector, same-owner overlap, completed lease non-dispatchability, stale owner, parallel AsyncLocal flow, foreign same-node reuse, and fault/cancel (`check-bridge.sh:715-780,1450-1510`). Do not weaken these into visibility, timing, node-name, or player-only ownership.

### Ordinary event/reward lifecycle seam
`EventOperation` intentionally offers child decisions while the root is pending: it requires an exact root, captures offers/screens, creates continuation leases, retains child work, renews continuation generations, and only closes screens after all captured work succeeds (`EventOperation.cs:31-128`). `DispatchLabel` accepts an owned child without completing/replacing the parent (`McpMod.Contract.cs:301-327`). This is the correct reusable seam for ordinary event selectors, reward screens, and nested action work; no global Task interception is needed.

### Rest readiness defect (proven mechanism; Smith downstream not assumed)
Rest action publication calls `DispatchUiTask(... NRestSiteButton.SelectOption ...)` (`McpMod.LegalActions.cs:86-94`), and `DispatchOwnedTask` tracks only the task returned by that method (`McpMod.NativeActions.cs:25-43`). Pinned IL shows `SelectOption` awaits `RestSiteSynchronizer.ChooseLocalOption`, then calls `NRestSiteRoom.AfterSelectingOption` before returning (`rest-select-state.il:157-298`). `AfterSelectingOption` is void and invokes `AfterSelectingOptionAsync(...).RunSafely()` while discarding the wrapper (`rest-after-select.il:1-13`). The async child then awaits hide/VFX, rebuilds options, shows Proceed, and may show choices (`rest-after-state.il:27-115`). Therefore `SelectOption` completion is not a sufficient receipt for rest post-selection work or any selector it later creates. The exact downstream Smith/card selector is not proven by this metadata and must not be guessed.

### Selector target omissions (proven metadata)
`InstallSelectionOwnershipHooks` currently targets `NPlayerHand.SelectCards`, `NCardGridSelectionScreen.CardsSelected`, `NChooseACardSelectionScreen.CardsSelected`, and `NCardRewardSelectionScreen.OptionSelected` (`McpMod.SelectionHooks.cs:44-51`). State/dispatch already recognize `NChooseABundleSelectionScreen` and `NChooseARelicSelection` (`McpMod.Contract.cs:104-106,185-188`; `McpMod.LegalActions.cs:167-188`). Pinned metadata proves:
- `CardSelectCmd.FromChooseABundleScreen` awaits `NChooseABundleSelectionScreen.CardsSelected` (`deck-select.il:1023-1030`); the current boundary hook omits it.
- `NChooseABundleSelectionScreen.CardsSelected` returns a generic Task backed by `_completionSource` (`bundle-select.il:1-18`; API output in `ownership/relic-api.log` was generated separately for relic).
- `NChooseARelicSelection` exposes `RelicsSelected() : Task<IEnumerable<RelicModel>>`, backed by `_completionSource` (`ownership/relic-api.log`); current boundary hook omits it.
These are generic UI families, not event/card/name exceptions. Their existence alone does not prove an owner; a lease must be created only when the exact initiating operation/root is owned and the returned task is attached.

## Architecture

1. A POST enters through `DispatchLabel`, validates state version/label, and executes on the main thread. An event option enters an operation owner and captures the exact native event task; a rest/ordinary UI action currently creates a fresh owner and tracks its returned Task.
2. Native async code carries `AsyncLocal` ExecutionContext when its continuation is created under an entered owner, but native `PlayerChoiceContext` is a separate boundary. `GameActionPlayerChoiceContext.Action` can be resolved through explicit registration; `BlockingPlayerChoiceContext` has no GameAction property (pinned API only exposes `OwnerId`, model stack, and signal methods). Current masking is why Brain Leech loses authority.
3. Selector hooks make a lease at selector-entry (`BeginBoundary`), attach the exact original returned Task at postfix, and fault on exception. Observation recognizes foreground selectors and requires `Find(selector, session.OperationOwner)` plus readiness; otherwise the entire legal set is cleared.
4. Event/reward/treasure operations already model pending parent + actionable child via continuation leases. Ordinary `DispatchOwnedTask` does not model detached native work; rest is the concrete proven example.
5. Native room travel uses exact vote/action/destination/task identity plus pre-Ready `NodeAdded` receipts (`McpMod.NativeActions.cs:123-158`); this is the right pattern for provenance, not adoption from a visible room.

## Smallest generalized repair recommendation

**First choice (no new interception target):** make the existing operation owner the only source of contextual selector authority, but permit a `BlockingPlayerChoiceContext` only when an already-owned ordinary event operation is active in the same captured native event-task flow. Keep exact event identity, active operation, root/task capture, generation, and native selector identity checks. Do not map arbitrary `PlayerChoiceContext.OwnerId`/player identity to an operation object; that is not exact ownership. Do not let a foreign/non-action context inherit a generic ambient owner. This is a bounded expansion of `SelectionContextPrefix`, not a per-event allowlist or global Task interception, and it requires supervisor approval because it changes authority.

**Selector families:** reuse `SelectionBoundaryPrefix/Postfix/Finalizer` for the two omitted generic tasks only after approval, with exact targets and receipts:
- `NChooseABundleSelectionScreen.CardsSelected`: lease selector = exact screen; attach its returned Task; refuse duplicate/reused screen and foreign owner.
- `NChooseARelicSelection.RelicsSelected`: same invariant.
This is a new bounded native hook target request: target, receipt, and reason are precise above. It must not be added silently.

**Rest:** do not claim `SelectOption` success means post-selection readiness. Prefer an upstream/native receipt that awaits the detached `AfterSelectingOptionAsync` lane. If no upstream fix exists, supervisor approval is required for a narrowly scoped hook at `NRestSiteRoom.AfterSelectingOption` (or its exact `AfterSelectingOptionAsync` producer), retaining the original returned child task under the same rest operation owner and requiring exact room/run/player/button/option identity. A hook on arbitrary `TaskHelper.RunSafely` or every `Task` is explicitly not recommended. Until that receipt exists, fail closed after the rest action rather than exposing a Smith/next selector.

**No speculative framework:** do not add a generalized task registry, event-name catalogue, host strategy, restored-room adoption, tutorial bypass, or global Task interception. The current operation/lease types already provide the minimal model. If upstream exposes owner tokens/lifetimes, replace local shims rather than expanding them.

## Behavior-level red-capable test seam

Add offline managed-fixture tests beside the existing `SelectionOwnership`/Harmony fixture tests (no game initialization):

1. **Blocking contextual event red:** enter one event operation owner; invoke the contextual CardSelect path with a non-GameAction/Blocking context; assert current baseline produces no lease/`unowned_selection_continuation`. After the bounded fix, assert exactly one lease for the exact grid screen and returned Task; complete the child and assert lease disappears only after parent operation bookkeeping. A second foreign context/screen must remain unowned.
2. **Entire legal set:** fixture offers two event options; one opens the supported grid and one has unsupported child metadata. Assert observation clears *all* actions, never only the supported option, and dispatch does not invoke a callback on an incomplete set.
3. **Rest detached red:** fixture `SelectOption` returns success while an independently retained post-select Task remains incomplete and later creates a selector. Assert session remains pending, no selector is advertised before post-select readiness, and child lease is available only after exact retained task/identity. Current baseline should fail this red assertion because it releases on `SelectOption`.
4. **Bundle/relic receipts:** for each exact omitted screen, assert pending returned Task creates one lease, completion closes it, duplicate/reused screen and foreign owner reject. Include skip/cancel/fault as non-success.
5. **Adversarial lifecycle:** foreign same-node human entry faults old owner without blocking foreign callback; stale owner after `CloseOwner` cannot begin; same-owner nested selector rejects; duplicate boundary/postfix rejects; late async continuation after parent release rejects; selector task fault/cancel is sticky; unchanged selector reused in a later generation rejects old action; parent root remains pending while child decision is active.

## Foreign/stale/nested counterexamples that must remain rejected

- Human/foreign callback reuses a persistent hand/grid/screen while an owned lease exists: old permission is faulted, foreign callback is not adopted (`SelectionOwnership.cs:67-77,153-185`; tests around `reusedSelector`).
- Closed operation owner or late async continuation calls `Begin`/`RegisterContext`: `stale_selection_owner`/`stale_or_duplicate_selection_context`; no resurrection.
- Two overlapping selectors under one owner: `overlapping_selection_ownership` remains a halt until an explicit nested protocol exists (`SelectionOwnership.cs:79-94`).
- Same selector begins twice, postfix attaches twice, or continuation is duplicated: reject stale/duplicate receipt; never replace the original Task.
- Wrong context object, unregistered action, arbitrary `OwnerId`, player-only match, or visibility-only match: no lease.
- Selector Task faults/cancels after native callback catches or changes state: mark owner failed and keep bridge pending/failed; never infer success from a new screen or `IsFinished`.
- Event root/offer is still pending while child selector is visible: expose only the exact owned child; do not release/replace parent. A child completion alone does not close the parent offer.
- Rest post-select child starts after root Task completed: without a retained producer receipt, refuse rather than adopt a visible Smith/rebuilt screen.

## Start Here

Open `mod/STS2MCP/McpMod.SelectionHooks.cs:89-115`, then `SelectionOwnership.cs:67-145`. The minimal Brain Leech fix boundary is visible there. Read `event-core.il:228-236` alongside `docs/evidence/rest-readiness-2026-09-20/live/trial-2-observation.json` to verify the causal chain before changing authority. For rest, open `/tmp/jev-generalized-2026-09-20/ownership/rest-after-select.il` first: it proves why ordinary returned-task tracking is insufficient.

## Proven vs unproven

**Proven:** Brain Leech-style event creates `BlockingPlayerChoiceContext`; current prefix masks it; grid lease is consequently absent; live refusal matches; rest `SelectOption` drops a post-select Task; bundle/relic task APIs are omitted from current boundary hooks; current lease invariants and fail-closed behavior.

**Not proven:** every ordinary event has a blocking context; every rest option leads to Smith; exact native relic-selector producers/callers for all future content; universal all-transitive gameplay completion. Do not use these as premises for a broader patch.

## Artifact paths

- Required report: this file.
- Native pinned metadata: `/tmp/jev-general-events-native/`.
- New scratch IL/API outputs: `/tmp/jev-generalized-2026-09-20/ownership/`.
- Historical live refusal (immutable): `docs/evidence/rest-readiness-2026-09-20/live/`.

No repository files were edited; no game request, Godot initialization, install/launch, provider call, credential/environment/save/settings access, commit, or push was performed.
