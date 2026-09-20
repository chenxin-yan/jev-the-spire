import json
from urllib.request import urlopen

# Read-only observation; never dispatch or advance the game.
with urlopen('http://127.0.0.1:15526/api/v1/singleplayer', timeout=10) as response:
    state = json.load(response)
print(json.dumps(state), flush=True)
assert state.get('halt_reason') != 'shared_event_unverified', 'Morphic Grove remains unsupported: shared_event_unverified'
