---
description: (dotfiles) Clean junk from AI dev tool data directories (Claude Code, Cursor) — dry-run first, approval before delete
---

# Clean Up AI Tools

Reclaim space from AI dev tool cruft — same logic on any tool's structure. **Destructive — always dry-run first; delete only on explicit approval.**

Start with tooling analysis (per PROCESS).

## Discover targets

Identify which tools are present and their data directories — don't limit to these examples:
- Claude Code: `~/.claude`
- Cursor: `~/.cursor`, plus any project-scoped `.cursor/` dirs in recent repos

For each target, map the structure before touching anything.

## What counts as junk

Apply these categories to whatever structure the tool uses — don't limit to the examples:

- **Old session transcripts** — conversation logs older than 30 days; always keep the newest few per project regardless of age
- **Orphaned plugin/extension cache** — cached versions no longer referenced by the current install manifest
- **Stale staging dirs and unregistered marketplace/extension entries** — dirs left from incomplete installs, extensions not in any known registry
- **Temp and backup files** — `.bak`, probe files, one-off leftovers the tool drops
- **Old logs and expired backup archives** from memory/worker systems
- **Empty project dirs** left after transcript cleanup, as long as they contain no memory

## What to protect — never delete

Apply these principles, not a fixed path list:

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
2. **Scan** — identify junk candidates and config hygiene proposals; cross-check against protect principles and active session
3. **Present table** — deletions (size, age, total reclaim) and config proposals side by side
4. **USER APPROVAL** — delete only on explicit yes; allow deselecting individual items; config edits require separate approval
5. **Delete** approved items; report space reclaimed (before → after)

## Rules

- Warn if other sessions of the same tool appear active before deleting any transcript or worker data
- Never delete without approval
