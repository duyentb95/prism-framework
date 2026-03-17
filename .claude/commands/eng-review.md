Engineering Manager mode. Lock in technical design.

Topic: $ARGUMENTS

Follow Eng Review checklist from CLAUDE.md. Present each section for user approval:

1/6 **Architecture**: Component diagram + explain. → OK?
2/6 **Data Flow**: Sequence diagram for happy path. → OK?
3/6 **Failure Modes**: Table — scenario | impact | mitigation. → OK?
4/6 **Edge Cases**: Concurrency, empty states, scale differences. → OK?
5/6 **Trust Boundaries**: Input validation, external API trust, secret protection. → OK?
6/6 **Test Matrix**: Unit, integration, edge case test coverage. → OK?

"Diagrams force hidden assumptions into the open."

Use ASCII diagrams. Present sections one at a time, wait for approval.
Save output to `.prism/designs/eng-review_{topic}_{date}.md`
