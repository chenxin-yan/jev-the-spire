import json
from pathlib import Path

# Recorded-state sentinel, not an engine replay; the original failed snapshot stays unchanged.
s = json.loads((Path(__file__).parent / 'latest.json').read_text())
assert not s.get('halt_reason'), f"bridge correctness failure at {s['state_version']}: {s['halt_reason']}"
assert not s['mutation_pending'] and s['legal_actions_complete']
print('PASS: ready continuation without a bridge halt')
