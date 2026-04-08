param(
    [switch]$StrictLedger
)

$ErrorActionPreference = 'Stop'

$root = $PSScriptRoot
$ledgerScript = Join-Path $root 'scripts\ledger-healthcheck.ps1'
$guardScript = Join-Path $root 'scripts\root-safe-guard.ps1'

if (-not (Test-Path $ledgerScript)) {
    Write-Host "[FAIL] Script bulunamadi: $ledgerScript" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $guardScript)) {
    Write-Host "[FAIL] Script bulunamadi: $guardScript" -ForegroundColor Red
    exit 1
}

Write-Host "[STEP] Ledger healthcheck" -ForegroundColor Cyan
if ($StrictLedger) {
    & $ledgerScript -Strict
} else {
    & $ledgerScript
}
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "[STEP] Root-safe guard" -ForegroundColor Cyan
& $guardScript
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "[OK] Proje dogrulama basarili." -ForegroundColor Green
exit 0
