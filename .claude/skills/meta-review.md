# Meta Review

For each changed or added entry in this repo's AI setup (`ai/` or `.claude/`):

- Check style — imperative, verb-led, no periods on bullets, no pompous language; consistent with surrounding entries
- Check duplication — same concept stated elsewhere, even in different wording
- Check fit — belongs here and reads well in sequence
- Check scope — one rule, one concern; split or cut if doing two things
- Check actionability — concrete enough to act on
- Check installer hygiene — any file added or removed from `ai/` must be in `install.ps1`; convention additions also update `conventions/index.md`; no rule references bare `conventions/` as a path
- Check internal boundary — files in `.claude/` are never added to `install.ps1`

Flag each offender with the criterion it violates. Fix, then re-run.
