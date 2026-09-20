#!/bin/bash
# usage: check.sh <dll> <label>
cd /Users/yanchenxin/dev/github.com/chenxin-yan/jev-slay-the-spire-2
mise exec -- bash mod/STS2MCP/tests/check-bridge.sh "$1" "/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2/SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64/sts2.dll" > /tmp/jev-event-offer-2026-09-20/scratch/check-$2.log 2>&1; echo $? > /tmp/jev-event-offer-2026-09-20/scratch/check-$2.exit
