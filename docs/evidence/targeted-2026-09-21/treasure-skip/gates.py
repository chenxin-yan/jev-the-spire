from pathlib import Path
import hashlib,json,subprocess,sys
repo=Path('/Users/yanchenxin/dev/github.com/chenxin-yan/jev-slay-the-spire-2')
game=Path('/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2')
output=Path(__file__).parent/'parent'/sys.argv[1];output.mkdir(parents=True,exist_ok=True)
native=game/'SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64/sts2.dll'
dll=repo/'mod/STS2MCP/bin/Release/net9.0/STS2_MCP.dll'
commands=[('native-build',['mise','exec','--','dotnet','build','mod/STS2MCP/STS2_MCP.csproj','-c','Release',f'-p:STS2GameDir={game}','-p:ImportDirectoryBuildProps=false','-p:ImportDirectoryBuildTargets=false']),('native-check',['mise','exec','--','bash','mod/STS2MCP/tests/check-bridge.sh',str(dll),str(native)]),('test',['mise','exec','--','bun','--no-env-file','test'])]+[(name,['mise','exec','--','bun','--no-env-file','run',name]) for name in ['lint','fmt:check','typecheck']]
for name,command in commands:
 with (output/(name+'.log')).open('w') as log:result=subprocess.run(command,cwd=repo,stdout=log,stderr=subprocess.STDOUT)
 with (output/'commands.jsonl').open('a') as log:log.write(json.dumps({'name':name,'command':command,'exit':result.returncode})+'\n')
 print(name,result.returncode,flush=True)
 if result.returncode:sys.exit(result.returncode)
(output/'candidate.sha256').write_text(hashlib.sha256(dll.read_bytes()).hexdigest()+'\n')
