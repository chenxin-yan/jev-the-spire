# Native singleplayer shared events — 2026-09-20

## Result and authority

Source fix: `f2490c9` (`fix: support native shared events in singleplayer`), based on `58b053a`. Independent review: **OK with notes**, no issues found. Final parent gates passed. This is offline acceptance, **not installation or live acceptance**.

The user reported Morphic Grove halting with `shared_event_unverified` and asked whether battle rewards were claimed. After diagnosis, the user approved **Fix shared-event support**, explicitly leaving reward wording and strategy unchanged. No game clicks, provider calls, new runs, monitoring loop, restart, installation, or save/settings changes occurred. Two bounded read-only bridge observations reproduced the original stop; that run remains a technical halt, not a success.

- Candidate DLL SHA256: `f84591d9a474b13ee3a50531a3b12edf5173815bc971c3bdae20f259b4a757d4`.
- Still-installed DLL SHA256: `f16fd24269faac9ffdeca7c0566d9bc9aa088284f5b55bc96e981620dcdf11ef`.
- Native v0.111.0 `sts2.dll` SHA256: `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`.

The candidate was built at baseline `58b053a` with the exact committed patch; it was not rebuilt merely to update revision metadata after committing. `gates/identity.json` records both DLL paths and hashes. No binaries are included.

## Diagnosis and fix

Morphic Grove's native `IsShared` getter is constant true, including singleplayer. The old bridge rejected shared models before offering options. That guard predates the new-run/enchantment update; this was an unsupported native interaction, not evidence of an upstream game bug or a regression in that update.

The fix proves native singleplayer with exactly the verified local player, binds the synchronizer's canonical/mutable event, service, player collection and local ID, and requires one empty vote slot. Dispatch still clicks the original button and captures exactly one appended native task. Shared choices must advance one page and clear votes; ordinary choices must leave the page unchanged. The original task remains authoritative while effects or owned child selections are pending. Multiplayer, custom layouts and embedded combat remain unsupported; no event-name exception, new Harmony target, task interception or direct effect invocation was added.

A reviewer requested additional proof for the newly reachable vote-display callback. `native/vote-container-refresh.il` shows an immediate return for one player before any delegate, icon, animation or helper call. Constructor, initialization and button `_Ready` IL establish that the list comes from the owning run's players. This resolves the worker report's cosmetic-callback uncertainty for the supported path.

## Battle reward audit

Log: `user/run-2026-09-20T21-39-37-380Z.jsonl`. All reward decisions were matched to one accepted dispatch and the next map decision.

| Floor | Offered | Jev selected | Outcome |
|---|---|---|---|
| 2 | 10 gold, Strength Potion, card reward | Proceed (0.35) | All skipped |
| 3 | 10 gold, card reward | Proceed (0.40) | All skipped |

There were **zero claim requests**. Jev skipped 20 gold, one potion and two card-selection opportunities; the bridge executed the selected actions rather than losing a requested claim. Native Proceed opens the map without collecting leftovers (same native assembly as the [prior reward trace](../run-boundary-2026-09-20/rewards/)). The Golden Pearl opening choice was separate from battle rewards.

`diagnosis/audit-rewards.py` is the read-only log audit, repointed to this archive layout; it exits 0 and regenerates `diagnosis/reward-audit.json`. Full historical player snapshots and model reasoning were not logged, so precise inventory deltas and why Jev preferred Proceed cannot be independently established. Screenshot inventory is consistent with skipping. No reward policy, prompt, or wording changes were made.

## Validation and review

- Workflow `dc344d55-1119-4157-99b0-236d6ef4e1fd`.
- Writer `bfff5a24-1103-48b4-8bf5-814c72bd498e`: `review/implementation.md`.
- Fresh read-only reviewer `2e52e6fb-ddc5-4765-8a70-fa549f48affd`: `review/review.md`.
- Review artifact filename mismatch resolved by parent: `final.diff` was generated from frozen source and verified byte-identical to worker `full.diff` (SHA256 `3ca34949804d9b0a24811650202f206ef55b78637f54d23cfbb92c06b823700c`). Preserved as `review/reviewed.diff`.
- After review, parent made only test cleanup: require the current three-argument policy signature instead of retaining the temporary old-signature RED adapter, remove its obsolete comment, and make the retained-task assertion null-safe (clearing CS8602). No production behavior changed. `review/final.diff` is the committed patch; all gates were rerun afterward.

| Check | Result |
|---|---|
| Read-only live symptom assertion | Exit 1: exact `shared_event_unverified`, epoch `0c940da5f3624b0586ed753feeb3074c:102` |
| Baseline policy RED | Exit 134: approved sole-player shared case refused as `shared_event_unverified`, not a missing-symbol failure |
| Blanket shared-admission mutation | Build 0; native assertions fail 134; mutation restored |
| Final native build | Exit 0, zero warnings/errors |
| Final actual-DLL checks | Exit 0, **2,735 checks**, no nullable warning |
| `bun --no-env-file test` | Exit 0, **51 tests / 196 assertions** |
| Lint / formatting / typecheck | All exit 0 |
| Reward log audit | Exit 0 |
| Source diff whitespace check | Exit 0 |

`gates/final/commands.jsonl` contains exact parent commands and exits; adjacent logs are authoritative final results. `gates/initial/` and `worker/` preserve earlier evidence, including the now-resolved test warning. Raw IL/log/diff captures retain original whitespace; do not reformat them. Authored Markdown/source whitespace checks are distinct from raw captures.

## Limits and next step

Managed fixtures and metadata/wiring checks do not execute the native Godot click path or verify Harmony in a running game. Actual shared choices and nested transforms still require a separately approved fresh live trial. The large virtualized-grid fail-closed limitation remains. The current halted event is not adopted or silently resumed.

The worker's suggested next live step is a recommendation, **not authorization**, and cannot establish that reopening the game would preserve the required event ownership. Installation/restart and any gameplay need separate approval. The user retains testing control.
