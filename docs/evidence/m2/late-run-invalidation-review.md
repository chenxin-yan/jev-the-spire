# Retained P2 review: late run invalidation

**Bounded source/managed verdict: PASS. My P2 late-cleanup finding is resolved.** No new finding in this focused delta. **Full M2 remains BLOCK** for broader coverage/live gates, including unsupported event models. This is not installation or live authorization.

## Independent red → green

Copied my original driver **unchanged** into `R/independent`, where `R = /tmp/jev-m2-late-cleanup-review`:

- `Program.cs` SHA256 `d0e81e85326d2d075fd2cae7dc705d4f5a35a6f415cccfa32312bed197a22a2a`.
- Prior candidate: **exit 1; 91 checks / 2 RED**, reproducing the original null-run/replacement-run leak.
- Independently rebuilt new candidate: **exit 0; 93 checks / 0 RED**. The extra two checks are the original driver's previously unreachable sticky-once assertions, not test edits.

```
cleanup-after-exit: failure=reward_run_invalidated pending=True releases=1
replacement-run-after-exit: failure=reward_run_invalidated pending=True releases=1
```

The unchanged driver also preserves native-order parameterless cancellation, posted cancellation propagation, pending loop/setup, task faults/cancellations, and cleanup-before-exit checks. No token equality or new native-state invariant was introduced.

## Why the scoped correction works

`CombatExitOperation.cs:68–76` adds only the `_roomTransition != null && !ReferenceEquals(Run, run)` guard. Production `DispatchMap` calls `ConsumeMap` then `AddMapWork` in its child branch, establishing that scope. The original `RegisterCombatExit` ready callback still:

1. Calls `operation.Poll(...)`.
2. Samples `RunManager.DebugOnlyGetState()` and its current room.
3. Calls `ValidateReadyIdentity` **regardless of whether Poll returned false or true**.
4. Returns completion only after validation.

Consequently the former `_arrived() == false` permanent wait now throws `reward_run_invalidated` when the run disappears/changes. `BridgeSession.Refresh` catches that exception and invokes normal `Fail → Release`. `Release` clears its delegate before invoking each cleanup; subsequent refreshes return early on the sticky failure.

Same-run room changes are deliberately not rejected. Supplied checks preserve pending movement, delayed Offer and arrival; the unchanged independent driver preserves pending destination setup. They remain pending without release until their own receipts succeed. Supplied late-cleanup checks additionally restore the original run, deliver remaining receipts, then substitute a new run: none heals the failure or repeats cleanup.

**Real wiring, not only helper assertions:** reread production registration/dispatch/release paths and independently decoded the rebuilt DLL. **Six compiled-wiring checks passed**, proving the scoped Poll/current-run/validation call sequence, `HoldUntil` registration, and existing cleanup callbacks containing:

- `remove_CombatEnded`, `remove_BeforeActionExecuted`, owner `Close`;
- `remove_RoomExited`, `remove_ActionEnqueued`, `remove_NodeAdded`, `remove_BeforeCancelled`, `remove_AfterFinished`;
- registration of map cleanup with `OnRelease`, and `Refresh → Fail → Release` routing.

Thus the reported owner/observer retention is fixed at the next bridge poll. Managed release counts and compiled/source wiring establish disposal behavior within this review's scope; actual installed native delegate delivery remains a live boundary.

The native provenance is unchanged from the prior review: ordinary menu cleanup calls `RunManager.CleanUp`, nulls `State`, emits no `RoomExited`, and does not retroactively cancel successful action tasks. I reused that pinned evidence; no new full-game scan was performed.

## Scope/inventory and reproducible build

Independently verified both frozen manifests and every current candidate member: **19 source files**, **28 compiler/project/manifest inputs**, exhaustive Git candidate inventory. Compared with `/tmp/jev-m2-owned-teardown/source`, the exact delta is:

- `CombatExitOperation.cs`: one guard plus explanatory comment;
- `tests/check-bridge.sh`: focused regressions;
- `README.md`: contract sentence.

Only **one compiler input** changed; the other 27 build inputs are byte-identical. The independently generated `R/actual.diff` exactly matches the writer's incremental diff. `ContextHalt`, global observation/disposal, native subscriptions, Harmony targets and event policy are unchanged. No extra hooks/callbacks/state were added.

Source-location rebuild used copied existing restore inputs, isolated `R/obj` and `R/release`, imports disabled, explicit game paths and the known PathMap recipe. **Exit 0; zero warnings/errors; byte-identical to writer freeze**:

**`3828de49ec906f8e22502452b7cf30d8f429df48e4e7e68fb8a8317640c6f67a`**

Prior candidate `0d539f856f927b50ec507a0ebad0bbf1331fe2dd7bd4b5b2e2f3006d3f1c4b2c`, frozen baseline `71ebec737f466c87800262475c94024a70c61dd3bb496229f2386ed5b2dac8bd`, and native `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4` were rehashed unchanged.

App remains `main` at `d1bbc90dce5fe5af2aee561e351a02fbfad0255b`; sibling remains detached at `55e064850a68f3b4cde7e5fd525bf9b2dec4e885`. Empty indexes, unchanged app tracked diff/status and protected `CONTEXT.md`/`mise.toml` hashes; `git diff --check` and final audit exit 0.

## Commands and results

Exact argv, cwd, environment overrides and exits: **`R/commands.jsonl`**. Each row below has its named log under `R`.

| Command/check | Exit/result |
|---|---|
| `build` | 0; byte-identical candidate |
| `independent-before` / `independent-after` | 1, 91/2 RED → 0, 93/0 RED |
| `supplied-before` | -6 (SIGABRT; shell equivalent 134), named `run-cleanup-after-exit … actual none releases=0` regression |
| `supplied-after` | 0; **1809** actual-DLL checks |
| `binding` | 0; **6** compiled production-wiring checks |
| `o1` / `r2` / `readiness` | 0 each; **60 / 16 / 50** checks |
| `cancel-positive` | 0; **1266** checks |
| `writer-repro` | 0; **0 RED** |
| `unsupported-o2` | 1; **74 checks / 2 known failures**, separate classification below |
| `audit-frozen-final` | 0; exhaustive source/input/hash/protected-file audit |

The current supplied script's C# and project payloads were extracted unchanged into `R/supplied` and executed there, avoiding its platform-default `mktemp` location. All new harness builds disabled Directory.Build imports. No failed implementation iteration or unexpected check failure occurred.

Core rebuild command:

```sh
mise exec -- dotnet build ../STS2MCP/STS2_MCP.csproj --no-restore -t:Rebuild -c Release \
  -o /tmp/jev-m2-late-cleanup-review/release \
  '-p:STS2GameDir=/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2' \
  '-p:STS2GameDataDir=/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2/SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64' \
  -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false \
  -p:BaseIntermediateOutputPath=/tmp/jev-m2-late-cleanup-review/obj/ \
  '-p:DefaultItemExcludes=obj/**' \
  '-p:PathMap=/tmp/jev-m2-late-cleanup-review/obj=/Users/yanchenxin/dev/github.com/chenxin-yan/STS2MCP/obj'
```

Original-driver commands, after copying its two source files byte-identically:

```sh
mise exec -- env TMPDIR=/tmp/jev-m2-late-cleanup-review DOTNET_CLI_TELEMETRY_OPTOUT=1 \
  dotnet build /tmp/jev-m2-late-cleanup-review/independent/Check.csproj \
  -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false
mise exec -- dotnet /tmp/jev-m2-late-cleanup-review/independent/bin/Debug/net9.0/Check.dll \
  /tmp/jev-m2-owned-teardown/release/STS2_MCP.dll
mise exec -- dotnet /tmp/jev-m2-late-cleanup-review/independent/bin/Debug/net9.0/Check.dll \
  /tmp/jev-m2-late-cleanup-review/release/STS2_MCP.dll
```

**O2 classification unchanged:** the early-cancellation/later-Began temporal counterexample still fails with its previously unsupported external producer. It is neither new native reachability evidence nor a regression of this one-line run-invalidation repair. The genuine native late-cleanup counterexample now passes.

## Remaining boundary

The guard detects invalidation at the next main-thread observation/refresh, not synchronously inside native cleanup. Until that poll the existing subscriptions remain; no new timer or cleanup interception was authorized or added. Before map work is attached, existing decision identity checks remain unchanged.

No project/source edits, native/Godot construction or execution, gameplay HTTP/UI, game launch/install, protected-data access, GitHub/publication or subagents. New scratch files remain under `R`, plus this report. Installed candidate untouched. Parent alone owns native/live acceptance and any installation. **P2 source/managed PASS does not unblock full M2.**
