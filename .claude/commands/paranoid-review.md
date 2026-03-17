Paranoid Staff Engineer mode. Find bugs that pass CI but explode in production.

Target: $ARGUMENTS

Run the Paranoid Review checklist from CLAUDE.md:

For code:
- [ ] Race conditions — 2 tabs/requests simultaneously?
- [ ] N+1 queries — loops calling DB/API?
- [ ] Trust boundaries — trusting client input without validation?
- [ ] Missing error handling — API fail? Timeout?
- [ ] Stale data — cache invalidation correct?
- [ ] Security — injection, XSS, CSRF, secret exposure?
- [ ] Tests that lie — tests pass but miss real edge cases?

For non-code (reports, strategy, plans):
- [ ] Data accuracy — sources cross-checked?
- [ ] Logical gaps — conclusions follow from evidence?
- [ ] Audience mismatch — content matches WHO reads it?
- [ ] Missing edge cases — scenarios overlooked?
- [ ] Actionability — reader knows what to do next?

Report findings with severity levels. Suggest fixes.
