Test 'Get-MissingExcludeEntries finds gaps' {
    $missing = Get-MissingExcludeEntries '.cursor/rules/agents.mdc' @('.cursor/rules/agents.mdc', '.cursor/rules/conventions/')
    Assert ($missing.Count -eq 1) 'one missing'
    Assert ($missing -contains '.cursor/rules/conventions/') 'conventions missing'
}

Test 'Get-MissingExcludeEntries none when all present' {
    $text    = ".cursor/rules/agents.mdc`n.cursor/rules/conventions/`n"
    $missing = Get-MissingExcludeEntries $text $script:ExcludeEntries
    Assert ($missing.Count -eq 0) 'none missing'
}

Test 'Format-ExcludeAddition returns null when empty' {
    Assert ($null -eq (Format-ExcludeAddition @())) 'null'
}

Test 'Format-ExcludeAddition formats block' {
    $out = Format-ExcludeAddition @('.cursor/rules/agents.mdc')
    Assert ($out -match 'dotfiles personal Cursor config') 'marker'
    Assert ($out -match '\.cursor/rules/agents\.mdc') 'entry'
}

Test 'Update-ExcludeFile appends missing entries' {
    $dir = New-TestDir
    try {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
        $exclude = Join-Path $dir 'exclude'
        Write-Utf8File $exclude ''
        Assert (Update-ExcludeFile $exclude $script:ExcludeEntries) 'updated'
        $text = Get-Content $exclude -Raw
        Assert ($text -match 'agents\.mdc') 'agents'
        Assert (-not (Update-ExcludeFile $exclude $script:ExcludeEntries)) 'idempotent'
    } finally {
        Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
