Report-only QA. Test but don't fix.

Target: $ARGUMENTS

## Process

1. **Discover** — Read project structure, identify entry points, tech stack
2. **Plan test matrix** — Map features to test cases, prioritize by risk
3. **Execute tests** — For each test case:
   - Run the relevant code/command
   - Check expected vs actual behavior
   - Capture evidence (error messages, stack traces, unexpected output)
4. **Classify findings** by severity:
   - CRITICAL — crashes, data loss, security holes
   - HIGH — broken features, wrong output
   - MEDIUM — edge cases, degraded UX
   - LOW — cosmetic, minor inconsistencies

## Output Format

```
QA REPORT — [project] @ [branch]
Date: [date]
Health Score: [0-100]

CRITICAL ([N])
  - [description] | Repro: [steps] | Expected: [X] | Actual: [Y]

HIGH ([N])
  - [description] | Repro: [steps]

MEDIUM ([N])
  - [description]

LOW ([N])
  - [description]

Ship readiness: [READY / NOT READY — list blockers]
```

## Rules
- REPORT ONLY — do NOT fix anything, do NOT edit any files
- Save report to `.prism/qa-reports/qa_{date}.md`
- If project has tests, run them: `npm test`, `pytest`, etc.
- Focus on behavior, not code style
