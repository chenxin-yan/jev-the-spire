#!/bin/bash
# usage: build.sh <label>  -> copies built DLL to scratch/dll-<label>.dll
S=/tmp/jev-event-offer-2026-09-20/scratch
cd /Users/yanchenxin/dev/github.com/chenxin-yan/jev-slay-the-spire-2
mise exec -- dotnet build mod/STS2MCP/STS2_MCP.csproj --no-restore -c Release -p:STS2GameDir='/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2' -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false -p:UseSharedCompilation=false --disable-build-servers > $S/build-$1.log 2>&1; echo $? > $S/build-$1.exit
cp mod/STS2MCP/bin/Release/net9.0/STS2_MCP.dll $S/dll-$1.dll 2>/dev/null; shasum -a 256 $S/dll-$1.dll > $S/dll-$1.sha256
