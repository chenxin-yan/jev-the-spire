# Independent Crust / Neow review

## Separate verdicts

- **App: PASS, scoped offline implementation.** The approved Bun 1.4.2 / TypeScript 7.0.2 / Crust migration preserves the loop and correctly maps cancellation/errors to nonzero exits. No blocking defect found.
- **Native: PASS, scoped offline implementation.** The finished-Neow exception is confined to the owned fresh `ActOpening`; ordinary, restored/unowned and later-act paths retain their refusals. Independent isolated rebuild is byte-identical to the submitted candidate. **Not a Godot/live acceptance or installation approval.**

Both repositories were read-only. No game HTTP, game UI/launch/install/control, real inference, credential/`.env` access, save/profile/settings access, environment dump, staging/commit/publication, or delegated agents. Only this report and `/tmp/jev-crust-neow-review/` were written. All Bun invocations used `--no-env-file`; fake HTTP servers used ephemeral loopback ports, SDK transports explicit fake keys. Prior scratch evidence was not overwritten.

## App findings

Read `docs/minimal-demo.md`, the supplied writer reports/deltas, prior CLI repair review and targeted tests, current source, and **installed published** Crust core/effect distributions and package metadata (not just the source-checkout API). Verified:

- `flags` string parser validates positive safe integers, including defaults; Crust rejects unknown/missing flags and positionals. The action rejects nonempty `rawArgs` before mkdir/log/HTTP. Independent whitespace/NaN/Infinity/passthrough checks also pass.
- Installed `handler` runs native Effect v4 via `Effect.runPromiseExit`; interruption unwraps to `AbortError`. Installed core dispatch validates before action, settles/disposes before returning, renders ordinary failure with exit 1, and maps interruption to silent 130. It provides no process AbortSignal. App-owned controller/listener/timer remain necessary and are released in `finally`.
- Terminal/action-bound summaries return success; halt/deadline summaries become failures; SIGINT becomes interruption **after** summary output. Independent real CLI cancellation at freshness and during an accepted fake POST exits 130; no subsequent POST/retry occurs. Already-sent mutations cannot be undone. mkdir and synchronous decision-log failures exit 1 naturally without dispatch or lingering five-minute timer.
- `src/{bridge,jev,loop}.ts` are byte-identical to the repair baseline. Full legal criteria, forced singleton logging, singleton→multiple freshness, pending-parent child decisions, 60-second inference bound, 10-second read-backoff allowance, one invalid-answer re-ask, and never-retry mutation behavior remain. Installed SDK evaluation/Gateway source still forwards the abort signal and reports configured model identity, not server attestation.
- New independent whole-deadline check uses the unchanged real CLI and asynchronously delayed HTTP responses with constantly changing versions; only the exact 300000-ms timer is shrunk to 150 ms. It exits 1 with `demo_deadline`, zero inference and zero POSTs. This avoids the earlier microtask-starvation fixture. It proves wiring, not five-minute endurance.

No Layer/service abstraction, strategy, scheduler, recovery mechanism, extra framework or help extension was introduced. Approved exit/version/mise changes are not regressions.

## Native findings

Read all three changed production files and their real admission/completion/map callers, `EventOperation.cs`, the actual five-file delta, initial-entry/completion reports, and retained IL evidence. Current and frozen compiled-DLL suites were independently rerun.

- `BridgeProtocol.InitialOpeningProceed` grants only `owned && actIndex == 0 && StartedWithNeow && ActFloor == 1`. The existing four-boolean protocol map guard is unchanged. The bridge wrapper's fourth argument defaults to **false**; only the two event Proceed sites pass `entry.Move is ActOpening`. Merchant/rest/treasure/reward call sites retain the full guard.
- `ActOpening` is constructed only by `BeginActOpening` after fresh-run provenance checks: zero reloads, act 0/Neow, exact starting Ancient coordinate, one visit, unfinished room/model, no running foreign travel action. Subsequent event identity/generation/input checks and current act/floor rechecks remain. No adoption of an ordinary/restored/unowned entry or later-act extension was found.
- Seen `map_select_ftue` is required before dispatch and checked again in the map postcondition; unseen tutorial still throws. `_isInputDisabled`, `IsTraveling`, exact `_runState`, and post-Proceed travel-enabled checks remain. No tutorial acknowledgement/reset or new Harmony target was added.
- Exact `EventOption.Chosen` task capture, duplicate refusal, synchronous exact-receiver `Opened` receipt, `RequireEventIdentity`, and `HoldUntil(operation.Poll() && map.IsOpen)` are retained. Independent native IL inspection additionally confirms `BeforeOptionChosen` skips its asynchronous shared-option path for Proceed (`<BeforeOptionChosen>d__31` IL0077/0186–0199); `Proceed` calls `SetTravelEnabled(true)`, **Open(false)**, then returns `CompletedTask`.
- Neither fade, `_hasPlayedAnimation`, nor null tween is treated as task completion. No hook/await was added for the discarded, potentially never-completing `StartOfActAnim` task. The accepted no-tutorial-reset assumption is essential to excluding its later `InitMapPrompt → MapFtueCheck` gameplay tail; both animation/banner branches remain covered by that argument.
- Initial map reachability has no remaining start-of-act guard: session refresh joins the retained event task before normal map exposure; `CaptureObservationCore` lists travelable readable points; `DispatchMap` closes the old event entry and uses the existing owned vote/action chain. Neither calls `RequireOrdinaryMap`; pinned native `OnMapPointSelectedLocally` enqueues without the human animation-interrupt guard. Actual engine delivery/context propagation remains untested.

**Fade clarification, nonblocking:** a genuinely complete zero-action snapshot is re-observed by `awaitReady`, not inferred on or immediately halted; an independent empty-map→ready-map check passes. The writer's “whole or empty” argument is about **map points**, not necessarily the entire action set: `McpMod.Contract.cs:164–168` can append potion actions. Also `IsReadableCanvas` checks alpha > 0, not completion of the fade. Do not promote the offline result into a live full-set/fade-completion claim. The preexisting visibility/potion code was not changed or broadened here.

## Commands and evidence

Scratch root **S = `/tmp/jev-crust-neow-review`**. Every validation command ran through `S/run.py`: allowlisted environment, complete stdout/stderr files, a 30/90/120-second external process-group timeout; new CLI subprocesses also had eight-second kill guards. All commands below exited **0**, no timeout or failed fix iteration. `S/commands.jsonl` records exact argv, cwd, timeout and exit; each named command has full `.log` and `.exit` files.

| Exact command (from app root unless stated) | Result / log |
|---|---|
| `mise exec -- bun --no-env-file --version` | 1.4.2; `versions.log` |
| `mise exec -- bunx --no-env-file --no-install tsc --version` | Version 7.0.2; `typescript-version.log` |
| `mise exec -- bunx --no-env-file tsc --noEmit` | clean; `typecheck-exact.log` (also passed with `--no-install`) |
| `mise exec -- bun --no-env-file test test/main.test.ts` | 15/15, 61 assertions; `main-test.log` |
| `mise exec -- bun --no-env-file test` | 50/50, 193 assertions; `app-test.log` |
| `mise exec -- bun --no-env-file test /tmp/jev-crust-neow-review/independent.test.ts` | 12/12, 56 assertions; `independent.log` |
| `mise exec -- bun --no-env-file test /tmp/jev-crust-neow-review/retained/targeted.test.ts` | 10/10, 88 assertions; `retained-app.log` |
| `mise exec -- bun --no-env-file test /tmp/jev-crust-neow-review/retained/original-contract-adjusted.test.ts` | 9/9, 57 assertions; `original-contract-adjusted.log` |

Retained scratch copies redirect output away from prior evidence. The original nine-test suite changes only output location and the two explicitly authorized expected exits (bad args 2→1; SIGINT 1→130). Its historical “no deadline signal” title is not an assertion that production has no deadline. The targeted copy changes output location only, using the review's 150-ms preload.

### Exact independent native build

Seeded only the five existing NuGet restore asset files from `/tmp/jev-neow-proceed/obj/` into `S/obj/`; no package download/restore/deployment. All output/intermediates isolated, imports disabled. `native-build.log`: zero warnings/errors.

```sh
mise exec -- dotnet build ../STS2MCP/STS2_MCP.csproj --no-restore -t:Rebuild -c Release \
  -o /tmp/jev-crust-neow-review/release \
  '-p:STS2GameDir=/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2' \
  '-p:STS2GameDataDir=/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2/SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64' \
  -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false \
  -p:BaseIntermediateOutputPath=/tmp/jev-crust-neow-review/obj/ '-p:DefaultItemExcludes=obj/**' \
  '-p:PathMap=/tmp/jev-crust-neow-review/obj=/Users/yanchenxin/dev/github.com/chenxin-yan/STS2MCP/obj' \
  -p:UseSharedCompilation=false --disable-build-servers
```

For the next commands, `D=/tmp/jev-crust-neow-review/release/STS2_MCP.dll` and `G=/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2/SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64/sts2.dll` (both passed as individual arguments):

| Command | Result |
|---|---|
| `mise exec -- bash ../STS2MCP/tests/check-bridge.sh "$D" "$G"` | PASS 1909; `native-current.log` |
| `mise exec -- bash /tmp/jev-neow-proceed/baseline/tests/check-bridge.sh "$D" "$G"` | PASS 1865; `native-retained.log` |
| `mise exec -- bash /tmp/jev-m2-generic-events/source/tests/check-bridge.sh "$D" "$G"` | PASS 1842; `native-frozen.log` |
| `mise exec -- dotnet /tmp/jev-m2-late-cleanup-review/independent/bin/Debug/net9.0/Check.dll "$D" "$G"` | 93 checks / 0 RED; `native-late-cleanup.log` |
| `mise exec -- dotnet /tmp/jev-m2-live-readiness-review/independent/bin/Debug/net9.0/Check.dll "$D" "$G"` | PASS 50; `native-readiness.log` |
| `mise exec -- dotnet /tmp/jev-m2-ordinary-review/extra/bin/Debug/net9.0/Check.dll "$D" "$G"` | PASS 60; `native-ordinary.log` |
| `mise exec -- dotnet /tmp/jev-m2-relic-review/extra/bin/Debug/net9.0/Check.dll "$D" "$G"` | PASS 16; `native-relic.log` |
| `mise exec -- dotnet /tmp/jev-m2-cancelasync-review/targeted/bin/Debug/net9.0/Check.dll "$D" "$G"` | PASS 1266; `native-cancel.log` |
| `mise exec -- dotnet /tmp/jev-m2-owned-teardown/repro/bin/Debug/net9.0/Repro.dll "$D"` | red=0; `native-teardown.log` |

Metadata-only ApiProbe/IlProbe commands, including exact BeforeOptionChosen/Proceed method names, are recorded in `commands.jsonl`. No native scene or game lifecycle was invoked. Sentry's “GDExtension not loaded; skipping” diagnostic is not a live-engine test. The known unsupported O2 external-producer temporal case was **not** rerun or relabeled a pass; its previously reported failure remains out of scope.

## Hashes, inventories and preservation

- Independent candidate and writer candidate, identical SHA256: **`d627dc6d47771d90fe2a8341f88f36e05024944416a55a481a2d6db051eaa61c`**.
- Pinned native metadata input: **`9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`**.
- `CONTEXT.md`: **`0b90a7e6f3825158ab4d15458b216148c5a7c5c46c70e345864fef051088e3b7`**, unchanged.
- Authorized current `mise.toml`: **`2fd8e7847337cbfc1caaf5d0f2b35f7d9ebb0853dac0eaabc022d6aa8e024d5a`**, unchanged by review; dotnet retained.
- `inventory-before.json` and `inventory-after.json`: **43 identical file hashes**, manifest SHA256 **`05cfb4b62dd60c4b05288b1bdcda846bec500718af0ee25cc3c20ab65db9fd78`**. App inventory: four source files, five test/preload files, package/lock/tsconfig/README/CONTEXT/mise. Native inventory: 25 root C# files, csproj, README and harness.
- `freeze-comparison.json`: **43/43 matches**: 26 native build inputs (25 C# + csproj), 14 available app frozen files, and three unchanged loop/provider/transport baseline comparisons. `native-source-comparison.json`: **19/19 native writer-source matches**. `native-changed-vs-baseline.json`: exactly BridgeProtocol, EventActions, OrdinaryActions, README, harness; only three compiler inputs changed. Hook-installation source remains frozen.
- App migration delta: `src/main.ts`, `test/main.test.ts`, `test/deadline-preload.ts`, `README.md`, `mise.toml`, `package.json`, `bun.lock`. No reviewer repo changes.
- Both repositories' before/after `git diff --cached --name-only` outputs are empty; statuses unchanged. Individual source/dependency/API hashes, candidate/native hashes and scratch manifest hashes are retained in `S`. Installed mod DLL and `.env` were not accessed; no fresh hash claim about them is made.

## Residuals and procedural note

1. Actual Gateway/Jev, Godot signals/AsyncLocal propagation, Ancient options, and continuous opening→map→gameplay are still live gates. No install/demo/checkpoint reset occurred. Later-act/boss support remains refused.
2. Owner-accepted tutorial-already-seen/no-reset assumption remains necessary. Cosmetic task completion is neither awaited nor certified.
3. Timers require a responsive event loop and abort-respecting transports; accelerated checks are not endurance tests. `202`/`max_actions` means acceptance, not completion of the last game mutation. Provider identity is configuration; request-size limits remain JSON characters.
4. The app writer explicitly reported `bun install` discovering `.env` despite `--no-env-file`. That is a **prior workflow-boundary exception**, not proof of compliance with “no .env access”; this review did not repeat or investigate it. Likewise the reported one-shot minimum-release-age bypass is not repeated. Future install work must avoid a dotenv-discovering invocation in the protected root rather than treating discovery as unavoidable. This does not change the scoped source/test verdict.

```acceptance-report
{
  "criteriaSatisfied": [
    {"id":"criterion-1","status":"satisfied","evidence":"Read-only review completed for both approved deltas only; app/native separately pass offline. Three native compiler inputs changed; loop/provider/transport unchanged; no new hooks or scope widening."},
    {"id":"criterion-2","status":"satisfied","evidence":"Independent Bun 1.4.2/TS 7.0.2 tests/typechecks, 12 new scratch boundary checks, retained app/native suites, byte-identical isolated native rebuild, full command/output records and 43-file unchanged inventory in /tmp/jev-crust-neow-review."}
  ],
  "changedFiles": ["/tmp/jev-crust-neow-review/ (scratch review evidence only)","/Users/yanchenxin/.pi/agent/sessions/--Users-yanchenxin-dev-github.com-chenxin-yan-jev-slay-the-spire-2--/subagent-artifacts/outputs/62e6578f-8da0-468c-852f-63a88f089787/reviews/crust-neow.md"],
  "testsAddedOrUpdated": ["/tmp/jev-crust-neow-review/independent.test.ts (12 independent checks)","/tmp/jev-crust-neow-review/deadline-preload.ts","/tmp/jev-crust-neow-review/retained/ (relocated retained tests; authorized exit expectations adjusted in original suite copy only)"],
  "commandsRun": [
    {"command":"mise exec -- bun --no-env-file test","result":"passed","summary":"exit 0; 50 pass, 0 fail, 193 assertions"},
    {"command":"mise exec -- bun --no-env-file test test/main.test.ts","result":"passed","summary":"exit 0; 15 pass, 0 fail"},
    {"command":"mise exec -- bunx --no-env-file tsc --noEmit","result":"passed","summary":"exit 0; TypeScript 7.0.2 clean"},
    {"command":"mise exec -- bun --no-env-file test /tmp/jev-crust-neow-review/independent.test.ts","result":"passed","summary":"exit 0; 12 pass, 56 assertions; real CLI fake-transport cancellation/error/deadline/no-I/O checks"},
    {"command":"retained app commands listed above and exact argv in /tmp/jev-crust-neow-review/commands.jsonl","result":"passed","summary":"10/10 targeted and 9/9 original with approved exit-contract adjustments; both exit 0"},
    {"command":"isolated dotnet rebuild command reproduced above","result":"passed","summary":"exit 0, zero warnings/errors; byte-identical d627dc6d47771d90fe2a8341f88f36e05024944416a55a481a2d6db051eaa61c"},
    {"command":"current/retained native harness and six independent suites listed above","result":"passed","summary":"all exit 0: 1909/1865/1842; 93/50/60/16/1266 and teardown red=0"},
    {"command":"inventory comparisons and git diff --cached --name-only in both repositories","result":"passed","summary":"43-file inventory unchanged; both indexes empty"}
  ],
  "validationOutput": ["App PASS offline; native PASS offline; no scoped code blockers","CONTEXT.md retains required SHA256","Full command argv, exits and output files retained; no validation failure or timeout","No repository edits; no game/provider requests"],
  "residualRisks": ["Godot/live/provider acceptance remains unperformed; candidate not installed","No tutorial reset after seen-FTUE admission; cosmetic task completion not claimed","Transient visibility/potion full-set behavior is not live-certified by the empty-map fixture","Timers are event-loop bounds, not external production watchdogs; accepted mutation is not completion","Prior writer-reported Bun install dotenv discovery remains a procedural exception, not reviewer-verified no-access compliance","Known unsupported O2 temporal case remains outside this scoped pass"],
  "noStagedFiles": true,
  "diffSummary":"No repository diff from reviewer. Reviewed seven app migration paths and five native paths; evidence/report only written.",
  "reviewFindings":["No blocking defect in either approved implementation delta","Nonblocking report clarification: whole-or-empty map points does not certify whole-or-empty legal_actions or fade completion","Prior install dotenv-discovery boundary exception explicitly retained, not reproduced"],
  "manualNotes":"Separate offline verdicts only. No installation, launch, game HTTP, real inference or live-demo authority implied. Exact commands and complete logs are in the review scratch directory."
}
```
