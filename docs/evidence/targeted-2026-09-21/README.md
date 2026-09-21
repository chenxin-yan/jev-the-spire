# Targeted bridge correctness QA — 2026-09-21

## Authority and current status

The user explicitly approved separately labeled, host-selected **legal-action QA**, then stopping after correctness verification. This is not Jev inference or autonomous gameplay. No gameplay strategy, production prompt, provider settings, probabilities, save data, or unlocks were modified. No uncertain accepted mutation was retried.

**Bounded correctness verification complete; gameplay stopped.** The first QA run exposed two treasure defects and stopped technically. The repaired, reviewed, installed candidate subsequently passed live whole-choice, Skip, claim and room-exit checks, plus a native shared event. Earlier selector-resume and Smith checks also passed. This archive is not a claim of exhaustive game support or playing strength.

## QA 1: passing mechanisms, then a preserved technical stop

Profile 2, Standard Ironclad A0, seed **5Q4V83QRSFPV**, epoch `162f86c6714243b59889a77c368f733a`, installed bridge SHA `257294dd1be62a0b7ae85820ca5479a6d0d54bf9f76a764aaf50063fbaa0ab13` (source `9fd5b40`).

`qa-1/journal.jsonl` retains complete observed snapshots and the actor `parent_targeted_qa`: **104 legal decisions, 104 accepted 202 dispatches, 104 unique consumed versions, zero model calls**. Bounded combat transit was QA-only and stopped at noncombat/selection boundaries. Scripts are preserved for provenance, not instructions to replay old versions against a live game.

Passed live assertions:

- **Potion selection/resume:** Colorless Potion at `:78` → three-choice selector `:80` → Seeker Strike in hand and potion consumed at ready combat `:83`.
- **Combat-pile selection/resume:** Seeker Strike `:83` → complete three-card `combat_pile` selector `:85` → selected Strike in hand, exact draw/damage effects and no pending mutation at `:88`. This is the shared mechanism used by Headbutt, **not literal Headbutt or repeated pauses within one action**.
- **Smith:** full ten-card grid, initial cancellation without deck/HP/option changes, preview cancellation, confirmation upgrading exactly Bash, then ready rest/map (`:218` through `:232`).
- **Negative transport:** unknown label 422 and stale version 409, with no mutation or version consumption. The initial scratch test incorrectly expected 409 for an unknown label and failed; native contract inspection corrected it to 422. Both original and corrected logs are retained. The journal therefore contains two unknown-label rejections and one stale-version rejection.

Offline rechecks (all exit 0):

```sh
python3 docs/evidence/targeted-2026-09-21/qa-1/check-resume.py
python3 docs/evidence/targeted-2026-09-21/qa-1/check-smith.py
python3 docs/evidence/targeted-2026-09-21/qa-1/audit-qa.py
```

Whispering Hollow and This or That are ordinary events: pinned native getters return false for `IsShared`. They do not establish shared-event coverage.

### Treasure failures

1. **Incomplete choice publication:** `open_treasure` at `:294` was accepted. Snapshot `:296` marked a claim-only relic catalog complete; `:297` added Skip without any intervening dispatch. The parent's stale-version check prevented the attempted `:296` claim **before POST**. No relic was taken.
2. **Skip ownership:** at stable `:297`, both Take Regal Pillow and Skip were complete/legal. One `proceed` was accepted at `2026-09-21T01:51:57.639Z`; `:298` halted `treasure_proceed_identity_unverified`, mutation pending, no legal actions. No retry, continuation, or failure reset occurred. Final readback stayed identical. The native map became visible, but that does not prove bridge completion.

`qa-1/check-halt.py` deliberately fails against the immutable failed snapshot (exit 1); it is a recorded-state sentinel, not an engine replay. The native screenshot is `treasure-readiness/skip-halt.png`. The failed run was closed natively before replacement; its technical-failure classification is preserved.

**Historical qualification:** autonomous run 4 had no bridge halt, but its Regal Pillow claim at `:275` was `singleton_only`, not Jev inference. The later readiness finding invalidates that claim as evidence of complete treasure choice publication. Raw run 4 records/counters remain unchanged; the source hash and exact extracted records are in `treasure-readiness/run4-historical-treasure.json`.

## Repairs and primary evidence

Native v0.111.0 `sts2.dll` SHA **9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4**.

- **Whole-choice readiness:** wait for the already captured `EnableSkipAfterDelay` task to succeed, not merely exist. Native IL enables Proceed before completing that task. Do not wait for the chest root, which awaits selection; do not manufacture a timer or force a reward claim. Parent RED exit 134, then 2,844 native checks and independent review with no issues (`treasure-readiness/`).
- **Native singleplayer Skip:** `OnPicked(null)` sets `_singleplayerSkipped` and returns without awards. Consequently Began/Finished and OpenChest remain parked. The old completed-pick/requires-awards invariant rejected a legitimate native branch; simply suppressing that error would leave ownership pending forever.
- **Exact Skip endpoint:** require the current identities, ordered relic-reference identity, a native false→true Skip receipt, and the exact successful pick's `AfterFinished`. Track that original pick work as the completion barrier while retaining/checking the parked root and every original failure through Proceed/map completion. No awards/offer capability is added to Skip. Claims, unopened Proceed and extra rewards retain their existing lifecycles.
- **Delayed execution:** parent challenge found that enqueue can precede actual execution while a prior executor batch finishes. The final adapter requires synchronous enqueue/Proceed receipts, not synchronous `LocalSkip` completion. Real operation/session tests retain ownership through unavailable/pending work and early Proceed/map, then release only after the exact successful receipt. A compiled wiring check rejects the removed immediate-completion condition.

Source **58197a6**, three files: `TreasureOperation.cs`, `McpMod.TreasureActions.cs`, `tests/check-bridge.sh`. No TypeScript, prompt, dependency, or gameplay-policy change.

Worker `d2342f61-148e-4875-8a04-0d2f0fd39f2e`, initial reviewer `ac054b78-ebb1-44b4-a820-f17c90d457d9`, timing challenge `c7168c95-9420-4ae8-95b3-7913d840856d`, final review `4d0babcd-6d36-4941-a67c-0f0bc98b72b4`; workflow `1227e62e-e0e4-434a-8048-7c99a71f69c3`. Final verdict **OK with notes, no issues**: timing P1 and diagnosis P2s closed. Live acceptance was outstanding at review time and was subsequently completed below.

Original reports are preserved verbatim. The corrected report fixes the worker's exception-swallowing claim and mistaken cancellation source, and qualifies dispatch acceptance and historical coverage. `treasure-skip/parent/review-fixes.md` distinguishes the delivered source from the historical worker candidate.

## Verification and installation

- Worker real-gate RED: exit 134. Three mutations failed and were restored; worker final 2,932 native checks.
- Parent delayed-dispatch RED: exit 134 at the intended compiled-wiring assertion against the worker candidate.
- Parent final: **2,949 actual-DLL checks, 57 application tests / 210 assertions; build (zero warnings), lint, format and typecheck all exit 0**. Commands/exits and raw logs: `treasure-skip/parent/final/`.
- These managed/metadata checks do **not** execute Godot/Harmony. The earlier discarded callback fixture's unexplained exit 139 remains a historical limitation, not positive proof.
- Installed atomically at **2026-09-21T02:41:28.688199Z**, after native close and verified game/listener absence. New DLL **1ebcd12431dd993eba1c10161412db49bd827a02dc98b6f9a860d0d0f5bb2102**, source `58197a6`, embedded build revision `b2046f2`. No rebuild merely to change revision metadata. Receipt/backup paths: `treasure-skip/installation/installation.json`. No binaries are committed.

## QA 2: corrected Skip and shared event pass live

Same installed candidate, Profile 2 / Standard Ironclad A0. Seed **Z9HGUUZA1DXW**, fresh native epoch `3eb22b954a2240068ca10044f0baab0d`. **66 legal decisions / 66 accepted 202s on unique versions, zero model calls, no bridge halt.**

- **Native shared event:** Dense Vegetation's installed `get_IsShared` returns true (`qa-2/dense-vegetation-shared.il`). Choice `:55` completed with exactly +96 gold / −8 HP, ready event Proceed at `:58`, then ready map at `:61`. Both accepted once, no pending mutation on the ready continuations. This establishes the shared singleplayer choice/task path, not every shared-event-specific interaction.
- **Whole-choice publication:** chest open `:193` → `:194` waiting, incomplete, no actions → first complete catalog `:195` with **Take Strike Dummy and Skip together**. No observed claim-only complete catalog.
- **Skip:** `:195 proceed` accepted once → ready map `:198`, no pending mutation, player inventory unchanged and no Strike Dummy acquired.
- **Room exit:** `:198 choose_map_node:0` → ready rest site `:202`, no pending mutation or halt. This exercises the later native room-exit cleanup after the intentionally parked chest root was released.

`qa-2/check-shared.py`, `check-treasure.py` and `audit-qa.py` all pass. Full journal, command logs and final snapshot/screenshot are retained. The healthy QA run was deliberately saved/quit and abandoned through native menus to start the final claim regression; this is not a natural defeat or technical failure. Setup/menu actions are separate from the 66 gameplay dispatches.

## QA 3: corrected claim path passes live; stop

Same installed candidate and profile/mode. Seed **BBK5PF16S0X4**, fresh native epoch `8703e7be650542d2820a473a9fb7e792`. **47 legal decisions / 47 accepted 202s on unique versions, zero model calls, no bridge halt.**

- Chest open `:133` → `:134` waiting/incomplete → `:135` complete **Take Happy Flower and Skip**.
- Explicit QA `claim_treasure_relic:0` at `:135` was accepted once. The player's relic list gained exactly Happy Flower; HP, max HP, gold, deck and potions were unchanged. Only Leave treasure room remained.
- A local attempt to use version `:136` for Proceed was refused **before POST** when a fresh observation returned `:137`. The complete legal set was unchanged; the only payload change was omission of the empty `treasure.relics` field. The parent inspected the fresh state, then sent exactly one legal Proceed at `:137`; no uncertain accepted mutation was retried.
- Proceed completed at **`:140`, ready map, complete legal set, no pending mutation**. Fresh final readback stayed identical. Gameplay stopped there; no background QA/autonomous driver remains.
- Transit also completed Sapphire Seed's full ten-card upgrade selection/preview/confirmation and Rest with Stone Humidifier's native max-HP effect. These were legal QA choices, not Jev behavior.

`qa-3/check-claim.py` and `audit-qa.py` pass. All positive live checks can be rerun offline without game/provider access:

```sh
python3 docs/evidence/targeted-2026-09-21/qa-2/check-shared.py
python3 docs/evidence/targeted-2026-09-21/qa-2/check-treasure.py
python3 docs/evidence/targeted-2026-09-21/qa-2/audit-qa.py
python3 docs/evidence/targeted-2026-09-21/qa-3/check-claim.py
python3 docs/evidence/targeted-2026-09-21/qa-3/audit-qa.py
```

## Sign-off boundary

The bridge is ready for autonomous use **within its supported singleplayer boundaries**, with the requested live mechanisms verified and no strategy/prompt optimization. Unsupported or unreadable interfaces remain fail-closed. This is not exhaustive coverage of every card/event/relic combination, repeated pauses in one action, or multiplayer; literal Headbutt on the final build was not replayed, while its shared combat-pile resume mechanism was exercised via Seeker Strike. Historical halts remain failures, and normal autonomous defeats remain gameplay outcomes, not bridge failures. No further play or indefinite encounter hunting was performed after acceptance.
