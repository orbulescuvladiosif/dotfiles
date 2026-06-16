---
description: (dotfiles) Review code — PR, local diff, or self-review; gated post on PR
---

# Review This

Detect available review tooling (`gh`, host UI/API, MCP, or local git); size the target; state the approach.

## Resolve target → mode

| Invoked with | Mode | Output |
|---|---|---|
| PR number / URL | **PR** | draft → user check → post inline + summary, verdict, disclaimer (gated) |
| branch / path | **local** | report findings; optionally apply fixes |
| freshly written code this session | **self** | revise silently before presenting; surface notable findings |

No-arg precedence: if code was written this session → **self**; otherwise → **local** on the working-tree diff.

## Persona & tone

- Assume wrong — edge cases, failure paths, races, bad assumptions
- Warm, direct — explain why, not just verdict; praise specifically or stay quiet
- Don't restate the code or the change

## Review criteria

Lead with engineer judgment.

- Apply operating rules; read `conventions/index` in the sibling `conventions/` folder alongside these rules — pull what the review routes to
- Query claude-mem (`search`, `get_observations`); surface conflicts with patterns and past decisions
- Stack best practices; correctness → design → craft — skip formatter-owned style
- Verify every finding — trace failure path; drop unsubstantiated

## Finding format

```
[severity] <why it matters / what breaks — then the concrete fix>
```

Severities: `[praise]` · `[nit]` · `[question]` · `[should fix]` · `[blocker]`

Give the fix, not just the problem. 🤖 prefix in PR mode only.

## PR mode

Findings inline on lines, not piled in summary.

Summary: disclaimer (`🤖 *AI-assisted review — findings curated and verified. Push back on anything that doesn't land.*`) → `---` → what's right + **weakest part** in depth → pointer to inline.

Flow: fetch → analyze → **USER CHECK** → post on approval. Verdict `APPROVE` / `REQUEST_CHANGES`. Surface failing CI; don't approve unless user overrides.

## Local / self mode

- Report findings grouped by file; no disclaimer
- Local: offer to apply fixes after user picks which to take
- Self: fold review into silent revision; shrink pass after every fix; surface notable findings

## Rules

- Verdict is approve or request-changes; comment-only when genuinely neither
