# Code Context

Investigated `.agent-sources/crust` at pinned `b79c147ad81549d5cf8755993bf707b539fda996`; no repository or checkout files were edited.

## Files Retrieved

1. `.agent-sources/crust/packages/effect/src/handler.ts` (lines 27-85, 88-119) — `ServicesOf`, `handler`, `service`, layer discovery, Effect execution, and unwrapping.
2. `.agent-sources/crust/packages/effect/src/layer.ts` (lines 14-47) — `Scope`, Layer build, finalizer registration, and `actionExits`.
3. `.agent-sources/crust/packages/effect/src/errors.ts` (lines 45-99) — tagged errors, `tryCrust`, interruption, and `AbortError` conversion.
4. `.agent-sources/crust/apps/docs/content/docs/modules/effect.mdx` (lines 28-63, 65-97, 99-148, 168-170) — official adaptor model, lifetime, errors, and out-of-scope boundaries.
5. `.agent-sources/crust/apps/docs/examples/modules/effect.ts` (lines 10-32) — official `Layer.effect`/`acquireRelease`/`layer`/`handler` example.
6. `.agent-sources/crust/packages/core/src/command/invocation.ts` (lines 202-309, 416-555) — invocation lifecycle and exit handling.
7. `.agent-sources/crust/packages/core/src/command/crust.ts` (lines 103-128, 1777-1799) — action input and `.execute()` contract.
8. `.agent-sources/crust/packages/core/src/parsing/parser.ts` (lines 72-128, 363-415, 584-630) — number coercion, strict argv parsing, parser hooks, and validation.
9. `.agent-sources/crust/packages/core/src/types.ts` (lines 118-136, 263-301) — synchronous `parse` is string-only; number flags cannot define it.
10. `.agent-sources/crust/packages/core/src/parsing/parser.test.ts` (lines 90-124, 488-535, 928-988) — tested number gaps, unknown/missing values, and parser behavior.
11. `src/main.ts` (lines 1-46), `src/loop.ts` (lines 6-18, 53-64, 85-145, 182-190, 209-297), `src/jev.ts` (lines 34-42, 73-128), `src/bridge.ts` (lines 63-120) — current CLI, loop, Jev Effect signal wiring, and HTTP cancellation.

## Key Code

### Effect adaptor

- `handler(fn)` accepts an Effect-returning function or generator and returns a Crust action `(input) => Promise<Out>` (`handler.ts:45-57`). It finds every `layer()` Context on the path, eagerly awaits all of them, provides their built services plus internal action input, then runs the program (`handler.ts:58-84`).
- It calls `Effect.runPromiseExit(program)` with **no signal/options** (`handler.ts:68-84`). `CrustCommandContext` contains args, flags, ctx, IO, and command snapshots but no AbortSignal (`core/src/command/crust.ts:103-128`). There is no handler/context-layer API parameter for a process signal.
- `service(factory)` is lazy and identity-sensitive: it requires the effective same-name provider from that exact factory (or `.of()` double), otherwise fails through tagged `CrustDefinitionError` (`handler.ts:88-119`). It is not needed for the current loop.
- `layer(name, live)` wraps one fully composed Layer as a normal Crust Context factory (`layer.ts:24-47`). It makes a fresh Effect `Scope`, registers `Scope.close` before building, builds with `Layer.buildWithScope`, and stores the action Exit for finalizers. Official docs say release occurs after post-run hooks, in reverse order, and finalizers receive success/failure/interruption Exit (`effect.mdx:50-63`). Every path Layer is eager, even unused (`effect.mdx:93-96`; `handler.test.ts:40-64,87-98`).
- `tryCrust` maps a thrown Core `CrustError` to a tagged `Crust*Error`, DOM-style `AbortError` to Effect interruption, and other errors to a defect (`errors.ts:62-84`). `unwrapExit` rethrows original tagged causes and converts interruption to `DOMException(..., "AbortError")` (`errors.ts:87-99`). Tests verify identical tagged-error rendering and silent exit 130 (`handler.test.ts:391-424`).

### Core lifecycle and exit codes

`dispatch` validates, runs the action, runs reverse-order post-run hooks, and only then leaves its `using` disposal scope (`invocation.ts:219-309`). `.execute()` is the terminal argv boundary; it accepts only `{ argv?, io? }`, not a signal, and promises 0/1/130 (`crust.ts:1777-1799`). Core recognizes an Error named `AbortError`, sets `process.exitCode = 130`, and suppresses default rendering (`invocation.ts:531-552`; tests `crust.test.ts:1574-1647`). Ordinary failures render and use exit 1.

Therefore native Crust/Effect integration manages Effect execution and Layer cleanup, **not process cancellation**. SIGINT must still be caught by app code and connected to an AbortController. Crust has no signal option to `.execute()` or `handler()` here.

### Strict parser and `--max-actions`

- `node:util.parseArgs` is strict (`parser.ts:363-395`). Unknown long/short options become `CrustError("PARSE", "Unknown flag ...")`; a valued flag without a value becomes a PARSE error retaining its flag name (`parser.test.ts:491-535`). Registering Crust flags therefore fixes the current manual parser's silent unknown-flag behavior. Extra unconsumed positionals become `VALIDATION` (`parser.ts:604-609`).
- `type: "number"` is not positive-integer validation. Core rejects only NaN (`parser.ts:75-81`); `tryCoerceNumber` explicitly makes `Number("")` equal 0 (`packages/utils/src/primitive.ts:29-42`). Tests show negative numbers and floats are accepted (`parser.test.ts:103-113`); Infinity is also not NaN. Do not use number type alone for this bound.
- Use a local synchronous positive-integer parser with a **string** flag: `type: "string", parse: parsePositiveInteger`. `parse` is string-only (`types.ts:118-126,284-301`), runs on raw argv and defaults, and parser exceptions are wrapped as PARSE (`parser.ts:109-128`; tests `parser.test.ts:959-988`). The local parser should reject empty, non-finite, non-integer, and `<= 0`; use `default: String(DEFAULT_MAX_ACTIONS)` so the default follows the same validation.
- Deliberate parser boundary: values after `--` are `rawArgs`, not flags (`parser.ts:397-414`; `parser.test.ts:448-457`). Thus `-- --unknown` is intentionally accepted as raw input; it is the one relevant strictness caveat if this CLI wants to reject every unknown-looking token. Repeated single-valued behavior is not needed for this bound; `multiple: true` is the explicit repeated-value mode (`types.ts:251-280`).

## Architecture

Current flow is already cancellation-aware without Crust: `main.ts` creates an AbortController and aborts it on SIGINT (`main.ts:27-31`); `runLoop` passes the signal to observe/decide/dispatch and prevents POST after inference (`loop.ts:117-145,209-230,263-297`); bridge fetches combine it with HTTP timeout (`bridge.ts:63-120`); Jev runs its Effect program with `{ signal }` and combines caller and Effect fiber signals for `experimental_evaluate` (`jev.ts:81-127`).

Recommended minimum migration is a thin boundary in `main.ts`: register Crust flags, keep `runLoop` and `jev.ts` as-is, and make one `.action(handler(...))` call `runLoop` through an Effect promise. No loop rewrite, DecisionModel rewrite, Layer, or `service()` is required. `handler` can close over the controller from `main.ts`; it cannot receive that signal from Crust automatically.

Important outcome detail: `runLoop` catches an aborted signal and **returns** `Summary { outcome: "aborted" }` (`loop.ts:294-296`). If returned as a successful Crust action, `.execute()` sees success and returns 0. If terminal cancellation should use Crust's documented 130, the action boundary must convert that summary to a thrown `DOMException(..., "AbortError")` after logging; Core then supplies 130. If the app deliberately retains its current explicit summary-to-`process.exit` policy, it can retain its own code selection, but that is not native Crust cancellation. Retain the SIGINT listener/controller either way.

Tiny verified-symbol shape (existing `LoopDeps` construction omitted):

```ts
const app = new Crust("jev")
  .flags({
    name: "max-actions",
    type: "string",
    default: String(DEFAULT_MAX_ACTIONS),
    parse: parsePositiveInteger, // local synchronous validator
  })
  .action(
    handler(({ flags }) =>
      Effect.promise(async () => {
        const summary = await runLoop({
          /* existing observe/dispatch/decide/log/print deps */
          signal: controller.signal,
          maxActions: flags["max-actions"],
        });
        if (summary.outcome === "aborted") {
          throw new DOMException("Effect was interrupted.", "AbortError");
        }
        return summary;
      }),
    ),
  );

await app.execute();
```

`Crust`, `handler`, `Effect.promise`, `.flags`, `.action`, and `.execute` are shown by the official example/API (`effect.mdx:65-89`, `examples/modules/effect.ts:21-32`). The DOMException conversion is only needed if 130 is desired; the current loop otherwise deliberately returns an aborted summary.

## Start Here

Open `src/main.ts` first: replace only ad-hoc argv extraction/action invocation with a Crust root boundary, preserving the controller and `runLoop` dependency wiring. Then inspect `src/loop.ts:225-297` to preserve no-dispatch-after-SIGINT and uncertain-mutation rules.

## Supported vs untested

**Source/test-backed:** handler forms, eager Layer construction and reverse scoped cleanup, tagged error unwrapping, Core exit 130 for an `AbortError`, strict unknown/missing argv errors, and synchronous string `parse` transforms.

**Not tested in this app:** actual Crust + Bun + current app integration, exact current-app Effect rc.116 compatibility with this pinned adaptor, and a real SIGINT run after wrapping `runLoop`. Parent owns package/version compatibility; no registry research was performed.
