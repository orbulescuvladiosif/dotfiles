param(
    [string]$RepoBase,
    [string]$ClaudeDir,
    [string]$CursorDir,
    [string]$CursorSkillsDir,
    [string]$CursorRulesTarget,
    [scriptblock]$FetchContent,
    [switch]$SkipCursorRules
)

if ($PSScriptRoot) {
    . (Join-Path $PSScriptRoot 'installer\lib.ps1')
} else {
    $seed  = if ($RepoBase) { $RepoBase } else { 'https://raw.githubusercontent.com/orbulescuvladiosif/dotfiles/master' }
    $fetch = if ($FetchContent) { $FetchContent } else { { param($url) [string](Invoke-RestMethod $url) } }
    try {
        Invoke-Expression (& $fetch "$seed/ai/installer/manifest.ps1")
        $base = if ($RepoBase) { $RepoBase } else { $script:DefaultRepo }
        Invoke-Expression (& $fetch "$base/ai/installer/lib.ps1")
    } catch {
        throw "Failed to fetch installer from ${seed}: $($_.Exception.Message)"
    }
}

$p = @{}
if ($PSBoundParameters.ContainsKey('RepoBase'))           { $p.RepoBase = $RepoBase }
if ($PSBoundParameters.ContainsKey('ClaudeDir'))          { $p.ClaudeDir = $ClaudeDir }
if ($PSBoundParameters.ContainsKey('CursorDir'))          { $p.CursorDir = $CursorDir }
if ($PSBoundParameters.ContainsKey('CursorSkillsDir'))  { $p.CursorSkillsDir = $CursorSkillsDir }
if ($PSBoundParameters.ContainsKey('CursorRulesTarget')) { $p.CursorRulesTarget = $CursorRulesTarget }
if ($PSBoundParameters.ContainsKey('FetchContent'))      { $p.FetchContent = $FetchContent }
if ($SkipCursorRules)                                     { $p.SkipCursorRules = $true }

Invoke-DotfilesInstall @p
