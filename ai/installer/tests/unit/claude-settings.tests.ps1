Test 'Get-StatusLineCommand format' {
    $cmd = Get-StatusLineCommand 'C:\Users\me\.claude'
    Assert ($cmd -match 'statusline\.ps1"') 'path'
    Assert ($cmd -match 'powershell -NoProfile') 'powershell'
}

Test 'Get-ClaudePluginWarnings when plugins missing' {
    $j = [PSCustomObject]@{ enabledPlugins = [PSCustomObject]@{} }
    $w = Get-ClaudePluginWarnings $j
    Assert ($w.Count -eq 2) 'two warnings'
}

Test 'Get-ClaudePluginWarnings when plugins present' {
    $j = [PSCustomObject]@{
        enabledPlugins = [PSCustomObject]@{
            'caveman@caveman'       = $true
            'claude-mem@thedotmack' = $true
        }
    }
    Assert ((Get-ClaudePluginWarnings $j).Count -eq 0) 'no warnings'
}

Test 'Update-ClaudeSettings missing file' {
    $r = Update-ClaudeSettings (Join-Path (New-TestDir) 'nope.json') 'C:\claude'
    Assert (-not $r.found) 'not found'
    Assert (-not $r.updated) 'not updated'
}

Test 'Update-ClaudeSettings sets statusLine' {
    $dir = New-TestDir
    try {
        $claudeDir = Join-Path $dir 'claude'
        New-Item -ItemType Directory -Force -Path (Join-Path $claudeDir 'hooks') | Out-Null
        $settings = Join-Path $claudeDir 'settings.json'
        $j = @{
            enabledPlugins = @{
                'caveman@caveman'       = $true
                'claude-mem@thedotmack' = $true
            }
        } | ConvertTo-Json -Depth 5
        Write-Utf8File $settings $j
        $r = Update-ClaudeSettings $settings $claudeDir
        Assert $r.found 'found'
        Assert $r.updated 'updated'
        $saved = Get-Content $settings -Raw | ConvertFrom-Json
        Assert ($saved.statusLine.command -eq (Get-StatusLineCommand $claudeDir)) 'statusLine'
    } finally {
        Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Test 'Update-ClaudeSettings idempotent' {
    $dir = New-TestDir
    try {
        $claudeDir = Join-Path $dir 'claude'
        New-Item -ItemType Directory -Force -Path (Join-Path $claudeDir 'hooks') | Out-Null
        $settings = Join-Path $claudeDir 'settings.json'
        $cmd = Get-StatusLineCommand $claudeDir
        $j = @{
            enabledPlugins = @{ 'caveman@caveman' = $true; 'claude-mem@thedotmack' = $true }
            statusLine     = @{ type = 'command'; command = $cmd }
        } | ConvertTo-Json -Depth 5
        Write-Utf8File $settings $j
        $r = Update-ClaudeSettings $settings $claudeDir
        Assert (-not $r.updated) 'idempotent'
    } finally {
        Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
