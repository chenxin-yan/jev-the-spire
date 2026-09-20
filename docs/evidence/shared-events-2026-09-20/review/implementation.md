# Sole-player shared-event support: implementation

Baseline HEAD `58b053a`, working tree only (nothing staged/committed/installed). Native `sts2.dll` SHA256
`9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4` (verified). Installed bridge unchanged:
`f16fd24269faac9ffdeca7c0566d9bc9aa088284f5b55bc96e981620dcdf11ef` (`implementation/installed-dll.sha256`).

## Changed paths

- `mod/STS2MCP/BridgeProtocol.cs` — `RequireEventPolicy(bool shared, bool embeddedCombat, bool soleLocalPlayer)`:
  shared refused only without a proven sole local player. New pure `RequireEventSynchronizer(shared, synchronizerShared,
  voteSlots, pendingVotes)` (flag agreement; no pending vote; shared needs exactly one vote slot) and
  `EventChoiceCompleted(shared, pageBefore, pageAfter, pendingVotes)` (shared: page +1 and no vote; ordinary: page unchanged).
- `mod/STS2MCP/McpMod.EventActions.cs` — `SoleLocalPlayer(entry)`: `run.Players.Count == 1 && Players[0] == entry.Player &&
  RunManager.NetService.Type == Singleplayer`. `EventInputsReady`/`RequireEventOption` pass it to the policy. Per-option
  synchronizer identity now also binds `_canonicalEvent == model.CanonicalInstance`, `_netService == RunManager.NetService`,
  `_playerVotes` (typed `List<uint?>`), then calls `RequireEventSynchronizer(model.IsShared, sync.IsShared, ...)` (replaces the
  bare `sync.IsShared` refusal). `DispatchEventOption` reads `_pageIndex`/`_playerVotes` before the unchanged
  `CaptureAppendedTask(tasks, () => button.ForceClick())` and throws `event_choice_receipt_unverified` (sticky
  `mutation_dispatch_failed`) unless `EventChoiceCompleted` holds.
- `mod/STS2MCP/tests/check-bridge.sh` — behavioural RED/GREEN seam, policy 2×2×2 matrix, synchronizer matrix,
  sole-player receipt fixture (success / stalled_vote / vote_left / double_page / no_page / no_task / two_tasks / ordinary /
  ordinary_page_moved, delayed completion via TCS), wiring checks, native chain/IL checks, field-compat list extended.
- `mod/STS2MCP/README.md`, `docs/research/generalized-events.md` — concise current-scope note (owner approval supersedes the
  historical shared-voting exclusion for the sole-player singleplayer case only).

No new Harmony target, no event-name exception, no direct synchronizer/effect call, no TypeScript/prompt/reward changes.

## Native contract evidence (metadata/IL, `/tmp/jev-morphic-2026-09-20/implementation/*.log`)

- `NEventRoom.OptionButtonClicked`: locked → return; proceed → `Chosen` directly; `_event.IsShared` → skips `ClearOptions`;
  then `EventSynchronizer.ChooseLocalOption(index)` (`il-neventroom-click.log`).
- `ChooseLocalOption`: `IsShared` (= `_canonicalEvent.IsShared`, throws if no event) → `PlayerVotedForSharedOptionIndex(LocalPlayer,
  index, _pageIndex)` → `_netService.SendMessage` ; else `ChooseOptionForEvent` (`shared-choice.il`).
- `PlayerVotedForSharedOptionIndex`: page must equal `_pageIndex`; `_playerVotes[slot] = index`; `PlayerVoteChanged`; if all slots
  voted and `_netService.Type != Client(3)` → `ChooseSharedEventOption` → `Rng.NextItem(_playerVotes)` → `ChooseOptionForSharedEvent`.
- `ChooseOptionForSharedEvent`: `IsShared` guard; `ClearPlayerVotes`; `_pageIndex++`; for each `_playerCollection.Players` →
  `ChooseOptionForEvent(player, index)` → `_pendingOptionTasks.Add(RunSafely(CurrentOptions[index].Chosen()))`.
- `BeginEvent` is the sole writer of `_events`/`_canonicalEvent` (`ResumeEvents` only resumes); `_events[i] = canonical.ToMutable()`,
  and `ToMutable` sets `CanonicalInstance` (`il-synchronizer-support.log`, `callers-beginevent.log`). `_playerVotes` grows to
  `Players.Count` and never shrinks.
- `NetSingleplayerGameService.get_Type` is `ldc.i4.1; ret` (Singleplayer), both `SendMessage` overloads are bare `ret`
  (asserted byte-exact in the harness); `NetGameType {None 0, Singleplayer 1, Host 2, Client 3, Replay 4}`.
- `NEventRoom.BeforeOptionChosen` branches `Players.Count > 1 && sync.IsShared && !proceed` → `BeforeSharedOptionChosen`; else
  `DisableOptionButtons` — native itself treats a sole player as ordinary. `NEventLayout.AddOptions` shows the shared label only when
  `Players.Count > 1` (`il-neventroom-beforechosen.log`, `il-neventlayout.log`).
- `MorphicGrove.get_IsShared` is `ldc.i4.1; ret` (`morphic-shared.il`). Sole-player chain therefore completes synchronously
  inside `ForceClick`, appending exactly one task and advancing exactly one page.

## Validation

| Step | Command | Exit |
|---|---|---|
| Baseline build | `dotnet build ... -c Release -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false` | 0 (`build-baseline.*`) |
| RED (behaviour, pre-implementation) | `check-bridge.sh` with the new sole-player seam against the baseline DLL | 134: `the sole local player ... may choose a shared event option; production halted: shared_event_unverified` (`check-red.*`) |
| GREEN build | same build | 0, 0 warnings (`build-green.*`) |
| GREEN checks | `check-bridge.sh` | 0, `PASS: 2735 actual-DLL checks` (baseline 2694) (`check-green.*`) |
| Mutation (admit every shared model) | `if (false) throw shared_event_unverified` → build 0 → checks | 134 (`check-mutation-admit-all-shared.*`), source restored |
| Final | build 0 / 0 warnings, checks 0 / 2735 | `build-final.*`, `check-final.*` |

Candidate DLL SHA256 `f84591d9a474b13ee3a50531a3b12edf5173815bc971c3bdae20f259b4a757d4` (`dll-final.sha256`); baseline build
`46566ec2d0437850ceaf0a2a108c18850f70b349676d0d1ebfe1a5e2ac852501`. Full diff: `implementation/full.diff`.
Live-red script not run; app tests untouched (no TypeScript change).

## Residual risks / not verifiable offline

- Godot/Harmony/live behaviour is not proven: `PlayerVoteChanged → NEventOptionButton.RefreshVotes → NMultiplayerVoteContainer`
  runs synchronously inside the click; assumed cosmetic (no button MouseFilter change) — not checkable without the engine.
- `Rng.NextItem` over the single vote advances `_multiplayerOptionSelectionRng`; identical to a human sole-player click.
- Post-click receipt failure (`event_choice_receipt_unverified`) surfaces as `mutation_dispatch_failed` (existing `Fail` overwrite
  semantics), same as the existing `event_task_capture_mismatch` path; the retained native task keeps running and the epoch stays latched.
- After a shared choice the old buttons remain until `StateChanged → RefreshEventState → SetOptions`; readiness waits on the new
  generation exactly as ordinary events do (native disables them in `BeforeOptionChosen`). An option whose effect never raises
  `StateChanged` would wait — parity with ordinary events, not a new hazard.
- Restored/resumed rooms remain refused by the existing entry ownership; multiplayer remains `shared_event_unverified`.

## Recommended next step

Parent acceptance/review of `full.diff`; then the separately approved live step (install candidate on profile 2, rerun
`check-live-halt.py` expecting GREEN at the Morphic Grove decision).
