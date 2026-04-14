#!/usr/bin/env bash
# Token Budget Check — passive monitor of CLAUDE.md + rules/ + active skill
# Warns when PRISM's own context footprint approaches bloat thresholds.
# Uses char-count / 4 as a rough token proxy (good enough for trend monitoring).
#
# Thresholds (from .claude/rules/progressive-disclosure.md):
#   CLAUDE.md:     < 100 lines target, 150 hard  (Layer 1 — ALWAYS loaded)
#   SKILL.md body: < 300 lines target, 500 hard  (Layer 2 — loaded when skill activates)
#   Rules total:   ~12000 tokens warn             (Layer 3 — only loaded when referenced)
#
# Rules live in Layer 3: they are NOT loaded at session start, only when a skill
# or CLAUDE.md explicitly references them. So the rules/ budget is looser than
# Layers 1-2. Watch for unbounded growth, not absolute size.

set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

WARN=0
OUT=""

_tokens() {
  # chars / 4 ≈ tokens. Conservative for English+code.
  local f="$1"
  [ -f "$f" ] || { echo 0; return; }
  local c
  c=$(wc -c < "$f" | tr -d ' ')
  echo $((c / 4))
}

_lines() {
  local f="$1"
  [ -f "$f" ] || { echo 0; return; }
  wc -l < "$f" | tr -d ' '
}

# 1) CLAUDE.md
if [ -f "CLAUDE.md" ]; then
  CM_LINES=$(_lines CLAUDE.md)
  CM_TOK=$(_tokens CLAUDE.md)
  if [ "$CM_LINES" -gt 150 ]; then
    OUT="${OUT}[HARD] CLAUDE.md: ${CM_LINES} lines (~${CM_TOK} tok) — over 150-line hard cap
"
    WARN=1
  elif [ "$CM_LINES" -gt 100 ]; then
    OUT="${OUT}[warn] CLAUDE.md: ${CM_LINES} lines (~${CM_TOK} tok) — over 100-line target
"
    WARN=1
  fi
fi

# 2) Rules aggregate
if [ -d ".claude/rules" ]; then
  RULES_TOK=0
  for f in .claude/rules/*.md; do
    [ -f "$f" ] || continue
    RULES_TOK=$((RULES_TOK + $(_tokens "$f")))
  done
  if [ "$RULES_TOK" -gt 12000 ]; then
    OUT="${OUT}[warn] .claude/rules/: ~${RULES_TOK} tok total — Layer 3 budget exceeded, consider pruning
"
    WARN=1
  fi
fi

# 3) Oversized SKILL.md files (Layer 2 budget: 500 lines hard)
if [ -d ".claude/skills" ]; then
  while IFS= read -r -d '' f; do
    L=$(_lines "$f")
    if [ "$L" -gt 500 ]; then
      OUT="${OUT}[HARD] $f: ${L} lines — over 500-line Layer 2 cap
"
      WARN=1
    fi
  done < <(find .claude/skills -name SKILL.md -print0)
fi

if [ "$WARN" -eq 1 ]; then
  echo ""
  echo "================================================================"
  echo "TOKEN BUDGET: bloat detected"
  echo "================================================================"
  printf "%s" "$OUT"
  echo "See .claude/rules/progressive-disclosure.md for targets."
  echo "================================================================"
  echo ""
fi

exit 0
