import hashlib, json, os, pathlib, subprocess, time
out = pathlib.Path(__file__).parent
root=pathlib.Path.cwd()
game=pathlib.Path.home()/'Library/Application Support/Steam/steamapps/common/Slay the Spire 2'
native=game/'SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64/sts2.dll'
assert hashlib.sha256(native.read_bytes()).hexdigest()=='9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4'
dll=root/'mod/STS2MCP/bin/Release/net9.0/STS2_MCP.dll'
commands=[
 ('native-build',['mise','exec','--','dotnet','build','mod/STS2MCP/STS2_MCP.csproj','--no-restore','-c','Release',f'-p:STS2GameDir={game}','-p:ImportDirectoryBuildProps=false','-p:ImportDirectoryBuildTargets=false','-p:UseSharedCompilation=false','--disable-build-servers']),
 ('native-check',['mise','exec','--','bash','mod/STS2MCP/tests/check-bridge.sh',str(dll),str(native)]),
 ('native-retained',['mise','exec','--','bash','/tmp/jev-overnight-readiness/baseline-check.sh',str(dll),str(native)]),
]
env={k:os.environ[k] for k in ('HOME','PATH')}
for name,cmd in commands:
 start=time.monotonic()
 with (out/(name+'.log')).open('w') as log:
  p=subprocess.run(cmd,env=env,stdout=log,stderr=subprocess.STDOUT,timeout=180)
 record={'name':name,'command':cmd,'exit':p.returncode,'seconds':round(time.monotonic()-start,3)}
 with (out/'commands.jsonl').open('a') as log:log.write(json.dumps(record)+'\n')
 print(json.dumps(record),flush=True)
 if p.returncode:raise SystemExit(p.returncode)
sha=hashlib.sha256(dll.read_bytes()).hexdigest()
assert sha=='4b5b756f2022a52d88b7338ad977fc70c82fa90718fa019b0a3485a7f791bcf3',sha
(out/'candidate.sha256').write_text(sha+'\n')
print('candidate verified '+sha)
