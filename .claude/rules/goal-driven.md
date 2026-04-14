# Goal-Driven Execution

> Define verifiable success before writing code. Loop until verified.

## The Rule

Before implementing anything non-trivial, transform the request into a concrete,
verifiable success criterion. Weak goals ("make it work") require constant clarification.
Strong goals let the agent loop independently.

## Reframing Patterns

| Vague request | Verifiable goal |
|---------------|-----------------|
| "Fix the bug" | Write a test that reproduces the bug, then make it pass |
| "Add validation" | Write tests for invalid inputs, then make them pass |
| "Refactor X" | Capture current test output, refactor, assert identical output |
| "Make it faster" | Benchmark current, set target number, benchmark after |
| "Handle edge case Y" | Add test asserting Y is handled, then make it pass |

**Principle:** Every feature/fix should have a test that would have FAILED before the change
and PASSES after. If you cannot write such a test, your goal is not concrete enough.

## Multi-Step Tasks — State the Plan

For any task with more than one step, state the plan as verify-per-step:

```
1. [Step]  → verify: [check]
2. [Step]  → verify: [check]
3. [Step]  → verify: [check]
```

Each "verify" should be a concrete command, test, or observable state — not "looks right".

## Two Self-Checks Before Marking Done

Borrowed from Karpathy's guidelines — apply at the end of every task:

1. **Overcomplication check:** *"Would a senior engineer say this is overcomplicated?"*
   If yes → simplify before shipping. 200 lines that could be 50 is a smell.

2. **Trace check:** *"Does every changed line trace directly to the user's request?"*
   If no → cut the uninvited additions. Don't "improve" adjacent code, comments, or
   formatting unless explicitly asked.

## Surface Tradeoffs, Don't Pick Silently

When a request has ≥2 reasonable interpretations, **present them** — do not silently choose
one and proceed. This is a hard rule, not a suggestion.

- State your assumption explicitly before implementing
- If uncertain which interpretation is correct → ask, don't guess
- If a simpler approach exists than what was requested → say so, let the user decide

**Anti-pattern:** Reading "add user filtering" and silently choosing client-side vs server-side
without asking. Both are valid; the user needs to choose.

## Integration

- **/investigate:** Iron Law already requires root cause. Goal-driven adds: write reproducing
  test BEFORE proposing a fix.
- **/plan:** Plans must include verify-per-step, not just step lists.
- **/review, /paranoid-review:** Use the two self-checks as a final gate before marking findings
  as resolved.
- **self-review hook:** Flag diffs where changed lines don't trace to the task description.
