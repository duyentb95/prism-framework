---
name: context-compactor
version: 1.0.0
description: |
  Compacts current session context into a portable snapshot for session handoff.
  Triggers: compact context, save state, session handoff, wrap up, staging,
  context too long, reset session, summarize progress.
  Reduces token consumption 40-60% by extracting only essential state.
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Bash
  - AskUserQuestion
model: sonnet
---

## Preamble (run first)

```bash
_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
_HAS_STAGING=$([ -f ".prism/STAGING.md" ] && echo "true" || echo "false")
_HAS_PLAN=$([ -f ".prism/MASTER_PLAN.md" ] && echo "true" || echo "false")
_TASK_COUNT=$(find .prism/tasks -name "TASK_*.md" 2>/dev/null | wc -l | tr -d ' ')
echo "BRANCH: $_BRANCH | STAGING_EXISTS: $_HAS_STAGING | PLAN: $_HAS_PLAN | TASKS: $_TASK_COUNT"
```

If `_HAS_STAGING` is `true`: warn user that a previous staging file exists and will be overwritten.

## AskUserQuestion Format

**ALWAYS follow this structure for every AskUserQuestion call:**
1. **Re-ground:** State the project, the current branch (use the `_BRANCH` value printed by the preamble — NOT any branch from conversation history or gitStatus), and what you're about to compact. (1-2 sentences)
2. **Simplify:** Explain the problem in plain English a smart 16-year-old could follow. No raw function names, no internal jargon, no implementation details. Use concrete examples and analogies. Say what it DOES, not what it's called.
3. **Recommend:** `RECOMMENDATION: Choose [X] because [one-line reason]`
4. **Options:** Lettered options: `A) ... B) ... C) ...`

Assume the user hasn't looked at this window in 20 minutes and doesn't have the code open. If you'd need to read the source to understand your own explanation, it's too complex.

---

# Context Compactor

Extract the essential state from the current session and write a compact snapshot
that allows a new session to resume without loss of critical information.

---

## Step 0: When to Activate

- User explicitly requests: "Compact context", "Save state", "Wrap up session"
- Master-Agent detects conversation is getting long (>50 exchanges)
- Before switching between major phases or sprints
- Signs of context degradation: contradictory answers, re-asking answered questions, hallucinations

---

## Step 1: Gather State

Read and extract key info from:

1. `.prism/MASTER_PLAN.md` → task statuses, current sprint
2. Current conversation → decisions made, open questions, blockers
3. `.prism/knowledge/` → any new entries added this session
4. Any files created/modified this session (use `git diff --stat` if in a git repo)
5. `.prism/tasks/` → any in-progress task briefs with handover status

---

## Step 2: Write Snapshot

Create/overwrite `.prism/STAGING.md`:

```markdown
# STAGING — Session Snapshot
**Date**: [YYYY-MM-DD HH:mm UTC+7]
**Branch**: [_BRANCH value]
**Session purpose**: [What this session was working on]

## Task Progress
| Task | Status | Notes |
|------|--------|-------|
| TASK_001 | ✅ | Completed — [1-line summary] |
| TASK_002 | 🔄 | In progress — [exactly where we left off] |
| TASK_003 | ⏳ | Not started |

## Decisions Made This Session
1. [Decision + reasoning]
2. [Decision + reasoning]

## Open Questions / Blockers
- [Question that needs human input]
- [Blocker waiting on external dependency]

## Files Modified This Session
- `path/file1` — [what changed]
- `path/file2` — [what changed]

## Knowledge Added
- [Any new entries in RULES.md, GOTCHAS.md, or TECH_DECISIONS.md]

## Resume Instructions
To continue this work:
1. Read this file (`.prism/STAGING.md`)
2. Read `.prism/MASTER_PLAN.md` for full task board
3. Next action: [specific next step with exact command to run]
```

---

## Output Schema

### STAGING.md Format (STRICT)
```markdown
# STAGING — Session Snapshot
**Date**: [YYYY-MM-DD HH:mm UTC+7]
**Branch**: [exact branch name]
**Project**: [project name from CONTEXT_HUB or directory name]
**Session purpose**: [1 sentence]
**Session duration**: ~[N] exchanges

## Task Progress
| Task | Status | Summary | Next Step |
|------|--------|---------|-----------|
| TASK_001 | ✅ | [done what] | — |
| TASK_002 | 🔄 | [at what point] | [exact next action] |
| TASK_003 | ⏳ | Not started | [what to do first] |

## Decisions Made This Session
1. **[Topic]**: [Decision] — because [reason]

## Open Questions / Blockers
- ❓ [Question needing human input]
- 🚫 [Blocker with dependency info]
[or: None]

## Files Modified This Session
- `path/file` — [what changed]
[or: No files modified]

## Knowledge Added
- Added to RULES.md: [entry summary]
- Added to GOTCHAS.md: [entry summary]
[or: No knowledge entries this session]

## Resume Instructions
1. Read `.prism/STAGING.md` (this file)
2. Read `.prism/MASTER_PLAN.md`
3. **Next action**: [specific command or step — copy-pasteable]
```

---

## Step 3: Signal User

Output exactly: **"Context consolidated into `.prism/STAGING.md`. Safe to start a fresh session. Resume with: `Read .prism/STAGING.md and resume`"**

Do not add extra commentary. The user knows what to do.
