import json, pathlib, subprocess, sys
root = pathlib.Path('/Users/yanchenxin/dev/github.com/chenxin-yan/jev-slay-the-spire-2')
base = pathlib.Path('/tmp/jev-autonomous-2026-09-20/headbutt/parent') / sys.argv[1]
base.mkdir(parents=True, exist_ok=True)
game = pathlib.Path.home() / 'Library/Application Support/Steam/steamapps/common/Slay the Spire 2'
checks = [
 ('native-build', ['mise','exec','--','dotnet','build','mod/STS2MCP/STS2_MCP.csproj','-c','Release',f'-p:STS2GameDir={game}','-p:ImportDirectoryBuildProps=false','-p:ImportDirectoryBuildTargets=false']),
 ('native-check', ['mise','exec','--','bash','mod/STS2MCP/tests/check-bridge.sh','mod/STS2MCP/bin/Release/net9.0/STS2_MCP.dll',str(game/'SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64/sts2.dll')]),
]
if '--all' in sys.argv:
 checks += [('test',['mise','exec','--','bun','--no-env-file','test'])] + [(name,['mise','exec','--','bun','--no-env-file','run',name]) for name in ['lint','fmt:check','typecheck']]
for name, command in checks:
 with (base/(name+'.log')).open('w') as log:
  result = subprocess.run(command, cwd=root, stdout=log, stderr=subprocess.STDOUT)
 with (base/'commands.jsonl').open('a') as log:
  log.write(json.dumps({'name':name,'command':command,'exit':result.returncode})+'\n')
 print(f'{name}: exit {result.returncode} ({base/(name+".log")})', flush=True)
 if result.returncode:sys.exit(1)
