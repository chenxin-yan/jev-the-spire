import json
from pathlib import Path

base = Path(__file__).parent
rows = [json.loads(line) for line in (base/'journal.jsonl').read_text().splitlines(keepends=True) if line.endswith('\n')]
obs = {r['snapshot']['state_version']: r['snapshot'] for r in rows if r['type'] == 'observation'}
epoch = '3eb22b954a2240068ca10044f0baab0d'
a, b, c = [obs[f'{epoch}:{n}'] for n in (55, 58, 61)]
assert 'ldc.i4.1' in (base/'dense-vegetation-shared.il').read_text()
assert a['event']['event_id'] == b['event']['event_id'] == 'DENSE_VEGETATION'
assert len(a['legal_actions']) == 2 and len(b['legal_actions']) == 1
assert b['legal_actions'][0]['description'].startswith('Proceed')
assert b['player']['gold'] == a['player']['gold'] + 96
assert b['player']['hp'] == a['player']['hp'] - 8
assert c['state_type'] == 'map'
for s in (a, b, c):
    assert s['legal_actions_complete'] and not s['mutation_pending'] and not s.get('halt_reason')
for n in (55, 58):
    ds = [r for r in rows if r['type'] == 'dispatch' and r['state_version'] == f'{epoch}:{n}']
    assert len(ds) == 1 and ds[0]['status'] == 202 and ds[0]['label'] == 'choose_event_option:0'
print('PASS: native shared Dense Vegetation choice completes with exact gold/HP effects, ready Proceed and map continuation; one202 per action, no bridge halt')
