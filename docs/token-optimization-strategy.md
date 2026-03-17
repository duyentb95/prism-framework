# Token Optimization Strategy — PRISM × gstack

## Problem

gstack tổng ~120K tokens across 12+ SKILL.md files. PRISM core (CLAUDE.md + commands.md + skills) ~15K.
Naive approach: load tất cả = ~135K tokens trước khi user gõ chữ nào → context window cạn kiệt.

## Solution: 4-Layer Loading Architecture

```
Layer 0 — ALWAYS LOADED (~4.2K tokens)
  ├── CLAUDE.md             ~3K    ← Não bộ Master-Agent
  └── commands/commands.md  ~1.2K  ← Command registry (names + 1-line descriptions)

Layer 1 — ON ROUTING (~1K tokens)
  └── skills/gstack-bridge/SKILL.md  ~1K  ← Lazy router, path resolution

Layer 2 — ON COMMAND INVOKE (3K–15K tokens)
  └── Active gstack SKILL.md         varies
      ├── plan-ceo-review  ~8K
      ├── plan-eng-review  ~10K
      ├── review           ~12K (largest — includes review methodology)
      ├── ship             ~6K
      ├── qa               ~12K
      ├── browse           ~5K
      ├── retro            ~7K
      ├── document-release ~5K
      ├── design-consult.  ~10K
      └── design-review    ~8K

Layer 3 — WITHIN WORKFLOW (1.5K–4.5K tokens, only if referenced)
  ├── gstack/review/checklist.md         ~2K   (used by /review, /ship)
  ├── gstack/review/greptile-triage.md   ~1.5K (used by /review, /ship)
  └── gstack/qa/references/issue-taxonomy.md ~1.5K (used by /qa, /qa-only)
```

## Budget Scenarios

| Scenario | Context Used | Notes |
|----------|-------------|-------|
| Idle (no gstack) | ~4.2K | Just CLAUDE.md + commands.md |
| Routing decision | ~5.2K | + gstack-bridge |
| Active /browse | ~10.2K | + browse SKILL.md |
| Active /review | ~19.7K | + review SKILL.md + checklist + greptile |
| Active /qa | ~18.7K | + qa SKILL.md + issue-taxonomy |
| Peak (heaviest skill) | ~22K | review with all extras |
| Naive load (NO optimization) | ~135K+ | All skills pre-loaded |

**Savings: 84% reduction** from naive approach at peak usage.

## 6 Optimization Techniques

### 1. Preamble Deduplication

All gstack SKILL.md files share an identical preamble (session tracking, update check, environment setup).
Run preamble ONCE per session, track with mental flag `_GSTACK_PREAMBLE_RAN`.

**Savings:** ~1.5K tokens per subsequent gstack command in same session.

### 2. Shared Dependency Caching

`/review` and `/ship` both use `checklist.md` + `greptile-triage.md`.
When running `/review` → `/ship` back-to-back:
- checklist.md stays loaded (don't re-read)
- greptile-triage.md stays loaded

**Savings:** ~3.5K tokens when chaining /review → /ship.

Similarly, `/qa` and `/qa-only` share `issue-taxonomy.md`:
- If switching between them, issue-taxonomy stays loaded

**Savings:** ~1.5K tokens.

### 3. Quick Mode Shortcuts

For simple invocations, skip full SKILL.md:

```
/browse [url]           → Skip SKILL.md, just run: $B navigate [url] && $B screenshot
/qa --quick             → Load SKILL.md but execute Quick tier only (skip Standard/Exhaustive)
/retro --brief          → Skip per-person breakdown, just top-line metrics
/review [single file]   → Scope review to that file only, skip codebase-wide analysis
```

**Savings:** Variable, 30-60% of typical workflow tokens.

### 4. Output Compression Pipeline

Long gstack outputs (retro = ~3K, QA report = ~5K, design audit = ~4K) consume context.
After gstack workflow completes:

```
1. gstack outputs raw result (full detail)
2. Context-compactor extracts key findings (compress 60-80%)
3. Compressed summary → .prism/ knowledge files
4. Raw output → .prism/ archive (for reference, not re-read)
5. Drop raw output from active context
```

**Savings:** ~60-80% of output tokens before next workflow step.

### 5. Progressive Disclosure (for complex skills)

Large SKILL.md files (review ~12K, qa ~12K) often have sections that aren't needed:

```
/review SKILL.md structure:
  Section 1: Preamble                    (shared — skip if already ran)
  Section 2: Diff analysis methodology   (always needed)
  Section 3: Category-specific checklists (only read relevant categories)
  Section 4: Greptile integration        (only if Greptile configured)
  Section 5: Auto-fix patterns           (only if fixing mode enabled)
```

Master-Agent can instruct: "Read sections 1-2, skip 3-5 unless needed."

**Savings:** Up to 40% of large SKILL.md files.

### 6. PRISM-First for Quick Checks

CLAUDE.md already contains inline versions of CEO review, Eng review, Ship, QA, Retro phases.
For quick checks, use PRISM inline (0 extra tokens) instead of loading gstack SKILL.md:

```
Quick CEO challenge     → PRISM /ceo-review (inline, 0 extra tokens)
Quick architecture Q    → PRISM /eng-review (inline, 0 extra tokens)
Quick paranoid check    → PRISM /paranoid-review (inline, 0 extra tokens)

Deep CEO analysis       → gstack /plan-ceo-review (+8K tokens)
Deep architecture lock  → gstack /plan-eng-review (+10K tokens)
Deep code review        → gstack /review (+15K tokens)
```

**Savings:** 3K-15K tokens per quick check by staying in PRISM inline mode.

## Full Feature Cycle — Token Timeline

```
Time →  t0     t1      t2      t3      t4      t5      t6      t7
        │      │       │       │       │       │       │       │
Action  idle   ceo     eng     impl    review  ship    qa      retro
        │      │       │       │       │       │       │       │
Tokens  4.2K   13.2K   15.2K   4.2K    19.7K   10.7K   18.7K   12.2K
        │      │       │       │       │       │       │       │
Loaded  base   +bridge +bridge base    +bridge +bridge +bridge +bridge
               +ceo    +eng    (impl   +review +ship   +qa     +retro
               SKILL   SKILL   is sub- +check  +check  +issue
                               agent)  +grep   +grep   -tax

Peak:   19.7K (at /review with all extras)
Average: ~12K across active gstack phases
Without optimization: 135K+ (everything pre-loaded)
```

## Decision Matrix: When to Optimize What

| Situation | Optimization |
|-----------|-------------|
| First gstack command in session | Run preamble, cache result |
| /review → /ship (same session) | Keep checklist.md loaded |
| Quick check ("is this right?") | Use PRISM inline, skip gstack |
| gstack output > 5K tokens | Run context-compactor before storing |
| User switching between many gstack commands | Drop old SKILL.md, load new one |
| Multiple sub-agents running | Each gets only their task context, NO gstack |
| Session > 50 exchanges | Run /compact, include gstack state in STAGING.md |

## Anti-Patterns to Avoid

```
❌ Loading all gstack SKILL.md at session start "just in case"
❌ Keeping old gstack SKILL.md in context after workflow completes
❌ Re-reading preamble on every gstack command
❌ Storing raw gstack output without compression
❌ Loading gstack SKILL.md for sub-agent sessions (they don't need it)
❌ Using gstack /plan-ceo-review when PRISM /ceo-review inline suffices
❌ Reading checklist.md separately for /review and /ship in same session
```
