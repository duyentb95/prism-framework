Initialize PRISM framework for this project.

1. Create `.prism/` folder structure:
   - `MASTER_PLAN.md`, `CONTEXT_HUB.md`, `DICTIONARY.md`
   - `tasks/`, `adhoc/`, `templates/`, `knowledge/` (with RULES.md, GOTCHAS.md, TECH_DECISIONS.md)
   - `designs/`, `qa-reports/`, `retros/`, `brainstorms/`, `context/`
2. Read any existing project files (README, package.json, pyproject.toml, etc.) to understand the codebase
3. Ask user interactively:
   - **WHY** — What is this project's purpose? Who is the audience?
   - **STANDARDS** — Tech stack, coding conventions, deployment target?
   - **WORKFLOW** — Solo or team? Sprint length? Review process?
4. Populate `CONTEXT_HUB.md` with answers
5. Create or update `CLAUDE.md` from `.claude/` templates if not present
6. If `.prism/` already exists, read existing state and report current status instead
