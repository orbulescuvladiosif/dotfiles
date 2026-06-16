Test 'Convert-ToCursorAgentsMdc wraps AGENTS' {
    $out = Convert-ToCursorAgentsMdc "# Rules`n"
    Assert ($out -match '(?m)^alwaysApply: true$') 'alwaysApply'
    Assert ($out -match '(?m)^# Rules$') 'body'
}

Test 'Convert-ToCursorConventionMdc wraps convention' {
    $out = Convert-ToCursorConventionMdc "# Git`n" 'Git conventions'
    Assert ($out -match '(?m)^description: Git conventions$') 'description'
    Assert ($out -match '(?m)^alwaysApply: false$') 'alwaysApply false'
    Assert ($out -match '(?m)^# Git$') 'body'
}

Test 'Convert-ToCursorAgentsMdc CRLF normalized' {
    Assert (-not ((Convert-ToCursorAgentsMdc "a`r`nb") -match "`r")) 'no CR'
}
