$source = 'https://raw.githubusercontent.com/orbulescuvladiosif/dotfiles/master/ai/AGENTS.md'
$target = Join-Path $HOME ".claude\CLAUDE.md"

$incoming = Invoke-RestMethod $source

if (Test-Path $target) {
    $existing = Get-Content $target -Raw
    if ($existing -ne $incoming) {
        Write-Warning "CLAUDE.md already exists and differs. Overwrite? (y/N)"
        if ((Read-Host) -ne 'y') { Write-Host "Aborted."; exit 0 }
    }
}

Set-Content -Path $target -Value $incoming -Encoding UTF8
Write-Host "CLAUDE.md written to $target"

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
