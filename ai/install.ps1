$repo    = 'https://raw.githubusercontent.com/orbulescuvladiosif/dotfiles/master'
$claude  = Join-Path $HOME '.claude'
$updated = @()

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
if (Sync-File "$repo/ai/skills/write-doc.md"           "$claude\commands\write-doc.md")               { $updated += 'commands/write-doc.md' }

if ($updated.Count -gt 0) { Write-Host "Updated: $($updated -join ', ')" }
else                       { Write-Host 'Already up to date.' }

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
