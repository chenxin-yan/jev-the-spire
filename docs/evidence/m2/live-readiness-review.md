# M2 live-readiness — independent focused review

## Verdict

**Bounded source/managed repair: PASS.** No blocking production defect established in the two fixes. The independently rebuilt DLL is **byte-identical** to the writer's candidate. This is **not live acceptance or installation authorization**.

**Full M2 remains BLOCKED:** event-family coverage and unexecuted native/live gates remain. The actual menu observation and native reward-disable-to-ready transition have not been re-executed by this review.

No repository source/project edits, new hooks, game requests, gameplay, native scene construction, installation, profile/save/settings reads, inference, or publication were performed. Parent retains installation/live/acceptance authority.

## Findings and production reachability

### 1. Ordered menu context is repaired without authorizing menu actions

- `../STS2MCP/McpMod.Contract.cs:41–49` passes `manager.IsInProgress` and a **deferred** nullable network-service read to `BridgeProtocol.ContextHalt` (`BridgeProtocol.cs:142–153`). It no longer eagerly evaluates `NetService.Type`.
- Profile/modded/initialization refusal precedes invocation of that delegate. A no-run context never invokes it; an active run with a missing service halts `run_network_service_unavailable`; active multiplayer remains refused.
- `CaptureObservationCore:67–81` routes through this gate and preserves pending-session disposal on disallowed context. The modal, terminal `game_over`, then `no_active_run` ordering at `:94–103` is unchanged. No menu actions were added.
- Compiled evidence: `independent-complete.log`, `ContextHalt` IL0063 loads the lambda, IL0074 calls the tested helper; no direct network-service getter occurs in that method. `CaptureObservationCore` IL0012 calls the new context gate.
- Supplied tests exercise 48 context combinations. Independent tests additionally use a **throwing** service delegate for no-run contexts, including invalid/out-of-range profiles: any eager invocation would fail.

The first-live audit's null backing-field evidence grounds this repair in a reachable native lifecycle, not an invented helper input. The original JSON had no stack trace: this fixes the identified eager dereference, not a proof that every other menu singleton read is exception-free. Full native capture was not executed.

### 2. The ordinary card-reward wait is wired before both takes and alternatives

- `McpMod.LegalActions.cs:126–153` examines holders with an offered `CardModel` before adding any reward label. Any false `_isClickable` sets `waiting=true` and exits the branch; missing metadata throws rather than silently pruning or indefinitely waiting.
- `BridgeProtocol.cs:158–168` deliberately examines the whole sequence: a disabled holder does not hide a later missing field. Independent `[false,null]`, `[null,false]`, and `[false,true,null]` checks all halt. Empty input returns false, so a genuinely alternative-only reward is not deadlocked.
- The compiled branch calls the helper at IL1766; its true path writes `waiting=true` at IL1774–1785 and **returns at IL1790**, before `AddCardClick` at IL1919 or alternative enumeration. Independent checks assert this compiled control flow, not merely the presence of an unused helper.
- **Other actions are also suppressed.** The reward phase is selecting, so the earlier combat-action branch does not populate actions (`McpMod.Contract.cs:122,143–150`). After noncombat enumeration, the caller re-reads `waiting` (`:158–163`; compiled IL1833–1864) and branches past `AddPotionActions` at IL2021 when true. The independent compiled check covers this sibling-action guard. `FinishObservation` does not generically clear actions merely because waiting is true; safety here correctly depends on these actual callers, which were inspected.
- `AddCardClick:49–57` retains `_isClickable`, node visibility and hitbox/native-control predicates; `AddClick:39–47` still checks native controls/completion support. The fix does not force-enable, sleep, emit input during observation, or replace native guards.
- `FinishObservation` (`McpMod.Contract.cs:195–211`) reports incomplete while waiting and fingerprints the changed decision. `DispatchLabel:297–314` re-observes, then checks actual current labels/version/owner before dispatch. Missing metadata reaches a whole-observation halt and clears all labels, including previously accumulated ones.

### 3. Native producer verified, with a qualification to the writer's absolute wording

Fresh metadata probes against the pinned installed `sts2.dll` confirm:

- `AfterOverlayOpened` starts `DisableCardsForShortTimeAfterOpening` at IL0142.
- Its `MoveNext` enumerates `_cardRow` grid holders, writes `SetClickable(false)` at IL0054, awaits `Cmd.Wait(0.35, token, false)` at IL0100, and re-enables valid-row holders at IL0244. This is precisely the window identified in the first-live audit; the alternatives are not disabled by this method.
- The independent **instruction-decoded** whole-assembly caller scan finds four `SetClickable` calls: those two, the pool re-enable, and generated Godot method dispatch. Constructor IL0001–0002 initializes `_isClickable=true`.
- **Qualification:** a direct-field-write scan also finds generated `SetGodotClassPropertyValue` and `RestoreGodotObjectData`, in addition to constructor/setter. `native-holder.log` verifies both can assign `_isClickable` from supplied Godot data. Thus “only native setter / cannot false-wait through any other writer” is too broad if read to include property dispatch or restoration. No additional ordinary reward-initialization producer was established, and this is **not a blocker or justification for new hooks**. The bounded claim is about the pinned ordinary screen's gameplay path, not arbitrary property injection/restoration or uninspected scene resources.

The harness initially asserted only two field writers and failed; that assertion was corrected to account for the two generated routes, with the failed result preserved. This was an evidence refinement, not a production-code change.

### 4. Ownership, freshness, cleanup and previous cancellation behavior preserved

The supplied readiness sequence calls production ownership/readiness/finish/session methods, but manufactures its action list and uses a separate session fingerprint for some acceptance checks. It is **not** execution of `AddNonCombatActions` against a native scene.

The new independent harness strengthens this by using **the actual static `_bridgeSession` used by `FinishObservation`**, actual `SelectionOwners`, an owned managed selector identity with the native selector **Type**, and pending Tasks:

- Waiting output is incomplete, empty and pending; Skip, take and a potion sibling are rejected against that exact output/version.
- Disabled-to-partially-disabled, unchanged visible observations keep a stable version—no artificial phase string forces a change.
- The ready output receives a fresh production version; the waiting version is rejected with 409, foreign ownership is rejected, the current child is admitted, and consumed-version replay is rejected.
- Same parent identity and lease remain; callbacks are never invoked. Only completion of retained work triggers one cleanup and closes the lease.

This is compiled-production managed coverage, with IL/source linkage to enumeration; it does **not** construct holders or claim native-scene reproduction.

Retained R2, O1 and cancellation-positive suites pass. The older temporal adversarial harness still fails identically on baseline and candidate: **2 failures/74 assertions**, exit 1. This is the already-adjudicated **unsupported cancellation-producer counterexample**, not a new regression: `m2-o2-provenance.md` established that the real OpenChest-local source's sole cancellation follows Began and is awaited by original Root. I reviewed that adjudication rather than promoting an arbitrary externally controlled CTS invariant back into a production blocker. Positive delayed delivery, retained work, faults/cancellation and cleanup checks remain green.

## Scope and exhaustive provenance

`audit.py` independently compares current repository bytes, writer freeze bytes, copied review bytes and SHA256 manifests, with exhaustive inventories:

- **19/19** candidate files; **28/28** compiler/project/manifest inputs.
- Exact baseline delta is **five files only**: `BridgeProtocol.cs`, `McpMod.Contract.cs`, `McpMod.LegalActions.cs`, `README.md`, `tests/check-bridge.sh` (`independent.diff`).
- No Harmony-target/hook files, map completion, cancellation/ownership controllers, app/M3/M4 files, public API or project files changed in this slice. No speculative refactor found.
- App remains main `d1bbc90dce5fe5af2aee561e351a02fbfad0255b`; sibling remains detached `55e064850a68f3b4cde7e5fd525bf9b2dec4e885`. Both indexes empty, statuses/tracked diffs unchanged, whitespace checks pass. Protected `CONTEXT.md`/`mise.toml` hashes unchanged.
- Audits before and after rebuilding/testing succeed. Full per-file hashes: `/tmp/jev-m2-live-readiness-review/hash-manifest.json`.

| Artifact | SHA256 |
|---|---|
| Independently rebuilt candidate DLL, byte-identical to writer | `71ebec737f466c87800262475c94024a70c61dd3bb496229f2386ed5b2dac8bd` |
| Frozen baseline DLL, unchanged | `dff158c2b5ca3d2c357eb417f2469be49caf332da7c41460956d1897c1be34ed` |
| Native metadata assembly | `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4` |

## Commands, results and build isolation

Artifacts: `/tmp/jev-m2-live-readiness-review/`. **Exact argv, cwd, environment overrides and all exits—including exploratory failures—are retained in `commands.jsonl`; each command has a corresponding `.log` and `.exit`.** `run.py` records commands/results. Prior freeze/build recipes and project imports were inspected before building.

Successful byte-reproducing rebuild, from app root:

```sh
mise exec -- dotnet build ../STS2MCP/STS2_MCP.csproj --no-restore -t:Rebuild -c Release \
  -o /tmp/jev-m2-live-readiness-review/release \
  '-p:STS2GameDir=/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2' \
  '-p:STS2GameDataDir=/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2/SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64' \
  -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false \
  -p:BaseIntermediateOutputPath=/tmp/jev-m2-live-readiness-review/obj/ \
  '-p:DefaultItemExcludes=obj/**' \
  '-p:PathMap=/tmp/jev-m2-live-readiness-review/obj=/Users/yanchenxin/dev/github.com/chenxin-yan/STS2MCP/obj'
```

Only existing NuGet asset/props/targets/cache regular files were copied into the isolated obj directory; no prior Release outputs were reused. Final compilation uses the repository inputs independently proved byte-identical to the freeze, with all obj/output writes redirected. **Exit 0, zero warnings/errors, DLL byte comparison passes.**

An initial literal copied-tree rebuild required escaped PathMap commas (unescaped attempt exit 1); corrected copied-tree builds succeeded but produced nonidentical PDB/DLL debug metadata even after mapping macOS `/private/tmp`. Those byte-comparison failures are retained, not claimed as reproductions. The established source-location/separate-obj recipe above reproduced exact bytes and is the verified final output.

| Final check | Exit / result |
|---|---|
| Exhaustive final audit + byte comparison | **0** |
| Supplied `check-bridge.sh`, candidate | **0**, 1553 checks |
| Same supplied C# heredoc extracted unchanged to scratch project and rerun | **0**, 1553 checks |
| Supplied script, baseline negative control | **134**, expected missing ordered-context regression |
| New independent production/static-session + decoded-IL/native-writer checks | **0**, 50 checks |
| Retained R2 / O1 checks | **0 / 0**, 16 / 60 checks |
| Retained legitimate cancellation-positive suite | **0**, 1266 checks |
| Preserved unsupported temporal-producer counterexample, baseline / candidate | **1 / 1**, same 2 failures/74; not a production regression |
| Fresh native holder/reward metadata probes | **0 / 0** |

Runnable retained checks:

```sh
# N is the exact native assembly path in commands.jsonl; D is the rebuilt DLL above.
mise exec -- dotnet run --project /tmp/jev-m2-live-readiness-review/independent/Check.csproj -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false -- "$D" "$N"
mise exec -- dotnet run --project /tmp/jev-m2-live-readiness-review/supplied-harness/Check.csproj -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false -- "$D" "$N"
python3 /tmp/jev-m2-live-readiness-review/audit.py
```

Other exploratory failures: one independent-harness compilation typo (exit 1, scratch-only correction); an invocation batch supplied an empty native path (supplied exit 134, R2/O1 SIGABRT), then reran successfully with explicit paths; the overly strong two-field-writer assertion failed before its generated-route correction. All are recorded separately. Initial supplied-script runs used its own `mktemp` location despite TMPDIR settings; its trap removed those transient harnesses. The final extracted, unchanged harness keeps source/project/build artifacts under the authorized scratch tree. No repository or installed files were changed by these attempts.

## Remaining ceiling

The full Godot scene, native input guards over actual holders, scene/prefab composition, native wait cancellation/teardown, and real reward-to-ready observation/dispatch transition remain unexecuted. Compiled linkage plus production managed tests are not a substitute for that gate. Visibility and clickability remain distinct predicates; ready-holder tests do not prove all live visibility predicates simultaneously settle. Menu exception attribution remains bounded by the missing original stack trace.

**No installation or further live action is authorized. Bounded repair supported; full M2 BLOCK unchanged.**
