# M2 generic ordinary-event path — implementation report

Candidate: `../STS2MCP` detached `55e0648…` (uncommitted work), app `main d1bbc90…` untouched. Freeze: `/tmp/jev-m2-generic-events/` (source/, build-inputs/, incremental.diff, commands.log, all logs/exits, final-hashes.log, freeze.py audit exit 0). Candidate DLL `0cd0c0bbf28a3a6565aa0b500c34967b1d623e051dcffa71f27754b5579035aa` — **not installed**; installed `71ebec…` and native `9cb4f1…` verified unchanged. Nothing staged/committed in either repo.

## Precondition and baseline replacement

- Verified byte-for-byte: repo matched `/tmp/jev-m2-byrdonis-paused/source` (all 29 files); exactly `BridgeProtocol.cs`, `McpMod.EventActions.cs`, `tests/check-bridge.sh` differed from `/tmp/jev-m2-late-cleanup/source`. No unexpected divergence.
- Replaced only those three files with the late-cleanup copies (`cp`), then verified the repo matched late-cleanup fully before editing. No `git reset/checkout`. Paused Byrdonis code not adopted (freeze asserts no `RequireByrdonisOptions/RequireByrdonisOwner/TinkerTime/event_model_tasks_unverified` tokens in any `.cs`).

## Changes (six files vs late-cleanup; four compiler inputs)

| File | Change |
|---|---|
| `BridgeProtocol.cs` | `RequireEventPolicy(shared, embeddedCombat)` — dropped the `audited` bool and `event_model_tasks_unverified`. |
| `McpMod.EventActions.cs` | `EventInputsReady`/`RequireEventOption`: removed the TinkerTime-or-finished admission and the callback declaring-type/closure-owner identity check. Retained unchanged: run/room/scene/layout/model/player identity, generation, exact `layout.OptionButtons` membership, locked/DisableOnChosen, native input/Ignore→Stop gate, `WillKillPlayer` lethal refusal, single `BeforeChosen` = `NEventRoom.BeforeOptionChosen`, separate finished-Proceed `NEventRoom.Proceed`+map receipt, unshared synchronizer `Events[0]`/`_playerCollection`/`_localPlayerId` and exact `CurrentOptions[index]` binding, **non-null single-receiver `OnChosen`** (multicast rejected), `CaptureAppendedTask` of the uniquely appended `RunSafely` task. Added one shared helper `EventOptionIndex(button)` (reads `<Index>k__BackingField`), used by the action label, the synchronizer check and the snapshot. No new hooks. |
| `McpMod.StateBuilder.cs` | `BuildEventState` options now come from `uiRoom.Layout.OptionButtons` with `["index"] = EventOptionIndex(button)` instead of `FindAll<NEventOptionButton>` traversal numbering. `IsReadableCanvas` filter, title/description/locked/proceed/chosen/relic/hover-tips fields unchanged; no hidden/future outcomes added. |
| `McpMod.Contract.cs` | `ResolveObservationSelection`: when the **pending owner is the retained event operation** and a foreground overlay is present that is not a selector/reward type, do not return the `waiting` stop; fall through so the existing `crystal_sphere_contract_incomplete` / `unsupported_overlay:X` / `game_over` paths report it. Other owners keep the existing waiting gate. (Not in the expected-file list — 3 lines, needed for “do not silently wait forever on a known unsupported active surface”; flagged below.) |
| `tests/check-bridge.sh` | See tests. `CalledBy` refactored onto a general `Operands` IL scanner (methods + type tokens + strings) — existing checks unchanged. 1809 → 1842 checks. |
| `README.md` | Event row + Stage 2 paragraph rewritten to the approved contract: generic native option protocol for any `EventModel`, `legal_actions_complete` certifies the **current** decision only, an unsupported follow-up halts after cost/effect with existing diagnostics (never retried/rolled back/inferred), same OptionButtons/native-index binding for observation and dispatch, contextual event grids still unsupported. No universal-coverage claim. |

Not changed: hooks/Harmony targets, `SelectionHooks` context prefix (contextual event grids still masked), `EventOperation`/`SelectionOwnership`, combat/reward/cancel/FTUE/late-cleanup code, custom/shared/embedded-combat/modal handling (still unsupported and halting).

## Tests (all against the actual compiled DLL + pinned native metadata; no game models instantiated)

New/updated in `tests/check-bridge.sh`:
- **Generic admission, no event-name dependency** (compiled wiring): `EventInputsReady`, `RequireEventOption`, `AddEventActions`, `DispatchEventOption`, `BuildEventState`, `EventSetupPrefix` (+ their closures) reference **no concrete `EventModel` subclass** (type tokens/isinst or method declaring types); four distinct pinned producers (`TinkerTime`, `ByrdonisNest`, `AbyssalBaths`, `ColossalFlower`) are confirmed concrete `EventModel` subclasses in the native assembly. Both readiness and per-option checks call the 2-arg `RequireEventPolicy`; `EventInputsReady` no longer calls `get_IsFinished`. Retained guards proven present: `GetInvocationList` (single callback), `WillKillPlayer` (lethal), `get_CurrentOptions` (exact index binding), `RequireGeneration`.
- **Same snapshot/action index**: `BuildEventState`, `AddEventActions`, `RequireEventOption` all call `get_OptionButtons` and the shared `EventOptionIndex`; `BuildEventState` no longer calls `FindAll`; helper reads `<Index>k__BackingField`; native `NEventLayout.OptionButtons` is `IEnumerable<NEventOptionButton>`. (Reordered-unrelated-node invariance follows structurally; a node-level fixture would need Godot construction.)
- **Current unsupported alternative clears the whole decision**: `FinishObservation` fixture now driven by `shared_event_unverified`, `event_embedded_combat_unverified`, `event_option_callback_unverified`, `event_lethal_confirmation_unverified` — earlier alternatives cleared, no callback invoked. 2×2 policy truth table + parameter-count == 2.
- **Fault after new page remains sticky** (managed, via real `BridgeSession`+`EventOperation`+`EventEntry`): new-page input becomes ready while root pending (page change ≠ completion); root fault → session `Failure` + entry revoked; a further `Changed`/new version cannot rearm (`InputReady` rejects, `Accept` 409).
- **Root waits through nested effects and exposes owned child before completion**: real `CaptureAppendedTask` of an async callback that awaits an effect, then opens a deck-selector boundary from the awaited continuation; lease belongs to the option owner (`Find(selector, owner)`), root still pending, foreign owner cannot claim it; release only after selector + effects settle.
- **Pending event root under unowned overlay**: with `_eventOperation` set to the session owner, `NCrystalSphereScreen` foreground → `Stop == null` (falls to existing halt); no foreground → still `waiting`; unowned card selector → `unowned_selection_continuation`; a different pending owner/non-event session under the same overlay → unchanged `waiting`.
- Reused, not duplicated: existing stale-generation, reused/foreign input, missing/duplicate/busy append, multicast rationale, reward-child-while-root-pending, readiness/O1/R2/cancel suites.

Red-before: old harness vs new DLL exit 134 (`TargetParameterCountException`); updated harness vs baseline DLL exit 134 (same); scratch baseline-tolerant copies (in `/tmp` only) show the baseline fails on its own at `EventInputsReady references no concrete event model…` and `pending event root under an unowned custom overlay…`. Managed sticky/nested-effect tests pass on the baseline too — they guard retained composition, not new behaviour.

## Validation summary

| Check | Result |
|---|---|
| Deployment-disabled Release rebuild (isolated obj/output, PathMap) | exit 0, 0 warnings/errors; identical DLL on rebuild |
| `tests/check-bridge.sh` (candidate + native) | **PASS 1842** |
| late-cleanup reviewer driver | 93 checks / 0 RED |
| readiness 50 · O1 60 · R2 16 · cancel-positive 1266 · writer teardown repro | all exit 0 |
| O2 `temporal` | exit 1, 74/2 failures — **known unsupported external-producer case, unchanged, not a pass** |
| freeze.py audit | exit 0 |

## Deviations / risks to flag

1. **`McpMod.Contract.cs` touched (3 lines)**, outside the expected file list, scoped to the event owner only. Without it a CrystalSphere-style overlay opened by an ordinary option (or player death from an option) would report `waiting` forever. Behaviour for combat/reward/treasure owners is unchanged and asserted. If the parent prefers this generalised to all pending owners, that is a separate decision (would change the combat death-while-pending observation from `waiting` to `game_over`).
2. Halts on an unowned follow-up surface are **non-sticky** (same as the existing `unowned_selection_continuation` model): dispatch is blocked while the surface is present; if a human resolves it the retained root can still complete and the bridge resumes. No new receipt authority was added to detect that; reported, not expanded.
3. Compiled-wiring tests prove structure, not live Godot behaviour: node delivery, `OptionButtons` order vs `Index` at runtime, and AsyncLocal propagation through real native continuations remain parent-owned live gates.
4. `/tmp/jev-m2-late-cleanup-review/supplied/Program.cs` (frozen copy of the *old* harness) still calls the 3-arg policy and will fail against this DLL by design; superseded by the updated `tests/check-bridge.sh`.
5. Restore assets for the isolated build were copied from the sibling's existing `obj/` (byte-identical to the accepted review's seed); no NuGet/network restore ran.

## Recommended next step

Independent review of the six-file delta (`/tmp/jev-m2-generic-events/incremental.diff`) and the Contract-scope choice in risk 1; then parent-owned decision on installing `0cd0c0bb…` for live acceptance at the paused ByrdonisNest (ordinary effect, multipage, deck selector), which this slice does not perform.
