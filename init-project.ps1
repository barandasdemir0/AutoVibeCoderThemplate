# ============================================
# VibeCoding Project Initializer v2.0
# Starter code + Universal rehberler + Deploy dosyaları
# Kullanım: .\init-project.ps1
# ============================================

$templatesPath = "$PSScriptRoot\Templates"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  VibeCoding Project Initializer v2.0" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Kategori secimi
Write-Host "Kategori Secin:" -ForegroundColor Yellow
Write-Host "  1) Backend" -ForegroundColor White
Write-Host "  2) Frontend" -ForegroundColor White
Write-Host "  3) Mobile" -ForegroundColor White
Write-Host "  4) ML-AI" -ForegroundColor White
Write-Host "  5) FullStack" -ForegroundColor White
Write-Host "  6) Testing" -ForegroundColor White
Write-Host ""

$categoryChoice = Read-Host "Seciminiz (1-6)"

$categories = @{
    "1" = "Backend"
    "2" = "Frontend"
    "3" = "Mobile"
    "4" = "ML-AI"
    "5" = "FullStack"
    "6" = "Testing"
}

$selectedCategory = $categories[$categoryChoice]
if (-not $selectedCategory) {
    Write-Host "Gecersiz secim!" -ForegroundColor Red
    exit 1
}

$categoryPath = Join-Path $templatesPath $selectedCategory
if (-not (Test-Path $categoryPath)) {
    Write-Host "Kategori bulunamadi: $selectedCategory" -ForegroundColor Red
    exit 1
}

# Tech stack secimi
Write-Host ""
Write-Host "$selectedCategory Templateleri:" -ForegroundColor Yellow

$templates = Get-ChildItem -Path $categoryPath -Directory | Sort-Object Name
$i = 1
foreach ($t in $templates) {
    $tName = $t.Name
    # Starter var mi kontrol et
    $starterPath = Join-Path $t.FullName "starter"
    $hasStarter = (Test-Path $starterPath)
    $starterIndicator = if ($hasStarter) { " [STARTER]" } else { "" }
    Write-Host "  $i) $tName$starterIndicator" -ForegroundColor White
    $i++
}

Write-Host ""
$tCount = $templates.Count
$templateChoice = Read-Host "Template Seciminiz (1-$tCount)"

$selectedTemplate = $templates[[int]$templateChoice - 1]
if (-not $selectedTemplate) {
    Write-Host "Gecersiz secim!" -ForegroundColor Red
    exit 1
}

# Proje adi
Write-Host ""
$projectName = Read-Host "Proje Adi"
if ([string]::IsNullOrWhiteSpace($projectName)) {
    Write-Host "Proje adi bos olamaz!" -ForegroundColor Red
    exit 1
}

$projectPath = Join-Path $PSScriptRoot $projectName

# Olusturma onayi
Write-Host ""
Write-Host "Ozet:" -ForegroundColor Green
Write-Host "   Kategori: $selectedCategory" -ForegroundColor White
$stName = $selectedTemplate.Name
Write-Host "   Template: $stName" -ForegroundColor White
Write-Host "   Proje:    $projectName" -ForegroundColor White
Write-Host "   Konum:    $projectPath" -ForegroundColor White

$starterExist = Join-Path $selectedTemplate.FullName "starter"
if (Test-Path $starterExist) {
    Write-Host "   Starter:  MEVCUT (hazir kod kopyalanacak)" -ForegroundColor Green
} else {
    Write-Host "   Starter:  BLUEPRINT (rehber kopyalanacak)" -ForegroundColor Yellow
}
Write-Host ""

$confirm = Read-Host "Olusturulsun mu? (E/H)"

if ($confirm -ne "E" -and $confirm -ne "e") {
    Write-Host "Iptal edildi." -ForegroundColor Yellow
    exit 0
}

# Proje olustur
if (Test-Path $projectPath) {
    Write-Host "'$projectName' klasoru zaten mevcut!" -ForegroundColor Red
    exit 1
}

New-Item -ItemType Directory -Path $projectPath -Force | Out-Null

# 1. Rehber dosyalarini kopyala (01-06.md)
$mdFiles = Get-ChildItem -Path $selectedTemplate.FullName -File -Filter "*.md"
foreach ($md in $mdFiles) {
    Copy-Item -Path $md.FullName -Destination $projectPath
}
Write-Host ""
Write-Host "[1/6] Rehber dosyalari kopyalandi!" -ForegroundColor Green

# 2. Starter code kopyala (varsa)
$starterPath = Join-Path $selectedTemplate.FullName "starter"
if (Test-Path $starterPath) {
    Copy-Item -Path "$starterPath\*" -Destination $projectPath -Recurse -Force
    Write-Host "[2/6] Starter code kopyalandi!" -ForegroundColor Green

    # 3. Placeholder degistir
    $projectNamePascal = $projectName.Substring(0,1).ToUpper() + $projectName.Substring(1)
    $projectNameSnake = $projectName.ToLower() -replace '[^a-z0-9]', '_'

    Get-ChildItem -Path $projectPath -Recurse -File | ForEach-Object {
        try {
            $content = Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue
            if ($content -and ($content -match "{{PROJECT_NAME}}|{{project_name}}")) {
                $content = $content -replace "{{PROJECT_NAME}}", $projectNamePascal
                $content = $content -replace "{{project_name}}", $projectNameSnake
                $content = $content -replace "{{PROJECT_DESCRIPTION}}", "VibeCoding ile olusturuldu"
                $content = $content -replace "{{DB_NAME}}", $projectNameSnake
                $content = $content -replace "{{PACKAGE_NAME}}", "com.example.$projectNameSnake"
                Set-Content $_.FullName -Value $content -NoNewline
            }
        } catch {}
    }
    Write-Host "[3/6] Placeholder'lar guncellendi!" -ForegroundColor Green
} else {
    Write-Host "[2/6] Starter code yok — BLUEPRINT kopyalandi" -ForegroundColor Yellow
    Write-Host "[3/6] Placeholder adimlari atlandi" -ForegroundColor Yellow
}

# 4. _Universal rehberleri kopyala
$universalPath = Join-Path $templatesPath "_Universal"
if (Test-Path $universalPath) {
    $universalDest = Join-Path $projectPath "_Universal"
    Copy-Item -Path $universalPath -Destination $universalDest -Recurse
    Write-Host "[4/6] _Universal rehberler kopyalandi!" -ForegroundColor Magenta
}

# 5. .env.example -> .env
$envExample = Join-Path $projectPath ".env.example"
$envFile = Join-Path $projectPath ".env"
if (Test-Path $envExample) {
    Copy-Item -Path $envExample -Destination $envFile
    Write-Host "[5/7] .env dosyasi olusturuldu!" -ForegroundColor Green
} else {
    Write-Host "[5/7] .env.example bulunamadi — atlandi" -ForegroundColor Yellow
}

# 6. Global Memory Zırhı (.cursorrules) olustur
$cursorRulesTemplate = Join-Path $universalPath "CURSORRULES-TEMPLATE.md"
$cursorRulesDest = Join-Path $projectPath ".cursorrules"
if (Test-Path $cursorRulesTemplate) {
    Copy-Item -Path $cursorRulesTemplate -Destination $cursorRulesDest
    Write-Host "[6/7] .cursorrules (AI Memory) mühürü eklendi!" -ForegroundColor Green
} else {
    Write-Host "[6/7] CURSORRULES-TEMPLATE.md bulunamadi — atlandi" -ForegroundColor Yellow
}

# 7. Git init
$gitignoreFile = Join-Path $projectPath ".gitignore"
if (-not (Test-Path $gitignoreFile)) {
    # Genel gitignore olustur
    @"
# IDE
.idea/
.vscode/
*.swp
.DS_Store

# Environment
.env
.env.local
.env.production

# Dependencies
node_modules/
__pycache__/
venv/
.venv/
bin/
obj/

# Build
dist/
build/
*.pyc

# OS
Thumbs.db
"@ | Set-Content $gitignoreFile
}

try {
    Push-Location $projectPath
    git init | Out-Null
    git add . | Out-Null
    git commit -m "Initial commit — VibeCoding starter" | Out-Null
    Pop-Location
    Write-Host "[7/7] Git repository olusturuldu!" -ForegroundColor Green
} catch {
    Write-Host "[7/7] Git init atlandi (git bulunamadi)" -ForegroundColor Yellow
}

# Tamamlandi
Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Proje basariyla olusturuldu!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Dosya Yapisi:" -ForegroundColor Yellow
Get-ChildItem -Path $projectPath -Depth 1 | ForEach-Object {
    $prefix = if ($_.PSIsContainer) { "[D]" } else { "[F]" }
    $fName = $_.Name
    Write-Host "   $prefix $fName" -ForegroundColor White
}

Write-Host ""
Write-Host "Sonraki Adimlar:" -ForegroundColor Yellow
Write-Host "   1. AI'a _Universal\MASTER-PROMPT.md okut" -ForegroundColor White
Write-Host "   2. AI'a _Universal\AI-RULES.md okut" -ForegroundColor White
Write-Host "   3. AI'a _Universal\STARTER-USAGE.md okut (starter varsa)" -ForegroundColor White
Write-Host "   4. Proje fikrinizi AI'a soyeleyin" -ForegroundColor White
Write-Host "   5. AI gerisini halleder!" -ForegroundColor Green
Write-Host ""
