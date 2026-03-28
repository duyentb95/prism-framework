# PRISM — AI Team Playbook

> **P**lan → **R**eview → **I**mplement → **S**hip → **M**onitor
>
> Make Claude Code 2-3x more productive. Stop guessing, start structuring.

---

## What is PRISM?

A set of conventions, templates, and pre-built skills that make Claude Code work like a professional AI team — not just a chatbot that writes code.

**Not a library. Not a platform. A playbook.** Copy it, use it, forget it's there.

```
WITHOUT PRISM:
  You → "Build me an API" → Claude writes 500 lines → wrong → fix → fix → lost context

WITH PRISM:
  You → "Build me an API" → Claude asks WHY → designs → you approve → executes correctly
  Knowledge saved → next session picks up where you left off
```

---

## Install (1 minute)

Copy the `.claude/` folder into your project:

```bash
# Clone PRISM
git clone https://github.com/duyentb95/prism-playbook.git

# Copy into your project
cp -r prism-playbook/.claude ~/my-project/.claude
cp -r prism-playbook/skills ~/my-project/.claude/skills-global  # optional: agent skills
```

Then open your project and run `/init-prism`:

```bash
cd ~/my-project
claude
> /init-prism
```

PRISM asks about your project (name, stack, audience) and generates a tailored `CLAUDE.md` + `.prism/` folder. Commit them to git — teammates get the context automatically.

---

## Use It

```bash
cd ~/my-project
claude

# Type /start — PRISM detects state and guides you
> /start

# Or use specific commands:
> /plan Build user authentication with JWT
> /paranoid-review
> /ship
```

### Gate Flow (enforced for complex tasks)

```
/plan → /ceo-review → /eng-review → implement → /review → /ship
```

Each gate must pass before the next. `/gsd` bypasses all gates for quick tasks < 15 min.

### Core Commands

| Command | What it does |
|---------|-------------|
| `/start` | Smart entry — detects state, suggests next step |
| `/plan [task]` | Break into micro-tasks, design first |
| `GO` | Approve plan, start execution |
| `/gsd [task]` | Just do it, no planning (< 15 min) |
| `/ceo-review` | "Am I building the right thing?" |
| `/eng-review` | Architecture, diagrams, edge cases |
| `/review` | Pre-merge code review with auto-fix |
| `/ship` | Full ship: test, version, commit, push, PR |
| `/paranoid-review` | Find production bugs before they find you |
| `/qa-only` | Report-only QA (no fixes) |
| `/investigate` | Systematic root-cause debugging |
| `/office-hours` | YC Office Hours — startup/builder brainstorm |
| `/retro` | Sprint retrospective |
| `/compact` | Save state, resume in fresh session |
| `/careful` / `/freeze` / `/guard` | Safety modes |

---

## What You Get

### 1. CLAUDE.md — Project Instructions for Claude

Tells Claude how to think about your project. Pick a template:
- **[Minimal](templates/claude-minimal.md)** — Smallest useful starting point
- **[Web App](templates/claude-web-app.md)** — Next.js, React, Vue, Svelte
- **[API Backend](templates/claude-api-backend.md)** — Python, Node, Go, Rust
- **[Data Pipeline](templates/claude-data-pipeline.md)** — ETL, analytics, notebooks
- **[Non-Code](templates/claude-non-code.md)** — Reports, strategy, documentation

### 2. .prism/ — Shared Knowledge

```
.prism/
├── CONTEXT_HUB.md       # WHY this project exists, WHO it's for
├── MASTER_PLAN.md       # Task board — what's done, what's next
├── GATE_STATUS.md       # Gate flow status (plan → review → ship)
├── knowledge/
│   ├── RULES.md         # Patterns ("always do X when Y")
│   ├── GOTCHAS.md       # Traps ("don't do Z because...")
│   └── TECH_DECISIONS.md # Architecture choices + reasoning
├── tasks/               # Sub-agent task briefs
└── qa-reports/          # QA results, review findings
```

**Commit `.prism/` to git.** Teammates pull → their Claude has all the context.

### 3. Built-in Skills (zero external dependencies)

All skills live in `.claude/skills/` — no external installs needed.

| Skill | Role |
|-------|------|
| ceo-review | Product validation, scope challenge |
| eng-review | Architecture, edge cases, test coverage |
| code-review | Pre-landing diff review with auto-fix |
| ship | Full ship automation (version, PR) |
| investigate | Root-cause debugging |
| document-release | Post-ship doc sync |
| safety | Careful mode, freeze, guard |

---

## Requirements

| Required | Install |
|----------|---------|
| **Claude Code** | `npm install -g @anthropic-ai/claude-code` |
| **Claude account** | [claude.ai](https://claude.ai) (Pro or Max) |
| **Git** | [git-scm.com](https://git-scm.com) |

---

**Full guide:** [GETTING-STARTED.md](GETTING-STARTED.md) | **License:** MIT
