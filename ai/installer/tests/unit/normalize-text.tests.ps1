Test 'Normalize-Text CRLF to LF' {
    Assert ((Normalize-Text "a`r`nb") -eq "a`nb") 'CRLF'
}

Test 'Normalize-Text leaves LF unchanged' {
    Assert ((Normalize-Text "a`nb") -eq "a`nb") 'LF'
}

Test 'Normalize-Text coerces non-string' {
    Assert ((Normalize-Text 42) -eq '42') 'coerce'
}
