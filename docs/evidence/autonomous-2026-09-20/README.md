# Autonomous validation — 2026-09-20

## Authority and status

The user authorized full takeover, installation, testing and iteration after quitting the game. Scope remains modded **Profile 2, Standard Ironclad A0**, Jev-owned strategy and complete legal choices. No forced reward claims, model-policy changes, hidden information, credential inspection or uncertain mutation retries.

This archive is a checkpoint, **not a claim of complete autonomous coverage**. Run 1 stopped technically; the repaired candidate completed run 2 to genuine defeat without a bridge halt. Run 3 hit an adapter rounding mismatch, then a separate native receipt halt during its post-fix continuation. Later recorded outcomes supersede only status, not earlier failure evidence.

## Installations and setup

- Installation 1: reviewed shared-event source `f2490c9`, DLL `f84591d9a474b13ee3a50531a3b12edf5173815bc971c3bdae20f259b4a757d4`, installed at `2026-09-20T22:43:18.364007Z`.
- Installation 2: reviewed combat-selection source **`d0e2944`**, DLL **`37157f738b1b1bcd69d22b8f83c1de087f23c971ca7f1cbd4f6a16986e915e9d`**, installed at `2026-09-20T23:18:42.848775Z`.
- Native v0.111.0 `sts2.dll` remains `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`.

Both installs verified game/listener absence, backed up the old DLL, atomically replaced it and verified the resulting hash. `installation-1.json` and `installation-2.json` preserve receipts and backup paths. No binaries are committed. The second candidate was built at `3e06aab` plus the exact committed patch, not rebuilt merely to change embedded revision metadata.

Direct `.app` launch failed Steam initialization (missing app ID); native Quit followed by `steam://rungameid/2868840` worked. No app-ID-file workaround was added. Each prior halted attempt was abandoned through the native menu before a fresh run; the game records an abandonment loss, but project evidence retains the technical-halt classification. No halted selector was manually completed, adopted or resumed. Menu/setup actions do not count as Jev gameplay decisions.

## Run 1: Headbutt technical stop

Seed **`5P4NPFRRCJY6`**, epoch `c2a3073294f1400c8e2b7e8d92e35e5b`, opening 80/80 HP, 99 gold, 10 cards. Unchanged unlimited CLI:

```sh
mise exec -- bun run src/main.ts --log /tmp/jev-autonomous-2026-09-20/run-1.jsonl
```

**9 dispatches, 7 model calls, 2 forced singletons; 21,468 input / 437 output tokens; 16,108 ms**. Process exited 1. Scroll Boxes bundle selection and confirmation succeeded live, followed by Neow Proceed and map travel. Jev then played Headbutt against Shrinker Beetle at version `:23`; POST returned 202. The discard selector opened, but version `:25` halted `unowned_selection_continuation`, mutation pending, no legal actions. The screenshot shows all five discard cards; no mutation was retried.

`headbutt/live-red/check-halt.py` checks the exact captured symptom and intentionally exits 1. This recorded-state assertion is not an engine replay. Raw run records, stdout/stderr, opening snapshot and accounting are under `run-1/`.

## Causal repair and review

Native `CardModel.OnPlayWrapper` and `PotionModel.OnUseWrapper` pass an unbranched `BranchingPlayerChoiceContext` around the registered action context. The bridge previously masked every such wrapper. Headbutt passed that wrapper through `FromCombatPile` to the already-hooked base `CardsSelected` boundary, leaving no owner. This was a missing shared card/potion capability, not an identified shared-event regression.

The fix resolves only an unbranched wrapper directly over an explicitly registered GameAction. Its lease revalidates the wrapper on observation and dispatch: a later branch revokes permission before the detached action completes. Branched, foreign, retired, Hook and nested-wrapper contexts remain refused.

A second missing capability lay behind that halt: the exact `NCombatPileCardSelectScreen` type was not admitted, and its inherited `_cards` field is always empty. Parent approved its native pile/filter-derived candidate list, preserving whole-set reference/multiplicity matching, native select/deselect/confirm behavior and the original task. No new Harmony target, general Task interception or card-name exception was added. Native detached relic-flash code returns for this screen's null `_cardResults`; it does not add a gameplay completion task.

Workflow `4c37db7d-d484-4a99-a1b5-7d0ae889f015`: sole writer `6e160d61-8439-4201-b846-ab45d9b909a4`, fresh read-only reviewer `7b667359-40c0-4e3e-a37f-de57cd195525`. Review: **OK with notes, no issues found**. Parent supplied additional hand/grid IL so review covered the adjacent hand/potion scope, not only Headbutt. Frozen diff SHA256 `2bf8028415e38a2a2ebee7aebb82469fed072f1c04de113b59442eb2b468b791`; it matches the committed patch.

### Checks

- Baseline: 2,735 native checks.
- Causal ownership RED: exit 134, real patched admission with native wrapper/context objects, exact missing-owner assertion.
- Negative mutations: accepting an already-branched wrapper, using empty `_cards`, and ignoring lease readiness each failed; all mutations restored.
- Final worker and parent: **2,770 actual-DLL checks**, **51 app tests / 196 assertions**; native build, lint, format and typecheck all exit 0. Offline Bun commands use `--no-env-file`.
- Source `git diff --check`: exit 0.

Exact parent commands/exits: `headbutt/parent/initial/commands.jsonl`. Worker stages preserve intermediate harness failures as well as successful final results. Raw IL/log/diff whitespace is intentionally retained.

**Report correction:** the worker inferred non-reproducible builds from differing baseline hashes. That conclusion is unsupported: the earlier installed DLL was built at `58b053a`, whereas the current build embeds `AssemblyInformationalVersion("1.0.0+3e06aab7e3dd42d9924036d8127010f6327f93f9")`. Revision metadata is a known differing input. Parent rebuilt the frozen candidate and obtained the worker's exact final hash.

## Run 2: uninterrupted run to defeat

Seed **`U1R2DVVR8386`**, epoch `a8304fdf49b743f49eb94c3aab9785cb`. The unchanged unlimited CLI exited **0** after **93 dispatches, 69 inference attempts (68 successful model choices plus one invalid distribution), 25 forced singletons; 228,026 input / 5,646 output tokens; 242,359 ms**. The one invalid distribution succeeded on the existing single re-ask; no mutation retry occurred. Every choice matched exactly one accepted 202 dispatch.

Jev died to the floor-7 elite encounter (Phrog Parasite/Wrigglers). The terminal readback at `:277` says **Defeat**, complete legal set, no actions, no pending mutation. Screenshot: 0/80 HP, 130 gold, 16 cards. This is a genuine gameplay loss, not a bridge stop.

Live coverage included combat, map, battle rewards (five total reward-claim dispatches), card rewards, a two-card ordinary-event grid (Gorge), and Brain Leech's nested Colorless reward. The log does not record complete historical snapshots, so inventory deltas are not reconstructed beyond visible evidence. Headbutt, shared events and rest were not reached.

After terminal accounting, the parent used native Continue/Unlock/Confirm/Back to finish the earned Chapter 1 – Preon timeline unlock, then started another Standard Ironclad A0 run. These post-run/menu actions are outside Jev's 93 gameplay actions; no save edit or tutorial bypass occurred. Run 3 seed **`FFJPM9TD41CV`**, fresh epoch `5d5fb3ecc3024cc8b97f36e52a0f2424`, is in progress at this checkpoint.

Recheck accounting offline: `python3 docs/evidence/autonomous-2026-09-20/audit-run.py 2` (exit 0). It verifies one-to-one decision/accepted-dispatch matching, unique consumed versions and exact model/forced counts.

## Run 3: declared-rounding mismatch and resumed trial

Seed **`FFJPM9TD41CV`**, epoch `5d5fb3ecc3024cc8b97f36e52a0f2424`. The initial CLI segment stopped at floor 3 after **25 dispatches, 20 inference attempts, 7 forced singletons; 57,856 reported input / 1,474 reported output tokens; 68,713 ms**. Its final two attempts failed Effect DecisionModel's probability-sum validation. Neither dispatched a mutation. Reported usage omits rejected answers because no successful Decided result was returned.

Installed SDK `ai@7.0.107` validates declared probability rounding with tolerance `1e-6 + labelCount × 0.5 × 10^-decimals`. Gateway returns that rounding metadata; `effect@4.0.0-rc.116` DecisionModel has no rounding channel and repeated a fixed `1e-6` check. The offline real-Gateway/SDK fake-transport reproduction demonstrates an SDK-valid sum of 1.01 rejected by the original adapter. Historical rejected raw distributions were not captured, so their exact sums cannot be established. A single subsequent diagnostic inference returned declared two-decimal precision (sum 1 in that fresh sample), using **3,667 input / 137 output tokens**, with **no dispatch**. It is separate from gameplay accounting.

After upstream-first disclosure, the user explicitly selected **Use SDK validation (Recommended)**. Source **`55020c2`** removes the incompatible duplicate DecisionModel validator while retaining Effect execution and SDK validation. It preserves Jev's exact label and probability values, including ties, and explicitly requires a full distribution (the SDK alone permits omission). Model identity, request bounds, cancellation/deadline, error classification, the one-invalid-answer re-ask, freshness and no-mutation-retry safeguards remain. No normalization, strategy/prompt/reward change, dependency update or native change occurred.

Fresh reviewer `7a658af0-abb7-4f55-a2bb-ef2631fed3b0`: **OK**, no issues. New rounded/tied-label test failed before implementation; all **57 tests / 210 assertions**, lint, format and typecheck pass afterward. Negative tests cover undeclared rounding, invalid precision, excess error, missing and extra labels. Evidence: `provider/`; exact gates: `provider/gates/commands.jsonl`. Native checks were not rerun for this app-only change; the unchanged installed DLL retains the earlier 2,770-check gate. No upstream issue was published.

Before resuming, readback confirmed the exact same ready combat version `:76`, complete legal set and **no pending mutation**. A new unlimited CLI segment logs to `run-3b.jsonl`, with normal fresh inference and pre-dispatch re-observation. The diagnostic answer was not reused. This is a post-fix continuation after a recorded failure, **not an uninterrupted successful run or a retry of an uncertain POST**. No native reinstall/restart or saved-event adoption occurred. The continuation subsequently halted; details follow.

### Run 3b: Headbutt selection accepted, resumed execution receipt rejected

The continuation ended with **50 dispatches / 36 successful model calls / 14 forced singletons**, 114,985 input / 2,751 output tokens, 125,980 ms. All 50 consumed distinct versions and received exactly one 202. There were no inference errors; these 36 live distributions all sum to 1 within `1e-6`, so rounded non-unit acceptance remains proven offline rather than by this sample.

At floor 7, action 49 played Headbutt against Fogmog (`:222`). The repaired ownership/grid path exposed all five discard candidates at `:224`: Taunt, Strike, Strike, Flame Barrier, Defend. Jev chose Taunt (`select_card:0`, probability 0.41000000000000003); action 50 received 202. The next observation `:225` was **`duplicate_or_late_execution_receipt`**, unsupported, pending, no legal actions. The game visibly returned to combat after selection (41/80 HP, 262 gold, 14 cards); this does **not** clear the native ownership failure or authorize another action.

The guard originates at `CombatExitOperation.BindExecutionReceipt`, called on each exact owner's native `BeforeActionExecuted` by `RegisterCombatExit`. A legitimate pause/resume re-emission was the initial hypothesis; the subsequent pinned native proof is recorded below. No guard was weakened, no repeated POST sent, and no failed session reset/adoption occurred. `resume-receipt/live-red.log` is the exact saved symptom RED; `run-3b/` contains accounting and logs; `resume-receipt/readback.json` and screenshot preserve the stopped state.

Combined run 3 segments: **75 accepted dispatches on 75 distinct versions, 56 inference attempts (54 successful choices), 21 forced**, 172,841 reported input / 4,225 reported output tokens. This excludes the separately accounted diagnostic. Run 3 remains a technical failure, not terminal success. The Headbutt selector is now live-observed through acceptance, but its complete causal lifecycle still fails; shared-event and rest coverage remain open.

## Reviewed resume-batch repair and installation 3

Source **`9fd5b40`** repairs the shared execution-receipt boundary. Native IL confirms that `BeforeActionExecuted` fires once per pass over an action: `WaitingForExecution` for its first pass, `ReadyToResumeExecuting` after a player choice. `FinishedExecutingActions` returns the **batch** task, not the action lifetime. A resumed pass can reuse its running batch or enter a new batch after the earlier one succeeds. The previous bridge rejected all second receipts.

The repair requires the exact registered action and those native phases. Every distinct resumed batch is retained as blocking work, with earlier fault/cancellation evidence preserved. Duplicate initial passes, missing/unproven predecessors, closed/late resumes remain refused. The action's original completion/execution/visual tasks still gate release. No general Task interception, card-name exception, session reset or selector-guard change was added.

Workflow `490bd9e0-35ed-47a7-96c9-a6e3e79770ea`: writer `867c06e0-4d72-4228-9849-059d80a07d2e`, reviewer `ceea386b-b72e-4417-92d8-733048464a4c`. Initial review found a P2 wiring-test gap, not a production defect. Parent strengthened the compiled callback check and demonstrated that a **constant-false-only resume flag mutation** fails the new assertion (exit 134), then restored production code. Parent also removed the temporary obsolete test-signature fallback. Retained review `dd7cd0e9-f6b8-42e5-93e3-bc50fadf007c`: **OK with notes**, P2 closed, no outstanding code-review findings.

Final parent gates: warning-free native build, **2,831 actual-DLL checks**, **57 app tests / 210 assertions**, lint, formatting and typecheck all exit 0 (`resume-receipt/parent/final/commands.jsonl`). Writer's original behavioral RED and five failing/restored mutations are preserved. An attempted full callback fixture exited **139**, cause unestablished; it was discarded and supplies no positive runtime evidence. The delivered wiring test is deliberately compiler-shape-sensitive metadata inspection, not a live Godot callback test. See `resume-receipt/parent/review-fixes.md` and both review reports.

After closing the game and verifying no process/listener, parent atomically installed candidate **`257294dd1be62a0b7ae85820ca5479a6d0d54bf9f76a764aaf50063fbaa0ab13`** at **2026-09-21 00:23:20.927933 UTC**, source `9fd5b40`, build revision `7b58630`. Native `sts2.dll` identity was unchanged. Prior installed `37157f73…` and candidate binaries are backed up under `/tmp/jev-autonomous-2026-09-20/installation-3/`; only the receipt, not binaries, is archived here.

Parent launched through Steam, verified **Profile 2 / one mod**, and abandoned the previously failed run through the native menu (game records a loss; evidence retains the technical failure). Continue was not used. A fresh **Standard Ironclad A0** run initialized seed **`3GS28H63P9HY`**, epoch `43630b553cd442ecb688d074c3b832d1`, at Neow with 80/80 HP, 99 gold and 10 cards. `run-4/run-4-opening.json` preserves the complete opening choice. Unlimited Jev process `proc_b135` subsequently completed; all gameplay choices remained Jev-owned (except complete singletons).

## Run 4: clean autonomous terminal outcome through the Act 1 boss

Process `proc_b135` exited **0** after **176 dispatches, 122 inference attempts (121 successful choices), 55 forced singletons**, **392,409 input / 10,389 output tokens**, **471,629 ms**. All 176 decisions matched exactly one accepted POST on distinct versions. One SDK-invalid answer did not select a highest-probability option; the existing single re-ask recovered. No bridge halt or uncertain mutation retry occurred.

Jev died to **Vantom at floor 17**. Terminal readback `:543` says **Vanquished**, complete legal set, no actions and no pending mutation; screenshot shows **0/80 HP, 206 gold, 13 cards**. This is a genuine terminal defeat, not a claim of winning capability.

Four Rest choices completed at floors **8, 11, 13 and 16**, each with both Rest and Smith initially offered, followed by Proceed and map travel. The floor-8 readiness sequence withheld inputs at `:186`, exposed both choices at `:187`, accepted Rest, then Proceed at `:190` and map at `:193`. Later rest descriptions included the native **+15 HP from Regal Pillow**. Treasure open/take-Regal-Pillow/proceed, ordinary events, Scroll Boxes, combat, map and the boss fight also completed. Headbutt appeared as an offered bundle alternative, **not a played/resumed card**, so that notification supplies no repaired-resume evidence. Smith and shared-event live coverage remain unconfirmed.

Evidence: `run-4/`; run accounting: `python3 docs/evidence/autonomous-2026-09-20/audit-run.py 4`. The user then narrowed the objective to bridge correctness only, no Jev strategy/prompt optimization, and explicitly approved separately labeled **targeted legal-action QA** for the remaining boundaries instead of open-ended autonomous runs. Run 4 was finished before that QA began; those host-selected tests must not be counted as Jev inference or autonomous gameplay.

## Remaining live checks

The repair's managed fixtures and metadata do not certify full holder allocation, auto-confirmation or continued original-task ownership in a running Headbutt encounter. Shared events and several rest/selector paths still need live coverage. Large/incomplete grids and nested wrappers deliberately remain fail-closed. Ordinary death is a valid terminal outcome; a bridge halt is not.
