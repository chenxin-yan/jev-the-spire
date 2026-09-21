#!/bin/bash
set -o pipefail
GAME_DIR="/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2"
OUT=/tmp/jev-autonomous-2026-09-20/resume-receipt/implementation
cd /Users/yanchenxin/dev/github.com/chenxin-yan/jev-slay-the-spire-2
mise exec -- bash mod/STS2MCP/tests/check-bridge.sh mod/STS2MCP/bin/Release/net9.0/STS2_MCP.dll \
  "$GAME_DIR/SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64/sts2.dll" 2>&1 | tee "$OUT/check-$1.log" | grep -v "^\s*at " | tail -6
echo "check exit ${PIPESTATUS[0]}" | tee "$OUT/check-$1.exit"
