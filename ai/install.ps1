$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$source = Join-Path $root "AGENTS.md"
$target = Join-Path $HOME ".claude\CLAUDE.md"

if (-not (Test-Path $source)) {
    Write-Error "AGENTS.md not found in script directory."; exit 1
}

if (Test-Path $target) {
    $existing = Get-Content $target -Raw
    $incoming = Get-Content $source -Raw
    if ($existing -ne $incoming) {
        Write-Warning "CLAUDE.md already exists and differs. Overwrite? (y/N)"
        $confirm = Read-Host
        if ($confirm -ne 'y') { Write-Host "Aborted."; exit 0 }
    }
}

Copy-Item -Path $source -Destination $target -Force
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
