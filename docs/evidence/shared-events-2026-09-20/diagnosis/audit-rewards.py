import json
from pathlib import Path

root = Path(__file__).parent
rows = [json.loads(line) for line in (root.parent / 'user' / 'run-2026-09-20T21-39-37-380Z.jsonl').read_text().splitlines()]
decisions = [row for row in rows if row['type'] == 'decision']
rewards = []
for i, decision in enumerate(decisions):
    if decision['state_type'] != 'rewards':
        continue
    dispatches = [row for row in rows if row['type'] == 'dispatch' and row['state_version'] == decision['state_version']]
    assert len(dispatches) == 1
    dispatch = dispatches[0]
    assert dispatch['label'] == decision['label'] == 'proceed'
    assert dispatch['http_status'] == 202
    assert dispatch['body']['label'] == decision['label']
    assert decision['source'] == 'model'
    assert decisions[i + 1]['state_type'] == 'map'
    assert len(decision['legal_actions']) > 1
    rewards.append({'floor': decision['run']['floor'], 'state_version': decision['state_version'],
                    'offered': [action['description'] for action in decision['legal_actions'] if action['label'].startswith('claim_reward:')],
                    'selected': decision['label'], 'source': decision['source'], 'probabilities': decision['probabilities'],
                    'dispatch_status': dispatch['http_status'], 'next_decision': 'map'})
assert len(rewards) == 2
assert not any(row['label'].startswith('claim_reward:') for row in decisions)
summary = next(row for row in rows if row['type'] == 'summary')
assert summary['dispatched'] == len([row for row in rows if row['type'] == 'dispatch' and row.get('http_status') == 202]) == 33
assert summary['halt_reason'] == 'shared_event_unverified'
result = {'reward_decisions': rewards, 'reward_claim_dispatches': 0, 'summary': summary,
          'limitation': 'Decision logs omit full player snapshots. Native Proceed semantics establish skipped claims; historical inventory deltas and model reasoning are not recorded.'}
(root / 'reward-audit.json').write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps(result, indent=2))
