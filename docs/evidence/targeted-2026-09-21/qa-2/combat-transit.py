# Bounded, operator-selected QA transit; stop at any selector/noncombat surface or Headbutt opportunity.
import json,subprocess,sys
from pathlib import Path
root=Path(__file__).parent

def choose(actions):
 return next((a for a in actions if a['label'].startswith('play_card:') and any(f'] {name}' in a['description'] for name in ('Strike','Bash'))),next((a for a in actions if a['label'].startswith('play_card:')),next((a for a in actions if a['label']=='end_turn'),None)))
assert choose([{'label':'end_turn','description':'End turn'}])['label']=='end_turn'
assert choose([{'label':'play_card:0:none','description':'Play hand[0] Defend'},{'label':'play_card:1:1','description':'Play hand[1] Strike targeting X'}])['label']=='play_card:1:1'
assert choose([]) is None
for i in range(60):
 s=json.loads((root/'latest.json').read_text())
 if s['state_type'] not in ('monster','elite','boss') or any('Headbutt' in a['description'] for a in s['legal_actions']):
  print('QA CHECKPOINT',s['state_type'],s['state_version'],flush=True);break
 a=choose(s['legal_actions']);assert a is not None
 print('QA transit',i+1,s['state_version'],a['description'],flush=True)
 result=subprocess.run(['mise','exec','--','bun','--no-env-file',str(root/'step.ts'),s['state_version'],a['label']],capture_output=True,text=True)
 if result.returncode:
  print(result.stdout,result.stderr);sys.exit(result.returncode)
else:
 print('QA action bound reached; stopped',flush=True)
