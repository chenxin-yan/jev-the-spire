# Custom reward offers: legitimate null Room rejected

## User report

The manual Jev run `run-2026-09-20T19-44-39-939Z.jsonl` advanced two Neow dialogue lines, selected Small Capsule, then halted with `event_offer_identity_unverified`. The screenshot shows the resulting Amethyst Aubergine reward. Read-only capture confirmed the refusal at version `157d4e49c3d24d5498167315659d939a:248`, with no legal actions and `mutation_pending:true`.

Three accepted actions, one model call, two complete-singleton bypasses; 2,020 input / 54 output tokens reported. No retry or rescue selection was performed. The earlier `19-44-07` log contains a separate `no_active_run` refusal with zero actions/inference, not this bug.

## Cause and shared repair

Pinned native `sts2.dll` SHA-256: `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`.

`SmallCapsule.AfterObtained` calls **the shared `RewardsCmd.OfferCustom`**. That command constructs a `RewardsSet` and calls `WithCustomRewards`; neither assigns `Room`. The old event and treasure offer guards nevertheless required that optional field to equal the current room. This native construction path is sufficient to explain rejection; the screenshot does not independently exclude simultaneous failures of other checks, since their exceptions are collapsed into the same reason. The writer handoff's claim that other failures would have different reasons is incorrect and is superseded by this qualification and the independent review.

Source fix: **`4e245af`** (local commit). Both owned non-combat branches now call one small `NonCombatOfferIdentity` predicate **after the unchanged source identity adapter**. It permits an unset reward room, rejects a non-null foreign room, and still requires the exact player and run. An unbound source room is rejected. Combat retains strict room-bound checks. Nested/closed/foreign scope and native current-room/scene/run checks remain unchanged. No scenario-name exception, new hook, or native behavior override was added. This does not add support for other operation families merely because they also call `OfferCustom`.

## Verification

- Behavior-preserving extraction of the old strict room/player/run predicate was built first. Its retained IL shows both callers wired to it. New tests fail on the actual null-room predicate, not a missing helper.
- Worker GREEN: **2,042 native checks**. A blanket-null-room mutation fails the foreign-player case.
- Independent review: **OK with notes**. The reviewer identified foreign-run tests that were also failing player identity. The parent replaced those cases with the same player/set but a different expected run; deleting **only** the run guard then fails the isolated regression. The original guard was restored and the source compared with the saved green copy.
- Final parent verification: zero-warning build, **2,042 native checks**, **50 app tests / 193 assertions**, lint, format and typecheck all exit 0. Commands/exits are retained under `parent-gates/`. Final candidate SHA-256: `e6bb7a56538052408fb8fb62086fb9f7de401630b55c21f16de9da288b2bf598`. Source patch is `final.diff`, built from `3c3f8cf` plus the patch; embedded revision is that base rather than the later commit.

These tests execute the compiled predicate using native pure-CLR fixtures and inspect call wiring. They do **not** initialize Godot, invoke the full live reward prefix, or certify the reward screen interaction. The user's game was left unchanged during diagnosis and verification.

## Installation follow-up

With explicit user approval, the parent quit normally from the main menu, verified process/listener absence, backed up the old `9bcaa0b1…` DLL, installed the verified `e6bb7a56…` candidate into the nested mod directory only, and reopened through Steam. See `installation.json`. No new run or gameplay action was started. Live verification still requires the user to start a fresh Profile-2 Standard Ironclad A0 run; do not adopt the halted selection through saved-run Continue.

`SHA256SUMS` covers all retained evidence except the manifest itself. Raw logs and the original review/handoff are preserved, including qualifications above; no binaries, credentials or save files are committed.
