#!/bin/bash
# Build + offline check per mod/STS2MCP/README.md (no install). usage: build.sh <label>
set -o pipefail
GAME_DIR="/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2"
OUT=/tmp/jev-autonomous-2026-09-20/resume-receipt/implementation
cd /Users/yanchenxin/dev/github.com/chenxin-yan/jev-slay-the-spire-2
DOTNET_CLI_TELEMETRY_OPTOUT=1 mise exec -- dotnet build mod/STS2MCP/STS2_MCP.csproj -c Release \
  -p:STS2GameDir="$GAME_DIR" -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false \
  2>&1 | tee "$OUT/build-$1.log" | tail -5
echo "build exit ${PIPESTATUS[0]}" | tee "$OUT/build-$1.exit"
shasum -a 256 mod/STS2MCP/bin/Release/net9.0/STS2_MCP.dll | tee "$OUT/dll-$1.sha256"
mise exec -- bash mod/STS2MCP/tests/check-bridge.sh mod/STS2MCP/bin/Release/net9.0/STS2_MCP.dll \
  "$GAME_DIR/SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64/sts2.dll" 2>&1 | tee "$OUT/check-$1.log" | tail -8
echo "check exit ${PIPESTATUS[0]}" | tee "$OUT/check-$1.exit"
