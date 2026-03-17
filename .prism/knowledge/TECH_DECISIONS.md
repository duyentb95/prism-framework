# Technical Decisions

## 2026-03-17 — Bilingual docs (English + Vietnamese)
- **Context**: Framework originally had Vietnamese-only docs. Preparing for open-source.
- **Decision**: English as primary language, Vietnamese alongside for key concepts
- **Alternatives**: Vietnamese only (limits audience), English only (loses Vietnamese developer community)
- **Reasoning**: Professional open-source projects use English. Vietnamese community benefits from parallel translations.
- **Consequences**: All future docs must maintain both languages. README and GETTING-STARTED are bilingual.

## 2026-03-17 — gstack as git submodule (not copy, not fork)
- **Context**: Need gstack's 12 cognitive modes integrated into PRISM
- **Decision**: Use git submodule at `vendor/gstack/`
- **Alternatives**: Fork gstack (diverges from upstream), copy files (no updates), npm package (doesn't exist)
- **Reasoning**: Submodule tracks upstream exactly. `./setup --update` pulls latest. Users get both PRISM + gstack updates.
- **Consequences**: Users must use `--recursive` when cloning. Setup script handles missing submodule gracefully.

## 2026-03-17 — Match gstack SKILL.md format exactly
- **Context**: PRISM skills were simpler than gstack's production-quality format
- **Decision**: Adopt gstack's Preamble + AskUserQuestion + Step-by-step format for all PRISM skills
- **Alternatives**: Keep simple format (less consistent), create PRISM-specific format (fragmented ecosystem)
- **Reasoning**: Consistency. Users who learn one gstack skill can read any PRISM skill. Same mental model.
- **Consequences**: Every new PRISM skill must include version, Preamble, AskUserQuestion Format, and numbered Steps.

## 2026-03-17 — Lazy loading architecture for gstack integration
- **Context**: gstack total ~120K tokens across 12 SKILL.md files. Pre-loading all would exhaust context.
- **Decision**: 4-layer lazy loading via gstack-bridge. Only 1 SKILL.md loaded at a time.
- **Alternatives**: Pre-load all (120K+ tokens wasted), no gstack (lose cognitive modes)
- **Reasoning**: 84% token reduction. Peak ~22K vs 135K+ naive approach.
- **Consequences**: gstack-bridge must maintain accurate command → path mapping. Preamble runs once per session.
