# CEO Review — Detailed Section Checklists (Layer 3)

> Loaded on-demand by `SKILL.md` after scope and mode are agreed.
> Apply sections **in order**. Each ends with **STOP** — AskUserQuestion once per issue,
> do not batch, do not proceed until user responds.

---

## Section 1: Architecture Review

Evaluate and diagram:
* Overall system design and component boundaries. Draw the dependency graph.
* Data flow — all four paths (happy, nil, empty, error). ASCII diagram each.
* State machines. ASCII diagram for every new stateful object.
* Coupling concerns. Before/after dependency graph.
* Scaling characteristics. What breaks first under 10x load? Under 100x?
* Single points of failure.
* Security architecture. Auth boundaries, data access patterns, API surfaces.
* Production failure scenarios. For each new integration point, describe one realistic production failure.
* Rollback posture. If this ships and immediately breaks, what's the rollback procedure?

**EXPANSION and SELECTIVE EXPANSION additions:**
* What would make this architecture beautiful? Not just correct — elegant.
* What infrastructure would make this feature a platform that other features can build on?

Required ASCII diagram: full system architecture showing new components and their relationships.
**STOP.** AskUserQuestion once per issue. Do NOT batch. Do NOT proceed until user responds.

---

## Section 2: Error & Rescue Map

For every new method, service, or codepath that can fail, fill in this table:
```
  METHOD/CODEPATH          | WHAT CAN GO WRONG           | EXCEPTION CLASS
  -------------------------|-----------------------------|-----------------

  EXCEPTION CLASS              | RESCUED?  | RESCUE ACTION          | USER SEES
  -----------------------------|-----------|------------------------|------------------
```
Rules:
* Catch-all error handling is ALWAYS a smell. Name the specific exceptions.
* Every rescued error must either: retry with backoff, degrade gracefully, or re-raise with added context.
* For each GAP: specify the rescue action and what the user should see.
* For LLM/AI calls: what happens when the response is malformed, empty, hallucinates invalid JSON, or returns a refusal?
**STOP.** AskUserQuestion once per issue. Do NOT proceed until user responds.

---

## Section 3: Security & Threat Model

Evaluate:
* Attack surface expansion. New endpoints, params, file paths, background jobs?
* Input validation. For every new user input: validated, sanitized, rejected loudly on failure?
* Authorization. For every new data access: scoped to the right user/role?
* Secrets and credentials. New secrets? In env vars, not hardcoded? Rotatable?
* Dependency risk. New packages? Security track record?
* Data classification. PII, payment data, credentials?
* Injection vectors. SQL, command, template, LLM prompt injection.
* Audit logging. For sensitive operations: is there an audit trail?

For each finding: threat, likelihood, impact, and whether the plan mitigates it.
**STOP.** AskUserQuestion once per issue. Do NOT proceed until user responds.

---

## Section 4: Data Flow & Interaction Edge Cases

**Data Flow Tracing:** For every new data flow, produce an ASCII diagram:
```
  INPUT --> VALIDATION --> TRANSFORM --> PERSIST --> OUTPUT
    |            |              |            |           |
  [nil?]    [invalid?]    [exception?]  [conflict?]  [stale?]
  [empty?]  [too long?]   [timeout?]    [dup key?]   [partial?]
```
For each node: what happens on each shadow path? Is it tested?

**Interaction Edge Cases:** For every new user-visible interaction:
```
  INTERACTION          | EDGE CASE              | HANDLED? | HOW?
  ---------------------|------------------------|----------|--------
```
Flag any unhandled edge case as a gap. For each gap, specify the fix.
**STOP.** AskUserQuestion once per issue. Do NOT proceed until user responds.

---

## Section 5: Code Quality Review

Evaluate:
* Code organization and module structure. Does new code fit existing patterns?
* DRY violations. Be aggressive. Reference the file and line.
* Naming quality. Named for what they do, not how they do it?
* Error handling patterns. (Cross-reference with Section 2.)
* Missing edge cases. List explicitly.
* Over-engineering check. Any new abstraction solving a problem that doesn't exist yet?
* Under-engineering check. Anything fragile or assuming happy path only?
* Cyclomatic complexity. Flag any new method that branches more than 5 times.
**STOP.** AskUserQuestion once per issue. Do NOT proceed until user responds.

---

## Section 6: Test Review

Make a complete diagram of every new thing this plan introduces:
```
  NEW UX FLOWS:         [list each]
  NEW DATA FLOWS:       [list each]
  NEW CODEPATHS:        [list each]
  NEW BACKGROUND JOBS:  [list each]
  NEW INTEGRATIONS:     [list each]
  NEW ERROR PATHS:      [list each — cross-reference Section 2]
```
For each item:
* What type of test covers it? (Unit / Integration / System / E2E)
* What is the happy path test?
* What is the failure path test?
* What is the edge case test?

Test ambition check: For each new feature:
* What's the test that would make you confident shipping at 2am on a Friday?
* What's the test a hostile QA engineer would write to break this?

Test pyramid check: Many unit, fewer integration, few E2E? Or inverted?
Flakiness risk: Flag any test depending on time, randomness, external services, or ordering.
**STOP.** AskUserQuestion once per issue. Do NOT proceed until user responds.

---

## Section 7: Performance Review

Evaluate:
* N+1 queries. For every new association traversal: is there a preload?
* Memory usage. For every new data structure: what's the maximum size in production?
* Database indexes. For every new query: is there an index?
* Caching opportunities. For every expensive computation: should it be cached?
* Background job sizing. Worst-case payload, runtime, retry behavior?
* Slow paths. Top 3 slowest new codepaths and estimated p99 latency.
* Connection pool pressure. New DB, Redis, or HTTP connections?
**STOP.** AskUserQuestion once per issue. Do NOT proceed until user responds.

---

## Section 8: Observability & Debuggability Review

Evaluate:
* Logging. Structured log lines at entry, exit, and each significant branch?
* Metrics. What metric tells you it's working? What tells you it's broken?
* Tracing. For cross-service flows: trace IDs propagated?
* Alerting. What new alerts should exist?
* Dashboards. What new panels do you want on day 1?
* Debuggability. If a bug is reported 3 weeks post-ship, can you reconstruct what happened from logs alone?
* Runbooks. For each new failure mode: what's the operational response?

**EXPANSION and SELECTIVE EXPANSION addition:**
* What observability would make this feature a joy to operate?
**STOP.** AskUserQuestion once per issue. Do NOT proceed until user responds.

---

## Section 9: Deployment & Rollout Review

Evaluate:
* Migration safety. Backward-compatible? Zero-downtime? Table locks?
* Feature flags. Should any part be behind a feature flag?
* Rollout order. Correct sequence?
* Rollback plan. Explicit step-by-step.
* Deploy-time risk window. Old code and new code running simultaneously — what breaks?
* Post-deploy verification checklist. First 5 minutes? First hour?
* Smoke tests. What automated checks should run immediately post-deploy?

**EXPANSION and SELECTIVE EXPANSION addition:**
* What deploy infrastructure would make shipping this feature routine?
**STOP.** AskUserQuestion once per issue. Do NOT proceed until user responds.

---

## Section 10: Long-Term Trajectory Review

Evaluate:
* Technical debt introduced. Code debt, operational debt, testing debt, documentation debt.
* Path dependency. Does this make future changes harder?
* Knowledge concentration. Documentation sufficient for a new engineer?
* Reversibility. Rate 1-5: 1 = one-way door, 5 = easily reversible.
* The 1-year question. Read this plan as a new engineer in 12 months — obvious?

**EXPANSION and SELECTIVE EXPANSION additions:**
* What comes after this ships? Phase 2? Phase 3?
* Platform potential. Does this create capabilities other features can leverage?
**STOP.** AskUserQuestion once per issue. Do NOT proceed until user responds.

---

## Section 11: Design & UX Review (skip if no UI scope detected)

Evaluate:
* Information architecture — what does the user see first, second, third?
* Interaction state coverage map: FEATURE | LOADING | EMPTY | ERROR | SUCCESS | PARTIAL
* User journey coherence — storyboard the emotional arc
* Responsive intention — is mobile mentioned or afterthought?
* Accessibility basics — keyboard nav, screen readers, contrast, touch targets

**EXPANSION and SELECTIVE EXPANSION additions:**
* What would make this UI feel *inevitable*?
* What 30-minute UI touches would make users think "oh nice, they thought of that"?

Required ASCII diagram: user flow showing screens/states and transitions.
**STOP.** AskUserQuestion once per issue. Do NOT proceed until user responds.
