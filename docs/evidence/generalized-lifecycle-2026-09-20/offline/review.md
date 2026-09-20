## Review

**Merge verdict: OK with notes.** No P0/P1 correctness issue established. Candidate remains uninstalled; this is not live certification.

### Correct

- **Shared contextual authority, not scenario hardcoding.** `ContextualSelectionOwner` admits registered GameAction contexts or explicitly supported Blocking contexts. Blocking admission requires the exact retained, open event/treasure operation, matching ambient owner, and its identity adapter. Other context subclasses remain masked (`mod/STS2MCP/McpMod.SelectionHooks.cs:96–125`). Event identity checks cover current run, player, room, scene, model and layout (`McpMod.EventActions.cs:109–121`). No blanket non-GameAction adoption was introduced.

- **Detached work is retained before synchronous production can escape.** `OrdinaryOwner` exists before `start()`. Both synchronous and delayed producers retain their original Tasks; release requires their successful completion. Fault/cancellation becomes sticky failure, and release closes the owner (`McpMod.NativeActions.cs:26–58`). `Track` does not poll or release before the holds are installed (`BridgeProtocol.cs:274–283,325–351`).

- **Rest receipts are scoped and bounded.** The postfix is inert without `RestScopes`; inside it, room/option/button identity and duplicate capture are checked. Capture failure is latched even when it occurs before session tracking, and cannot silently satisfy the hold (`McpMod.OrdinaryActions.cs:33–54`). Its retained run/player are checked against the existing rest-entry receipt (`BridgeProtocol.cs:226–232`). Released owners cannot accept late retained work.

- **Smith lineage is actually supported.** Native Smith calls context-free `FromDeckForUpgrade`; that command awaits the already-hooked grid boundary. Consequently the ordinary owner flows to the child without a contextual-prefix exception or Smith-name branch. Evidence: `recovery/smith-onselect-full.il:24–29`, `/tmp/jev-general-events-native/deck-select.il:438–447`, and `repair/target-visibility.log`. Exact leases and `AcceptChild` allow the child while its parent remains pending (`SelectionOwnership.cs:137–146`; `McpMod.Contract.cs:313–316`).

- **Boundary and readiness changes reuse existing mechanisms.** Bundle/relic Tasks use the existing boundary handlers (`McpMod.SelectionHooks.cs:44–52,134–145`). Combat target visibility now marks the shared decision waiting after native legality filtering; `FinishObservation` removes every executable sibling (`McpMod.Contract.cs:200–219,246–278`).

### Rest cancellation / missing receipt conclusion

The recovered handoff’s recommendation to require `scope.Captured` unconditionally is **not safe**:

1. Smith explicitly permits cancellation and returns `false` for an empty selection (`recovery/smith-onselect-full.il:18–20,66–72`).
2. `ChooseOption` propagates that result without consuming the rest option (`recovery/rest-sync-full.il:252–256`).
3. `SelectOption` skips the post-select producer, then awaits a frame and re-enables options (`ownership/rest-select-state.il:100–105,119–165`).
4. The bridge already exposes grid cancellation (`McpMod.LegalActions.cs:270–274`).

This is a successful **declined selection**, not a canceled Task. With the pinned installed hook and the primary Task’s owned execution context, successful native selection invokes the producer before primary completion; delayed selection remains inside the same awaited lineage. I found no concrete reachable lost-capture path in that chain. Failure-only holding therefore is not, by itself, a demonstrated premature-release defect. Do not add an unconditional `Captured` requirement.

### Finding: P2 — lifecycle comment misstates the successful path

**Location:** `mod/STS2MCP/McpMod.OrdinaryActions.cs:21–24`.

The comment says `SelectOption` returns “one frame later” after launching post-select work. Native IL branches around that frame wait when selection succeeds; the wait/re-enable tail belongs to the unsuccessful/declined path (`ownership/rest-select-state.il:122–165`, IL0339–0459).

**Smallest fix:** describe successful selection as returning without awaiting the detached post-select Task, and reserve the frame-wait description for decline. The implementation already handles synchronous production correctly; this is documentation-only.

### Validation and residual limitations

- Retained logs show a successful zero-warning build and **2032 actual-DLL checks** (`repair/build-final.log`, `repair/check-final.log`). Parent gate records independently show all recorded commands exiting zero. I ran no commands.
- Behavioral coverage is meaningful for context masking/identity-adapter ordering, pending-parent child acceptance, ordinary synchronous/delayed retention, and sticky faults/cancellation (`tests/check-bridge.sh:1579–1676,1714–1755`). Mutations **a, b, d** fail behavioral assertions.
- Combat’s fixture exercises the actual shared readiness/finalization/session machinery, **not native `AddCombatActions` enumeration**. Mutation **c** is caught by compiled-wiring inspection; mutation **e** likewise checks rest wiring. Neither establishes native runtime behavior.
- Rest postfix success, duplicate successful receipt, actual Godot identity transitions, and Smith’s complete native interaction remain unexecuted by these fixtures. Native target metadata and IL establish the intended seams, not successful live Harmony installation.
- Existing unsupported selector/context families and generic card-holder readiness gaps were not repaired or certified by this diff.

**Fixed:** none; review was read-only.