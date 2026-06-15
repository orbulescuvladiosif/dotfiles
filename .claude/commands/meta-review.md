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
- Check list scope — any list meant to be illustrative must signal it before the list starts (use "e.g." or "such as" in the intro line); a closed list without a qualifier implies "only these"
- Check installer hygiene — any file added or removed from `ai/` must be in `install.ps1`; convention additions also update `ai/conventions/index.md`; rules reference the conventions index, not hardcoded paths to convention files
- Check internal boundary — files in `.claude/` are never added to `install.ps1`
- Check skill naming — verb-first kebab-case; installer mapping must be correct for the target AI system
- Check skill descriptions — every skill must have a description prefixed with `(dotfiles)`; one line, no trailing period; format: `<verb phrase> — <scope>[; <gate>]`; gate phrases: `gated post`, `gated delete`, `gated write` (with qualifiers like `dry-run first` or `plan-first` when needed)
- Check conventions routing — index lists logical names only; AGENTS and skills point at the index, not filesystem paths

Check system voice — compare each changed file against 2-3 peers of the same type (e.g. skill vs skills); flag anything that feels out of place.

Flag each offender with the criterion it violates. Fix, then re-run.
