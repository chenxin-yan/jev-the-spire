import json, urllib.request, urllib.error
from pathlib import Path
root=Path('/tmp/jev-m2-live')
base='http://127.0.0.1:15526'
s=json.loads((root/'combat-get-1.json').read_text())
cases=[('combat-get-2','GET','/api/v1/singleplayer',None,{}),('unknown-label','POST','/api/v1/singleplayer',{'state_version':s['state_version'],'label':'not-a-legal-action'},{}),('stale-version','POST','/api/v1/singleplayer',{'state_version':'deliberately-stale','label':'play_card:0:1'},{}),('browser-origin','GET','/api/v1/singleplayer',None,{'Origin':'https://example.invalid'}),('route-allowlist','GET','/api/v1/not-allowed',None,{}),('combat-after-rejections','GET','/api/v1/singleplayer',None,{})]
for name,method,path,payload,headers in cases:
    data=None if payload is None else json.dumps(payload).encode()
    if data is not None:
        headers['Content-Type']='application/json'
        (root/(name+'.request.json')).write_bytes(data)
    request=urllib.request.Request(base+path,data=data,headers=headers,method=method)
    try: response=urllib.request.urlopen(request,timeout=10)
    except urllib.error.HTTPError as error: response=error
    body=response.read()
    (root/(name+'.json')).write_bytes(body)
    (root/(name+'.headers')).write_text(str(response.status)+'\n'+str(response.headers))
    print(name,response.status,body.decode()[:300] if response.status!=200 else 'snapshot saved')
a=json.loads((root/'combat-get-2.json').read_text())
b=json.loads((root/'combat-after-rejections.json').read_text())
assert s==a==b, 'Snapshot changed during read/rejection checks'
print('PASS: exact snapshots and state_version unchanged across GET/rejected requests')
