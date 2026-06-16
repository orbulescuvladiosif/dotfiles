---
description: (dotfiles) Consolidate memories — promote durable facts, clean stale/dupes; plan-first, gated write
---

# Consolidate Memories

Run on the machine you're consolidating from. Read what Claude Code and claude-mem stored here; promote durable facts into the dotfiles repo; user commits and runs the installer to sync every machine.

Scope: project name given → restrict to it; else scan all.

## Sources — Claude Code and claude-mem on this machine

Read what's available; skip and note unavailable:

1. **CC native memory** — `~/.claude/projects/*/memory/*.md`, project `MEMORY.md` indexes
2. **claude-mem** — `search` (filter decision/discovery/change/feature/bugfix), `get_observations`, `timeline` when needed; skip if worker down
3. **Cursor** — no queryable memory store; skip

## Promotion targets — dotfiles repo

Source-repo destinations, not installed-harness routing — commit here, run installer to sync.

| Target | What belongs there |
|---|---|
| `ai/AGENTS.md` | Cross-cutting operating rules — installer syncs to CLAUDE.md / agents.mdc |
| `ai/conventions/<name>` | Routed by `ai/conventions/index` — pick by task fit |
| `ai/skills/` | Recurring workflow not yet a skill |
| `ai/hooks/` | Session- or prompt-level automation |
| Native project `memory/` | Project-specific facts |

Never write to `ai/` directly — propose wording; user commits and runs the installer.

## Algorithm

1. **Gather** — all available sources; note skips
2. **Classify and clean each fact:**
   - Cross-cutting → map to dotfiles target above
   - Convention fact → read `ai/conventions/index`; pick name; target matching sibling file
   - Project-specific → native `memory/`
   - Narrow / stale / contradicts current state → drop
   - Duplicate → one home
   - Inconsistent → flag both; user resolves
3. **Proposal table:**

   | Fact | Source | Action | Target | Proposed wording |
   |---|---|---|---|---|
   | … | … | promote / move / drop / flag | … | … |

4. **USER CHECK** — present table; per-row veto OK
5. **Execute on approval:**
   - `ai/` → exact wording for user to paste and commit
   - Native `memory/` → write directly; update `MEMORY.md`
   - Drops → delete from source; update indexes
6. **Report** — moved, dropped, flagged, skipped

## Rules

- One fact, one home — no duplicates across hand-curated layers
- Never hand-edit claude-mem — promote copies to curated homes only
- Stale → drop; rewrite = new fact. Inconsistent → flag, user decides
