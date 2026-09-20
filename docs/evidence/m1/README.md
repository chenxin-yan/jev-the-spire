# M1 — Mac compatibility gate

Verified locally 2026-09-19. This is a disposable compatibility test, **not a Jev-owned run** and not the autonomous readiness gate.

## Build and review

- Upstream STS2MCP: `55e064850a68f3b4cde7e5fd525bf9b2dec4e885` (MIT).
- Editable local fork: `../STS2MCP`, uncommitted; immutable baseline: `.agent-sources/STS2MCP`.
- Game: public-beta v0.111.0, release commit `41cef1ea`, Apple Silicon macOS 14.7.1. Installed `sts2.dll` SHA-256: `9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`.
- SDK: `mise exec -- dotnet`, 9.0.318.
- Baseline build: four missing-member errors. Minimal compatibility patch replaces removed lobby accessors with installed-source-verified equivalents.
- Rebuild and independent rebuild: exit 0, zero warnings/errors. Offline lobby compatibility check passed.
- Independent review: OK with notes; missing package LICENSE corrected.
- Parent-required pre-install safety patch: expose only singleplayer GET/POST, permit only `choose_map_node`, reject browser-origin/fetch-metadata requests, remove wildcard CORS. Actual built-helper checks: 80 passed, rerun by parent (exit 0). This temporary boundary must be replaced by M2, not extended as a second protocol.
- Installed DLL SHA-256: `d67269f5999b73980d3d6308be3148b7ed6f13bba0f904f433e3bbc6faface02`. See `installed-hashes.txt` for manifest/LICENSE hashes.

Exact rebuild (from application checkout):

```sh
DOTNET_CLI_TELEMETRY_OPTOUT=1 mise exec -- dotnet build ../STS2MCP/STS2_MCP.csproj -c Release -o /tmp/jev-m1-evidence/smoke-repair/release '-p:STS2GameDir=/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2' -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false
DOTNET_CLI_TELEMETRY_OPTOUT=1 mise exec -- bash ../STS2MCP/tests/check-smoke-boundary.sh /tmp/jev-m1-evidence/package/STS2_MCP.dll
```

## Live evidence

- Manually installed DLL, one matching manifest and LICENSE in `SlayTheSpire2.app/Contents/MacOS/mods/STS2_MCP/` while game closed; relaunched through Steam. Observed official Load Mods consent dialog; subsequent loader log confirms initialization. Parent did not issue the consent click (game was subsequently observed restarted and loaded).
- Listener independently observed on **127.0.0.1:15526 only**, see `listener.txt`.
- Explicitly selected **modded profile 2** in the visible UI, verified its main-menu label, selected Ironclad, embarked, declined tutorial. Loader log confirms current run written under `modded/profile2/`.
- Stable unobstructed map: exactly one `GET /api/v1/singleplayer` answered HTTP 200 with `state_type=map`; sole legal travel option index 0 corresponded to the visibly available monster node. See `get.json`, `get.headers`, `before-map-action.png`.
- Exactly one gameplay POST: `{"action":"choose_map_node","index":0}`. HTTP 200, body `status=ok`, `Traveling to Monster at (3,0)`. See `post.json`/`post.headers`.
- Independently observed transition into first combat: Ironclad 80/80, 3 energy, five-card hand; enemy 42/42, attack intent 12. See `after-map-action.png`. No post-action polling or further gameplay action.
- Seed: `F8AG9S4KZ3GG`. M4 must use a fresh run from its first map choice; this compatibility run cannot count as Jev-only smoke evidence.

## Save-safety incident and limits

First modded startup automatically copied original saves to the separate `modded/` namespace. Steam Cloud then deleted those new local copies because absent remotely. Startup defaulted to modded profile 1; parent stopped before requests and obtained permission for a read-only metadata/source check.

Original profile 1 progress (211,334 bytes), backup, preferences and 123 run histories remained; timestamps predated installation. Installed assembly inspection established copy-to-modded paths and Cloud deletion of those same modded paths. This is evidence against deletion of originals, **not a byte-integrity guarantee** (no pre-install hash baseline). No agent edited/restored/deleted save files or changed Cloud settings. Normal game setup writes profile-2 saves and shared settings; this is not a read-only launch.

Original saves: `~/Library/Application Support/SlayTheSpire2/steam/<account>/profile1/saves/`.
Modded saves: `~/Library/Application Support/SlayTheSpire2/steam/<account>/modded/profile2/saves/`.

Raw logs remain local at `/tmp/jev-m1-live/`; they contain private account identifiers and are not included. `loader-excerpt.log` redacts the account identifier. Detailed build/probe logs: `/tmp/jev-m1-evidence/`; migration probes: `/tmp/jev-m1-safety-code/`.

M2 still must implement pure GET, full legal-action enumeration, freshness/in-flight protection, profile-2 enforcement and visible-information filtering. No autonomous use is justified by M1 alone.
