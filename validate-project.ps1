# ============================================
# VibeCoding Project Validator v1.0
# Proje bittikten sonra otomatik doğrulama
# Kullanım: .\validate-project.ps1 -ProjectPath "C:\path\to\project"
# ============================================

param(
    [Parameter(Mandatory=$false)]
    [string]$ProjectPath = "."
)

$ProjectPath = Resolve-Path $ProjectPath

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  VibeCoding Project Validator v1.0" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Proje: $ProjectPath" -ForegroundColor White
Write-Host ""

$passed = 0
$failed = 0
$warnings = 0
$results = @()

function Test-Check {
    param([string]$Name, [bool]$Condition, [string]$Level = "ERROR")
    if ($Condition) {
        Write-Host "  ✅ $Name" -ForegroundColor Green
        $script:passed++
        $script:results += [PSCustomObject]@{Check=$Name; Status="PASS"; Level=$Level}
    } elseif ($Level -eq "WARN") {
        Write-Host "  ⚠️  $Name" -ForegroundColor Yellow
        $script:warnings++
        $script:results += [PSCustomObject]@{Check=$Name; Status="WARN"; Level=$Level}
    } else {
        Write-Host "  ❌ $Name" -ForegroundColor Red
        $script:failed++
        $script:results += [PSCustomObject]@{Check=$Name; Status="FAIL"; Level=$Level}
    }
}

# ==========================================
# 1. DOSYA YAPISI KONTROLLERI
# ==========================================
Write-Host "📂 Dosya Yapısı Kontrolleri" -ForegroundColor Yellow
Write-Host "──────────────────────────────" -ForegroundColor DarkGray

Test-Check ".gitignore var" (Test-Path (Join-Path $ProjectPath ".gitignore"))
Test-Check "README.md var" (Test-Path (Join-Path $ProjectPath "README.md"))

# .env.example kontrol
$hasEnvExample = (Test-Path (Join-Path $ProjectPath ".env.example"))
Test-Check ".env.example var" $hasEnvExample

# .env dosyası gitignore'da mı?
$gitignorePath = Join-Path $ProjectPath ".gitignore"
if (Test-Path $gitignorePath) {
    $gitignoreContent = Get-Content $gitignorePath -Raw
    $envInGitignore = $gitignoreContent -match "\.env"
    Test-Check ".env .gitignore'da" $envInGitignore
} else {
    Test-Check ".env .gitignore'da" $false
}

# Test klasörü var mı?
$hasTests = (Test-Path (Join-Path $ProjectPath "test")) -or
            (Test-Path (Join-Path $ProjectPath "tests")) -or
            (Test-Path (Join-Path $ProjectPath "test_*")) -or
            (Test-Path (Join-Path $ProjectPath "__tests__")) -or
            (Test-Path (Join-Path $ProjectPath "*.test.*"))
Test-Check "Test klasörü/dosyası var" $hasTests "WARN"

Write-Host ""

# ==========================================
# 2. GÜVENLİK KONTROLLERI
# ==========================================
Write-Host "🔐 Güvenlik Kontrolleri" -ForegroundColor Yellow
Write-Host "──────────────────────────────" -ForegroundColor DarkGray

# Hardcoded secret arama
$secretPatterns = @(
    "password\s*=\s*['""][^'""]+['""]",
    "secret\s*=\s*['""][^'""]+['""]",
    "api_key\s*=\s*['""][^'""]+['""]",
    "apiKey\s*=\s*['""][^'""]+['""]"
)

$hardcodedSecrets = $false
$codeFiles = Get-ChildItem -Path $ProjectPath -Recurse -File -Include "*.dart","*.ts","*.tsx","*.js","*.jsx","*.py","*.cs","*.java","*.kt","*.swift","*.php" -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch "(node_modules|\.git|build|dist|__pycache__|bin|obj|\.dart_tool|\.gradle)" }

foreach ($file in $codeFiles) {
    $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    if ($content) {
        foreach ($pattern in $secretPatterns) {
            if ($content -match $pattern) {
                # .env dosyaları ve örnek dosyaları hariç
                if ($file.Name -notmatch "\.(env|example|sample|template)") {
                    $hardcodedSecrets = $true
                    Write-Host "    ⚠️  Potansiyel secret: $($file.Name)" -ForegroundColor DarkYellow
                }
            }
        }
    }
}
Test-Check "Hardcoded secret yok" (-not $hardcodedSecrets)

# Console.log / print kontrolü
$debugStatements = 0
foreach ($file in $codeFiles) {
    $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    if ($content) {
        # Test dosyalarını atla
        if ($file.Name -match "test|spec") { continue }
        $matches = [regex]::Matches($content, "(console\.log|print\(|println|Console\.WriteLine|System\.out\.print)")
        $debugStatements += $matches.Count
    }
}
Test-Check "Debug print yok (bulundu: $debugStatements)" ($debugStatements -eq 0) "WARN"

Write-Host ""

# ==========================================
# 3. KOD KALİTESİ KONTROLLERI
# ==========================================
Write-Host "🏗️ Kod Kalitesi Kontrolleri" -ForegroundColor Yellow
Write-Host "──────────────────────────────" -ForegroundColor DarkGray

# God class kontrol (1000+ satır dosya)
$godFiles = @()
foreach ($file in $codeFiles) {
    $lineCount = (Get-Content $file.FullName -ErrorAction SilentlyContinue | Measure-Object -Line).Lines
    if ($lineCount -gt 1000) {
        $godFiles += "$($file.Name) ($lineCount satır)"
    }
}
if ($godFiles.Count -gt 0) {
    foreach ($gf in $godFiles) {
        Write-Host "    ⚠️  God file: $gf" -ForegroundColor DarkYellow
    }
}
Test-Check "God class yok (1000+ satır)" ($godFiles.Count -eq 0) "WARN"

# Dosya başına yorum bloğu kontrol (rastgele 5 dosya)
$sampleFiles = $codeFiles | Get-Random -Count ([Math]::Min(5, $codeFiles.Count)) -ErrorAction SilentlyContinue
$commentedFiles = 0
$totalSample = 0
foreach ($file in $sampleFiles) {
    $totalSample++
    $firstLines = Get-Content $file.FullName -TotalCount 5 -ErrorAction SilentlyContinue
    $firstContent = $firstLines -join "`n"
    if ($firstContent -match "(//|/\*|#|///|---)" ) {
        $commentedFiles++
    }
}
$commentRatio = if ($totalSample -gt 0) { [math]::Round(($commentedFiles / $totalSample) * 100) } else { 0 }
Test-Check "Dosya başı yorum (örneklem: %$commentRatio)" ($commentRatio -ge 60) "WARN"

# Toplam dosya sayısı
$totalCodeFiles = $codeFiles.Count
Write-Host "    ℹ️  Toplam kod dosyası: $totalCodeFiles" -ForegroundColor DarkCyan

Write-Host ""

# ==========================================
# 4. TEKNOLOJİ BAZLI KONTROLLER
# ==========================================
Write-Host "⚙️ Teknoloji Kontrolleri" -ForegroundColor Yellow
Write-Host "──────────────────────────────" -ForegroundColor DarkGray

# Flutter
if (Test-Path (Join-Path $ProjectPath "pubspec.yaml")) {
    Write-Host "    🎯 Flutter projesi algılandı" -ForegroundColor Cyan
    $pubspec = Get-Content (Join-Path $ProjectPath "pubspec.yaml") -Raw
    Test-Check "flutter_test dependency var" ($pubspec -match "flutter_test") "WARN"
    Test-Check "lib/ klasörü var" (Test-Path (Join-Path $ProjectPath "lib"))
}

# Node.js
if (Test-Path (Join-Path $ProjectPath "package.json")) {
    Write-Host "    🎯 Node.js projesi algılandı" -ForegroundColor Cyan
    $packageJson = Get-Content (Join-Path $ProjectPath "package.json") -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue
    if ($packageJson) {
        $hasStartScript = $packageJson.scripts.PSObject.Properties.Name -contains "start" -or
                         $packageJson.scripts.PSObject.Properties.Name -contains "dev"
        Test-Check "start/dev script var" $hasStartScript
        $hasTestScript = $packageJson.scripts.PSObject.Properties.Name -contains "test"
        Test-Check "test script var" $hasTestScript "WARN"
    }
    Test-Check "node_modules .gitignore'da" ($gitignoreContent -match "node_modules") 
}

# .NET
if (Get-ChildItem -Path $ProjectPath -Filter "*.csproj" -Recurse -ErrorAction SilentlyContinue) {
    Write-Host "    🎯 .NET projesi algılandı" -ForegroundColor Cyan
    $hasSln = (Get-ChildItem -Path $ProjectPath -Filter "*.sln" -ErrorAction SilentlyContinue).Count -gt 0
    Test-Check "Solution dosyası (.sln) var" $hasSln "WARN"
    $hasAppSettings = (Get-ChildItem -Path $ProjectPath -Filter "appsettings.json" -Recurse -ErrorAction SilentlyContinue).Count -gt 0
    Test-Check "appsettings.json var" $hasAppSettings
}

# Python
if (Test-Path (Join-Path $ProjectPath "requirements.txt")) {
    Write-Host "    🎯 Python projesi algılandı" -ForegroundColor Cyan
    Test-Check "requirements.txt var" $true
    $venvIgnored = $gitignoreContent -match "(venv|\.venv|__pycache__)"
    Test-Check "venv/.venv .gitignore'da" $venvIgnored
}

# Android (Kotlin)
if (Get-ChildItem -Path $ProjectPath -Filter "build.gradle*" -Recurse -ErrorAction SilentlyContinue) {
    Write-Host "    🎯 Android/Gradle projesi algılandı" -ForegroundColor Cyan
    $hasManifest = (Get-ChildItem -Path $ProjectPath -Filter "AndroidManifest.xml" -Recurse -ErrorAction SilentlyContinue).Count -gt 0
    Test-Check "AndroidManifest.xml var" $hasManifest
}

# iOS (Swift)
if (Get-ChildItem -Path $ProjectPath -Filter "*.xcodeproj" -Recurse -ErrorAction SilentlyContinue) {
    Write-Host "    🎯 iOS projesi algılandı" -ForegroundColor Cyan
    $hasInfoPlist = (Get-ChildItem -Path $ProjectPath -Filter "Info.plist" -Recurse -ErrorAction SilentlyContinue).Count -gt 0
    Test-Check "Info.plist var" $hasInfoPlist
}

Write-Host ""

# ==========================================
# SONUÇ
# ==========================================
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  SONUÇ" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  ✅ Geçen:    $passed" -ForegroundColor Green
Write-Host "  ⚠️  Uyarı:    $warnings" -ForegroundColor Yellow
Write-Host "  ❌ Başarısız: $failed" -ForegroundColor Red
Write-Host ""

$total = $passed + $failed + $warnings
$successRate = if ($total -gt 0) { [math]::Round(($passed / $total) * 100) } else { 0 }

if ($failed -eq 0 -and $warnings -eq 0) {
    Write-Host "  🚀 PRODUCTION READY!" -ForegroundColor Green
} elseif ($failed -eq 0) {
    Write-Host "  ⚡ Yayınlanabilir (uyarıları dikkate alın)" -ForegroundColor Yellow
} else {
    Write-Host "  🛑 Başarısız kontroller düzeltilmeli!" -ForegroundColor Red
}

Write-Host ""
Write-Host "  Başarı Oranı: %$successRate" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
