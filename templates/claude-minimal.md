# CLAUDE.md — {{PROJECT_NAME}}

## How to Work

1. **ASK before doing** -- Don't jump to code. Ask: "What are you trying to achieve?"
2. **Design before build** -- Present the approach section by section. Wait for approval.
3. **Plan before execute** -- Break complex tasks into micro-tasks. Type GO to start.
4. **Small tasks -> just do it** -- If < 15 minutes, no planning needed (GSD mode).

## Project Context

**What**: {{PROJECT_DESCRIPTION}}
**Why**: [Why does it exist? What problem does it solve?]
**Who**: {{PROJECT_AUDIENCE}}
**Stack**: {{TECH_STACK}}

## PRISM Workflow

Type `/start` to begin -- it detects your project state and guides you.

### Quick Reference
- Think:   /brainstorm, /ceo-review, /eng-review
- Plan:    /plan -> GO
- Build:   /gsd (quick) or sub-agents (complex)
- Check:   /paranoid-review, /qa-check
- Ship:    /ship-it, /document-release
- Learn:   /retro
- Context: /start, /status, /compact, /adhoc

### Rules
- NEVER jump straight to code. Ask WHY first, design, then plan.
- Complex tasks: /plan -> wait for GO -> execute.
- Quick tasks (< 15 min): /gsd -- no planning needed.
- Long sessions: /compact to save state, resume in fresh session.
- Knowledge: append to .prism/knowledge/ when you learn something new.

## Knowledge

- Read `.prism/knowledge/` before starting -- it contains patterns and traps from previous sessions.
- After learning something new, append to the appropriate file:
  - `RULES.md` -- patterns ("always do X when Y")
  - `GOTCHAS.md` -- traps ("don't do Z because...")
  - `TECH_DECISIONS.md` -- architecture choices + reasoning

## Session Handoff

If the conversation gets long and Claude starts forgetting:
1. Write current state to `.prism/STAGING.md`
2. User opens fresh session: `Read .prism/STAGING.md and resume`
