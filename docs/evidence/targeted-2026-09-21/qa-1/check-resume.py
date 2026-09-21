import json
from pathlib import Path
rows=[json.loads(l) for l in (Path(__file__).parent/'journal.jsonl').read_text().splitlines()]
obs={r['snapshot']['state_version']:r['snapshot'] for r in rows if r['type']=='observation'}
epoch='162f86c6714243b59889a77c368f733a'
def state(n):return obs[f'{epoch}:{n}']
for before,selected,after,screen in [(78,80,83,'choose'),(83,85,88,'combat_pile')]:
 a,b,c=state(before),state(selected),state(after)
 assert a['state_type']==c['state_type']=='monster' and not a['mutation_pending'] and not c['mutation_pending']
 assert b['state_type']=='card_select' and b['card_select']['screen_type']==screen and b['mutation_pending']
 assert all(s['legal_actions_complete'] and not s.get('halt_reason') for s in [a,b,c])
 assert len(b['card_select']['cards'])==3
 for n in [before,selected]:
  ds=[r for r in rows if r['type']=='dispatch' and r['state_version']==f'{epoch}:{n}'];assert len(ds)==1 and ds[0]['status']==202
assert len(state(78)['player']['potions'])==1 and state(83)['player']['potions']==[]
assert state(83)['player']['hand'][-1]['id']=='SEEKER_STRIKE'
assert state(85)['battle']['enemies'][0]['hp']==state(83)['battle']['enemies'][0]['hp']-9
assert state(88)['player']['draw_pile_count']==state(83)['player']['draw_pile_count']-1
assert state(88)['player']['hand'][-1]['id']=='STRIKE_IRONCLAD'
assert len(state(88)['player']['deck'])==len(state(78)['player']['deck'])==10
print('PASS: native potion and combat-pile card selections resume to ready combat with exact effects and one accepted dispatch per version')
