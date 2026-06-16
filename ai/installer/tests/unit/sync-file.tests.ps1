Test 'Sync-File uses fetcher' {
    $dir = New-TestDir
    try {
        $dest    = Join-Path $dir 'out.txt'
        $fetcher = { param($url) "from:$url" }
        Assert (Sync-File 'http://example/x' $dest $fetcher) 'returns true'
        Assert ((Get-Content $dest -Raw) -eq 'from:http://example/x') 'content'
        Assert (-not (Sync-File 'http://example/x' $dest $fetcher)) 'idempotent'
    } finally {
        Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Test 'Get-RepoUrl joins base and path' {
    Assert ((Get-RepoUrl 'https://host/repo' 'ai/AGENTS.md') -eq 'https://host/repo/ai/AGENTS.md') 'url'
}
