import json, sys, urllib.request, urllib.error
from pathlib import Path
root=Path('/tmp/jev-m2-live-recheck'); name,label=sys.argv[1:]
url='http://127.0.0.1:15526/api/v1/singleplayer'
assert not (root/(name+'.request.json')).exists(), 'Never retry a named action'
def request(suffix,data=None):
    req=urllib.request.Request(url,data=data,headers={} if data is None else {'Content-Type':'application/json'})
    try: response=urllib.request.urlopen(req,timeout=10)
    except urllib.error.HTTPError as e: response=e
    body=response.read(); (root/(name+suffix+'.json')).write_bytes(body)
    (root/(name+suffix+'.headers')).write_text(str(response.status)+'\n'+str(response.headers))
    return response.status,json.loads(body)
status,before=request('-before')
assert status==200 and before['legal_actions_complete'] and not before.get('waiting') and not before.get('halt_reason')
assert label in [a['label'] for a in before['legal_actions']]
data=json.dumps({'state_version':before['state_version'],'label':label}).encode()
with (root/(name+'.request.json')).open('xb') as f: f.write(data)
status,result=request('',data)
print('POST',status,result)
status,after=request('-immediate')
print('GET',status,json.dumps({k:v for k,v in after.items() if k!='player'},indent=2))
if 'player' in after: print('player', {k:after['player'].get(k) for k in ['hp','energy','gold','hand']})
