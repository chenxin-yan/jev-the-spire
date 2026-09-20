# First controlled live M2: independent read-only audit

## Scope and grounding

This is an observation audit, **not implementation, M2 acceptance, or authorization to resume gameplay**. No repository/source edits, game requests, game/native object construction, installation, deployment, inference, or profile/save/settings access were performed. Only saved evidence, source, cached owner decisions, and assembly metadata were inspected. New artifacts are confined to `/tmp/jev-m2-first-live-audit/` and this report.

Verified independently:
- App HEAD `d1bbc90dce5fe5af2aee561e351a02fbfad0255b`; target HEAD `55e064850a68f3b4cde7e5fd525bf9b2dec4e885`.
- All 19 frozen files (including README/test script) byte-match the current sibling candidate. This does not independently reconstruct all 28 compiler inputs.
- Candidate DLL SHA256 `dff158c2b5ca3d2c357eb417f2469be49caf332da7c41460956d1897c1be34ed`.
- Inspected native DLL SHA256 `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4` matches the pinned v0.111.0 assembly.
- Both indexes have no staged files; pre-existing working-tree changes were untouched.

Source references below are relative to `/tmp/jev-m2-cancelasync/source/`. New IL evidence is under `/tmp/jev-m2-first-live-audit/`; **IL offsets are decimal**, as printed by the existing probe. Probe implementation and retained invocation recipes were inspected before use; only reflection/IL inspection was executed.

Owner contract: cached issues #5–#8 require current legal labels, freshness, one owned mutation, human-visible information, and Jev's strategic authority. #6 expressly says **zero actions → wait/re-observe; singleton → still ask Jev**. #7 leaves setup/embark to the human. The owner issues do not separately define the candidate's `legal_actions_complete` field or animation-readiness semantics. Therefore instantaneous native legality and a complete strategic decision must not be conflated.

## Dispositions

| Observation | Disposition | Minimal recommendation | New Harmony target? |
|---|---|---|---|
| Main menu exception | Safe refusal; diagnostic/null-lifecycle defect, not missing authorized menu gameplay | Guard absent run/network context before dereference; preserve unsupported/no actions | No |
| Immediate card reward: Skip only | Native delayed card input is real; whole-decision readiness is misleading/risky, **not proven omission of currently legal takes or early parent release** | Withhold the entire ordinary reward decision during its known card-input initialization; retain owner and re-observe | No demonstrated need |
| Immediate empty map | Consistent with completed native proceed plus unreadable fading map; **not evidence of unsafe completion**. Waiting classification is misleading but zero-set behavior is already safe under #6 | No completion repair justified by this snapshot; optionally classify this specific unreadable-map transition as waiting | No |

### 1. Main menu: fail-closed, improve diagnosis only

**Observed:** `menu-get.json` is unsupported, incomplete, empty actions, not pending, with `observation_unavailable:NullReferenceException`. Loading the run subsequently permitted combat observation (reported live sequence; this audit did not load anything).

**Reachable source cause:** `McpMod.Contract.cs:43–47` eagerly evaluates `run.NetService.Type.IsMultiplayer()` while computing `AllowedProfile`. This precedes the intended `no_active_run` branch at `98–99`. C# argument evaluation means even the pure `AllowedProfile` guard cannot short-circuit that dereference. `CaptureObservation:51–58` converts the exception into the recorded safe halt.

**Native grounding:** `menu.il`, `RunManager.get_NetService`, offsets 0000–0006, directly returns its backing field. The native constructor (`proceed-body.il`, final method, 0000–0006) only calls `Object..ctor`; it does not initialize that service. `get_IsInProgress` tests whether State is non-null. An uninitialized no-run manager therefore has a genuinely reachable null service; this is not a fabricated helper input.

**Uncertainty:** the JSON contains no stack trace. `NetService` is the strongest grounded explanation, not proof of the exact throwing instruction; other singleton reads remain possible. Do not label the menu snapshot a missing gameplay feature: main-menu execution is outside the chosen run boundary and intentionally not enumerated.

**Minimal fix:** distinguish no active run/missing service from active-run singleplayer validation before evaluating `.Type`; keep profile-2/modded/multiplayer refusal and terminal handling intact. An absent service in an allegedly active run must still fail closed, not default to singleplayer. No menu actions or new listener route are justified.

**Faithful test seam:** a test of `AllowedProfile(false, …)` alone is inadequate—it never executes the eager caller. A repair needs an ordered context-read seam (or compiled control-flow check) proving the no-run path cannot call the network-service type getter, plus active multiplayer/invalid-profile negatives. No faithful runtime repro of the full production menu capture was executed here: it requires native scene/context access prohibited by this task.

### 2. Card reward: legal-now Skip versus complete reward choice

**Observed:** the immediate and settled files contain the same three cards. Immediate has only `card_reward_alternative:0` (Skip), `waiting:false`, `legal_actions_complete:true`, `mutation_pending:true`. Settled adds all three `select_card_reward:*` labels and retains pending. No action was submitted in the immediate window.

**Native ordering explains the window:**
- `card-clean.il`: `_Ready` calls `RefreshOptions` at 0170. `card-refresh.il` creates/connects card holders and alternative buttons synchronously; its card tween is separate from input readiness.
- `card-boundaries.il`, `AfterOverlayOpened`, 0142–0152: starts `DisableCardsForShortTimeAfterOpening().RunSafely()` without retaining that Task.
- That async method's `MoveNext`: 0052–0054 sets each card holder unclickable; 0083–0105 awaits native `Cmd.Wait(0.35, token, false)`; 0241–0244 re-enables holders. It does **not** disable alternative buttons.
- `holder-controller.il`: `_GuiInput` 0007–0015 and mouse release 0037–0043 enforce `_isClickable`. Thus the three takes are genuinely unavailable through normal native input in this window, notwithstanding descriptions/visible cards.
- `OptionSelected` creates/awaits its completion source (`card-boundaries.il`, third method, 0017–0039). `OnAlternateRewardSelected` 0011–0029 resolves that source directly, with no card-clickability check. Skip can therefore remain a real native input while takes are disabled. The saved JSON does not record every native mouse/filter/modal predicate, so exact frame-level input availability is not independently reconstructed.

**Bridge behavior:** `McpMod.LegalActions.cs:49–56,127–138` suppresses unclickable holders and independently adds Skip. `SelectionOwnership.cs:22–29,137–144` grants an ordinary selector lease readiness by default once the exact pending selection task is attached; this is ownership, not card-input readiness. `BridgeProtocol.cs:55–59` treats selector phases as non-waiting. `McpMod.Contract.cs:193–207` then labels any non-halted/non-waiting result complete.

**Concrete reachable consequence:** `DispatchLabel:294–304` can accept the same-version Skip through the current owned lease and `AcceptChild` (`BridgeProtocol.cs:301–307`). If cards enable before revalidation, the changed action set changes the fingerprint/version and rejects the old choice. If dispatch occurs before enabling, no such freshness change is required and Skip can consume this reward decision. That is a timing-dependent singleton strategic menu, not evidence that the bridge bypassed native take guards. It did **not** release the initiating parent: the recorded `mutation_pending:true` is correct for the owned child.

**Contract classification:** under a strictly instantaneous legal-set interpretation, the snapshot can be complete; the source does not establish that three *currently legal* takes were pruned. Under the intended joint reward decision, advertising Skip-only as decision-ready is misleading: #6 requires asking Jev even for a singleton, so an orchestrator may legitimately decide before the ordinary alternatives become available. Recommend addressing that readiness risk before inference, without calling it proven unsafe gameplay-task completion or a demonstrated lost reward. None was lost here.

**Minimal fix direction:** at the **ordinary card-reward observation branch**, while its known offered card holders are in native initial input-disable state, expose a waiting/incomplete observation and no actionable alternatives. Once those holders actually become input-ready, expose takes and Skip together under the same retained owner. Do not force-enable cards, invent a sleep, await `OptionSelected` (it awaits the decision), or wait for all visual tweens. Keep current ownership/failure/stale checks. Check actual observed holder/input state, not a hardcoded card count or generic “all disabled controls everywhere must become enabled” invariant. Preserve truly legitimate zero-card/alternative-only cases rather than deadlocking them.

**Test seam:** exercise the production reward-readiness/whole-set branch with the source-grounded sequence: exact owned pending selector, three offered holders initially unclickable and enabled Skip; then the same holders clickable, same pending parent. Before readiness: no dispatchable Skip and incomplete/waiting. After readiness: all four labels, unchanged parent identity, fresh decision version; old version rejected. Include a legitimate alternative-only case if supported. A raw `FinishObservation` call supplied an invented partial action list is not a faithful native repro. Existing checks at `tests/check-bridge.sh:890–895` prove child ownership availability, not the native initial disable window. Full native enumeration cannot be faithfully replayed offline under this task's no-Godot constraint; the future seam must be wired into production, not just a standalone boolean test.

**Hooks:** no new Harmony target is necessary for this bounded readiness gate: holders and clickability are already read. Capturing the detached native disable Task would be a different, unapproved expansion and is not justified merely to wait for the input predicate.

### 3. Empty map: completion and readable decision are different boundaries

**Observed:** immediate map has zero nodes, next options and actions, is non-waiting/complete and not pending. Settled has 66 nodes and three travel choices. The immediate file does not reveal whether map nodes existed but were unreadable, nor retained task/control internals.

**Native normal-open ordering:**
- `proceed-body.il`, `ProceedFromTerminalRewardsScreen.MoveNext`: ordinary branches call `NMapScreen.Open(false)` at 0197 or 0217 and reach `SetResult` at 0264. Only the resume-parent-event branch awaits `ResumePreviousRoom` (0076 onward). Native ordinary proceed does **not** await the map fade.
- `map-open.il`, `Open`: marks open/visible at 0011–0019. The ordinary existing-map branch sets `_points.Modulate.A=0` at 0547–0579; it schedules visual tweens, including the point fade with delay, then synchronously calls `RecalculateTravelability` at 1157 and emits Opened at 1383 before returning at 1448. It does not await these tweens.
- This is enough to make `IsMapScreenOpenOrVisible` true (`McpMod.Helpers.cs:317–320`) while `IsReadableCanvas` (`McpMod.Contract.cs:216–222`) rejects all map points. `BuildMapState` (`McpMod.StateBuilder.cs:1716–1758`) and legal enumeration (`McpMod.Contract.cs:126–139`) both use that readability filter. An empty exported map need not mean missing map construction or pending travel computation.
- The native travel predicates do not use fade opacity (`point-input.il`: `get_IsTravelable` reads travel-enabled/state; `IsInputAllowed` checks traveling/drawing). Native travel can be established before bridge-readable map information. Human-visible information restrictions still justify not exporting invisible nodes/actions.

**Owned completion:** `McpMod.RewardHooks.cs:418–432` retains the exact terminal transition, and `CombatExitOperation.cs:132–164` releases only after registered work and screen lifetimes settle; otherwise it retains the map continuation. `BridgeSession.Refresh` joins those barriers before clearing pending. Consequently `mutation_pending:false` with unreadable map points is entirely consistent with successful owned gameplay completion followed by cosmetic visibility progression. Do **not** retain a completed mutation merely until nodes appear, or replace receipts with a stable fingerprint/delay.

**Disposition:** no unsafe early-completion bug is demonstrated. `BridgeProtocol.IsWaiting("map", false, …)` ignores readability and `FinishObservation` consequently says complete; that is misleading presentation of a not-yet-usable decision, but **harmless for this zero-action sample under #6's mandatory wait/re-observe rule**. The recorded later version/action set permits progress without accepting a stale choice. This is unlike Skip-only, which can immediately cause a strategic decision.

**Uncertainty/ceiling:** the exact Open branch was not recorded. `Open` also has a start-of-act branch (0241–0433); `map-start.il` confirms it detaches `StartOfActAnim`, whose successful tail calls `InitMapPrompt`. Ordinary room proceeds explicitly exclude start-act/active-animation/tutorial branches (`McpMod.OrdinaryActions.cs:57–65`); combat reward proceed's capture at `McpMod.RewardHooks.cs:203–212` does not use that same guard. This is a reason not to generalize the harmless normal-fade explanation into proof that *all* reward-map transitions are safe. The supplied empty snapshot alone does not establish that branch, an unseen tutorial, a pending gameplay task, or an input bypass. A whole new map-completion adapter is not justified on this evidence.

**Minimal recommendation:** no completion change. Optionally classify the specific open-but-unreadable map observation as waiting/incomplete; maintain human-visible filtering. Do not add a global “empty legal set is invalid” invariant: owner explicitly permits zero sets. If later evidence establishes a deferred tutorial/input-blocked branch, refuse that unsupported branch using grounded existing guards rather than infer its completion from visible nodes.

**Test seam:** for an optional readability change, exercise actual map observation classification with native-established travelability but unreadable point ancestry, then readable ancestry; pending may already be false in both. Pair it with the existing production owned-transition controller tests: pending retained Offer/child work must still block release; completed work must not require a cosmetic fade. Existing `tests/check-bridge.sh:995–1000,1088–1099` supplies a synthetic ready map action and does not cover the zero-readable-node transition. A fixture saying “empty map always means pending” would encode the wrong contract. Full Godot fade reproduction was not run.

## Checks actually run, limits, and parent verification

Artifacts:
- `hashes.json`, `source-comparison.json`, `repository-metadata.json`: provenance/index checks, all successful (Python wrapper exit 0; each git subcommand exit 0).
- `probe-commands.json`: exact argv, output paths and subprocess exits for **18 metadata invocations**. Sixteen exit 0. Two exploratory invocations terminated with return `-6` (SIGABRT) because guessed method names `OnCardPressed` / `RefreshAllMapPointStates` did not exist. Their earlier output is retained, but decisive methods were re-probed successfully in `card-clean.il` / `map-open.il`; the missing names are not used as evidence.
- `source-excerpts.txt`: numbered production excerpts.
- `python3 /tmp/jev-m2-first-live-audit/check_evidence.py`: **exit 0**, five saved snapshots pass integrity/relationship checks.
- Same command with `--whole-reward-decision`: **exit 1 intentionally**, demonstrates the recorded Skip-only complete-decision witness. This is an immutable evidence diagnostic, **not** a production regression or proof a proposed repair works.

No production tests added/changed; `tests/check-bridge.sh` was inspected in relevant portions but **not run**. No candidate build was performed. No full offline native repro was fabricated; metadata ordering plus actual recorded observations support the dispositions, not a claim of scene-level test coverage.

Parent's next separately authorized live verification should (1) distinguish a deliberate menu/no-run refusal from an exception, (2) check the immediate reward-to-ready transition without dispatching the transient singleton, and verify parent retention/stale rejection, and (3) distinguish normal map readability progression from act-start/tutorial/input-blocked branches before claiming completion parity. Native transient fields/receipts were not present in these snapshots; if obtaining them needs instrumentation or new hooks, obtain separate approval first. Do not resume or replay the already-consumed reward/proceed merely for this audit.

**M2 remains BLOCKED independently** by incomplete event coverage and unexecuted gates. These three observations neither invalidate the reported successful controlled actions nor establish autonomous smoke-run/build-ready acceptance.

```acceptance-report
{
  "criteriaSatisfied": [
    {"id":"criterion-1","status":"satisfied","evidence":"Completed only the assigned read-only three-observation audit; no implementation or repository changes."},
    {"id":"criterion-2","status":"satisfied","evidence":"Provided source lines, pinned native IL offsets, actual snapshot checks, uncertainty, bounded recommendations, test seams and exact command/exit manifest."}
  ],
  "changedFiles": [
    "/Users/yanchenxin/.pi/agent/sessions/--Users-yanchenxin-dev-github.com-chenxin-yan-jev-slay-the-spire-2--/subagent-artifacts/outputs/56c3585b-b843-4c06-a69e-6d978f424417/reviews/m2-first-live-audit.md",
    "/tmp/jev-m2-first-live-audit/ (offline metadata and evidence artifacts only)"
  ],
  "testsAddedOrUpdated": ["/tmp/jev-m2-first-live-audit/check_evidence.py (saved-evidence diagnostic only; no production regression test)"],
  "commandsRun": [
    {"command":"Provenance/hash/source comparison and git read-only metadata commands; see repository-metadata.json, hashes.json, source-comparison.json","result":"passed","summary":"Expected hashes and HEADs; 19/19 frozen files match; both indexes empty; exits 0."},
    {"command":"18 mise exec -- dotnet metadata-probe invocations; exact argv in probe-commands.json","result":"passed","summary":"16 successful invocations (exit 0); decisive native methods successfully inspected without native object execution."},
    {"command":"Initial card/map probes ending in OnCardPressed / RefreshAllMapPointStates","result":"failed","summary":"Two missing-method exploratory probes each returned -6/SIGABRT; corrected successful probes retained separately."},
    {"command":"python3 /tmp/jev-m2-first-live-audit/check_evidence.py","result":"passed","summary":"Exit 0; five saved snapshots confirm reported relationships."},
    {"command":"python3 /tmp/jev-m2-first-live-audit/check_evidence.py --whole-reward-decision","result":"failed","summary":"Intentional exit 1: immutable recorded skip-only whole-decision readiness witness, not a production test."},
    {"command":"tests/check-bridge.sh / live verification / candidate build","result":"not-run","summary":"No production test execution, build, or live access performed."}
  ],
  "validationOutput": ["Menu refusal is safe; probable eager null network-service dereference.","Skip-only matches a native card-input disable window; parent remains retained; whole-decision readiness risk is reachable.","Empty map is consistent with native proceed completion preceding readable fade; unsafe release not established."],
  "residualRisks": ["Menu exception has no stack trace.","Snapshots omit transient native input/task and exact map-Open branch data.","No faithful offline Godot scene repro or implemented repair validation.","M2 remains blocked by incomplete coverage and unexecuted gates."],
  "noStagedFiles": true,
  "diffSummary": "Audit/report and bounded /tmp evidence only; no source changes.",
  "reviewFindings": ["Before inference: address or explicitly resolve skip-only whole-reward decision readiness semantics.","No unsafe owned-completion finding established by these three snapshots.","No new Harmony target demonstrated necessary; none authorized."],
  "manualNotes": "Acceptance here means completion of the read-only audit task, not acceptance of M2 or authorization for live actions. Independent reviewer gate remains required."
}
```
