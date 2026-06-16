---
description: (dotfiles) Run SDLC — understand → plan → build → check → refine; gated
---

# SDLC

One path for non-trivial work — engineering is the common case. Effort scales inside phases; spine stays the same.

Entry: an ask, or a tracker ticket. Detect which; if ticket-led, fetch and ingest the ticket first.

## Step 0 — Tooling analysis

Per operating rules: one-line plan-of-attack, user vetoes before Phase 1.

## Phase 1 — Understand

### 1a. Cross-cutting dependencies (first)

Before diving into code on the path, map what sits outside it — when the work is org-scale (not a solo personal project). e.g.:

- Other teams, services, or repos that must change or approve
- Backend / platform / infra the feature depends on or blocks
- Contracts, APIs, env config, feature flags, migrations owned elsewhere
- Affected systems and blast radius

Solo personal project → skip or note "none" in one line.

### 1b. Scout and ingest

Gather everything on the path — e.g.:

- claude-mem (`search`, `get_observations`) — past decisions, patterns, prior work on this area
- Ticket body, linked epics, related tickets, acceptance criteria (if ticket-led)
- Repo rules per operating rules (`CLAUDE.md` / `AGENTS.md`, conventions as routed)
- Code, docs, PRs, and configs on the affected path
- CI, test layout, PR template if shipping is in scope

### 1c. Understanding brief

Synthesize — problem, constraints, dependencies, open questions. Pick artifact depth by scale:

| Scale | Artifacts |
|---|---|
| Tiny | Brief in chat — enough to plan |
| Medium | Invoke `/write-requirements` |
| Large | `/write-pvd` → `/write-requirements`; `/write-ticket` if tracking still needed |

**USER CHECK** — confirm understanding before plan. Misread here wastes everything after.

## Phase 2 — Plan

Switch to **plan mode**. Stay there. No code, no file edits for implementation.

Plan lives where the AI system puts it — internal plan artifact, not a repo doc.

Plan must cover: phases, files/systems touched, done-when, risks, dependency calls, what BUILD will execute.

**USER GATE** — hard stop. Veto or approve plan. Also pick **build mode** before Phase 3 — no BUILD until both are set:

| Mode | Behavior |
|---|---|
| **Autonomous** | Execute approved plan; no per-step asks unless a gate fires |
| **Checkpoint** | Pause between batches for user ok |
| **MITM** | User steers live throughout build |

## Phase 3 — Build

Exit plan mode → agent mode. Run in the build mode chosen at plan approval.

AI gates (visible — label meta steps so reasoning is traceable):

- Surface what runs — e.g. `claude-mem: searching…`, `self-review: pass`, `pre-quality: test/lint/build` — brief, not silent
- Pre-quality — test, lint, typecheck, build as the stack warrants; paste output (no fake done)
- Operating rules apply — self-review, destructive and outward gates

Note phase + state in claude-mem at session boundaries.

## Phase 4 — Check

Present: what changed, how to verify, known gaps.

- Draft PR per repo template (what + why) when shipping via PR
- `/review-this` **local** on the diff first

**USER GATE** — user reviews: run it, break it, read it.

## Phase 5 — Refine

Route by what the user's review conclusion looks like:

| Finding shape | Mode |
|---|---|
| Bullet list, small fixes | **Async** — user pastes bullets; fix; loop back to CHECK |
| Multi-layer, design smell, hard to articulate | **MITM** — live session; user steers; agent executes |

Loop until merge-ready. Then `/review-this` **PR** mode and `/reply-review-comments` when a PR has review threads.

## Fail loops

- Understanding wrong → Phase 1
- Plan wrong → Phase 2
- Implementation wrong → Phase 3
- Polish only → Phase 5 async

## Rules

- One orchestrator; personas live in the invoked skills and operating rules
- No subagent delegation unless the user explicitly overrides for a given task
