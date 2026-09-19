# Research: Jev decision API and gameplay suitability

## Summary

Jev can select a supplied legal-action label, but cannot generate arbitrary moves, prose, or visual observations: its interface is text/JSON state plus typed questions. **Recommendation, not decision:** evaluate a pinned `jev-1.13.0` Choice-per-action loop, with tactical fixtures as a feasibility gate; TypeSafe explicitly warns about arithmetic and multi-hop reasoning. [API](https://docs.typesafe.ai/api) · [Models](https://docs.typesafe.ai/models) · [Jaggedness](https://docs.typesafe.ai/model-jaggedness/jev-1.13)

Research date: 2026-09-18; scope: TypeSafe only, [Establish Jev’s decision API and gameplay suitability](https://github.com/chenxin-yan/jev-slay-the-spire-2/issues/2). Evidence is **verified published documentation**, not independently verified service behavior or machine-tested gameplay. No installations, inference calls, credentials, or game control were used. Research covered interface/limits, calibration/planning, and SDK reliability through the [documentation index](https://docs.typesafe.ai/llms.txt).

## Findings

### 1. Actual decision contract

Use `POST https://api.typesafe.ai/v1/systemone`, bearer authentication, and top-level `state`, `model`, `questions`. State accepts a string, JSON object, or array—not images/audio/video. Questions have application-chosen IDs; **question IDs are not sent to the underlying model**, so instructions must express the complete question. Responses contain `model`, keyed `answers`, and input/output token usage. [API](https://docs.typesafe.ai/api) · [Models](https://docs.typesafe.ai/models)

| Primitive | Documented output | Implication |
|---|---|---|
| `choice` | One supplied label; probabilities for every label summing to one; `confidence` | Closed-set action selection, not arbitrary generated text. |
| `noul` | Float in [0,1]: probability of yes; no separate confidence | Boolean decisions require an application threshold. Independent Nouls are not an exclusive selection. |
| `score` | Probability-weighted level index, `legend`, level probabilities, confidence | Semantic ordered rubric; can fall between levels, not exact numeric prediction. |

These are the three documented types: no native multi-select, ranked-list, action-sequence, or free-text output. Choice criteria map labels to descriptions; Score criteria are ordered descriptions; Noul optionally describes true/false. Instructions/descriptions can contain JSON structure. A custom SDK `response_model` describes response parsing, not arbitrary model-generated schemas. [API](https://docs.typesafe.ai/api) · [Primitives](https://docs.typesafe.ai/primitives) · [SDK schemas](https://docs.typesafe.ai/sdk/python/api/types/questions) · [Sync client](https://docs.typesafe.ai/sdk/python/api/clients/sync)

### 2. Limits and pinned behavior

The model-specific table specifies **64k tokens for state plus all questions**, and **32k for state plus the longest question**. Both apply: fan-out cannot accommodate a 60k-token state. Advertised rate limits are 250,000 tokens/second and 1,200 requests/minute, expressly changeable without notice. [Models](https://docs.typesafe.ai/models)

Questions must form a nonempty map. Primitives says question count is limited only by tokens, but its older “around 32,000” shared-budget paragraph conflicts with Models. Prefer the current model-specific limits and verify boundaries. No numerical maximum for Choice labels, label length, Score levels, or JSON depth was established in inspected API/SDK schemas. HTTP docs require **at least two Score levels**, whereas SDK wording says nonempty; plan for two or more. Empty/singleton Choice behavior remains unverified. [Primitives](https://docs.typesafe.ai/primitives) · [Models](https://docs.typesafe.ai/models) · [API](https://docs.typesafe.ai/api) · [SDK schemas](https://docs.typesafe.ai/sdk/python/api/types/questions) · [Sync client](https://docs.typesafe.ai/sdk/python/api/clients/sync)

Both aliases, `jev-latest` and `jev-preview`, currently resolve to `jev-1.13.0`; aliases move. Pin the full version and record requested/returned IDs. Models says responses identify the versioned model, although illustrative API responses still show an alias. Pinning controls upgrades, **not a documented bit-for-bit determinism guarantee**: jaggedness describes quantitatively similar outputs. [Models](https://docs.typesafe.ai/models) · [API](https://docs.typesafe.ai/api) · [Jaggedness](https://docs.typesafe.ai/model-jaggedness/jev-1.13)

### 3. Independence, ranking, and confidence

Batched questions see the same state and are evaluated independently. Fan-out asks potentially relevant questions upfront and ignores irrelevant answers; one answer does not become another question’s context. Selecting a target conditioned on a newly chosen card therefore needs a second call, or explicit speculative questions for every card. Parallel evaluation with little added latency is a vendor claim, not measured gameplay timing here. [Primitives](https://docs.typesafe.ai/primitives) · [Fan-out](https://docs.typesafe.ai/patterns/fan-out)

Choice returns the highest-probability label. Sorting its distribution gives an application-side relative ranking, but no tie-breaking contract was found. Per-action Scores offer another ranking approach, but host-authored strategic weights would transfer strategy away from Jev. Separate Nouls need not obey arithmetic identities or sum to one; TypeSafe warns against transferring thresholds between Noul and Choice. [API](https://docs.typesafe.ai/api) · [Jaggedness](https://docs.typesafe.ai/model-jaggedness/jev-1.13)

`confidence` summarizes distribution concentration, **not simply the winning label’s probability**; its exact formula is not published on the inspected page. Calibration is described as a population property: among predictions assigned 0.8, approximately 80% should be correct if calibrated. This is a vendor training objective, not demonstrated calibration on this game. [Confidence](https://docs.typesafe.ai/confidence) · [AI primer](https://docs.typesafe.ai/introduction/machine-learning-primer)

**Inference:** display “action-selection probability” and “selection confidence,” never “chance to win.” A distribution over preferred actions is not a distribution over run outcomes. Even a separate “will we win?” Noul would require outcome-based validation before becoming a reliable win estimate. [API semantics](https://docs.typesafe.ai/api) · [Calibration](https://docs.typesafe.ai/introduction/machine-learning-primer)

### 4. Smallest legal-action design

**Proposed design:** provide current observable state, relevant rule text, and all legal, fully parameterized moves. Jev selects one label; the host validates membership/freshness and dispatches it. Combine action+target to prevent inconsistent independent selections; re-observe after execution rather than batching unknown future decisions. This follows the API contract, not documented game support. [API](https://docs.typesafe.ai/api) · [Primitives](https://docs.typesafe.ai/primitives)

Documentation-grounded shape sketch—not runnable integration or a validated tactical prompt:

```json
{
  "model": "jev-1.13.0",
  "state": {
    "snapshot_id": "s17",
    "observation": "<current visible state and relevant rules>",
    "legal_actions": {
      "a0": "Play card instance c7 on enemy e2",
      "a1": "End turn"
    }
  },
  "questions": {
    "next_action": {
      "type": "choice",
      "instructions": "Which legal action in `legal_actions` should be taken next to pursue winning this run, given `observation`?",
      "criteria": {
        "a0": "Play card instance c7 on enemy e2",
        "a1": "End turn"
      }
    }
  }
}
```

`snapshot_id` is application data, not an API transaction feature. Proposed safeguards: zero legal actions means wait/reobserve; singleton handling needs a parent-approved policy; never strategically prune the legal list in host code. These are integration recommendations, not TypeSafe guarantees. [API](https://docs.typesafe.ai/api)

**Options/tradeoffs:** joint Choice is simplest and leaves action preference with Jev. Per-action Nouls/Scores add diagnostics but require aggregation. Two-stage Jev selection reduces candidate descriptions but adds a dependent round trip and can discard a useful branch. Recommend joint Choice first; keep diagnostic scoring out of selection until tested. [Primitives](https://docs.typesafe.ai/primitives) · [Fan-out](https://docs.typesafe.ai/patterns/fan-out)

### 5. Gameplay suitability remains unproven

The 1.13 jaggedness page, reviewed **2026-09-17**, warns about counting, numerical precision, multi-hop reasoning, literal interpretation, irrelevant long context, and contradictory judgments. Score interpolation is unsuitable for reconstructing exact numbers. Jev is not trained to generate text; forcing generation through chained choices is described as slow and poor. [Jaggedness](https://docs.typesafe.ai/model-jaggedness/jev-1.13)

**Inference:** immediate action preference is plausible to test; multi-card sequencing, resource arithmetic, delayed effects, and long-horizon planning are substantial risks. Supply explicit semantics rather than relying on unexplained game names. Exact mechanical calculations can inform state without selecting strategy, but host utility weights, strategic search pruning, or another model selecting moves would undermine “Jev alone owns strategy.” Parent should explicitly settle the mechanical-calculation boundary. [Jaggedness](https://docs.typesafe.ai/model-jaggedness/jev-1.13) · [Snap-judgment guidance](https://docs.typesafe.ai/primitives)

For watchability, display supplied action descriptions, probabilities, and observed changes—not fabricated Jev reasoning. Both structured and visual upstream approaches must ultimately supply text/JSON; Jev cannot itself inspect screenshots. [API](https://docs.typesafe.ai/api) · [Models](https://docs.typesafe.ai/models)

### 6. Failure and retry semantics

HTTP docs specify `401` authentication failure, `422` invalid request, `429` rate limit, and `529` overload. Python/JavaScript SDKs retry automatically. Python defaults: **two retries after the initial attempt**, retry 408/429/all 5xx and connection/timeouts; exponential backoff starts at 0.5 seconds, capped at 5 seconds, with jitter; honor `Retry-After`/`retry-after-ms`. The documented retry budget is 30 seconds including attempts/delays; HTTP-operation timeout is separately configurable. These are settings, not measured latency. [API](https://docs.typesafe.ai/api) · [SDKs](https://docs.typesafe.ai/sdk) · [RetryPolicy](https://docs.typesafe.ai/sdk/python/api/retries) · [Sync client](https://docs.typesafe.ai/sdk/python/api/clients/sync)

**Proposed policy:** bound retries; reject malformed/missing/mismatched answers; recheck state before dispatch; stop safely on exhausted transport/schema failures. Do not substitute another strategist. Low confidence is not a transport failure, and identical retries are not promised to improve judgment. Autonomous play needs a parent-approved bounded Jev-only reconsideration policy or acceptance of uncertain legal choices; routine human escalation would interrupt autonomy. [Confidence](https://docs.typesafe.ai/confidence) · [Jaggedness](https://docs.typesafe.ai/model-jaggedness/jev-1.13) · [SDK errors](https://docs.typesafe.ai/sdk/python/api/clients/sync)

### 7. Illustrative token costs

Advertised price: **$0.042 per million input tokens; output free**. Cost = billed input tokens × 0.042 / 1,000,000. These are hypothetical workloads, **not measured run lengths/counts**: one call per decision, with state, questions, criteria, and overhead included in assumed tokens, respecting both context limits. [Pricing](https://docs.typesafe.ai/models)

| Scenario | Calls × tokens/call | Input tokens/run | Jev cost/run |
|---|---:|---:|---:|
| Small | 500 × 3,000 | 1.5 million | $0.063 |
| Middle | 1,500 × 10,000 | 15 million | $0.63 |
| Heavy | 3,000 × 30,000 | 90 million | $3.78 |

A 10k-token request costs $0.00042. Two equally sized stages double costs; assuming 10% extra fully billed attempts multiplies by 1.10, giving $8.316 for the heavy two-stage scenario. This is conservative budgeting, **not established failed-request billing**. Perception, hosting, and game costs are excluded. [Pricing basis](https://docs.typesafe.ai/models)

Fan-out shares state once: an assumed 8k-token state plus twenty 100-token questions totals approximately 10k ($0.00042), versus twenty separate 8.1k calls totaling 162k ($0.006804), before unmodeled overhead. Future probes must capture actual usage and end-to-end timing; no measured latency is established here. [Models](https://docs.typesafe.ai/models) · [Fan-out](https://docs.typesafe.ai/patterns/fan-out)

## Gaps and minimum future validation probes

1. **Offline fixture gate:** approximately 20–30 audited state/action fixtures covering empty/singleton sets, distinct IDs for duplicate names, target combinations, exact lethal/block arithmetic, sequencing, and noncombat decisions. Check serialization and legal-label mapping without inference. This proposed gate targets published numeric/indirection weaknesses. [Jaggedness](https://docs.typesafe.ai/model-jaggedness/jev-1.13)
2. **Small authorized live gate:** verify pinned identity and three primitives, then fixtures; repeat difficult cases and permute label order. Compare joint Choice with any decomposition. Log distributions, incorrect high-confidence decisions, token usage, and latency. This can falsify suitability, not establish calibration or win rate. [Calibration](https://docs.typesafe.ai/introduction/machine-learning-primer) · [Models](https://docs.typesafe.ai/models)
3. **Boundary probes:** maximum labels/label length, zero/one-label behavior, two-level Score, token accounting, both context limits, response model ID, and ties. Ask TypeSafe where observations cannot establish a contract. Published schemas do not resolve all these questions. [SDK schemas](https://docs.typesafe.ai/sdk/python/api/types/questions) · [Models](https://docs.typesafe.ai/models)
4. **Future local failure mocks:** 401/422, 429/529 with retry headers, timeout, malformed response, stale snapshot. Check finite attempts and no stale/double dispatch. A larger held-out tactical evaluation remains necessary; no inspected source supplies a Slay the Spire 2 benchmark. [RetryPolicy](https://docs.typesafe.ai/sdk/python/api/retries) · [API](https://docs.typesafe.ai/api)

Still unanswered: gameplay competence/calibration, exact confidence formula, deterministic ties, version-retirement guarantees, and failed-request billing. Parent also needs the mechanical-computation boundary and uncertainty policy. [Confidence](https://docs.typesafe.ai/confidence) · [Models](https://docs.typesafe.ai/models) · [API](https://docs.typesafe.ai/api)

**Tool limitation:** shared provider returned `Firecrawl ... error (429): Rate limit exceeded`. Core references below were read successfully; individual primitive/detail fetches were intermittently blocked. Fetching ceased following parent quota guidance. Missing evidence was not replaced with invented execution behavior.

## Sources

- [Documentation index](https://docs.typesafe.ai/llms.txt), [Models](https://docs.typesafe.ai/models), [HTTP API](https://docs.typesafe.ai/api).
- [Primitives](https://docs.typesafe.ai/primitives), [Fan-out](https://docs.typesafe.ai/patterns/fan-out), [Confidence](https://docs.typesafe.ai/confidence).
- [Jev 1.13 jaggedness](https://docs.typesafe.ai/model-jaggedness/jev-1.13), [AI primer/calibration](https://docs.typesafe.ai/introduction/machine-learning-primer).
- [SDK overview](https://docs.typesafe.ai/sdk), [Python schemas](https://docs.typesafe.ai/sdk/python/api/types/questions), [Sync client](https://docs.typesafe.ai/sdk/python/api/clients/sync), [RetryPolicy](https://docs.typesafe.ai/sdk/python/api/retries).
