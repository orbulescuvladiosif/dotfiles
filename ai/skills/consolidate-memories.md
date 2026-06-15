---
description: (dotfiles) Consolidate memories — promote durable facts, clean stale/dupes; plan-first, gated write
---

# Consolidate Memories

Promotes durable facts to their right harness layer; cleans stale entries, dupes, and inconsistencies. **Plan-first: never write until the user approves.**

Scope: if a project name is given, restrict to it; otherwise scan all.

## Sources

Read what's available; skip and note any source that's unavailable:

1. **CC native memory** — `~/.claude/projects/*/memory/*.md` and each project's `MEMORY.md` index
2. **claude-mem** — query via MCP (`smart_search`, `get_observations`) filtered to high-signal types: `decision`, `discovery`, `refactor`, `change`; if the worker is down, skip and continue
3. **Cursor memory** — Cursor has no queryable memory store (rules are config, not recall); skip

## Promotion targets

| Target | What belongs there |
|---|---|
| `ai/AGENTS.md` | Cross-cutting behavior rules |
| `ai/conventions/` | Patterns, standards, style decisions reusable across projects |
| `ai/skills/` | A recurring workflow not yet a skill |
| `ai/hooks/` | Session- or prompt-level automation |
| Native project `memory/` | Project-specific facts |

**Skill never writes to `ai/` directly** — those are repo files governed by the dotfiles workflow. Propose the wording; the user commits and runs the installer.

## Algorithm

1. **Gather** — read all available sources; note anything skipped
2. **Classify each fact:**
   - Harness-wide → map to the right `ai/` target above
   - Project-specific → native project `memory/` (stays or moves there from claude-mem)
   - Narrow / no lasting value → mark for drop
3. **Cleanup pass — run alongside classification:**
   - **Stale** — fact contradicts current code, config, or a more recent fact; mark for removal
   - **Duplicate** — same fact in multiple sources, even in different wording; consolidate to one home
   - **Inconsistent** — conflicting facts; flag both, don't silently pick one
4. **Build the proposal table:**

   | Fact | Source | Action | Target | Proposed wording |
   |---|---|---|---|---|
   | … | … | promote / move / drop / flag | … | … |

5. **STOP — present the table.** Get explicit approval before touching anything. Allow per-row veto.
6. **Execute on approval:**
   - `ai/` promotions → output exact wording for the user to paste and commit
   - Native `memory/` writes → write directly; update the project's `MEMORY.md` index
   - Drops → delete from source; update any index
   - Inconsistencies → present both sides; resolve only after the user picks one
7. **Report** — what moved, what was dropped, what was flagged, what was skipped

## Rules

- One fact, one home — never leave a promoted fact duplicated across hand-curated layers
- Never hand-edit claude-mem — it's the auto-firehose; curated copies live in their promoted home
- Stale facts get dropped, not updated — if the fact needs rewriting it's a new fact
- Flag inconsistencies without resolving them — the user decides, not the skill
