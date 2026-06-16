# ai

AI workflow harness for Claude Code and Cursor.

## Install

```powershell
iex (irm 'https://raw.githubusercontent.com/orbulescuvladiosif/dotfiles/master/ai/install.ps1')
```

Requires [caveman](https://github.com/JuliusBrussee/caveman) and [claude-mem](https://github.com/thedotmack/claude-mem). Installer warns if either is missing.

Claude Code: syncs to `~/.claude/`. Cursor: skills to `~/.cursor/skills/` (global); optional project rules into a git repo you choose.

## Installer dev

`ai/installer/` is dev-only — not installed to `~/.claude/`. Tests:

```powershell
powershell -NoProfile -File ai/installer/tests/unit/run.ps1
powershell -NoProfile -File ai/installer/tests/integration/run.ps1
```
