# Autonomous validation — 2026-09-20

## Authority and status

The user authorized full takeover, installation, testing and iteration after quitting the game. Scope remains modded **Profile 2, Standard Ironclad A0**, Jev-owned strategy and complete legal choices. No forced reward claims, model-policy changes, hidden information, credential inspection or uncertain mutation retries.

This archive is a checkpoint, **not a claim of complete autonomous coverage**. Run 1 stopped technically; the repaired candidate is installed and run 2 is underway at this checkpoint. Later recorded outcomes supersede only status, not earlier failure evidence.

## Installations and setup

- Installation 1: reviewed shared-event source `f2490c9`, DLL `f84591d9a474b13ee3a50531a3b12edf5173815bc971c3bdae20f259b4a757d4`, installed at `2026-09-20T22:43:18.364007Z`.
- Installation 2: reviewed combat-selection source **`d0e2944`**, DLL **`37157f738b1b1bcd69d22b8f83c1de087f23c971ca7f1cbd4f6a16986e915e9d`**, installed at `2026-09-20T23:18:42.848775Z`.
- Native v0.111.0 `sts2.dll` remains `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`.

Both installs verified game/listener absence, backed up the old DLL, atomically replaced it and verified the resulting hash. `installation-1.json` and `installation-2.json` preserve receipts and backup paths. No binaries are committed. The second candidate was built at `3e06aab` plus the exact committed patch, not rebuilt merely to change embedded revision metadata.

Direct `.app` launch failed Steam initialization (missing app ID); native Quit followed by `steam://rungameid/2868840` worked. No app-ID-file workaround was added. Each prior halted attempt was abandoned through the native menu before a fresh run; the game records an abandonment loss, but project evidence retains the technical-halt classification. No halted selector was manually completed, adopted or resumed. Menu/setup actions do not count as Jev gameplay decisions.

## Run 1: Headbutt technical stop

Seed **`5P4NPFRRCJY6`**, epoch `c2a3073294f1400c8e2b7e8d92e35e5b`, opening 80/80 HP, 99 gold, 10 cards. Unchanged unlimited CLI:

```sh
mise exec -- bun run src/main.ts --log /tmp/jev-autonomous-2026-09-20/run-1.jsonl
```

**9 dispatches, 7 model calls, 2 forced singletons; 21,468 input / 437 output tokens; 16,108 ms**. Process exited 1. Scroll Boxes bundle selection and confirmation succeeded live, followed by Neow Proceed and map travel. Jev then played Headbutt against Shrinker Beetle at version `:23`; POST returned 202. The discard selector opened, but version `:25` halted `unowned_selection_continuation`, mutation pending, no legal actions. The screenshot shows all five discard cards; no mutation was retried.

`headbutt/live-red/check-halt.py` checks the exact captured symptom and intentionally exits 1. This recorded-state assertion is not an engine replay. Raw run records, stdout/stderr, opening snapshot and accounting are under `run-1/`.

## Causal repair and review

Native `CardModel.OnPlayWrapper` and `PotionModel.OnUseWrapper` pass an unbranched `BranchingPlayerChoiceContext` around the registered action context. The bridge previously masked every such wrapper. Headbutt passed that wrapper through `FromCombatPile` to the already-hooked base `CardsSelected` boundary, leaving no owner. This was a missing shared card/potion capability, not an identified shared-event regression.

The fix resolves only an unbranched wrapper directly over an explicitly registered GameAction. Its lease revalidates the wrapper on observation and dispatch: a later branch revokes permission before the detached action completes. Branched, foreign, retired, Hook and nested-wrapper contexts remain refused.

A second missing capability lay behind that halt: the exact `NCombatPileCardSelectScreen` type was not admitted, and its inherited `_cards` field is always empty. Parent approved its native pile/filter-derived candidate list, preserving whole-set reference/multiplicity matching, native select/deselect/confirm behavior and the original task. No new Harmony target, general Task interception or card-name exception was added. Native detached relic-flash code returns for this screen's null `_cardResults`; it does not add a gameplay completion task.

Workflow `4c37db7d-d484-4a99-a1b5-7d0ae889f015`: sole writer `6e160d61-8439-4201-b846-ab45d9b909a4`, fresh read-only reviewer `7b667359-40c0-4e3e-a37f-de57cd195525`. Review: **OK with notes, no issues found**. Parent supplied additional hand/grid IL so review covered the adjacent hand/potion scope, not only Headbutt. Frozen diff SHA256 `2bf8028415e38a2a2ebee7aebb82469fed072f1c04de113b59442eb2b468b791`; it matches the committed patch.

### Checks

- Baseline: 2,735 native checks.
- Causal ownership RED: exit 134, real patched admission with native wrapper/context objects, exact missing-owner assertion.
- Negative mutations: accepting an already-branched wrapper, using empty `_cards`, and ignoring lease readiness each failed; all mutations restored.
- Final worker and parent: **2,770 actual-DLL checks**, **51 app tests / 196 assertions**; native build, lint, format and typecheck all exit 0. Offline Bun commands use `--no-env-file`.
- Source `git diff --check`: exit 0.

Exact parent commands/exits: `headbutt/parent/initial/commands.jsonl`. Worker stages preserve intermediate harness failures as well as successful final results. Raw IL/log/diff whitespace is intentionally retained.

**Report correction:** the worker inferred non-reproducible builds from differing baseline hashes. That conclusion is unsupported: the earlier installed DLL was built at `58b053a`, whereas the current build embeds `AssemblyInformationalVersion("1.0.0+3e06aab7e3dd42d9924036d8127010f6327f93f9")`. Revision metadata is a known differing input. Parent rebuilt the frozen candidate and obtained the worker's exact final hash.

## Remaining live checks

The repair's managed fixtures and metadata do not certify Godot/Harmony, full holder allocation, auto-confirmation or continued original-task ownership in a running Headbutt encounter. Run 2 starts fresh with seed `U1R2DVVR8386`, epoch `a8304fdf49b743f49eb94c3aab9785cb`; no outcome is claimed here. Shared events and several rest/selector paths still need live coverage. Large/incomplete grids and nested wrappers deliberately remain fail-closed. Ordinary death is a valid terminal outcome; a bridge halt is not.
