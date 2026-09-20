import json, pathlib, signal, subprocess, os, time
out=pathlib.Path(__file__).parent
cmd=['mise','exec','--','bun','run',str(out/'provider-smoke.ts')]
start=time.monotonic()
p=subprocess.Popen(cmd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,start_new_session=True)
try:
 stdout,stderr=p.communicate(timeout=90)
 result=next((json.loads(line) for line in reversed(stdout.decode('utf8',errors='replace').splitlines()) if line.startswith('{"ok":')),None)
 record={'command':cmd,'exit':p.returncode,'external_timeout':False,'seconds':round(time.monotonic()-start,3),'result':result,'stderr_bytes_omitted':len(stderr)}
except subprocess.TimeoutExpired:
 os.killpg(p.pid,signal.SIGKILL)
 p.communicate()
 record={'command':cmd,'exit':p.returncode,'external_timeout':True,'seconds':round(time.monotonic()-start,3)}
(out/'provider-smoke.json').write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps(record),flush=True)
raise SystemExit(0 if record.get('result',{}).get('ok') else 1)
