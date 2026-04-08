param(
    [string]$TemplatesPath = "Templates"
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$target = Join-Path $root $TemplatesPath

if (-not (Test-Path $target)) {
    Write-Host "[FAIL] Templates klasoru bulunamadi: $target" -ForegroundColor Red
    exit 1
}

$blockedExt = @(
    '.js','.jsx','.ts','.tsx','.py','.cs','.java','.kt','.swift','.dart','.go',
    '.php','.rb','.rs','.vue','.html','.css','.scss','.sql'
)

$violations = Get-ChildItem -Path $target -Recurse -File |
    Where-Object { $blockedExt -contains $_.Extension.ToLowerInvariant() } |
    Select-Object -ExpandProperty FullName

if ($violations.Count -gt 0) {
    Write-Host "[FAIL] Root-safe guard: Templates altinda kaynak kod bulundu." -ForegroundColor Red
    $violations | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
    exit 1
}

Write-Host "[OK] Root-safe guard gecti. Templates altinda kaynak kod yok." -ForegroundColor Green
exit 0
