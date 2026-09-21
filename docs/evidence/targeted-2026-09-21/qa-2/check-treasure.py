import json
from pathlib import Path

base = Path(__file__).parent
rows = [json.loads(line) for line in (base/'journal.jsonl').read_text().splitlines()]
obs = {r['snapshot']['state_version']: r['snapshot'] for r in rows if r['type'] == 'observation'}
epoch = '3eb22b954a2240068ca10044f0baab0d'
s = lambda n: obs[f'{epoch}:{n}']
assert s(194)['state_type'] == 'waiting' and not s(194)['legal_actions_complete'] and not s(194)['legal_actions']
assert s(194)['mutation_pending']
assert s(195)['state_type'] == 'treasure' and s(195)['legal_actions_complete'] and s(195)['mutation_pending']
assert {a['label'] for a in s(195)['legal_actions']} == {'claim_treasure_relic:0', 'proceed'}
for x in obs.values():
    if x['state_type'] == 'treasure' and any(a['label'].startswith('claim_treasure') for a in x['legal_actions']):
        assert x['legal_actions_complete'] and any(a['label'] == 'proceed' for a in x['legal_actions'])
assert s(195)['player'] == s(198)['player']
assert not any(r['id'] == 'STRIKE_DUMMY' for r in s(198)['player']['relics'])
assert s(198)['state_type'] == 'map' and s(202)['state_type'] == 'rest_site'
for n in (198, 202):
    assert s(n)['legal_actions_complete'] and not s(n)['mutation_pending'] and not s(n).get('halt_reason')
for n, label in ((193,'open_treasure'), (195,'proceed'), (198,'choose_map_node:0')):
    ds = [r for r in rows if r['type'] == 'dispatch' and r['state_version'] == f'{epoch}:{n}']
    assert len(ds) == 1 and ds[0]['status'] == 202 and ds[0]['label'] == label
assert not any(x.get('halt_reason') for x in obs.values())
print('PASS: chest withholds incomplete choices; first complete offer includes Take and Skip; Skip returns to ready map without acquiring relic; next room travel completes without bridge halt')
