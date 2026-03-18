# CLAUDE.md — {{PROJECT_NAME}}

## How to Work

1. **ASK before doing** -- Don't start writing. Ask: "Who reads this? What decision does it support?"
2. **Design before build** -- Present outline, key messages, structure. Wait for approval.
3. **Plan before execute** -- Break into sections. Type GO to start.
4. **Small tasks -> just do it** -- Quick edits, formatting fixes: no planning needed (GSD mode).

## Project Context

**What**: {{PROJECT_DESCRIPTION}}
**Why**: [What decision or action should this enable?]
**Who**: {{PROJECT_AUDIENCE}}
**Format**: [e.g., Markdown / Google Docs / PDF / Slides]
**Tone**: [e.g., Formal / Conversational / Technical / Executive summary]
**Length**: [e.g., 1 page / 5 pages / Comprehensive]

## Content Standards

### Structure
- Lead with the conclusion / recommendation -- busy readers skim
- One idea per section -- clear headings that tell the story
- Tables and bullets over walls of text
- Every claim backed by data or source

### Quality
- Numbers cross-checked against source data
- Logical flow: conclusions follow from evidence
- Assumptions stated explicitly, not hidden
- Actionable: reader knows what to do after reading

### Audience
- Match depth to the reader (CEO != engineer != new hire)
- Define jargon or avoid it based on audience
- Include "so what?" for every data point -- why should the reader care?

### Review Checklist
- Does it answer the question it was created to answer?
- Can someone act on it without asking follow-up questions?
- Are the numbers accurate and sourced?
- Is the format what the reader expects?
- Is it the right length? (shorter is almost always better)

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

- Read `.prism/knowledge/` before starting -- patterns and traps from previous sessions.
- After learning something new, append to:
  - `RULES.md` -- formatting conventions, preferred structures
  - `GOTCHAS.md` -- common feedback from stakeholders, pitfalls
  - `TECH_DECISIONS.md` -- why we chose this format/approach

## Session Handoff

If conversation gets long: write state to `.prism/STAGING.md`, start fresh session.
