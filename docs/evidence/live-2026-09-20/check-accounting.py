"""Offline consistency checks for this capture, not native completion certification."""
import json
import math
from pathlib import Path

root = Path(__file__).parent
all_totals = {}
for phase, count in (("qa", 5), ("full", 3)):
    totals = dict(dispatched=0, model_calls=0, forced=0, input_tokens=0, output_tokens=0)
    for index in range(1, count + 1):
        rows = [json.loads(line) for line in (root / f"{phase}-{index}.jsonl").read_text().splitlines()]
        summary = rows[-1]
        assert summary["type"] == "summary"
        decisions = [row for row in rows if row["type"] == "decision"]
        dispatches = [row for row in rows if row["type"] == "dispatch"]
        inferences = [row for row in rows if row["type"] == "inference"]
        assert len(decisions) == len(dispatches) == summary["dispatched"]
        assert len(inferences) == summary["model_calls"]
        assert all(row["ok"] and row["attempt"] == 1 for row in inferences)
        assert not any(row["type"] in ("stale", "error", "invalid_answer") for row in rows)
        for decision, dispatch in zip(decisions, dispatches):
            labels = {action["label"] for action in decision["legal_actions"]}
            assert decision["label"] in labels
            assert dispatch["http_status"] == 202 and dispatch["body"]["status"] == "dispatched"
            assert (decision["state_version"], decision["label"]) == (dispatch["state_version"], dispatch["label"])
            if decision["source"] == "singleton_only":
                assert len(labels) == 1 and decision["probabilities"] is None and decision["model_id"] is None
            else:
                assert decision["source"] == "model" and decision["model_id"] == "typesafe-ai/jev"
                probabilities = decision["probabilities"]
                assert len(labels) > 1 and set(probabilities) == labels
                assert all(math.isfinite(value) and 0 <= value <= 1 for value in probabilities.values())
                assert abs(sum(probabilities.values()) - 1) <= 0.001
        assert sum(row["source"] == "singleton_only" for row in decisions) == summary["forced"]
        assert summary["wall_ms"] < 300000
        for name, usage_key in (("input_tokens", "inputTokens"), ("output_tokens", "outputTokens")):
            assert summary[name] == sum(row["usage"][usage_key] for row in inferences)
        expected = "aborted" if phase == "qa" and index == 5 else "halted" if phase == "full" and index == 3 else "max_actions"
        assert summary["outcome"] == expected
        if expected == "halted":
            assert summary["halt_reason"] == "ordinary_mouse_input_unverified"
            assert decisions[-1]["label"] == "choose_map_node:1"
            assert not any(row["state_type"] == "rest_site" for row in decisions)
        for key in totals:
            totals[key] += summary[key]
    all_totals[phase] = totals
final = json.loads((root / "full-final-readback.json").read_text())
assert final["seed"] == "0RBY5896E908" and final["run"] == {"act": 1, "floor": 7, "ascension": 0}
assert final["state_type"] == "rest_site" and final["player"]["hp"] == 32
assert not final["terminal"] and not final["waiting"] and not final["mutation_pending"]
assert final["legal_actions_complete"] and len(final["legal_actions"]) == 2
print(json.dumps(all_totals, indent=2))
