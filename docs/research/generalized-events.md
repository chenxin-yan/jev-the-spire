# Generalized events: use the native choice protocol

## Recommendation

Keep the existing bridge and remove event-name admission checks. For standard native event controls:

1. Read the current visible text, rules, options and native option identities.
2. Let Jev select an available option.
3. Invoke the original native button once and retain the task it starts.
4. Expose supported owned child decisions while the parent task is pending; otherwise wait for its task and the next native input to be ready.

No event-effect reimplementation, per-event strategy, event/relic allowlist, new schema, task scheduler or framework. Reuse current snapshot/action/selection/reward code. Preserve stale-version checks, ownership, fault/cancellation handling, native input guards and accepted combat/reward cleanup.

**This generalizes a shared interaction protocol, not every possible game interface.** Custom minigames, shared voting and event-to-combat transitions are different interaction/lifecycle shapes. Add a reusable handler only when a concrete missing shape warrants it; do not claim universal event support from generic option clicking.

## What the research established

The game already implements the ordinary route:

`native button → EventSynchronizer → EventOption.Chosen → appended Task`

`Chosen` awaits its pre-callback and selected callback. The appended `RunSafely` wrapper propagates failure. Ordinary card acquisition awaits its hook dispatcher; listeners can perform further awaited native commands without the bridge knowing their names. The earlier proposed neutral-listener inventory is unnecessary for trusting this normal task contract.

Our existing snapshot already carries event text, options and hover rules. The event-specific restriction is bridge policy: `EventInputsReady` and `RequireEventOption` admit TinkerTime and inspect its callback type. Replace that policy, not the whole architecture. Align snapshot indices with the exact native option bindings used by dispatch: the current snapshot uses tree traversal order while actions use native indices.

A root task can await a selector, so waiting for root completion before exposing that owned selector would deadlock. Existing deck-selector and reward receipts provide reusable building blocks, but support differs by selector subtype. Contextual event selectors are currently masked by the ownership guard; widening that authority requires a separate precise decision. A serializer for a screen does not establish operational support.

These findings concern native v0.111.0 / `41cef1ea`, assembly SHA256 `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`. A metadata inventory found 69 concrete EventModel subclasses, including mock/deprecated classes. That is not a playable-event count or tested coverage percentage.

## The necessary trade-off

The native task is not a certificate that every possible consequence is supported. A standard option can open a custom minigame after dispatch; event-combat entry also launches work outside the option's returned task. Current visible options do not declare every future decision type.

Recommended scope: support the current native decision and known owned continuations; stop with an explicit unsupported result if a new unsupported surface appears. **The initiating choice may already have applied a cost or effect before that stop.** Do not retry it, infer success from a stable screen, automatically click through, or claim that preflight guaranteed all consequences were supported.

This changes the prior stronger preflight expectation. The owner explicitly approved **Use generic native path** after being told that an unsupported follow-up may halt after the initial choice has taken effect. `legal_actions_complete` certifies the current decision, not every future consequence. Known unsupported current alternatives still invalidate the whole executable decision; do not silently omit them.

If every possible consequence must be guaranteed supported before any choice, a stronger native/upstream capability and gameplay-lifetime contract is needed. Building global task interception or auditing every event/listener is not the simple solution requested here. Arbitrary third-party mods are outside the first compatibility target.

## Approved small first implementation

- Start from accepted offline snapshot `/tmp/jev-m2-late-cleanup/`, retaining the combat teardown and late-run invalidation repairs.
- Replace only the stopped Byrdonis-specific delta, preserved at `/tmp/jev-m2-byrdonis-paused/`; do not discard unrelated work.
- Remove event/callback-name allowlists for the supported ordinary native path; retain exact current option identity, single-callback, generation and input checks.
- Use the same owned option bindings for observation and dispatch. Keep original task receipts and existing compatible child handlers.
- No new Harmony targets, selector-authority expansion, custom minigame implementation or event-combat instrumentation in this initial slice. Present any necessary expansion separately.
- Validate an ordinary effect, a multipage choice and an existing awaited deck selector, including previously unlisted native event classes without adding per-event code. Check stale/reordered choices, delayed native input, child decisions while root pending and failures after state changes.
- Retain all relevant combat/reward/cancellation regressions. Managed checks and source inspection remain distinct from parent-owned native gameplay acceptance.

No implementation or installation occurred during the research. The subsequently authorized implementation is now complete and independently reviewed offline: [implementation](../evidence/m2/generic-events-implementation.md), [review](../evidence/m2/generic-events-review.md). Candidate `0cd0c0bbf28a3a6565aa0b500c34967b1d623e051dcffa71f27754b5579035aa` passed 1842 supplied and 83 independent checks and a byte-identical rebuild. Parent compared all 19 candidate snapshot files and 28 build inputs with current source and reran the 83-check driver successfully. No new hooks/framework; six-file delta, four compiler inputs. The known withdrawn O2 external-producer failures remain separately classified, not passed.

Unsupported-surface diagnostics block dispatch while the surface is unsupported; they are not a newly permanent failure latch. Fault/cancellation failures remain sticky. Human resolution of an unsupported surface can allow existing task/ownership checks to progress; the bridge does not retry or click through it. A newly visible ordinary page does not bypass its still-pending root task.

The owner subsequently approved installation and a fresh diagnostic run on modded profile 2, including UI setup to the first map. Candidate `0cd0c0bb…` is now installed. **Bounded native PASS:** lethal combat → retained unclaimed rewards → Unknown room → **The Legends Were True**, without the old cancellation halt. Both choices and public rules were exposed without per-event code; Nab the Map added Spoils Map (deck 10→11), stale reuse of its version was rejected409, and a separate fresh Proceed returned to map. [Live evidence](../evidence/m2/generic-live/README.md) contains 196 hashed captures, 20 accepted diagnostic POSTs and one deliberate rejection. These are parent-selected diagnostics, not Jev/M4/M5.

The old Byrdonis run was replaced without selecting either option. Current checkpoint: fresh seed `YXRKN2F6AQHC`, floor 3 map, 75/80 HP, 113 gold, 11 cards. Only one event-effect branch is live-verified; multipage/deck-selector and other required-family gates remain outstanding. Full M2 remains incomplete.

## Sources and verification

- [Native lifecycle research](../evidence/m2/generalized-events-native-research.md): exact native methods/IL, structural inventory, task propagation, selectors, detached gameplay examples and reproducible probe commands.
- [Observation/design research](../evidence/m2/generalized-events-design-research.md): current bridge paths, alternative comparison, schema reuse, source line citations and migration limits.
- Fixed source reference: `/tmp/jev-m2-late-cleanup/source/`; accepted offline DLL `3828de49ec906f8e22502452b7cf30d8f429df48e4e7e68fb8a8317640c6f67a`, not installed.
- Parent spot-checked the Tinker-specific gates, snapshot/native index mismatch, contextual selector guard, native appended option task and detached event-combat entry against the cited source/IL. This synthesis does not elevate sampled research into exhaustive event coverage.
