## Review

Scope: read-only inspection of the three changed files, supplied `final.diff` against `7b58630`, native IL artifacts, and supervisor-approved ownership/readiness dependencies. No edits, commands, installation, or live requests performed.

### Correct

- **Native repeat callback is substantiated.** In `implementation/il-executor.log`, `ExecuteActions.MoveNext` allocates its batch TCS at IL 0018–0035, invokes `BeforeActionExecuted` at 0266–0283, loops after paused execution, and completes the batch at 1152–1165. `il-gameaction.log` proves `Execute` accepts states 1/4 and can return while gameplay remains paused; `il-queueset.log` proves state 3 is skipped and resumption changes the same action to state 4. `FinishedExecutingActions` returns the batch task—not lifetime completion of that action. Both same-batch and new-batch resume are therefore legitimate.
- **Admission is narrowly grounded.** `mod/STS2MCP/McpMod.RewardHooks.cs:55–63` requires the exact registered action and native state 1 or 4. `CombatExitOperation.cs:81–98` rejects duplicate initial passes, missing predecessors, unrelated pending predecessor batches, closed operations, and resumed passes after combat ended. Foreign action references are not adopted. Same-task reuse is justified by the native callback boundary, not blanket idempotence.
- **Required task evidence remains additive.** The first batch remains reachable through `RequireExecutionReceipt`; each distinct resumed batch becomes blocking work. Nothing overwrites an earlier task or removes fault/cancellation evidence (`CombatExitOperation.cs:81–98,108–125`). Identical-task reuse leaves that task subject to the existing failure checks.
- **No premature readiness or reward bypass found.** `BridgeProtocol.cs:299–300,382–407` independently requires original completion, visual, and execution success plus the readiness predicate. Consequently, first-batch completion cannot release a paused action. Reward decisions and terminal completion still require blocking work (`CombatExitOperation.cs:154–158,181–217`); release unsubscribes and closes ownership (`McpMod.RewardHooks.cs:83–96`). Selection freshness remains enforced by `SelectionOwnership.cs:140–147` and `McpMod.Contract.cs:333–341`.
- **Change remains focused.** The supplied diff contains no task sweeping, card-name exception, session reset workaround, selection-guard relaxation, or prompt/SDK changes.

### Finding

- **P2 — Callback wiring regression is only partially tested.**  
  `mod/STS2MCP/tests/check-bridge.sh:2017–2019` checks that the compiled closure contains `get_State`, `FinishedExecutingActions`, and `BindExecutionReceipt`, but does not verify the boolean passed to binding. Keeping the phase guard while changing the third argument at `McpMod.RewardHooks.cs:61` to constant `false` satisfies this assertion yet restores the original resume failure. Managed receipt scenarios supply their own boolean and cannot catch that wiring error. The recorded hook mutation removes the state read too, so its failure does not close this gap.  
  **Smallest correction:** strengthen the compiled-callback check to verify the forwarded state comparison and demonstrate rejection of a constant-false-only mutation. Current production source forwards the correct comparison; this is a coverage finding, not an observed implementation defect.

### Evidence and remaining limits

Inspected artifact logs corroborate:

- Baseline: **2770** native/managed checks.
- Behavioral RED: old binding rejects legitimate resume, exit **134**.
- Final: **2830** checks; build succeeds with zero warnings/errors.
- Five recorded mutations fail their intended assertions.
- App gates: **57 tests, 210 expectations**, zero failures; lint, formatting, typecheck exit **0**.
- GREEN/final recorded DLL hashes match `64ffe78e…9792d`.

These are inspected writer artifacts, not independently rerun commands or newly computed hashes. Parent should independently verify the Git diff, candidate/native hashes, build, and offline gates.

The original accepted selection at `run-3b/run-3b.jsonl:195` and unsupported `:225` readback remain preserved. Native IL establishes the lifecycle; it does **not** establish successful live Godot/Harmony execution. Live pausing-card replay, continuation freshness, final-batch completion, and clean readback remain acceptance gates. Multi-pause execution is supported by the rule but lacks a separate live demonstration.

**Merge verdict: OK with notes.** No functional defect found in the inspected repair; one nonblocking coverage gap and live acceptance remain.