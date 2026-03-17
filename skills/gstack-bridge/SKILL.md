---
name: gstack-bridge
description: >
  Routes PRISM workflow to gstack cognitive mode SKILL.md files. Lazy-loads on demand.
  Triggers: any gstack slash command (/review, /ship, /qa, /browse, /retro, /doc-release,
  /design-review, /design-fix, /design-system, /cookies, /gstack-upgrade),
  or intent matching (review my code, ship it, test the site, design check, weekly retro).
  Also handles browse binary discovery and gstack↔PRISM output integration.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
model: sonnet
---

# gstack Bridge — Lazy Router for PRISM

## Purpose

gstack = 12 specialized execution modes (cognitive modes) for Claude Code by Garry Tan / YC.
Each mode has its own SKILL.md (3K–15K tokens).
This bridge routes to the correct one WITHOUT pre-loading any of them.

PRISM already embeds gstack philosophy in CLAUDE.md (CEO review, Eng review, Ship, QA, etc.).
This bridge connects that philosophy to the ACTUAL gstack skill files for deeper execution.

## When gstack vs PRISM Native

```
USER INTENT                              → ROUTE TO
────────────────────────────────────────────────────────
"brainstorm" / "ideate" / "PRD"          → PRISM /brainstorm (personas)
"plan this feature"                      → PRISM /plan (micro-task decomposition)
"compress context" / "save state"        → PRISM context-compactor
"what's the plan" / "project overview"   → PRISM knowledge-spine / /status

"review plan as CEO" / "is this right?"  → gstack /plan-ceo-review
"lock the architecture"                  → gstack /plan-eng-review
"review my code before merge"            → gstack /review
"ship this branch"                       → gstack /ship
"test the website" / "QA this"           → gstack /qa or /browse
"how does the design look"               → gstack /plan-design-review
"fix the design issues"                  → gstack /qa-design-review
"create a design system"                 → gstack /design-consultation
"update the docs post-ship"              → gstack /document-release
"weekly retro" / "what did we ship"      → gstack /retro
```

### PRISM commands vs gstack commands — same concept, different depth

| PRISM Command | gstack Command | Difference |
|---|---|---|
| `/ceo-review` | `/plan-ceo-review` | PRISM: inline in CLAUDE.md, saves to .prism/designs/. gstack: full SKILL.md with structured methodology |
| `/eng-review` | `/plan-eng-review` | PRISM: inline phases. gstack: forced diagrams, test matrix, failure mode analysis |
| `/paranoid-review` | `/review` | PRISM: checklist in CLAUDE.md. gstack: SQL safety, Greptile triage, auto-fix mechanical issues |
| `/ship-it` | `/ship` | PRISM: inline checklist. gstack: full automation (merge, test, diff review, version bump, PR) |
| `/document-release` | `/doc-release` | PRISM: inline checklist. gstack: cross-references git diff vs every doc file |
| `/qa-check` | `/qa` | PRISM: manual evidence. gstack: diff-aware browser testing, 3 tiers, fix loop |
| `/retro` | `/retro` (gstack) | PRISM: inline format. gstack: commit analysis, session detection, per-person breakdown |

**Rule of thumb:**
- Quick / inline check → use PRISM command (reads from CLAUDE.md)
- Deep / specialized execution → use gstack command (lazy-loads SKILL.md)
- User says the gstack command name explicitly → always route to gstack

## Command Registry (lazy references)

All paths relative to gstack installation. Discovery order:
1. `$PROJECT_ROOT/.claude/skills/gstack/` (vendored in project)
2. `$HOME/.claude/skills/gstack/` (global install)

| Command | SKILL.md Path | Extra Files |
|---------|---------------|-------------|
| `/plan-ceo-review` | `gstack/plan-ceo-review/SKILL.md` | — |
| `/plan-eng-review` | `gstack/plan-eng-review/SKILL.md` | — |
| `/plan-design-review` | `gstack/plan-design-review/SKILL.md` | — |
| `/qa-design-review` | `gstack/qa-design-review/SKILL.md` | — |
| `/design-consultation` | `gstack/design-consultation/SKILL.md` | — |
| `/review` | `gstack/review/SKILL.md` | `gstack/review/checklist.md`, `gstack/review/greptile-triage.md` |
| `/ship` | `gstack/ship/SKILL.md` | `gstack/review/checklist.md`, `gstack/review/greptile-triage.md` |
| `/qa` | `gstack/qa/SKILL.md` | `gstack/qa/references/issue-taxonomy.md` |
| `/qa-only` | `gstack/qa-only/SKILL.md` | `gstack/qa/references/issue-taxonomy.md` |
| `/browse` | `gstack/browse/SKILL.md` | — |
| `/retro` (gstack) | `gstack/retro/SKILL.md` | — |
| `/doc-release` (gstack) | `gstack/document-release/SKILL.md` | — |
| `/setup-browser-cookies` | `gstack/setup-browser-cookies/SKILL.md` | — |
| `/gstack-upgrade` | `gstack/gstack-upgrade/SKILL.md` | — |

## Execution Pattern

When user invokes a gstack command:

```
1. RESOLVE PATH
   Find gstack root (project vendor → global install)

2. LAZY LOAD (only the target SKILL.md)
   Read the SKILL.md from Command Registry table
   If "Extra Files" column has entries → read those too
   NEVER read more than 1 gstack SKILL.md at a time

3. RUN PREAMBLE
   Execute the bash block at top of SKILL.md (session tracking, update check)
   This is identical across all gstack skills — run once per session

4. EXECUTE WORKFLOW
   Follow SKILL.md instructions exactly

5. INTEGRATE OUTPUT → .prism/
   Route gstack output into PRISM knowledge system (see Integration section below)

6. COMPRESS IF NEEDED
   If output > 5K tokens → suggest context-compactor
```

## gstack Root Discovery

```bash
# Find gstack installation
_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
GSTACK=""

# Priority 1: vendored in project
[ -n "$_ROOT" ] && [ -d "$_ROOT/.claude/skills/gstack" ] && GSTACK="$_ROOT/.claude/skills/gstack"

# Priority 2: global install
[ -z "$GSTACK" ] && [ -d "$HOME/.claude/skills/gstack" ] && GSTACK="$HOME/.claude/skills/gstack"

if [ -n "$GSTACK" ]; then
  echo "GSTACK_ROOT: $GSTACK"
else
  echo "NOT_FOUND: Run ./setup from framework root, or: cd ~/.claude/skills/gstack && ./setup"
fi
```

## Browse Binary Discovery

Run once before any `/browse` or `/qa` command:

```bash
_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
B=""
[ -n "$_ROOT" ] && [ -x "$_ROOT/.claude/skills/gstack/browse/dist/browse" ] && B="$_ROOT/.claude/skills/gstack/browse/dist/browse"
[ -z "$B" ] && [ -x "$HOME/.claude/skills/gstack/browse/dist/browse" ] && B="$HOME/.claude/skills/gstack/browse/dist/browse"
if [ -x "$B" ]; then
  echo "BROWSE_READY: $B"
else
  echo "NEEDS_BUILD: cd $GSTACK && bun install && bun run build"
fi
```

## Token Budget Rules

```
HARD RULES:
  ✗ NEVER load more than 1 gstack SKILL.md at a time
  ✗ NEVER pre-load gstack SKILL.md "just in case"
  ✓ After finishing a gstack workflow → SKILL.md content is stale, can be forgotten
  ✓ If switching commands → old SKILL.md is replaced by new one
  ✓ Preamble bash block is identical across skills → run once per session
  ✓ For /review → /ship back-to-back: checklist.md stays loaded (shared dependency)

BUDGET TABLE:
  Layer 0 (always loaded):     CLAUDE.md ~3K + commands.md ~1.2K = ~4.2K
  Layer 1 (on routing):        gstack-bridge SKILL.md ~1K
  Layer 2 (on command invoke): Active gstack SKILL.md = 3K–15K
  Layer 3 (within workflow):   Extra files (checklist.md ~2K, issue-taxonomy ~1.5K)

  PEAK at any moment: ~4.2K + 1K + 15K + 2K = ~22K tokens
  Without lazy loading (naive): ~120K+ tokens (all gstack skills loaded)
```

## Output Integration — gstack → .prism/

gstack outputs feed into PRISM's knowledge system:

| gstack Output | Save To | Format |
|---|---|---|
| `/plan-ceo-review` decisions | `.prism/designs/ceo-review_{topic}_{date}.md` | Product direction + options chosen |
| `/plan-eng-review` design | `.prism/designs/eng-review_{topic}_{date}.md` | Architecture + diagrams + edge cases |
| `/review` findings | `.prism/knowledge/GOTCHAS.md` (append) | Bugs found + fixes applied |
| `/qa` report | `.prism/qa-reports/qa_{date}.md` | Issues + evidence + status |
| `/qa` critical bugs | `.prism/tasks/TASK_NNN_qa_fix.md` | Sub-agent task briefs for fixes |
| `/retro` analysis | `.prism/retros/retro_{sprint}_{date}.md` | Metrics + wins + improvements |
| `/retro` lessons | `.prism/knowledge/GOTCHAS.md` (append) | Extracted patterns |
| `/design-consultation` | `DESIGN.md` (project root) | Design system reference |
| `/plan-design-review` audit | `.prism/qa-reports/design-audit_{date}.md` | Letter grades + issues |
| `/doc-release` changes | `.prism/knowledge/RULES.md` (append) | New patterns discovered |

### Post-gstack Workflow

After any gstack command completes:

1. Save output to appropriate .prism/ location (see table above)
2. If output contains lessons learned → append to `.prism/knowledge/GOTCHAS.md`
3. If output changes project standards → update `.prism/CONTEXT_HUB.md`
4. If output reveals new terminology → update `.prism/DICTIONARY.md`
5. Update `.prism/MASTER_PLAN.md` task status if relevant
6. If output > 5K tokens → run context-compactor to create concise summary

## Preamble Deduplication

All gstack SKILL.md files share an identical preamble (session tracking + update check).
After running it once in a session, skip it on subsequent gstack commands.

Track with a mental flag: `_GSTACK_PREAMBLE_RAN = true`

## Quick Mode Shortcuts

For simple invocations that don't need the full SKILL.md:

```
/browse [url]           → Just run: $B navigate [url] && $B screenshot
/qa --quick             → Read SKILL.md but skip exhaustive tier, run Quick only
/review [specific file] → Read SKILL.md, scope to that file only
/retro --brief          → Skip per-person breakdown, just metrics + top 3
```
