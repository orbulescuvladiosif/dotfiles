# Install and boundaries

**2026-06-15**

Original design: `curl | bash`, symlinks into `~/.claude/` and `~/.cursor/`.

`install.ps1` via `iex (irm ...)` — Windows-primary, remote-callable, idempotent. Syncs file contents from raw GitHub URL; no symlinks.

Claude Code: `~/.claude/`. Cursor: project-scoped into a git repo you choose — matches how Cursor rules work; personal rules stay local via `.git/info/exclude`.

`ai/` is portable and installs out. `.claude/` at repo root stays here — repo governance (`meta-review`, harness change rules) only applies while working in this repo.
