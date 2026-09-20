import json, os, pathlib, subprocess, time
out = pathlib.Path(__file__).parent
commands = [
 ('lint', ['mise','exec','--','bun','--no-env-file','run','lint']),
 ('format', ['mise','exec','--','bun','--no-env-file','run','fmt:check']),
 ('typecheck', ['mise','exec','--','bunx','--no-env-file','--no-install','tsc','--noEmit']),
 ('test', ['mise','exec','--','bun','--no-env-file','test']),
]
env = {k: os.environ[k] for k in ('HOME','PATH')}
failed = False
for name, cmd in commands:
 start=time.monotonic()
 with (out/(name+'.log')).open('w') as log:
  result=subprocess.run(cmd, env=env, stdout=log, stderr=subprocess.STDOUT, timeout=120)
 record={'name':name,'command':cmd,'exit':result.returncode,'seconds':round(time.monotonic()-start,3)}
 with (out/'commands.jsonl').open('a') as log: log.write(json.dumps(record)+'\n')
 print(json.dumps(record), flush=True)
 failed |= result.returncode != 0
raise SystemExit(int(failed))
