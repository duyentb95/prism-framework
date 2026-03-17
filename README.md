# PRISM — AI Agent Orchestration Framework

> **P**lan → **R**eview → **I**mplement → **S**hip → **M**onitor
>
> Turn Claude Code from an "AI coder" into a professional "AI Team Manager".
> Optimize tokens, output quality, and developer experience.
>
> *Biến Claude Code từ "AI coder" thành "AI Team Manager" chuyên nghiệp.*
> *Tối ưu token, output quality, và developer experience.*

---

## Installation / Cài đặt

```bash
# Clone framework (gstack included as submodule)
git clone --recursive https://github.com/duyentb95/prism-framework.git
cd prism-framework

# Install everything
./setup
```

**What `./setup` does / `./setup` tự động:**

1. Check prerequisites (Git, Claude Code, Bun)
2. Init `vendor/gstack` (clone if missing)
3. Install PRISM skills → `~/.claude/skills/`
4. Install gstack → `~/.claude/skills/gstack/` (build browse binary + symlinks)
5. Show Superpowers install command
6. Setup project files (CLAUDE.md, .prism/, .claude/)

**Add framework to another project / Thêm vào dự án khác:**
```bash
./setup --project ~/projects/my-other-app
```

**Update gstack to latest / Cập nhật gstack:**
```bash
./setup --update
```

---

## Quick Start

```bash
cd /path/to/your/project
claude

# Step 1: Initialize / Khởi tạo
> /init-prism

# Step 2: Brainstorm (if idea is unclear / nếu ý tưởng chưa rõ)
> /brainstorm [rough idea]
# → Claude asks clarifying questions → refines → presents design

# Step 3: Plan (once you know what you need / sau khi biết rõ cần gì)
> /plan [task description]
# → Design sections → micro-tasks → model tiers → cost estimate
# → Review plan → type GO

# Step 4: Execute (sub-agents run in parallel / chạy song song)
# Open a new terminal for each task:
> claude
> "Read .prism/tasks/TASK_001_xxx.md and EXECUTE. Assume I am AFK."

# Step 5: Review (sub-agent reports: DONE / BLOCKED / CONCERNS)
# Return to master session:
> /review TASK_001
```

---

## Why This Framework? / Tại sao cần Framework này?

| Problem / Vấn đề | Solution / Giải pháp |
|---|---|
| Claude "forgets" context in long chats | Context Compacting → STAGING.md → fresh session |
| Inconsistent output quality | CONTEXT_HUB + templates + RULES.md |
| Wasted tokens on unnecessary context | Isolated sub-agent sessions + .claudecodeignore |
| No visibility into "what AI is thinking" | Zero-Assumption Rule + transparent reporting |
| Knowledge lost between sessions | Knowledge Spine → git-committed wisdom |
| Ad-hoc tasks derail the main sprint | Isolated adhoc/ folder |

---

## Project Structure / Cấu trúc dự án

```
prism-framework/
├── setup                  # ← Run this / Chạy cái này
├── CLAUDE.md              # Master-Agent brain (copied to each project)
├── GETTING-STARTED.md     # Beginner's guide / Hướng dẫn cho người mới
├── .prism/                # Template .prism/ (copied to each project)
├── .claude/               # Settings template
├── skills/                # PRISM skills (installed globally)
│   ├── master-agent/
│   ├── sub-agent/
│   ├── context-compactor/
│   ├── knowledge-spine/
│   └── gstack-bridge/    # Router: PRISM ↔ gstack (lazy-load)
├── commands/              # Slash commands
├── vendor/                # Third-party skills
│   └── gstack/            # ← Garry Tan's cognitive modes (git submodule)
├── docs/                  # Additional documentation
├── .gitmodules            # gstack submodule config
└── .gitignore
```

**Per-project structure after setup / Cấu trúc dự án sau khi setup:**

```
your-project/
├── CLAUDE.md                    # Brain — Master-Agent instructions
├── .claudecodeignore            # Don't scan these folders
├── .claude/settings.json        # Agent Teams enabled
├── .prism/
│   ├── CONTEXT_HUB.md          # WHY, WHO, STANDARDS (shared context)
│   ├── MASTER_PLAN.md          # Task board + sprint status
│   ├── DICTIONARY.md           # Project terminology
│   ├── STAGING.md              # Session snapshot (for context reset)
│   ├── tasks/                  # Sub-agent task briefs
│   ├── adhoc/                  # Out-of-sprint requests
│   ├── templates/              # Sample outputs for reverse-engineering
│   ├── knowledge/              # Accumulated project wisdom
│   │   ├── RULES.md            #   Extracted patterns & rules
│   │   ├── GOTCHAS.md          #   Traps & lessons learned
│   │   └── TECH_DECISIONS.md   #   Architecture Decision Records
│   └── context/                # Minimal context extracts per task
└── [your project files...]
```

---

## How It Works / Cách hoạt động

```
You provide context (files, notes, screenshots, WHY)
    │
    ▼
Master-Agent (Opus) — Plan Mode
    │ Read context → Analyze → Propose plan
    │ ← You review + approve (CONFIRMED)
    │
    ├── GSD Mode (<15min) ──── Master does it directly
    │
    ├── Wave 1 (parallel)
    │   ├── Sub-Agent A (Sonnet) ──── TASK_001 ──── Handover ─┐
    │   └── Sub-Agent B (Opus)   ──── TASK_002 ──── Handover ─┤
    │                                                          │
    │   Master-Agent reviews ◀─────────────────────────────────┘
    │   ├── PASS → Mark done, extract knowledge
    │   └── FAIL → Update task, re-run sub-agent
    │
    ├── Wave 2 (depends on Wave 1)
    │   └── Sub-Agent C (Sonnet) ──── TASK_003
    │
    ▼
Master-Agent — Wrap up
    │ Update MASTER_PLAN, knowledge, docs
    │ Context Compacting if session is long
    ▼
Done (or next sprint)
```

---

## Cognitive Modes (from gstack — Garry Tan / YC)

> "Planning is not review. Review is not shipping. Founder taste is not engineering rigor.
> If you blur all of that together, you get a mediocre blend of all four."

| Mode | Brain | When to use / Khi nào dùng |
|------|-------|---|
| CEO / Founder | Taste, ambition, user empathy | "Am I building the right thing?" |
| Eng Manager | Architecture, rigor, diagrams | Lock technical design, edge cases, test matrix |
| Paranoid Reviewer | Security, bugs, production thinking | "What will break in production?" |
| Release Engineer | Execution, no talking | Branch ready → ship it. No more brainstorming. |
| Technical Writer | Docs, clarity, reader empathy | Update README, ARCHITECTURE, API docs |
| QA Engineer | Testing, verification, evidence | Verify output, screenshot, reproduce |
| Retro Analyst | Metrics, reflection, trends | What worked this sprint, what to improve |

---

## Commands / Lệnh

### PRISM commands (inline, zero extra tokens)

| Command | When to use / Khi nào dùng | Time |
|---------|---|---|
| `/init-prism` | First-time setup for a project / Lần đầu setup | Once |
| `/brainstorm [idea]` | Explore a vague idea / Ý tưởng mơ hồ | 5-10 min |
| `/ceo-review [feature]` | "Am I building the right thing?" | 5-10 min |
| `/eng-review [feature]` | Lock architecture, diagrams, edge cases | 5-10 min |
| `/plan [task]` | Break into micro-tasks, assign model tiers | 3-5 min |
| `GO` | Approve plan, start execution | 0 min |
| `/gsd [small task]` | Small task, do it now / Việc nhỏ, làm ngay | 1-5 min |
| `/paranoid-review` | Find bugs before production does | 3-5 min |
| `/ship-it` | Ship. No more talking. | 1-2 min |
| `/document-release` | Update docs to match shipped code | 5-10 min |
| `/qa-check` | Verify output with evidence | 3-5 min |
| `/retro` | Sprint retrospective | 5-10 min |
| `/compact` | Session too long, Claude is forgetting | 1 min |

### gstack commands (lazy-loaded, deeper analysis)

| Command | Mode | When to choose over PRISM |
|---------|------|---|
| `/plan-ceo-review` | Founder/CEO | Deep product thinking needed |
| `/plan-eng-review` | Eng manager | Need thorough architecture lock |
| `/review` | Staff engineer | Pre-merge code review with auto-fix |
| `/ship` | Release engineer | Version bump + PR automation |
| `/browse [url]` | QA engineer | Headless browser ~100ms |
| `/qa` | QA lead | Diff-aware 3-tier testing |
| `/retro --gstack` | Eng manager | Commit analysis + per-person |

---

## Pro Tips / Mẹo chuyên nghiệp

1. **Always provide WHY** — "I need this dashboard to convince the CEO to invest more in DeFi" > "Build a dashboard"
2. **Sample outputs are powerful** — Put screenshots/HTML into `.prism/templates/` → Claude reverse-engineers the pattern
3. **Git is the Single Source of Truth** — Commit `.prism/` → teammate `git pull` → their AI has all the "memory"
4. **Review the plan before GO** — 2 minutes reviewing saves 30 minutes fixing mistakes
5. **`/compact` when sessions get long** — Keeps Claude sharp and focused
6. **Append, don't rewrite** — Knowledge files grow incrementally (saves tokens)

---

## Requirements / Yêu cầu

| Required | How to check | Install |
|----------|---|---|
| **Claude Code CLI** | `claude --version` | `npm install -g @anthropic-ai/claude-code` |
| **Claude account** | Can login to Claude Code | Sign up at claude.ai (Pro $20/mo or Max) |
| **Git** | `git --version` | [git-scm.com](https://git-scm.com) |

| Recommended | Why |
|---|---|
| **Bun** | Required for gstack `/browse` browser automation |
| **tmux** | View multiple agent terminals side-by-side |
| **Claude Max plan** | Agent teams consume many tokens |

---

## Contributing / Đóng góp

Contributions are welcome! Feel free to open issues or submit pull requests.

## License

MIT

---

> **Full guide / Hướng dẫn đầy đủ:** See [GETTING-STARTED.md](GETTING-STARTED.md)
