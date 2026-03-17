# Getting Started with PRISM Framework
# Hướng dẫn tích hợp PRISM Framework

> **For beginners** — You don't need to know anything about "agents", "skills", or "subagents".
> Basic terminal knowledge is enough. This guide takes you from zero to running in 15 minutes.
>
> **Dành cho người mới** — Bạn không cần biết gì về "agents", "skills", hay "subagents".
> Chỉ cần biết dùng terminal cơ bản là đủ. Hướng dẫn này đưa bạn từ zero → chạy được trong 15 phút.

---

## Table of Contents / Mục lục

1. [What problem does this solve?](#1-what-problem-does-this-solve)
2. [Prerequisites](#2-prerequisites)
3. [Step-by-step installation](#3-step-by-step-installation)
4. [First-time usage walkthrough](#4-first-time-usage-walkthrough)
5. [5 real-world scenarios](#5-real-world-scenarios)
6. [Common mistakes](#6-common-mistakes)
7. [Cheat Sheet](#7-cheat-sheet)
8. [FAQ](#8-faq)

---

## 1. What Problem Does This Solve?

### The problem with "raw" Claude Code / Vấn đề khi dùng Claude Code "thô"

If you're using Claude Code like this:

```
You: "Write me a user management API"
Claude: *writes 500 lines of code*
You: "Hmm that's not what I meant, fix it..."
Claude: *rewrites 500 different lines*
You: "We're halfway through and it's already forgetting context..."
```

You'll hit 3 main problems:

| Problem | Symptom |
|---------|---------|
| **Claude jumps straight to code** | Doesn't ask what you need, output misses the mark |
| **Context gets lost** | Long chats → Claude "forgets" previous discussions |
| **Wasted tokens** | Claude reads entire project including node_modules |

### How the framework solves it / Framework giải quyết thế nào

```
BEFORE (no framework):
  You type → Claude guesses → wrong → fix → fix → out of context → start over

AFTER (with framework):
  You provide context → Claude ASKS FIRST → designs → you approve → Claude executes correctly
```

Specifically:

- **Claude asks before doing** — "What are you trying to achieve? Who will use this?"
- **Presents a plan for your approval** — no wasted tokens on wrong implementations
- **Splits work into small parallel tasks** — 2-3x faster
- **Never loses context** — saves "memory" to files, new sessions can read it back
- **Saves 40-60% tokens** — each agent only reads the files it needs

---

## 2. Prerequisites / Cần chuẩn bị gì?

### Required / Bắt buộc

| Tool | How to check | If missing |
|------|-------------|-----------|
| **Claude Code CLI** | `claude --version` | `npm install -g @anthropic-ai/claude-code` |
| **Claude account** | Can login to Claude Code | Sign up at claude.ai (Pro $20/mo or Max) |
| **Git** | `git --version` | [git-scm.com](https://git-scm.com) |

### Recommended / Khuyến nghị

| Tool | Why |
|------|-----|
| **Bun** | Required for gstack `/browse` headless browser |
| **tmux** | View multiple agent terminals side-by-side |
| **Claude Max plan** | Agent teams use many tokens; Pro will hit quota quickly |

---

## 3. Step-by-Step Installation / Cài đặt từng bước

### Step 1: Download the framework

```bash
# Clone (gstack is included via vendor/)
git clone --recursive https://github.com/duyentb95/prism-framework.git
cd prism-framework
```

**`--recursive` is important**: it also downloads `vendor/gstack` (git submodule). If you forget, run:
```bash
git submodule update --init
```

### Step 2: Run setup (1 command — installs everything automatically)

```bash
./setup
```

**What setup does:**

```
▸ Prerequisites...
  ✓ Git
  ✓ Claude Code
  ✓ Bun (for gstack /browse)

▸ Checking vendor/gstack...
  ✓ gstack vendored at vendor/gstack/

▸ Installing PRISM skills → ~/.claude/skills/
  ✓ master-agent
  ✓ sub-agent
  ✓ context-compactor
  ✓ knowledge-spine
  ✓ PRISM commands

▸ Installing gstack → ~/.claude/skills/gstack/
  ✓ gstack ready (browse binary + symlinks)
  ✓   /plan-ceo-review
  ✓   /plan-eng-review
  ✓   /review
  ✓   /ship
  ✓   /browse
  ✓   /qa
  ✓   /retro
  ✓   /setup-browser-cookies
  ✓   /document-release

▸ Superpowers plugin
  ℹ Install in Claude Code: /plugin marketplace add obra/superpowers

▸ Setting up project → /current/directory/
  ✓ CLAUDE.md
  ✓ .claudecodeignore
  ✓ .prism/ structure
  ✓ .claude/settings.json

  Vendor gstack into this project so teammates get it via git?
  [y/N]: y
  ✓ gstack vendored → .claude/skills/gstack/
```

**Add to another project (no need to clone again) / Thêm vào dự án khác:**
```bash
cd ~/prism-framework
./setup --project ~/projects/my-app
./setup --project ~/projects/another-app
```

**Management commands / Quản lý:**
```bash
./setup --update     # Update gstack to latest
./setup --status     # Check installation status
./setup --uninstall  # Remove everything
```

### Step 3: Customize for your project / Tùy chỉnh cho dự án

Open `.prism/CONTEXT_HUB.md` in any editor and fill in:

```markdown
## WHY — Why does this project exist
Building a personal expense tracker because existing apps are too complex.

## WHO — Who receives the output
- Primary: Myself — daily use on mobile
- Secondary: Friends who want to try it

## STANDARDS — Output standards
- Language: TypeScript + React Native
- Testing: Jest
- Style: ESLint + Prettier
```

**Tip:** Doesn't need to be perfect. Write quickly in 2 minutes. Claude will ask for more if needed.

### Step 4: Verify installation / Kiểm tra cài đặt

```bash
# Check project files
ls -la CLAUDE.md .prism/ .claude/

# Expected:
# CLAUDE.md
# .prism/CONTEXT_HUB.md
# .prism/MASTER_PLAN.md
# .prism/DICTIONARY.md
# .claude/settings.json

# Check global skills
ls ~/.claude/skills/

# Expected:
# master-agent/
# sub-agent/
# context-compactor/
# knowledge-spine/
# gstack-bridge/        ← Router between PRISM and gstack (lazy-load)
# gstack/              ← 12 cognitive modes from Garry Tan / YC

# Test in Claude Code
claude
> /plan-ceo-review Test if this skill loads
# If Claude understands and asks clarifying questions → gstack is working
```

**Done! Framework is installed.** Now let's use it for real.

---

## 4. First-Time Usage Walkthrough / Dùng lần đầu tiên

### Scenario: Build a REST API for a todo list app

#### Step 1: Open Claude Code in your project

```bash
cd ~/projects/my-project
claude
```

Claude will automatically read `CLAUDE.md` and know it's the Master-Agent.

#### Step 2: Describe what you need

Type in Claude Code:

```
I need to build a REST API for a todo list app.
Tech stack: Node.js + Express + SQLite.
Need CRUD endpoints + basic authentication.
```

#### Step 3: Claude ASKS FIRST (doesn't jump to code)

```
Claude (Master-Agent):
  "Before I plan, let me ask:
   1. Is this API for a mobile app, web app, or both?
   2. How much auth do you need — simple JWT or full OAuth?
   3. Do you need pagination, search, filtering?"
```

**You answer:**

```
1. Both mobile and web
2. Simple JWT is enough
3. Need pagination, no search yet
```

#### Step 4: Claude presents the design (section by section)

```
Claude:
  "DESIGN — Todo REST API

  Section 1: Database Schema
    - Table 'users': id, email, password_hash, created_at
    - Table 'todos': id, user_id, title, done, created_at
    → OK?

  Section 2: API Endpoints
    - POST /auth/register, POST /auth/login
    - GET /todos (paginated), POST /todos, PATCH /todos/:id, DELETE /todos/:id
    → OK?

  Section 3: Auth Flow
    - JWT token, expires in 7 days, middleware verifies on all /todos routes
    → OK?"
```

**You approve:** "All good, go ahead"

#### Step 5: Claude creates the plan (micro-tasks)

```
Claude:
  "PLAN — 6 tasks, estimate 30 min total

  | ID | Task | Model | Parallel? |
  |----|------|-------|-----------|
  | TASK_001 | Setup project + dependencies | GSD | — |
  | TASK_002 | Database schema + migrations | Sonnet | Yes w/ 003 |
  | TASK_003 | Auth endpoints + JWT middleware | Sonnet | Yes w/ 002 |
  | TASK_004 | CRUD todo endpoints | Sonnet | After 002 |
  | TASK_005 | Pagination middleware | Sonnet | After 004 |
  | TASK_006 | Integration tests | Sonnet | After all |

  Wave 1 (parallel): TASK_001(GSD) + TASK_002 + TASK_003
  Wave 2: TASK_004 + TASK_005
  Wave 3: TASK_006

  Type GO to begin."
```

#### Step 6: Type `GO`

Claude will:
1. Do TASK_001 immediately (small — GSD mode)
2. Create task briefs for TASK_002-006 in `.prism/tasks/`
3. Tell you to open new sessions for sub-agents

#### Step 7: Run sub-agents

**Terminal 2** (sub-agent for TASK_002):
```bash
claude
# Paste:
Read .prism/tasks/TASK_002_database.md and EXECUTE. Assume I am AFK.
```

**Terminal 3** (sub-agent for TASK_003, runs in parallel):
```bash
claude
# Paste:
Read .prism/tasks/TASK_003_auth.md and EXECUTE. Assume I am AFK.
```

Each sub-agent will:
- Read its task brief → know exactly what to do
- Finish → report status: `DONE` or `BLOCKED`

#### Step 8: Return to Master for review

Back in Terminal 1 (master session):

```
Review TASK_002 and TASK_003
```

Claude (Master) will:
- Read sub-agent outputs
- Check if they meet requirements
- If OK → proceed to Wave 2
- If issues → update task brief → you re-run sub-agent

#### Step 9: Repeat for remaining waves

Same pattern: dispatch TASK_004, 005, 006 → review → done.

#### Result / Kết quả

After ~30 minutes, you have:
- Complete REST API
- Full test coverage
- Code reviewed in 2 rounds (sub-agent implements + master reviews)
- Knowledge saved to `.prism/knowledge/`

---

## 5. Real-World Scenarios / Tình huống thực tế

### Scenario 1: "I have an idea but it's not clear yet"

```bash
claude
> /brainstorm I want to build an expense tracker but not sure about the tech stack
```

Claude will ask clarifying questions, explore alternatives, and present a design.
Not a single line of code until you say "OK, plan it."

### Scenario 2: "Quick bug fix"

```bash
claude
> /gsd Fix CORS error on /api/todos endpoint
```

GSD mode = Claude does it immediately. No planning, no sub-agents. Done in 2 minutes.

### Scenario 3: "Chat is too long, Claude is starting to forget"

```bash
# In current session:
> /compact

# Claude writes all state to .prism/STAGING.md
# You see: "Context consolidated. Ready for fresh session."

# Open new session:
claude
> Read .prism/STAGING.md and resume
# → Claude remembers everything, continues as if nothing happened
```

### Scenario 4: "Boss suddenly requests an out-of-scope feature"

```bash
> /adhoc Boss wants CSV export for reports, but we're mid-sprint on authentication
```

Claude handles it in `.prism/adhoc/` — doesn't disrupt the main sprint.
When done → extracts general knowledge → updates knowledge base.

### Scenario 5: "I need another AI to do the design part (Manus, Figma...)"

```bash
> I need Manus to design a landing page. Write an optimized prompt for Manus based on our project context.
```

Claude writes an optimized prompt for Manus → you paste it → results come back to Claude for integration.

---

## 6. Common Mistakes / Sai lầm phổ biến

### Mistake 1: Not providing WHY

```
Bad:  "Build a dashboard"
Good: "I need this dashboard to track my trading bot's PnL daily.
       I'm the only user, checking on my laptop each morning.
       Most important: see today's profit/loss at a glance."
```

**Why it matters:** With WHY, Claude knows how to choose layout, metrics, and priorities.

### Mistake 2: Skipping plan review

```
Bad:  Type GO without reading the plan → Claude builds the wrong thing → wasted sprint
Good: Read each task in the plan → adjust if needed → then GO
```

**Tip:** 2-3 minutes reviewing the plan saves 30-60 minutes fixing mistakes.

### Mistake 3: Using one session for everything

```
Bad:  Master-Agent plans + codes + debugs in one long session
      → context window fills up → Claude starts "hallucinating"

Good: Master plans in session 1
      Sub-agents execute in separate sessions (one terminal each)
      Return to master for review
```

### Mistake 4: Not using `.claudecodeignore`

```
Without .claudecodeignore:
  Claude reads node_modules/ (thousands of files) → wastes tokens → slow

With .claudecodeignore:
  Claude skips node_modules/ → 5-10x faster → 50%+ cheaper
```

### Mistake 5: Not updating knowledge

```
Bad:  Fix a bug → forget to record it → hit the same bug 2 weeks later

Good: Fix a bug → tell Claude:
      "Add to .prism/knowledge/GOTCHAS.md: API X needs header Y or you get error Z"
```

---

## 7. Cheat Sheet

### PRISM commands (uses .prism/ knowledge system, inline — zero extra tokens)

| Command | When to use | Time |
|---------|-------------|------|
| `/init-prism` | First-time framework setup for a project | Once |
| `/brainstorm [idea]` | Vague idea, want to explore | 5-10 min |
| `/ceo-review [feature]` | "Am I building the right thing?" | 5-10 min |
| `/eng-review [feature]` | Lock architecture, diagrams, edge cases | 5-10 min |
| `/plan [task]` | Break into micro-tasks, assign model tiers | 3-5 min |
| `GO` | Approve plan, start execution | 0 min |
| `/gsd [small task]` | Small task, do it now | 1-5 min |
| `/paranoid-review` | Find production bugs before they find you | 3-5 min |
| `/ship-it` | Ship. No more talking. | 1-2 min |
| `/document-release` | Update docs to match shipped code | 5-10 min |
| `/qa-check` | Verify output with evidence | 3-5 min |
| `/retro` | Sprint retrospective | 5-10 min |
| `/review TASK_NNN` | Review sub-agent output | 2-3 min |
| `/compact` | Session is long, Claude forgetting | 1 min |
| `/status` | Check current progress | 30 sec |
| `/adhoc [request]` | Out-of-sprint request | Varies |

### gstack native commands (lazy-load SKILL.md — deeper than PRISM inline)

| Command | Mode | Special | When to choose over PRISM |
|---------|------|---------|--------------------------|
| `/plan-ceo-review` | Founder/CEO | Full 10-star framework | Deep product thinking needed |
| `/plan-eng-review` | Eng manager | Forced diagrams + test matrix | Need thorough architecture lock |
| `/review` | Staff engineer | Auto-fix + Greptile triage | Pre-merge code review |
| `/ship` | Release engineer | Version bump + PR automation | Ship code to production |
| `/browse [url]` | QA engineer | Headless Chromium ~100ms | Browser automation |
| `/qa` | QA lead | Diff-aware + 3 tiers + fix loop | Full QA testing |
| `/plan-design-review` | Designer | 80-item audit + letter grades | Design audit report |
| `/qa-design-review` | Designer + dev | Audit + auto-fix | Design audit + fix |
| `/design-consultation` | Design consultant | Create DESIGN.md | Build design system |
| `/doc-release` | Tech writer | Cross-ref git diff vs docs | Post-ship doc update |
| `/retro --gstack` | Eng manager | Commit analysis + per-person | Deep retrospective |
| `/setup-browser-cookies` | Session mgr | Import cookies from browsers | Test auth pages |

**How it works:** gstack commands lazy-load their SKILL.md via `gstack-bridge`.
Only 1 SKILL.md is loaded at a time (~3K-15K tokens), never pre-loaded.

**Tip:** PRISM commands (`/ceo-review`) and gstack commands (`/plan-ceo-review`) share methodology but:
- **PRISM commands** → inline (from CLAUDE.md), saves to `.prism/`, faster, fewer tokens
- **gstack commands** → lazy-loads SKILL.md, deeper analysis, browser automation + Greptile integration
- **Both save to .prism/** → gstack output auto-integrates into the knowledge system

### Running sub-agents / Chạy sub-agent

```bash
# Open a new terminal
claude

# Paste exactly:
Read .prism/tasks/TASK_001_xxx.md and EXECUTE. Assume I am AFK.
```

The sub-agent reads the task → executes → reports status. You don't need to watch it.

### Resuming after a break / Tiếp tục sau khi nghỉ

```bash
# Next morning, open the project:
claude

# Claude auto-reads CLAUDE.md → MASTER_PLAN → knows where you left off
# If there's a STAGING.md (from /compact yesterday):
Read .prism/STAGING.md and resume
```

---

## 8. FAQ

### "I'm working on a small project, do I need this framework?"

**Yes**, but you'll use fewer features. Small project workflow:

```
claude → describe task → Claude asks 2 questions → design → GO → done
```

No sub-agents needed, no parallel execution. Just the "ask before doing" part already saves many tokens.

### "I don't code, I just need to write reports/slides. Can I use this?"

**Yes.** This framework works for ANY task, not just code:

```
> /plan Create Q1 2026 crypto market analysis report for the investment team

Claude will:
1. Ask: who's the audience, what metrics they care about, what format
2. Design: report outline section by section
3. Plan: micro-tasks (research data, write each section, format)
4. Execute: create a complete report
```

### "How much does this cost?"

The framework is **FREE**. The only cost is your Claude subscription:
- **Pro ($20/mo)**: Enough for 1-2 small projects
- **Max ($100/mo)**: Recommended if using agent teams heavily

### "I have a team of 3. How do we share?"

```bash
# Add .prism/ to git
git add .prism/ CLAUDE.md .claudecodeignore
git commit -m "Add PRISM framework"
git push

# Teammates clone/pull:
git pull
# → Their AI automatically has all context, knowledge, standards
# → No need to explain anything again
```

### "Claude still jumps straight to code, doesn't ask first?"

Check 2 things:

1. **Does `CLAUDE.md` exist at project root?** Claude reads this file first.
   ```bash
   ls CLAUDE.md  # Must exist
   ```

2. **Are you in the right project directory?**
   ```bash
   pwd  # Must be the directory containing CLAUDE.md
   claude  # Claude Code will auto-read CLAUDE.md
   ```

### "gstack /browse or /qa doesn't work?"

```bash
# Bun runtime is required
bun --version  # If missing: curl -fsSL https://bun.sh/install | bash

# Rebuild gstack binary
cd ~/.claude/skills/gstack && ./setup

# If still broken — rebuild from scratch
cd ~/.claude/skills/gstack && bun install && bun run build
```

### "gstack /plan-ceo-review or /plan-eng-review not recognized?"

```bash
# Check symlinks
ls -la ~/.claude/skills/plan-ceo-review
# Should point to -> ~/.claude/skills/gstack/plan-ceo-review/

# If symlink is broken, re-run setup
cd ~/.claude/skills/gstack && ./setup
```

### "Can I use gstack skills directly (without PRISM)?"

Absolutely. gstack works independently. In Claude Code:
```
/plan-ceo-review [describe feature]    # gstack native
/plan-eng-review [feature]             # gstack native
/review                                # gstack native
/ship                                  # gstack native
```

PRISM commands (`/ceo-review`, `/eng-review`) are wrappers that integrate gstack methodology with the `.prism/` knowledge system. Either approach works.

### "Sub-agent is BLOCKED, what do I do?"

1. Read the task brief → HANDOVER section → see the BLOCKED reason
2. Add missing context or revise the requirements in the task brief
3. Re-run: `Read .prism/tasks/TASK_NNN_xxx.md and EXECUTE`

### "When should I /compact?"

When you notice ANY of these signs:
- Claude gives contradictory answers vs. what it said earlier
- Claude asks about something you already answered
- Responses start getting slower than usual
- Claude starts "making up" information you never provided

---

## Summary / Tóm lại

```
Before framework:
  You → Claude → output (may be wrong) → fix → fix → out of context → restart

After framework:
  You → provide WHY → Claude asks → designs → you approve → GO
       → sub-agents work in parallel → review → DONE
       → knowledge saved → next time is faster
```

**3 most important things to remember:**

1. **Always describe WHY** (why you need it, for whom, what it's used for)
2. **Review the plan before GO** (2 min review = saves 30 min of rework)
3. **`/compact` when sessions get long** (keeps Claude sharp and focused)

Start small. Use it with one simple task first. Scale up to multi-agent once you're comfortable.
