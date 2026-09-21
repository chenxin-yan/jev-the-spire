import { appendFileSync } from 'node:fs';
import assert from 'node:assert/strict';
import { observe, dispatch } from '/Users/yanchenxin/dev/github.com/chenxin-yan/jev-slay-the-spire-2/src/bridge.ts';
const url='http://127.0.0.1:15526/api/v1/singleplayer', signal=AbortSignal.timeout(15000);
const s=await observe(url,signal);
assert(s.legal_actions_complete && s.legal_actions.length>0 && !s.mutation_pending);
for (const [version,label,status] of [[s.state_version,'qa_nonexistent_action',422],['qa_stale_version',s.legal_actions[0]!.label,409]] as const) {
 const result=await dispatch(url,version!,label!,signal);
 appendFileSync('/tmp/jev-targeted-2026-09-21/journal.jsonl',JSON.stringify({ts:new Date().toISOString(),actor:'parent_targeted_qa',type:'expected_rejection',state_version:version,label,...result})+'\n');
 assert.equal(result.status,status);
 const after=await observe(url,signal);
 assert.equal(after.state_version,s.state_version);
 assert.deepEqual(after.legal_actions,s.legal_actions);
 assert.equal(after.mutation_pending,false);
}
console.log('PASS: unknown label422 and stale version409, no mutation or version consumption');
