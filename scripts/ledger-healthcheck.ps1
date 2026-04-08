param(
    [switch]$Strict
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$required = @(
    'AI_CHAT_LEDGER.md',
    'AI_DECISION_LOG.md',
    'AI_FEATURE_LEDGER.md',
    'AI_ERROR_LEDGER.md',
    'AI_DEVELOPMENT_LOG.md'
)

$missing = @()
$empty = @()
$placeholderHits = @()

foreach ($name in $required) {
    $path = Join-Path $root $name
    if (-not (Test-Path $path)) {
        $missing += $name
        continue
    }

    $content = Get-Content -Path $path -Raw
    if ([string]::IsNullOrWhiteSpace($content)) {
        $empty += $name
    }

    if ($content -match 'YYYY-MM-DD HH:mm|\[hata baglami\]|\[o adimda yapilan is\]') {
        $placeholderHits += $name
    }
}

if ($missing.Count -gt 0) {
    Write-Host "[FAIL] Eksik ledger dosyalari:" -ForegroundColor Red
    $missing | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
    exit 1
}

if ($empty.Count -gt 0) {
    Write-Host "[FAIL] Bos ledger dosyalari:" -ForegroundColor Red
    $empty | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
    exit 1
}

if ($placeholderHits.Count -gt 0) {
    $msg = "[WARN] Ornek placeholder kalan dosyalar: {0}" -f ($placeholderHits -join ', ')
    if ($Strict) {
        Write-Host ($msg -replace '^\[WARN\]', '[FAIL]') -ForegroundColor Red
        exit 1
    }

    Write-Host $msg -ForegroundColor Yellow
}

Write-Host "[OK] Ledger healthcheck gecti." -ForegroundColor Green
exit 0
