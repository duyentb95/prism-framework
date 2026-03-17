# Gotchas & Lessons Learned

## 2026-03-17 — gstack symlinks not created by manual clone
- **Problem**: `git clone` gstack to `~/.claude/skills/gstack/` but gstack commands show as warnings in `./setup --status`
- **Root cause**: `./setup --status` checks for symlinks (e.g., `~/.claude/skills/plan-ceo-review` → `gstack/plan-ceo-review/`). Manual clone + `./setup` inside gstack may not create these.
- **Fix**: Not critical — gstack-bridge resolves paths directly via `gstack/plan-ceo-review/SKILL.md`. Symlinks are optional convenience.
- **Prevention**: Document that `./setup --status` warnings for gstack skills are cosmetic if gstack is installed and commands work.

## 2026-03-17 — git push rejected on fresh repo with existing remote
- **Problem**: `git push -u origin main` rejected because remote had existing commits (README from GitHub init)
- **Root cause**: GitHub creates an initial commit when you check "Add README" during repo creation
- **Fix**: `git pull origin main --rebase --allow-unrelated-histories` then push
- **Prevention**: Either create GitHub repo without README, or always pull-rebase before first push

## 2026-03-17 — PRISM skills lacked AskUserQuestion Format
- **Problem**: All 5 PRISM skills had no standardized question format. Sub-agents would ask poorly structured questions.
- **Root cause**: Original skills were written before studying gstack patterns
- **Fix**: Added AskUserQuestion Format section to all 5 skills (Re-ground → Simplify → Recommend → Options)
- **Prevention**: Always check gstack SKILL.md as reference when writing new skills
