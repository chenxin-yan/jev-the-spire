import collections, json, sys
from pathlib import Path
root=Path(__file__).parent
number=int(sys.argv[1])
root=root/f'run-{number}'
rows=[json.loads(line) for line in (root/f'run-{number}.jsonl').read_text().splitlines()]
summaries=[r for r in rows if r['type']=='summary']
assert len(summaries)==1
summary=summaries[0]
decisions=[r for r in rows if r['type']=='decision']
dispatches=[r for r in rows if r['type']=='dispatch']
inferences=[r for r in rows if r['type']=='inference']
assert len(dispatches)==summary['dispatched']==len(decisions)
assert len(inferences)==summary['model_calls']
assert all(r['http_status']==202 for r in dispatches)
assert [(r['state_version'],r['label']) for r in decisions]==[(r['state_version'],r['label']) for r in dispatches]
assert len({r['state_version'] for r in dispatches})==len(dispatches)
assert sum(r['source']=='singleton_only' for r in decisions)==summary['forced']
assert sum(r['ok'] for r in inferences)==sum(r['source']=='model' for r in decisions)
result={'summary':summary,'all_dispatches_accepted_once':True,'decision_sources':dict(collections.Counter(r['source'] for r in decisions)),'decision_states':dict(collections.Counter(r.get('state_type') for r in decisions)),'action_families':dict(collections.Counter(r['label'].split(':')[0] for r in decisions)),'failed_inferences':[r for r in inferences if not r['ok']]}
(root/f'run-{number}-audit.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
