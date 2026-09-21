import json
from pathlib import Path

base = Path(__file__).parent
rows = [json.loads(line) for line in (base/'journal.jsonl').read_text().splitlines()]
obs, decisions, dispatched = {}, {}, {}
for r in rows:
    assert r['actor'] == 'parent_targeted_qa'
    assert r['type'] in ('observation','qa_decision','dispatch')
    if r['type'] == 'observation':
        s = r['snapshot']; assert not s.get('halt_reason'); obs[s['state_version']] = s
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
assert decisions == dispatched and len(dispatched) == 47
final = json.loads((base/'final-readback.json').read_text())
assert final == rows[-1]['snapshot']
assert final['state_version'] == '8703e7be650542d2820a473a9fb7e792:140'
assert final['state_type'] == 'map' and final['legal_actions_complete'] and not final['mutation_pending'] and not final['terminal']
accounting = {'actor':'parent_targeted_qa','seed':'BBK5PF16S0X4','epoch':'8703e7be650542d2820a473a9fb7e792','accepted_dispatches':47,'unique_accepted_versions':47,'model_calls':0,'bridge_halts':0,'final_state_version':final['state_version'],'classification':'bounded_qa_passed_stopped_at_ready_map','coverage':['complete treasure catalog after readiness wait','explicit HappyFlower claim and ready map','SapphireSeed upgrade selection/confirmation','Rest with native StoneHumidifier effect'],'note':'A local stale136Proceed attempt was refused beforePOST; fresh137still offered onlyProceed and was dispatched once. Snapshot136→137 removed the empty treasure.relics field without changing the complete legal set. No uncertain accepted mutation was retried. No further gameplay after final ready map.'}
(base/'accounting.json').write_text(json.dumps(accounting,indent=2)+'\n')
print('PASS: 47 exact legal QA decisions and202s, unique versions, no bridge halt, zero model calls; stopped at ready map')
