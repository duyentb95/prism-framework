Audit all installed skills for overlapping triggers and conflicts.

## Preamble (run first)

```bash
_scan_skill() {
  local loc="$1" skill="$2"
  [ -f "$skill" ] || return
  local name=$(basename $(dirname "$skill"))
  local desc=$(head -30 "$skill" | grep -A2 "description" | grep -v "description" | head -1 | sed 's/^[[:space:]]*//')
  local triggers=$(grep -iE "Triggers?:|Activates? on:" "$skill" | head -1 | sed 's/^[[:space:]]*//')
  echo "$loc|$name|$desc|$triggers"
}

echo "=== GLOBAL SKILLS ==="
for skill in ~/.claude/skills/*/SKILL.md; do _scan_skill "GLOBAL" "$skill"; done

echo "=== GLOBAL GSTACK SKILLS ==="
for skill in ~/.claude/skills/gstack/*/SKILL.md; do _scan_skill "GSTACK" "$skill"; done

echo "=== PROJECT SKILLS ==="
for skill in .claude/skills/*/SKILL.md; do _scan_skill "PROJECT" "$skill"; done

echo "=== PROJECT GSTACK SKILLS ==="
for skill in .claude/skills/gstack/*/SKILL.md; do _scan_skill "PROJECT-GSTACK" "$skill"; done

echo "=== REPO SKILLS ==="
for skill in skills/*/SKILL.md; do _scan_skill "REPO" "$skill"; done

echo "=== COMMANDS ==="
for cmd in ~/.claude/commands/*.md .claude/commands/*.md; do
  [ -f "$cmd" ] || continue
  local name=$(basename "$cmd" .md)
  local desc=$(head -1 "$cmd" | sed 's/^[[:space:]]*//')
  local loc="GLOBAL"
  [[ "$cmd" == .claude/* ]] && loc="PROJECT"
  echo "CMD|$loc|$name|$desc"
done
```

## Analysis Steps

Using the preamble output, perform this analysis:

### Step 1: Build Trigger Map

For each skill, extract trigger keywords from:
- The `Triggers:` line in description
- The `Activates on:` line
- The first line of the SKILL.md description

Build a map: `keyword --> [skill1, skill2, ...]`

### Step 2: Detect Overlaps

Find keywords that appear in 2+ skills. Classify each overlap:

**HIGH severity** -- Genuine conflict:
- Two skills trigger on same keyword AND produce different types of output
- User intent is ambiguous between them
- Example: user-built `code-reviewer` vs `paranoid-review` both trigger on "review"

**LOW severity** -- By-design wrapper:
- One skill explicitly delegates to another (e.g., "when gstack available, delegates")
- One is a PRISM skill that wraps a gstack skill
- Example: `ship-engineer` wraps gstack `/ship`

**INFO** -- Duplicate installation:
- Same skill appears in both global and project locations
- Not harmful but wastes scan time

### Step 3: Detect Duplicate Skills (global vs project)

If the same skill name exists in both `~/.claude/skills/` and `.claude/skills/`, flag it.
Project-level takes priority in Claude Code, so global copy is redundant.

### Step 4: Detect Command-Skill Mismatches

Check if any commands share the same name as a skill (potential confusion).
Check if commands exist in both global and project locations (duplicates).

### Step 5: Report

Present results in this format:

```
SKILL AUDIT REPORT
==================

Skills scanned: [N] (global: [N], project: [N])
Commands scanned: [N]

OVERLAPS FOUND: [N]
------------------

[HIGH] "review" --> paranoid-review, code-reviewer
  paranoid-review: Finds production bugs (PRISM built-in)
  code-reviewer: Generic code review (user-built)
  SUGGESTION: Merge into one, or rename triggers to be specific
              ("paranoid review" vs "code review")

[LOW] "browse" --> browser-agent, gstack-bridge
  browser-agent wraps gstack /browse (by design)
  No action needed.

[INFO] Duplicate: master-agent exists in both global and project
  SUGGESTION: Remove from global (~/.claude/skills/master-agent/)
              Project-level takes priority.

DUPLICATES: [N]
--------------
[list]

SUMMARY
-------
HIGH overlaps: [N] -- should fix
LOW overlaps: [N] -- by design, no action
Duplicates: [N] -- can clean up
```

### Step 6: Interactive Fix

For each HIGH overlap, ask the user:

```
[HIGH] "review" triggers both paranoid-review and code-reviewer.
  A) Keep paranoid-review, remove code-reviewer
  B) Keep code-reviewer, remove paranoid-review
  C) Keep both -- I'll rename triggers manually
  D) Skip
```

For duplicates, ask:
```
[DUP] master-agent exists in global AND project.
  A) Remove global copy (recommended -- project takes priority)
  B) Remove project copy
  C) Skip
```

Execute user choices. Do NOT delete files without confirmation.

### Step 7: Save Report

Save audit report to `.prism/qa-reports/skill-audit_{date}.md`
