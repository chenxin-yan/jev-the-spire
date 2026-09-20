# Independent owned-teardown review

**Bounded verdict: CHANGES REQUIRED — one P2 late-cleanup regression.** The original legitimate `combat_loop_cancelled` false halt is repaired in the managed production-controller reproduction, and the rebuild is byte-identical. The broader requested sticky human-cleanup/observer-disposal contract is not met. **Full M2 remains BLOCK; no installation or live acceptance authorized.**

## Finding: P2 — cleanup after the authorized exit leaves the owner and observers retained indefinitely

**Locations:** `CombatExitOperation.cs:68–71, 194–198`; `McpMod.NativeActions.cs:149, 176–191`; related existing `McpMod.RewardHooks.cs:85–90`, `BridgeProtocol.cs:141–151`, `McpMod.Contract.cs:67–86`.

Production-reachable sequence:

1. The exact consumed map continuation executes its owned travel, emits the valid old-room `RoomExited`, cancels the old loop through native reset, and successfully finishes its movement/Offer/child receipts. The bridge has not yet received its next observation/`Refresh`.
2. The human returns to the main menu. Native `NGame.ReturnToMainMenu` calls `RunManager.CleanUp(true)` at IL0246. This requires no reflection, another mod, or forged event.
3. `CleanUp` emits no `RoomExited`; its finally block sets `RunManager.State = null` at IL0367. `ActionQueueSet.Reset` sets `_wasReset`, clears the queues and emits queue-changed notifications, **not** `BeforeCancelled` on already-successful actions. A completed task is not retroactively canceled. There need not be any remaining reward selector to revoke.
4. On the next refresh, the candidate accepts the old canceled loop because `_teardown == 2`, but its new `_arrived()` predicate is false because the run disappeared. `Poll` returns false rather than throwing. `ValidateReadyIdentity` does nothing: `ConsumeMap` cleared `Map`, completed travel cleared the reward screens, and `HasDecision` is false.
5. The outer observation path does not rescue this: actual `BridgeProtocol.ContextHalt(..., runInProgress:false, ...)` returns **null**, so `CaptureObservationCore` calls `Refresh`, not `Dispose`. It later displays `no_active_run`, an observation-only halt. The session still has `Failure == null`, `Pending == true`, `Closed == false`; no `OnRelease` runs. Returning in a different `RunState` continues waiting against the old run instead of sticky failure/disposal.

Thus the visible no-run halt is safe against dispatch, but it is **not the required sticky owned-operation failure/cleanup**. The retained `CombatEnded`, `BeforeActionExecuted`, `RoomExited` and associated ownership resources remain registered until an unrelated later event happens to fail the operation. Before this repair, the same canceled old loop forced `Fail` and cleanup on that refresh. This is not merely the preexisting no-run UI behavior.

**Independent executable evidence:** `R/independent/Program.cs` uses the rebuilt production `BridgeSession`, `CombatExitOperation`, `QueuedActionChain`, `SelectionOwnership`, and the exact `RegisterCombatExit` poll-then-`ValidateReadyIdentity` callback shape. It models the native cleanup's null run without inventing an action cancellation. `R/independent.log`: **91 checks, 89 pass, 2 RED; exit 1**:

```
RED cleanup-after-exit ... actual failure=none releases=0
cleanup-after-exit: failure=none pending=True releases=0
RED replacement-run-after-exit ... actual failure=none releases=0
replacement-run-after-exit: failure=none pending=True releases=0
```

The second RED is the same root cause, not another finding. The ordinary non-event destination shape is sufficient (`EventEntry.Bound == false`); unsupported-event rejection must not be used to mask this general lifecycle gap. The counterexample deliberately places cleanup after successful movement, so it does not assume a still-running movement can survive native run destruction.

**Requested correction:** fail the retained consumed-map operation when its run identity disappears/changes, including after the exit receipt, through the existing scoped validation/polling path; distinguish that permanent invalidation from merely not having reached the destination yet. Then prove normal `OnRelease` disposal and sticky refusal after later receipts/new runs. No additional Harmony target is necessary for this finding. No implementation was made here.

## What the repair does establish

- **Initial identities / ownership:** `RegisterCombatExit` retains the initiating card/potion/end-turn action, run, combat room, player combat state, combat UI, player and exact original `_turnLoopTask`; reward entry checks these against the room's combat state. The exact initiating `BeforeActionExecuted` retains its native batch receipt, including post-action win-check failure. The original `CombatEnded(room)` receipt remains mandatory.
- **Turn-state grounding, not an invented CTS invariant:** fresh native scan covered **50,815 bodies / 534,084 resolved members / zero unresolved**. `SetUpCombat` constructs one `CombatTurnState` from the combat state, refuses replacement until reset, and `RunTurnLoopAfter` captures that turn state before awaiting. `_turnLoopTask` is assigned by `AfterCombatRoomLoaded`; `Reset` cancels the retained turn state and does not replace that task. The candidate does **not** explicitly capture/compare a `CombatTurnState` object or token. Its correspondence is inferred from this pinned ordinary single-room lifecycle and retained loop/room identity, not a separately measured runtime turn-state receipt. I did not manufacture a reflection/mod-only state swap as an ordinary producer.
- **Exact continuation and cause:** child dispatch requires the parent's exact map surface and session owner; `ConsumeMap` closes that continuation before adding work. `QueuedActionChain.AddChild` requires the currently executing exact vote and destination. Dispatch additionally checks player, source coordinate/act and vote generation. `ExpectRoomExit` receives that exact child movement, not an arbitrary current executor task.
- **Execution-time provenance / wiring:** the existing subscribed `BeforeActionExecuted` invokes `TravelExecuting` for that action, sampling current run, old room and original loop. Native executor IL0283 invokes the observer before assigning `CurrentlyRunningAction` at IL0305 and invoking `Execute` at IL0316. The continuation-scoped `RoomExited` observer samples the run/current room/current action and demands armed state, same run, old room absent and exact movement. Source and compiled closure checks confirm both registrations and the corresponding `OnRelease` unsubscriptions. The finding above concerns failure to *reach* that otherwise-present disposal, not a missing remove call.
- **Actual exit ordering:** `ExitCurrentRoom` pops the old room at IL0050, calls/awaits its `Exit` at IL0072, then invokes `RoomExited` at IL0171. `CombatRoom.Exit` synchronously calls `Reset(true)` at IL0006 and returns `Task.CompletedTask`. `Reset` calls retained `CombatTurnState.Cancel` at IL0208. `Cancel` uses parameterless `TrySetCanceled` at IL0072/0082. Therefore the canceled loop exception token need not match the private CTS token.
- **Cancellation means waiting, not success:** state 2 only relaxes the non-join canceled-loop rejection; all original work and sticky action cancellation still run through `Check`. Final release additionally requires the loop settled, successful original vote/movement/Offer/child receipts, exact same-run destination, and the existing session destination setup/input gate. `EventInputsReady` and unsupported event policy are unchanged. A room-transition provider, victory, current executor, final UI or elapsed time alone is not accepted.
- **End-turn remains joined:** `joinLoop` still rejects a canceled loop, including an artificially fully observed teardown state. Normal readiness still requires a successful joined loop before consuming the map continuation.
- **No hidden scope expansion:** exhaustive delta is exactly five files, only three compiler inputs. No new Harmony targets, general task interception, event-family coverage, tutorial writes, app/M3/M4 changes or extra source files.

### Independent negative and ordering checks

The supplied 22 scenarios pass, including unarmed/early cancellation, wrong execution run/room/loop, absent/foreign/duplicate exit, old room still current, loop fault, movement task fault/cancellation/sticky cancellation, Offer fault, delayed Offer/destination and end-turn controls.

My additional production-DLL driver covers parameterless cancellation **before** `RoomExited` (native synchronous order, with no invented intervening bridge poll), delayed propagation of that same cancellation until after the exit event, retained unsettled loop, Offer cancellation, explicit child fault/cancellation, vote fault/cancellation, movement completion cancellation/execution fault, original action sticky cancellation, pending/faulted destination setup, and cleanup before exit. These pass; only the two late-run-invalidation checks above fail. Every tested ordinary failure invokes cleanup once and remains sticky.

This matters because the writer's extended repro calls `RoomExited` before canceling the managed signal: useful for deferred loop completion, but not by itself a test of native synchronous `Cancel → RoomExited`. Both relevant propagation orders now have independent coverage. Native `CombatRoom.Exit` is synchronous, so a fabricated main-thread poll inserted between its reset and the enclosing exit event would not establish a live regression.

## Rebuild, inventory and checks

`R = /tmp/jev-m2-owned-teardown-review`. Exact argv, environment overrides, cwd and exits are retained in **`R/commands.jsonl`**; individual logs use the command names below. `R/audit.py` independently verifies every manifest member against current source and writer freeze, exhaustive Git candidate inventory, all build inputs, repository HEADs/indexes/app status and protected app hashes, and the final bytes.

- Current source matches all **19** writer-frozen candidate files and **28** compiler/project/manifest inputs. Versus live-readiness: only `CombatExitOperation.cs`, `McpMod.NativeActions.cs`, `McpMod.RewardHooks.cs`, `tests/check-bridge.sh`, `README.md` differ; only the first three affect compilation.
- App remains `main` at `d1bbc90dce5fe5af2aee561e351a02fbfad0255b`; sibling remains detached at `55e064850a68f3b4cde7e5fd525bf9b2dec4e885`. Empty indexes, unchanged app tracked diff/status and `CONTEXT.md`/`mise.toml` hashes; `git diff --check` passes.
- Independent **Rebuild: exit 0, zero warnings/errors**, isolated `R/obj` and `R/release`, deployment imports disabled, explicit game data path. Read-only source-project build with copied existing restore inputs and the known PathMap recipe reproduced the candidate **byte for byte**:
  - Candidate/rebuilt DLL: `0d539f856f927b50ec507a0ebad0bbf1331fe2dd7bd4b5b2e2f3006d3f1c4b2c`.
  - Prior baseline unchanged: `71ebec737f466c87800262475c94024a70c61dd3bb496229f2386ed5b2dac8bd`.
  - Native unchanged: `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`.

Core rebuild command (through the logging wrapper):

```sh
mise exec -- dotnet build ../STS2MCP/STS2_MCP.csproj --no-restore -t:Rebuild -c Release \
  -o /tmp/jev-m2-owned-teardown-review/release \
  '-p:STS2GameDir=/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2' \
  '-p:STS2GameDataDir=/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2/SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64' \
  -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false \
  -p:BaseIntermediateOutputPath=/tmp/jev-m2-owned-teardown-review/obj/ \
  '-p:DefaultItemExcludes=obj/**' \
  '-p:PathMap=/tmp/jev-m2-owned-teardown-review/obj=/Users/yanchenxin/dev/github.com/chenxin-yan/STS2MCP/obj'
```

| Independent execution | Result |
|---|---|
| Current supplied harness against rebuilt DLL | exit 0; **1758** checks |
| Same supplied C# extracted unchanged under `R/supplied` and rebuilt with imports disabled | exit 0; **1758** checks |
| Current harness against prior DLL | exit 134 at named owned-exit capability assertion |
| Prior unchanged harness against new DLL | exit 134 at old map-release assertion; fixture lacks the newly required exit receipts, not evidence that the new receipt requirement is wrong |
| Original diagnosis repro against prior DLL | exit 1; **6 PASS / 2 RED**, original parameterless-cancel pending/final false halt reproduced |
| Writer's extended repro against prior/new DLL | exit 1 / exit 0; **2 RED / 0 RED** |
| Focused independent production driver | exit 1; **91 checks / 2 RED**, late-cleanup finding above |
| Retained O1 / R2 / live-readiness independent checks | exit 0 each; **60 / 16 / 50** |
| Retained cancellation-positive suite | exit 0; **1266** checks |
| Retained unsupported O2 temporal counterexample | exit 1; **74 checks / 2 failures**, classified separately below |
| Fresh native reference scan and IL probes (run cleanup/exit, turn state, combat setup/loop/reset, executor, human exit) | exit 0 each |
| Final inventory/hash audit | exit 0 |

Focused driver command:

```sh
mise exec -- env TMPDIR=/tmp/jev-m2-owned-teardown-review DOTNET_CLI_TELEMETRY_OPTOUT=1 \
  dotnet run --project /tmp/jev-m2-owned-teardown-review/independent/Check.csproj \
  -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false -- \
  /tmp/jev-m2-owned-teardown-review/release/STS2_MCP.dll
```

**O2 is not this finding:** its externally controlled early cancellation/later `Began` callback producer remains the previously unsupported provenance counterexample. I retained its failing result without promoting it to an ordinary native producer or counting it as a new regression in this slice. The late-cleanup finding instead uses an independently reachable native menu/cleanup path and the actual run-state lifecycle.

Execution bookkeeping: three initial shell-variable invocations passed an empty native argument (supplied exit 134, two probes -6); explicit Python argv reruns succeeded. No native probe ran in those failed attempts. The unmodified shell harness's `mktemp` reported auto-cleaned platform temporary paths outside `R` despite the requested TMPDIR; the final unchanged extracted harness was explicitly built under `R`. No project/source edits, game HTTP/UI/launch, native/Godot construction, save/profile/settings/credential reads, installs, staging/commits, GitHub, inference or subagents were used. All retained new review files are under `R` plus this report.

## Remaining acceptance boundary

Fix and independently rerun the late-run-invalidation cleanup regression before accepting this slice. The repair otherwise demonstrates the intended owned old-room cancellation handoff offline, not installed event delivery or live gameplay success. Single-room-stack scope and unsupported ByrdonisNest/event-model gate remain unchanged. Parent alone owns installation, live card/potion/end-turn/reward/map/destination verification and publication. **Full M2 remains BLOCK independently.**
