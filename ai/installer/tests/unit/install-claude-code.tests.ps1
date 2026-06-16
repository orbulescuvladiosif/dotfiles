Test 'Install-ClaudeCode syncs files' {
    $dir = New-TestDir
    try {
        $claudeDir = Join-Path $dir 'claude'
        $files     = @{
            'ai/AGENTS.md' = '# agents'
            'ai/skills/review-this.md' = "---`ndescription: x`n---`n`n# skill`n"
        }
        $fetcher = {
            param($url)
            $key = ($url -replace '^.*/(ai/.*)$', '$1')
            return $files[$key]
        }
        $paths = @(@{ src = 'ai/AGENTS.md'; dest = 'CLAUDE.md'; label = 'CLAUDE.md' })
        $updated = Install-ClaudeCode 'https://host/repo' $claudeDir @('review-this') $paths $fetcher
        Assert ($updated -contains 'CLAUDE.md') 'agents synced'
        Assert ($updated -contains 'commands/review-this.md') 'skill synced'
        Assert (Test-Path (Join-Path $claudeDir 'CLAUDE.md')) 'agents file'
        $again = Install-ClaudeCode 'https://host/repo' $claudeDir @('review-this') $paths $fetcher
        Assert ($again.Count -eq 0) 'idempotent'
    } finally {
        Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
