---
description: (dotfiles) Clean junk from AI dev tool directories — Claude Code, Cursor; dry-run first, gated delete
---

# Clean Up AI Tools

**Destructive — dry-run first; delete only on explicit approval.**

Detect present tools and map data dirs first. Examples: Claude Code `~/.claude`; Cursor `~/.cursor` + project `.cursor/` dirs.

## What counts as junk

Apply these categories to whatever structure each tool uses (examples below):

- **Old transcripts** — >30 days; keep newest few per project
- **Orphaned plugin cache** — versions not in current manifest
- **Stale staging / unregistered extensions** — incomplete installs, unknown registry entries
- **Temp and backup** — `.bak`, probes, one-off leftovers
- **Old logs / expired memory backups**
- **Empty dirs** after transcript cleanup — only if no memory left

## What to protect — never delete

- Curated memory — `memory/` dirs, indexes, hand-written facts
- Active config — e.g. settings, commands, hooks, skills, rules, conventions
- Active session transcript; registries and manifests; live worker data (check PIDs)
- Unsure → "review manually," never delete

## Config hygiene — propose only, never auto-edit

- Inspect each tool's config for stale entries — e.g. dead MCP references, missing paths, orphaned permission rules, env vars for removed tools
- Write a temp backup before any edit; present exact entries to remove; edit only on approval

## Flow

1. **Disk picture** — size per tool before touching anything
2. **Scan** — junk + config hygiene; cross-check protect list and active session
3. **USER CHECK** — table of deletions and config proposals; deselect OK; separate approval for config edits
4. **Delete** approved; report reclaimed space

## Rules

- Warn if other sessions of the same tool appear active before deleting any transcript or worker data
