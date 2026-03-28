# Getting Started with PRISM

> Zero to productive in 10 minutes. No prior knowledge of "agents" or "skills" needed.

---

## 1. Install

Copy the `.claude/` folder into your project:

```bash
git clone https://github.com/duyentb95/prism-playbook.git
cp -r prism-playbook/.claude ~/my-project/.claude
```

That's it. PRISM commands and skills are now available in your project.

---

## 2. Initialize Your Project

```bash
cd ~/my-project
claude
> /init-prism
```

PRISM asks about your project (~30 seconds), then creates:

- **`CLAUDE.md`** — instructions for Claude, tailored to your project type
- **`.prism/`** — shared knowledge folder with your answers
- **`.prism/GATE_STATUS.md`** — tracks the plan → review → ship flow

---

## 3. Your First 5 Minutes

Type `/start` — PRISM detects your project state and guides you:

```
> /start

Welcome to My Cool App!
  Sprint: #1 — No tasks yet

  What would you like to do?
  A) I have a new idea — let's brainstorm        → /brainstorm
  B) I know what to build — let's plan            → /plan
  C) Quick fix or small task — just do it          → /gsd
```

### Example: "I want a todo app"

```
YOU:  /start → Choose A (brainstorm)

YOU:  I want a todo app with smart prioritization

CLAUDE: [Asks 3-4 questions: WHO uses it? Mobile or web? What makes it "smart"?]

YOU:  For myself, web app, prioritize by deadline + energy level

CLAUDE: [Presents design] "Ready to plan? Type /plan"

YOU:  /plan → Claude breaks into micro-tasks → "Type GO to start."

YOU:  GO → Claude executes
```

---

## 4. Gate Flow — The PRISM Workflow

For complex tasks, PRISM enforces a gate flow:

```
/plan → /ceo-review → /eng-review → implement → /review → /ship
```

Each step must complete before the next. Gates are soft — you can override.

For quick tasks (< 15 min), use `/gsd` — bypasses all gates.

### Three Workflows — Pick One

**New Project / New Idea:**
```
/start → /brainstorm → /plan → GO
```

**Feature / Sprint Task:**
```
/plan Build user auth with JWT → GO
```

**Quick Fix (< 15 min):**
```
/gsd Fix the login button not working on mobile
```

---

## 5. Command Map

```
    THINK                PLAN              BUILD
 ┌──────────┐      ┌──────────┐      ┌──────────┐
 │/brainstorm│─────▶│  /plan   │─────▶│   GO     │
 │/ceo-review│      │          │      │  /gsd    │
 │/eng-review│      │          │      │          │
 └──────────┘      └──────────┘      └──────────┘
                                           │
                                           ▼
    LEARN               SHIP              CHECK
 ┌──────────┐      ┌──────────┐      ┌──────────┐
 │  /retro  │◀─────│  /ship   │◀─────│/paranoid │
 │          │      │/doc-release│     │/qa-check │
 └──────────┘      └──────────┘      └──────────┘

 Navigation: /start · /status · /compact · /adhoc
```

### All Commands

| Phase | Command | What it does |
|-------|---------|-------------|
| **Start** | `/start` | Smart entry — detects state, guides next step |
| **Think** | `/brainstorm [idea]` | Socratic exploration |
| | `/office-hours [topic]` | YC-style startup diagnostic / builder brainstorm |
| | `/ceo-review` | "Are we building the right thing?" |
| | `/eng-review` | Architecture, diagrams, edge cases |
| **Plan** | `/plan [task]` | Brainstorm → design → micro-tasks |
| **Build** | `GO` | Approve plan, start execution |
| | `/gsd [task]` | Do it now, no planning |
| **Check** | `/paranoid-review` | Find production bugs |
| | `/qa-check` | Verify output with evidence |
| | `/qa-only` | Report-only QA (no fixes) |
| **Ship** | `/ship` | Test, version, commit, push, PR |
| | `/document-release` | Update docs to match what shipped |
| **Debug** | `/investigate` | Systematic root-cause debugging |
| **Learn** | `/retro` | Sprint retrospective |
| **Context** | `/status` | Current sprint overview |
| | `/compact` | Save state for session handoff |
| | `/adhoc [task]` | Handle out-of-scope request |
| **Safety** | `/careful` | Destructive command warnings |
| | `/freeze [dir]` | Restrict edits to a directory |
| | `/guard` | Maximum safety (careful + freeze) |

---

## 6. Running Sub-Agents (for complex tasks)

When Claude creates task briefs, run each in a separate terminal:

```bash
# Terminal 2
claude
> Read .prism/tasks/TASK_002_database.md and EXECUTE. Assume I am AFK.

# Terminal 3 (parallel)
claude
> Read .prism/tasks/TASK_003_auth.md and EXECUTE. Assume I am AFK.
```

Back in your main terminal:
```
> Review TASK_002 and TASK_003
```

---

## 7. Tips

1. **Type `/start` when unsure** — it reads your project state and tells you what to do.
2. **Always say WHY** — "Build dashboard" is weak. "Build dashboard to track trading bot PnL every morning" is strong.
3. **Review the plan before GO** — 2 minutes reviewing saves 30 minutes fixing.
4. **`/compact` when sessions get long** — keeps Claude sharp.
5. **Commit `.prism/`** — knowledge persists across sessions and team members.

---

## 8. Team Use

No special setup. Just commit `.prism/` to git:

```bash
git add .prism/ CLAUDE.md .claude/
git commit -m "Add PRISM playbook"
git push
```

Teammates pull → their Claude reads the same context. Knowledge compounds.

---

## 9. Choosing a CLAUDE.md Template

| Template | Best for |
|----------|---------|
| [Minimal](templates/claude-minimal.md) | Quick start, small projects |
| [Web App](templates/claude-web-app.md) | Frontend + full-stack |
| [API Backend](templates/claude-api-backend.md) | REST/GraphQL APIs |
| [Data Pipeline](templates/claude-data-pipeline.md) | ETL, analytics |
| [Non-Code](templates/claude-non-code.md) | Reports, strategy, docs |

---

## 10. FAQ

**"How do I install PRISM?"**
Copy `.claude/` into your project, run `/init-prism`. No bash scripts needed.

**"How much does it cost?"**
PRISM is free. You pay for Claude: Pro ($20/mo) or Max ($100/mo recommended).

**"Claude still jumps straight to code?"**
Check that `CLAUDE.md` exists at your project root. Claude reads it automatically.

**"Sub-agent is BLOCKED?"**
Read the task brief → HANDOVER section. Add missing context, re-run.

**"I don't know which command to use."**
Type `/start`.

---

**Full command reference:** See [README.md](README.md)
