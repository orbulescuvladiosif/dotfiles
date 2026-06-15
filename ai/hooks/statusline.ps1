$ClaudeDir = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $HOME ".claude" }
$MemDir    = if ($env:CLAUDE_MEM_DATA_DIR) { $env:CLAUDE_MEM_DATA_DIR } else { Join-Path $HOME ".claude-mem" }
$Esc = [char]27
$Dot = [char]0x25CF      # ●
$Ring = [char]0x25CB     # ○
$parts = @()
try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch {}
try { [Console]::InputEncoding = [Text.Encoding]::UTF8 } catch {}

$cOrange=172; $cGray=245; $cGold=178; $cTime=244; $cDim=240
function Fmt-Num($n) {
    $n = [double]$n
    if ($n -ge 1000000) { return ('{0:0.0}M' -f ($n / 1000000)) }
    if ($n -ge 1000)    { return ('{0:0}k'   -f ($n / 1000)) }
    return ('{0:0}' -f $n)
}

$raw = [Console]::In.ReadToEnd()
if ($raw) { $b = $raw.IndexOf('{'); if ($b -ge 0) { $raw = $raw.Substring($b) } }  # tolerate BOM/prefix
try { $j = $raw | ConvertFrom-Json } catch { $j = $null }

$cm = ""
$Flag = Join-Path $ClaudeDir ".caveman-active"
if (Test-Path $Flag) {
    try {
        $item = Get-Item -LiteralPath $Flag -Force -ErrorAction Stop
        if (-not ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -and $item.Length -le 64) {
            $mode = (((Get-Content -LiteralPath $Flag -TotalCount 1 -ErrorAction Stop) | Out-String).Trim()).ToLowerInvariant()
            $mode = ($mode -replace '[^a-z0-9-]', '')
            $valid = @('lite','full','ultra','wenyan-lite','wenyan','wenyan-full','wenyan-ultra','commit','review','compress')
            if ($valid -contains $mode) {
                $cm = if ($mode -eq 'full') { '[CAVEMAN]' } else { '[CAVEMAN:' + $mode.ToUpperInvariant() + ']' }
            }
        }
    } catch {}
}
if ($cm) { $parts += "${Esc}[38;5;${cOrange}m$cm${Esc}[0m" }

if ($j -and $j.model -and $j.model.display_name) {
    $seg = $j.model.display_name
    if ($j.effort -and $j.effort.level) { $seg += ' ' + $j.effort.level }
    if ($j.fast_mode) { $seg += ' fast' }
    $parts += "${Esc}[38;5;${cGray}m$seg${Esc}[0m"
}

if ($j -and $j.context_window -and $null -ne $j.context_window.used_percentage) {
    $pct = [int]$j.context_window.used_percentage
    $col = if ($pct -le 60) { 42 } elseif ($pct -le 80) { 220 } else { 196 }
    $parts += "${Esc}[38;5;${col}m$Dot $pct%${Esc}[0m"
}

if ($j -and $j.cost -and $null -ne $j.cost.total_cost_usd) {
    $parts += "${Esc}[38;5;${cGold}m`$$('{0:0.00}' -f $j.cost.total_cost_usd)${Esc}[0m"
}

if ($j -and $j.cost -and $null -ne $j.cost.total_duration_ms) {
    $mins = [int][math]::Floor([double]$j.cost.total_duration_ms / 60000)
    $t = if ($mins -ge 60) { ('{0}h{1}m' -f [math]::Floor($mins / 60), ($mins % 60)) } else { "${mins}m" }
    $parts += "${Esc}[38;5;${cTime}m$t${Esc}[0m"
}

$memUp = $false
$pidFile = Join-Path $MemDir "worker.pid"
if (Test-Path $pidFile) {
    try {
        $wp = ((Get-Content -LiteralPath $pidFile -Raw -ErrorAction Stop) | ConvertFrom-Json).pid
        if ($wp -and (Get-Process -Id $wp -ErrorAction SilentlyContinue)) { $memUp = $true }
    } catch {}
}
if ($memUp) { $parts += "${Esc}[38;5;42m$Dot mem${Esc}[0m" }
else        { $parts += "${Esc}[38;5;${cDim}m$Ring mem${Esc}[0m" }

$sep = "${Esc}[38;5;${cDim}m | ${Esc}[0m"
[Console]::Write(($parts -join $sep))
