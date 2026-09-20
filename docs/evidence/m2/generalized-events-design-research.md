# Generic event decisions: architecture research

## Scope and conclusion

**Smallest next step for parent consideration:** keep the current observation/actions and native option task receipt; replace the TinkerTime-only gate with a shared native-path check once the completion ceiling below is explicitly accepted. Reuse existing dialogue, selector and reward handlers. **No new framework, schema, scheduler or module is needed now.** Keep custom/combat/modal paths unsupported until a concrete missing decision warrants one proven handler. UI-semantic discovery is diagnostic, not permission to click arbitrary controls.

This is research, not implementation approval. The per-event workflow was deliberately stopped. Neither the sibling nor either frozen candidate was edited; the paused changes were not adopted, built or installed. Reference is `/tmp/jev-m2-late-cleanup/source` (19 source/28 build inputs; supplied accepted DLL SHA256 `3828de49ec906f8e22502452b7cf30d8f429df48e4e7e68fb8a8317640c6f67a`). Native primary evidence is v0.111.0/41cef1ea, whose assembly hash was independently reconfirmed below. No game requests, construction, invocation or live checks occurred.

`CONTEXT.md:5–19` makes the ownership boundary clear: Jev chooses gameplay; enumeration, validation and execution do not transfer strategy ownership. A bridge should expose what the player can presently learn and execute the selected native action—not predict or implement its effects.

## 1. Much of the desired architecture already exists

The baseline already serializes event title/body and current option title, description, locked/proceed/chosen flags, relic rules and hover tips. Ancient dialogue suppresses future lines and option context while dialogue is active (`StateBuilder:1383–1450`). Card, grid, reward, bundle and relic builders already exist independently of event names (`StateBuilder:1828–2128`). `Helpers:242–269` handles ordinary/card hover tips; live-node/readable-text and visual-position helpers should be reused.

The versioned contract already separates observation from dispatch, keeps private object identities out of model context, consumes each version once, rejects stale choices, and permits owned selector continuations without replacing their parent (`Contract:34–37,175–214,311–353`; `BridgeProtocol:283–351`). `EventOperation` already retains root, Offer and child tasks; `SelectionOwnership` supplies opaque owners and generation leases. This is not a missing framework.

The native seam is generic too:

* `EventModel.CurrentOptions` is an `IReadOnlyList<EventOption>`; `StateChanged`, `Description`, `IsFinished` and layout interfaces are shared metadata.
* `NEventLayout.AddOptions` creates `NEventOptionButton(model, option, index)` for every supplied option (IL 0087–0138).
* `NEventRoom.OptionButtonClicked` dispatches through the synchronizer, not an event-name switch. Ordinary `ChooseOptionForEvent` appends `option.Chosen().RunSafely()` to `_pendingOptionTasks` (IL 0391–0408). `EventOption.<Chosen>d__64` awaits `BeforeChosen` and `OnChosen`.
* Finished-page Proceed is UI-created and need not occur in `CurrentOptions`; preserve that distinction.

The read-only upstream checkout, pinned at `55e064850a68f3b4cde7e5fd525bf9b2dec4e885`, already chooses any indexed event button with `ForceClick` (`McpMod.Actions.cs:270–299`). Its immediate `status: ok` is **not** a completion receipt. Upstream illustrates generic choosing, not the stronger safety contract.

### What currently blocks generalization

`EventActions:108–163` explicitly admits only TinkerTime non-proceed effects and verifies its callback declaring type/closure. `BridgeProtocol:104–109` calls this an “audited” policy. Custom layouts, shared models, embedded combat and lethal confirmation are rejected independently. `EventEntry` also binds lifetime identity to a standard layout; that assumption cannot simply survive combat/custom handoffs unchanged.

More subtly, `SelectionHooks:89–101` masks non-`GameActionPlayerChoiceContext` ownership except inside the treasure Obtain scope. An event-owned native task can therefore request a standard card selection and lose authority at this shared boundary. Fixing event names cannot fix this seam. Bundle/relic builders and action cases exist, but the installed selector task boundaries cover only hand, grid, choose-a-card and card reward (`SelectionHooks:43–50`): serialization is not operational support.

## 2. Compare the alternatives

| Alternative | Benefits | Limits, safety and cost |
|---|---|---|
| **Native option + decision-family adapters** | Reuses almost everything; unknown event classes using the same surfaces need no name registration. Native text, predicates and original dispatch preserve rules. Ancient dialogue is one family, not one adapter per ancient. | Private fields/IL remain version-coupled. Custom controls need additional semantics. Embedded combat needs explicit owner handoff, not ordinary-event identity checks. Standard root/task receipts do not prove every detached descendant is accounted for. Smallest initial change; additional hooks require approval. |
| **UI-semantic discovery/dispatch fallback** | Discovers visible labels, controls, selection previews and inventory surfaces even under custom event containers. Can reveal missing coverage without cataloguing event classes. | A visible/enabled control does not establish its input route, gameplay meaning or causal completion. Existing merchant dispatch uses `MouseReleased → OnSelected`, not ForceClick's Released (`LegalActions:241–243`). Duplicate labels, overlays, hidden ancestors, graphical rules and inaccessible controls defeat blind traversal. Useful diagnostics now; automatic dispatch only after a finite control-family adapter proves these properties. |
| **Broader command/task instrumentation or supported receipts** | Explicit decision owner tokens and causal child receipts could make family handoffs robust and delete local shims. Narrow shared boundaries scale better than effect-method allowlists. | Global TaskHelper interception is unauthorized and mixes cosmetic, unrelated and gameplay work; it does not catch every possible Task/async-void mechanism or identify visibility. Command interception still needs ownership and lifecycle classification. Pinned native interfaces do not expose a universal receipt. Largest version/maintenance burden unless upstream supplies a supported contract. |

Native `ICustomEventNode` exposes only `Initialize(EventModel)` and `CurrentScreenContext`; `IScreenContext` exposes focus controls, not an option inventory or completion task. `EventLayoutType` explicitly includes Default, Combat, Ancient and Custom. Thus **EventModel alone is not a universal custom-event API**.

There is nevertheless real reuse beyond ordinary events: pinned `NFakeMerchant` exposes `NMerchantInventory` and `NMerchantButton`. That suggests an inventory capability operating on a supplied owned surface rather than `NMerchantRoom.Instance`, not another event-specific shop implementation. `NEventRoom.EmbeddedCombatRoom` specifically comes through `NCombatEventLayout`; `OnEnteringEventCombat` disables options and hides event visuals. This is a phase transition to the existing combat capability, not another option effect to emulate.

## 3. Choosing is not synchronization—and the contract needs a deliberate ceiling

Serialized public rules/options solve **what Jev may choose**. They cannot establish which native task a click started, whether a chooser belongs to that task, whether a callback failed, or whether an enabled new page appeared before gameplay cleanup completed. Existing deferred option animation makes input readiness distinct from setup/root completion. State changes and stable fingerprints are not receipts.

Conversely, requiring proof that every event effect and every transitive listener is neutral is not a scalable prerequisite for generic events. The earlier audit shows `CardPileCmd.Add` awaits hook dispatch; BingBong/Hoarder await additional Add calls, and other listeners await Heal/Gold work. Those are ordinary native mechanics, not evidence that the bridge must reject them. PreviewCardPileAdd separately starts presentation that is not a gameplay choice. The paused neutral-listener gate rejects behavior the native awaited chain may already handle correctly.

Do **not** replace that gate with a list of every event method or every permissible relic. Proposed operational contract: retain the native root and explicitly owned decision/gameplay continuations, require native input readiness, and account for demonstrated detached gameplay producers at shared boundaries. Do not promise completion of all tasks anywhere in the game; do not wait for every cosmetic fade.

This is a policy decision, not proof that removing the allowlist is safe today. The native hook inventory includes mod run subscribers; arbitrary third-party code can detach mutations outside all inspected receipts. Runtime refusal of an unknown resulting chooser contains further bridge actions but cannot undo the initiating choice. Parent must decide whether **current-decision completeness with bounded continuation support** is acceptable, or whether every possible consequence must be supported before choosing. The latter requires additional bounded-program evidence or supported upstream contracts; it cannot be obtained from visible text alone. Preserve demonstrated combat/reward cleanup requirements under either interpretation.

## 4. Minimal shared shape and missing information

Keep the existing `CaptureObservation` → `AddNonCombatActions` → `AddEventActions` flow and `Observation`/`LegalAction` records. Private owner, lease, native surface and generation bindings already exist. If a helper is needed, put it in the current partial class; extract a module only after real duplication appears. Reuse `halt_reason` for unsupported cases rather than introducing a support protocol.

Finite decision families for support accounting—not a roadmap to implement them all:

1. **Option choice / dialogue advance / proceed:** current native buttons or dialogue hitbox, including repeatable options and locked alternatives.
2. **Item selection:** card/hand/grid, reward card, relic or bundle; selection bounds, selected set, preview, confirm/cancel/skip. Existing task coverage differs by subtype.
3. **Reward claim:** owned Offer/ShowScreen with claim children and separately chosen proceed.
4. **Inventory interaction:** open/close, purchase/removal using native entries and guards, independent of room identity.
5. **Combat decision:** existing combat legality and execution; enter/resume event through correlated handoffs.
6. **Confirmation/modal decision:** visible prompt and all alternatives; currently blocked, requiring a proven receipt/ownership adapter before support.

Spatial/graphical custom interactions remain an explicit unsupported capability until a reusable surface contract is evidenced. Do not invent a universal “click-anything” capability to claim coverage.

Existing schema is sufficient; illustrative subset with no event-specific fields or private identities:

```json
{
  "state_type": "event",
  "state_version": "opaque:42",
  "mutation_pending": false,
  "legal_actions_complete": true,
  "event": {
    "body": "Current displayed prompt",
    "options": [{
      "index": 0,
      "title": "Displayed choice",
      "description": "Displayed rules",
      "is_locked": false,
      "is_proceed": false,
      "was_chosen": false,
      "keywords": []
    }]
  },
  "legal_actions": [
    { "label": "choose_event_option:0", "description": "Displayed choice: Displayed rules" }
  ]
}
```

Keep existing player/card/reward payloads and action labels; no provider/Bun/Effect change is needed. Do not silently redefine `legal_actions_complete` without approval.

Concrete gaps to close:

* Capture option text and actions from **the same surface/index/object binding**: the builder currently traverses all room buttons and assigns traversal indices; dispatch uses layout buttons and native Index (`StateBuilder:1421–1448`; `EventActions:193–201`).
* Add enabled/temporarily unavailable state and visible disabled reason where native UI provides it; keep locked visible options informational. Report selection constraints and actual native prompt, not guessed rules.
* Preserve visible item/keyword/preview information without reading generated inventories, unrevealed cells, future dialogue or `GameInfoOptions`. Existing hover-tip support is intentionally narrow; unknown rule-bearing tip types need explicit diagnostics, not silent omission.
* Distinguish a missing rules description from textless navigation using the existing proceed exception (`BridgeProtocol:43–50`); broaden validation only when a real supported decision needs it.
* Include support diagnostics for missing observation, input route, ownership or completion capability. Do not expose callback names/private object graphs as strategy context.

## 5. Whole-decision accounting and transition protocol

Completeness is the intersection of **visible-rule coverage, alternative enumeration, native legality, dispatch route and owned lifecycle support**. If one current alternative lacks required support, clear all executable actions—not only that alternative. Preserve safely captured public context with diagnostics where possible; never serialize an unfiltered model to explain failure. Example using current fields: `halt_reason:"confirmation_receipt_unavailable:choose_event_option:1"`, `legal_actions_complete:false`, `legal_actions:[]`. Unknown custom controls should prevent a completeness claim, not be ignored.

1. Capture the foreground owned surface on the main thread; overlays/selection precede background event options. Expose no future outcomes.
2. On Jev's POST, recapture, revalidate the entire decision, consume its version, then invoke the original native route once under the existing scoped owner.
3. Retain the root receipt. Known selector/reward boundaries attach child leases to that owner; root may remain pending while Jev decides. Event-created choice contexts need a causally scoped binding, not ambient ownership adopted from any visible screen.
4. Child completion restores the suspended parent only after its own work settles; generation/input guards determine the next decision. Unknown/foreign boundaries revoke permission and report unsupported.
5. Combat entry temporarily suspends event authority; bind the actual owned combat phase, reuse combat/reward cleanup, and revalidate the event on native resume. Do not keep requiring unchanged event layout/current room throughout a legitimate transition.
6. Release only on retained receipt success and required readiness; failures/cancellation remain sticky. Timeout means unresolved/stopped, never successful or automatically retryable.

## 6. Migration, validation and unresolved permissions

Start from the accepted frozen baseline, not the paused sibling diff. Replace TinkerTime callback/name checks and the `audited` boolean with capability checks **only after choosing the completion ceiling**. Do not merge paused `RequireByrdonisOptions`, `RequireByrdonisOwner` or neutral-deck-acquisition gates. Consolidate event observation/action indexing. Replace event-specific custom-state branches only when an equivalent family adapter preserves visible information; deleting them first loses coverage. Keep EventOperation/SelectionOwnership initially rather than rewriting controllers wholesale.

Preserve accepted combat exit, sticky cancellation, reward ownership, FTUE refusal and late-run invalidation behavior. Existing selection/reward/proceed/six ordinary hooks are the authorization boundary. Widening ordinary-context ownership, extending the existing Chosen capture beyond Proceed, adding bundle/relic/modal/combat boundaries, or global interception are **not authorized by this report**; parent must approve the exact needed scope after native evidence. Broad interception is not recommended as the default.

Staged validation, subsequently authorized:

* Metadata ABI checks against the pinned DLL and existing managed tests; add whole-decision failure, stale/reordered identical options, owner loss, sequential selectors, root fault after child appearance, and hidden-data exclusion checks.
* Managed family fixtures with new/unseen producer classes and altered titles/options prove no event-name dependency. These are architecture tests, not native gameplay coverage.
* After separate native/live authorization, start with held-out stock classes across ordinary effects, active hook effects, multi-page/repeat choices, ancient dialogue and existing selections/rewards. No new per-event implementation between held-out cases. Test confirmation/custom/embedded handoffs only when separately supported; do not build them merely to fill a matrix.
* Third-party events are a separate compatibility tier: using supported surfaces is necessary, not proof of safe detached work. Require a documented receipt contract or explicit bounded audit; promise neither stock-all-event nor arbitrary-mod 100% coverage.

## References and reproducibility

Abbreviated source citations above refer exclusively to `/tmp/jev-m2-late-cleanup/source/McpMod.<name>.cs`, except `BridgeProtocol.cs`, `EventOperation.cs` and `SelectionOwnership.cs`. Other key references: `EventOperation.cs:8–66,70–130`; `SelectionOwnership.cs:9–12,63–110,136–158`; `McpMod.RewardHooks.cs:143–158` (event Offer binding); `McpMod.Contract.cs:94–111` (custom/overlay refusal); baseline `README.md:9–65` (offline limits, not a new acceptance assertion).

Native evidence, all for v0.111.0/41cef1ea, SHA256 `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`:

* `/tmp/jev-m2-events/api.log`: EventModel, EventOption, EventSynchronizer metadata.
* `/tmp/jev-m2-byrdonis-audit/{layout,room-click,sync,chosen,room-lifecycle,button-animate}.il`: shared option lifecycle and readiness. `{CardPileCmd,hooks,listeners,preview,preview-callbacks}.il` and `docs/evidence/m2/byrdonis-audit.md`: awaited effects versus detached presentation and mod-listener limits. Earlier per-event recommendations are evidence to reconsider, not adopted policy.
* `/tmp/jev-general-events-design/interfaces.log`: exact ICustomEventNode, EventLayoutType, PlayerChoiceContext, ICardSelector metadata; `surfaces.log`: IScreenContext, NAncientEventLayout, NFakeMerchant, EventCombatSynchronizer; `room-surfaces.il`: NEventRoom custom/embedded getters and OnEnteringEventCombat.
* `.agent-sources/STS2MCP` commit `55e064850a68f3b4cde7e5fd525bf9b2dec4e885`: `McpMod.Actions.cs:270–331`, `docs/raw-full.md:515–552,1212–1234`. Upstream docs target older game versions; pinned assembly takes precedence.

Probe sources `/tmp/jev-m1-safety-code/{ApiProbe,IlProbe}.cs` and invocation recipes in the prior audit were read before reuse. Successful commands used `dotnet /tmp/jev-m1-safety-code/ApiProbe.dll '<absolute sts2.dll path>' <types>` and `IlProbe.dll '<absolute sts2.dll path>' MegaCrit.Sts2.Core.Nodes.Rooms.NEventRoom get_CustomEventNode get_EmbeddedCombatRoom OnEnteringEventCombat`; these only inspect metadata/IL. One initial shell-variable invocation supplied an empty path and exited 134 before assembly loading; retry with a literal absolute path succeeded. No new probe build or native/Godot invocation occurred. Scratch evidence and this report are the only authored outputs.
