#!/usr/bin/env bash
# Self-Review Hook — runs on Stop (session end)
# Reviews changed files against rotating criteria
# Inspired by agstack's self-review pattern

set -euo pipefail

# Find files changed in this session (uncommitted + last commit)
CHANGED_FILES=$(git diff --name-only HEAD 2>/dev/null; git diff --name-only --cached 2>/dev/null; git diff --name-only HEAD~1 HEAD 2>/dev/null) || true
CHANGED_FILES=$(echo "$CHANGED_FILES" | sort -u | grep -v '^$' || true)

if [ -z "$CHANGED_FILES" ]; then
  exit 0
fi

FILE_COUNT=$(echo "$CHANGED_FILES" | wc -l | tr -d ' ')

# Rotating review angle based on day-of-week
DAY=$(date +%u)  # 1=Monday, 7=Sunday
case $((DAY % 6)) in
  0) ANGLE="CLEANUP: dead code, unused imports, commented-out blocks" ;;
  1) ANGLE="ERROR HANDLING: missing catches, silent failures, error propagation" ;;
  2) ANGLE="TYPE SAFETY: any casts, missing null checks, implicit conversions" ;;
  3) ANGLE="STRUCTURE: file organization, function length, single responsibility" ;;
  4) ANGLE="NAMING: unclear variable names, abbreviations, inconsistent conventions" ;;
  5) ANGLE="SURGICAL SCOPE: does every changed line trace to the request? Any uninvited refactors? Would a senior engineer say this is overcomplicated?" ;;
esac

echo ""
echo "================================================================"
echo "SELF-REVIEW: $FILE_COUNT files changed this session"
echo "================================================================"
echo "Review angle: $ANGLE"
echo ""
echo "Changed files:"
echo "$CHANGED_FILES" | head -20 | sed 's/^/  - /'
if [ "$FILE_COUNT" -gt 20 ]; then
  echo "  ... and $((FILE_COUNT - 20)) more"
fi
echo ""
echo "Before ending: review these files through the lens above."
echo "================================================================"
echo ""

# Brutal-honesty failure trigger: scan commits in the last 24h for revert/hotfix/rollback
# Each one is a latent FAILURES.md entry waiting to be written.
FAIL_COMMITS=$(git log --since="24 hours ago" --oneline 2>/dev/null \
  | grep -iE '^\w+ (revert|hotfix|rollback|fix:|fixup)' || true)
if [ -n "$FAIL_COMMITS" ]; then
  FAIL_COUNT=$(echo "$FAIL_COMMITS" | wc -l | tr -d ' ')
  echo "================================================================"
  echo "BRUTAL HONESTY: $FAIL_COUNT revert/hotfix/fix commits in last 24h"
  echo "================================================================"
  echo "$FAIL_COMMITS" | head -5 | sed 's/^/  /'
  echo ""
  echo "These are failures unless proven otherwise. For each, append to"
  echo ".prism/knowledge/FAILURES.md:"
  echo "  - What broke"
  echo "  - The false assumption"
  echo "  - Who decided it (you / user / we)"
  echo "  - How to prevent next time"
  echo "No hedging. 'Could have been better' → 'was wrong because X'."
  echo "================================================================"
  echo ""
fi
