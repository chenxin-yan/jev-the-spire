# Shared selection ownership and action lifecycle repair

## Scope and cause

This follows the preserved [rest-trial technical stop](../rest-readiness-2026-09-20/README.md), not a continuation of that attempt. The user requested shared repairs instead of event/card-specific exceptions.

Pinned native `sts2.dll`: `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4` (v0.111.0). The shared `EventModel.SelectCardsToAddToDeckFromGrid` creates a `BlockingPlayerChoiceContext`. The bridge previously masked that context even inside its own retained event operation, so the resulting selector had no owner. The historical Brain Leech failure was one instance, not the implementation boundary.

Repair source commit: **`b246f7e`** (local only). The repair:

- Admits a Blocking context only through the exact retained, open event/treasure operation, matching ambient owner and native identity checks. Unregistered GameAction and other context classes remain masked.
- Adds bundle/relic selector producers to the existing exact-task boundary mechanism.
- Gives ordinary actions a retained-work owner before native dispatch. The scoped rest adapter retains the original detached `AfterSelectingOptionAsync` Task; pending/faulted/cancelled work cannot become successful completion.
- Routes unreadable native-legal combat targets through existing whole-decision readiness, rather than publishing a pruned legal set.

There are no event/card-name branches, blanket token inheritance, global Task interception, or native behavior replacements. Existing adapters remain necessary because native surfaces use different protocols.

## Verification and review

- Baseline: 1,972 native checks. New tests against the baseline DLL fail at the contextual-prefix regression.
- Final candidate: **2,032 actual-DLL checks**, zero-warning build, **50 app tests / 193 assertions**, lint, format, and typecheck all exit 0. Exact commands/exits are in [`offline/final-gates/commands.jsonl`](offline/final-gates/commands.jsonl).
- Five deliberate mutations fail; ambient ownership, retained work, and context-class mutations fail behavioral assertions. Combat/rest-dispatch mutations fail compiled-wiring assertions, not actual Godot interactions.
- [Independent review](offline/review.md): **OK with notes**, no established P0/P1. Its sole P2 finding was corrected in both production and test comments.
- Reviewed pre-comment DLL: `defad43796b942d96c0b16695aeb27ba5cd83844ae65e0218de0c6b823e97094`. Final built/installed DLL after comment correction: `9bcaa0b1d837f390d7a82662f441c8c8157752468d994cdc8d2ae98be187c09a`. Built from `96af9eb` plus [`offline/recovery/final.diff`](offline/recovery/final.diff); embedded source revision is that base, not a later evidence commit.

### Declining a selection is not Task cancellation

The recovered writer initially flagged absence of a rest receipt as ambiguous. Full native IL resolved this: Smith permits an empty/cancelled selection, `ChooseOption` returns false without consuming the option, and `SelectOption` skips the post-select producer, waits a frame, then re-enables options. On success it launches the detached producer and returns without awaiting it. The bridge already exposes `cancel_selection`; requiring a receipt unconditionally would break that valid choice. See [`rest-sync-full.il`](offline/recovery/rest-sync-full.il), [`smith-onselect-full.il`](offline/recovery/smith-onselect-full.il), and the independent review. The writer report is retained unchanged as historical evidence; its proposed unconditional receipt requirement was **not adopted**.

### Workflow recovery

Workflow `a0783863-d198-40bd-bfd0-fe8843c5ab53` completed two scouts, then worker `f1285af4-54e0-404d-a63a-511b7b0320cc` timed out after 1,800,000 ms while preparing its handoff. Seven modified files and the partial diff were captured on `main` at `96af9eb`. No installation occurred at that point. Same-protocol recovery `b97df111-05df-4b71-bde3-148da14e2469` resumed the writer for a report only, then ran a fresh independent reviewer. No CLI fallback was used. The parent independently reran all final gates before installation.

## Limits

Offline fixtures and metadata checks do not initialize Godot or certify native UI/Harmony execution. In particular, real identity success, successful/duplicate rest receipts and native combat target enumeration are not executed by those fixtures. Generic card-holder clickability, unsupported context classes, Mend targeting and non-treasure relic selectors remain outside this repair. No exhaustive game coverage is claimed.

## Bounded live trial — genuine death, partial coverage

After normal Save and Quit → Quit and verified process/listener absence, the parent backed up the previous DLL and replaced only the nested mod DLL. The installed hash matched the final candidate. Normal Profile-2 Abandon → Singleplayer → Standard → default Ironclad confirmation created seed **`77SVP3CVQFHQ`**, A0; no seed/save/settings edits or restored checkpoint adoption. Installation/setup receipts and screenshots are in [`live/`](live/).

One fresh start, capped at 150 accepted actions / 20 minutes, with each invocation capped at five minutes. Started **19:29:12 UTC**, ended **19:34:45 UTC**, before the 19:49:12 deadline. The five invocations accepted **10 + 20 + 20 + 20 + 11 = 81 actions**. The first four exited 0 at their action bounds; the fifth exited 0 with `terminal`, not a technical halt.

Jev chose Lead Paperweight at Neow, then chose to cancel the owned card selector. Jev subsequently claimed floor-2 gold and Rupture, cleared fights, left the floor-4 shop without opening inventory, skipped later rewards and selected the next routes. The parent made no gameplay decisions. Two invalid probability distributions were rejected; each received the existing single re-ask against the same snapshot. No probability normalization or uncertain POST replay occurred.

Totals: **61 application-level model calls** (59 successful decisions, two invalid-answer calls), **22 complete-singleton bypasses**, **168,382 reported input / 5,005 reported output tokens**. Usage was not returned for the two rejected calls, so these are not complete billing totals; transport attempts and cost are unknown. All 81 dispatched labels were legal and returned HTTP 202. All 88 logged waits exposed zero actions. The [offline accounting checker](live/check-accounting.py) passes; an illegal-label mutation is rejected (retained negative-test output).

Final readback: **`game_over`, `terminal:true`, `mutation_pending:false`**, no legal actions. The screenshot confirms **death at act 1 floor 7, 0/80 HP, 117 gold, 11 cards**; “Conquered” is the defeat screen, not a victory. Game and controller were not restarted after this terminal outcome.

**Live covered:** Neow owned card selector/cancellation, combat, card reward selection, reward-to-map continuation, shop exit and genuine terminal recognition without a bridge halt. **Not covered:** the previously failing ordinary-event Blocking grid, rest entry/Smith/cancellation/post-select work, bundle/relic selectors, or the unreadable-target condition itself. Therefore this is **not a live pass for the rest repair or exhaustive generalized-event support**. Another bounded fresh run requires a new execution decision; unused action/time allowance does not restart this terminal run.

Earlier technical stops remain immutable. The retained runner is historical execution evidence, not an authorized replay command. `SHA256SUMS` covers the retained evidence except the manifest itself.
