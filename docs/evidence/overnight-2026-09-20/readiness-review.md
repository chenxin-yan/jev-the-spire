# Independent readiness review

## Review

**No issues found.**

- **Correct — map readiness is whole-decision readiness.** `mod/STS2MCP/McpMod.Contract.cs:129–143,201–220` marks an observation waiting when any otherwise-eligible travelable point is unreadable. Later readable points cannot reset it. Finalization removes every action, not merely the unreadable alternatives.
- **Correct — potion filters preserve native eligibility.** `mod/STS2MCP/McpMod.LegalActions.cs:305–343` retains dead/player-disabled/queued, `_isUsable`, usage, custom-usability and target-validity exclusions. Only the existing visibility exclusions now invalidate the whole observation. Missing holder/usability metadata still halts.
- **Correct — POST cannot consume a surviving sibling.** `McpMod.Contract.cs:207–223,306–318` clears the shared serialized/executable action list and recaptures it before acceptance. `BridgeProtocol.cs:345–362` rejects labels absent from that list, including owned-child dispatch, without releasing the pending parent.
- **Correct — bounded scope.** The retained diff contains only the two production files above and `tests/check-bridge.sh`. No interception, ownership, selector, tutorial, provider or dispatch authority was expanded. No edits were made during this review.
- **Merge verdict: OK with notes.** The scoped offline readiness gate is satisfied; live acceptance is not.

## Reachability and completeness assessment

I read the required handoff/domain/scope documents, current production sources, preserved baseline sources, `/tmp/jev-overnight-readiness/final.diff`, added tests, and relevant native IL evidence.

The map-plus-potion concern is supported by the pinned-native control flow:

- `map-open.il`, IL0547–0579 sets points alpha to zero; IL1102–1150 schedules its delayed fade; IL1157 recalculates travelability before IL1383 emits `Opened`.
- `proceed.log`, IL0000–0028 enables travel, calls `Open(false)`, then returns `Task.CompletedTask`. The bridge’s original Proceed receipts do not await point readability (`McpMod.EventActions.cs:229–254`).
- `container.log`, `holder-create.log`, `potion-writers.log` and `potion-callers.log` support potion usability being independent of map fade. `popup.log` shows discard eligibility independent of combat-only use.
- Baseline map filtering could therefore remove map alternatives while retaining discard. The unchanged CLI accepts a complete/nonwaiting singleton without inference (`src/loop.ts:136–152,221–227`).

This establishes the control-flow risk, **not an observed live incident**.

For potion targets, `potion-model.log` and `target-guards.log` show native validity does not imply canvas readability. The new gate correctly waits instead of offering siblings when an otherwise-valid target fails the existing visibility filter.

The completeness claim remains appropriately narrow: existing map/target alpha thresholds and holder visibility semantics are unchanged. It is not certification of all action surfaces or full-animation completion.

## Tests and limitations

Directly reviewed:

- `tests/check-bridge.sh:1201–1255`: compiled production helper/finalizer tests covering all/partial unreadability, earlier/later siblings, sticky waiting, normal/child rejection, pending-parent preservation and subsequent complete observations.
- `tests/check-bridge.sh:1658–1688`: compiled wiring checks for the map predicate, both potion sites and POST recapture.

Retained execution evidence reports:

| Check | Result |
|---|---|
| Baseline regression | Expected assertion failure, exit 134 |
| Updated harness | 1950 checks, exit 0 |
| Original retained harness | 1909 checks, exit 0 |
| Build | Exit 0; zero warnings/errors |

**I did not execute commands or independently rehash binaries.** Results above come from inspected logs and `commands.jsonl`. I confirmed the local main ref is the supplied baseline; current named sources agree with the reviewed diff. Frozen status/index evidence reports exactly three modified files and an empty index, but is not a fresh reviewer-run Git inventory.

The tests use readiness booleans, not a real Godot scene. IL call-presence checks supplement source review; they do not prove engine scheduling or execute the full observation/HTTP path. Persistent unreadability intentionally reaches the existing wait timeout.

Historical O2 remains **74 checks / two failures**, withdrawn as a demonstrated production blocker—not green.

## Gate decision

Safe to advance to **parent-owned acceptance**, after rerunning the recorded affected offline checks and confirming current diff/artifact identity. No code blocker was found.

Provider integration, fresh-Neow lifecycle, visible legal-set parity and native completion still require their separately authorized live gates. This review does not authorize installation or establish bounded-QA/full-run success.