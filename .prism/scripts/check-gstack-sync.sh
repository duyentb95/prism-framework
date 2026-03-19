#!/bin/bash
# check-gstack-sync.sh — Detect drift between gstack skills and PRISM bridge routing table
# Usage: .prism/scripts/check-gstack-sync.sh [gstack-path]
# Default gstack path: ~/.claude/skills/gstack

set -euo pipefail

GSTACK="${1:-$HOME/.claude/skills/gstack}"
BRIDGE="skills/gstack-bridge/SKILL.md"
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")

if [ ! -d "$GSTACK" ]; then
  echo "ERROR: gstack not found at $GSTACK"
  echo "Usage: $0 [path-to-gstack]"
  exit 1
fi

if [ ! -f "$ROOT/$BRIDGE" ]; then
  echo "ERROR: Bridge SKILL.md not found at $ROOT/$BRIDGE"
  exit 1
fi

echo "gstack path: $GSTACK"
echo "Bridge file: $ROOT/$BRIDGE"
echo ""

# Extract gstack skills (directories with SKILL.md)
GSTACK_SKILLS=$(find "$GSTACK" -maxdepth 2 -name "SKILL.md" -not -path "$GSTACK/SKILL.md" | sed "s|$GSTACK/||;s|/SKILL.md||" | sort)

# Extract bridge path table entries (Step 1 table — column 3 has the SKILL.md path)
BRIDGE_SKILLS=$(grep -E '^\| `/' "$ROOT/$BRIDGE" | grep 'SKILL.md' | awk -F'|' '{print $3}' | grep -oE '[a-z][-a-z]*/SKILL\.md' | sed 's|/SKILL\.md||' | sort -u)

echo "=== gstack skills ($(echo "$GSTACK_SKILLS" | wc -l | tr -d ' ')) ==="
echo "$GSTACK_SKILLS"
echo ""
echo "=== Bridge routes ($(echo "$BRIDGE_SKILLS" | wc -l | tr -d ' ')) ==="
echo "$BRIDGE_SKILLS"
echo ""

# Find missing from bridge
MISSING=$(comm -23 <(echo "$GSTACK_SKILLS") <(echo "$BRIDGE_SKILLS"))
if [ -n "$MISSING" ]; then
  echo "⚠️  MISSING from bridge (gstack has, bridge doesn't route):"
  echo "$MISSING" | sed 's/^/  - /'
  echo ""
else
  echo "✅ All gstack skills have bridge routes"
  echo ""
fi

# Find stale in bridge (bridge routes to non-existent gstack skill)
STALE=$(comm -13 <(echo "$GSTACK_SKILLS") <(echo "$BRIDGE_SKILLS"))
if [ -n "$STALE" ]; then
  echo "⚠️  STALE in bridge (bridge routes, but gstack skill doesn't exist):"
  echo "$STALE" | sed 's/^/  - /'
  echo ""
else
  echo "✅ All bridge routes point to existing gstack skills"
  echo ""
fi

# Check gstack version if available
if [ -f "$GSTACK/VERSION" ]; then
  echo "gstack version: $(cat "$GSTACK/VERSION")"
fi

# Summary
if [ -n "$MISSING" ] || [ -n "$STALE" ]; then
  echo ""
  echo "❌ SYNC NEEDED — run eng-review to plan updates"
  exit 1
else
  echo ""
  echo "✅ Bridge is in sync with gstack"
  exit 0
fi
