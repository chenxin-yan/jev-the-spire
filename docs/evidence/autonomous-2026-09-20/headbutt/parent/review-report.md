## Review

**Scope:** Read-only review against `3e06aab7e3dd42d9924036d8127010f6327f93f9`. Inspected the frozen diff, production source, tests, worker report, saved failure, and native IL. Supervisor confirmed the five changed paths and byte-identical working-tree diff (`2bf8028415e38a2a2ebee7aebb82469fed072f1c04de113b59442eb2b468b791`). No edits, shell execution, or live access.

### Correct

- **Causal diagnosis is supported.** `run-1-stdout.log:91–104` records accepted Headbutt play followed by `unowned_selection_continuation`; `implementation/check-red.log` fails specifically on the registered-action wrapper admission. Native IL establishes the missing link: `OnPlayWrapper` constructs the Branching context (IL 1589), passes it to `OnPlay` (1613), and awaits through it (1624). Headbutt passes that context into `FromCombatPile` (0257). Its selector calls the existing base `CardsSelected` boundary (0922), rather than an unhooked override.

- **Authority remains explicitly registered and bounded.** `mod/STS2MCP/McpMod.SelectionHooks.cs:100–130` admits only an unbranched wrapper directly over a registered `GameActionPlayerChoiceContext`. Hook, Throwing, nested Branching, branched, unregistered, and closed registrations remain refused. No OwnerId/model-stack inference, general Task interception, or new Harmony target was added. Supervisor confirmed this shared card/hand/potion scope and the exact combat-pile screen were approved.

- **Branch transitions cannot preserve dispatch permission.** `SelectionOwnership.cs:34–51,94` captures/restores readiness with the async owner and transfers it to the lease. `McpMod.Contract.cs:203–219,328–339` checks readiness during observation and again before child acceptance. Native `BranchingPlayerChoiceContext.SignalPlayerChoiceBegun` stores `_createdContext` before completing its paused source, so the predicate becomes false before detachment. The mutation check removing lease readiness fails at this guard.

- **Exact task, cancellation, retirement, and freshness protections remain intact.** The original boundary Task is attached at `McpMod.SelectionHooks.cs:156–164`; completed/failed/stale leases are rejected and closed registrations removed at `SelectionOwnership.cs:139–185`. Root execution, visual completion, cancellation subscriptions, cleanup, and consumed versions remain governed by `BridgeProtocol.cs:315–427` and `McpMod.Contract.cs:314–339`. Existing tests retain fault/cancellation, selector reuse, foreign-owner, cleanup-failure, and new-epoch checks.

- **Combat-pile candidates match native behavior without weakening completeness.** `McpMod.LegalActions.cs:242–292` adds one exact screen type and derives candidates from its live pile/filter. Native `Create` leaves `_cards` empty; `UpdatePileContents` renders the filtered pile. The existing reference-and-multiplicity comparison remains mandatory (`BridgeProtocol.cs:123–134`): empty allocation waits; partial allocation halts. Native click/confirm handlers support the existing select/deselect/confirm enumeration. `FlashRelicsOnModifiedCards` returns immediately for the null `_cardResults` installed by this creation path.

- **Adjacent paths were checked.** Parent-supplied `commands-hand.il`, `hand-select.il`, and `hand-wiring.il` corroborate the existing hand modes, filter, replacement-at-cap behavior, confirmation, cancellation, and retained task boundary used by `McpMod.LegalActions.cs:294–327`. Blocking event/treasure admission remains unchanged. Ordinary, shared-event, reward, cleanup, and fresh-run guards were not relaxed; their existing regression checks remain present. No strategy or reward-policy changes appear in the diff.

### Verification

Inspected recorded results: baseline **2735** checks, targeted RED, final **2770** checks, **51** app tests passing, and build/lint/format/typecheck exits **0**. Supervisor independently reproduced the final gates and candidate hash.

These checks validate bridge policy, managed fixtures, and native metadata—not execution of the native engine.

### Findings

No issues found.

### Residual live gaps

The candidate still requires the parent’s live Headbutt acceptance test: complete discard choices, correct holder identities/input readiness, single-click completion, and release only after the original action finishes. Native animation timing, changing-pile windows, and newly admitted hand/potion continuations are not live-certified here. Large or temporarily incomplete grids remain deliberately fail-closed; nested Branching contexts remain unsupported.

**Merge verdict: OK with notes.**