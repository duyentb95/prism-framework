Audit all installed skills for overlapping triggers and conflicts.

## Preamble (run first)

```bash
echo "=== GLOBAL SKILLS ==="
for skill in ~/.claude/skills/*/SKILL.md; do
  [ -f "$skill" ] || continue
  name=$(basename $(dirname "$skill"))
  desc=$(head -20 "$skill" | grep -A1 "description" | tail -1 | sed 's/^[[:space:]]*//')
  triggers=$(grep -i "^[[:space:]]*Trigger" "$skill" | head -1 | sed 's/^[[:space:]]*//')
  echo "GLOBAL|$name|$desc|$triggers"
done

echo "=== PROJECT SKILLS ==="
for skill in .claude/skills/*/SKILL.md; do
  [ -f "$skill" ] || continue
  name=$(basename $(dirname "$skill"))
  desc=$(head -20 "$skill" | grep -A1 "description" | tail -1 | sed 's/^[[:space:]]*//')
  triggers=$(grep -i "^[[:space:]]*Trigger" "$skill" | head -1 | sed 's/^[[:space:]]*//')
  echo "PROJECT|$name|$desc|$triggers"
done

echo "=== REPO SKILLS ==="
for skill in skills/*/SKILL.md; do
  [ -f "$skill" ] || continue
  name=$(basename $(dirname "$skill"))
  desc=$(head -20 "$skill" | grep -A1 "description" | tail -1 | sed 's/^[[:space:]]*//')
  triggers=$(grep -i "^[[:space:]]*Trigger" "$skill" | head -1 | sed 's/^[[:space:]]*//')
  echo "REPO|$name|$desc|$triggers"
done

echo "=== COMMANDS ==="
for cmd in ~/.claude/commands/*.md .claude/commands/*.md; do
  [ -f "$cmd" ] || continue
  name=$(basename "$cmd" .md)
  desc=$(head -1 "$cmd" | sed 's/^[[:space:]]*//')
  loc="GLOBAL"
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

### Step 4: Detect Orphan Commands

Commands in `.claude/commands/` that reference skills not installed.

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
