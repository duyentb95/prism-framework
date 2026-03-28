# CLAUDE.md — {{PROJECT_NAME}}

## How to Work

1. **ASK before doing** -- Don't jump to code. Ask: "What are you trying to achieve? Who uses this page?"
2. **Design before build** -- Present component structure, data flow, UI layout. Wait for approval.
3. **Plan before execute** -- Break into micro-tasks (2-10 min each). Type GO to start.
4. **Small tasks -> just do it** -- Bug fixes, style tweaks, copy changes: no planning needed (GSD mode).

## Project Context

**What**: {{PROJECT_DESCRIPTION}}
**Why**: [Why does it exist? What user problem does it solve?]
**Who**: {{PROJECT_AUDIENCE}}
**Stack**: {{TECH_STACK}}
**Styling**: [e.g., Tailwind CSS / CSS Modules / styled-components]
**State**: [e.g., React Query + Zustand / Redux / Pinia]
**API**: [e.g., REST via fetch / GraphQL via Apollo / tRPC]
**Testing**: [e.g., Vitest + Testing Library / Jest + Cypress]
**Deploy**: [e.g., Vercel / Netlify / Docker + VPS]

## Web App Standards

### UI/UX
- Mobile-first -- design for 375px, then scale up
- Semantic HTML -- use `nav`, `main`, `article`, `section`, not div soup
- Accessibility -- keyboard navigation, ARIA labels, color contrast
- Loading states for async operations -- never show blank screens
- Error states with helpful messages -- not just "Something went wrong"

### Performance
- No N+1 API calls in loops -- batch requests
- Images: lazy load, proper sizing, WebP/AVIF when possible
- Bundle: no unnecessary large dependencies
- Server components / SSR where appropriate

### Security
- Validate all user input (client AND server)
- No `dangerouslySetInnerHTML` with user data
- Auth checks on every protected route (not just frontend guards)
- No secrets in client-side code

## PRISM Workflow

Type `/start` to begin -- it detects your project state and guides you.

### Gate Flow (enforced for complex tasks)
```
/plan → /ceo-review → /eng-review → implement → /review → /ship
```
Each gate must pass before the next. `/gsd` bypasses all gates for quick tasks.

### Quick Reference
- Think:   /brainstorm, /office-hours, /ceo-review, /eng-review
- Plan:    /plan -> GO
- Build:   /gsd (quick) or sub-agents (complex)
- Check:   /paranoid-review, /qa-check, /qa-only
- Ship:    /ship, /document-release
- Learn:   /retro
- Context: /start, /status, /compact, /adhoc

### Rules
- NEVER jump straight to code. Ask WHY first, design, then plan.
- Complex tasks: /plan -> wait for GO -> execute through gate flow.
- Quick tasks (< 15 min): /gsd -- no planning needed, gates bypassed.
- Long sessions: /compact to save state, resume in fresh session.
- Knowledge: append to .prism/knowledge/ when you learn something new.

## Knowledge

- Read `.prism/knowledge/` before starting -- patterns and traps from previous sessions.
- After learning something new, append to:
  - `RULES.md` -- component patterns, styling conventions
  - `GOTCHAS.md` -- browser quirks, SSR issues, hydration mismatches
  - `TECH_DECISIONS.md` -- why we chose library X over Y

## Session Handoff

If conversation gets long: write state to `.prism/STAGING.md`, start fresh session.
