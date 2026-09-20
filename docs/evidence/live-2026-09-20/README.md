# Parent-supervised Jev run — 2026-09-20

## Bounded QA: PASS

Owner reported the Vercel prerequisite resolved and authorized continuation of the existing
handoff plan. Historical payment failure remains in `../overnight-2026-09-20/`; it is not
rewritten as success. Current implementation baseline: `3af9351`.

- Provider-only retry: one application evaluation, 914 ms, full ten-label distribution,
  3130 input / 135 output tokens, no warnings. Fixed configured model `typesafe-ai/jev`;
  this is not backend attestation. Confidence absent. See `provider-attempt-2/`.
- Installed the exact offline-reviewed bridge **`4b5b756f2022a52d88b7338ad977fc70c82fa90718fa019b0a3485a7f791bcf3`**
  only at the nested existing mod location, after normal quit and verified process/listener
  absence. Native assembly retained pinned **`9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`**.
  Previous bridge backed up under `/tmp/jev-resume-2026-09-20/previous-install/`.
  `installation.json` records hashes and the AppleEvent -128 quit result followed by confirmed
  exit. No other mod file was modified; binaries are not committed.
- Parent saw **Profile 2**, Running Modded / one loaded mod before Abandon. Normal UI setup:
  Abandon + confirmation → Singleplayer → Standard → Ironclad → confirm. No seed entry,
  save/settings/tutorial edits or profile-1 access. Fresh seed **`0RBY5896E908`**, A0.
- Parent setup stopped at initial Neow options. Every subsequent gameplay choice was either
  Jev-selected over the full current legal set or the approved forced singleton. No rescue,
  diagnostic POST, replay or host strategy occurred.

### Verified path

| Segment | Bound | Accepted | Model / forced | Post-segment evidence |
| --- | ---: | ---: | ---: | --- |
| `qa-1` | 1 | 1 | 1 / 0 | Jev chose Precise Scissors; owned removal selector exposes all ten cards, parent pending |
| `qa-2` | 3 | 3 | 2 / 1 | Jev selected Strike and confirmed; forced Proceed → first map, both routes, deck 9, parent released |
| `qa-3` | 1 | 1 | 1 / 0 | Jev chose Monster `(3,1)` → three-slime combat, correct five-card hand and ten legal actions |
| `qa-4` | 12 | 12 | 9 / 3 | Round 4 ready; one slime remaining at 9 HP, player 69 HP / 5 Block / 2 energy |
| `qa-5` | 20 | 6 | 5 / 1 | Combat victory → all four reward alternatives → Jev chose Leave rewards → next map; intentional SIGINT |

**23 accepted actions, 18 model application calls, five forced actions; one fresh start and
five CLI invocations.** Within approved 60-action / three-start / six-invocation bounds.
All invocations remained below five minutes. QA reported **47973 input / 1466 output tokens**;
provider-only smoke is separate. No billable-request count or cost is invented.

Jev deliberately left **11 gold, Flex Potion and the card reward unclaimed**. No parent
intervention corrected that strategy. Burning Blood healed 69 → 75 HP. The post-reward
map is `(3,1)`, floor 2, **75/80 HP, 99 gold, nine cards**, with next Monster `(3,2)`.

`qa-accounting.json` validates every logged selected label/distribution and singleton
provenance, all 23 HTTP 202 results, and the final readback. No invalid-answer re-ask,
stale decision, rejected/uncertain POST or technical halt occurred during QA.

### Completion, readiness and stop control

202 and the CLI boundary were **not** treated as completion. Separate GET readbacks and
UI observations followed segments. The Neow removal selector was a complete owned child
while its event remained pending; first-map readback then showed parent release. Existing
exact Chosen/Opened receipts and tutorial checks remained enforced by the installed code.
No tutorial/reset occurred. Combat waits exposed incomplete empty action sets. After reward
Proceed, `qa-5.jsonl` explicitly records map waiting/incomplete/zero actions before readiness.

`run-qa-5-to-map.py` supervises the unchanged CLI and sends real **SIGINT** on its first
post-reward `observed: map` line. It supplies no choices or transport substitution. CLI
recorded `aborted/SIGINT`, exited **130**, and dispatched **no next-map action**; the apparent
process failure is the intended kill-switch outcome. It also retained independent 295-second
SIGINT / 300-second kill fallbacks, neither reached. Readback afterward showed complete,
nonwaiting map input with `mutation_pending:true`: the supported owned map child remains
ready while the previous combat/reward parent awaits travel. This is not a completion fault.
The next invocation is an explicit supervised continuation after that verified stop, not
an automatic restart on an unknown failure.

UI parity was checked at initial Neow, the ten-card selector, first map, combat entry,
mid-combat and final map. Screenshots and complete snapshots are retained. Some short
select/confirm/proceed/reward transitions occurred faster than parent screenshots; their
native observations and chosen full action lists remain in JSONL. **No claim of per-action
visual certification or exhaustive bridge coverage.** No potion was acquired, so the map
fade-with-potion combination remains offline-regression verified, not live-stress tested.
Broader M2 and later-act/boss authority are unchanged.

## Full-run attempt: TECHNICAL STOP (not completed)

After QA passed, parent continued the **same entirely Jev-owned run**, with no new start.
Attempt began **17:44:12 UTC**, stopped **17:48:43 UTC**, before its **19:44:12 UTC** deadline.
Three supervised CLI segments retained the existing five-minute deadline and 20-action cap.

| Segment | Accepted | Model / forced | Outcome |
| --- | ---: | ---: | --- |
| `full-1` | 20 | 14 / 6 | `max_actions`, exit 0; floor-4 combat readback ready |
| `full-2` | 20 | 14 / 6 | `max_actions`, exit 0; floor-6 combat readback ready |
| `full-3` | 17 | 13 / 4 | `halted`, exit 1; `ordinary_mouse_input_unverified` entering floor-7 rest site |

Full-attempt segment totals: **57 accepted actions, 41 model calls, 16 forced actions;
104875 input / 3153 output tokens**. Including the QA opening: **80 actions, 59 model calls,
21 forced; 152848 input / 4619 output tokens**. The successful provider-only smoke adds one
application evaluation and 3130 / 135 tokens, separately. SDK transport/billing request count
and monetary cost are unavailable. Every recorded gameplay inference succeeded on application
attempt 1; no rejected/uncertain POST, stale decision or invalid-answer re-ask was recorded.

Jev cleared floors 3, 4 and 6, left the floor-5 shop without opening its inventory, then
claimed 13 gold and **Primal Force** from floor-6 rewards. Jev chose the rest site from the
three offered map routes. Parent supplied no gameplay selection or strategy correction.

### Exact stop and subsequent readback

The final dispatch was `choose_map_node:1` at version `…:230`, accepted once at 17:48:41 UTC.
CLI observed waiting at `…:231`, then **unsupported `…:233`**, and stopped at 17:48:43 with
`ordinary_mouse_input_unverified`. See `full-3.jsonl`, `full-3-stdout.txt` and
`full-3-stderr.txt`. No rest option was inferred or dispatched, and no CLI was restarted.

Read-only capture afterward (`full-final-readback.json/png`) showed **rest_site `…:234`**,
act 1 / floor 7 / A0, **32/80 HP, 112 gold, ten cards**, Rest and Smith both offered,
`waiting:false`, `legal_actions_complete:true`, `mutation_pending:false`, `terminal:false`.
UI showed those same two choices. The game is left there untouched. Later readiness does
**not** erase the earlier halt or authorize recovery of this attempt. It was neither death
nor victory, and is not evidence of a completed autonomous run.

### Remaining blocker — evidence versus hypothesis

Confirmed: `McpMod.OrdinaryActions.cs:22-27` throws that reason when a visible/actionable
ordinary control fails its mouse-input filter gate. Rest-site enumeration calls this shared
helper for rest buttons and Proceed (`McpMod.LegalActions.cs:74-88`). The later successful
GET demonstrates that this refusal was not permanent in this room.

Hypothesis: a transient rest-entry input transition is being classified as unsupported
instead of whole-decision waiting. The captured error does **not** identify the precise
control/filter or native animation responsible; no causal proof or fix is claimed. A focused
follow-up must trace the pinned native rest-button/Proceed lifecycle and reproduce the actual
wiring before changing readiness classification. Preserve the full-choice gate; do not simply
prune the temporarily unreadable option, insert a delay or blindly retry the CLI. No new
interception, authority expansion, runtime patch or additional full attempt was made.

### Verification and scope

- `python3 docs/evidence/live-2026-09-20/check-accounting.py`: exit 0; all eight gameplay
  segment logs checked for selected-label/full-distribution and singleton provenance,
  single accepted dispatch per recorded decision, usage totals and expected stop outcomes.
  A temporary copy with one probability label deleted correctly failed (exit 1).
- Fresh closeout lint, format, typecheck and tests all exited 0; **50 tests / 193 assertions**.
  Exact commands/results and format's evidence-directory exclusion are in `verification.json`.
- Application and native implementation are unchanged since independently reviewed `3af9351`.
  Native build and 1950 current / 1909 retained checks were not repeated for this evidence-only
  closeout; results remain in `../overnight-2026-09-20/`. They do not certify rest entry.
- `SHA256SUMS` covers retained public evidence except itself. Binaries, credentials and saves
  are excluded. Captured live harnesses are historical artifacts, **not safe rerun commands**;
  only `check-accounting.py` is an offline evidence check.
- QA remains a bounded path pass, not exhaustive M2 coverage. Potion readiness is still only
  offline-regression verified; merchant inventory, rest selection, treasure, later-act and
  boss transitions were not validated by this run. M2 is not closed.

No push, issue update or other publication is authorized. Credentials are consumed only by
Bun/SDK; no agent inspects or prints them. Historical evidence remains intact.
