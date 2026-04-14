# Ship — Test Coverage Audit (Layer 3)

> Loaded on-demand by `SKILL.md` Step 3.4.
> Evaluate what was ACTUALLY coded (from the diff), not what was planned.
> Every untested path is where bugs hide.

---

## 1. Trace every codepath changed

Using `git diff origin/<base>...HEAD`:

Read every changed file. For each one:
- Read the full file (not just diff hunks) to understand context
- Identify every function/method added or modified
- Identify every conditional branch (if/else, switch, ternary, guard clause, early return)
- Identify every error path (try/catch, rescue, error boundary, fallback)

## 2. Check each branch against existing tests

For each code path, search for a test that exercises it:
- Function `processPayment()` — look for `billing.test.ts`, `billing.spec.ts`, `test/billing_test.rb`
- An if/else — look for tests covering BOTH paths
- An error handler — look for a test that triggers that specific error condition

**Quality scoring rubric:**
- 3 stars: Tests behavior with edge cases AND error paths
- 2 stars: Tests correct behavior, happy path only
- 1 star: Smoke test / existence check / trivial assertion

## 3. Map key user flows and error states

For each changed feature, think through:
- **User flows:** What sequence of actions touches this code? Each step needs a test.
- **Error states the user sees:** For every error the code handles, what does the user experience?
  Is there a clear error message or a silent failure? Can the user recover?
- **Empty/zero/boundary states:** What happens with zero results? Maximum input? Null values?

Add these alongside code branches in your mental model.

## 4. Output ASCII coverage diagram

```
CODE PATH COVERAGE
===========================
[+] src/services/billing.ts
    |
    +-- processPayment()
    |   +-- [3-STAR TESTED] Happy path + card declined -- billing.test.ts:42
    |   +-- [GAP]           Network timeout -- NO TEST
    |   +-- [GAP]           Invalid currency -- NO TEST
    |
    +-- refundPayment()
        +-- [2-STAR TESTED] Full refund -- billing.test.ts:89
        +-- [1-STAR TESTED] Partial refund (checks non-throw only) -- billing.test.ts:101

USER FLOW COVERAGE
===========================
[+] Payment checkout flow
    |
    +-- [3-STAR TESTED] Complete purchase -- checkout.e2e.ts:15
    +-- [GAP]           Form validation errors -- NO TEST
    +-- [GAP]           Empty cart submission -- NO TEST

-------------------------------------
COVERAGE: 3/7 paths tested (43%)
  Code paths: 3/5 (60%)
  User flows: 0/2 (0%)
QUALITY:  3-star: 1  2-star: 1  1-star: 1
GAPS: 4 paths need tests
-------------------------------------
```

**Fast path:** All paths covered — "Step 3.4: All new code paths have test coverage." Continue.

## 5. Generate tests for uncovered paths

If a test framework is available:
- Prioritize error handlers and edge cases first
- Read 2-3 existing test files to match conventions exactly
- Generate unit tests with real assertions (never `expect(x).toBeDefined()`)
- Run each test. Passes — commit as `test: coverage for {feature}`
- Fails — fix once. Still fails — revert, note gap in diagram.

**Caps:** 20 code paths max, 10 tests generated max, 2-min per-test exploration cap.

If no test framework — diagram only, no generation. Note: "Test generation skipped — no test framework configured."

**Diff is test-only changes:** Skip Step 3.4 entirely: "No new application code paths to audit."

## 6. Coverage summary for PR body

```bash
find . -name '*.test.*' -o -name '*.spec.*' -o -name '*_test.*' -o -name '*_spec.*' | grep -v node_modules | wc -l
```

`Test Coverage Audit: N code paths. M covered (X%). K tests generated, J committed.`
