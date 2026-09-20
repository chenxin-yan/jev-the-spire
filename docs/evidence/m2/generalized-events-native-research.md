# Native event seam: reusable execution, incomplete structured lifetime

## Finding and boundary

**The pinned game already has a generic ordinary-option execution receipt. Event-name allowlists and a catalogue of every card/relic listener are not necessary to dispatch native options or preserve their returned-task semantics. However, that receipt is not a universal certificate that every descendant gameplay operation, decision surface, and room transition has finished.** The practical boundary is supported lifecycle/decision capabilities, not event names.

This is research, not implementation or acceptance. The deliberately stopped per-event work was neither resumed nor treated as a retry. The reference is `/tmp/jev-m2-late-cleanup/source`; neither it nor `../STS2MCP` was edited. Only scratch metadata tooling/evidence and this report were written. No native objects/methods were constructed/invoked, no game HTTP/UI/session/profile access occurred, and no live coverage is claimed. The DLL hash independently matches `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`. Findings concern supplied v0.111.0/41cef1ea, not arbitrary mods. No generated outcomes or future RNG values were inspected as gameplay information.

## Minimal recommendation after simplicity steering

**Start with visible native options → original button/callback → existing appended task → next owned decision. Reuse the adapters already present.** Replace event-name/callback-name admission with that protocol; do not replace it with six-hook-neutral recipient enumeration. Keep identity, stale-input, failure and actual unsupported-control checks. Focus first validation on an ordinary effect, a multipage option and an awaited deck selector. Do not add a general task registry, minigame support or combat-transition instrumentation for this slice.

The real limit is that a standard-looking option can open an unsupported child; runtime halting is containment, not advance assurance that no cost was paid. The owner must explicitly accept that limitation or require a stronger capability declaration. Arbitrary hostile-mod behavior is outside the supported-environment assumption, not a reason to audit every vanilla listener. The alternatives below document future gaps, **not work to build now**. Further reading would not change this recommendation; research stopped.

## 1. Four contracts that must remain separate

### A. Snapshot the decision, not its implementation

`EventModel.CurrentOptions`, visible layout buttons, their native option identities, title/description/hover tips, locks, reuse state, and current generation provide the ordinary public decision. Native option indices are dispatch coordinates, not strategy. `EventOption.OnChosen` is a `Func<Task>`: its method name need not be understood to execute the option. Keep identity, single-delegate, native-input and stale-generation checks; remove neither lethal-confirmation handling nor whole-observation rejection of unsupported controls.

The baseline's actual restrictions are `EventInputsReady`/`RequireEventOption`: TinkerTime-or-finished policy plus Tinker-specific delegate ownership. They are bridge policy, not native requirements. Native `Chosen` accepts the current callback, including closures. Checking that callback's name against each event is not the generic seam. Do not call option generators, inspect latent rewards, or compute hypothetical outcomes to discover capabilities. [A, B]

### B. Dispatch and retain the exact native root

The existing button route is reusable:

`ForceClick → NEventRoom.OptionButtonClicked → EventSynchronizer.ChooseLocalOption → ChooseOptionForEvent → option.Chosen().RunSafely()`.

For unshared choices, `ChooseOptionForEvent` obtains the exact `CurrentOptions[index]` and appends the wrapper to `_pendingOptionTasks` at decimal IL0391–0408. `Chosen` marks reuse state, awaits `BeforeChosen`, then awaits `OnChosen`. `RunSafely` awaits the input and rethrows failure; it is not success laundering. Capturing the uniquely appended wrapper preserves normal task fault/cancellation and awaited descendants without a per-event callback hook. Multicast `Func<Task>` remains unsafe because invocation returns only the last task; the baseline's single-receiver requirement is meaningful. [B]

The root can finish after changing to another page without finishing the event. Conversely, `SetEventState` sets `_isFinished` when its new options are empty and invokes `StateChanged` synchronously; `SetEventFinished` subsequently calls cleanup. Neither notification means the callback task has returned. Generation invalidation and completion are different receipts. Finished-page Proceed is a fresh UI-only option, not a member of empty `CurrentOptions`; its native callback enables map travel and opens the map. Retain its separate `Chosen` task/map-open receipt. [B]

### C. Expose awaited child decisions before root completion

Waiting for the root before offering its selector deadlocks. Existing `SelectionOwnership` leases and `EventOperation` already distinguish a pending parent from an owned actionable child. `CanDecide` requires a captured root, not a completed root; `Poll` joins root, offers, child work and screen lifetimes. `DispatchLabel` has the owned-child acceptance path. [A]

Two native selector routes must not be conflated:

* **Deck selectors:** `CardSelectCmd.FromDeckGeneric` creates/pushes a deck screen and awaits `NCardGridSelectionScreen.CardsSelected` (IL0534–0643); `FromDeckForUpgrade` uses the same boundary (IL0489–0586). These routes do **not** require `PlayerChoiceContext`. The existing grid boundary hook can inherit the owned event execution context. This is a sizeable generic family already reachable through existing targets, subject to adapter readiness tests.
* **Contextual grids:** `EventModel.SelectCardsToAddToDeckFromGrid` creates `BlockingPlayerChoiceContext`, calls `FromSimpleGridForRewards`, awaits selection, then awaits deck insertion. The baseline context prefix masks every non-GameAction context except its authorized treasure scope. This is a real event gap, not proof that all deck selection is unsupported. A narrowly validated event-context exception would change authority and requires explicit approval. `ThrowingPlayerChoiceContext` is not an alternative owner token: both choice-signal methods actually throw. [C]

`RewardsCmd.OfferCustom → RewardsSet.Offer` similarly supplies a native parent task. `Offer` retains `BeginRewardsSet`'s task, shows the screen, then awaits that task (IL0176, 0688, 0695–0780). Existing Offer/ShowScreen hooks bind exact set/player/room/run and child actions while the root remains pending. Selection completion alone is not subsequent acquisition completion; retained native tasks still matter. [D]

### D. Completed gameplay is not completed presentation

The normal command contract composes usefully. `CardPileCmd.Add` awaits `Hook.AfterCardChangedPiles`; its dispatcher awaits normal and late listener tasks. `RelicCmd.Obtain` awaits `AfterObtained` (IL0297–0382). Existing evidence shows recursive clone/add, healing and gold effects being awaited. It is unnecessary to reject all active listeners merely because their effects differ from the nominal option text. Jev receives actual observed results, not a bridge prediction of “exactly one card.” [B, E]

This does **not** prove listeners cannot detach work. But “a Task could hide anything” is not grounds to replace every normal task contract with a recipient allowlist. The six-hook-neutral restriction in the prior Byrdonis audit is a conservative slice-specific workaround, not a native prerequisite for general event execution.

## 2. Structural survey and actual exceptions

A metadata-only inventory enumerated every nonabstract `EventModel` subclass in the pinned assembly: **69 types**, comprising 60 direct `EventModel` subclasses and nine direct `AncientEventModel` subclasses. The denominator includes mock/deprecated types; it is **not** 69 playable events or a support percentage. Declared overrides and IL call edges, including nested compiler state machines, were inventoried without invoking getters. Detailed bodies were then sampled at shared producers and exceptional boundaries, not every effect. [F]

Observed families:

| Family | Native structure and implication |
|---|---|
| Ordinary/multipage | Option callbacks call `SetEventState` or `SetEventFinished`; the same root/generation protocol applies. |
| Deck selection / rewards / relic acquisition | Commands await common decision boundaries. Adapters should target those boundaries, not the event that requested them. |
| Shared voting | `ChooseLocalOption` first votes; an immediate local append is not promised. The ordinary capture algorithm cannot simply enable shared events. |
| Embedded combat | `EnterCombatWithoutExitingEvent` transfers to the combat synchronizer; a new gameplay lifecycle must be owned. |
| Ancient dialogue | `NAncientEventLayout.OnDialogueHitboxClicked`/`SetDialogueLineAndAnimate` advance dialogue and enable options; dialogue is a distinct native control, not an event option callback. |
| Custom overlay/layout | CrystalSphere's ordinary option awaits a minigame `_completionSource` and then `CompleteMinigame`; cell/tool/proceed controls are not standard card selectors. FakeMerchant declares a custom layout; TheArchitect declares a combat layout and custom dialogue/terminal progression. |
| Room/map/terminal progression | Ordinary finished Proceed opens the map synchronously; embedded-room entry and run-ending callbacks have different receipts. Never equate every control labelled Proceed with map opening. |

A missing capability may be discovered only after an option starts: CrystalSphere does not declare a custom `LayoutType` override but opens its custom overlay inside the callback. Thus `ordinary layout && no canonical encounter` is not a complete preflight capability declaration. Current native metadata has no public “all possible descendant decision kinds” contract. [F, G]

### Concrete detached work: classify, do not generalize indiscriminately

1. **Detached gameplay transition, directly relevant to events.** `EventModel.EnterCombatWithoutExitingEvent` is void and calls `EventCombatSynchronizer.ReadyToEnterCombat`. Once readiness agrees, `EnterCombat` calls `RunManager.EnterRoomWithoutExitingCurrentRoom`, wraps it with `RunSafely`, and pops it (IL0715–0725). The option's returned task does not join room entry, battle decisions, terminal rewards or event resume. Capturing this transition at a generic producer is justified; scanning every event callback is not. [G]
2. **Detached gameplay in a transitive native hook, bounded to another room family.** `LordsParasol.AfterRoomEntered` starts `PurchaseEverything().RunSafely()` and returns `CompletedTask` (IL0023–0034). The worker waits frames/time, then awaits actual merchant purchases and card removal. This disproves an assembly-wide assumption that every hook's returned task encompasses gameplay. Its guard is `MerchantRoom`: it does **not** demonstrate detached purchases during ordinary event card gain. [H]
3. **Detached decision-affecting UI.** `NRewardsScreen._Ready` drops `RelicFtueCheck().RunSafely` (IL1035–1045). The task waits frames before creating a relic tutorial. Its end is not an acknowledgement receipt. Existing seen-at-entry refusal is justified; checking that no modal is visible now misses a future modal. New support needs the actual tutorial lifetime, not merely a postfix retaining `RelicFtueCheck`. [I]
4. **Harmless detached presentation versus unproved hypotheses.** Card preview callbacks animate/clean up; PunchOff's detached `PunchEachOther` loop calls animation, waits and VFX, not damage in the inspected body. Waiting for every task could wait forever on ambient presentation. `CardReward.Populate` drops `Hook.AfterModifyingCardRewardOptions`; however the pinned declared recipients found for that hook update usage synchronously and return `CompletedTask`. `OnRelicObtained` drops `AfterModifyingRewards`; inspected recipients synchronously flash/update flags. These are contract holes for future/mod code, **not demonstrated delayed vanilla reward mutation**. [B, H, J]

Arbitrary mod subscribers/patches can violate any of these assumptions. A native DLL hash does not prove their absence. Establish the supported environment separately; do not execute unknown subscriber factories during observation. This trust boundary is different from auditing every native listener.

## 3. Comparison for the owner's architecture choice

**Reuse current interfaces/tasks first.** Generic public-option snapshot, original button dispatch, appended root, generation invalidation, native-enabled input, owned deck-selector/reward leases, and separate map Proceed are available without new interception targets. This supports a useful ordinary capability family. It does not mean removing the Tinker check alone is safe or installed: contextual selectors, lifecycle readiness and unsupported-surface behavior still need changes/tests.

**Limited scoped receipts at generic producers.** Where a concrete native producer drops relevant work, retain it under exact operation/run/player/room identity. Potential approval requests grounded here are:

* `RunManager.EnterRoomWithoutExitingCurrentRoom(AbstractRoom,bool)` returned task, scoped to an identified event-combat transfer; pair it with explicit combat decision ownership and event-resume handoff. A transition task is not battle completion.
* `NChooseABundleSelectionScreen.CardsSelected` for the bundle-selection family: `CardSelectCmd.FromChooseABundleScreen` awaits it at IL0153–0241, but the existing selection hook list omits it.
* A validated event exception at the **already hooked** contextual CardSelectCmd methods for the native blocking context. This expands authority even without a new Harmony target.

Custom minigames and tutorials need their own **control-family** capabilities/receipts or upstream support; the evidence does not justify inventing a generic acknowledgement method. These proposals are outside current implementation authorization. No global TaskHelper interception is proposed: it mixes presentation, detached gameplay and unrelated owners, and misses work detached by other mechanisms.

**Upstream structured gameplay/decision receipts—comparison only, not a framework recommendation now.** If universal all-transitive completion becomes a requirement, the missing contract is an operation-scoped gameplay lifetime: every gameplay child is awaited or explicitly registered before publication; decisions carry owner, generation, native control schema and resolution lifetime; room transitions transfer ownership; presentation is explicitly nonblocking; failure/cancellation remains sticky. This would replace the local reflection/AsyncLocal shims without enumerating models.

Smallest useful conceptual contract:

```
Snapshot = public visible choices + owner + generation + decision-kind
Execute(native choice) -> root receipt
While pending: expose only owned supported decision receipts
Release: root and registered gameplay children succeeded,
         decisions closed or ownership explicitly transferred,
         next native input is ready
```

No existing Task API proves the registration set is closed over *all* detached work. Also, runtime refusal upon an unexpected surface can occur after costs were paid. If the owner requires “prove all alternatives supported before any mutation,” the native game needs a capability declaration/upstream contract or a separately justified bounded environment; current controls alone cannot provide that guarantee. Do not silently substitute post-mutation halting for preflight support.

Likewise, adopting **observational readiness** (“known receipts settled; currently owned control actionable”) instead of **all-transitive-gameplay completion** is an owner safety-contract decision. Ordinary awaited work already provides stronger evidence than screen stability. Neither delays, `IsFinished`, nor absence of visible overlays close unknown detached producers.

## Evidence and reproducibility

All new evidence is `/tmp/jev-general-events-native/`; IL offsets above are decimal. Sources:

* **[A]** Fixed baseline `McpMod.EventActions.cs`, `EventOperation.cs`, `SelectionOwnership.cs`, `McpMod.SelectionHooks.cs`, `McpMod.RewardHooks.cs`, `McpMod.Contract.cs` (`DispatchLabel`).
* **[B]** `/tmp/jev-m2-byrdonis-audit/{sync,chosen,run-safely,log-task-body,finish-complete,room-click,room-lifecycle,CardPileCmd,hooks,preview,preview-callbacks}.il`; prior `docs/evidence/m2/byrdonis-audit.md` is a secondary audit, not an authority requiring neutral listeners.
* **[C]** New `deck-select.il`, `event-core.il`, `throwing-context.il`, `apis.log`.
* **[D]** `rewards-custom.il`, `rewards-offer.il`; baseline reward adapters.
* **[E]** `relic-obtain.il`; prior `Relics.BingBong.il`, `Modifiers.Hoarder.il`, `Relics.BookOfFiveRings.il`, `Relics.LuckyFysh.il`.
* **[F]** `Inventory.cs`, `Inventory.csproj`, `inventory.log`. Enumeration is `assembly.GetTypes()`, nonabstract assignable EventModel subclasses; call edges decode actual IL instructions with generic resolution context. `DROPPED_TASK` is only a candidate scan (its prefix also matches TaskCompletionSource); resolved methods/bodies decide semantics. No claim of exhaustive task-escape analysis.
* **[G]** `event-core.il`, `event-combat.il`, `minigame-lifetime.il`, `ancient-dialogue.il`, inventory overrides/call edges.
* **[H]** `parasol.il`, `punch.il`.
* **[I]** `reward-ftue.il` (metadata only; no save-manager method was executed).
* **[J]** `cardreward.il`, `reward-overrides.log`, `reward-listeners.il`.

Recipes read before use: `/tmp/jev-m1-safety-code/{ApiProbe,IlProbe}.cs`, `/tmp/jev-m2-byrdonis-audit/Overrides.csproj`. Invocation: `dotnet <ApiProbe.dll|IlProbe.dll> <absolute pinned DLL> <exact type> [methods/nested state machines]`. Scratch inventory: `dotnet run --project /tmp/jev-general-events-native/Inventory.csproj -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false -- <absolute pinned DLL>`. Successful probes/builds exited zero. One initial shell-variable invocation supplied an empty DLL path and failed before assembly loading; the absolute-path rerun succeeded. No candidate build or behavioral/live test was performed.

## Behavior-family test matrix

| Family/adversarial lifecycle | Required assertion |
|---|---|
| Ordinary single/multipage options | Entire public choice set; native callback/index identity; fresh generation; separate Proceed. |
| Awaited nested command/listener work | Root remains pending through effects; recursive additions/heal/gold need no listener-name knowledge. |
| Deck/contextual grids and reward children | Child offered while root pending; correct cardinality/cancel semantics; child completion does not discard parent. |
| Delayed input/presentation | Disabled rebuilt buttons wait; harmless preview/ambient loop does not become gameplay completion barrier. |
| Fault/cancel/reentrancy | Sticky faults even after StateChanged/new buttons; duplicate/missing append, multicast, reused node and foreign owner reject. |
| Shared voting and room/combat transfer | No assumed synchronous append; destination ownership and resume explicitly acknowledged. |
| Tutorial/custom/bundle surfaces | No ownership inferred from visibility; unsupported capability halts explicitly; no hidden outcomes exposed. |
| Detached gameplay adversary | Parent returns before delayed mutation/decision: existing receipt must not be advertised as universal completion. |
| Supported-environment boundary | Foreign mod callback/late producer/context cannot inherit permission merely because native assembly hash matches. |
| Preflight versus runtime failure | Unexpected child after irreversible cost is reported as unsupported after dispatch, never “safe preflight passed.” |
