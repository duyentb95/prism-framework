Upgrade PRISM to latest version. Pulls prism-playbook from git + updates current project.

$ARGUMENTS

Run these steps in order:

1. **Find prism-playbook source:**
   ```bash
   PRISM_SOURCE=$(cat ~/.prism/source-path 2>/dev/null)
   echo "Source path: ${PRISM_SOURCE:-NOT SET}"
   [ -n "$PRISM_SOURCE" ] && [ -d "$PRISM_SOURCE/.git" ] && echo "STATUS: LOCAL_REPO" || echo "STATUS: NEED_CLONE"
   ```

2. **If LOCAL_REPO** — pull latest:
   ```bash
   cd "$PRISM_SOURCE" && git pull origin main
   ```

3. **If NEED_CLONE** — clone from GitHub as fallback:
   ```bash
   mkdir -p ~/.prism/source
   git clone --depth 1 https://github.com/duyentb95/prism-playbook.git ~/.prism/source
   echo "$HOME/.prism/source" > ~/.prism/source-path
   PRISM_SOURCE="$HOME/.prism/source"
   ```

4. **Review before updating:** Show the user what changed:
   ```bash
   cd "$PRISM_SOURCE" && git log --oneline -10
   ```
   Ask for confirmation: "These commits will be applied. Update now?"

5. **Only after user confirms** — copy updated files:
   ```bash
   cp -r "$PRISM_SOURCE/.claude/commands/" .claude/commands/
   cp -r "$PRISM_SOURCE/.claude/skills/" .claude/skills/
   cp "$PRISM_SOURCE/.claude/settings.json" .claude/settings.json
   ```

6. **Report what changed:** Show git log of new commits pulled and list of updated files.
