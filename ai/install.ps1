$repo    = 'https://raw.githubusercontent.com/orbulescuvladiosif/dotfiles/master'
$claude  = Join-Path $HOME '.claude'
$updated = @()

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

if (Sync-File "$repo/ai/AGENTS.md"                    "$claude\CLAUDE.md")                          { $updated += 'CLAUDE.md' }
if (Sync-File "$repo/ai/conventions/index.md"         "$claude\conventions\index.md")                { $updated += 'conventions/index.md' }
if (Sync-File "$repo/ai/conventions/engineering.md"   "$claude\conventions\engineering.md")          { $updated += 'conventions/engineering.md' }
if (Sync-File "$repo/ai/conventions/git.md"           "$claude\conventions\git.md")                  { $updated += 'conventions/git.md' }
if (Sync-File "$repo/ai/conventions/ui.md"            "$claude\conventions\ui.md")                   { $updated += 'conventions/ui.md' }
if (Sync-File "$repo/ai/hooks/statusline.ps1"         "$claude\hooks\statusline.ps1")                { $updated += 'hooks/statusline.ps1' }
if (Sync-File "$repo/ai/skills/clean-up-ai-tools.md"   "$claude\commands\clean-up-ai-tools.md")       { $updated += 'commands/clean-up-ai-tools.md' }
if (Sync-File "$repo/ai/skills/reply-review-comments.md" "$claude\commands\reply-review-comments.md") { $updated += 'commands/reply-review-comments.md' }
if (Sync-File "$repo/ai/skills/review-this.md"         "$claude\commands\review-this.md")             { $updated += 'commands/review-this.md' }
if (Sync-File "$repo/ai/skills/consolidate-memories.md" "$claude\commands\consolidate-memories.md")    { $updated += 'commands/consolidate-memories.md' }
if (Sync-File "$repo/ai/skills/write-doc.md"           "$claude\commands\write-doc.md")               { $updated += 'commands/write-doc.md' }
if (Sync-File "$repo/ai/skills/write-pvd.md"           "$claude\commands\write-pvd.md")               { $updated += 'commands/write-pvd.md' }
if (Sync-File "$repo/ai/skills/write-requirements.md" "$claude\commands\write-requirements.md")       { $updated += 'commands/write-requirements.md' }
if (Sync-File "$repo/ai/skills/write-ticket.md"        "$claude\commands\write-ticket.md")            { $updated += 'commands/write-ticket.md' }
if (Sync-File "$repo/ai/skills/sdlc.md"                "$claude\commands\sdlc.md")                    { $updated += 'commands/sdlc.md' }

if ($updated.Count -gt 0) { Write-Host "Claude Code: $($updated -join ', ')" }
else                       { Write-Host 'Claude Code: already up to date.' }

if ($cursorDetected) {
    Write-Host ''
    Write-Host 'Cursor detected. Rules are project-scoped -- enter a repo path to install, or Enter to skip:'
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

            $exclude     = Join-Path $cursorTarget '.git\info\exclude'
            $excludeText = Get-Content $exclude -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
            $excludeEntries = @('.cursor/rules/agents.mdc', '.cursor/rules/conventions/')
            $missing = $excludeEntries | Where-Object { $excludeText -notlike "*$_*" }
            if ($missing) {
                $addition = "`n# dotfiles personal rules`n" + ($missing -join "`n") + "`n"
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
