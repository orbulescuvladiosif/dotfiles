Test 'Convention index matches convention files on disk' {
    $aiRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
    $indexPath = Join-Path $aiRoot 'conventions\index.md'
    $listed = @([regex]::Matches((Get-Content $indexPath -Raw -Encoding UTF8), '(?m)^- (\S+) \u2014') |
        ForEach-Object { $_.Groups[1].Value })
    $onDisk = @(Get-ChildItem (Join-Path $aiRoot 'conventions\*.md') |
        Where-Object { $_.Name -ne 'index.md' } |
        ForEach-Object { $_.BaseName })
    $drift = Compare-Object $listed $onDisk
    Assert (-not $drift) "convention index drift: $drift"
}

Test 'Convention files are listed in install manifest' {
    $aiRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
    $manifestConventions = @(
        foreach ($entry in $script:ClaudeSyncPaths) {
            if ($entry.src -match '^ai/conventions/.+\.md$' -and $entry.src -ne 'ai/conventions/index.md') { $entry.src }
        }
        foreach ($entry in $script:CursorConventions.Values) {
            if ($entry.src -match '^ai/conventions/.+\.md$' -and $entry.src -ne 'ai/conventions/index.md') { $entry.src }
        }
    ) | Select-Object -Unique
    $onDisk = @(Get-ChildItem (Join-Path $aiRoot 'conventions\*.md') |
        Where-Object { $_.Name -ne 'index.md' } |
        ForEach-Object { "ai/conventions/$($_.Name)" })
    $drift = Compare-Object $onDisk $manifestConventions
    Assert (-not $drift) "convention manifest drift: $drift"
}

Test 'Install paths exclude dev-only directories' {
    $paths = @()
    foreach ($entry in $script:ClaudeSyncPaths) { $paths += $entry.src }
    foreach ($entry in $script:CursorConventions.Values) { $paths += $entry.src }
    foreach ($name in $script:SkillNames) { $paths += "ai/skills/$name.md" }
    $forbidden = @($paths | Select-Object -Unique | Where-Object {
        $_ -match '(^|/)\.claude(/|$)' -or $_ -match '(^|/)installer(/|$)' -or $_ -match '(^|/)ai/installer(/|$)'
    })
    Assert (-not $forbidden) "dev-only paths in install manifest: $($forbidden -join ', ')"
}

Test 'Skill descriptions use dotfiles prefix and scope separator' {
    $aiRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
    $pattern = '(?m)^description:\s*\(dotfiles\).+\u2014'
    foreach ($name in $script:SkillNames) {
        $path = Join-Path $aiRoot "skills\$name.md"
        $raw = Get-Content $path -Raw -Encoding UTF8
        Assert ($raw -match $pattern) "bad description format: ai/skills/$name.md"
    }
}
