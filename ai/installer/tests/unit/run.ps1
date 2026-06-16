$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '..\..\lib.ps1')

$failed = 0

function Test($name, $script) {
    try {
        & $script
        Write-Host "ok $name"
    } catch {
        Write-Host "FAIL $name"
        Write-Host "  $($_.Exception.Message)"
        $script:failed++
    }
}

function Assert($cond, $msg) {
    if (-not $cond) { throw $msg }
}

function AssertThrows($script, $pattern) {
    $threw = $false
    try {
        & $script
    } catch {
        $threw = $true
        if ($_.Exception.Message -notmatch $pattern) { throw "wrong throw: $($_.Exception.Message)" }
    }
    if (-not $threw) { throw "no throw: expected $pattern" }
}

function New-TestDir {
    return Join-Path ([System.IO.Path]::GetTempPath()) "dotfiles-install-test-$([guid]::NewGuid())"
}

. (Join-Path $PSScriptRoot 'manifest.tests.ps1')
. (Join-Path $PSScriptRoot 'normalize-text.tests.ps1')
. (Join-Path $PSScriptRoot 'convert-to-cursor-skill.tests.ps1')
. (Join-Path $PSScriptRoot 'convert-to-cursor-mdc.tests.ps1')
. (Join-Path $PSScriptRoot 'sync-content.tests.ps1')
. (Join-Path $PSScriptRoot 'sync-file.tests.ps1')
. (Join-Path $PSScriptRoot 'exclude.tests.ps1')
. (Join-Path $PSScriptRoot 'claude-settings.tests.ps1')
. (Join-Path $PSScriptRoot 'install-claude-code.tests.ps1')
. (Join-Path $PSScriptRoot 'install-cursor-skills.tests.ps1')
. (Join-Path $PSScriptRoot 'install-cursor-rules.tests.ps1')

if ($failed -gt 0) { throw "$failed test(s) failed" }
Write-Host "all passed ($((Get-ChildItem $PSScriptRoot '*.tests.ps1').Count) files)"
