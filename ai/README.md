# ai

[![Installer Tests](https://github.com/orbulescuvladiosif/dotfiles/actions/workflows/ai-installer-tests.yml/badge.svg)](https://github.com/orbulescuvladiosif/dotfiles/actions/workflows/ai-installer-tests.yml)

AI workflow harness for Claude Code and Cursor.

## Install

```powershell
iex (irm 'https://raw.githubusercontent.com/orbulescuvladiosif/dotfiles/master/ai/install.ps1')
```

Requires [caveman](https://github.com/JuliusBrussee/caveman) and [claude-mem](https://github.com/thedotmack/claude-mem). Installer warns if either is missing.

Claude Code: syncs to `~/.claude/`. Cursor: skills to `~/.cursor/skills/` (global); optional project rules into a git repo you choose.
