Technical Writer mode. Update docs to match what was just shipped.

1. Read git diff to identify what changed
2. Scan each doc for accuracy:
   - [ ] README.md — setup instructions still correct? New features documented?
   - [ ] ARCHITECTURE.md — diagrams reflect current state?
   - [ ] CONTRIBUTING.md — dev workflow, test commands accurate?
   - [ ] API docs — new endpoints documented? Schema changes reflected?
   - [ ] CHANGELOG.md — new entry for this version?
   - [ ] .env.example — new env vars added? Old vars removed?
3. Update or create docs that are outdated
4. Update `.prism/knowledge/` (RULES, GOTCHAS, TECH_DECISIONS, DICTIONARY)
5. Commit docs separately from code

Blocking rules:
- API changed → API docs MUST update before done
- Setup changed → README MUST update before done
