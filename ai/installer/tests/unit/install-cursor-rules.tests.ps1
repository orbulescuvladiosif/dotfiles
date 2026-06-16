Test 'Install-CursorRules rejects non-git dir' {
    $dir = New-TestDir
    try {
        $fetcher = { param($url) 'content' }
        $r = Install-CursorRules 'https://host/repo' $dir $script:CursorConventions $script:ExcludeEntries $fetcher
        Assert (-not $r.ok) 'not ok'
        Assert ($r.updated.Count -eq 0) 'no updates'
    } finally {
        Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Test 'Install-CursorRules syncs rules and exclude' {
    $dir = New-TestDir
    try {
        $repoDir = Join-Path $dir 'project'
        New-Item -ItemType Directory -Force -Path (Join-Path $repoDir '.git') | Out-Null
        $contents = @{
            'ai/AGENTS.md'                  = '# agents'
            'ai/conventions/index.md'       = '# index'
            'ai/conventions/engineering.md' = '# eng'
            'ai/conventions/git.md'         = '# git'
            'ai/conventions/ui.md'          = '# ui'
        }
        $fetcher = { param($url)
            $key = ($url -replace '^.*/(ai/.*)$', '$1')
            return $contents[$key]
        }
        $r = Install-CursorRules 'https://host/repo' $repoDir $script:CursorConventions $script:ExcludeEntries $fetcher
        Assert $r.ok 'ok'
        Assert ($r.updated -contains 'agents.mdc') 'agents'
        Assert ($r.updated -contains 'conventions/index.mdc') 'conventions'
        $exclude = Get-Content (Join-Path $repoDir '.git\info\exclude') -Raw
        Assert ($exclude -match 'agents\.mdc') 'exclude agents'
        $again = Install-CursorRules 'https://host/repo' $repoDir $script:CursorConventions $script:ExcludeEntries $fetcher
        Assert ($again.updated.Count -eq 0) 'idempotent'
    } finally {
        Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
