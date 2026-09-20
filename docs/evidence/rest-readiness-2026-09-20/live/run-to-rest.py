# One supervised CLI segment; stops before the first ready rest-site decision.
import datetime, json, os, pathlib, signal, subprocess, sys, threading, time

out = pathlib.Path(__file__).parent
name, bound = sys.argv[1], int(sys.argv[2])
assert 1 <= bound <= 30
start_file = out / 'trial-start.json'
if not start_file.exists():
    now = datetime.datetime.now(datetime.timezone.utc)
    start_file.write_text(json.dumps({'start_utc': now.isoformat(), 'deadline_utc': (now + datetime.timedelta(minutes=20)).isoformat(), 'max_actions': 150}, indent=2) + '\n')
start = json.loads(start_file.read_text())
remaining_seconds = (datetime.datetime.fromisoformat(start['deadline_utc']) - datetime.datetime.now(datetime.timezone.utc)).total_seconds()
assert remaining_seconds > 0
accepted = 0
for path in out.glob('trial-*.jsonl'):
    rows = [json.loads(line) for line in path.read_text().splitlines()]
    assert rows[-1]['type'] == 'summary' and rows[-1]['outcome'] == 'max_actions', 'No automatic restart after a stop'
    accepted += rows[-1]['dispatched']
assert accepted + bound <= 150
log_path = out / (name + '.jsonl')
assert not log_path.exists()
cmd = ['mise', 'exec', '--', 'bun', 'run', 'src/main.ts', '--max-actions', str(bound), '--log', str(log_path)]
p = subprocess.Popen(cmd, stdout=subprocess.PIPE, text=True, bufsize=1, start_new_session=True)
def stop(sig):
    try: os.killpg(p.pid, sig)
    except ProcessLookupError: pass
soft = threading.Timer(min(295, remaining_seconds), stop, [signal.SIGINT])
hard = threading.Timer(min(300, remaining_seconds + 2), stop, [signal.SIGKILL])
soft.start()
hard.start()
stopped = False
try:
    with (out / (name + '-stdout.txt')).open('w') as console:
        for line in p.stdout:
            if not stopped and line.startswith('observed: rest_site '):
                stopped = True
                stop(signal.SIGINT)
                print('PARENT STOP: SIGINT before ready rest-site decision', flush=True)
            console.write(line)
            console.flush()
            print(line, end='', flush=True)
    code = p.wait()
finally:
    soft.cancel()
    hard.cancel()
(out / (name + '-control.json')).write_text(json.dumps({'command': cmd, 'exit': code, 'sigint_at_rest_entry': stopped}, indent=2) + '\n')
raise SystemExit(code)
