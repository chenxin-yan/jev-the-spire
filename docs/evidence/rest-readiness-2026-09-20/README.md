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

## Live outcome: blocked before rest entry

Installed **exactly the reviewed candidate**, after normal UI Save and Quit → Quit confirmation
and verified game/process/listener shutdown. Backed up the prior DLL; replaced only the nested
mod DLL, verified its hash, and relaunched via Steam. `live/installation.json` records identity.
Parent rechecked Profile 2 / Running Modded / one loaded mod, then used normal Abandon and fresh
Standard / Ironclad setup. No seed entered; new seed **`79675RSRGBWQ`**, A0.

Trial began **18:25:45 UTC**, with a **18:45:45 UTC** deadline. Jev chose Arcane Scroll at Neow,
obtained Crimson Mantle, selected the first route and cleared the first combat. It left rewards
unclaimed, followed the sole next route to Brain Leech, then chose **Share Knowledge** from both
native options. The card-selection overlay opened, but the bridge refused it:

- Final accepted POST: `choose_event_option:0`, version `e89b9cb09de247d4959726db7f48d545:49`.
- Immediate observation: **unsupported `…:50`, `unowned_selection_continuation`**.
- CLI halted at **18:27:06 UTC**, exit 1. Later GET retained the same refusal and pending parent.
- UI: Brain Leech's five-card selection, act 1 / floor 3, **72/80 HP, 99 gold**.
  No card was selected, no retry/restart/rescue followed. This checkpoint remains untouched.

Two CLI segments: `trial-1` max-actions 10 (7 model / 3 forced), `trial-2` halted after 7
(5 model / 2 forced). Total **17 accepted actions, 12 model calls, 5 forced**;
**34916 input / 1063 output tokens**. No rejected/uncertain POST or invalid-answer re-ask.
Application calls are not billable-request counts; monetary cost is unknown.

**The rest repair is implemented/offline-verified, but live rest entry and selection remain
unverified:** this trial never reached a rest site. The new failure is an event-selection
ownership refusal, not recurrence of the rest-button mouse-filter failure. Its exact cause
has not been diagnosed; no new interception or ownership authority was added to get past it.
A further fresh trial or separate event investigation requires a new scoped decision.

`live/check-accounting.py` passed (exit 0), validating both logs' full distributions, labels,
singletons, accepted dispatches, usage and outcomes. `live/accounting.json` retains totals.
`run-to-rest.py` was a bounded one-segment supervisor intended to SIGINT at the first ready
rest-site observation; that stop condition was never reached. Its safety timer was not used.
The live runner is a historical artifact, not an authorized replay command. Only the accounting
checker is safe to run offline. `SHA256SUMS` covers evidence files except itself.

Neither this trial nor the earlier technical stop is relabeled a completed run. Local commits
only; nothing pushed or published. No running gameplay controller remains.
