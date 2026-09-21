// Operator-approved targeted QA only; no model, invented probabilities, or mutation retries.
import { appendFileSync, mkdirSync, writeFileSync } from 'node:fs';
import { observe, dispatch } from '/Users/yanchenxin/dev/github.com/chenxin-yan/jev-slay-the-spire-2/src/bridge.ts';
const dir = '/tmp/jev-targeted-treasure-2026-09-21';
mkdirSync(dir, { recursive: true });
const url = 'http://127.0.0.1:15526/api/v1/singleplayer';
const signal = AbortSignal.timeout(45000);
const log = (record: object) => appendFileSync(`${dir}/journal.jsonl`, JSON.stringify({ ts: new Date().toISOString(), actor: 'parent_targeted_qa', ...record }) + '\n');
let previous = '';
async function ready() {
  const deadline = Date.now() + 30000;
  for (;;) {
    const s = await observe(url, signal);
    if (s.state_version !== previous) { log({ type: 'observation', snapshot: s }); previous = s.state_version; }
    writeFileSync(`${dir}/latest.json`, JSON.stringify(s, null, 2) + '\n');
    if (s.halt_reason) throw new Error(s.halt_reason);
    if (s.terminal || s.legal_actions_complete && s.legal_actions.length > 0) return s;
    if (Date.now() >= deadline) throw new Error('QA readiness timeout; no further dispatch');
    await new Promise(resolve => setTimeout(resolve, 500));
  }
}
const s = await ready();
const [version, label] = process.argv.slice(2);
if ((version === undefined) !== (label === undefined)) throw new Error('Require both exact version and legal label');
if (label !== undefined) {
  if (version !== s.state_version || !s.legal_actions.some(a => a.label === label)) throw new Error('QA stale version or unavailable label; not dispatched');
  log({ type: 'qa_decision', state_version: version, label, legal_actions: s.legal_actions });
  const result = await dispatch(url, version, label, signal);
  log({ type: 'dispatch', state_version: version, label, ...result });
  if (result.status !== 202) throw new Error(`QA dispatch rejected: ${result.status}`);
}
const after = label === undefined ? s : await ready();
console.log(JSON.stringify({ state_version: after.state_version, state_type: after.state_type, run: after.run, legal_actions: after.legal_actions, terminal: after.terminal }, null, 2));
