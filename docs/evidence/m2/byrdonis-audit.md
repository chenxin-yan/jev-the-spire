# Byrdonis Nest — bounded, read-only next-step audit

## Recommendation

**Both native option producers are compatible with the existing ordinary-event task receipt. Do not simply add `ByrdonisNest` to the TinkerTime allowlist.** A concrete next slice is exact Byrdonis initial-option/callback support, restricted to an ordinary, noncombat, hook-neutral acquisition context; retain the existing finished-event Proceed path. Refuse the **whole initial decision** if Take's transitive context cannot be proved supported, rather than exposing only Eat.

No source implementation, installation, gameplay request, native construction, native method invocation, UI action, profile access, inference, GitHub operation, staging or publication occurred. Only metadata/resource inspection and a scratch metadata-probe build occurred. App/source candidates and installed candidate were not written. **Full M2 remains BLOCK**, independently of this slice and of the other writer's combat/map handoff repair. This report is source grounding, not acceptance or permission to select either option.

Evidence directory: `/tmp/jev-m2-byrdonis-audit/`. Audited adapter source is the fixed `/tmp/jev-m2-live-readiness/source/` snapshot, not concurrently changing sibling source. Supplied app/fork revisions and frozen candidate provenance are assumptions from the task; no new claim of current-source equality is made. Native DLL hash was independently verified as `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`.

## Public decision information

Static packaged English localization, selected **only** for the visible initial options, egg card and Unplayable keyword (`public-text.py`, `public-text.log`):

| Visible choice | Public rule |
|---|---|
| Eat the Egg | “Gain **7** Max HP.” (`MaxHpVar(7)` in native metadata.) |
| Take the Egg | “Add **Byrdonis Egg** to your **Deck**.” |
| Byrdonis Egg | “Can be hatched at a **Rest Site**.” |
| Unplayable | “Unplayable cards cannot be played.” |

`ByrdonisEgg` is Quest type/Quest rarity, canonical energy cost -1, has the Unplayable keyword and maximum upgrade level 0 (`egg.il`, `card-api.log`). Its only declared behavioral override is `TryModifyRestSiteOptions`: when the requested player is its owner, append a `HatchRestSiteOption` (IL 0000–0023). This is a **later rest-site decision**, not work started or awaited by taking the egg. No hatch outcome, future random result, seed, future encounter or future reward was inspected or supplied as decision context.

`GenerateInitialOptions` attaches `FromCardWithCardHoverTips<ByrdonisEgg>(false)` to Take (IL 0057–0063); Eat gets an empty hover-tip array. Existing `BuildEventState` already emits `opt.HoverTips`; `McpMod.Helpers.cs:242+` handles both ordinary and card hover tips. No app/schema change is indicated. Live parity must still establish that the card description and Unplayable text reach the observation instead of only the card's name.

## Exact input → task → completion lifecycle

IL offsets below are decimal offsets, as printed by the existing probe.

1. Original button `ForceClick`/release path remains intact. Cached `/tmp/jev-m2-events/button.il`, `NEventOptionButton.OnRelease`: locked/lethal branches precede `NEventRoom.OptionButtonClicked(Option, Index)` at 0249–0266. Existing adapter rejects lethal confirmation and verifies the exact button, model, layout, option, enabled input, generation and single `BeforeChosen` receiver.
2. `room-click.il`, `NEventRoom.OptionButtonClicked`: ordinary unshared option clears layout buttons at 0043–0049, then calls `EventSynchronizer.ChooseLocalOption(index)` at 0054–0065. Clearing the UI does not clear the model's selected option or the adapter's retained callback/task identity. Proceed instead calls `option.Chosen().RunSafely()` and drops the wrapper (0017–0028).
3. `sync.il`: the nonshared local path calls `ChooseOptionForEvent(LocalPlayer,index)` synchronously (0188–0196). That method validates unfinished model/index, reads `CurrentOptions[index]`, and appends **`option.Chosen().RunSafely()`** to `_pendingOptionTasks` (0391–0408), then records history. Thus the append receipt is the exact native wrapper task, not literally the unwrapped Chosen task.
4. `run-safely.il`, `log-task.il`, `log-task-body.il`: the wrapper awaits its input; `GetResult` is at 0096; errors/cancellation rethrow at 0147 and fault/cancel the wrapper through `SetException` at 0167. It does not convert failure into success. No new Chosen hook for ordinary options is needed to retain completion/failure semantics.
5. `chosen.il`, `EventOption.<Chosen>d__64`: checks callback/reuse, marks WasChosen, awaits the single `BeforeChosen` (0080–0165), then awaits `OnChosen` (0176–0258). Existing adapter verifies the pre-callback invocation list exactly; this matters because multicast Func<Task> invocation would otherwise return only its last task.
6. `event.il`, `GenerateInitialOptions`: exactly two native options, index 0 → direct instance delegate `ByrdonisNest.Eat`, text key `BYRDONIS_NEST.pages.INITIAL.options.EAT`; index 1 → direct instance delegate `ByrdonisNest.Take`, corresponding `.TAKE` key. Neither is a Tinker-style compiler closure. Match this **exact producer pair**, not arbitrary methods declared on this model or nested classes.
7. Both effect tasks invoke `SetEventFinished` only after their awaited effect chain. `finish-complete.il`: `SetEventState(description, empty)` clears options, marks `_isFinished` before invoking `StateChanged` (0087–0106), then cleanup runs. Byrdonis inherits no-op `OnEventFinished`, false `IsShared`, null `CanonicalEncounter` (`event-defaults.il`, API declared-method inventory).
8. The original `NEventRoom.SetOptions` rebuilds the finished page with a fresh UI-only Proceed option bound to static `NEventRoom.Proceed`, attaches the room's BeforeOptionChosen and adds buttons (`room-lifecycle.il`, SetOptions 0018–0150). The model's `CurrentOptions` remains empty; do **not** require Proceed to be present there.
9. Proceed sets map travel enabled, calls `NMapScreen.Open(false)`, then returns `Task.CompletedTask` (`room-lifecycle.il`, Proceed 0000–0028). Existing proceed-only Chosen postfix plus exact map `Opened` signal is the appropriate receipt; no terminal-reward proceed is involved. Keep existing ordinary-map/FTUE/act-animation checks.

### Generations and readiness

`EventSetupPrefix` binds the exact owned destination run/room/model/layout and installs `StateChanged`/NodeAdded tracking **before original SetupLayout**. Native SetupLayout registers its own state listener, performs its setup waits and initial SetOptions (`room-lifecycle.il`: listener at 0109, initial SetOptions at 0555). The retained Setup task gates first input. On finish, the adapter's earlier StateChanged listener increments generation and clears captured inputs before native SetOptions creates replacements; the active option owner must flow through the awaited continuation to those new nodes.

`layout.il` AddOptions creates/adds buttons synchronously (0116–0131), then launches deferred animation. `animate.il` schedules a deferred callback; `button-animate.il` shows normal tween completion → EnableButton at 0348–0366, or fast-mode immediate EnableButton at 0027–0028. **Setup completion/IsFinished/new generation alone is not input completion.** The existing initially-disabled registration plus exact live MouseFilter Stop/IsEnabled gate covers this known native input-enabling producer without another target. Initial and rebuilt generations must both remain covered. Missing context/node registration, early enablement, reused nodes or foreign state changes must continue to refuse, not be adopted after the fact.

`EventOperation.Poll` additionally waits for Root, offers and child tasks and closes owned selector lifetimes. `DispatchEventOption` holds until Poll and EventInputsReady (or map open for Proceed). Preserve these prerequisites; do not fix this slice with a delay or `IsFinished` shortcut.

## Effects and transitive limits

### Eat

`event.il`, `<Eat>d__5`: awaits `CreatureCmd.GainMaxHp(owner.Creature, DynamicVars.MaxHp.BaseValue)` (0044–0126), then finishes the event at 0143.

`CreatureCmd.il`:
- GainMaxHp awaits SetMaxHp (0079–0167), records the actual max-HP delta, and awaits Heal(actual delta, true) (0255–0340).
- SetMaxHp synchronously changes the max (0052), returns the actual delta and has a kill branch only if the resulting max is nonpositive. Normal live/alive +7 does not take that branch. `hp-internal.il` documents the native max cap; do not advertise unconditional numerical postconditions for corrupt/capped states.
- Heal mutates HP synchronously at 0233 and records healing. For a local player in EventRoom, the detached work shown is fullscreen healing presentation at 0753. If `Creature.CombatState != null`, Heal additionally awaits `Hook.AfterCurrentHpChanged` at 1341–1426. An event room alone does **not** prove that combat-hook branch unreachable.

Therefore the effect includes healing by the actual gained maximum (normally +7 current HP as well), and is genuinely awaited. A bounded no-combat-state gate avoids claiming arbitrary HP-hook listener coverage. Do not publish a current HP prediction as an observed result; neither option has been selected.

### Take

`event.il`, `<Take>d__6`: creates owned ByrdonisEgg, awaits `CardPileCmd.Add(card, Deck, Bottom, null, false)` (0034–0130), calls `CardCmd.PreviewCardPileAdd(result, 2f, style 1)` (0140–0147), then finishes at 0164.

`CardPileCmd.il`: Add's single-card/PileType overload awaits the single-card/pile overload, which awaits bulk Add. Bulk Add includes these concrete deck-acquisition boundaries:
- `Hook.ShouldAddToDeck` at 0787; if prevented, await `AfterAddToDeckPrevented` at 0905–0993.
- `Hook.ModifyCardBeingAddedToDeck` at 1384; both normal and late modifier passes are synchronous (`hooks.il`).
- Actual `CardPile.AddInternal` at 1570, plus run history/floor-added bookkeeping.
- `Hook.AfterCardChangedPiles` at 2171–2259, awaited after pile insertion. Its dispatcher awaits each normal listener (0095–0180) and then each late listener (0331–0416), with execution-finished notifications.

The bulk method also has combat-pile branches; those are not authority for this Deck acquisition. Card creation is synchronous; `create-card.il` shows mutable card creation, AddCard, AfterCreated; Byrdonis does not override the default no-op AfterCreated (`after-created.il`).

**Important distinction:** awaiting the dispatcher proves it awaits the tasks returned by its listeners. It does not prove that all listeners await everything they start.

Concrete native recipients found by metadata-only override inventory:
- BingBong: for matching owner/deck and null clonedBy, clones and **awaits another Add** (0164); no “exactly one card gained” assumption is valid model-wide.
- Hoarder: similarly performs awaited repeated clone/add operations (0159), with clone-origin/skip guards.
- BookOfFiveRings: updates counters, detaches `DoActivateVisuals().RunSafely()` (0128–0138), and **awaits Heal** (0167). This audit does not elevate the entire activation-visual implementation to trusted gameplay completion.
- LuckyFysh: **awaits GainGold** (0109); further gold-hook closure was deliberately not expanded for this bounded plan.
- DarkstonePeriapt, SovereignBlade and combat/mock/late listeners also exist. The normal/late card modifier passes include FresnelLens and three upgrade eggs. Exact card type guards may make individual listeners inert, but this report does not certify all their transitive contexts.

More importantly, `RunState.<IterateHookListeners>d__118` includes deck cards/enchantments, relics, potions, modifiers, badges/scaling, **mod run subscribers** (0481), and optional combat listeners. `ModHelper` exposes `_runHookSubscribers`; `mod-subscribers.il` is the subscriber iterator metadata. A native DLL hash alone does not establish the identity/purity of arbitrary mod-supplied listener factories. Checking only the current event or the relic list is not a complete closure.

### Presentation is not a reward/selection completion task

`preview.il`: PreviewCardPileAdd discards the PreviewInternal completion source (0076–0081); PreviewInternal builds a card display/tweens. `preview-callbacks.il` shows detached relic flashing and card-fly presentation/cleanup completion. Thus **not every presentation task is awaited by Take**. There is no reward selection, deck mutation or tutorial acknowledgment in these shown callbacks. Do not add a gameplay task hook solely to wait for the egg preview animation. Live input/visibility safety still applies while it is visible.

Neither exact Byrdonis option directly invokes RewardsSet.Offer, ShowScreen, card-selection commands, relic Obtain, terminal rewards, combat entry or a tutorial. However, these absences in the **event body** are not blanket absence claims for arbitrary transitive hook listeners.

## Existing reward/selector protection is not blanket transitive support

- Existing event Offer/ShowScreen scopes verify exact room/player/run/set and bind screen lifetime. `EventOperation.BindScreen` explicitly refuses terminal rewards and unseen-at-entry relic FTUE; these refusals stay unchanged.
- Context-bearing card-selection commands ordinarily mask non-GameAction contexts (`McpMod.SelectionHooks.cs:89–101`). The sole explicit non-action exception is the authorized treasure Obtain scope, **not events**. Do not assume an arbitrary event listener's new PlayerChoiceContext inherits event selector authority.
- Unowned selectors/rewards should halt; this is fail-closed containment, not evidence the complete initial decision was supported before mutation. A hook-neutral gate avoids knowingly starting such an unsupported branch.
- Existing hooks do not capture arbitrary fire-and-forget model work; no global TaskHelper interception is authorized. No exact additional Harmony target is demonstrated necessary for the bounded neutral path. If broader hook-active contexts are desired, first identify the concrete missing producer and scope; the event's Eat/Take methods or global CardPileCmd.Add are not justified new hook targets merely because they transitively call hooks.

## Smallest defensible implementation plan (not implemented)

Likely source files: **`McpMod.EventActions.cs`, `tests/check-bridge.sh`, `README.md`**. Keep `EventOperation.cs`, reward/selector targets, app and M3/M4 unchanged unless a concrete test exposes a separate issue.

1. In EventActions, replace the duplicated Tinker-only audited expressions with one consistent exact branch: existing Tinker support unchanged; an explicitly validated Byrdonis initial decision; finished/proceed handling unchanged. Do not widen `BridgeProtocol.RequireEventPolicy` to trust event models generally.
2. Byrdonis branch requires exact runtime type, ordinary NEventLayout, nonshared/no canonical or embedded combat, alive local owner, no current combat execution and null creature combat state. Validate exactly two current options with the native index/key/direct-instance Eat and Take delegates and single invocation lists, plus existing BeforeChosen, identity, generation, lock/reuse and input checks. Do not accept nested Byrdonis callbacks merely by declaring type.
3. For the first bounded version, require Take's acquisition hook recipients to be **neutral for the six audited methods**: inherited AbstractModel implementations of ShouldAddToDeck, AfterAddToDeckPrevented, TryModifyCardBeingAddedToDeck, its Late counterpart, AfterCardChangedPiles and its Late counterpart (`hook-defaults.il`). Restrict recipients to pinned native types. Include all recipient categories above and the newly created egg; do not silently exclude modifiers, enchantments, potions or badges. Require the mod-run-subscriber registry empty **before** any listener enumeration; do not execute subscriber factories during observation just to discover what they return. A conservatively enumerated superset of concrete in-memory recipients is preferable to executing unknown callbacks. Revalidate the same whole-decision guard at dispatch.
4. The existing snapshot has no such neutral-listener preflight. Implementation must test that its recipient inventory is complete and read-only; if that cannot be grounded without extra scope, leave the initial decision refused. No assumption is made here that the paused floor-3 inventory qualifies: HP/gold/deck count do not identify its recipients.
5. Retain one appended native wrapper receipt and all its cancel/fault semantics. After either choice, wait for newly owned Proceed input; then the parent may select Proceed as a separate action. Do not auto-proceed and do not offer Eat alone when Take is unsupported.

This consciously declines hook-active acquisition contexts, rather than auditing all cards/relics/modifiers or adding more hooks. Individual proven-inert or fully awaited native recipients can be added later through exact evidence, if live inventory requires them. The restriction is local to Byrdonis, not an event-wide or model-wide allowlist expansion.

## Runnable checks to add; live gates retained

No candidate tests were changed or run in this audit. The scratch probe is evidence tooling, not a behavioral test.

Minimum managed checks using the existing bridge test harness:
- Fail-before for the old Byrdonis policy; exact Eat/Take pair succeeds only in neutral ordinary context. Wrong type/closure/target/key/index/count, multicast callback, extra option and foreign BeforeChosen all refuse the whole observation.
- Active card-gain override, late override, mod subscriber, nonnative recipient, combat state, modifier/enchantment/potion listener and changed-between-observation/dispatch inventory all refuse. A default native recipient and newly created neutral egg qualify without invoking native model code.
- Existing appended-task helper: exactly one append and prefix identity; missing/duplicate/reordered append; incomplete/faulted/canceled prior task; callback throw. Root remains pending across nested awaited work; fault/cancel is sticky even after state generation changes or a button appears.
- Initial setup receipt and rebuilt Proceed generation: no root completion from IsFinished alone; exact native-enabled input required; old/reused/foreign nodes and stale actions reject. Whole-decision finalization must clear all actions after one unsupported alternative.
- No authority regression for terminal rewards, unseen-at-entry FTUE, foreign selectors and non-action choice contexts. No new Harmony target or TaskHelper interception.
- Metadata ABI pins for exact Byrdonis callbacks, EventSynchronizer task-list producer, default hook methods/recipient sources and no-op egg creation. Tests must not construct Godot/native models.

Parent-owned live gates, only after implementation/review/build/install authorization:
1. Independently repair/validate the old-combat cancellation handoff; this audit neither repairs nor bypasses it. Do not adopt a preexisting unowned event entry.
2. Establish exact current owned event entry and complete public recipient inventory; if the guarded context fails, stop instead of selecting Eat or using UI fallback.
3. One observation exposes both current options, descriptions and egg/Unplayable hover rules; unsupported alternatives cannot be silently omitted.
4. Parent alone chooses one option. Track the native task through completion, then verify actual visible HP/deck/gold changes and fresh Proceed identity without predicting hidden outcomes. Do not claim both branches live-tested from one run.
5. Proceed remains a separate parent-owned action with map signal/FTUE readiness gates. Taking the egg does not authorize a later Hatch choice. Full M2 acceptance/live/publication remain separate.

## Commands, results and reproducibility

The following are exact command forms used. All paths are explicit; the probes only load metadata, enumerate reflection metadata and decode IL. They do not instantiate native types or invoke game methods. All output files mentioned above are in the scratch evidence directory.

```sh
command -v dotnet
shasum -a 256 '/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2/SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64/sts2.dll'
NATIVE='/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2/SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64/sts2.dll'
dotnet /tmp/jev-m1-safety-code/ApiProbe.dll "$NATIVE" <types>
dotnet /tmp/jev-m1-safety-code/IlProbe.dll "$NATIVE" <type> <methods>
```

`command -v` resolved `/Users/yanchenxin/.local/share/mise/dotnet-root/dotnet`; hash command and successful probes exited 0. Existing probe sources were read first. The only failed probe was `IlProbe ... MegaCrit.Sts2.Core.Models.EventModel SetEventFinished SetCurrentOptions`, exit **134**, because `SetCurrentOptions` does not exist; its partial output is `finish.il`. Corrected `SetEventFinished SetEventState EnsureCleanup` exited 0 (`finish-complete.il`). No native execution was attempted by this failure.

Exact API probe argument groups (prefix `MegaCrit.Sts2.Core.` for each listed type):
- `Models.Events.ByrdonisNest Models.Cards.ByrdonisEgg` → `byrdonis-api.log`.
- `Commands.CreatureCmd Commands.CardPileCmd Multiplayer.Game.EventSynchronizer Events.EventOption Models.EventModel` → `transitive-api.log`.
- `Entities.Cards.CardKeyword Entities.Cards.CardType Entities.Cards.CardRarity Entities.Cards.PileType Entities.Cards.CardPilePosition Commands.CardCmd` → `card-api.log`.
- `Hooks.Hook Nodes.Rooms.NEventRoom Nodes.Events.NEventLayout` → `lifecycle-api.log`.
- `Models.Relics.BingBong Models.Relics.BookOfFiveRings Models.Relics.DarkstonePeriapt Models.Relics.LuckyFysh Models.Modifiers.Hoarder Models.Cards.SovereignBlade` → `recipient-api.log`.
- `Runs.RunState` → `run-api.log`; `Modding.ModHelper` → `mod-helper-api.log`.

Exact successful IL argument groups (same namespace prefix):
- `Models.Events.ByrdonisNest GenerateInitialOptions get_CanonicalVars '<Eat>d__5' '<Take>d__6'`.
- `Models.Cards.ByrdonisEgg .ctor get_MaxUpgradeLevel get_CanonicalKeywords TryModifyRestSiteOptions`.
- `Commands.CreatureCmd '<GainMaxHp>d__22' '<SetMaxHp>d__24' '<Heal>d__20'`.
- `Commands.CardPileCmd '<Add>d__7' '<Add>d__8' '<Add>d__9' '<Add>d__10'`.
- `Multiplayer.Game.EventSynchronizer ChooseLocalOption ChooseOptionForEvent`.
- `Events.EventOption '<Chosen>d__64'`.
- `Models.EventModel SetEventFinished SetEventState EnsureCleanup`; separately `OnEventFinished get_IsShared get_CanonicalEncounter`.
- `Helpers.TaskHelper RunSafely`; separately `LogTaskExceptions`; separately `'<LogTaskExceptions>d__4'`.
- `Commands.CardCmd PreviewCardPileAdd PreviewInternal`; `Commands.CardCmd+<>c__DisplayClass29_0 '<PreviewInternal>b__0' '<PreviewInternal>b__1'`.
- `Hooks.Hook ShouldAddToDeck ModifyCardBeingAddedToDeck '<AfterCardChangedPiles>d__9'`.
- `Nodes.Rooms.NEventRoom '<SetupLayout>d__25' '<BeforeOptionChosen>d__31' SetOptions Proceed`; separately `OptionButtonClicked`.
- `Nodes.Events.NEventLayout AddOptions`; separately `AnimateButtonsIn`; `Nodes.Events.NEventLayout+<>c__DisplayClass33_0 '<AnimateButtonsIn>b__0'`; `Nodes.Events.NEventOptionButton AnimateIn`.
- `Models.Relics.BingBong '<AfterCardChangedPiles>d__5'`; `Models.Relics.BookOfFiveRings '<AfterCardChangedPiles>d__19'`; `Models.Relics.DarkstonePeriapt '<AfterCardChangedPiles>d__4'`; `Models.Relics.LuckyFysh '<AfterCardChangedPiles>d__7'`; `Models.Modifiers.Hoarder '<AfterCardChangedPiles>d__1'`; `Models.Cards.SovereignBlade AfterCardChangedPiles`.
- `Models.Relics.FresnelLens TryModifyCardBeingAddedToDeck`.
- `Models.AbstractModel ShouldAddToDeck AfterAddToDeckPrevented TryModifyCardBeingAddedToDeck TryModifyCardBeingAddedToDeckLate AfterCardChangedPiles AfterCardChangedPilesLate`.
- `Runs.RunState '<IterateHookListeners>d__118'`; separately `CreateCard`.
- `Entities.Creatures.Creature SetMaxHpInternal HealInternal`; `Models.CardModel AfterCreated`.
- `Modding.ModHelper '<IterateAllRunStateSubscribers>d__11'`; `HoverTips.HoverTipFactory FromCardWithCardHoverTips`.

Standalone scratch-only reflection inventory build/run, exit 0 (no game reference/project/deployment targets):

```sh
dotnet run --project /tmp/jev-m2-byrdonis-audit/Overrides.csproj \
  -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false \
  -p:DeployMod=false "-p:STS2GameDir=$(dirname "$NATIVE")" -- "$NATIVE" \
  ShouldAddToDeck AfterAddToDeckPrevented ModifyCardBeingAddedToDeck \
  AfterModifyingCardBeingAddedToDeck AfterCardChangedPiles AfterCardAddedToDeck

dotnet /tmp/jev-m2-byrdonis-audit/bin/Debug/net9.0/Overrides.dll "$NATIVE" TryModifyCardBeingAddedToDeck
dotnet /tmp/jev-m2-byrdonis-audit/bin/Debug/net9.0/Overrides.dll "$NATIVE" TryModifyCardBeingAddedToDeckLate AfterCardChangedPilesLate
python3 /tmp/jev-m2-byrdonis-audit/public-text.py
```

All exited 0. Some generic method-token operands in `public-hover.il` could not be resolved by the reused probe without generic context; these are printed as resolution diagnostics, not treated as resolved calls. The non-generic Byrdonis producer explicitly names the generic egg hover factory, and its public localization/card metadata independently ground the public rules. `Overrides.cs` only enumerates declared method metadata by exact names; `public-text.py` validates the packaged GDPC v3 header, reads its directory and selects public English localization keys. Two preparatory read-only Python header/directory reads exited 0. A bounded `/tmp` filename search for cached pck/localization/event/card JSON evidence returned no matches (exit 0). No candidate build or source-changing build was run. No behavioral check or native/live acceptance is implied by these exits.
