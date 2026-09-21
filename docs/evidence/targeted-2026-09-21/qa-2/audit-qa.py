import json
from pathlib import Path

base = Path(__file__).parent
rows = [json.loads(line) for line in (base/'journal.jsonl').read_text().splitlines()]
obs, decisions, dispatched = {}, {}, {}
for r in rows:
    assert r['actor'] == 'parent_targeted_qa'
    assert r['type'] in ('observation', 'qa_decision', 'dispatch')
    if r['type'] == 'observation':
        s = r['snapshot']
        assert not s.get('halt_reason')
        obs[s['state_version']] = s
    elif r['type'] == 'qa_decision':
        v = r['state_version']; s = obs[v]
        assert v not in decisions and s['legal_actions_complete']
        assert s['legal_actions'] == r['legal_actions'] and r['label'] in {a['label'] for a in s['legal_actions']}
        decisions[v] = r['label']
    else:
        v = r['state_version']
        assert v not in dispatched and decisions[v] == r['label'] and r['status'] == 202
        assert r['body']['state_version'] == v and r['body']['label'] == r['label']
        dispatched[v] = r['label']
assert decisions == dispatched and len(dispatched) == 66
final = json.loads((base/'final-readback.json').read_text())
assert final == rows[-1]['snapshot']
assert final['state_version'] == '3eb22b954a2240068ca10044f0baab0d:202'
assert final['state_type'] == 'rest_site' and final['legal_actions_complete'] and not final['mutation_pending'] and not final['terminal']
accounting = {'actor':'parent_targeted_qa','seed':'Z9HGUUZA1DXW','epoch':'3eb22b954a2240068ca10044f0baab0d','accepted_dispatches':66,'unique_accepted_versions':66,'model_calls':0,'bridge_halts':0,'final_state_version':final['state_version'],'classification':'bounded_qa_passed_then_deliberately_ended','coverage':['native shared DenseVegetation choice and continuation','complete treasure catalog after readiness wait','native Skip without relic acquisition','subsequent map travel/room exit'],'note':'Native Save and Quit/Abandon after the ready checkpoint are setup actions for the final fresh-chest claim regression, not natural defeat or bridge failure.'}
(base/'accounting.json').write_text(json.dumps(accounting,indent=2)+'\n')
print('PASS: 66 exact legal QA decisions and202s, unique versions, no bridge halt, zero model calls; stopped at ready rest site')
