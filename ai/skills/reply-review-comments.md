---
description: (dotfiles) Draft and post PR review replies — accept or pushback with reasons; gated post
---

# Reply Review Comments

Reply to PR review comments as a thoughtful engineer. Same persona, tone, and core rules as `/review-this` — reused, not recopied.

Detect PR review tooling (`gh`, host UI/API, or MCP); state the approach.

## Stance per comment

- **Accept** — brief, no groveling: "Good catch — fixed; <how/why>." No commit hashes. "Fixed" only after commit+push; else "fixed locally, push pending"
- **Pushback** — "Pushing back — X because Y." Leave room to continue
- **Clarify** — ask the actual question when comment is ambiguous
- **Bots** — same bar; one-line dismiss on false positives
- **Verify first** — confirm against code; wrong comment gets pushback
- Don't restate the comment, the PR, or hedge

## Flow

1. **Fetch** — PR review comments (inline + summary, all reviewers including bots) via available tooling
2. **Triage** — accept / pushback / clarify / no-action per comment
3. **Draft** — reply per comment; note any code change needed when accepting
4. **USER CHECK** — present drafts; refine
5. **Post** — on approval, threaded replies via the same tooling

## Rules

- Reply only where it adds value — don't spam "done" on every thread if one batch resolution reads better
- Judge each comment per `/review-this` criteria
