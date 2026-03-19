# Eng Review: PRISM Auto-Update via Symlink Architecture

**Date:** 2026-03-20
**Commit:** 96650e6
**Design doc:** office-hours_auto-update-symlink_2026-03-20.md
**Status:** CLEARED

## Scope (Reduced from design doc)

Design doc proposed `~/.prism/` as full shared location for both skills + commands.
Review found: skills already live globally at `~/.claude/skills/` — no need to duplicate.

**Final scope:** `~/.prism/` for commands only + version marker. Skills stay global.

## Architectural Decisions Locked In

### 1. Per-file symlink (not directory symlink)
- Projects keep real `.claude/commands/` directory
- Each PRISM command is symlinked individually
- Project-specific commands (real files) coexist with PRISM symlinks
- Trade-off: need re-link when PRISM adds new commands

### 2. Commands only — skills stay global
- `~/.claude/skills/` is already the single source of truth for skills
- No symlink needed for skills — they're never copied to projects
- gstack-bridge preamble already checks global path

### 3. `--update` auto-relinks all registered projects
- `~/.prism/projects.list` tracks setup'd project paths
- `./setup --update` refreshes `~/.prism/commands/` + relinks all projects
- Stale projects (deleted/moved) gracefully skipped
- Custom (non-symlink) commands in projects preserved

## Implementation Spec

```
~/.prism/
├── version              ← PRISM version string
├── commands/            ← Source of truth for slash commands
└── projects.list        ← Registry of setup'd project paths

setup --project:
  1. [existing] Create .prism/, interview, CLAUDE.md
  2. [modified] Symlink commands: for f in ~/.prism/commands/*.md → ln -sf
  3. [new] Register project path in ~/.prism/projects.list
  4. [new] Write .prism-source marker

setup --update:
  1. [existing] Pull gstack, install_global
  2. [new] Refresh ~/.prism/commands/
  3. [new] For each project in projects.list:
     - Verify path exists
     - Symlink new commands
     - Remove stale symlinks (command deleted from PRISM)
     - Skip custom (non-symlink) files
```

## Files to modify

| File | Change |
|---|---|
| `setup` | Modify `setup_project()`, `update_all()`, `check_status()`. Add `populate_prism_shared()`, `relink_project()` |

## Failure modes

- 0 critical gaps
- 3 minor gaps (mkdir -p, path existence check, dedup registry)

## NOT in scope

- Version pinning / rollback (Phase 2)
- Claude Code session hook
- Windows support
- GitHub Actions cascade
- Skill marketplace
