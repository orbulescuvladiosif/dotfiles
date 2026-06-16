$ErrorActionPreference = 'Stop'

$repoRoot     = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\..')).Path
$sandbox      = Join-Path $env:TEMP "dotfiles-integ-$([guid]::NewGuid().ToString('n').Substring(0, 8))"
$fakeHome     = Join-Path $sandbox 'home'
$project      = Join-Path $sandbox 'project'
$savedHome    = $env:HOME
$savedProfile = $env:USERPROFILE

try {
    New-Item -ItemType Directory -Force -Path (Join-Path $fakeHome '.cursor\skills') | Out-Null
    New-Item -ItemType Directory -Force -Path $project | Out-Null
    git -C $project init -q 2>$null
    if (-not (Test-Path (Join-Path $project '.git'))) {
        New-Item -ItemType Directory -Force -Path (Join-Path $project '.git') | Out-Null
    }

    $env:HOME = $fakeHome
    $env:USERPROFILE = $fakeHome

    $fetch = {
        param($url)
        [string](Get-Content ($url -replace '/', '\') -Raw -Encoding UTF8)
    }

    $installPs1 = Join-Path $PSScriptRoot '..\..\..\install.ps1'
    $params = @{
        RepoBase          = $repoRoot
        ClaudeDir         = Join-Path $fakeHome '.claude'
        CursorDir         = Join-Path $fakeHome '.cursor'
        CursorSkillsDir   = Join-Path $fakeHome '.cursor\skills'
        FetchContent      = $fetch
        CursorRulesTarget = $project
    }

    & $installPs1 @params

    $claudeMd  = Join-Path $fakeHome '.claude\CLAUDE.md'
    $skillMd   = Join-Path $fakeHome '.cursor\skills\review-this\SKILL.md'
    $agentsMdc = Join-Path $project '.cursor\rules\agents.mdc'

    if (-not (Test-Path $claudeMd))  { throw "missing $claudeMd" }
    if (-not (Test-Path $skillMd))   { throw "missing $skillMd" }
    if (-not (Test-Path $agentsMdc)) { throw "missing $agentsMdc" }

    . (Join-Path $PSScriptRoot '..\..\lib.ps1')
    $expected = Normalize-Text (Get-Content (Join-Path $repoRoot 'ai\AGENTS.md') -Raw -Encoding UTF8)
    $actual   = Normalize-Text (Get-Content $claudeMd -Raw -Encoding UTF8)
    if ($expected -ne $actual) { throw 'CLAUDE.md mismatch' }

    & $installPs1 @params

    $installWithoutScriptRoot = [scriptblock]::Create([string](Get-Content $installPs1 -Raw -Encoding UTF8))
    & $installWithoutScriptRoot @params

    Write-Host 'integration ok'
} finally {
    $env:HOME = $savedHome
    $env:USERPROFILE = $savedProfile
    Remove-Item $sandbox -Recurse -Force -ErrorAction SilentlyContinue
}
