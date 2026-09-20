## Review

No issues found.

- **Correct — grounded root cause.** The pinned scene initializes rest buttons with `mouse_filter = 2`; native `_Ready` launches the unawaited 0.5-second `AnimateIn`, whose tail sets Stop. Parent-supplied native IL additionally confirms default `_isEnabled = true` and room `_Ready` disabling only Proceed. This explains the failure through `McpMod.OrdinaryActions.cs:22–27`, independently of the later successful readback.

- **Correct — narrow repair.** `BridgeProtocol.cs:184–188` and `McpMod.LegalActions.cs:77–94` classify only the rest-button Ignore window as whole-decision waiting. No delay, pruning, interception, selector authority or adoption was added. Model-disabled options remain distinguished by `Option.IsEnabled` and `_isUnclickable`; Stop/Pass behavior remains unchanged after the fade.

- **Correct — ownership and sibling safety.** `RequireRest` executes before readiness classification, preserving entry identity, captured tutorial status, death and room-exit failures (`McpMod.OrdinaryActions.cs:48–54`; `BridgeProtocol.cs:208–232`). Waiting skips potion enumeration and clears the shared wire/executable action list (`McpMod.Contract.cs:151–158,207–225`), withholding options, Proceed and potions together.

- **Correct — shared callers preserved.** Inspected rest/shop enumeration, ordinary Proceed/shop-toggle checks, treasure admission/dispatch and event option/dialogue callers. The shared `OrdinaryInput` refusal remains untouched; the rest-specific lifecycle is not generalized to unrelated controls.

- **Correct — meaningful offline regression.** `tests/check-bridge.sh:1426–1447,1681–1710` checks entry/partial/ready filters, production finalization, compiled call ordering and native lifecycle metadata. Retained logs show baseline rejection, unwired-predicate mutation rejection, and final **1972 checks passing**; final build reports zero warnings/errors.

**Validation notes:** The baseline red fails on the missing helper, not by executing the original Godot failure. The separate mutation test meaningfully verifies production wiring, but neither it nor the fixture executes live `AddNonCombatActions`. Tests do not certify live fade timing, rest dispatch or post-option transitions. I reviewed supplied logs rather than rerunning commands; no edits or live actions were performed.

**Merge verdict: OK with notes** — offline repair supported; live certification remains parent-controlled.