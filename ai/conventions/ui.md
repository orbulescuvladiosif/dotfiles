# UI

## UX patterns

- Prevent flash-of-spinner — pair async requests with a minimum loading delay
- Build error UX alongside the happy path
- Provide recovery: retry options, re-enabled forms, clear error messages
- Prevent dismiss (panel, dialog, etc.) during in-flight operations. Re-enable on completion

## Accessibility (WCAG 2.1 AA) — e.g.

- Use the right element for the job — `<button>`, `<a>`, `<table>`, `<nav>`, `<h1>`–`<h6>`. Avoid `<div>`/`<span>` for interactive or meaningful content
- Every interactive element needs an accessible name — visible text, `aria-label`, or `aria-labelledby`
- Every icon is either informative (needs label) or decorative (`aria-hidden="true"`)
- ARIA only when native semantics fall short
- Announce state changes: `role="status"` + `aria-live="polite"` for loading/empty/success. `role="alert"` for errors
- Manage focus: return to trigger after dialogs close; move focus to new content on context change
- All interactive elements reachable and operable via keyboard
- Visible focus indicators on every focusable element
- Logical tab order that follows visual layout
- Text must scale with user preferences
- Sufficient color contrast: 4.5:1 normal text, 3:1 large text
- Don't rely on color alone to convey meaning
- Respect `prefers-reduced-motion`

## Component tests

- Interact through user-visible behavior — clicks, keyboard input, rendered output. Click → assert output is standard
- Cover keyboard and a11y behavior
- Prefer accessible selectors (roles, labels) over classes or test-only attributes
- Setup cost is the bar
- Don't test pixel-perfect layout or framework compile mechanics

## E2E

- Each test runs independently — no reliance on other tests' state or order
- One user flow per test — don't chain unrelated assertions
- Wait for real conditions (elements, responses, navigation) — never hardcode timeouts
- Follow Page Object Model. Use the repo's existing POM if present; propose one before adding. Tests read as intent, not selectors
- Selector priority: role > accessible name (label, text, placeholder) > test id > class
- Assert what the user sees, not internal state
- Mock all API traffic — never hit a real backend
