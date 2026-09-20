<p align="center">
  <img src="docs/teaser.png" alt="STS2 MCP" width="90%" />
</p>

<p align="center"><em>An Experimental Research Project to Fully-Automate your Slay the Spire 2 Runs</em></p>

## Local M2 repair candidate — not accepted or live-verified

This working tree's guarded contract is only `GET/POST /api/v1/singleplayer`, modded **profile 2**, singleplayer. The broader upstream API/install claims below do **not** describe this candidate. Do not install it before independent review and authorized live verification. M3/M4 have not started.

Native completion support below means **implemented and offline-checked**, not verified gameplay:

| Family | Retained completion / boundary | Known ceiling |
|---|---|---|
| Play card | Exact `PlayCardAction`, original enqueue-VFX task, completion and execution tasks; sticky native cancellation | Only explicitly owned, recognized selectors can continue |
| Map travel | Native map callback; exact vote (player/source/destination/generation) and synchronously caused matching `MoveToMapCoordAction`; both execution/completion tasks | Missing, duplicate, wrong-owner or wrong-destination travel halts; later room-specific detached work is not broadly intercepted |
| End turn | Native button predicate/callback; exact player/turn action; retained loop and next-player `TurnStarted` boundary | Combat exit requires exact `CombatEnded`, original gameplay/queue/loop tasks and captured exit/reward work; unowned turn-hook choices halt |
| Potion use / discard | Native manual-use callback and exact `UsePotionAction`; original `PotionCmd.Discard` task | Unsupported resulting selectors halt |
| Shop purchase / removal | Full native `NMerchantSlot.OnSelected` task, with a fresh per-purchase owner | Entry guards remain native; removal may continue through an owned supported grid |
| Rest option | Native `SelectOption` task and native unclickable/enabled/mouse guards | Requires the owned pre-Ready entry receipt below with seen `rest_site_ftue`; missing/foreign/unseen entries and unsupported resulting selectors halt |
| Combat-exit rewards | Original `ShowRewards` / `ProceedWithoutRewards` / `RewardsSet.Offer` tasks; exact `ShowScreen` surface; original `GetReward` children and terminal `ProceedFromTerminalRewardsScreen` task | Owned card chooser, sequential rewards and correlated map continuation retain the initiating parent. Unseen `obtain_relic_ftue` at ShowScreen entry permanently refuses this operation before any reward choice. Separate unseen `combat_reward_ftue` skip, boss/act/debug, linked rewards and unowned screens also halt the whole legal set. Runtime Offer binding remains same-CombatRoom; nonterminal handling is controller coverage only; nested/wrong-room Offers fail closed |
| Owned child decisions | Exact selector instance + operation owner + pending selection task; child consumes its version without replacing/releasing its parent | Hand; deck/simple/upgrade/transform grids; choose-a-card; card rewards only. Overlapping/nested selectors halt; sequential selectors get new leases |
| Event options / ordinary event rewards | Generic native option protocol for any `EventModel` (no event-name, callback-name or relic allowlist): exact owned `SetupLayout` Task, exact `CurrentOptions[index]`/layout-button identity, single native callback, native input-generation receipts, exact appended option task; separate event-owned `Offer`/`ShowScreen`, retained reward children and owned deck-selector leases while the root is pending | `legal_actions_complete` certifies the **current** decision, not every later consequence. A chosen option may open an unsupported surface (custom minigame, contextual grid, modal, event combat) after its cost/effect already applied; the bridge then halts with the existing diagnostics and never retries, rolls back, clicks through or infers success from `IsFinished`/stable screens. Shared, custom-layout, embedded-combat and lethal-confirmation alternatives and missing/multicast callbacks halt the whole current observation before dispatch. Event Offers must be nonterminal and same-run/room/player; no roomless/nested ownership or fake combat lifetime |
| Ancient dialogue / event proceed | Original dialogue callback plus exact Released/line/control receipt; IsProceed-only original `Chosen` Task plus exact map Opened receipt | Owned standard layout required. Dialogue is synchronous; cosmetic fades/delayed focus are not gameplay receipts. Finished-event proceed only; native map exclusions remain |
| Open / close shop | Exact `MerchantOpened` / `InventoryClosed` subscription before the original click, successful synchronous return and receiver/control postconditions | Cached unseen merchant FTUE, input blocking, targeting, dead player and mismatched input filters refuse the whole observation. Close does not proceed; cosmetic fades are not completion receipts |
| Merchant / rest proceed | Exact map receiver's `Opened` signal, successful original click return and native map postconditions | No act-start/active act-animation, unseen map FTUE, disabled-input or traveling branch. Rest requires an owned pre-Ready snapshot; attaching to an existing rest room is unsupported |
| Treasure open / relic claim / skip / proceed | Exact OpenChest, skip-enabling, registered PickRelicAction, awards and scoped non-generic Obtain Tasks; original callbacks and exact terminal-proceed/map receipt | One fresh nonempty singleplayer collection. Original OpenChest yields owned extra rewards and relic choices; picking-finished/map visibility cannot omit AfterObtained or awards work. Empty/reopened/precompleted collections, unknown results and foreign work refuse the whole decision |
| Other unsupported proceeds | **No completion adapter** | Entire affected observation halts before dispatch; no pruning into a supposedly complete legal set. This is not full M2 support |
| Bundle/relic choices, unfamiliar grids, foreign/unowned selectors | **Unsupported** | Fail closed; no ownership adoption from visible UI or current executor action |

Selection ownership uses a small required, version-specific Harmony shim on contextual `CardSelectCmd` entries and four hand/grid/chooser task boundaries. It propagates only explicitly registered native action identities or scoped opaque task owners; foreign/human selectors are not instrumented. Foreign reentry on an already-owned selector invalidates/fails the old lease without blocking the foreign callback. No global TaskHelper hooks, idle/fingerprint completion, or general fire-and-forget interception. Context is restored immediately at caller boundaries while captured async continuations retain it. Task-owner registrations and subscriptions are cleaned on completion/fault/cancel/abandonment; event-entry observers additionally span the owned scene and close on scene exit, replacement movement or entry failure. One active card selector per operation remains the ceiling; an owned reward backdrop may suspend while that selector is active.

The shim refuses any game assembly other than inspected v0.111 (`sts2.dll` SHA256 `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`). Hook-install failure prevents listener startup. This required shim is separate from the inherited optional Harmony patch switch. Remove it when upstream exposes explicit selector/decision owner tokens and owned combat-exit/Offer/proceed tasks.

Context is read in order: modded profile-2 gates, then run presence, then the running run's network service. A no-run main menu never dereferences `RunManager.NetService` and halts as `no_active_run` (or terminal game over) with no actions; a run in progress without a service halts `run_network_service_unavailable` rather than defaulting to singleplayer. An ordinary card reward whose offered holders are still in the native `DisableCardsForShortTimeAfterOpening` window (the only `SetClickable(false)` caller in v0.111, which leaves Skip enabled) is reported as a waiting, incomplete `card_reward` with no alternatives; takes and Skip appear together under the same retained owner once native card input is ready. Missing holder clickability metadata halts the observation instead of waiting or pruning.

Ownership gating and state building share foreground-overlay precedence: lingering rewards defer to map; actual grid/chooser overlays remain foreground. Active-combat grid/chooser/card-reward observations reuse the existing battle builder, including its observed-creature and readable-intent filters. Managed gate/branch tests do not establish live visibility or peek parity.

The current bounded combat-exit shim adds only `NCombatUi.ShowRewards`, `NCombatUi.ProceedWithoutRewards`, `RewardsSet.Offer`, `NRewardsScreen.ShowScreen`, and the additionally approved `RunManager.ProceedFromTerminalRewardsScreen`. It registers exact run/room/combat/UI/player/initiating-action identity before enqueue can execute. Card/potion/end-turn actions also retain the original native queue-batch receipt captured at their exact `BeforeActionExecuted`: the executor checks victory **after** action completion and propagates those faults to that receipt. No arbitrary current-executor selector ownership is inferred.

`Offer` and its UI ancestors can span human choices; their completion is not required to expose the exact owned `ShowScreen` decision. Original gameplay/post-action cleanup and the exact `CombatEnded` receipt are still required. Pending original claims block sibling choices but allow their registered card selectors. Native button release observations revoke bridge permission on foreign input without stopping human callbacks. Terminal proceed may open map while Offer is still pending: an explicit map continuation retains the parent through existing vote/movement receipts and room-exit skip. No new-room reward ownership is inherited from that map transition. The retained card/potion (non-join) turn loop may still be suspended after victory; the owned travel's native `CombatRoom.Exit` → `CombatManager.Reset(true)` → `CombatTurnState.Cancel` (parameterless `TrySetCanceled`) legitimately cancels it. That cancellation is accepted only after the exact chained `MoveToMapCoordAction` was seen entering execution (existing `BeforeActionExecuted`) with the original run, current combat room and `_turnLoopTask`, and the continuation-scoped existing `RunManager.RoomExited` then fired with the same run, the old room popped and that travel as `CurrentlyRunningAction`; it permits waiting only. Release additionally requires that exit receipt, the settled loop, same run at the exact destination and every original Offer/child/vote/movement task. Cancellation before or without that receipt (including `RunManager.CleanUp`, which never emits `RoomExited`), a foreign executing action, wrong run/room, a second exit, the joined end-turn loop, loop faults, movement faults/cancellation or sticky action cancellation still halt. Once the map continuation is consumed, the existing per-poll identity check also fails the operation (`reward_run_invalidated`, sticky, normal release) if the original `RunState` disappears or is replaced at any later poll, including after the valid exit and successful movement but before the next observation; same-run travel that has not yet reached the exact destination only stays pending. Original faults/cancellation halt; UI animations alone never establish completion. Death requires exact `CombatEnded` plus original action/queue cleanup (and the retained loop for end-turn), not game-over visibility. These are source-grounded and managed-fixture-tested paths, **not live verification**.

The existing pinned ShowScreen boundary samples cached `SeenFtue("obtain_relic_ftue")` **before** Push/_Ready. A true entry value proves that this screen's RelicFtueCheck takes its synchronous early return (including native FTUE-disabled behavior). A false entry value permanently refuses the operation: that detached task awaits two frames and does not recheck the flag before adding its modal. Later seen flags, absent modals, or no currently listed relic do not prove the task settled; no retry reopens that failed operation. Existing live modal/tutorial guards still block even a seen-at-entry screen, since native MarkFtueAsComplete follows modal Add, not dismissal. The separate `combat_reward_ftue` predicate still guards terminal skip. Both are cached runtime reads only; unsupported branches invalidate the entire observation, not selected choices. That FTUE repair adds no hook target, RelicFtueCheck hook, delay, task-completion guess, tutorial dismissal, seen-flag write or profile change. Upstream should expose the post-action win-check/teardown receipt, owned exit tasks, and stable reward decision tokens with child-task accounting; then delete this version-pinned local shim and its event subscriptions.

Stage 1 adds **no Harmony targets**. A map-entry-scoped `SceneTree.NodeAdded` listener is registered before the original map callback. It requires the explicitly registered movement's scoped owner, exact run/player/destination/current room scene and model, and a main-thread already-ready parent with the fresh node's `_proceedButton` still null. Native `_Ready` assigns that field before launching the detached rest tutorial; `NSceneContainer` assigns CurrentScene before AddChild. Cached rest FTUE readiness is sampled at that event, not before asynchronous travel or during GET. The exact movement's AfterFinished seals the receipt; existing completion/execution/cancellation ownership still gates exposure. Missing context, late/reused/foreign nodes, cancellation or an unseen entry cannot be healed by later flags. Subscriptions are released with the map owner. Installed Godot execution/context propagation remains a live gate; a missing receipt refuses the entire rest observation.

Stage 2 adds only `NEventRoom.SetupLayout` and IsProceed-only `EventOption.Chosen` captures. Movement ownership is registered before native setup can run. Setup's original Task must succeed; ordinary option nodes additionally need exact generation/option identity and an observed initial Ignore filter before their native enabled/Stop gate. StateChanged renews identities but is never completion: a callback's new page can become actionable while its original task still runs, and a later fault of that task stays sticky. Ordinary options are admitted by the shared native route (`OptionButtonClicked → EventSynchronizer.ChooseLocalOption → CurrentOptions[index].Chosen().RunSafely()` appended to the unshared synchronizer's task list), whose task already awaits the option's pre-callback, callback and awaited command/listener effects; the bridge retains that exact task and does not inspect callback owners or effect names. Observation and dispatch bind options through the same `NEventLayout.OptionButtons` and native option index, never scene-tree traversal order. While an event root is pending, a foreground overlay the bridge cannot own (for example the CrystalSphere minigame) reports the existing unsupported-overlay halt instead of an indefinite `waiting`; unowned selectors still halt as `unowned_selection_continuation`, and contextual event grids remain unsupported. This is a deliberate ceiling accepted by the owner: the retained task is a receipt for the current decision, not a certificate that every descendant surface is supported, and an unsupported follow-up is contained after the fact rather than prevented before the choice. Exact scoped NodeAdded observations and foreign Released/StateChanged invalidation are scene-bound, not ownership inferred from visible controls. A missing/foreign/duplicate setup, unverified prefab filter, changed run/room/model/layout/player or failed/canceled retained Task fails closed. Dialogue context excludes future lines and options while dialogue is active. **Initial act opening (Neow):** the same `SetupLayout` capture may bind the one room the native run start created itself, since `RunManager.EnterAct` enters the starting Ancient point without any map travel only for act 0 with `StartedWithNeow`. Provenance is native lifecycle state, not the visible screen: `RunManager._numReloads == 0` (every saved-run setup runs `SaveManager.IncrementNumReloads` before `InitializeShared`; new runs pass 0), act 0 with Neow, current coordinate equal to the act's `StartingMapPoint`, `Ancient` point type, exactly one visited coordinate, unfinished room/model, no executing `GameAction` (foreign travel), no ambient bridge owner and no live entry. Restored/continued, resumed, later-act and human-travel rooms stay `event_setup_unowned`. This adds no hook target, run-lifecycle subscription or session authority; only the option/dialogue receipts already described apply afterwards. Later-act Ancients are ordinary owned map travel to the act's starting point and depend on the still-refused boss/act transition. Neow's finished-page Proceed (`NEventRoom.Proceed` = `SetTravelEnabled(true)` + `Open(false)`) opens the map through the start-of-act branch (`StartOfActAnim`/act banner). By owner approval, only the owned fresh `ActOpening` entry on the act-0/Neow/`ActFloor == 1` map is exempt from the shared guard's `startsAct`/`_actAnimTween` refusal (`BridgeProtocol.InitialOpeningProceed`); the exact `Chosen` root task, synchronous `Opened` receipt after `RecalculateTravelability`, input-disabled/traveling/receiver checks and the entry-time `map_select_ftue` read all remain. The detached `StartOfActAnim` task is natively discarded and may never finish after a human interrupt, so it is neither hooked nor awaited; its only gameplay descendant (`InitMapPrompt → MapFtueCheck`) re-reads the seen flag, whose sole lowering writer is the human settings reset-tutorials popup (accepted residual). Merchant/rest/treasure/reward proceeds, later-act openings, restored and foreign rooms keep the full refusal; the following initial map decision is the existing owned `choose_map_node` route, whose listing/dispatch never consulted the guard. Event reward decisions retain the original option parent, original Offer and child Tasks, with the same sticky unseen-at-entry relic-FTUE refusal and live modal guard as combat. Existing contextual-selector masks remain strict: unknown contexts/selector kinds are not adopted. Native hook installation, node delivery/context propagation and supported-path availability remain unexecuted live gates.

Stage 3 adds only exact `NTreasureRoom.OpenChest`, `EnableSkipAfterDelay(float,CancellationToken)`, `NTreasureRoomRelicCollection.AnimateRelicAwards(List<RelicPickingResult>)`, and non-generic `RelicCmd.Obtain(RelicModel,Player,int)` boundaries. The Obtain hook is inert outside the exact awards scope; expected recipient/model correspondence is checked before its synchronous AfterObtained segment. Existing contextual selector hooks admit ordinary contexts only in that explicit Obtain scope. Exact PickRelicAction registration precedes execution; awards require that registered action's execution receipt and collection/results identities, not arbitrary current-executor ownership. Native holder MouseFilter enabling is required; the unsigned strict `ticks-openedTicks > 200` predicate is an input guard, never a completion timer. The skip token is captured from the owned native call, and cancellation is accepted only after the owned picking-began/awards boundary. Pending awards/Obtain work blocks early-opened-map travel while still permitting its exact recognized selectors. Extra reward children preserve parent ownership and sticky relic-tutorial refusal. Unopened native proceed has only its own original transition receipt, not invented chest gameplay. Empty/reopened/previously-completed collections remain unsupported; unrelated native input revokes bridge permission. Actual scenes, hook installation, task-context propagation and all resulting relic/selector variants still require independent/native verification.

Offline check: `bash tests/check-bridge.sh <candidate-STS2_MCP.dll> <installed-sts2.dll>` under .NET 9. Checks exercise production protocol/ownership helpers, managed-only Harmony fixtures, native metadata, and a direct GET-mutation scan. They do **not** establish Godot scene legality, complete transitive GET purity, or live behavior. End-to-end M2 remains incomplete.

---

**Original upstream documentation follows (not local candidate acceptance or installation authorization).**

A mod for [**Slay the Spire 2**](https://store.steampowered.com/app/2868840/Slay_the_Spire_2/) that lets AI agents play the game. Exposes game state and actions via a localhost REST API, with an optional MCP server for Claude Desktop / Claude Code integration.

Singleplayer and multiplayer (co-op) supported, plus full menu and lobby control: profile switching, character select (SP and MP host/client) with optional seed, multiplayer host / Steam-friend join / FastMP localhost join, multiplayer load lobby for resuming saved co-op runs, game-over dismissal, FTUE/tutorial popup handling, and Timeline visibility. Tested against STS2 `v0.103.2`.

> [!warning]
> This mod allows external programs to read and control your game via a localhost API. Use at your own risk with runs you care less about.

> [!caution]
> Multiplayer support is in **beta** — expect bugs. Any multiplayer issues encountered with this mod installed are very likely caused by the mod, not the game. Please disable the mod and verify the issue persists before reporting bugs to the STS2 developers.

## For Players

### 1. Install the Mod

Grab the [latest release](https://github.com/Gennadiyev/STS2MCP/releases/latest) and follow the instructions:

1. Copy `STS2_MCP.dll` and `STS2_MCP.json` to `<game_install>/mods/`
2. Launch the game and enable mods in settings (a consent dialog appears on first launch)
3. The mod starts an HTTP server on `localhost:15526` automatically

> [!note]
> The release DLL is a platform-agnostic .NET assembly — the same `STS2_MCP.dll` and `STS2_MCP.json` work on Windows, Linux, and macOS. No separate builds are needed.

#### macOS install

On macOS, the mods directory lives inside the app bundle. The default Steam install path is:

```
~/Library/Application Support/Steam/steamapps/common/Slay the Spire 2/
    SlayTheSpire2.app/Contents/MacOS/mods/
```

To install, right-click `SlayTheSpire2.app` → **Show Package Contents**, navigate to `Contents/MacOS/`, and create a `mods` folder. Or from the terminal:

```bash
GAME_DIR="$HOME/Library/Application Support/Steam/steamapps/common/Slay the Spire 2"
MODS_DIR="$GAME_DIR/SlayTheSpire2.app/Contents/MacOS/mods"
mkdir -p "$MODS_DIR"
cp STS2_MCP.dll "$MODS_DIR/"
cp STS2_MCP.json "$MODS_DIR/"
```

Launch the game and open **Settings → Mods**. The mod should appear in the list. A consent dialog appears on first launch — accept it to enable mod loading. Once enabled, verify the HTTP server is running:

```bash
curl -s http://localhost:15526/
```

A successful response looks like:

```json
{"message": "Hello from STS2 MCP v0.3.4", "status": "ok"}
```

If you get "Connection refused", the mod is not loaded — check that mods are enabled in the game's settings.

### 2. Give Your AI Instructions to Interact with the Game

**Clone or download the repository**, then:

| I prefer a skill | I prefer an MCP Server |
|---|---|
| Tell AI to reference docs/raw-*.md. Sit back, and watch it play. | Requires [Python 3.11+](https://www.python.org/) and [uv](https://docs.astral.sh/uv/). Follow the instructions below ⬇️ |

#### MCP server setup

Install [uv](https://docs.astral.sh/uv/) if you don't have it (macOS: `brew install uv`). Then run the server once to install dependencies:

```bash
uv run --directory /path/to/STS2_MCP/mcp python server.py --help
```

`uv` reads `mcp/pyproject.toml`, creates an isolated virtual environment, and installs the pinned dependencies from `mcp/uv.lock`. Subsequent runs reuse the environment instantly.

Add the server to your AI client's MCP config:

```json
{
  "mcpServers": {
    "sts2": {
      "command": "uv",
      "args": ["run", "--directory", "/path/to/STS2_MCP/mcp", "python", "server.py"]
    }
  }
}
```

**Claude Code**: add to your project's `.mcp.json`.
**Claude Desktop**: add to `claude_desktop_config.json` with the same config as above.
*Other agents should have similar config options for custom MCP servers.*

> [!tip]
> On macOS, use the absolute path to `uv` (e.g. `/opt/homebrew/bin/uv`) in the `command` field. GUI-launched apps may not inherit your shell's `PATH`, which would prevent the server from starting.

Restart your Claude session after adding the config. To verify the MCP server is working, ask Claude to call `get_game_state` — with the game running, it should return the current game state.

The MCP server accepts `--host` and `--port` options if you need non-default settings.

Flag `--no-trust-env` can be used to disable `requests` from picking up proxy settings from the environment, which can cause connection issues if you are running the server in a container.

### Profile and Compendium Data

The HTTP API exposes profile-level progress separately from live run state:

- `GET /api/v1/profile` returns the active profile's persistent progress summary, including discoveries, achievements, epochs, character totals, and global run totals.
- `GET /api/v1/compendium` groups that progress into the same high-level sections as the in-game Compendium: Card Library, Relic Collection, Potion Lab, Bestiary, Character Stats, and Run History.
- `GET /api/v1/wiki?query=...` searches discovered card and relic wiki entries for the active profile with fuzzy matching. Results are limited to 10 by default and can be overridden with `limit`; card results include base and upgraded variants when available.
- `GET /api/v1/profiles` lists the three profile slots and the active profile.
- `POST /api/v1/profiles` switches or deletes profile slots through the game UI.

The MCP server exposes the same profile data through `get_profile()`, `get_compendium()`, `search_wiki(query, item_type, limit)`, `list_profiles()`, `switch_profile(profile_id)`, and `delete_profile(profile_id)`.

`get_compendium()` is intended for agents that need durable context outside the current room or current run. It works from the main menu, includes a `current_run` block while a run is active, and summarizes saved `saves/history/*.run` files for the active profile. Run history is capped to the 20 most recent files in the response so long-lived profiles do not create unbounded tool output.

`search_wiki()` is the selective lookup path for durable card and relic text. It never returns the full game catalog: the mod first filters to the active profile's discovered card and relic IDs, then returns only the best fuzzy matches. Use `item_type="card"` or `item_type="relic"` when the query is known, and raise `limit` only when the default 10 results are not enough.

## For Developers

### Build & Install

Requires [.NET 9 SDK](https://dotnet.microsoft.com/download/dotnet/9.0) and the base game.

**PowerShell** (recommended):

```powershell
# Pass game path directly:
.\build.ps1 -GameDir "D:\SteamLibrary\steamapps\common\Slay the Spire 2"

# Or set it once and forget:
$env:STS2_GAME_DIR = "D:\SteamLibrary\steamapps\common\Slay the Spire 2"
.\build.ps1
```

The script builds `STS2_MCP.dll` into `out/STS2_MCP/`. Copy it along with the manifest JSON to `<game_install>/mods/` to install:

```
out/STS2_MCP/STS2_MCP.dll           ->  <game_install>/mods/STS2_MCP.dll
mod_manifest.json                   ->  <game_install>/mods/STS2_MCP.json
```

### Build instructions for macOS

Install dotnet to compile the mod:

```bash
brew install dotnet@9
export DOTNET_ROOT="/opt/homebrew/opt/dotnet@9/libexec"
export PATH="$DOTNET_ROOT:$PATH"
```

Homebrew installs `dotnet@9` as keg-only, so the exports above are required for the current session. Add them to `~/.zshrc` to persist across sessions.

Build with `dotnet` directly (the PowerShell script is Windows-only):

```bash
dotnet build STS2_MCP.csproj -c Release -o out/STS2_MCP \
  -p:STS2GameDir="$HOME/Library/Application Support/Steam/steamapps/common/Slay the Spire 2"
```

On macOS the game ships as an app bundle. The `.csproj` detects macOS and resolves the data directory to `SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64` automatically.

The mods directory on macOS lives inside the app bundle at `SlayTheSpire2.app/Contents/MacOS/mods/`. Finder hides bundle contents by default — to browse it in the GUI, right-click `SlayTheSpire2.app` → **Show Package Contents**. Or copy from the terminal:

```bash
GAME_DIR="$HOME/Library/Application Support/Steam/steamapps/common/Slay the Spire 2"
MODS_DIR="$GAME_DIR/SlayTheSpire2.app/Contents/MacOS/mods"
mkdir -p "$MODS_DIR"
cp out/STS2_MCP/STS2_MCP.dll "$MODS_DIR/"
cp mod_manifest.json "$MODS_DIR/STS2_MCP.json"
```

> [!NOTE] 
> `mod_manifest.json` is renamed to `STS2_MCP.json` on copy — the game's mod loader expects the manifest filename to match the mod ID.

## License

MIT

## FAQ

### Why let the AI play the game for me?

I start building this mod with the hope that I can co-op with an AI player. Singleplayer is originally just built for validation.

### You did not answer the question!

First of all, I play lots of games, including service games that has daily/weekly tasks. I really hoped that modern AI could save me from the grind, which, if you have tried one or more of the GUI agents, never really materialized. Let's face it: modern AI is still pretty bad at gaming because no one cares.

About my intention, as a researcher that loves playing games, the purpose of STS2MCP is to test AI models and agents in a rarely explored (we call it out-of-distribution) domain. Ultimately, this might turn into a benchmark for evaluating the reasoning and decision-making capabilities of different language models.

STS2 is just an example to show how good (or bad) current AI agents are at playing such games. **I have no intention to replace human players with AI, and I would definitely rather play STS2 myself** as a big fan of the game.

### Is this a cheat mod?

It can be, but it doesn't have to be. The mod itself does not alter the gameplay. It is just an interface that allows external programs to interact with the game. What you do with that interface is up to you.

### How many tokens do a run consume?

I evaluated on the Ironclad. Claude Sonnet 4.6 uses slightly more than 8M tokens (counting both input, output and tool responses) for a full run. GPT-5.4 averages 7.34M tokens. Depending on your prompt and model choice, it can be more or less.

### Do you have a roadmap for future features?

The project is still too early to have a clear roadmap. My current focus is to make sure the core features are stable and well-documented. However, I am open to suggestions and contributions from the community.

- Solidifying multiplayer features and fixing bugs is a priority
- Add support for in-game communication in multiplayer runs when collaborating with an AI agent
- Self-reflection and learning from past runs to improve future performance
- Benchmarking different models and agents is also on my mind
