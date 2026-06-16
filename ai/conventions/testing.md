# Testing

## Principles

- Test behavior, not implementation details
- Names: `it('should [outcome] when [condition]')` — domain terms, no HTTP verbs, RxJS operators, or framework jargon
- Optimize for value, not quantity — no redundant tests for the same behavior
- Arrange → Act → Assert

## Layers

- **Unit** — one thing in isolation. Fast. Coverage measures this layer.
- **Broader** — wiring, UI, integration, load
- Don't exhaustively re-test the same behavior at every level

## What to test — e.g.

- Business logic and data transformations
- Method behavior (params, return values, side effects)
- Edge cases (empty values, null/undefined, boundaries)
- Error scenarios in isolated units

## What not to test — e.g.

- Private/internal variables or methods
- Framework internals (DI wiring, lifecycle mechanics)
- Third-party library internals
- Trivial pass-through wrappers
- DI token declarations and static config objects with no behavior

## Unit tests

- One root `describe` per unit. Group related scenarios in nested `describe` blocks
- `beforeEach`/`afterEach` for repeatable setup. Clear stateful side effects between tests
- Mock external dependencies — don't hit real network, DB, or filesystem
- Unit-test services and helpers, not shells

## Coverage

- Thresholds apply to unit tests — broader suites have their own pass/fail checks
- Chase coverage on logic-bearing code. Thin glue may sit lower
- Don't paper over gaps with ignore comments
- Inline ignore for specific lines/branches only when genuinely untestable glue
- Use config exclusions for entire file categories that will never have unit tests (e.g. routes, config, index barrels, tokens, constants, enums)
- Don't use config exclusions to hide gaps in otherwise testable files
- Coverage thresholds are a floor, not the target
