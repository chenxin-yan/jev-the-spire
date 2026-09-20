import json
from pathlib import Path
p=Path(__file__).parent
s=json.loads((p/'readback.json').read_text())
assert s['state_type']=='unsupported' and s['halt_reason']=='unowned_selection_continuation'
assert s['state_version']=='c2a3073294f1400c8e2b7e8d92e35e5b:25'
assert not s['legal_actions'] and s['mutation_pending']
print('Confirmed exact Headbutt continuation halt; bridge must retain ownership of this native owned selection.')
assert s['halt_reason']!='unowned_selection_continuation', 'RED: accepted Headbutt play yielded unowned_selection_continuation'
