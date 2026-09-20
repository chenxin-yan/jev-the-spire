"""Offline capture check; no game requests or inference."""
import json
from pathlib import Path

root = Path(__file__).parent
summaries = []
for index in (1, 2):
    rows = [json.loads(line) for line in (root / f'trial-{index}.jsonl').read_text().splitlines()]
    summary = rows[-1]
    assert summary['type'] == 'summary'
    decisions = [row for row in rows if row['type'] == 'decision']
    dispatches = [row for row in rows if row['type'] == 'dispatch']
    inferences = [row for row in rows if row['type'] == 'inference']
    assert len(decisions) == len(dispatches) == summary['dispatched']
    assert len(inferences) == summary['model_calls']
    assert all(row['ok'] and row['attempt'] == 1 for row in inferences)
    for decision, dispatch in zip(decisions, dispatches):
        labels = {action['label'] for action in decision['legal_actions']}
        assert decision['label'] in labels
        assert dispatch['http_status'] == 202 and dispatch['body']['status'] == 'dispatched'
        assert (decision['label'], decision['state_version']) == (dispatch['label'], dispatch['state_version'])
        if decision['source'] == 'singleton_only':
            assert len(labels) == 1 and decision['probabilities'] is None and decision['model_id'] is None
        else:
            assert decision['source'] == 'model' and decision['model_id'] == 'typesafe-ai/jev'
            probabilities = decision['probabilities']
            assert len(labels) > 1 and set(probabilities) == labels
            assert all(0 <= value <= 1 for value in probabilities.values())
            assert abs(sum(probabilities.values()) - 1) <= 0.001
        assert decision['state_type'] != 'rest_site'
    assert sum(row['source'] == 'singleton_only' for row in decisions) == summary['forced']
    assert summary['wall_ms'] < 300000
    for key, field in [('input_tokens', 'inputTokens'), ('output_tokens', 'outputTokens')]:
        assert summary[key] == sum(row['usage'][field] for row in inferences)
    assert summary['outcome'] == ('max_actions' if index == 1 else 'halted')
    summaries.append(summary)
assert summaries[-1]['halt_reason'] == 'unowned_selection_continuation'
assert decisions[-1]['label'] == 'choose_event_option:0'
final = json.loads((root / 'final-readback.json').read_text())
assert final['halt_reason'] == 'unowned_selection_continuation' and final['legal_actions'] == []
assert final['mutation_pending'] and not final['terminal'] and not final['legal_actions_complete']
totals = {key: sum(row[key] for row in summaries) for key in ('dispatched', 'model_calls', 'forced', 'input_tokens', 'output_tokens')}
assert totals['dispatched'] == 17
print(json.dumps({'totals': totals, 'summaries': summaries}, indent=2))
