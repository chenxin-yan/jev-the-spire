// Accelerate the former whole-run timer if it is reintroduced, so uninterrupted-play coverage needs
// milliseconds rather than five minutes. Other safety timers are unchanged.
const FORMER_DEADLINE_MS = 5 * 60_000;
const SHRUNK_MS = 100;
const original = globalThis.setTimeout;
globalThis.setTimeout = ((fn: Parameters<typeof setTimeout>[0], ms?: number, ...rest: unknown[]) =>
  original(fn, ms === FORMER_DEADLINE_MS ? SHRUNK_MS : ms, ...rest)) as typeof setTimeout;
