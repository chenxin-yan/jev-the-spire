## Review

No issues found.

- **Correct:** `TreasureOperation.cs:130–135` now waits for successful completion of the captured native Skip task, not root completion. This closes the transient claim-only window without deadlocking the root awaiting selection.
- **Correct:** Native `skip-body.il` offsets 0030–0180 show Wait → cancellation check → Proceed.Enable → SetResult. Unpicked cancellation remains rejected by `TreasureOperation.cs:35–49`, including cancellation that leaves Skip successfully completed.
- **Correct:** Observation, dispatch, and continuation readiness share the gate (`McpMod.TreasureActions.cs:51–55,181,208–211,288`). Waiting clears executable actions and marks completeness false (`McpMod.Contract.cs:229–236`).
- **Correct:** Post-pick `GameplayDone`, expected cancellation, reward readiness, and OnlyProceed completion remain unchanged (`TreasureOperation.cs:96–128,137–146`).
- **Correct:** Added tests exercise pending Skip despite elapsed anti-click delay, readiness with root still pending, begun-picking refusal, and fault/cancellation persisting after root success (`tests/check-bridge.sh:310–331`). Native wiring checks cover observation and dispatch (`:2005–2012`). Recorded RED fails at the intended readiness assertion, exit 134.

**Validation:** Read completed parent logs: build passes without warnings; 2,844 native checks pass; 57 application tests / 210 assertions pass; lint, formatting, and typecheck exit 0. No commands or live interactions performed during review.

**Residual live acceptance:** Candidate installation/retest remains outstanding. Managed tests and inspected native IL support this fix; neither the old installed build nor run4 establishes corrected live whole-choice readiness. Retest should verify withholding while Skip is pending, then claim and Skip appearing together.

**Merge verdict: OK with notes** — pending live acceptance remains separate from this source review.