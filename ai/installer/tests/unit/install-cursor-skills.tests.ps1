Test 'Install-CursorSkills converts and syncs' {
    $dir = New-TestDir
    try {
        $skillsDir = Join-Path $dir 'skills'
        $raw       = @"
---
description: (dotfiles) Test - scope
---

# Skill
"@
        $fetcher = { param($url) $script:TestSkillRaw }
        $script:TestSkillRaw = $raw
        $updated = Install-CursorSkills 'https://host/repo' $skillsDir @('review-this') $fetcher
        Assert ($updated -contains 'skills/review-this/SKILL.md') 'updated'
        $dest = Join-Path $skillsDir 'review-this\SKILL.md'
        $content = Get-Content $dest -Raw
        Assert ($content -match 'disable-model-invocation: true') 'cursor format'
        $again = Install-CursorSkills 'https://host/repo' $skillsDir @('review-this') $fetcher
        Assert ($again.Count -eq 0) 'idempotent'
    } finally {
        Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Test 'Sync-CursorSkill delegates to Sync-Content' {
    $dir = New-TestDir
    try {
        $dest = Join-Path $dir 'skill\SKILL.md'
        $raw  = @"
---
description: x
---

body
"@
        Assert (Sync-CursorSkill $raw 'my-skill' $dest) 'synced'
        Assert (-not (Sync-CursorSkill $raw 'my-skill' $dest)) 'idempotent'
    } finally {
        Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
