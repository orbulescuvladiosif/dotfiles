$repo = 'https://raw.githubusercontent.com/orbulescuvladiosif/dotfiles/master'
$target = Join-Path $HOME ".claude\CLAUDE.md"
$updated = @()

$incoming = Invoke-RestMethod "$repo/ai/AGENTS.md"
if (-not (Test-Path $target) -or (Get-Content $target -Raw) -ne $incoming) {
    Set-Content -Path $target -Value $incoming -Encoding UTF8
    $updated += 'CLAUDE.md'
}

if ($updated.Count -gt 0) {
    Write-Host "Updated: $($updated -join ', ')"
} else {
    Write-Host "Already up to date."
}

$settings = Join-Path $HOME ".claude\settings.json"
if (Test-Path $settings) {
    $j = Get-Content $settings -Raw | ConvertFrom-Json
    if (-not $j.enabledPlugins.'caveman@caveman') {
        Write-Warning "caveman not enabled — https://github.com/JuliusBrussee/caveman"
    }
    if (-not $j.enabledPlugins.'claude-mem@thedotmack') {
        Write-Warning "claude-mem not enabled — https://github.com/thedotmack/claude-mem"
    }
}
