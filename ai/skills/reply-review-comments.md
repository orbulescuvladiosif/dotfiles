---
description: (dotfiles) Draft and post replies to PR review comments — genuine accept or reasoned pushback, gated post
---

# Reply Review Comments

Reply to PR review comments as a thoughtful engineer. Same persona, tone, and core rules as `/review-this` — reused, not recopied.

Start with tooling analysis (per PROCESS).

## Stance per comment

- **Genuine accept** — "Good catch — fixed; <one line on how/why>." Brief, no groveling. Never reference a commit hash. Only say "fixed" once the change is actually committed and pushed — make the fix first, then reply. If not yet done, say "will fix"
- **Reasoned pushback** — "Pushing back — I think X because Y." State the why; leave it open to continue
- **Clarify** — when the comment is ambiguous, ask the actual question
- **Bots** — same bar; accept real catches, dismiss false positives with a one-line reason; no rubber-stamp, no over-explaining
- **Verify before agreeing** — confirm the comment is correct against the code before accepting; a wrong comment gets pushback, not a reflexive "done"
- Don't restate the comment or what the PR does; don't hedge

## Flow

1. **Fetch** — PR review comments (inline + summary, all reviewers including bots) via `gh`
2. **Triage** — accept / pushback / clarify / no-action per comment
3. **Draft** — reply per comment; note any code change needed when accepting
4. **USER CHECK** — present drafts; refine
5. **Post** — on approval, threaded replies via `gh`

## Rules

- Posting is an outward action — gated behind explicit approval
- Reply only where it adds value — don't spam "done" on every thread if one batch resolution reads better
- Apply `AGENTS.md`, `conventions/index.md`, and general best practices when judging whether a comment is right
