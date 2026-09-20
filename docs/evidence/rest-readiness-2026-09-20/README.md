# Rest-site readiness repair — 2026-09-20

## Confirmed cause and narrow correction

The previous Jev attempt halted at `ordinary_mouse_input_unverified` while entering the
floor-7 rest site. Its evidence remains unchanged in `../live-2026-09-20/`.

Pinned native code and the shipped scene show that `NRestSiteButton` starts visible/enabled
but with mouse input set to Ignore. `_Ready` launches an unawaited 0.5-second `AnimateIn`;
only its completed tail sets the mouse filter to Stop. The bridge observed that legitimate
input-disabled window after owned map travel completed and incorrectly classified it as
unsupported. This is a bridge readiness bug, not a defect requiring a native-game patch.

The rest branch now waits while **any** rest option still has mouse Ignore. The existing
whole-observation finalizer withholds all wire and executable choices, including Proceed and
potions. It resumes only on a new ready observation, not elapsed time. Ownership/tutorial
checks run first; model-disabled options and the shared ordinary-input guard are unchanged.
No new hook, adoption, selector authority, delay, retry, strategy or provider change.

## Offline acceptance

- Fresh independent review: **OK with notes**, `offline/review.md`.
- Parent build: exit 0, zero warnings/errors.
- Parent native checks: **1972 current + 1909 retained**, exit 0.
- Parent lint, format, typecheck and app tests: exit 0; **50 tests / 193 assertions**.
- Exact commands and results: `offline/commands.jsonl`; native IL and the scene-root excerpt
  are retained alongside the implementation/review reports.
- Candidate SHA256: `a105a689977a0f887af8dcef688800536a4f11d450ad7de9bc91118b08925a48`.
  Built at baseline `3443707` plus the reviewed three-file patch; a later commit does not
  retroactively change the binary's embedded source revision. Pinned native assembly remains
  `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`.

**Test limitation:** baseline red rejects the missing production helper; it does not execute
Godot's original failure. A separate mutation (helper present, production branch unwired)
fails the compiled-wiring check. Fixtures execute the production predicate/finalizer, and
metadata checks tie it to the native fade lifecycle. These checks do not replace live entry,
rest-option dispatch or post-option validation.

## Newly authorized live trial

Owner explicitly approved replacing the disposable **Profile-2** checkpoint and installing
the reviewed fix after normal shutdown. One fresh Jev-owned Ironclad A0 trial; stop after a
rest-site interaction, any technical fault, **150 accepted actions or 20 minutes**. No
restored-room adoption, save/settings/tutorial edits, host strategy or repeated attempt.
Parent alone controls installation/setup/observation; Jev owns all gameplay choices.

Live result is pending. This new trial does not rewrite the earlier technical stop as a
completed run. Local commits only; nothing pushed or published.
