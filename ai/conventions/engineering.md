# Engineering

- Use the simplest solution. KISS, YAGNI, SoC, Fail Fast
- DRY at 3+ duplicates
- Leave file slightly cleaner than you found it
- Don't expand scope beyond the ask — spot something? Mention it, don't fix it
- Keep names descriptive — code should read clearly
- Think product and high-level — perspective, not tunnel vision
- Design for failure — consider error paths, not just the happy path
- Keep orchestration thin — business logic in services, helpers, or pure functions; shells wire and render
- No noise comments that restate the code
- No commented-out code without a TODO and linked issue
- TODOs require a linked issue: `// TODO (#123): reason`
- Comment only when the code cannot explain the why
- When you comment — sentences end with a period; fragments don't
