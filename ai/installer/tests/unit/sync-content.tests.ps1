Test 'Sync-Content writes new file' {
    $dir = New-TestDir
    try {
        $dest = Join-Path $dir 'out.txt'
        Assert (Sync-Content 'hello' $dest) 'returns true'
        Assert ((Get-Content $dest -Raw) -eq 'hello') 'content'
    } finally {
        Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Test 'Sync-Content idempotent when unchanged' {
    $dir = New-TestDir
    try {
        $dest = Join-Path $dir 'out.txt'
        Sync-Content 'same' $dest | Out-Null
        Assert (-not (Sync-Content 'same' $dest)) 'returns false'
        Assert ((Get-Content $dest -Raw) -eq 'same') 'unchanged'
    } finally {
        Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Test 'Sync-Content idempotent when disk has CRLF' {
    $dir = New-TestDir
    try {
        $dest = Join-Path $dir 'out.txt'
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
        Write-Utf8File $dest "same`r`n"
        Assert (-not (Sync-Content "same`n" $dest)) 'returns false'
    } finally {
        Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Test 'Sync-Content updates when different' {
    $dir = New-TestDir
    try {
        $dest = Join-Path $dir 'out.txt'
        Sync-Content 'v1' $dest | Out-Null
        Assert (Sync-Content 'v2' $dest) 'returns true'
        Assert ((Get-Content $dest -Raw) -eq 'v2') 'updated'
    } finally {
        Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Test 'Sync-Content CRLF normalized on write' {
    $dir = New-TestDir
    try {
        $dest = Join-Path $dir 'out.txt'
        Sync-Content "a`r`nb" $dest | Out-Null
        Assert ((Get-Content $dest -Raw) -eq "a`nb") 'LF only'
    } finally {
        Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
