import json
from pathlib import Path
rows=[json.loads(l) for l in (Path(__file__).parent/'journal.jsonl').read_text().splitlines()]
obs={r['snapshot']['state_version']:r['snapshot'] for r in rows if r['type']=='observation'}
def s(n):return obs[f'162f86c6714243b59889a77c368f733a:{n}']
assert s(218)['player']['deck']==s(222)['player']['deck']
assert s(218)['player']['hp']==s(222)['player']['hp']
assert s(218)['legal_actions']==s(222)['legal_actions']
for n in [219,223,225]:
 assert s(n)['state_type']=='card_select' and s(n)['legal_actions_complete'] and s(n)['mutation_pending']
 assert len(s(n)['card_select']['cards'])==10
 assert len([a for a in s(n)['legal_actions'] if a['label'].startswith('select_card:')])==10
for n in [224,226]:
 assert s(n)['card_select']['preview_showing'] and s(n)['mutation_pending']
 assert {a['label'] for a in s(n)['legal_actions']}=={'confirm_selection:1','cancel_selection:2'}
 assert not any(c['is_upgraded'] for c in s(n)['player']['deck'])
assert len(s(229)['player']['deck'])==10
assert [c['id'] for c in s(229)['player']['deck'] if c['is_upgraded']]==['BASH']
for n in [222,229,232]:assert not s(n)['mutation_pending'] and not s(n).get('halt_reason') and s(n)['legal_actions_complete']
assert s(229)['state_type']=='rest_site' and [a['label'] for a in s(229)['legal_actions']]==['proceed']
assert s(232)['state_type']=='map'
print('PASS: Smith cancel, full candidate set, preview cancel, exact single upgrade, post-select readiness and map return')
