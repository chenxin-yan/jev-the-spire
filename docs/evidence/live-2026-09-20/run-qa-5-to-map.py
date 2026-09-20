import json, os, pathlib, signal, subprocess, threading, time
out = pathlib.Path(__file__).parent
cmd = ['mise', 'exec', '--', 'bun', 'run', 'src/main.ts', '--max-actions', '20', '--log', str(out/'qa-5.jsonl')]
start = time.monotonic()
p = subprocess.Popen(cmd, stdout=subprocess.PIPE, text=True, bufsize=1, start_new_session=True)
def stop(sig):
    try: os.killpg(p.pid, sig)
    except ProcessLookupError: pass
soft = threading.Timer(295, stop, [signal.SIGINT])
hard = threading.Timer(300, stop, [signal.SIGKILL])
soft.start()
hard.start()
stopped_at_map = False
try:
    for line in p.stdout:
        if not stopped_at_map and line.startswith('observed: map '):
            stopped_at_map = True
            stop(signal.SIGINT)
            print('PARENT STOP: SIGINT at post-reward map observation', flush=True)
        print(line, end='', flush=True)
    code = p.wait()
finally:
    soft.cancel()
    hard.cancel()
record = {'command':cmd, 'exit':code, 'sigint_at_map_observation':stopped_at_map, 'seconds':round(time.monotonic()-start, 3)}
(out/'qa-5-control.json').write_text(json.dumps(record, indent=2)+'\n')
print(json.dumps(record), flush=True)
raise SystemExit(code)
