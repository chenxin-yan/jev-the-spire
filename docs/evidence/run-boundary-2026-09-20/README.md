# Fresh-run bridge lifetime, enchant selection, and reward investigation

## Reported failures

The user ran the CLI manually. No assistant gameplay, mutation retries, save edits, installation, or provider calls occurred during this repair.

- The 20:09 invocation stopped at the former ten-action cap after dispatching Bash in floor-2 combat. Later invocations returned the same `combat_loop_cancelled` state while the UI showed a new Neow opening. The process-static bridge session kept the old failure before considering the new run. The intervening native/human cancellation trigger was not logged.
- After restarting the game, the 20:35 invocation reached floor 5 and chose **Read the Back**, an Attack enchantment with Sharp 2. The owned selector opened, then the bridge refused its previously unsupported native subclass: `unverified_grid_subclass:NDeckEnchantSelectScreen`. This attempt ended in a technical stop after 44 accepted actions, not victory or defeat.

Original logs, screenshots, and readbacks are under [`user/`](user/). Historical halts remain recorded; no halted selector was adopted.

## Shared fixes

1. **Run-scoped session lifetime.** An observation-only postfix at the pinned native `RunManager.InitializeNewRun` retires old ownership and creates a new session epoch. Saved/replay setups use `InitializeSavedRun`, not this boundary. Same-run faults, CLI reconnects and room transitions do not reset anything. Old action versions remain invalid.
2. **Reliable retirement.** Dispatch callbacks retain their original session. Subscriptions retain their original queue/executor even though native setup replaces those publishers before the boundary. Cleanup failures—including earlier event cleanup failures—remain sticky and prevent replacement. Such an uncertain cleanup still requires a full game restart.
3. **Shared enchanting selector.** The exact `NDeckEnchantSelectScreen` type uses the existing owned `CardsSelected` task boundary and grid input path, including native enchantment text, preview, confirm and cancel controls. Unknown subclasses still refuse dispatch.
4. **Complete grid choices.** Native grids allocate a sliding window. Every supported grid now compares candidates and allocated holders by reference and multiplicity, rather than silently omitting off-screen cards. Empty initialization windows wait; other incomplete grids halt with `grid_candidates_incomplete`. Scrolling/large-grid support is not implemented by this patch.

Native contract evidence is under [`native/`](native/). The implementation report and initial review are preserved in [`review/`](review/). The initial review correctly blocked three cleanup defects; [`review/review-fixes.md`](review/review-fixes.md) records the parent corrections. The corrected complete patch is [`review/final.diff`](review/final.diff), not the worker's earlier `native/final.diff`. A follow-up found that map turnover could discard historical event-cleanup failure; the shared checked turnover fix and its genuine RED are recorded in [`review/turnover-fix.md`](review/turnover-fix.md). The [final independent review](review/final-review.md) accepted all three fixes: **OK with notes**, no remaining findings.

## Reward choices

**Not always skipping.** In the latest run:

- Floor 1: chose Small Capsule and collected Juzu Bracelet, providing live evidence for the previously installed custom-reward fix.
- Floor 2: collected 15 gold, opened the card reward, and took Taunt. Proceed was forced only after no rewards remained.
- Floor 3: Jev chose Proceed over 12 gold and a card reward (Proceed probability about 0.40).
- Floor 4: Jev chose Proceed over 14 gold, Speed Potion, and a card reward (Proceed probability 0.46).

Every leave-with-unclaimed-rewards choice was model-selected, with the claim actions present, and the accepted dispatch matched that choice. Native Proceed does not automatically collect the remaining rewards. The adapter preserves the provider's choice; no host auto-skip rule was found. No reward policy or model prompt was changed.

[`rewards/findings.md`](rewards/findings.md) and [`rewards/accounting.json`](rewards/accounting.json) contain the details. Logs capture choices/distributions, not hidden reasoning or complete historical model inputs. Terse descriptions may contribute to poor choices, but causation is not established. Offered-relic effect text is a separate context omission in `BuildRewardsState`; owned relics do include effect descriptions. That omission is not established as the cause of these gold/card/potion skips.

## Verification

- Baseline native checks: **2042**, exit 0.
- Worker candidate: **2672**, exit 0; subsequently blocked by independent review. Its baseline RED was missing-hook wiring, not a live lifecycle reproduction.
- Parent reproduced the successful-completion cleanup defect before fixing it (`review/cleanup-red.log`, exit 134), then reproduced the event-boundary cleanup defect (`review/event-red.log`, exit 134).
- Targeted mutations are rejected: resolving the replacement queue during unsubscribe fails the real production-closure publisher test; omitting historical event-cleanup failure recording fails the previously-failed-entry fixture. Both mutations were restored.
- Final restored-source gates after the turnover fix: **2694 compiled-bridge checks**, zero-warning native build; **51 app tests / 196 assertions**, lint, formatting and typecheck all exit 0. Commands and full logs are under [`gates/final-v2/`](gates/final-v2/). The earlier `gates/final/` records the 2692-check candidate before the remaining turnover finding.

Raw IL/log/diff captures retain their original whitespace and are covered by `SHA256SUMS`. An archive-wide `git diff --check` reported only that captured trailing whitespace (exit 2); source and authored Markdown whitespace checks passed. The raw evidence was not reformatted.

These are offline managed-behavior, metadata, and compiled-wiring checks. They do not initialize the game, prove Harmony application, or certify Godot input/main-thread ordering. New-run recovery and enchantment selection still need separately approved live verification.

## Candidate and authority

Reviewed source commit: `1288b01`. The candidate was built from baseline `4bbd8c2` plus that exact corrected patch; it was not rebuilt merely to change embedded revision metadata. Candidate SHA256: `f16fd24269faac9ffdeca7c0566d9bc9aa088284f5b55bc96e981620dcdf11ef`.

The installed DLL remains `e6bb7a56538052408fb8fb62086fb9f7de401630b55c21f16de9da288b2bf598`; this candidate is **not installed**. [`gates/identity.json`](gates/identity.json) records candidate, installed and pinned native hashes. Binaries are not included here. The worker's recommendation to install under prior approval is superseded: installation and a fresh live trial require new owner approval.

Workflow: `69584d23-e389-4221-a572-85a534348755`; writer `9c49107f-7f69-42f4-a5a0-4af353b43c64`, initial reviewer `fa88b658-c46e-4075-b21f-19c22e8ee42b`. Retained reviewer follow-ups: `eef9f656-4ab4-4c34-91c6-b08f2b6316a6` (remaining turnover finding) and `3c02db6f-de90-47e5-9b55-1d39844d6977` (final acceptance). All review passes are preserved; no delegated lane remains active.
