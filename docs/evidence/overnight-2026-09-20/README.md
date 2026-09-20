# Overnight execution — 2026-09-20

**Stopped at the provider prerequisite. No fresh gameplay or full-run attempt occurred.**

Authority: owner-approved `/tmp/jev-overnight-handoff-2026-09-20.md`. This supersedes older
no-M5 statements only conditionally: bounded QA must pass before one full-run attempt.
The payment/response/access stop rule applied before installation or new-run setup.
No push, issue update, credential inspection, save/settings access or tutorial changes occurred.

## Delivered and verified

Starting checkout: `main`, clean at `d89dfdadc18056cbd977e546f54ab7002f48b5e0`.
The other same-checkout session confirmed it had no writers/controllers and remained read-only.
The already-committed README title was preserved, as were `CONTEXT.md` and tool pins.

The map/potion concern is a **reachable native control-flow risk, not an observed live incident**:
map opening sets point alpha to zero before emitting `Opened`, while native potion discard
eligibility need not be disabled. The old bridge could advertise a potion-only complete set.
The CLI can legitimately execute a complete singleton without inference, making completeness
at the bridge boundary essential.

Minimal repair, two production files plus the existing harness:

- Unreadable otherwise-eligible map points, usable potion holders and valid potion targets
  make the whole observation wait; no sibling action is offered as a partial decision.
- Finalization clears both serialized and executable actions while waiting, preventing POST
  from consuming a surviving sibling. A new complete observation restores the alternatives.
- Existing eligibility, visibility thresholds, ownership/task receipts, selectors and hooks
  are unchanged. No arbitrary delay, potion pruning, interception or authority expansion.

[Writer evidence](readiness-writer.md) and [fresh independent review](readiness-review.md)
are retained as returned, including their stage-specific pending notes. The reviewer found
no blockers and explicitly did not rerun commands. **The parent subsequently inspected the
diff, rebuilt/rehashed the candidate and reran current and retained native checks successfully.**
The offline gate is accepted; this is not live certification.

### Checks actually run

Parent command argv, exits and timings: [`offline/commands.jsonl`](offline/commands.jsonl).
Full outputs and the runners are alongside it. Bun offline processes inherited only HOME/PATH;
all Bun commands used `--no-env-file`; typecheck also used `--no-install`. No installs.

| Check | Exit | Result |
| --- | ---: | --- |
| `mise exec -- bun --no-env-file run lint` | 0 | 0 warnings/errors |
| `mise exec -- bun --no-env-file run fmt:check` | 0 | Pass |
| `mise exec -- bunx --no-env-file --no-install tsc --noEmit` | 0 | Pass |
| `mise exec -- bun --no-env-file test` | 0 | 50 tests / 193 assertions |
| Canonical .NET build, imports disabled, no restore/deploy | 0 | 0 warnings/errors |
| Current compiled-DLL harness | 0 | 1950 checks |
| Original retained harness against candidate | 0 | 1909 checks |
| Writer's updated regression against baseline DLL | 134 | Expected RED: waiting map retained executable potion sibling |

The regression exercises compiled production readiness/finalization and normal/owned-child
acceptance, plus actual map/potion/POST wiring checks. It does **not** construct Godot scenes
or execute the entire observation/HTTP path. Pinned native metadata traces are in
[`native-trace/`](native-trace/); probe commands and intermediate failures are preserved in
`offline/writer-commands.jsonl` and `offline/writer-pre-run-notes.md`.
Historical withdrawn O2 remains previously failing (74 checks / two failures), not rerun or
relabeled green. Unrelated action surfaces and later-act/boss transitions are not certified.
Captured IL/diff whitespace is preserved byte-for-byte: the all-evidence staged whitespace
check reports trailing spaces in raw captures; the check excluding captured evidence passes.
This is not a source-code formatting failure.

### Artifact identity

| Artifact | SHA256 |
| --- | --- |
| Installed native `sts2.dll` | `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4` |
| Installed bridge, unchanged | `0cd0c0bbf28a3a6565aa0b500c34967b1d623e051dcffa71f27754b5579035aa` |
| Reviewed/rebuilt candidate, **not installed** | `4b5b756f2022a52d88b7338ad977fc70c82fa90718fa019b0a3485a7f791bcf3` |

Candidate location: `mod/STS2MCP/bin/Release/net9.0/STS2_MCP.dll`; frozen scratch copy:
`/tmp/jev-overnight-readiness/candidate.dll`. Binaries remain ignored/uncommitted. Rebuilding
after the commit can change revision metadata and therefore the hash.

## Provider smoke — blocker

Exactly **one application evaluation** used the unchanged `makeJevDecider` with the existing
Gateway configuration, fixed model `typesafe-ai/jev`, `contextOf` and the full retained public
[`combat-ready.json`](../m2/generic-live/combat-ready.json) legal set. No game transport was
used. Bun/SDK could consume the existing key; no agent inspected its value. The adapter's
60-second deadline and a separate 90-second external timeout were retained.

[`provider/provider-smoke.json`](provider/provider-smoke.json): process exit **1**, total
633 ms; adapter failure after **486 ms**, `invalid_answer: false`. The safe classifier matched
**payment/credit/balance/402**; authentication, probability, deadline and policy indicators
were false. Raw error text/payload was deliberately omitted; no exact HTTP status or exact
account diagnosis was retained. This is a payment-class prerequisite failure, **not proof of
a specific credit balance**, and no probability-contract bug was established.

No valid selected label, distribution, confidence or usage returned. SDK-internal transport
attempts/billable requests are unknown; one application evaluation is not a billing count.
Cost is unavailable, not assumed zero. There was no re-ask, retry invocation, provider/model
substitution, account inspection or local workaround.

**Required before resuming:** owner resolves the Gateway payment/access prerequisite for
`typesafe-ai/jev`, then explicitly resumes verification. Begin with a new provider-only smoke;
only after it passes should verified installation and bounded fresh profile-2 QA proceed.
Do not infer live success from the offline checks or spend further calls to diagnose billing.

## Gameplay and safe checkpoint

- Fresh QA starts: **0/3**. Accepted gameplay actions: **0/60**.
- Gameplay CLI invocations: **0/6**. Model-selected game actions: **0**; forced game actions: **0**.
- No game HTTP request, POST, installation, quit/relaunch, Abandon or new-run setup occurred.
- Initial and final parent fused observations showed the existing diagnostic floor-3 map,
  **75/80 HP, 113 gold**, matching the handoff. Process 50999 held the localhost 15526 listener.
  Final native/installed/candidate hashes still matched the table above; no managed process
  remained running.
- The old run remains a parent-selected diagnostic, not a Jev-owned run. It was left running
  at that map with its old installed bridge; no live controller was started.
- Opening → map → combat → rewards → next-map QA: **not attempted**. Live stop-control,
  fresh-Neow ownership, UI parity and completion/readiness checks remain unverified.
- Full run: **not attempted**, because QA did not pass. No death/victory/terminal outcome claimed.

Readiness workflow `4eba1c4e-1191-4c1e-9182-702afdb1cd84`; writer
`ee02e199-2f3c-44be-b564-9054c7da76b7`; fresh reviewer
`81b507f0-b158-409e-b8a7-613965df4e2c`. Original scratch roots:
`/tmp/jev-overnight-readiness` and `/tmp/jev-overnight-2026-09-20`.
`manifest.json` hashes this retained text evidence (excluding itself).
