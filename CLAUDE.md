# CLAUDE.md -- PRISM Playbook

> Plan -> Review -> Implement -> Ship -> Monitor

## This Project

This is the **prism-playbook** repository -- the source code for the PRISM framework itself.
Stack: Bash (setup script), Markdown (SKILL.md files, docs, templates).
Repo: github.com/duyentb95/prism-playbook

## Core Rules

1. **ASK before doing** -- don't jump to code. Ask: "What are you trying to achieve?"
2. **Design before build** -- present approach section by section. Wait for approval.
3. **Plan before execute** -- break complex tasks into micro-tasks. Type GO to start.
4. **Quick tasks (< 15 min)** -- /gsd, no planning needed.
5. **Append knowledge** -- after learning something new, append to .prism/knowledge/.

## PRISM Workflow

Type `/start` to begin -- it detects project state and guides you.

- Think:   /brainstorm, /ceo-review, /eng-review
- Plan:    /plan -> GO
- Build:   /gsd (quick) or sub-agents (complex)
- Check:   /paranoid-review, /qa-check
- Ship:    /ship-it, /document-release
- Learn:   /retro
- Context: /start, /status, /compact, /adhoc, /skill-audit

## Key Constraints

- Zero runtime dependencies for core (bash + markdown only)
- gstack is vendored via git submodule at vendor/gstack/
- Skills must work both globally (~/.claude/skills/) and vendored (.claude/skills/)
- Token budget: keep CLAUDE.md compact -- every token here loads on EVERY request
- All .prism/ files are git-committable (no secrets, no binary)
- Templates in templates/ use {{PLACEHOLDER}} syntax filled by setup script

## Project Structure

```
CLAUDE.md              <- This file (compact project instructions)
PLAYBOOK.md            <- Full framework documentation (reference only)
GETTING-STARTED.md     <- User onboarding guide
README.md              <- GitHub landing page
setup                  <- Install script (bash)
skills/                <- 12 PRISM skill definitions (SKILL.md)
templates/             <- 5 CLAUDE.md templates for target projects
.prism/                <- PRISM's own project knowledge
.prism-template/       <- Template files for new project setup
.claude/commands/      <- 32 slash commands
.claude/settings.json  <- Claude Code settings
vendor/gstack/         <- gstack submodule
```

## Sub-Agent Protocol

Sub-agents end with one of: DONE | DONE_WITH_CONCERNS | BLOCKED | NEEDS_CONTEXT.
Task briefs go in .prism/tasks/TASK_NNN_xxx.md.
Run: `Read .prism/tasks/TASK_NNN_xxx.md and EXECUTE. Assume I am AFK.`

## Token Optimization

- Never pre-load gstack SKILL.md -- lazy load only when command invoked
- One gstack SKILL.md at a time -- drop old before loading new
- Sub-agents read only files specified in task brief, not entire project
- Use .claudecodeignore to exclude node_modules, data/, .git/, build/

## Communication

- Always explain WHY for decisions
- If unclear, ASK -- don't assume
- Structured output for task briefs, reports, plans
- Full framework reference: see PLAYBOOK.md
