from pathlib import Path
import json,subprocess,sys
root=Path('/Users/yanchenxin/dev/github.com/chenxin-yan/jev-slay-the-spire-2')
output=Path(__file__).parent/'gates';output.mkdir(exist_ok=True)
commands=[('test',['mise','exec','--','bun','--no-env-file','test'])]+[(name,['mise','exec','--','bun','--no-env-file','run',name]) for name in ['lint','fmt:check','typecheck']]
for name,command in commands:
 with (output/(name+'.log')).open('w') as log: result=subprocess.run(command,cwd=root,stdout=log,stderr=subprocess.STDOUT)
 with (output/'commands.jsonl').open('a') as log:log.write(json.dumps({'name':name,'command':command,'exit':result.returncode})+'\n')
 print(name,result.returncode,flush=True)
 if result.returncode:sys.exit(result.returncode)
