---
description: (dotfiles) Clean junk from AI dev tool directories — Claude Code, Cursor; dry-run first, gated delete
---

# Clean Up AI Tools

**Destructive — always dry-run first; delete only on explicit approval.**

Detect which tools are present; map each tool's data dirs before touching anything. Examples:
- Claude Code: `~/.claude`
- Cursor: `~/.cursor`, plus any project-scoped `.cursor/` dirs in recent repos

## What counts as junk

Apply these categories to whatever structure each tool uses (examples below):

- **Old session transcripts** — conversation logs older than 30 days; always keep the newest few per project regardless of age
- **Orphaned plugin/extension cache** — cached versions no longer referenced by the current install manifest
- **Stale staging dirs and unregistered marketplace/extension entries** — dirs left from incomplete installs, extensions not in any known registry
- **Temp and backup files** — `.bak`, probe files, one-off leftovers the tool drops
- **Old logs and expired backup archives** from memory/worker systems
- **Empty project dirs** left after transcript cleanup, as long as they contain no memory

## What to protect — never delete

- All curated memory — any `memory/` dirs, index files, and hand-written fact files
- Active config — settings files, commands, hooks, skills, rules
- The currently active session transcript
- Plugin/extension registry, install manifests, and enabled-plugin records
- Any running worker process's data (check for live PIDs before touching)
- Anything you're unsure about — list it as "review manually," don't delete

## Config hygiene — propose only, never auto-edit

- Inspect each tool's config for stale entries — e.g. dead MCP references, missing paths, orphaned permission rules, env vars for removed tools
- Write a temp backup before any edit; present exact entries to remove; edit only on approval

## Flow

1. **Disk picture** — report total size and biggest consumers per tool before any deletion
2. **Scan** — identify junk candidates and config hygiene proposals; cross-check against protect list and active session
3. **Present table** — deletions (size, age, total reclaim) and config proposals side by side
4. **USER CHECK** — delete only on explicit yes; allow deselecting individual items; config edits require separate approval
5. **Delete** approved items; report space reclaimed (before → after)

## Rules

- Warn if other sessions of the same tool appear active before deleting any transcript or worker data
