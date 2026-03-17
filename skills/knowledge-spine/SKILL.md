---
name: knowledge-spine
version: 1.0.0
description: |
  Maintains the project's accumulated knowledge across sessions and agents.
  Triggers: update knowledge, lessons learned, add rule, add gotcha, document decision,
  what did we learn, extract rules, reverse pattern, update docs.
  Always APPEND, never rewrite entire files.
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - AskUserQuestion
model: sonnet
---

## Preamble (run first)

```bash
_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
_RULES=$([ -f ".prism/knowledge/RULES.md" ] && wc -l < .prism/knowledge/RULES.md | tr -d ' ' || echo "0")
_GOTCHAS=$([ -f ".prism/knowledge/GOTCHAS.md" ] && wc -l < .prism/knowledge/GOTCHAS.md | tr -d ' ' || echo "0")
_DECISIONS=$([ -f ".prism/knowledge/TECH_DECISIONS.md" ] && wc -l < .prism/knowledge/TECH_DECISIONS.md | tr -d ' ' || echo "0")
echo "BRANCH: $_BRANCH | RULES: ${_RULES}L | GOTCHAS: ${_GOTCHAS}L | DECISIONS: ${_DECISIONS}L"
```

## AskUserQuestion Format

**ALWAYS follow this structure for every AskUserQuestion call:**
1. **Re-ground:** State the project, the current branch (use the `_BRANCH` value printed by the preamble — NOT any branch from conversation history or gitStatus), and what knowledge you're about to capture. (1-2 sentences)
2. **Simplify:** Explain the problem in plain English a smart 16-year-old could follow. No raw function names, no internal jargon, no implementation details. Use concrete examples and analogies. Say what it DOES, not what it's called.
3. **Recommend:** `RECOMMENDATION: Choose [X] because [one-line reason]`
4. **Options:** Lettered options: `A) ... B) ... C) ...`

Assume the user hasn't looked at this window in 20 minutes and doesn't have the code open. If you'd need to read the source to understand your own explanation, it's too complex.

---

# Knowledge Spine

You are the project's institutional memory. You capture, organize, and surface knowledge
so that no lesson is lost across sessions, agents, or team members.

---

## Step 0: Identify Knowledge Type

Classify what needs to be captured:

| Type | File | When |
|------|------|------|
| Pattern / Rule | `.prism/knowledge/RULES.md` | Extracted from templates, code, or repeated decisions |
| Gotcha / Lesson | `.prism/knowledge/GOTCHAS.md` | Bug found, trap discovered, "things that don't work like you'd expect" |
| Architecture Decision | `.prism/knowledge/TECH_DECISIONS.md` | Major technical choice with alternatives considered |
| Terminology | `.prism/DICTIONARY.md` | New project-specific term introduced |
| Standard Update | `.prism/CONTEXT_HUB.md` | Project-wide standard changed |

---

## Step 1: Write Entry

### For `.prism/knowledge/RULES.md` — Patterns & Rules

Append:
```markdown
## [Category] — [Rule Name]
- **Rule**: [What to do / not do]
- **Source**: [Which template, task, or code]
- **Date**: [YYYY-MM-DD]
```

### For `.prism/knowledge/GOTCHAS.md` — Traps & Lessons

Append:
```markdown
## [Date] — [Short Title]
- **Problem**: [What went wrong]
- **Root cause**: [Why it happened]
- **Fix**: [How it was resolved]
- **Prevention**: [How to avoid next time]
- **Source**: [Task/session that discovered this]
```

### For `.prism/knowledge/TECH_DECISIONS.md` — ADR-lite

Append:
```markdown
## [Date] — [Decision Title]
- **Context**: [What prompted this decision]
- **Decision**: [What we decided]
- **Alternatives**: [What else we considered]
- **Reasoning**: [Why this choice]
- **Consequences**: [What this means going forward]
```

---

## Step 2: Verify

After appending:
1. Read the file back to confirm the entry was written correctly
2. Check for duplicates — if a similar entry already exists, update it instead of adding a duplicate
3. Keep each entry to 2-5 lines max. Detailed docs go in separate files.

---

## Key Rules

1. **ALWAYS append** — Never rewrite entire knowledge files. Add new entries at the bottom.
2. **Date everything** — Every entry has a date for traceability.
3. **Source everything** — Note which task/session produced this knowledge.
4. **Keep it short** — 2-5 lines per entry. Longer analysis goes in `.prism/designs/` or `.prism/retros/`.
5. **Shareable via Git** — This folder is committed to repo so the whole team benefits.

---

## Reverse Patterning

When user provides a template/screenshot/sample output:

1. Read/view the sample carefully
2. Extract: layout structure, color scheme, data patterns, interaction model, naming conventions
3. Write extracted rules to `.prism/knowledge/RULES.md` with `Source: [template path]`
4. Reference the template path so future agents can consult the original
