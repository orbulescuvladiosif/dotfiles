Test 'SkillNames matches ai/skills on disk' {
    $aiRoot  = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
    $onDisk  = @(Get-ChildItem (Join-Path $aiRoot 'skills\*.md') | ForEach-Object { $_.BaseName })
    $missing = Compare-Object $onDisk $script:SkillNames
    Assert (-not $missing) "manifest drift: $missing"
}

Test 'ClaudeSyncPaths src files exist' {
    $aiRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
    foreach ($entry in $script:ClaudeSyncPaths) {
        Assert (Test-Path (Join-Path $aiRoot ($entry.src -replace '^ai/', ''))) "missing $($entry.src)"
    }
}

Test 'CursorConventions src files exist' {
    $aiRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
    foreach ($entry in $script:CursorConventions.Values) {
        Assert (Test-Path (Join-Path $aiRoot ($entry.src -replace '^ai/', ''))) "missing $($entry.src)"
    }
}
