param(
    [string]$RepoBase,
    [string]$ClaudeDir,
    [string]$CursorDir,
    [string]$CursorSkillsDir,
    [string]$CursorRulesTarget,
    [scriptblock]$FetchContent,
    [switch]$SkipCursorRules
)

. (Join-Path $PSScriptRoot 'installer\lib.ps1')

$p = @{}
if ($PSBoundParameters.ContainsKey('RepoBase'))           { $p.RepoBase = $RepoBase }
if ($PSBoundParameters.ContainsKey('ClaudeDir'))          { $p.ClaudeDir = $ClaudeDir }
if ($PSBoundParameters.ContainsKey('CursorDir'))          { $p.CursorDir = $CursorDir }
if ($PSBoundParameters.ContainsKey('CursorSkillsDir'))  { $p.CursorSkillsDir = $CursorSkillsDir }
if ($PSBoundParameters.ContainsKey('CursorRulesTarget')) { $p.CursorRulesTarget = $CursorRulesTarget }
if ($PSBoundParameters.ContainsKey('FetchContent'))      { $p.FetchContent = $FetchContent }
if ($SkipCursorRules)                                     { $p.SkipCursorRules = $true }

Invoke-DotfilesInstall @p
