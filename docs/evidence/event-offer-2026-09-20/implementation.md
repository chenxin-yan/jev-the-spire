# event_offer_identity_unverified — implementation handoff

HEAD 3c3f8cf, working tree uncommitted (2 files). Reviewer artifacts: `/tmp/jev-event-offer-2026-09-20/scratch/{review.diff,status.txt}`.

## Root cause (offline IL, native sts2.dll sha `9cb4f1ad…`, no engine init)

- `RewardsCmd.OfferCustom(player, rewards)` = `new RewardsSet(player, null).WithCustomRewards(rewards).Offer()` (`offer-custom-state.il`).
- `RewardsSet..ctor` sets Player + synchronizer only; `WithCustomRewards` only `AddRange`s. `set_Room` has exactly **two** native callers — `EmptyForRoom`, `WithRewardsFromRoom` — reached only from `OfferForRoomEnd`/`GenerateForRoomEnd` (`scratch/callers-set_Room.log`, `callers-EmptyForRoom.log`, `callers-WithRewardsFromRoom.log`).
- **All 24** `OfferCustom` callers (relics: SmallCapsule, CallingBell, Cauldron, GlassEye, Kaleidoscope, LostCoffer, Orrery, ToyBox, NeowsBones-adjacent; 14 event options; `HealRestSiteOption`; crystal sphere sync) therefore produce `RewardsSet.Room == null` (`scratch/callers-OfferCustom.log`).
- Old event and treasure guards in `RewardOfferPrefix` required `ReferenceEquals(__instance.Room, op.Room)` → fail-closed on every native custom offer. Hypothesis (1) confirmed; (2)/(3) ruled out for this halt (player/run checks are retained and would have named a different failure; nested/closed checks precede the room check and are unchanged).

## Fix (mod/STS2MCP/McpMod.RewardHooks.cs, +7/−4 net)

One shared predicate, used by **both** treasure and event branches after their unchanged `RequireTreasureIdentity` / `RequireEventIdentity`:

```csharp
private static bool NonCombatOfferIdentity(RewardsSet set, object? room, object player, object run)
    => room != null && (set.Room == null || ReferenceEquals(set.Room, room))
        && ReferenceEquals(set.Player, player) && ReferenceEquals(set.Player.RunState, run);
```

- Null `set.Room` accepted (native custom-offer contract); non-null must equal the verified live room; exact player + player's run agreement preserved; `room == null` (unbound entry) still refused.
- Combat branch untouched: still strict `CurrentRoom`/`set.Room`/player/run equality and `nested_rewards_set_unverified`.
- No event/relic-name exceptions, no new hooks, no behavior override, no blanket ownership.

## Tests (mod/STS2MCP/tests/check-bridge.sh, +40, inside the native-assembly block)

Real native `RewardsSet`/`Player`/`RunState`/`EventRoom`/`TreasureRoom` via `RuntimeHelpers.GetUninitializedObject` + backing-field writes (`Player._runState`, `<Room>/<Player>k__BackingField`; getters verified as pure `ldfld`). 10 new checks:
1. Pinned native contract: `WithCustomRewards` body never calls `set_Room`; `Player._runState` exists.
2. null-room custom set, verified player/run → owned.
3. same-room set → owned.
4. foreign non-null room → refused.
5. foreign player (same run) → refused.
6. foreign run → refused.
7. same room, foreign run → refused.
8. unbound live room (`room == null`) → refused.
9. Compiled wiring: `RewardOfferPrefix` calls `NonCombatOfferIdentity` exactly 2×, plus `RequireTreasureIdentity` and `RequireEventIdentity`.
10. Combat strictness: exactly one direct `RewardsSet.get_Room` remains in `RewardOfferPrefix`, `get_CurrentRoom` present, strings `rewards_set_identity_mismatch` and `nested_rewards_set_unverified` present.

## Red/green/mutation (exact exits + logs in `/tmp/jev-event-offer-2026-09-20/scratch/`)

| step | dll | exit | result |
|---|---|---|---|
| check-baseline | installed baseline `9bcaa0b1…` | 0 | PASS 2032 |
| build-extracted | behavior-preserving extraction (strict `ReferenceEquals(set.Room, room)`) into helper, both callers wired | 0 | `dll-extracted.sha256` |
| check-red | dll-extracted + new tests | 134 | `native custom RewardsSet (Room null) offered by the verified player in the verified live room is owned` — real causal red, not a missing symbol |
| build-green / check-green | relaxed predicate | 0 / 0 | PASS 2042 |
| mutation-blanket-null-room | player/run agreement only when Room bound (`set.Room == null \|\| (…&&…&&…)`) | 0 / 134 | killed: `custom RewardsSet for a different player is refused` |
| build-final | restored green source (byte-identical, copy kept outside repo, no git checkout) | 0 | sha == dll-green |

Commands: `scratch/build.sh <label>` (canonical mise dotnet build line), `scratch/check.sh <dll> <label>` (check-bridge.sh with pinned native sts2.dll).

**Final DLL sha256:** `c140c7a498857d7b3587d8e9a6e0a8fb8e085337d8a0b9ead7cd71410903dedc` (`scratch/dll-final.dll`). Not installed.

## Coverage limits / risks

- Predicate and compiled wiring only; `RewardOfferPrefix` scope selection, `BeginOffer`/`AttachOffer`, and downstream `RewardScreenPostfix` (`__args[0] == ordinary.Set` — unaffected, still same-instance) are not executed offline (Godot).
- Treasure branch relaxed identically (a relic obtained from a chest with `AfterObtained → OfferCustom` would have hit the same wall); combat branch intentionally still refuses null-room nested sets as before.
- Live trial (Neow Small Capsule → relic reward) remains user-controlled.

Skipped: any per-relic/per-event allowlist; add never — the null-Room contract is structural in `RewardsCmd`.
