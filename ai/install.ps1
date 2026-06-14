$repo    = 'https://raw.githubusercontent.com/orbulescuvladiosif/dotfiles/master'
$claude  = Join-Path $HOME '.claude'
$updated = @()

function Sync-File($src, $dest) {
    $incoming = Invoke-RestMethod $src
    if (-not (Test-Path $dest) -or (Get-Content $dest -Raw) -ne $incoming) {
        New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null
        Set-Content -Path $dest -Value $incoming -Encoding UTF8
        return $true
    }
    return $false
}

if (Sync-File "$repo/ai/AGENTS.md"                    "$claude\CLAUDE.md")                          { $updated += 'CLAUDE.md' }
if (Sync-File "$repo/ai/conventions/engineering.md"   "$claude\conventions\engineering.md")          { $updated += 'conventions/engineering.md' }
if (Sync-File "$repo/ai/conventions/git.md"           "$claude\conventions\git.md")                  { $updated += 'conventions/git.md' }
if (Sync-File "$repo/ai/conventions/ui.md"            "$claude\conventions\ui.md")                   { $updated += 'conventions/ui.md' }

if ($updated.Count -gt 0) { Write-Host "Updated: $($updated -join ', ')" }
else                       { Write-Host 'Already up to date.' }

$settings = Join-Path $claude 'settings.json'
if (Test-Path $settings) {
    $j = Get-Content $settings -Raw | ConvertFrom-Json
    if (-not $j.enabledPlugins.'caveman@caveman')       { Write-Warning 'caveman not enabled — https://github.com/JuliusBrussee/caveman' }
    if (-not $j.enabledPlugins.'claude-mem@thedotmack') { Write-Warning 'claude-mem not enabled — https://github.com/thedotmack/claude-mem' }
}
