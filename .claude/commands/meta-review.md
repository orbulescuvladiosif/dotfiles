---
description: (dotfiles) Run meta-review — checklist for ai/ and .claude/ changes
---

# Meta Review

For each changed or added entry in this repo's AI setup (`ai/` or `.claude/`):

- Check style — imperative, verb-led, no periods on bullets, no pompous language; consistent with surrounding entries
- Check duplication — same concept stated elsewhere, even in different wording
- Check fit — belongs here and reads well in sequence
- Check scope — one rule, one concern; split or cut if doing two things
- Check actionability — concrete enough to act on
- Check length — every line earns its place; cut without losing essence
- Check list scope — any list meant to be illustrative must signal it before the list starts (use "e.g." or "such as" in the intro line); a closed list without a qualifier implies "only these"
- Check installer hygiene — any installable file added or removed from `ai/` must be in `ai/installer/manifest.ps1` (skills via `$SkillNames`); `ai/installer/` is dev-only and never installed; convention additions also update `ai/conventions/index.md`
- Check internal boundary — files in `.claude/` are never installed
- Check skill naming — verb-first kebab-case; `$SkillNames` in `ai/installer/manifest.ps1` must list every `ai/skills/*.md`; Claude maps to `commands/`; Cursor maps to `~/.cursor/skills/<name>/SKILL.md` with `name`, `description`, `disable-model-invocation: true`
- Check skill descriptions — every skill must have a description prefixed with `(dotfiles)`; one line, no trailing period; format: `<verb phrase> — <scope>[; <gate>]`; gate phrases: `gated post`, `gated delete`, `gated write` (with qualifiers like `dry-run first` or `plan-first` when needed)
- Check conventions routing — `ai/conventions/index.md` lists logical names only; `ai/AGENTS.md` uses portable sibling `conventions/index` routing (it installs out); `ai/` skills route by index name only — repo-specific content belongs in `.claude/`
- Check requirements alignment — when `docs/requirements.md` exists, verify changed `ai/` entries match the living spec; flag drift, stale inventories, or divergences that need a `docs/decisions/` record before requirements update

Check system voice — compare each changed file against 2-3 peers of the same type (e.g. skill vs skills); flag anything that feels out of place.

Flag each offender with the criterion it violates. Fix, shrink, then re-run.
