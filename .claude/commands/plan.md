Enter Plan Mode. Brainstorm → Design → Micro-task breakdown.

Topic: $ARGUMENTS

Follow the PRISM planning flow from CLAUDE.md:

1. **Brainstorm** (Socratic): Ask 2-4 clarifying questions about WHY/WHO/WHAT
2. **CEO Review**: "Are we building the right thing?" — reframe problem, find 10-star version, scope back
3. **Eng Review**: Architecture diagram, data flow, failure modes, edge cases, test matrix
4. **Micro-Task Plan**: Break into tasks (2-10 min each) with exact file paths + verification steps
5. Present task board with model tiers, dependencies, parallel groups, cost estimate
6. WAIT for user to type `GO` or `CONFIRMED`
7. On confirm → write tasks to `.prism/tasks/` and update MASTER_PLAN.md

Shortcuts:
- If user said `--skip-brainstorm` → skip questions, go straight to design
- If user said `--skip-ceo` → skip CEO review
- If user said `--eng-only` → only do Eng review + plan

## Gate Integration

After user says `GO` or `CONFIRMED` and tasks are written to MASTER_PLAN.md:

1. If `.prism/GATE_STATUS.md` exists, replace `- [ ] plan-approved` with:
   ```
   - [x] plan-approved (<today's date>) — <N> tasks approved
   ```
2. If `.prism/GATE_STATUS.md` doesn't exist, create it from `.prism-template/GATE_STATUS.md` format, then mark plan-approved.
