Review completed work or sub-agent output.

Target: $ARGUMENTS

If argument is a TASK_NNN:
1. Read task brief from `.prism/tasks/TASK_NNN_*.md`
2. Read the output/changes made
3. Check against Definition of Done
4. Stage 1: Spec Compliance — output matches requirements?
5. Stage 2: Quality Check — code quality, standards, edge cases
6. Report: PASS / CONCERNS / FAIL with details

If argument is a file, branch, or PR:
Load and execute `.claude/skills/code-review/SKILL.md` for deep code review.
