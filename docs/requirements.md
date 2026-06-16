# AI Workflow Config — Requirements

What the `ai/` harness must do. Structural first, behavioral second.

## Repository

- Personal engineering config repo
- `.claude/` — repo-specific Claude config; never installed

## Harness (`ai/`)

- `AGENTS.md` — operating rules; first read on session start; routes `conventions/index`; mandates caveman, claude-mem, self-review via `review-this`
- `conventions/` — one concern per file; index lists logical names only; skills route by index name
- `skills/` — on-demand, single-concern workflows; gate checkpoints pull conventions; installed as Claude commands per `install.ps1`; description format: `(dotfiles) <verb> — <scope>[; gate]`
- `hooks/` — Claude Code hooks
- `install.ps1` — remote installer

## Gates

- Checkpoint in skill flow — pull conventions, validate prior output; human-in-the-loop counts
- `sdlc` orchestrates phased gates for non-trivial work
- `meta-review` (`.claude/commands/`) audits harness entities — conventions, installer hygiene, style

## Installer

- `iex (irm '<raw-url>/ai/install.ps1')`
- Syncs to `~/.claude/`; optional Cursor rules into user-chosen git repo
- Warns if caveman or claude-mem missing; idempotent; harness works without them
- Every `ai/` file in `install.ps1`; new conventions also update `conventions/index.md`

## Execution

- Scope inputs and outputs small; push back on oversized tasks or context
- No default subagent delegation — batching, compacting, memory handoffs
