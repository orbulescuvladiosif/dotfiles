$repo    = 'https://raw.githubusercontent.com/orbulescuvladiosif/dotfiles/master'
$claude  = Join-Path $HOME '.claude'
$updated = @()

$skillNames = @(
    'clean-up-ai-tools',
    'reply-review-comments',
    'review-this',
    'consolidate-memories',
    'write-doc',
    'write-pvd',
    'write-requirements',
    'write-ticket',
    'sdlc',
    'init-repo-docs'
)

$cursorDetected = Test-Path (Join-Path $HOME '.cursor')

function Sync-File($src, $dest) {
    $incoming = ([string](Invoke-RestMethod $src)) -replace "`r`n", "`n"
    if (Test-Path $dest) {
        $existing = (Get-Content $dest -Raw -Encoding UTF8) -replace "`r`n", "`n"
        if ($existing -eq $incoming) { return $false }
    }
    New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null
    [System.IO.File]::WriteAllText($dest, $incoming, (New-Object System.Text.UTF8Encoding $false))
    return $true
}

function Convert-ToCursorSkill($raw, $name) {
    $raw = ([string]$raw) -replace "`r`n", "`n"
    if ($raw -notmatch '(?s)^---\n(.+?)\n---\n(.*)$') { throw "Invalid skill format: $name" }
    $frontmatter = $matches[1]
    $body        = $matches[2]
    $desc = if ($frontmatter -match '(?m)^description:\s*(.+)$') { $matches[1].Trim() } else { '' }
    if (-not $body.Trim()) { throw "Skill body empty after frontmatter: $name" }
    return "---`nname: $name`ndescription: $desc`ndisable-model-invocation: true`n---`n$body"
}

if (Sync-File "$repo/ai/AGENTS.md"                    "$claude\CLAUDE.md")                          { $updated += 'CLAUDE.md' }
if (Sync-File "$repo/ai/conventions/index.md"         "$claude\conventions\index.md")                { $updated += 'conventions/index.md' }
if (Sync-File "$repo/ai/conventions/engineering.md"   "$claude\conventions\engineering.md")          { $updated += 'conventions/engineering.md' }
if (Sync-File "$repo/ai/conventions/git.md"           "$claude\conventions\git.md")                  { $updated += 'conventions/git.md' }
if (Sync-File "$repo/ai/conventions/ui.md"            "$claude\conventions\ui.md")                   { $updated += 'conventions/ui.md' }
if (Sync-File "$repo/ai/hooks/statusline.ps1"         "$claude\hooks\statusline.ps1")                { $updated += 'hooks/statusline.ps1' }
foreach ($skill in $skillNames) {
    if (Sync-File "$repo/ai/skills/$skill.md" "$claude\commands\$skill.md") { $updated += "commands/$skill.md" }
}

if ($updated.Count -gt 0) { Write-Host "Claude Code: $($updated -join ', ')" }
else                       { Write-Host 'Claude Code: already up to date.' }

if ($cursorDetected) {
    Write-Host ''
    Write-Host 'Cursor detected. Rules and skills are project-scoped -- enter a repo path to install, or Enter to skip:'
    $cursorTarget = Read-Host '>'
    if ($cursorTarget) {
        if (-not (Test-Path (Join-Path $cursorTarget '.git'))) {
            Write-Warning "$cursorTarget is not a git repo. Skipping Cursor install."
        } else {
            $cursorRules   = Join-Path $cursorTarget '.cursor\rules'
            $cursorUpdated = @()
            New-Item -ItemType Directory -Force -Path $cursorRules | Out-Null

            $agentsContent = "---`nalwaysApply: true`n---`n" + (([string](Invoke-RestMethod "$repo/ai/AGENTS.md")) -replace "`r`n", "`n")
            $agentsDest    = Join-Path $cursorRules 'agents.mdc'
            $agentsExisting = if (Test-Path $agentsDest) { (Get-Content $agentsDest -Raw -Encoding UTF8) -replace "`r`n", "`n" } else { $null }
            if ($agentsExisting -ne $agentsContent) {
                [System.IO.File]::WriteAllText($agentsDest, $agentsContent, (New-Object System.Text.UTF8Encoding $false))
                $cursorUpdated += 'agents.mdc'
            }

            $conventionsDir = Join-Path $cursorRules 'conventions'
            New-Item -ItemType Directory -Force -Path $conventionsDir | Out-Null

            $cursorConventions = [ordered]@{
                'index.mdc'       = @{ src = 'ai/conventions/index.md';       desc = 'Convention index — routes tasks to convention files' }
                'engineering.mdc' = @{ src = 'ai/conventions/engineering.md'; desc = 'Engineering conventions' }
                'git.mdc'         = @{ src = 'ai/conventions/git.md';         desc = 'Git conventions' }
                'ui.mdc'          = @{ src = 'ai/conventions/ui.md';           desc = 'UI conventions' }
            }
            foreach ($name in $cursorConventions.Keys) {
                $entry   = $cursorConventions[$name]
                $content = "---`ndescription: $($entry.desc)`nalwaysApply: false`n---`n" + (([string](Invoke-RestMethod "$repo/$($entry.src)")) -replace "`r`n", "`n")
                $dest    = Join-Path $conventionsDir $name
                $existing = if (Test-Path $dest) { (Get-Content $dest -Raw -Encoding UTF8) -replace "`r`n", "`n" } else { $null }
                if ($existing -ne $content) {
                    [System.IO.File]::WriteAllText($dest, $content, (New-Object System.Text.UTF8Encoding $false))
                    $cursorUpdated += "conventions/$name"
                }
            }

            $cursorSkills = Join-Path $cursorTarget '.cursor\skills'
            foreach ($skill in $skillNames) {
                $content = Convert-ToCursorSkill ([string](Invoke-RestMethod "$repo/ai/skills/$skill.md")) $skill
                $dest    = Join-Path $cursorSkills "$skill\SKILL.md"
                $existing = if (Test-Path $dest) { (Get-Content $dest -Raw -Encoding UTF8) -replace "`r`n", "`n" } else { $null }
                if ($existing -ne $content) {
                    New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null
                    [System.IO.File]::WriteAllText($dest, $content, (New-Object System.Text.UTF8Encoding $false))
                    $cursorUpdated += "skills/$skill/SKILL.md"
                }
            }

            $exclude     = Join-Path $cursorTarget '.git\info\exclude'
            $excludeText = Get-Content $exclude -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
            $excludeEntries = @('.cursor/rules/agents.mdc', '.cursor/rules/conventions/', '.cursor/skills/')
            $missing = $excludeEntries | Where-Object { $excludeText -notlike "*$_*" }
            if ($missing) {
                $addition = "`n# dotfiles personal Cursor config`n" + ($missing -join "`n") + "`n"
                [System.IO.File]::AppendAllText($exclude, $addition, (New-Object System.Text.UTF8Encoding $false))
            }

            if ($cursorUpdated.Count -gt 0) { Write-Host "Cursor: $($cursorUpdated -join ', ')" }
            else                             { Write-Host 'Cursor: already up to date.' }
        }
    }
}

$settings = Join-Path $claude 'settings.json'
if (Test-Path $settings) {
    $j = Get-Content $settings -Raw | ConvertFrom-Json
    if (-not $j.enabledPlugins.'caveman@caveman')       { Write-Warning 'caveman not enabled — https://github.com/JuliusBrussee/caveman' }
    if (-not $j.enabledPlugins.'claude-mem@thedotmack') { Write-Warning 'claude-mem not enabled — https://github.com/thedotmack/claude-mem' }
    $statusCmd = "powershell -NoProfile -ExecutionPolicy Bypass -File `"$claude\hooks\statusline.ps1`""
    if (-not $j.statusLine -or $j.statusLine.command -ne $statusCmd) {
        $j | Add-Member -NotePropertyName 'statusLine' -NotePropertyValue ([PSCustomObject]@{ type = 'command'; command = $statusCmd }) -Force
        [System.IO.File]::WriteAllText($settings, ($j | ConvertTo-Json -Depth 10), (New-Object System.Text.UTF8Encoding $false))
        Write-Host "Updated: settings.json (statusLine)"
    }
}
