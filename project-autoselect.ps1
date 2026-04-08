param(
    [string]$Idea,
    [ValidateSet('AUTO','S','M','L','XL')]
    [string]$Size = 'AUTO',
    [switch]$NoPrompt,
    [switch]$SavePlan,
    [string]$PlanPath = 'PROJECT-AUTO-SELECTION.md'
)

function Get-NormalizedText {
    param([string]$Text)
    if (-not $Text) { return '' }
    return $Text.ToLowerInvariant()
}

function Test-ContainsAny {
    param(
        [string]$Text,
        [string[]]$Keywords
    )
    foreach ($k in $Keywords) {
        if ($Text.Contains($k)) { return $true }
    }
    return $false
}

function Get-MatchCount {
    param(
        [string]$Text,
        [string[]]$Keywords
    )
    $count = 0
    foreach ($k in $Keywords) {
        if ($Text.Contains($k)) { $count++ }
    }
    return $count
}

function Resolve-Size {
    param(
        [string]$Text,
        [string]$SelectedSize
    )

    if ($SelectedSize -ne 'AUTO') { return $SelectedSize }

    $enterpriseSignals = @(
        'enterprise','kurumsal','global','high traffic','yuksek trafik','multi tenant','multitenant','microservice','mikroservis',
        'super app','superapp','escrow','fraud','disaster recovery','backup','cloud functions','video call','gps','multi role','cok rol'
    )
    $advancedSignals = @(
        'marketplace','odeme','payment','realtime','analytic','raporlama','ai','ml','notification','premium','abonelik','subscription',
        'booking','rezervasyon','firebase','offline','multilingual','coklu dil','15 dil'
    )

    $enterpriseScore = Get-MatchCount -Text $Text -Keywords $enterpriseSignals
    $advancedScore = Get-MatchCount -Text $Text -Keywords $advancedSignals
    $isWebAndMobile = (Test-ContainsAny $Text @('web')) -and (Test-ContainsAny $Text @('mobile','mobil','ios','android'))

    if ($isWebAndMobile -and $enterpriseScore -ge 2 -and $advancedScore -ge 4) {
        return 'XL'
    }

    if ($enterpriseScore -ge 2) {
        return 'XL'
    }

    if ($advancedScore -ge 2) {
        return 'L'
    }

    if (Test-ContainsAny $Text @('landing','portfolio','blog','todo','to-do','single page','tek sayfa')) {
        return 'S'
    }

    return 'M'
}

function Resolve-Template {
    param([string]$Text)

    $isWeb = Test-ContainsAny $Text @('web','frontend','next','react','vue','angular','browser')
    $isMobile = Test-ContainsAny $Text @('mobile','mobil','flutter','react native','ios','android','swift','kotlin')

    if ($isWeb -and $isMobile) {
        if (Test-ContainsAny $Text @('firebase')) {
            return 'Templates/FullStack/NextJS-FullStack'
        }
        return 'Templates/FullStack/NextJS-FullStack'
    }

    if (Test-ContainsAny $Text @('swift','ios','iphone')) {
        return 'Templates/Mobile/SwiftUI-iOS'
    }
    if (Test-ContainsAny $Text @('android','kotlin')) {
        return 'Templates/Mobile/Kotlin-MVVM'
    }
    if (Test-ContainsAny $Text @('mobile','flutter','react native')) {
        if (Test-ContainsAny $Text @('react native','expo')) { return 'Templates/Mobile/ReactNative' }
        return 'Templates/Mobile/Flutter-Firebase'
    }

    if (Test-ContainsAny $Text @('ml','computer vision','yolo','nlp','model training')) {
        if (Test-ContainsAny $Text @('yolo','computer vision','goruntu')) { return 'Templates/ML-AI/ComputerVision-YOLO' }
        if (Test-ContainsAny $Text @('nlp','transformer','llm')) { return 'Templates/ML-AI/NLP-Transformers' }
        return 'Templates/ML-AI/QUICK-START.md'
    }

    if (Test-ContainsAny $Text @('api','backend','service','microservice')) {
        if (Test-ContainsAny $Text @('dotnet','.net','c#')) { return 'Templates/Backend/DotNet-WebAPI' }
        if (Test-ContainsAny $Text @('java','spring')) { return 'Templates/Backend/Java-SpringBoot' }
        if (Test-ContainsAny $Text @('node','express','typescript')) { return 'Templates/Backend/NodeJS-Express' }
        return 'Templates/Backend/Python-FastAPI'
    }

    if (Test-ContainsAny $Text @('frontend','ui only','spa','react','next','vue','angular')) {
        if (Test-ContainsAny $Text @('angular')) { return 'Templates/Frontend/Angular' }
        if (Test-ContainsAny $Text @('vue')) { return 'Templates/Frontend/Vue' }
        if (Test-ContainsAny $Text @('next')) { return 'Templates/Frontend/NextJS' }
        return 'Templates/Frontend/React'
    }

    return 'Templates/FullStack/NextJS-FullStack'
}

function Resolve-CompanionTemplates {
    param([string]$Text)
    $companions = @()

    if (Test-ContainsAny $Text @('firebase')) { $companions += 'Templates/Mobile/Flutter-Firebase' }
    if (Test-ContainsAny $Text @('ai','ml','image recognition','goruntu')) { $companions += 'Templates/ML-AI/ComputerVision-YOLO' }
    if (Test-ContainsAny $Text @('booking','marketplace','odeme','payment')) { $companions += 'Templates/FullStack/NextJS-FullStack' }

    $companions = $companions | Select-Object -Unique
    return ($companions -join ', ')
}

function Resolve-Architecture {
    param(
        [string]$SelectedSize,
        [string]$TemplatePath
    )

    if ($TemplatePath.Contains('/Frontend/')) {
        return 'Feature-based component architecture'
    }
    if ($TemplatePath.Contains('/Mobile/')) {
        return 'MVVM (mobile-first UI + layered services)'
    }

    switch ($SelectedSize) {
        'XL' { return 'Microservice-ready domain architecture (bounded contexts)' }
        'L'  { return 'Modular monolith with explicit bounded contexts' }
        default { return 'Modular monolith (API-first + code-first)' }
    }
}

function Resolve-DeliveryMode {
    param([string]$SelectedSize)
    switch ($SelectedSize) {
        'S' { return 'Fast MVP: minimum infra, basic CI, critical tests only' }
        'M' { return 'Standard production-ready baseline: CI + staging + unit/integration tests' }
        'L' { return 'Advanced: stronger quality gates + observability + rollback readiness' }
        'XL' { return 'Enterprise: governance-heavy, release discipline, incident readiness' }
        default { return 'Standard production-ready baseline: CI + staging + unit/integration tests' }
    }
}

if (-not $Idea) {
    $Idea = Read-Host 'Proje fikrini yaz (or: e-ticaret sitesi, AI destekli mobil uygulama)'
}

if (-not $Idea) {
    Write-Error 'Proje fikri bos olamaz.'
    exit 1
}

if (($Size -eq 'AUTO') -and (-not $NoPrompt)) {
    $sizeAnswer = Read-Host 'Proje buyuklugu sec (S/M/L/XL) veya Enter ile AUTO'
    if ($sizeAnswer) {
        $candidate = $sizeAnswer.ToUpperInvariant()
        if (@('S','M','L','XL') -contains $candidate) {
            $Size = $candidate
        }
    }
}

$normalized = Get-NormalizedText $Idea
$finalSize = Resolve-Size -Text $normalized -SelectedSize $Size
$template = Resolve-Template -Text $normalized
$companionTemplates = Resolve-CompanionTemplates -Text $normalized
$architecture = Resolve-Architecture -SelectedSize $finalSize -TemplatePath $template
$delivery = Resolve-DeliveryMode -SelectedSize $finalSize

$result = [ordered]@{
    Timestamp = (Get-Date).ToString('yyyy-MM-dd HH:mm')
    Idea = $Idea
    SelectedSize = $finalSize
    RecommendedTemplate = $template
    CompanionTemplates = $companionTemplates
    RecommendedArchitecture = $architecture
    DeliveryMode = $delivery
    NextStep = 'ONE-COMMAND-AUTONOMY-PROMPT.md metnini kullanarak AI ajanini baslat'
}

Write-Host ''
Write-Host '=== AUTO SELECTION RESULT ===' -ForegroundColor Cyan
$result.GetEnumerator() | ForEach-Object {
    Write-Host ('{0}: {1}' -f $_.Key, $_.Value)
}

if ($SavePlan) {
    $md = @()
    $md += '# Project Auto Selection'
    $md += ''
    foreach ($kv in $result.GetEnumerator()) {
        $md += ('- {0}: {1}' -f $kv.Key, $kv.Value)
    }
    $md += ''
    $md += '## Startup Instruction'
    $md += 'ONE-COMMAND-AUTONOMY-PROMPT.md dosyasindaki komutu AI aracina ver.'
    Set-Content -Path $PlanPath -Value $md -Encoding UTF8
    Write-Host ('Plan saved to: {0}' -f $PlanPath) -ForegroundColor Green
}
