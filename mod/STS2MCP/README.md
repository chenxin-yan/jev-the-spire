# Jev's STS2 bridge

This directory is the authoritative mod source for this project. The Bun CLI lives in
[`../../src`](../../src); compatible CLI and bridge changes belong in the same commit.
It exposes only `GET/POST /api/v1/singleplayer` on localhost, for **modded profile 2**.

## Build and check

From the repository root on the owner's Mac, with the game installed:

```sh
GAME_DIR="$HOME/Library/Application Support/Steam/steamapps/common/Slay the Spire 2"

mise exec -- dotnet build mod/STS2MCP/STS2_MCP.csproj -c Release \
  -p:STS2GameDir="$GAME_DIR" \
  -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false

mise exec -- bash mod/STS2MCP/tests/check-bridge.sh \
  mod/STS2MCP/bin/Release/net9.0/STS2_MCP.dll \
  "$GAME_DIR/SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64/sts2.dll"
```

These commands build and run offline compiled-bridge/metadata checks; they do not install
or launch the mod, access saves, issue game requests, or prove Godot behavior. The game
assemblies are local references, not redistributed dependencies. `bin/`, `obj/` and `out/`
are ignored. Native checks require those assemblies and are separate from the app-only CI.

The bridge is pinned to game v0.111.0 (`41cef1ea`), with `sts2.dll` SHA256
`9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4`.
Unsupported versions or ownership/tutorial states refuse dispatch. The bridge session is
process-scoped and is replaced only at the native new-run boundary (`RunManager.InitializeNewRun`);
failures within a run, on Continue/saved runs or on CLI reconnect stay latched. Deck grid screens
(select/upgrade/transform/enchant) expose a decision only when every native candidate has an
allocated holder: v0.111 `NCardGrid` allocates a sliding window of rows, so a deck larger than that
window halts as `grid_candidates_incomplete` instead of offering a partial set. Build success is not
permission to install: live work remains separately approved and restricted to profile 2.
See [current scope](../../docs/minimal-demo.md) and
[the offline review](../../docs/evidence/m3/crust-neow-review.md).

## Provenance

- Upstream: [Gennadiyev/STS2MCP](https://github.com/Gennadiyev/STS2MCP), based on
  commit `55e064850a68f3b4cde7e5fd525bf9b2dec4e885`.
- Imported local checkpoint: `96597ec7c5431591f989317baf73e64e53b906ab`, branch
  `checkpoint/jev-minimal-demo` in the preserved sibling checkout.
- App checkpoint before colocation: `3cfe5d26a2c7d325560c032ed63c9867f468f55b`.
- License: [MIT, copyright 2026 Yikun Ji (Kunologist)](LICENSE), retained verbatim.

All 25 C# files, project/solution, build helper, mod manifest, test harness and license were
imported unchanged. The source checkout's README is preserved verbatim as
[UPSTREAM.md](UPSTREAM.md): its historical milestones, broader API claims and relative
links are archival, not current instructions. The Python MCP client, standalone-repo
metadata/docs, agent settings, game binaries and build outputs were not imported.

This is a plain source import, not a submodule. Make future changes here; the sibling is
only a checkpoint backup. Historical evidence keeps its original sibling and scratch
paths so its provenance is not rewritten.
