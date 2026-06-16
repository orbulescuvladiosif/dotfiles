# Install and boundaries

**2026-06-15**

Original design: `curl | bash`, symlinks into `~/.claude/` and `~/.cursor/`.

`install.ps1` via `iex (irm ...)` — Windows-primary, remote-callable, idempotent. Syncs file contents from raw GitHub URL; no symlinks.

**2026-06-16** — Cursor skills global (`~/.cursor/skills/`); rules still per-repo

Claude Code: `~/.claude/`. Cursor: skills to `~/.cursor/skills/` (global); rules to `.cursor/rules/` in a git repo you choose — personal rules stay local via `.git/info/exclude`.

`ai/` is portable and installs out. `.claude/` at repo root stays here — repo governance (`meta-review`, harness change rules) only applies while working in this repo.

**2026-06-16** — Installer lib split + tests

`ai/install.ps1` is entry only; `ai/installer/manifest.ps1` holds sync manifest (`$SkillNames`, paths); `ai/installer/lib.ps1` holds logic. `ai/installer/` is dev-only — unit and integration tests under `tests/`; never installed.

**2026-06-16** — Remote in-memory bootstrap

`iex (irm …)` leaves `$PSScriptRoot` empty — entry fetches `manifest.ps1` then `lib.ps1` via `irm` before `Invoke-DotfilesInstall`. Seed URL matches `manifest` `$script:DefaultRepo` until manifest loads; local disk path still dot-sources `installer/lib.ps1`.
