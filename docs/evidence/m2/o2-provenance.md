# M2 O2 — cancellation-source provenance adjudication

## Decision

**I withdraw O2 as a production-runtime blocker for this pinned, supported treasure path.** It remains a genuine counterexample to the broader helper invariant requested in the earlier review—not a demonstrated reachable cancellation producer. My previous review promoted that invariant violation to a bounded acceptance blocker without establishing cancellation authority. That conclusion was too strong.

**O1's legitimate delayed-`CancelAsync` false halt remains independently verified fixed. No additional runtime defect is established by O2. Full M2 remains BLOCK on its separate coverage/native/live gates. No installation authorization.**

## 1. Exact source and cancellation authority

Fresh metadata evidence is under **`/tmp/jev-m2-o2-provenance/`**. A decoded-IL reference scan covered **50,815 native method bodies, 534,084 resolved member operands, zero unresolved operands**. It searched references to the exact OpenChest source field, room source, skip token field, OpenChest and EnableSkipAfterDelay—not merely similar `Cancel` names.

### The OpenChest-local source

`NTreasureRoom.<OpenChest>d__26` is a private nested state-machine type. Its `<cancelSource>5__2` field is private. Across the pinned native assembly, **all five references to this field are in its own MoveNext**:

| IL | Operation and authority |
|---|---|
| **0412–0417** | Parameterless `new CancellationTokenSource()` stored in the private state-machine field. No initial timeout, linked source, room-source alias or external source argument. |
| **0464–0474** | Load source; call `get_Token`; pass only the **token value**, with delay 2.5, to `EnableSkipAfterDelay`. |
| **0592–0597** | Load source; call its **sole cancellation writer, `CancelAsync()`**. This follows Began await `GetResult` at **0586**. |
| **0903–0904** | Clear source reference on exception; original Task faults/cancels through `SetException`. |
| **0933–0934** | Clear source reference on success before original Task `SetResult` at **0945**. |

There is no other source load, address escape, store into a scene field, `Cancel`, `CancelAfter`, `CreateLinkedTokenSource`, or cancellation delegate capturing this source. The only native caller of private `EnableSkipAfterDelay` is this OpenChest call. OpenChest itself takes **no source/token argument**; its original Task is produced by its own async builder. The only native call site is `OnChestButtonReleased` (IL0001), which then passes the Task to RunSafely.

### The token consumer chain

Fresh `room.il` and `wait.il` establish the complete relevant token route:

1. `EnableSkipAfterDelay` copies its token argument into its own state machine at **0031**.
2. Its MoveNext reads that token at **0024**, passing it to `Cmd.Wait` at **0030**. After the wait it reads `IsCancellationRequested` at **0118–0123** and enables proceed only if false. These are its only token-field uses.
3. `Cmd.Wait` passes the token to `WaitInternal` at **0128–0133**. Its instant/noninteractive/other early-success branches do not cancel anything.
4. `WaitInternal` passes the token to **`Task.WaitAsync(CancellationToken)` at 0038–0043**. The timer/signal Task is independent; timeout completes that wait, not the source.
5. CLR metadata for the review runtime (.NET 9.0.20) shows `CancellationPromise` registers through `token.UnsafeRegister` (**0168**). The cancellation callback calls **`TrySetCanceled(token)` on the promise Task**, then Cleanup. Cleanup disposes the registration and removes the continuation; it does **not** call source cancellation. This is downstream cancellation observation, not upstream cancellation authority.

A `CancellationToken` contains a **private readonly** source reference; its public API exposes observation, waiting and registration, **not Cancel/CancelAsync or a source getter**. `CancellationTokenRegistration.Token` returns another token; Dispose/Unregister removes a callback, not the source's cancellation state. Holding the token or its registration therefore does not provide the cancellation capability my harness held. Extracting the private source by reflection/unsafe access is outside the stated boundary.

### Room exit and human/native callbacks

There **is** another cancellation source on `NTreasureRoom`: `_cts`. This was important to check rather than assume away:

- `.ctor` and `_EnterTree` each allocate their own `_cts` instance.
- `_ExitTree` calls **`_cts.Cancel()` at IL0001–0006**.
- Its only other native reference is `RelicFtueCheck`, which passes `_cts.Token` to its tutorial wait.
- It is **not** the OpenChest-local source. No assignment or link joins them. Collection-owned cancellation sources likewise cannot alias a source that never escapes its OpenChest state machine except as this read-only token.

The inspected chest/proceed/active-screen handlers do not possess the OpenChest source. Human skip invokes the pick/synchronizer/proceed path; it does not directly cancel that source. Human chest activation creates another OpenChest invocation rather than canceling this invocation. Room exit cancels the distinct `_cts`; bridge `TreeExiting` separately latches `treasure_scene_exited`. A supported human/room-exit path that requests **this exact source** before Began was **not found**, and the exhaustive field-use/capability trace excludes such a path without arbitrary reflection or code modification.

## 2. Production capture and root proof

The bridge does not accept a caller-supplied CTS:

- `TreasureOpenPrefix` requires the current registered operation, matching scene/run/player/collection and original Began/Finished Task identities; duplicate/foreign opens fail.
- `TreasureSkipPrefix` receives the original native **token by value**, not `ref` and not a source. It validates the ambient operation/scene, single entry, 2.5 delay, cancellability, initially unrequested state and holder collection snapshot. It calls production `RegisterSkipCancellation` and registers disposal on session release. It neither substitutes the argument nor skips the original method.
- `RegisterSkipCancellation` stores the token and registers `CancelObserved`. The callback has no CTS or cancellation writer. Production callers do not directly invoke it or register it on another source.
- `TreasureTaskPostfix` captures original OpenChest `__result` into Root; it does not capture RunSafely's wrapper or manufacture a completion Task. Finalizers preserve native exceptions and fail ownership. `OnlyProceed`'s intentional completed Root is a separate unopened-chest branch, not the cancellation path.
- Successful chest gameplay still requires original Root, pick, awards, Finished, Obtain where applicable, skip and Offers/children. Poll additionally requires original proceed/map receipts. Scene failure/closure remains sticky.

**Yes: under this proven single-writer provenance, successful original OpenChest Root proves its ordered Began await, its own CancelAsync await and subsequent native cleanup completed successfully.** IL **0602–0685** retains and awaits that CancelAsync Task, and the success path does not jump around it. Callback delivery cannot make this retained Task succeed early. Root success is not proof that detached Obtain/AfterObtained or other children finished; the additional existing barriers remain necessary and unchanged.

This conclusion is conditional on the actual pinned producer, not a general theorem about arbitrary Tasks/CTSs. CLR `CancelAsync` returns a completed Task if cancellation was already requested; with an invented earlier external writer, an arbitrary later call would not establish the same provenance. The actual producer trace excludes that writer. My temporal harness supplied both the external writer and a separately completable root Task, so its helper inputs did not carry native Root's production guarantee.

## 3. What remains true about O2

The preserved harness is unchanged and its assertion still **fails**:

```text
requested before Began; callback after Began;
expected=True; failure=none; pending=False; closed=True
```

Both successful/canceled Skip variants produced **2 failed assertions out of 74**, exit **1**, in the original review and all ten repetitions. I am **not** relabeling that execution as a passing test.

It demonstrates that callback-time/current-state checks do not reconstruct request-time readiness for an arbitrary externally controlled CTS. No timestamp or instantaneous-request event is supplied by `CancellationToken.Register` under `CancelAsync`; callback delivery may be delayed. The stronger requirement “reject every earlier request even if readiness changes before any observer/callback executes” exceeds this helper's supported producer contract. It is not needed to guard a native source whose only request is already ordered after Began.

The original **O1** was different: its requested=true/callback-not-delivered interval is produced by that sole legitimate native CancelAsync call. That runtime race was real, and the bounded repair correctly tolerates its delivery window while retaining original work. Nothing in this adjudication weakens its regression or completion barriers.

### Smallest supported remedy

**No production-code change is justified by O2.** Do not add hooks, source interception, timers, Task scheduling machinery or broader canceled-task acceptance.

Correct the review/implementation wording and test classification:

> Cancellation support is specific to the pinned OpenChest-local source. Its sole cancellation call follows successful original Began and is awaited by original Root. The bridge tolerates asynchronous callback delivery and rejects observed inconsistent/foreign/failed receipts; it is not a general request-time cancellation provenance monitor for externally controlled sources.

Keep the legitimate O1 gated-delivery, original-root/Obtain/map, failure and close/disposal checks. Preserve the O2 artifact as a **synthetic unsupported-producer counterexample**, not a claimed passing safety regression or an outstanding production blocker. Existing early/foreign defensive tests may remain, but their passing cases must not be described as proving rejection of all adversarial cancellation orderings. The native provenance evidence supplies the missing scope qualification. Revisit this decision if the pinned producer changes, a source escape/additional writer appears, or token/root adoption is broadened.

## Evidence and checks

- App main **`d1bbc90dce5fe5af2aee561e351a02fbfad0255b`**; fork detached **`55e064850a68f3b4cde7e5fd525bf9b2dec4e885`**.
- Reused independent audit: **exit 0**, 19 candidate files/28 compiler-project-manifest inputs match frozen bytes/hashes; statuses/HEADs/empty indexes/protected hashes unchanged. Final manifest checks also **exit 0**.
- Native SHA256: **`9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`**.
- Candidate DLL SHA256: **`dff158c2b5ca3d2c357eb417f2469be49caf332da7c41460956d1897c1be34ed`**.
- Preserved O2 source SHA256: **`8e2d46c3dbafc3ac810aa351c7aed2e85a6e72efceb4e6da61fa22c4030df818`**.
- `references.log` SHA256: **`afdae0ae129c28df8545d8d295a56ff3d9406f04ce6d4611507e3ac974375108`**. Additional artifact hashes in `hashes.log`.

Commands used `TMPDIR=/tmp`; metadata-only probes did not construct native objects or invoke native methods:

```sh
R=/tmp/jev-m2-o2-provenance
N='/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2/SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64/sts2.dll'
TMPDIR=/tmp mise exec -- dotnet /tmp/jev-m1-safety-code/ApiProbe.dll "$N" MegaCrit.Sts2.Core.Nodes.Rooms.NTreasureRoom MegaCrit.Sts2.Core.Commands.Cmd
TMPDIR=/tmp mise exec -- dotnet /tmp/jev-m1-safety-code/IlProbe.dll "$N" MegaCrit.Sts2.Core.Nodes.Rooms.NTreasureRoom .ctor _EnterTree _ExitTree _Ready OpenChest EnableSkipAfterDelay '<EnableSkipAfterDelay>d__27' '<OpenChest>d__26' RelicFtueCheck '<RelicFtueCheck>d__28' OnChestButtonReleased OnProceedButtonPressed OnProceedButtonReleased OnActiveScreenChanged
TMPDIR=/tmp mise exec -- dotnet /tmp/jev-m1-safety-code/IlProbe.dll "$N" MegaCrit.Sts2.Core.Commands.Cmd '<Wait>d__1' '<WaitInternal>d__2'
TMPDIR=/tmp mise exec -- dotnet build "$R/metadata/Probe.csproj" -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false
TMPDIR=/tmp mise exec -- dotnet "$R/metadata/bin/Debug/net9.0/Probe.dll" "$N"
TMPDIR=/tmp mise exec -- dotnet build "$R/clr-metadata/Probe.csproj" -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false
TMPDIR=/tmp mise exec -- dotnet "$R/clr-metadata/bin/Debug/net9.0/Probe.dll" /tmp/unused 'System.Threading.Tasks.Task+CancellationPromise`1' .ctor Cleanup
TMPDIR=/tmp mise exec -- dotnet "$R/clr-metadata/bin/Debug/net9.0/Probe.dll" /tmp/unused 'System.Threading.Tasks.Task+CancellationPromise`1+<>c' '<.ctor>b__3_0'
TMPDIR=/tmp mise exec -- dotnet "$R/clr-metadata/bin/Debug/net9.0/Probe.dll" /tmp/unused System.Threading.CancellationTokenSource CancelAsync
```

All above probes/builds **exit 0**; metadata builds have zero warnings/errors. Two preliminary attempts to load CoreLib with the old path-loading probes exited **134** (`FileNotFoundException` from `LoadFromAssemblyPath`); their logs/exits remain. The CLR metadata probe instead uses the already-loaded `typeof(object).Assembly`, with generic resolution context. No safety regression was rerun or edited in this follow-up; original results are preserved.

## Narrow verdict

**O2: internal overbroad contract/test claim needing correction, not an unresolved or demonstrated runtime blocker.** No P0/P1/new P2 production defect established here. The earlier bounded-review BLOCK attributable solely to O2 is withdrawn; O1's bounded source/managed repair remains supported by the prior independent rebuild and regressions.

**Full M2 remains BLOCK independently:** required-family coverage gaps, installed-hook/rollback behavior, Godot signals/prefabs/AsyncLocal propagation, native variants, transitive GET purity, rendering/peek parity and zero-human-input live acceptance are not resolved by this provenance review. No installation or live verification is authorized.

No repository source/test edits, gameplay/native objects, HTTP/UI, installation, saves/settings/profiles/.env, inference, GitHub, staging or commits. New work consists only of `/tmp` metadata tools/evidence and this mandated report; no runtime interception or instantaneous cancellation event was invented.
