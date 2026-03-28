# Changelog

All notable changes to this project will be documented in this file.

## [3.0.0] - 2026-03-28

### Added
- Gate enforcement system: Plan → CEO Review → Eng Review → Implement → Ship
- GATE_STATUS.md template with soft gate checks and GSD bypass
- Gate check logic in ceo-review, eng-review, ship skills
- Gate write logic in /plan, /gsd commands
- Self-contained /office-hours command (YC Office Hours brainstorm)
- Self-contained /qa-only command (report-only QA)
- Default CLAUDE.md template for shipped package (`templates/CLAUDE.md`)

### Changed
- **Distribution model**: copy `.claude/` folder → run `/init-prism` (replaces bash setup script)
- Master-agent routing: local `.claude/skills/` only (no external loading)
- 12 commands rewritten to point to local skills instead of gstack
- 5 CLAUDE.md templates updated with gate flow and new command list
- README.md and GETTING-STARTED.md rewritten for v3 copy-folder install
- /init-prism: interactive setup replaces bash script
- /start: points to /init-prism instead of ./setup
- /retro: removed gstack delegation
- /prism-upgrade: copies files directly instead of running setup script
- paranoid-review, qa-engineer, ship-engineer, sprint-retro: removed gstack delegation checks

### Removed
- `setup` bash script (archived to `archive/setup-v2`)
- `vendor/gstack/` submodule and `.gitmodules`
- 9 gstack-dependent commands: browse, codex, design-consultation, gstack-upgrade, plan-design-review, qa-design-review, qa, setup-browser-cookies, skill-audit
- 3 gstack-dependent skills: browser-agent, gstack-bridge, design-auditor
- `commands/commands.md` (old reference doc)
- All gstack, greptile, codex references from active files

## [2.0.0] - 2026-03-26

### Added
- 7 internalized skills in `.claude/skills/`: ceo-review, eng-review, code-review, ship, investigate, document-release, safety
- Zero external dependency execution skills (2,447 lines total)

## [1.0.0] - 2026-03-20

### Added
- Initial PRISM framework with 12 skills, 32 commands
- gstack integration via submodule
- Setup script for global installation
- 5 CLAUDE.md templates (web-app, api-backend, data-pipeline, non-code, minimal)
