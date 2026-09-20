# Independent review — M2 generic ordinary-event path

## Verdict

**PASS for this bounded source/build/managed gate. No blocking defect found in the six-file delta against accepted late-cleanup. Not installed, not live-accepted; full M2 remains incomplete.**

Reviewed against the approved **current-decision completeness / unsupported-follow-up halt** contract in `docs/research/generalized-events.md` and both linked research reports—not the withdrawn requirement to pre-prove every effect/listener. This is reusable ordinary-option support across producers, not universal event support.

Evidence: `/tmp/jev-m2-generic-events-review/` (`commands.log`, logs and exit files, independent driver source, source/compiler inventories, frozen source copies, hashes). Neither repository was edited. No game HTTP, UI/control/launch/install, native/Godot object construction or gameplay invocation, save/profile/settings/credential access, child agents, staging, commits or publication.

## Identity and reproducibility

- App remains `main d1bbc90dce5fe5af2aee561e351a02fbfad0255b`, no tracked changes; sibling remains detached `55e064850a68f3b4cde7e5fd525bf9b2dec4e885`; both indexes empty.
- Exhaustively verified all **19 changed/untracked snapshot files** against current Git inventory and writer freeze. Verified all **28 build-input files**, including the evaluated **25 repository C# compiler inputs**, current ↔ frozen byte-for-byte. Verified accepted baseline manifests too.
- Actual Csc command confirms those 25 sources plus **two SDK-generated sources**, with no additional nested/ignored compiler source. Recorded hashes for **205 explicit compiler/source/reference/analyzer/config inputs** in `compiler-input-hashes.json`; full compiler argv in `csc-command.txt`.
- Exactly six files differ from late-cleanup: `BridgeProtocol.cs`, `McpMod.Contract.cs`, `McpMod.EventActions.cs`, `McpMod.StateBuilder.cs`, `README.md`, `tests/check-bridge.sh`. Four compiler inputs changed; other 24 build-input files are unchanged.
- Two independent Release rebuilds, including diagnostic rebuild, exited **0**, **0 warnings / 0 errors**, and reproduced the writer DLL exactly:

| Artifact | SHA256 |
|---|---|
| Reviewer rebuild and writer candidate | `0cd0c0bbf28a3a6565aa0b500c34967b1d623e051dcffa71f27754b5579035aa` |
| Accepted offline baseline | `3828de49ec906f8e22502452b7cf30d8f429df48e4e7e68fb8a8317640c6f67a` |
| Installed bridge, unchanged | `71ebec737f466c87800262475c94024a70c61dd3bb496229f2386ed5b2dac8bd` |
| Native v0.111.0 / 41cef1ea, unchanged | `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4` |

Used the real source location, explicit game-data path, disabled Directory.Build imports, isolated obj/output and accepted PathMap. Five restore seed files were copied into scratch and verified byte-identical to the accepted review seed; candidate build used `--no-restore`. No deployment target was imported or run.

## Source and actual-DLL findings

### 1. Ordinary admission is genuinely producer-independent

`BridgeProtocol.cs:104–111` removes the audited-model parameter. `McpMod.EventActions.cs:108–159` removes TinkerTime/closure-owner admission without replacing it with an event, callback, relic or listener inventory. The remaining callback-method identity checks are the common native **BeforeOptionChosen** and finished-page **Proceed** infrastructure receipts, not effect-producer allowlists.

Retained: exact run/player/room/model/scene/layout identities; generation and node receipts; native input and Ignore→Stop readiness; locked/reused-option refusal; lethal-confirmation refusal; exact layout membership and `CurrentOptions[nativeIndex]` object identity; unshared synchronizer/run/local-player binding; non-null single callback. Removing the redundant `CurrentOptions.Contains(option)` does not weaken the retained indexed object-identity check. Multicast callbacks still refuse the whole current decision.

The original native `ForceClick → synchronizer → Chosen().RunSafely()` route and uniquely appended task capture remain intact (`DispatchEventOption:215–253`). No callback replacement, effect implementation, general task interception, new Harmony target or schema/framework was introduced.

Independent native IL checks—not constructed event fixtures—verified actual producer edges for ByrdonisNest's gain/add effects, AbyssalBaths and ColossalFlower multipage changes, and AromaOfChaos's `FromDeckForUpgrade`. Verified awaited command state machines, the native Chosen pre-callback/callback awaits, synchronizer task-list capture, and the deck command's hooked `CardsSelected` boundary. These establish real examples of the shared route, not live coverage or an exhaustive event census.

### 2. Observation and dispatch now share native option coordinates

`McpMod.StateBuilder.cs:1418–1444` enumerates the current `Layout.OptionButtons`, preserving the readable-canvas filter and existing visible text/rules fields. `BuildEventState`, `AddEventActions` and `RequireEventOption` all call the same native-index helper; dispatch additionally verifies the current indexed option object. The snapshot no longer assigns scene-tree traversal ordinals. Native `NEventLayout.AddOptions` creates the indexed buttons.

Compiled-wiring checks support reordered/unrelated-node invariance structurally. Actual Godot visibility/order/node-delivery behavior was not simulated or accepted here.

### 3. Owned children do not wait for root completion

`EventOperation.cs`, `SelectionOwnership.cs` and selection/context hooks are byte-identical to late-cleanup. The retained operation still owns compatible selectors/rewards while its original task is pending; completing a child does not replace or release that parent. Contextual event grids remain masked, not adopted merely because an event is now admitted.

The new independent driver exercised the actual DLL's `CaptureAppendedTask`, `BridgeSession`, `EventEntry`, `EventOperation`, `SelectionOwnership`, and `ResolveObservationSelection`: delayed effect → first selector → second selector → new page → delayed final effect. It checked fresh leases, stale/duplicate and foreign child rejection, retained parent ownership, readiness without premature completion, late fault/cancellation after the page change, sticky rejection of fresh versions, and cleanup exactly once. All passed.

### 4. The Contract-scope addition is justified and bounded

`McpMod.Contract.cs:181–199` now lets a non-selector foreground surface fall through the pending wait **only when the session owner is the retained event operation**. It grants no selector lease or new execution authority. Existing downstream CrystalSphere/unsupported-overlay/game-over handling can therefore report the new surface instead of indefinitely waiting for the task that awaits it. A pending event with no foreground surface still waits; unowned selectors still report `unowned_selection_continuation`; other operation owners retain their previous behavior.

This small additional file is consistent with the approved runtime-halt contract. The native CrystalSphere minigame actually awaits its completion source after showing its screen, so this is a reachable problem solved, not speculative instrumentation. Independent tests cover CrystalSphere, game-over, bundle/relic unowned surfaces, absent foreground, and non-event ownership.

**Important retained ceiling:** these unsupported-surface diagnostics are observational, not newly sticky failure receipts. If a human removes/resolves such a surface, existing ownership/task checks may later allow progress. The bridge does not click through, retry the initiating option, roll back effects, or invent task completion. Do not describe this as a new permanent “must explicitly recover” latch. Fault/cancellation failures remain sticky. No automatic-recovery mechanism was added.

### 5. Accepted cleanup and authority remain unchanged

No changes to combat teardown/late-run invalidation, cancellation ownership, reward Offer/ShowScreen/child handling, FTUE seen-at-entry refusal, or contextual selector authorization. Source equality plus retained actual-DLL suites support that conclusion. Existing custom-state serialization branches are not evidence of operational support and were not removed merely to claim a name-free whole application.

## Re-executed tests

All candidate tests below used the independently rebuilt DLL and the pinned native assembly where applicable.

| Check | Exit | Result |
|---|---:|---|
| Supplied current harness, byte-identical to generic freeze | 0 | **1842** actual-DLL checks |
| New independent managed/native-IL/compiled-wiring driver | 0 | **83 checks, 0 RED** |
| Same independent driver against accepted baseline | 1 | **5 expected RED**: two event foreground gates, three shared-index bindings |
| Retained late-cleanup reviewer | 0 | **93 checks, 0 RED** |
| Readiness | 0 | **50** |
| O1 ordinary | 0 | **60** |
| R2 relic | 0 | **16** |
| Cancellation-positive | 0 | **1266**, 0 failures |
| Writer teardown repro | 0 | `red=0` |
| Source/freeze/hash audit, including final rerun | 0 | Exact inventories/hashes/HEADs/indexes |
| Actual compiler-input audit | 0 | 27 C# inputs; 205 explicit input files hashed |
| **Withdrawn O2 temporal external-producer cases** | **1** | **74 checks, 2 known failures — NOT PASS** |

O2 failures remain `early_began_late_state` and `early_began_late_state_skip_cancel`. Kept separate as the previously classified unsupported external-producer scenarios; not reclassified as success or used to demand new global instrumentation.

The frozen *old* supplied harness's three-argument `RequireEventPolicy` call is obsolete, not an ABI promised to consumers. Current/frozen generic harness bytes match. My baseline comparison avoids that signature mismatch and independently demonstrates the changed gate/index wiring. Preliminary scratch-driver authoring errors (operator spacing and a corrected metadata namespace) were corrected before the final 83-check run; they were not candidate defects.

## Commands

Complete paths, commands and per-command logs/exits are in `/tmp/jev-m2-generic-events-review/commands.log`. Core reproduction from the app directory:

```bash
export TMPDIR=/tmp/jev-m2-generic-events-review DOTNET_CLI_TELEMETRY_OPTOUT=1
OUT=/tmp/jev-m2-generic-events-review
GAME='/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2'
DATA="$GAME/SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64"
mise exec -- dotnet build ../STS2MCP/STS2_MCP.csproj --no-restore -t:Rebuild -c Release \
  -o "$OUT/release" -p:STS2GameDir="$GAME" -p:STS2GameDataDir="$DATA" \
  -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false \
  -p:BaseIntermediateOutputPath="$OUT/obj/" -p:DefaultItemExcludes='obj/**' \
  -p:PathMap="$OUT/obj=/Users/yanchenxin/dev/github.com/chenxin-yan/STS2MCP/obj"
mise exec -- bash ../STS2MCP/tests/check-bridge.sh "$OUT/release/STS2_MCP.dll" "$DATA/sts2.dll"
mise exec -- dotnet run --project "$OUT/independent/Check.csproj" \
  -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false -- \
  "$OUT/release/STS2_MCP.dll" "$DATA/sts2.dll"
python3 "$OUT/audit.py"
python3 "$OUT/compiler-audit.py"
```

## Unsupported families and remaining live gates

Expected refusals remain: shared voting; custom/nonstandard layouts; embedded event combat/canonical encounters; lethal-confirmation options; CrystalSphere/custom controls; contextual event grids; bundle/relic selectors without captured ownership; unowned/foreign/overlapping decisions; unsupported modal/tutorial surfaces; terminal, nested or wrong-identity event reward Offers. An initiating ordinary choice may already have applied a cost/effect before a newly encountered unsupported follow-up is reported. None of these families was required to be implemented for this slice.

Parent-owned acceptance still must establish real installed hook/node delivery and ExecutionContext propagation, exact option/readiness behavior, ordinary effect and multipage execution in previously unlisted stock producers, a compatible awaited deck selector while its root is pending, continued native reward/cancellation/cleanup behavior, and runtime halt on an unsupported follow-up without retry. Managed type-token tests cannot substitute for those checks. The paused ByrdonisNest state was not queried or changed, no option was chosen, and no installation is authorized by this report.
