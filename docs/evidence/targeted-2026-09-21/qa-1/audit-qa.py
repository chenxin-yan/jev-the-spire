import json
from collections import Counter
from pathlib import Path

base = Path(__file__).parent
rows = [json.loads(line) for line in (base / 'journal.jsonl').read_text().splitlines()]
epoch = '162f86c6714243b59889a77c368f733a'
observations, decisions, dispatches = {}, {}, {}
for row in rows:
    assert row['actor'] == 'parent_targeted_qa'
    kind = row['type']
    assert kind in {'observation', 'qa_decision', 'dispatch', 'expected_rejection'}
    if kind == 'observation':
        snapshot = row['snapshot']
        assert snapshot['state_version'].startswith(epoch + ':')
        observations[snapshot['state_version']] = snapshot
    elif kind == 'qa_decision':
        version = row['state_version']
        assert version not in decisions
        snapshot = observations[version]
        assert snapshot['legal_actions_complete'] and not snapshot.get('halt_reason')
        assert snapshot['legal_actions'] == row['legal_actions']
        assert row['label'] in {a['label'] for a in snapshot['legal_actions']}
        decisions[version] = row['label']
    elif kind == 'dispatch':
        version = row['state_version']
        assert version not in dispatches
        assert decisions[version] == row['label'] and row['status'] == 202
        assert row['body']['state_version'] == version and row['body']['label'] == row['label']
        dispatches[version] = row['label']
    else:
        assert row['status'] == (422 if row['label'] == 'qa_nonexistent_action' else 409)
        assert row['label'] == 'qa_nonexistent_action' or row['state_version'] == 'qa_stale_version'
assert decisions == dispatches
assert len(dispatches) == 104
assert f'{epoch}:296' not in dispatches
assert dispatches[f'{epoch}:297'] == 'proceed'
a, b = [observations[f'{epoch}:{n}'] for n in (296, 297)]
assert a['legal_actions_complete'] and b['legal_actions_complete']
assert [x['label'] for x in a['legal_actions']] == ['claim_treasure_relic:0']
assert {x['label'] for x in b['legal_actions']} == {'claim_treasure_relic:0', 'proceed'}
assert a['player'] == b['player'] and a['mutation_pending'] and b['mutation_pending']
final = observations[f'{epoch}:298']
assert final['halt_reason'] == 'treasure_proceed_identity_unverified'
assert final['mutation_pending'] and not final['legal_actions_complete'] and not final['legal_actions']
assert rows[-1]['type'] == 'observation' and rows[-1]['snapshot'] == final
assert len([r for r in rows if r['type'] == 'expected_rejection']) == 3
accounting = {
    'actor': 'parent_targeted_qa',
    'classification': 'technical_stop_not_terminal_game_result',
    'seed': '5Q4V83QRSFPV',
    'epoch': epoch,
    'accepted_dispatches': len(dispatches),
    'unique_accepted_versions': len(set(dispatches)),
    'model_calls': 0,
    'expected_rejections': {'unknown_label_422': 2, 'stale_version_409': 1},
    'halt_reason': final['halt_reason'],
    'final_state_version': final['state_version'],
    'action_counts': dict(sorted(Counter(label.split(':')[0] for label in dispatches.values()).items())),
    'notes': [
        'Three rejected requests include the first scratch test with an incorrect expected409 for unknown label; corrected to native422, then passed.',
        'Stale local296claim was refused beforePOST; no accepted version was retried.',
        'Chest296claim-only complete catalog later addedSkip at297 without dispatch; separate readiness defect.',
        'Final legal Skip accepted202 thenownershiphalt; native map screenshot does not prove bridge completion.',
        'Smith and equivalent combat-pile/potion resume checks are separate passing assertions; shared event not encountered.'
    ]
}
(base / 'accounting.json').write_text(json.dumps(accounting, indent=2) + '\n')
print('PASS: 104 exact legal QA decisions/202 dispatches, unique versions, three negative requests, and preserved treasure technical stop; zero model calls')
