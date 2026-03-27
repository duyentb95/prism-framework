---
name: safety
description: "Safety guardrails: destructive command warnings (/careful), directory-scoped edit lock (/freeze), combined mode (/guard). Use when touching production, debugging live systems, or scoping edits."
model: sonnet
tools: ["Bash", "Read", "AskUserQuestion"]
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "bash ${CLAUDE_SKILL_DIR}/bin/check-careful.sh"
          statusMessage: "Checking for destructive commands..."
    - matcher: "Edit"
      hooks:
        - type: command
          command: "bash ${CLAUDE_SKILL_DIR}/bin/check-freeze.sh"
          statusMessage: "Checking freeze boundary..."
    - matcher: "Write"
      hooks:
        - type: command
          command: "bash ${CLAUDE_SKILL_DIR}/bin/check-freeze.sh"
          statusMessage: "Checking freeze boundary..."
---

# /safety — Safety Guardrails

This skill provides 4 modes: **careful**, **freeze**, **unfreeze**, and **guard**.
Detect which mode from $ARGUMENTS or the user's request.

## Mode detection

1. If arguments contain "careful" or user asked for "careful mode", "safety mode", "prod mode" → **careful** mode
2. If arguments contain "freeze" or user asked to "restrict edits", "only edit this folder", "lock edits" → **freeze** mode
3. If arguments contain "unfreeze" or user asked to "unlock edits", "remove freeze", "allow all edits" → **unfreeze** mode
4. If arguments contain "guard" or user asked for "full safety", "lock it down", "maximum safety" → **guard** mode (careful + freeze)
5. If no mode detected → ask the user which mode they want

---

## Mode: careful

Destructive command warnings are now **active**. Every Bash command is checked
against dangerous patterns before running. Warnings can be overridden.

### Protected patterns

| Pattern | Example | Risk |
|---------|---------|------|
| `rm -rf` / `rm -r` / `rm --recursive` | `rm -rf /var/data` | Recursive delete |
| `DROP TABLE` / `DROP DATABASE` | `DROP TABLE users;` | Data loss |
| `TRUNCATE` | `TRUNCATE orders;` | Data loss |
| `git push --force` / `-f` | `git push -f origin main` | History rewrite |
| `git reset --hard` | `git reset --hard HEAD~3` | Uncommitted work loss |
| `git checkout .` / `git restore .` | `git checkout .` | Uncommitted work loss |
| `kubectl delete` | `kubectl delete pod` | Production impact |
| `docker rm -f` / `docker system prune` | `docker system prune -a` | Container/image loss |

### Safe exceptions (no warning)

`rm -rf node_modules`, `.next`, `dist`, `__pycache__`, `.cache`, `build`, `.turbo`, `coverage`

Tell the user: "Careful mode active. Destructive commands will warn before executing. To deactivate, end the session."

---

## Mode: freeze

Restrict Edit/Write to a specific directory. Edits outside are **blocked** (denied, not just warned).

### Setup

Ask the user which directory to restrict edits to via AskUserQuestion:
- Question: "Which directory should I restrict edits to? Files outside this path will be blocked from editing."
- Text input (not multiple choice).

Once the user provides a path:

1. Resolve to absolute path:
```bash
FREEZE_DIR=$(cd "<user-provided-path>" 2>/dev/null && pwd)
echo "$FREEZE_DIR"
```

2. Save state (project-local):
```bash
FREEZE_DIR="${FREEZE_DIR%/}/"
mkdir -p .prism
echo "$FREEZE_DIR" > .prism/freeze-dir.txt
echo "Freeze boundary set: $FREEZE_DIR"
```

Tell the user: "Edits restricted to `<path>/`. Edits outside are blocked. Run `/unfreeze` to remove, or end the session."

---

## Mode: unfreeze

Remove the freeze boundary.

```bash
if [ -f .prism/freeze-dir.txt ]; then
  PREV=$(cat .prism/freeze-dir.txt)
  rm -f .prism/freeze-dir.txt
  echo "Freeze boundary cleared (was: $PREV). Edits allowed everywhere."
else
  echo "No freeze boundary was set."
fi
```

Tell the user the result.

---

## Mode: guard

Activates both **careful** (destructive command warnings) and **freeze** (edit boundary).

### Setup

Ask the user which directory to restrict edits to via AskUserQuestion:
- Question: "Guard mode: which directory should edits be restricted to? Destructive command warnings are always on. Files outside the chosen path will be blocked from editing."
- Text input (not multiple choice).

Then follow the same freeze setup steps above.

Tell the user:
- "**Guard mode active.** Two protections running:"
- "1. **Destructive command warnings** — rm -rf, DROP TABLE, force-push, etc. warn before executing"
- "2. **Edit boundary** — edits restricted to `<path>/`. Edits outside are blocked."
- "Run `/unfreeze` to remove the edit boundary. End session to deactivate everything."

---

## How hooks work

- **check-careful.sh**: Reads Bash command from stdin JSON, matches against destructive patterns, returns `permissionDecision: "ask"` with warning if matched
- **check-freeze.sh**: Reads file_path from stdin JSON, checks against freeze boundary in `.prism/freeze-dir.txt`, returns `permissionDecision: "deny"` if outside boundary
- Hooks are always registered. Careful fires on every Bash call. Freeze only fires when `.prism/freeze-dir.txt` exists.
- The trailing `/` on freeze dir prevents `/src` matching `/src-old`
- Freeze applies to Edit/Write only — Read, Bash, Glob, Grep are unaffected
