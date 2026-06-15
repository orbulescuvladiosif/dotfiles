---
description: (dotfiles) Draft and post an issue tracker ticket in PO/PM voice — problem, value, AC, scope. Gated post.
---

# Write Ticket

Write as a PO/PM — not as a developer. Flow: draft → refine → post on approval → link.

Start with tooling analysis (per PROCESS): detect which tracker is available (Jira MCP, Linear MCP, GitHub Issues via `gh`, or other); identify the target project and issue type.

## Voice (the core rule)

- Write from the user/business value angle: problem, who it affects, why it matters, acceptance criteria, scope / out-of-scope
- **No dev/implementation suggestions** unless the ticket is genuinely technical (infra, refactor, tech-debt) — then keep them minimal and clearly labelled
- PO voice **takes precedence** over mimicking past tickets

## Flow

1. **Gather** — search related tickets in the same scope (e.g. project, epic, labels) via the tracker's tools; read a few for house conventions — guidance only, not to copy their voice
2. **Draft** — produce the ticket: summary, description (problem → value → acceptance criteria → scope), suggested type / labels / priority; surface any required fields by inspecting project metadata
3. **USER CHECK / REFINE** — present the draft; revise until approved; do not post before approval
4. **Post** — on approval, create it in the right project and type via the tracker's tools
5. **Link / relate** — add links to related epics / tickets found in step 1; add a comment if needed
6. **Report** — the created key + URL + links made

## Rules

- Posting and linking are outward actions — gated behind explicit approval
- If no tracker is authenticated, stop and say so — don't fabricate a ticket ID
- Don't invent project keys, issue types, or field values — discover them; ask if ambiguous
