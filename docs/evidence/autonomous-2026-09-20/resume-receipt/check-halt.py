import json
from pathlib import Path
s=json.loads((Path(__file__).parent/'readback.json').read_text())
assert s['halt_reason']=='duplicate_or_late_execution_receipt' and s['state_type']=='unsupported'
assert not s['legal_actions']
print('Confirmed exact post-Headbutt-selection halt:',s['state_version'],flush=True)
assert s['halt_reason']!='duplicate_or_late_execution_receipt','RED: an accepted owned Headbutt selection must not be mistaken for a duplicate execution receipt'
