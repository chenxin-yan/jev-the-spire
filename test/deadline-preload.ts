// Test-only preload: shrinks the CLI's 5-minute demo deadline timer so main.test.ts can observe the
// deadline abort without waiting five minutes. Only that exact delay is touched; production code is unchanged.
const DEMO_DEADLINE_MS = 5 * 60_000;
const SHRUNK_MS = 100;
const original = globalThis.setTimeout;
globalThis.setTimeout = ((fn: Parameters<typeof setTimeout>[0], ms?: number, ...rest: unknown[]) =>
  original(fn, ms === DEMO_DEADLINE_MS ? SHRUNK_MS : ms, ...rest)) as typeof setTimeout;
