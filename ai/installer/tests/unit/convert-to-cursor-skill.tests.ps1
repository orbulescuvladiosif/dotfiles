Test 'Convert-ToCursorSkill valid skill' {
    $raw = @"
---
description: (dotfiles) Do thing — scope
---

# Body
"@
    $out = Convert-ToCursorSkill $raw 'my-skill'
    Assert ($out -match '(?m)^name: my-skill$') 'name'
    Assert ($out -match '(?m)^description: \(dotfiles\) Do thing — scope$') 'description'
    Assert ($out -match '(?m)^disable-model-invocation: true$') 'disable-model-invocation'
    Assert ($out -match '(?m)^# Body$') 'body'
}

Test 'Convert-ToCursorSkill missing description' {
    $raw = @"
---
other: field
---

# Body
"@
    $out = Convert-ToCursorSkill $raw 'no-desc'
    Assert ($out -match '(?m)^description: $') 'empty description'
}

Test 'Convert-ToCursorSkill CRLF normalized' {
    $raw = "---`r`ndescription: x`r`n---`r`n`r`nbody`r`n"
    Assert (-not ((Convert-ToCursorSkill $raw 'x') -match "`r")) 'no CR'
}

Test 'Convert-ToCursorSkill invalid format throws' {
    AssertThrows { Convert-ToCursorSkill '# no frontmatter' 'bad' } 'Invalid skill format: bad'
}

Test 'Convert-ToCursorSkill empty body throws' {
    $raw = "---`ndescription: x`n---`n"
    AssertThrows { Convert-ToCursorSkill $raw 'empty' } 'Skill body empty after frontmatter: empty'
}
