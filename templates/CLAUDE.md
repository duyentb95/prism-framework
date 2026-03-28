# CLAUDE.md — {{PROJECT_NAME}}

> Plan -> Review -> Implement -> Ship -> Monitor

## How to Work

1. **ASK before doing** -- Don't jump to code. Ask: "What are you trying to achieve?"
2. **Design before build** -- Present approach section by section. Wait for approval.
3. **Plan before execute** -- Break complex tasks into micro-tasks. Type GO to start.
4. **Quick tasks (< 15 min)** -- /gsd, no planning needed.
5. **Append knowledge** -- After learning something new, append to .prism/knowledge/.

## Project Context

**What**: {{PROJECT_DESCRIPTION}}
**Why**: {{PROJECT_WHY}}
**Who**: {{PROJECT_AUDIENCE}}
**Stack**: {{TECH_STACK}}

## PRISM Workflow

Type `/start` to begin -- it detects your project state and guides you.

### Gate Flow (enforced for complex tasks)
```
/plan → /ceo-review → /eng-review → implement → /review → /ship
```
Each gate must pass before the next. `/gsd` bypasses all gates for quick tasks.
Gate status tracked in `.prism/GATE_STATUS.md`.

### Quick Reference
- Think:   /brainstorm, /office-hours, /ceo-review, /eng-review
- Plan:    /plan -> GO
- Build:   /gsd (quick) or sub-agents (complex)
- Check:   /paranoid-review, /qa-check, /qa-only
- Ship:    /ship, /document-release
- Learn:   /retro
- Context: /start, /status, /compact, /adhoc
- Safety:  /careful, /freeze, /guard, /investigate

## Key Constraints

- All skills are local in `.claude/skills/` -- zero external dependencies
- All `.prism/` files are git-committable (no secrets, no binary)
- Templates use `{{PLACEHOLDER}}` syntax filled during /init-prism

## Sub-Agent Protocol

Sub-agents end with: DONE | DONE_WITH_CONCERNS | BLOCKED | NEEDS_CONTEXT.
Task briefs: `.prism/tasks/TASK_NNN_xxx.md`
Run: `Read .prism/tasks/TASK_NNN_xxx.md and EXECUTE. Assume I am AFK.`

## Knowledge

- Read `.prism/knowledge/` before starting -- patterns and traps from previous sessions.
- After learning something new, append to:
  - `RULES.md` -- patterns ("always do X when Y")
  - `GOTCHAS.md` -- traps ("don't do Z because...")
  - `TECH_DECISIONS.md` -- architecture choices + reasoning

## Session Handoff

If conversation gets long: run /compact to save state, resume in fresh session.
