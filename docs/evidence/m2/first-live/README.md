# M2 first controlled live validation — partial, not accepted

Recorded 2026-09-20 UTC (2026-09-19 local). Parent-controlled diagnostic play on **modded profile 2**, disposable seed `F8AG9S4KZ3GG`. No Jev inference or Jev-owned run; this does not count toward M4 or authorize M5. M2 remains open; M3/M4 remain gated.

## Installed checkpoint and rollback

- Game: Steam public-beta v0.111.0 / `41cef1ea`, Apple Silicon.
- Native assembly SHA-256: `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`.
- Installed reviewed partial M2 DLL: `dff158c2b5ca3d2c357eb417f2469be49caf332da7c41460956d1897c1be34ed`, from `/tmp/jev-m2-cancelasync/release/STS2_MCP.dll`.
- Parent byte-compared all **19 candidate source files and 28 build inputs** with the current external mod fork before installation and again after this session. Installed DLL matches the frozen release. No mod source edits during this test.
- Accepted M1 DLL: `d67269f5999b73980d3d6308be3148b7ed6f13bba0f904f433e3bbc6faface02`. Entire installed mod directory backed up to `/tmp/jev-m2-live/m1-backup/`; hashes retained here. Only the installed DLL was replaced. Manifest, config and license were preserved.
- Normal quit AppleEvent returned `User canceled (-128)`, but subsequent process, window and listener checks confirmed the old game had exited. No force kill. Relaunched through Steam after replacement.
- Loader started the localhost listener after required-hook installation. `profile2-menu.png` visibly identifies Profile 2 and modded mode. No profile switching, save edits, tutorial acknowledgement, or original-profile access.

## Observed results

| Check | Evidence | Result |
|---|---|---|
| Listener / initialization | `loader-excerpt.log`, `listener.txt` | Listener on `127.0.0.1:15526`; mod initialized |
| Repeated GET / rejected-request non-mutation | `combat-get-{1,2}.json`, `combat-after-rejections.json` | Exact parsed snapshots and version identical |
| Unknown label / stale version | `unknown-label.*`, `stale-version.*` | HTTP 422 / 409, no observed state change |
| Browser Origin / route allowlist | `browser-origin.*`, `route-allowlist.*` | HTTP 403 / 404 |
| Targeted Strike | `strike.*`, `after-strike-*`, `after-strike.png` | 202; immediate pending/no actions; later energy 3→2, enemy HP 42→36, actionable state |
| Accepted-action replay | `replay-strike.*` | HTTP 409; no duplicate play |
| End turn | `end-turn.*`, `after-end-turn-*`, `after-end-turn.png` | 202; pending/no actions, then round 2, player HP 80→68, energy 3, next hand |
| Permanent deck / blocking overlay | `deck-ui.png`, `deck-overlay.*` | Native deck matches 5 Strike + 4 Defend + Bash; bridge refuses while deck view is open |
| Combat exit → rewards | `lethal-strike-*`, `reward-get.*`, `reward-ui.png` | Pending after lethal play, then owned reward decision; Burning Blood heals 62→68 |
| Gold claim / replay | `claim-gold-*`, `replay-gold.*` | Gold 99→118; old request rejected 409 even though remaining reward reused index 0 |
| Card reward child | `card-reward-settled.*`, `card-reward-ui.png`, `take-card-*` | Three card takes + Skip; selected Setup Strike; permanent deck becomes 11 with exactly one copy |
| Rewards → map | `leave-rewards-*`, `map-settled.*`, `map-ui.png` | Eventually 66 map nodes and 3 travel choices, parent no longer pending |

`mutation_pending:true` during an actionable owned reward/selector is intentional: the parent task remains retained while its advertised child decision can be submitted. Pending combat snapshots instead had no legal actions and incomplete decisions. Do not treat the flag alone as either permission to act or proof of child readiness.

Exactly **12 accepted diagnostic POSTs**: six card plays, two end turns, gold claim, open card reward, take Setup Strike, leave rewards. Each was explicitly selected by the parent for testing. No fallback strategist or autonomous loop was run. Native UI clicks only continued the existing run and opened/closed its informational deck view. No gameplay choice used UI fallback.

## Observations and independent audit dispositions

1. **Main-menu GET fails closed with an exception reason.** `menu-get.json` contains `observation_unavailable:NullReferenceException:Object reference not set to an instance of an object.` with no actions. The audit found a reachable eager `RunManager.NetService.Type` dereference before the intended no-active-run branch. This is the strongest source-grounded explanation, not proof of the exact throwing instruction (the snapshot has no stack). A null-context guard is being repaired; no menu gameplay is being added.
2. **Card-reward opening initially advertises only Skip as complete.** `open-card-reward-immediate.json` already contains all three card descriptions, but only Skip is legal, with `waiting:false` and `legal_actions_complete:true`. Later `card-reward-settled.json` advertises all four choices. No action was submitted against the early snapshot. Native metadata confirms the card holders are temporarily unclickable while alternatives remain enabled. This is not proven pruning of currently legal inputs or premature parent release, but it can prompt Jev with a timing-dependent singleton before the joint reward choice is ready. A bounded whole-decision readiness gate is being repaired.
3. **Map opening initially advertises an empty complete decision.** `leave-rewards-immediate.json` has empty nodes/options/actions, `waiting:false`, `legal_actions_complete:true`, and `mutation_pending:false`. The later snapshot contains the map and travel choices. The audit found ordinary native proceed completes before map opacity fades in; bridge readability filtering explains the empty snapshot. Unsafe early completion is not established. Completion tracking remains unchanged; the owner contract already requires waiting/re-observing zero-action sets. This does not establish safety for act-start/tutorial branches.

Independent read-only audit `56c3585b-b843-4c06-a69e-6d978f424417` is complete: [full report](../first-live-audit.md). Parent accepted the two bounded menu/reward fixes and left map completion unchanged. Repair and fresh independent verification run as workflow `3937f90c-826b-4b78-a7ac-68175be47fee`; no new Harmony targets, gameplay, or installation are authorized to children. The installed candidate and this live evidence remain the original `dff158c2…` checkpoint until separately reviewed and revalidated.

## Scope limits and next gate

This is one real native combat/reward/map path, not family-wide acceptance. Shop/rest/event/treasure/potion/death paths, unsupported branches, concurrent-in-flight rejection, and wrong-profile runtime refusal were **not** exercised here. Profile 1 was deliberately not selected to test the guard. Non-TinkerTime event coverage remains incomplete. Offline assertion totals are not substituted for live coverage.

Stopped at the map after floor 1: **68/80 HP, 118 gold, 11 cards**, three available Monster destinations `(1,1)`, `(2,1)`, `(6,1)`. No destination chosen. Reviewed M2 remains installed; M1 rollback files remain available locally.

## Evidence and commands

- Original local capture: `/tmp/jev-m2-live/`; sanitized HTTP captures, screenshots, loader excerpt, hashes and manual diagnostic scripts copied here. Raw loader log, account-bearing save data and mod/game binaries are not published.
- `python3 /tmp/jev-m2-live/check-rejections.py`: exit 0, exact snapshot equality across read/rejected requests.
- `curl --max-time 10 ... http://127.0.0.1:15526/api/v1/singleplayer`: bounded single requests; HTTP codes retained in headers. No mutation retries after uncertain outcomes.
- `action-once.py <unique-name> <explicit-label>`: fresh observation, asserted advertised complete/non-waiting decision, one POST, one immediate GET; refuses reuse of a request filename. This is a manual evidence helper, **not the future Bun/Effect/Jev runner**. Do not replay these diagnostic scripts against another run.
- Parent verification asserted the selected card appears exactly once in an 11-card permanent deck; exit 0.
- Source/build-input byte comparisons and installed-DLL hash comparison: exit 0. Mod fork `git diff --check`: exit 0 before installation. No new build/test suite run for this evidence-only checkpoint.
- `CONTEXT.md` and `mise.toml` protected hashes remain unchanged; `.env` was not read.
- `SHA256SUMS` covers the captured artifacts (not this narrative). Evidence is currently local/uncommitted; no milestone closure implied.
