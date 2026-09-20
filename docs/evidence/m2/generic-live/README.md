# M2 generic ordinary-event live diagnostic

## Verdict

**Bounded native PASS:** combat/reward/map handoff and one previously unlisted ordinary event choice, followed by separate Proceed. **Full M2 remains incomplete.** This was parent-selected diagnostic gameplay, not Jev inference, M4 evidence or an M5 autonomous run.

Installed DLL: `0cd0c0bbf28a3a6565aa0b500c34967b1d623e051dcffa71f27754b5579035aa` ([independent review](../generic-events-review.md)). Native v0.111.0 / `41cef1ea` remains pinned. Modded **profile 2** only.

## Authorization, installation and setup

The owner explicitly approved **Fresh diagnostic run**: replace the paused profile-2 test run, install the reviewed build, normal UI setup to the first map if needed, then bridge testing. This is not blanket UI fallback permission.

- Before installation the old bridge reported `event_setup_unowned`, not the historical canceled-loop latch: the game process/session had changed since the earlier test. It correctly did not adopt the restored event. Read-only UI still showed Byrdonis Nest, 57/80 HP, 130 gold, 11 cards. Neither old event option was selected.
- Normal application quit returned AppleEvent `User canceled (-128)`. Subsequent process/listener checks confirmed exit; no force kill. Only after both were absent was the DLL replaced.
- Previous install backed up at `/tmp/jev-m2-generic-live/previous-install/`; M1 and previous backups retained. `installed-hashes.json` records DLL replacement with all other installed mod files unchanged.
- Relaunched through Steam; main menu visibly showed **Profile 2** and **Running Modded. Loaded 1 mod.**
- Native UI setup: Abandon Run and confirmation; dismiss the game's newly unlocked Silent chapter page; Standard run, Ironclad; choose Neow's **Booming Conch**; Proceed to the first map. The chapter page was an unlock announcement, not a gameplay tutorial. No tutorial flags/save files were edited or tutorial acknowledgements automated.
- All those UI setup actions are **excluded from bridge/event verification**. No UI gameplay clicks occurred after the first map. No profile-1 access or changes, Jev inference, commits or pushes.

Fresh seed: `YXRKN2F6AQHC`. First map: 80/80 HP, 99 gold, 10 cards, Burning Blood and Booming Conch. This was a fresh standard run, not a replay of the old seed.

## Verified native sequence

1. Complete first-map observation → `choose_map_node:1` → waiting/no actions → ordinary combat at `(3,1)`, floor 2.
2. Nine explicit card plays and three end turns completed the three-enemy combat. Native UI/observation parity checked before lethal Strike. Reward entry showed 75/80 HP after Burning Blood.
3. Opened card reward: immediate observation contained the three descriptions but `waiting:true`, incomplete/zero actions. Ready observation exposed all three cards plus Skip together. Chose Skip, leaving the card reward unclaimed; claimed 14 gold, left the potion unclaimed, and chose reward Proceed.
4. Map had a retained parent (`mutation_pending:true`). `choose_map_node:0` to Unknown `(3,2)` first returned waiting, then reached **The Legends Were True**, floor 3, with `mutation_pending:false`, no halt and both legal options. **The prior `combat_loop_cancelled` handoff failure did not recur.**
5. Event snapshot matched the displayed title/body and both native choices: **Nab the Map** / **Slowly Find an Exit**. Spoils Map and Unplayable rule text was included. This event had no event-specific implementation or allowlist addition.
6. `choose_event_option:0` (Nab the Map) → waiting/no actions → finished page with freshly enabled **Proceed**. Deck grew **10 → 11** with exactly the observed Spoils Map addition; HP stayed **75/80**, gold **113**. UI showed the finished text and 11-card count.
7. Replayed the original choice version while the new page reused action label `choose_event_option:0`: **409 rejected**, no choice replay. A fresh-version Proceed was separately accepted and returned to the map, pending false.

Final checkpoint: floor 3 map, `(3,2)`, **75/80 HP, 113 gold, 11 cards**, next choices Monster `(2,3)` or Shop `(3,3)`. Left the game there. No later room entered.

## Request accounting and evidence

**20 accepted diagnostic POSTs:** 9 card plays, 3 end turns, 4 reward actions, 2 map choices and 2 event actions. **1 deliberate stale-version POST rejected409.** Acceptance202 alone is not counted as completion; subsequent observations establish the sequence above.

`SHA256SUMS` covers **196 captures** (requests/responses/headers, screenshots, command results and installation hashes). This narrative is excluded from the manifest. Backups/binaries, helper source and any raw game logs are not published here.

Key pairs: `enter-unknown-immediate.json` → `event-ready.json`; `event-nab-map-immediate.json` → `event-complete.json`; `stale-event-choice.*`; `event-proceed.*` → `final-map.json`. Screenshot parity: `before-lethal.png`, `event-ready.png`, `event-complete.png`, `final-map.png`.

Parent-only helpers at `/tmp/jev-m2-generic-live/`: `action-once.py` requires an explicit label, recaptures a complete/nonwaiting observation, sends one POST and refuses reused request filenames; `observe-once.py` performs one GET into a fresh filename. Neither chooses strategy, loops, retries uncertain mutations or invokes Jev.

## Remaining limits

Only Nab the Map was executed; the other option and the old Byrdonis options are **not live-verified**. This demonstrates reusable ordinary-event handling, not all-event support. Multipage/repeat event choices, an awaited event deck selector, remaining required action families and other M2 native gates remain outstanding. Custom/shared/embedded-combat/contextual selection/tutorial paths retain documented limitations. No new hooks or case-specific code were added during this run.
