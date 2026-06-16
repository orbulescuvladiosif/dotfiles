if (-not (Get-Variable -Name SkillNames -Scope Script -ErrorAction SilentlyContinue)) {
    . (Join-Path $PSScriptRoot 'manifest.ps1')
}

$script:Utf8NoBom = New-Object System.Text.UTF8Encoding $false

function Normalize-Text($text) {
    return ([string]$text) -replace "`r`n", "`n"
}

function Write-Utf8File($path, $content) {
    [System.IO.File]::WriteAllText($path, $content, $script:Utf8NoBom)
}

function Get-RepoUrl($repoBase, $relativePath) {
    return "$repoBase/$relativePath"
}

function Sync-Content($incoming, $dest) {
    $incoming = Normalize-Text $incoming
    if (Test-Path $dest) {
        $existing = Normalize-Text (Get-Content $dest -Raw -Encoding UTF8)
        if ($existing -eq $incoming) { return $false }
    }
    New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null
    Write-Utf8File $dest $incoming
    return $true
}

function Sync-File($src, $dest, [scriptblock]$FetchContent) {
    if (-not $FetchContent) {
        $FetchContent = { param($url) [string](Invoke-RestMethod $url) }
    }
    return Sync-Content (& $FetchContent $src) $dest
}

function Convert-ToCursorSkill($raw, $name) {
    $raw = Normalize-Text $raw
    if ($raw -notmatch '(?s)^---\n(.+?)\n---\n(.*)$') { throw "Invalid skill format: $name" }
    $frontmatter = $matches[1]
    $body        = $matches[2]
    $desc = if ($frontmatter -match '(?m)^description:\s*(.+)$') { $matches[1].Trim() } else { '' }
    if (-not $body.Trim()) { throw "Skill body empty after frontmatter: $name" }
    return "---`nname: $name`ndescription: $desc`ndisable-model-invocation: true`n---`n$body"
}

function Convert-ToCursorAgentsMdc($raw) {
    return "---`nalwaysApply: true`n---`n" + (Normalize-Text $raw)
}

function Convert-ToCursorConventionMdc($raw, $desc) {
    return "---`ndescription: $desc`nalwaysApply: false`n---`n" + (Normalize-Text $raw)
}

function Get-MissingExcludeEntries($excludeText, $entries) {
    return @($entries | Where-Object { $excludeText -notlike "*$_*" })
}

function Format-ExcludeAddition($missing) {
    if (-not $missing -or @($missing).Count -eq 0) { return $null }
    return "`n# dotfiles personal Cursor config`n" + ($missing -join "`n") + "`n"
}

function Update-ExcludeFile($excludePath, $entries) {
    $excludeText = Get-Content $excludePath -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
    $missing     = Get-MissingExcludeEntries $excludeText $entries
    $addition    = Format-ExcludeAddition $missing
    if (-not $addition) { return $false }
    New-Item -ItemType Directory -Force -Path (Split-Path $excludePath) | Out-Null
    [System.IO.File]::AppendAllText($excludePath, $addition, $script:Utf8NoBom)
    return $true
}

function Get-StatusLineCommand($claudeDir) {
    return "powershell -NoProfile -ExecutionPolicy Bypass -File `"$claudeDir\hooks\statusline.ps1`""
}

function Get-ClaudePluginWarnings($settingsJson) {
    $warnings = @()
    if (-not $settingsJson.enabledPlugins.'caveman@caveman') {
        $warnings += 'caveman not enabled — https://github.com/JuliusBrussee/caveman'
    }
    if (-not $settingsJson.enabledPlugins.'claude-mem@thedotmack') {
        $warnings += 'claude-mem not enabled — https://github.com/thedotmack/claude-mem'
    }
    return $warnings
}

function Update-ClaudeSettings($settingsPath, $claudeDir) {
    if (-not (Test-Path $settingsPath)) {
        return @{ found = $false; updated = $false; warnings = @() }
    }
    $j         = Get-Content $settingsPath -Raw | ConvertFrom-Json
    $warnings  = Get-ClaudePluginWarnings $j
    $statusCmd = Get-StatusLineCommand $claudeDir
    $updated   = $false
    if (-not $j.statusLine -or $j.statusLine.command -ne $statusCmd) {
        $j | Add-Member -NotePropertyName 'statusLine' -NotePropertyValue ([PSCustomObject]@{ type = 'command'; command = $statusCmd }) -Force
        Write-Utf8File $settingsPath ($j | ConvertTo-Json -Depth 10)
        $updated = $true
    }
    return @{ found = $true; updated = $updated; warnings = $warnings }
}

function Sync-CursorSkill($raw, $name, $dest) {
    return Sync-Content (Convert-ToCursorSkill $raw $name) $dest
}

function Install-ClaudeCode($repoBase, $claudeDir, $skillNames, $claudeSyncPaths, $fetchContent) {
    $updated = @()
    foreach ($entry in $claudeSyncPaths) {
        $src  = Get-RepoUrl $repoBase $entry.src
        $dest = Join-Path $claudeDir $entry.dest
        if (Sync-File $src $dest $fetchContent) { $updated += $entry.label }
    }
    foreach ($skill in $skillNames) {
        $src  = Get-RepoUrl $repoBase "ai/skills/$skill.md"
        $dest = Join-Path $claudeDir "commands\$skill.md"
        if (Sync-File $src $dest $fetchContent) { $updated += "commands/$skill.md" }
    }
    return $updated
}

function Install-CursorSkills($repoBase, $cursorSkillsDir, $skillNames, $fetchContent) {
    $updated = @()
    foreach ($skill in $skillNames) {
        $raw  = & $fetchContent (Get-RepoUrl $repoBase "ai/skills/$skill.md")
        $dest = Join-Path $cursorSkillsDir "$skill\SKILL.md"
        if (Sync-CursorSkill $raw $skill $dest) { $updated += "skills/$skill/SKILL.md" }
    }
    return $updated
}

function Install-CursorRules($repoBase, $cursorTarget, $cursorConventions, $excludeEntries, $fetchContent) {
    if (-not (Test-Path (Join-Path $cursorTarget '.git'))) {
        return @{ ok = $false; updated = @() }
    }
    $cursorRules = Join-Path $cursorTarget '.cursor\rules'
    $updated     = @()
    New-Item -ItemType Directory -Force -Path $cursorRules | Out-Null

    $agentsContent = Convert-ToCursorAgentsMdc (& $fetchContent (Get-RepoUrl $repoBase 'ai/AGENTS.md'))
    if (Sync-Content $agentsContent (Join-Path $cursorRules 'agents.mdc')) { $updated += 'agents.mdc' }

    $conventionsDir = Join-Path $cursorRules 'conventions'
    New-Item -ItemType Directory -Force -Path $conventionsDir | Out-Null
    foreach ($name in $cursorConventions.Keys) {
        $entry   = $cursorConventions[$name]
        $content = Convert-ToCursorConventionMdc (& $fetchContent (Get-RepoUrl $repoBase $entry.src)) $entry.desc
        if (Sync-Content $content (Join-Path $conventionsDir $name)) { $updated += "conventions/$name" }
    }

    Update-ExcludeFile (Join-Path $cursorTarget '.git\info\exclude') $excludeEntries | Out-Null
    return @{ ok = $true; updated = $updated }
}

function Invoke-DotfilesInstall {
    param(
        [string]$RepoBase = $script:DefaultRepo,
        [string]$ClaudeDir = (Join-Path $HOME '.claude'),
        [string]$CursorSkillsDir = (Join-Path $HOME '.cursor\skills'),
        [string]$CursorDir,
        [scriptblock]$FetchContent = { param($url) [string](Invoke-RestMethod $url) },
        [string]$CursorRulesTarget,
        [switch]$SkipCursorRules,
        [scriptblock]$PromptCursorRules = { Read-Host '>' }
    )

    $updated = Install-ClaudeCode $RepoBase $ClaudeDir $script:SkillNames $script:ClaudeSyncPaths $FetchContent
    if ($updated.Count -gt 0) { Write-Host "Claude Code: $($updated -join ', ')" }
    else                      { Write-Host 'Claude Code: already up to date.' }

    $settings = Update-ClaudeSettings (Join-Path $ClaudeDir 'settings.json') $ClaudeDir
    foreach ($w in $settings.warnings) { Write-Warning $w }
    if ($settings.found -and $settings.updated) {
        Write-Host 'Claude Code: updated settings.json (statusLine)'
    } elseif (-not $settings.found) {
        Write-Host 'Claude Code: no settings.json — skipped plugin and statusLine checks.'
    }

    $cursorRoot = if ($PSBoundParameters.ContainsKey('CursorDir')) { $CursorDir } else { Join-Path $HOME '.cursor' }
    if (-not (Test-Path $cursorRoot)) {
        Write-Host 'Cursor: not detected (~/.cursor missing) — skipping skills and rules.'
        return
    }

    $skillsUpdated = Install-CursorSkills $RepoBase $CursorSkillsDir $script:SkillNames $FetchContent
    if ($skillsUpdated.Count -gt 0) { Write-Host "Cursor skills: $($skillsUpdated -join ', ')" }
    else                            { Write-Host 'Cursor skills: already up to date.' }

    if ($SkipCursorRules) { return }

    if (-not $PSBoundParameters.ContainsKey('CursorRulesTarget')) {
        Write-Host ''
        Write-Host 'Cursor rules are project-scoped -- enter a repo path to install, or Enter to skip:'
    }
    $cursorTarget = if ($PSBoundParameters.ContainsKey('CursorRulesTarget')) { $CursorRulesTarget } else { & $PromptCursorRules }
    if (-not $cursorTarget) { return }

    $rules = Install-CursorRules $RepoBase $cursorTarget $script:CursorConventions $script:ExcludeEntries $FetchContent
    if (-not $rules.ok) {
        Write-Warning "$cursorTarget is not a git repo. Skipping Cursor rules install."
        return
    }
    if ($rules.updated.Count -gt 0) { Write-Host "Cursor rules: $($rules.updated -join ', ')" }
    else                            { Write-Host 'Cursor rules: already up to date.' }
}
