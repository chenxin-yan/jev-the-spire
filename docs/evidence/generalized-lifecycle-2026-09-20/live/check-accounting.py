"""Offline checks for this capture; no game requests, inference or native certification."""
import datetime
import json
import math
from pathlib import Path

root = Path(__file__).parent
summaries = []
all_decisions = []
failed_calls = []
for index in range(1, 6):
    rows = [json.loads(line) for line in (root / f'trial-{index}.jsonl').read_text().splitlines()]
    summary = rows[-1]
    decisions = [row for row in rows if row['type'] == 'decision']
    dispatches = [row for row in rows if row['type'] == 'dispatch']
    inferences = [row for row in rows if row['type'] == 'inference']
    successful = [row for row in inferences if row['ok']]
    assert summary['type'] == 'summary' and summary['seed'] == '77SVP3CVQFHQ'
    assert summary['outcome'] == ('terminal' if index == 5 else 'max_actions')
    assert len(decisions) == len(dispatches) == summary['dispatched']
    assert len(inferences) == summary['model_calls']
    assert len(successful) == sum(row['source'] == 'model' for row in decisions)
    assert sum(row['source'] == 'singleton_only' for row in decisions) == summary['forced']
    assert summary['wall_ms'] < 300000
    assert not any(row['type'] in ('stale', 'error') for row in rows)
    assert all(row['action_count'] == 0 for row in rows if row['type'] == 'wait')
    for position, inference in enumerate(inferences):
        if inference['ok']:
            assert inference['model_id'] == 'typesafe-ai/jev'
        else:
            assert inference['attempt'] == 1 and 'probabilities that do not sum to 1' in inference['error']
            retry = inferences[position + 1]
            assert retry['ok'] and retry['attempt'] == 2 and retry['state_version'] == inference['state_version']
            assert 'usage' not in inference
            failed_calls.append(inference)
    for decision, dispatch in zip(decisions, dispatches):
        labels = {action['label'] for action in decision['legal_actions']}
        assert decision['label'] in labels
        assert dispatch['http_status'] == 202 and dispatch['body']['status'] == 'dispatched' and not dispatch.get('uncertain')
        assert (decision['label'], decision['state_version']) == (dispatch['label'], dispatch['state_version'])
        if decision['source'] == 'singleton_only':
            assert len(labels) == 1 and decision['probabilities'] is None and decision['model_id'] is None
        else:
            probabilities = decision['probabilities']
            assert decision['source'] == 'model' and decision['model_id'] == 'typesafe-ai/jev'
            assert len(labels) > 1 and set(probabilities) == labels
            assert all(math.isfinite(value) and 0 <= value <= 1 for value in probabilities.values())
            assert abs(sum(probabilities.values()) - 1) <= 0.001
        assert decision['state_type'] != 'rest_site'
    for key, field in [('input_tokens', 'inputTokens'), ('output_tokens', 'outputTokens')]:
        assert summary[key] == sum(row['usage'][field] for row in successful)
    all_decisions.extend(decisions)
    summaries.append(summary)

assert len(failed_calls) == 2
assert len({row['state_version'] for row in all_decisions}) == len(all_decisions)
assert all_decisions[1]['state_type'] == 'card_select' and all_decisions[1]['label'] == 'cancel_selection'
assert all_decisions[-1]['run'] == {'act': 1, 'floor': 7, 'ascension': 0}
assert all_decisions[-1]['label'] == 'end_turn'
final = json.loads((root / 'final-readback.json').read_text())
assert final['state_type'] == 'game_over' and final['terminal'] and not final['mutation_pending']
assert final['legal_actions_complete'] and final['legal_actions'] == [] and final['seed'] == '77SVP3CVQFHQ'
assert 'Inadequately prepared.' in final['visible_text']
totals = {key: sum(row[key] for row in summaries) for key in ('dispatched', 'model_calls', 'forced', 'input_tokens', 'output_tokens')}
assert totals == {'dispatched': 81, 'model_calls': 61, 'forced': 22, 'input_tokens': 168382, 'output_tokens': 5005}
start = json.loads((root / 'trial-start.json').read_text())
assert totals['dispatched'] <= start['max_actions']
assert datetime.datetime.fromisoformat(summaries[-1]['ts']) < datetime.datetime.fromisoformat(start['deadline_utc'])
print(json.dumps({'totals': totals, 'failed_calls_without_usage': len(failed_calls), 'summaries': summaries}, indent=2))
