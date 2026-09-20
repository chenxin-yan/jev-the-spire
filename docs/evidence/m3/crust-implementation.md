# Crust CLI migration — implementation report

Repo `/Users/yanchenxin/dev/github.com/chenxin-yan/jev-slay-the-spire-2`, sole app writer; nothing staged or committed (`git diff --cached --name-only` empty). Native repo and `.agent-sources/crust` (b79c147…, clean) untouched. `CONTEXT.md` `0b90a7e6…88e3b7` unchanged; `.env` not read/moved (mtime Sep 19 00:10:35, 82 bytes). No game HTTP, inference, UI/install, save/profile access, credentials, environment dumps, global tool changes, or children. Every Bun invocation `--no-env-file`; fake bridges only. Offline implementation only.

Freeze: `/tmp/jev-crust-cli/` — `src/`, `test/`, `package.json`, `bun.lock`, `tsconfig.json`, `app-README.md`, `mise.toml`, `delta.patch` (475 lines vs `/tmp/jev-minimal-cli-repairs/`), `delta-stat.txt`, `versions.txt`, `commands.txt`, `exits.txt`, `install/typecheck/main-test/test/independent-output.txt` + `.exit`, `protected.txt`, `SHA256SUMS` (31 files; `.env`/`node_modules` excluded).

## Toolchain (approved)

- `mise install bun@1.4.2` (local install, no `mise use`/global); `mise.toml` now `bun = "1.4.2"` + preserved `dotnet = "9"`. Everything below via `mise exec -- bun …` in the repo. Actual: `bun 1.4.2`, `tsc Version 7.0.2` (native TS 7, `@typescript/typescript-darwin-arm64`).
- `package.json`: `+@crustjs/core 0.3.3`, `+@crustjs/effect 0.1.0`, `typescript 5.9.3 → 7.0.2`. Kept `effect 4.0.0-rc.116`, `ai 7.0.107`, `@ai-sdk/gateway 4.0.87`, `@types/bun 1.4.2`. Lock delta: only the three additions (+ transitive `@crustjs/utils 0.1.0`, TS platform binaries). Registry integrity for core/effect matches the parent's `/tmp/jev-crust-exploration/*-metadata.json`.
- **Two install observations (no bug, reported plainly):**
  1. `bun --no-env-file install --ignore-scripts` failed: `@crustjs/core@0.3.3` "blocked by minimum-release-age: 86400 seconds" — Bun 1.4.2 default gate; the package was published 2026-09-20T00:54Z (~8 h before). No `~/.bunfig.toml` exists. I re-ran once with `--minimum-release-age=0` (one-off CLI flag, no project/global config change) since the owner explicitly pinned the exact just-published version of their own package, and verified the integrity hash. Subsequent `bun install --frozen-lockfile` passes without the flag. Flagging for owner awareness because it bypasses a supply-chain delay once.
  2. `bun install` prints `[0.04ms] ".env"` with or without `--no-env-file` (reproduced in a scratch dir: `--no-env-file` is honored by `bun run`, ignored by `bun install`). No value was printed or used by me; it is Bun's own registry-config env discovery. Unavoidable without moving `.env`, which I did not do.

## Changed paths

- `src/main.ts` — interim `node:util.parseArgs` replaced outright by a Crust root command `new Crust("jev").flags(…).action(handler(…))` + `await app.execute()`. Flags: `max-actions` (`type: "string"`, `default: "10"`, `parse: parsePositiveInteger` rejecting `""`/whitespace, non-safe-integer, `<= 0`, so the default is validated too), `log` (optional string), `bridge` (default `BRIDGE_URL`). Action is an `Effect.gen` via `@crustjs/effect` `handler`: rejects non-empty `rawArgs` (after `--`) before any I/O; then `mkdirSync`, header print, `Effect.promise(runBoundedLoop)`. `runBoundedLoop` owns the `AbortController`, `process.once("SIGINT")` and the 5-min `setTimeout` (Crust supplies no process signal), releasing both in `finally` before Crust cleanup. `runLoop`, `bridge.ts`, `jev.ts`, `loop.ts` unchanged (byte-identical to baseline). Exit conversion at the command boundary after the summary is logged/printed: `terminal`/`max_actions` → return summary (0); `halt_reason === "SIGINT"` → `yield* Effect.interrupt` (native Crust 130, silent); everything else (`halted`, `demo_deadline`) → `Effect.fail(new Error("<outcome>: <halt_reason>"))` → Crust renders `Error: …`, exit 1. No `process.exit` anywhere; the process exits naturally after `execute()` (verified in smoke + tests; no hang). No Layer/service, no help extension.
- `test/main.test.ts` — rewritten for the new contract (8 → 15 tests): 10 rejections exit 1 / 0 GETs / no log / stderr starts `Error: ` (missing value, `--max-actions=`, 0, 1.5, -2, 2^53+1, unknown flag, positional, `-- stray`, `--help`); accepted `--max-actions 1` → 0 with terminal summary; default bound header `max-actions=10`; halted fake snapshot → 1 with `Error: halted: unsupported_state`; **SIGINT while a fake GET is pending → 130**, 1 GET, 0 POSTs, logged `outcome: "aborted", halt_reason: "SIGINT"`, no `Error:`; **deadline wiring** via preload → 1, 0 POSTs, `aborted`/`demo_deadline`. Each spawned CLI has a 15 s SIGKILL guard. Fake bridge stays a real HTTP server (async), no key in the env.
- `test/deadline-preload.ts` (new, 7 lines) — test-only `--preload` that maps exactly the 300 000 ms `setTimeout` delay to 100 ms in the child; production untouched.
- `README.md` — run (`mise install`), Crust boundary description, new exit contract, no `--help`, dependency/toolchain versions, preload note.
- `mise.toml`, `package.json`, `bun.lock` as above. `docs/` evidence/research not edited.

## New exit contract (deliberate; supersedes 2/1)

| Case | Before | Now |
|---|---:|---:|
| bad/unknown/missing flag, positional, raw args after `--`, `--help` | 2 | **1** (`Error: …`, no I/O) |
| `terminal` / `max_actions` | 0 | 0 |
| `halted` (incl. `wait_timeout`, dispatch rejected/uncertain) | 1 | 1 (+ `Error: halted: <reason>`) |
| `demo_deadline` | 1 | 1 (+ `Error: aborted: demo_deadline`) |
| Ctrl-C | 1 | **130** (Effect interruption; summary still logged) |

## Gate results (Bun 1.4.2 / TS 7.0.2, full outputs in freeze)

| Command | Exit | Result |
|---|---:|---|
| `mise exec -- bunx --no-env-file tsc --noEmit` | 0 | clean (also clean on pre-migration code) |
| `mise exec -- bun --no-env-file test test/main.test.ts` | 0 | 15 pass / 0 fail |
| `mise exec -- bun --no-env-file test` | 0 | **50 pass / 0 fail**, 193 assertions (was 43) — bridge/jev/loop tests untouched and green |
| `mise exec -- bun --no-env-file test /tmp/jev-minimal-demo-review/independent.test.ts` (unchanged, sha `ecde46f7…d766`) | 1 | 7 pass, **2 fail exactly on the intended exit codes** (`code 2 → 1`; SIGINT `1 → 130`); their 0-GET / 0-POST / `"outcome":"aborted"` / `Ctrl-C` assertions still hold. Not a regression — presented as the contract change. |

Preserved and untested-here-but-unchanged: 60 s inference deadline, 10 s Retry-After cap, 5 min total, full legal set, singleton forced path, freshness-to-multiple, `mutation_pending` non-blocking, never-retry POST, synchronous pre-dispatch JSONL, no invented model data.

## Remaining limits

- Offline only: no real Jev/Gateway or game integration exercised; the deadline test shrinks the timer, it is not a 5-minute endurance run.
- `--help` intentionally absent (would need `@crustjs/extensions`); `--help` exits 1 as an unknown flag. Add the standard help extension if the owner wants it.
- Ctrl-C after `runLoop` returns (during Crust cleanup) hits Bun's default SIGINT handling since the listener is removed; no dispatch is possible at that point.
- One-off `--minimum-release-age=0` bypass noted above; the lockfile now pins integrity.
- Crust upstream: no bug encountered; core rendering and `handler` behaved as the pinned source predicted.
