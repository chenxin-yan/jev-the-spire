# Independent minimal-demo review

## Verdicts

- **App: functional offline path passes; small changes requested before acceptance.** Original tests: **30 pass / 0 fail**, typecheck clean. Independent fixture/SDK/CLI checks: **7 pass / 2 fail**. Failures are real argument/readiness validation gaps, not a request for broader M2 coverage. Inference also lacks an application deadline; see bounds below.
- **Native: PASS for the narrowly implemented initial-opening entry, offline only.** Independent isolated rebuild is byte-identical to the writer candidate; 1,865 current and 1,842 frozen regression checks pass. No new interception targets, selector permissions or tutorial bypasses were introduced. Ancient availability through actual Godot execution remains unverified.
- **Integration: NOT a demonstrated working opening → ordinary gameplay path.** Neow's finished-page Proceed is still deliberately refused by the existing start-of-act map guard. This is an authority/coverage blocker, not permission to loosen the guard. Initial choice support, later-act choice reuse and boss/act-transition reachability must remain separate claims.

Read `docs/minimal-demo.md`, both supplied writer reports, actual app sources/tests, native delta and relevant installed Effect/AI SDK/native metadata. No repository edits, game/provider requests, UI/launch/install/control, save/profile/settings-file access, credential access, staging or commits. Scratch evidence: `/tmp/jev-minimal-demo-review/`. This review grants **no installation, demo or production-run authorization**.

## Findings and minimum corrections

### A1 — P2: missing explicit action bound silently starts a default run

`src/main.ts:12-18`: `argValue("--max-actions")` returns `undefined` both when absent and when present without a value. The latter silently becomes 10 instead of exit 2. Unknown arguments / `--max-actions=1` are also ignored by this parser; the demonstrated defect is the missing-value case.

Independent test invoked the real CLI with `--bridge <ephemeral fake server> --log <scratch> --max-actions`. Expected `{code:2, gets:0}`; actual **`{code:0, gets:1}`** (fake terminal response). No game access occurred. On a ready bridge this can perform actions despite malformed safety-bound input.

**Minimum:** distinguish absent from present-but-empty flags and reject malformed/unknown arguments before creating logs or networking. Built-in `node:util.parseArgs` is sufficient; no CLI framework needed. Keep one regression test.

### A2 — P2: readiness field is trusted without runtime validation

`src/bridge.ts:41-59` casts to `Snapshot` without validating optional `waiting`; `src/loop.ts:130` tests `snapshot.waiting !== true`. Consequently **`waiting: "true"` is accepted and treated as ready** if the other readiness fields/actions are present. Independent malformed-input test fails exactly here. This is not emitted by the pinned native bridge, so it is a malformed-transport fail-closed gap, not a demonstrated native readiness regression.

**Minimum:** when present, validate `waiting` as boolean and `halt_reason` as string at `parseSnapshot`. Validate optional summary fields used via dereferencing as well (e.g. `run: null` is currently accepted). Do not implement a complete gameplay schema; only the fields consumed by the control loop need guarding.

### A3 — boundedness limitation: waiting timeout does not bound inference or read backoff

`src/jev.ts:92-97` passes only the caller/fiber signals to `experimental_evaluate`; installed `ai` evaluation and Gateway code add no request deadline. A pending provider request can therefore outlive the 30-second waiting bound indefinitely until Ctrl-C or external transport failure. The action count bounds accepted POSTs, not wall time/model requests; repeated stale decisions are also outside `awaitReady`'s deadline. `src/bridge.ts:91-98` accepts unbounded numeric `Retry-After`, and HTTP-date form is not honored.

The scratch pending-provider test confirms explicit cancellation propagates; its short delay is **not** presented as an empirical proof of an infinite hang. The missing deadline is a source-level finding.

**Minimum:** add one finite inference timeout via the existing combined signal, and bound read retry delays (or halt when server backoff exceeds the demo budget). No scheduler/recovery layer. At minimum, do not describe the current CLI as wall-time-bounded; a parent-supervised run must retain manual stop control.

### N1 — integration blocker, intentionally unchanged: Neow Proceed

`../STS2MCP/McpMod.EventActions.cs:154-161,245-252` routes both Proceed admission and completion through `RequireOrdinaryMap`. `McpMod.OrdinaryActions.cs:57-65` rejects `startsAct` even when the animation has already played; Neow is act index 0 / ActFloor 1. Thus the sole finished-page alternative invalidates the whole event observation with `ordinary_map_readiness_unverified` (or the earlier tutorial refusal).

Independent pinned-native IL confirms the initial-map animation/banner branch. **Correction to writer prose:** native `NEventRoom.Proceed` calls `SetTravelEnabled(true)` then **`Open(false)`**, not `Open(true)` (`native-entry-proceed.il`, IL0016 `ldc.i4.0`). The blocker is unchanged: normal settings can take the animation path, and the guard refuses the entire start-of-act case regardless.

**Minimum next step:** parent/owner decides whether to authorize only this finished-event → initial-map branch, with a precise native completion/tutorial argument, or explicitly accept a split demo containing a separately authorized human step. The proposed `Opened + _hasPlayedAnimation + _actAnimTween == null + seen FTUE` is a candidate for analysis, **not yet an accepted completion proof** for the detached `InitMapPrompt/MapFtueCheck` tail. No hook added or guard changed here. Do not reset the existing floor-3 checkpoint merely to test this candidate without approval.

## What checked out

### App / installed dependencies

- Actual mapping is `Decision.make(Schema.Json)` → `Decision.classify` with **every** current label/description → `DecisionModel.make({decide})` → `ai.experimental_evaluate` → `gateway.evaluation("typesafe-ai/jev")`. Installed `Decision.js:32-35` rejects fewer than two labels; the documented owner-approved singleton bypass is justified and logged separately.
- `DecisionModel.js:54-100,178-197` requires a legal label, finite complete probabilities summing to one within `1e-6`, and optional valid confidence. `ai/dist/index.js:14421-14544` also checks exact answer keys, finite distribution and chosen argmax. Independent unknown/wrong identity and invalid-distribution checks refuse rather than invent output.
- `@ai-sdk/gateway/dist/index.js:2270-2347` sends the v4 evaluation endpoint with fixed model header. Fake-transport tests exercise the actual installed Gateway and AI SDK, not a guessed substitute API. No real inference was performed.
- **Identity/logging nuance:** Gateway's `doEvaluate` itself sets `response.modelId = this.modelId`; AI SDK also has a requested-model fallback. The app's equality check therefore protects adapter/configuration mismatch, **not independent server-reported model attestation**. A fake response containing a different top-level model id still yields the requested id. Log wording should not claim more. Gateway does not supply a response id here; `null` is honest.
- **Request-count nuance:** SDK evaluation defaults to two transport retries. The independent 503→success fake causes two underlying requests for one `decide` invocation. `model_calls` counts application inference attempts, not Gateway HTTP attempts. No ambiguous **game mutation** retries result from this.
- Current snapshot only; no history fed back, host strategy, pruning, search, action-family ranking or hidden-outcome derivation. Removing bridge bookkeeping is not gameplay pruning. Five real public recorded fixtures parse and retain all legal labels and remaining public context unchanged.
- 64k total / 32k state-plus-question JSON-character checks halt before transport and do not truncate. With one question, the 32k cap dominates. Units are not verified against live provider enforcement; JS character length is not a UTF-8 byte bound, so “conservative” should not be read as a byte-level guarantee.
- Waiting/incomplete/empty states are not decisions. `mutation_pending` alone correctly does not block owned children. Native fingerprint includes state/readiness/actions/private identities (`McpMod.Contract.cs:199-214`), so comparing versions is adequate for this pinned contract; POST additionally recaptures/consumes on the native main thread (`298-333`). I am **not** demanding duplicate full-snapshot freshness logic.
- Dispatch is one POST with exactly `{state_version,label}`; timeout/network ambiguity and rejection halt. There is no POST replay path. Logging occurs synchronously before dispatch; post-dispatch log failure cannot undo an accepted action.
- Existing aborted-inference tests prevent POST; independent **real CLI SIGINT during a pending fake GET** exits 1, emits aborted summary and sends **zero POSTs**. No cancellation/rollback of an already accepted native action is claimed.
- At `max_actions`, summary is based on the last pre-dispatch observation and does not certify completion of the last accepted action. Parent live evidence must separately observe resulting native readiness; `202` is acceptance, not task completion.
- Missing/rounded probabilities remain a live interoperability risk: AI SDK accepts optional/declared-rounded distributions while Effect requires a complete sum within `1e-6`. Safe refusal is correct; Gateway/Jev availability is not proven offline. No request to fabricate or normalize probabilities.

### Native scope / provenance / retained safety

- Exactly five native inventory files differ from `/tmp/jev-m2-generic-events/source`: `BridgeProtocol.cs`, `EventOperation.cs`, `McpMod.EventActions.cs`, `tests/check-bridge.sh`, `README.md`. Three implementation files add the predicate, destination stand-in and existing-SetupLayout bootstrap. Hook installation, selectors, tutorial guards and other production source are unchanged. No new framework/scaffolding is needed.
- Independent metadata extraction from pinned native bytes confirms new singleplayer setup passes zero into `InitializeShared` (IL0059/0060), which stores `_numReloads` (IL0653). Saved singleplayer/multiplayer setup increments persisted reload count before reading it into initialization. No save files were read or game methods invoked.
- Initial `EnterAct` act-0/StartedWithNeow branch directly enters `StartingMapPoint`; other acts open a MapRoom. `_Ready` invokes the existing `SetupLayout` boundary on new scene construction. The gate additionally requires first visited coordinate, start-coordinate equality, Ancient point, unfinished room/model and no currently executing action. Binding then verifies exact run/room/scene/model/layout/player/destination identities. No polling adoption of a preexisting screen.
- Bootstrap requires no live entry and no ambient owner. Existing owned map-entry setup is not replaced; closed/missing entries alone do not bypass the fresh-start predicate. Saved/reloaded/pre-finished/later-act/non-start/foreign-travel cases fail the predicate. Existing source closes entries at scene exit/foreign input and replaces them on the next owned map dispatch.
- Setup's original Task must complete successfully before decisions; option generations/identity/input receipts and retained option tasks remain unchanged. StateChanged is not task completion; owned child decisions can still coexist with a pending parent. Existing scene-exit/foreign-input/fault/cancellation regressions pass.
- **Initial opening is the only new entry claim.** Later-act Ancient room option handling reuses the existing owned-map route, but boss/act-transition reachability remains refused/unverified. Nothing here proves an autonomous multi-act run.
- Exact native delivery, AsyncLocal propagation and Ancient dialogue/option receipts still require a separately approved live gate. Metadata and managed tests cannot certify Godot execution. Existing ordinary-event live evidence does not substitute for Ancient evidence.
- Retained unsupported O2 temporal-cancellation case still fails two checks (74 total), as reported by the writer. This is explicitly **not a pass**, not introduced by this delta, and not a demand to broaden this minimal task into general external-producer recovery.

## Independent evidence / commands / hashes

Full exact runnable validation commands and exits: `/tmp/jev-minimal-demo-review/commands.txt`. All Bun invocations, including two test-spawned CLI processes, have `--no-env-file`. Mock SDK requests use explicit fake keys/fetch; local HTTP fixtures are not the game.

| Command/result | Exit | Evidence |
|---|---:|---|
| `bun --no-env-file test` | 0 | `app-test.log`: 30 pass, 113 assertions |
| `bun --no-env-file node_modules/typescript/bin/tsc --noEmit` | 0 | `typecheck.log`: empty |
| `bun --no-env-file run src/main.ts --max-actions 0` | 2 expected | `cli-invalid.log`: rejected before networking |
| `bun --no-env-file test /tmp/jev-minimal-demo-review/independent.test.ts` | 1 | `independent.log`: 7 pass, 2 fail, 57 assertions; full failures read; no fixes attempted |
| Isolated `dotnet build ... --no-restore -t:Rebuild -c Release` | 0 | `build.log`: 0 warnings/errors; imports disabled and explicit PathMap below |
| Current native `tests/check-bridge.sh` against independent DLL | 0 | `native-current.log`: 1,865 checks |
| Frozen pre-change harness against independent DLL | 0 | `native-retained.log`: 1,842 checks |
| Retained independent late-cleanup / readiness / ordinary / relic / cancellation / teardown | all 0 | `native-{late-cleanup,readiness,ordinary,relic,cancel,teardown}.log`: 93/0 RED, 50, 60, 16, 1,266, red=0 |
| Retained O2 `Check.dll ... temporal` | 1 | `native-o2.log`: 74 checks, 2 known failures, full failure output read |
| Three native metadata-only `IlProbe.dll` commands | all 0 | `native-provenance.il`, `native-entry-proceed.il`, `native-map-open.il` |
| Explicit frozen/current SHA256 comparisons | 0 | `source-comparison.log`: 58/58 equal (19 inventory + 26 compiler inputs + 13 app files); `baseline-delta.log`: exactly five native delta files |
| Both `git diff --cached --name-only` | both 0 | `app-staged.log`, `native-staged.log`: both zero bytes |

Build used `ImportDirectoryBuildProps=false`, `ImportDirectoryBuildTargets=false`, isolated `/tmp/jev-minimal-demo-review/obj/`, copied existing restore assets, `DefaultItemExcludes='obj/**'`, and **`PathMap=/tmp/jev-minimal-demo-review/obj=/Users/yanchenxin/dev/github.com/chenxin-yan/STS2MCP/obj`**. Output only under review scratch; candidate was not installed.

SHA256:

- Independently rebuilt and writer candidate DLL: **`a7bc16d70f4fa76284d5f69d771de5bac77d5aaf08e3311fb09fb078adbf6bdc`**.
- Installed/frozen prior bridge: **`0cd0c0bbf28a3a6565aa0b500c34967b1d623e051dcffa71f27754b5579035aa`** (installed hash independently read, unchanged).
- Pinned native `sts2.dll`: **`9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`**.
- App `CONTEXT.md`: **`0b90a7e6f3825158ab4d15458b216148c5a7c5c46c70e345864fef051088e3b7`**.
- App `mise.toml`: **`9193ec101cad14715bb4679c0c3e6acaf5a5e16702ed876e81d52c0d6a76daad`**.
- Individual app/current/frozen/input hashes are recorded in `source-comparison.log`, `baseline-delta.log`, and `final-app-hashes.log`.

`.env` was never read, hashed, printed or modified by this review. Byte equality cannot be independently certified without reading it; no stronger claim is made. No environment dump occurred. Existing untracked/modified work in both repositories was preserved and neither index contains staged files.

## Minimal next step

Fix the small app boundaries (and finite inference deadline), rerun focused tests; retain this native candidate as an **offline-reviewed initial-entry candidate only**. Parent then resolves the specific initial-map Proceed authorization and selects a short, explicitly approved live gate. Do not finish broad M2, invent a lifecycle hook, adopt the existing checkpoint, or claim M5/full-act support to make this review green.

```acceptance-report
{
  "criteriaSatisfied": [
    {
      "id": "criterion-1",
      "status": "satisfied",
      "evidence": "Completed assigned read-only review of the two implemented scopes; edited neither repository. Only scratch checks/evidence and this required report were written. No unauthorized live operations."
    },
    {
      "id": "criterion-2",
      "status": "satisfied",
      "evidence": "Independent app tests/typecheck/fixtures/real-CLI mocked SIGINT, isolated byte-identical native rebuild, frozen/current hashes and retained regressions; two reproduced app failures and native integration blocker documented with exact evidence paths."
    }
  ],
  "changedFiles": [
    "/tmp/jev-minimal-demo-review/independent.test.ts",
    "/tmp/jev-minimal-demo-review/commands.txt",
    "/Users/yanchenxin/.pi/agent/sessions/--Users-yanchenxin-dev-github.com-chenxin-yan-jev-slay-the-spire-2--/subagent-artifacts/outputs/cd15aafe-2b80-42ee-b2d1-7005eeb89243/reviews/minimal-demo.md"
  ],
  "testsAddedOrUpdated": [
    "/tmp/jev-minimal-demo-review/independent.test.ts (9 focused independent mocked/fixture checks; no repository tests edited)"
  ],
  "commandsRun": [
    { "command": "bun --no-env-file test", "result": "passed", "summary": "Exit 0: 30 pass / 0 fail, 113 assertions" },
    { "command": "bun --no-env-file node_modules/typescript/bin/tsc --noEmit", "result": "passed", "summary": "Exit 0, clean" },
    { "command": "bun --no-env-file run src/main.ts --max-actions 0", "result": "passed", "summary": "Expected exit 2, no network" },
    { "command": "bun --no-env-file test /tmp/jev-minimal-demo-review/independent.test.ts", "result": "failed", "summary": "Exit 1: 7 pass / 2 fail; malformed waiting accepted and missing bound starts fake GET" },
    { "command": "Isolated import-disabled native rebuild; exact command in /tmp/jev-minimal-demo-review/commands.txt", "result": "passed", "summary": "Exit 0, 0 warnings/errors, DLL a7bc16d70f4fa76284d5f69d771de5bac77d5aaf08e3311fb09fb078adbf6bdc" },
    { "command": "Current and frozen native harnesses plus six retained independent suites; exact commands in commands.txt", "result": "passed", "summary": "All exit 0: 1865, 1842, 93/0 RED, 50, 60, 16, 1266, teardown red=0" },
    { "command": "Retained cancellation Check.dll temporal suite", "result": "failed", "summary": "Exit 1: known unsupported O2, 74 checks / 2 failures; not introduced by delta" },
    { "command": "Native IL probes, explicit source/input hash comparisons, protected hashes and both git diff --cached --name-only checks", "result": "passed", "summary": "Exit 0; 58 matches, five-file native delta, protected hashes unchanged, both indexes empty" }
  ],
  "validationOutput": [
    "App happy path/typecheck pass; review requests small input-boundary changes, not broader coverage.",
    "Native initial-entry scope passes offline; Neow Proceed and live Ancient availability remain gated.",
    "No game HTTP, real inference, UI/control/install, save/profile/settings-file access or repository edits."
  ],
  "residualRisks": [
    "Unbounded provider wait/read backoff; model_calls excludes SDK retries; model identity is requested SDK identity.",
    "Native initial-map Proceed authority unresolved; Ancient live receipts/AsyncLocal delivery unverified; later-act transition unsupported.",
    "Gateway/Jev distribution interoperability and request-size units unverified live.",
    "Preexisting unsupported O2 temporal case still has two failures.",
    ".env intentionally not read/hash-verified; no review operation accessed or modified it."
  ],
  "noStagedFiles": true,
  "diffSummary": "No application or native repository diff from reviewer. Added only independent scratch checks/evidence and required review artifact.",
  "reviewFindings": [
    "P2 src/main.ts:12-18: valueless --max-actions silently defaults to ten and starts networking.",
    "P2 src/bridge.ts:41-59: malformed waiting value accepted; loop treats it as non-waiting.",
    "Boundedness src/jev.ts:92-97: no finite model request deadline; GET Retry-After also uncapped.",
    "Integration blocker McpMod.EventActions.cs:161 and McpMod.OrdinaryActions.cs:57-65: initial Neow Proceed remains deliberately unauthorized.",
    "No new native-scope regression found; no install/demo authorization implied."
  ],
  "manualNotes": "Review completion criteria refer to the assigned read-only review, not blanket acceptance of implementation. App changes requested; native scoped offline pass; integration live gate remains parent-owned."
}
```
