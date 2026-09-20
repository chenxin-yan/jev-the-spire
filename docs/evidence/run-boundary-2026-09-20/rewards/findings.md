# Reward-choice investigation (no gameplay / no policy changes)

Source baseline: main 4bbd8c2. Inputs: preserved user logs in the parent directory, screenshot user-enchant-error.png, native v0.111.0 metadata/IL. Full provider request snapshots were not recorded by these CLI logs, so this is decision/dispatch evidence plus source tracing, not a replay of the exact historical model inputs.

## User's latest run (20:35:24–20:37:05 UTC)

`run-2026-09-20T20-35-24-506Z.jsonl`, epoch d780453c901a41918e1ff6b699a92678:

| Floor | Observed choice | Attribution |
| --- | --- | --- |
| 1, Neow | Small Capsule, then claim Juzu Bracelet | Model choices; reward return to event and Proceed succeeded. This also supplies live coverage of the previously fixed event custom-reward path. |
| 2, first battle | Claim 15 Gold, open card reward, take Taunt | Three model choices; then a singleton Proceed after no rewards remained. |
| 3, second battle | Proceed while 12 Gold and a card reward were available | Model choice, proceed ≈0.40 vs gold0.35/card0.25. |
| 4, third battle | Proceed while 14 Gold, Speed Potion and card reward were available | Model choice, proceed0.46 vs gold0.27/card0.22/potion0.05. |
| 5, event | Read the Back / enchant Attack with Sharp2, then technical halt | `unverified_grid_subclass:NDeckEnchantSelectScreen`; not a model refusal or reward choice. |

Screenshot gold114 is consistent with initial99+the collected15, not collecting the later12+14. The final log summary: 44 accepted dispatches, 33 application model calls, 12 forced actions; 32 successful model-chosen actions plus one rejected inference/re-ask; reported usage88328 input/2311 output. Technical stop, not completed run. No rescue/retry.

Earlier 20:32 invocation also explicitly chose Proceed over13Gold/EnergyPotion/card reward at floor2 (proceed0.42), then eventually user SIGINT at27 actions. Its later combat-loop cancellation is separate from the reward choice.

## Attribution chain

- `McpMod.LegalActions.cs`, rewards case: enumerates unselected reward buttons as claim_reward labels plus an independent proceed/Leave rewards action. Native collect uses NRewardButton.GetReward; leaving calls native Proceed, not an automatic host default.
- `McpMod.StateBuilder.cs:BuildRewardsState`: reward items include type/description, gold amount, potion description; BuildGameState also includes full player/deck. `BuildCardRewardState` supplies details after opening card offers.
- `src/loop.ts:contextOf`: removes bookkeeping only. Multi-action states always call the decider; only an exactly-one complete legal set bypasses inference. In logs every leave-with-unclaimed-rewards has source=model, and accepted dispatch matches its label.
- `src/jev.ts`: criteria map every action label to its description. Gateway answer.choice is mapped to Classify label; no host reward policy, sampling or proceed preference.
- Installed `@ai-sdk/gateway/src/gateway-evaluation-model.ts` forwards state/questions and returns the answer. Installed Effect `DecisionModel.ts:validateAnswer` validates the Classify label/distribution and preserves the supplied label, not substituting an argmax or other choice.
- Native `NRewardsScreen.OnProceedButtonPressed` and `RunManager.<ProceedFromTerminalRewardsScreen>d__211` show ordinary terminal Proceed opens the map; it does not claim the remaining rewards. Nonterminal custom-reward Proceed skips the local rewards set. `NRewardButton.<GetReward>d__26` is the actual collection path. IL preserved here. The initial GetReward state-machine lookup used an incomplete name and failed (exit134); header then supplied exact d__26 and corrected probe succeeded. No game initialization or requests from these probes.

## Conclusion

Not always skipping: latest run collected the first battle rewards and skipped the next two. The skips were actual model outputs among exposed claims, not a forced singleton or suppressed claim path in these decisions. No claim about Jev's hidden reasoning or strategic justification is supported; model output contains a choice/distribution, not rationale.

Potential UX/context improvements, NOT applied or proven to fix model behavior: clarify `Leave rewards` as leaving without collecting remaining items; describe sequential reward claiming and opening card choices as such; optionally state an explicit win-the-run objective. Keep all legal choices and Jev ownership. Do not add an auto-collect host strategy, remove Skip/Proceed, or silently re-rank the model.

Separate context limitation seen in source: BuildRewardsState does not expand offered relic effect text (reward.Description is often the relic title). This did not hide the gold/card/potion options in these skips and is not established as their cause. It is narrower than the owned-relic description support in BuildPlayerState; broad 'full context' claims should distinguish owned inventory from every possible offer tooltip.

Validation: accounting.json records all reward decisions with exact legal alternatives and probabilities. Offline assertions matched every recorded decision to one202 dispatch, all summary action/model/forced counts, and confirmed all three leave-with-claimable-rewards decisions across the two captured runs were source=model. No provider or gameplay calls, source changes, or installation performed by this investigation.
