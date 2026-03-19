Smart entry point. Detects state, guides next step.

## Preamble (run first)

```bash
_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
_PRISM=$([ -d ".prism" ] && echo "true" || echo "false")
_HAS_PLAN=$([ -f ".prism/MASTER_PLAN.md" ] && echo "true" || echo "false")
_HAS_STAGING=$([ -f ".prism/STAGING.md" ] && echo "true" || echo "false")
_HAS_CONTEXT=$([ -f ".prism/CONTEXT_HUB.md" ] && echo "true" || echo "false")
_TASK_COUNT=$(ls .prism/tasks/TASK_*.md 2>/dev/null | wc -l | tr -d ' ')
_DONE_TASKS=$(grep -c '✅' .prism/MASTER_PLAN.md 2>/dev/null || echo "0")
_PENDING_TASKS=$(grep -c '⏳\|🔄' .prism/MASTER_PLAN.md 2>/dev/null || echo "0")
_BLOCKED_TASKS=$(grep -c '❌' .prism/MASTER_PLAN.md 2>/dev/null || echo "0")
echo "BRANCH=$_BRANCH PRISM=$_PRISM PLAN=$_HAS_PLAN STAGING=$_HAS_STAGING CONTEXT=$_HAS_CONTEXT"
echo "TASKS: total=$_TASK_COUNT done=$_DONE_TASKS pending=$_PENDING_TASKS blocked=$_BLOCKED_TASKS"
```

## Routing Logic

Based on preamble results, follow ONE of these paths:

### Path 1: No PRISM initialized (`_PRISM=false`)
```
"This project doesn't have PRISM set up yet.
 Run this from your prism-playbook directory:
   ./setup --project $(pwd)
 Then come back and type /start"
```
STOP here.

### Path 2: Has staging file (`_HAS_STAGING=true`)
```
"Welcome back! You have a saved session."
```
Read `.prism/STAGING.md` and summarize:
- Where you left off
- What's next
- Ask: "Continue from here? Or start fresh?"

### Path 3: No tasks yet (`_TASK_COUNT=0` and `_PENDING_TASKS=0`)
Read `.prism/CONTEXT_HUB.md` to get project name and description.
```
"🧭 Welcome to [project name]!
   [project description — 1 line from CONTEXT_HUB]
   Sprint: #1 — No tasks yet

   What would you like to do?
   A) I have a new idea — let's brainstorm           → will run /brainstorm
   B) I know what to build — let's plan               → will run /plan
   C) Quick fix or small task — just do it             → will run /gsd
   D) Show me what PRISM can do                        → will show command map"
```
Wait for user choice, then route to the appropriate command.

If user picks D, show the command map:
```
THINK:   /brainstorm (explore ideas) → /ceo-review (validate direction) → /eng-review (design)
PLAN:    /plan (decompose into tasks) → GO (approve & execute)
BUILD:   /gsd (quick tasks) · sub-agents (complex tasks)
CHECK:   /paranoid-review (find bugs) → /qa-check (verify output)
SHIP:    /ship-it (push code) → /document-release (update docs)
LEARN:   /retro (sprint retrospective)
CONTEXT: /status (where am I?) · /compact (save session) · /adhoc (handle interruptions)
```

### Path 4: Has blocked tasks (`_BLOCKED_TASKS > 0`)
Read `.prism/MASTER_PLAN.md` and show:
```
"⚠️ You have [N] blocked task(s):
   - TASK_XXX: [reason]

   A) Unblock — provide missing context
   B) Skip — move to next available task
   C) Re-plan — re-scope the blocked work"
```

### Path 5: Has pending tasks (`_PENDING_TASKS > 0`)
Read `.prism/MASTER_PLAN.md` and show:
```
"🔄 Sprint in progress — [done]/[total] tasks complete

   Next up: TASK_XXX — [task name]

   A) Continue — work on next task
   B) Review — check completed work
   C) Ship — everything's done, let's ship
   D) Status — full sprint overview"
```

### Path 6: All tasks done (`_PENDING_TASKS=0` and `_DONE_TASKS > 0`)
```
"✅ All tasks complete! What's next?

   A) /paranoid-review — find bugs before shipping
   B) /ship-it — sync, test, commit, push
   C) /retro — sprint retrospective
   D) /plan — start next sprint"
```

## Rules
- ALWAYS read CONTEXT_HUB.md to personalize the greeting with project name
- Keep output SHORT — this is a navigation aid, not a report
- After user chooses, route to the appropriate command immediately
- If user types something that's not A/B/C/D, treat it as a direct request and route accordingly
