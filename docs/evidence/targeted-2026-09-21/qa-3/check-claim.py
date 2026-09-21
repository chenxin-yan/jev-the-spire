import json
from pathlib import Path

base = Path(__file__).parent
rows = [json.loads(line) for line in (base/'journal.jsonl').read_text().splitlines()]
obs = {r['snapshot']['state_version']:r['snapshot'] for r in rows if r['type'] == 'observation'}
epoch = '8703e7be650542d2820a473a9fb7e792'
s = lambda n: obs[f'{epoch}:{n}']
assert s(134)['state_type'] == 'waiting' and not s(134)['legal_actions_complete'] and not s(134)['legal_actions']
assert s(135)['legal_actions_complete'] and s(135)['mutation_pending']
assert {a['label'] for a in s(135)['legal_actions']} == {'claim_treasure_relic:0','proceed'}
before, after = s(135)['player'], s(137)['player']
assert [r['id'] for r in after['relics']] == [r['id'] for r in before['relics']] + ['HAPPY_FLOWER']
for key in ('hp','max_hp','gold','deck','potions'):
    assert before[key] == after[key]
assert s(136)['legal_actions'] == s(137)['legal_actions']
assert [a['label'] for a in s(137)['legal_actions']] == ['proceed']
assert s(140)['state_type'] == 'map' and s(140)['legal_actions_complete'] and not s(140)['mutation_pending']
assert s(140)['player'] == after
for x in obs.values():
    assert not x.get('halt_reason')
    if x['state_type'] == 'treasure' and any(a['label'].startswith('claim_treasure') for a in x['legal_actions']):
        assert x['legal_actions_complete'] and any(a['label'] == 'proceed' for a in x['legal_actions'])
for n, label in ((133,'open_treasure'), (135,'claim_treasure_relic:0'), (137,'proceed')):
    ds = [r for r in rows if r['type'] == 'dispatch' and r['state_version'] == f'{epoch}:{n}']
    assert len(ds) == 1 and ds[0]['status'] == 202 and ds[0]['label'] == label
assert not any(r['type'] == 'dispatch' and r['state_version'] == f'{epoch}:136' for r in rows)
print('PASS: complete Take/Skip catalog after waiting; explicit legal claim obtains exactly Happy Flower; Proceed reaches ready map; stale136 locally refused beforePOST, no bridge halt')
