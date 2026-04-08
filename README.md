# 🚀 VibeCoding Projects — Multi-Technology Template System v2.2 (MD-Only)

> **Tam bir VibeCoding canavarı** — Backend, Frontend, Mobile, ML/AI ve FullStack projelerini tek bir merkezi sistemden başlatın.
> **v2.2**: Tam markdown-only mimari, kalıcı hafıza ledger'ları, otonom işletim sistemi kuralı.

## 🎯 Projenin Amacı

Bu projenin amaci, farkli teknoloji yiginlari icin tekrar tekrar sifirdan plan cikarma ihtiyacini ortadan kaldirmak ve AI destekli gelistirmeyi standart bir sisteme baglamaktir.

Hedeflenen sonuc:
- Projeyi dogru template ile hizli baslatmak
- AI ajanini tek tip kurallarla yonetmek
- Hata/karar/feature gecmisini kaybetmeden ilerlemek
- Checklist ve quality gate'lerle daha guvenli teslimat yapmak

Kisaca: Bu repo, fikirden calisan urune giden sureci hizlandiran, hafiza destekli ve markdown-only bir VibeCoding isletim sistemidir.

## 🆕 v2.1 Yenilikler

| Özellik | Açıklama |
|---------|----------|
| ⚡ **QUICK-START.md** | Her template'te tek dosyalık yoğunlaştırılmış başlangıç talimatı — AI'a sadece bunu ver! |
| ✅ **MD Validation Akışı** | Proje bittikten sonra checklist tabanlı doğrulama (güvenlik, yapı, kod kalitesi) |
| 🤖 **AI-TOOL-GUIDE.md** | Hangi AI aracıyla (Cursor, Claude Code, ChatGPT) en iyi sonuç alınır |
| 🚀 **AUTONOMOUS-WORKFLOW.md** | Tek dosyayla otonom proje üretme akışı (6 faz, checkpoint'ler) |
| 🧠 **AUTONOMOUS-OPERATING-SYSTEM.md** | Teknoloji seçimi + mimari öncelik + quality gates |
| 🔧 **Starter Code** | Her template'te gerçek çalışan boilerplate kod |
| 📄 **STARTER-BLUEPRINT.md** | AI'ın hangi pattern'i takip edeceği |
| ✅ **PRODUCTION-CHECKLIST.md** | Yayınlamadan önce 60+ maddelik kontrol listesi |
| 🔍 **ERROR-PATTERNS.md** | 100+ hata pattern'i ve çözümleri (tüm stack'ler) |
| 📱 **MOBILE-PUBLISH.md** | Play Store + App Store yayınlama rehberi |
| 🐳 **Deploy Rehberi** | Docker, compose, CI/CD için markdown tabanlı şablon rehber |
| 📐 **Dosya Üretme Sırası** | Dependency order — hangi dosya önce yazılır |
| ✅ **Self-Validation** | AI her adımda kendini kontrol eder |

## 📂 Yapı

```
VibeCodingProjects/
├── Templates/
│   ├── _Base/                     → Teknoloji-bağımsız generic şablon
│   ├── _Universal/                → 🧠 CROSS-CUTTING rehberler (31 dosya)
│   │   ├── MASTER-PROMPT.md       → AI'a ilk okutulacak — otonom çalışma protokolü
│   │   ├── AI-RULES.md            → Kod yazma kuralları, dosya okuma sırası
│   │   ├── AUTONOMOUS-WORKFLOW.md → 🆕 Tam otonom üretim akışı (6 faz)
│   │   ├── AUTONOMY-BRAIN.md      → 🆕 Context engineering + kalıcı hafıza protokolü
│   │   ├── AI-TOOL-GUIDE.md       → 🆕 Hangi AI aracı en iyi?
│   │   ├── AUTONOMOUS-OPERATING-SYSTEM.md → 🆕 Tam otonom işletim kuralı
│   │   ├── STARTER-USAGE.md       → Starter code kullanım rehberi
│   │   ├── ERROR-PATTERNS.md      → 100+ hata pattern → çözüm
│   │   ├── PRODUCTION-CHECKLIST.md→ Yayınlamadan önce kontrol
│   │   ├── MOBILE-PUBLISH.md      → Store yayınlama rehberi
│   │   ├── CONFIG-RULES.md        → Pipeline/middleware sırası
│   │   ├── AUTH-JWT.md, DB-GUIDE.md, REST-API.md, ...
│   │   └── DEPLOY-CICD.md        → Deploy/CI örnekleri (markdown snippet)
│   ├── Backend/ (8 template — HER BİRİ QUICK-START.md içerir)
│   ├── Frontend/ (6 template)
│   ├── Mobile/ (4 template)
│   ├── ML-AI/ (4 template)
│   ├── FullStack/ (8 template)
│   └── Testing/ (7 template)
└── README.md                      → Bu dosya
```

## 🚀 Kullanım

## 🧭 Calisma Mantigi (Net Akis)

1. Kullanici fikrini `PROJECT-IDEA.md` dosyasina yazar.
2. Uygun template secilir (Base + Universal cekirdek md dosyalariyla).
3. AI'a su 2 sey verilir:
   - `PROJECT-IDEA.md`
   - Secilen template'in `QUICK-START.md`
4. AI once mimari ve kararlarini olusturur, sonra kodu proje klasorunde uretir.
5. Her gorev sonunda ledger dosyalari guncellenir.
6. `validate-project.ps1` ile enforcement kontrolu calistirilir.

Kritik not:
- Kullanici fikrinin ana kaynagi `PROJECT-IDEA.md` dosyasidir.
- "Fikri nereye yazacagim?" sorusunun cevabi: `PROJECT-IDEA.md`.

### Yöntem 1: Tam Otonom (QUICK-START) — ÖNERİLEN

```
1. Template seç (ör: Mobile/Flutter-Firebase)
2. O template'in QUICK-START.md dosyasını aç
3. Agentic AI aracına (Cursor, Claude Code, Windsurf) ver:
   - PROJECT-IDEA.md içeriğini yapıştır
   - QUICK-START.md içeriğini yapıştır
   - Proje fikrini yaz
   - "A'dan Z'ye tamamla" de
4. AI otonom çalışır → bitti!
5. PRODUCTION-CHECKLIST.md + ledger kapanışları ile doğrula
```

### Yöntem 2: Tam MD Akışı (Script Yok)

```
1. Template klasörünü seç
2. QUICK-START.md + MASTER-PROMPT.md + AUTONOMY-BRAIN.md okut
3. AI'dan proje iskeletini bu dokümanlara göre oluşturmasını iste
4. Her adım sonrası ledger kayıtlarını zorunlu tut
5. Checklist ile doğrula
```

### Yöntem 3: AI'a Detaylı Okut (Büyük Projeler)

```
1. _Universal/MASTER-PROMPT.md okut → Otonom protokol
2. _Universal/AI-RULES.md okut → Kuralları öğrensin
3. _Universal/AUTONOMOUS-WORKFLOW.md okut → Tam akış
4. Seçilen template'in QUICK-START.md okut
5. Projenin fikrini yaz → AI gerisini halleder!
```

### Proje Doğrulama

```
1. PRODUCTION-CHECKLIST.md'yi uçtan uca uygula
2. AI_ERROR_LEDGER.md'de open kayıt bırakma
3. AI_FEATURE_LEDGER.md'de her feature için doğrulama kanıtı tut
4. AI_DEVELOPMENT_LOG.md'da final kapanış yaz
```

### Script Tabanli Enforcement (9.5/10 Mod)

```powershell
# Standart dogrulama (placeholder varsa warning)
.\validate-project.ps1

# Siki dogrulama (placeholder varsa fail)
.\validate-project.ps1 -StrictLedger
```

Scriptler:
- `scripts/ledger-healthcheck.ps1` -> Ledger varligi, bosluk ve placeholder kontrolu
- `scripts/root-safe-guard.ps1` -> `Templates/` altina kaynak kod sizmasini engeller
- `validate-project.ps1` -> Tum kontrolleri tek komutta calistirir

## ⚡ QUICK-START Durumu

| Template | QUICK-START | Starter Code | Blueprint |
|----------|:---:|:---:|:---:|
| Flutter-Firebase | ✅ | ✅ 22 dosya | ✅ |
| Kotlin-MVVM | ✅ | — | ✅ |
| ReactNative | ✅ | — | ✅ |
| SwiftUI-iOS | ✅ | — | ✅ |
| Python-FastAPI | ✅ | ✅ 17 dosya | ✅ |
| NodeJS-Express | ✅ | ✅ 10 dosya | ✅ |
| DotNet-WebAPI | ✅ | — | ✅ |
| React (Vite) | ✅ | ✅ 13 dosya | ✅ |
| NextJS | ✅ | — | ✅ |
| NextJS-FullStack | ✅ | — | ✅ |
| Testing/Mobile-Flutter | ✅ | — | ✅ |
| DotNet-MVC | — | — | ✅ |
| Python-Flask | — | — | ✅ |
| Python-Django | — | — | ✅ |
| PHP-Laravel | — | — | ✅ |
| Java-SpringBoot | — | — | ✅ |
| Angular/Vue | — | — | ✅ |
| ML-AI (4 template) | — | — | ✅ |
| FullStack (7 template) | — | — | ✅ |
| Testing (6 template) | — | — | ✅ |

> ⚡ QUICK-START = AI'a tek dosya ver → otonom üretim
> ✅ Starter Code = Gerçek çalışan boilerplate kod
> ✅ Blueprint = AI'ın takip edeceği detaylı klasör/dosya yapısı

## 📄 Her Template İçeriği

| Dosya | İçerik |
|-------|--------|
| `QUICK-START.md` | 🆕 **Tek dosyalık tam talimat** — AI'a sadece bunu ver |
| `01-Planning.md` | Proje hedefleri, tech stack, MVP, backlog |
| `02-Architecture.md` | Mimari desen, folder yapısı, ORM, auth akışı |
| `03-StepByStep.md` | Adım adım kurulum ve geliştirme rehberi |
| `04-FilesStructure.md` | Dosya açıklamaları, naming kuralları |
| `05-DebugTips.md` | Sık hatalar ve çözümleri, debug araçları |
| `06-Resources.md` | Dökümantasyon linkleri, code snippets |
| `starter/` | **Blueprint referansı** (md-first uyarlama rehberi) |

## 🧠 _Universal Rehberler (31 Dosya)

| Rehber | İçerik |
|--------|--------|
| `MASTER-PROMPT.md` | 🧠 AI otonom çalışma protokolü + starter code protokolü + self-validation |
| `AI-RULES.md` | 🤖 Dosya okuma sırası, hata algoritması, naming convention |
| `AUTONOMOUS-WORKFLOW.md` | 🚀 **YENİ** — Tam otonom üretim akışı (6 faz, checkpoint'ler) |
| `AUTONOMY-BRAIN.md` | 🧠 **YENİ** — Context engineering, chat/error/feature hafızası, CI kapısı |
| `AUTONOMOUS-OPERATING-SYSTEM.md` | 🧠 **YENİ** — Bias'sız teknoloji seçimi ve adım adım otonom yürütme |
| `AI-TOOL-GUIDE.md` | 🤖 **YENİ** — Hangi AI aracıyla en iyi sonuç? |
| `STARTER-USAGE.md` | 🔧 Starter code kullanım rehberi |
| `ERROR-PATTERNS.md` | 🔍 100+ hata → çözüm (Flutter, React, .NET, Python, Node, Java, Swift, Kotlin) |
| `PRODUCTION-CHECKLIST.md` | ✅ 60+ maddelik yayınlama kontrol listesi |
| `MOBILE-PUBLISH.md` | 📱 Play Store + App Store yayınlama (signing, listing, review) |
| `CONFIG-RULES.md` | ⚙️ Pipeline/middleware sırası (tüm stack'ler) |
| `INTEGRATION-GUIDE.md` | 🔗 Backend+Frontend birleştirme |
| `DEPLOY-CICD.md` | 🐳 Docker/CI/CD örnekleri ve uygulama adımları |
| + 18 diğer rehber | Auth, DB, REST, Cache, Logging, Testing, UX, vb. |

## 💡 VibeCoding İlkeleri

1. **AI-First**: Her projeye başlamadan AI'a `QUICK-START.md` okut (veya detaylı okutma)
2. **Starter-First**: Hazır kodu al → üzerine business logic ekle
3. **Code-First**: DB şeması koddan üretilir (migration)
4. **Test-First**: Her feature için en az unit test yaz
5. **Self-Validate**: AI her adımda kendini kontrol eder
6. **Error-Aware**: Hata olunca QUICK-START → ERROR-PATTERNS.md
7. **Production-Ready**: Bitince PRODUCTION-CHECKLIST.md + ledger kapanışları
8. **Tool-Aware**: Doğru AI aracını kullan (AI-TOOL-GUIDE.md)
9. **Log Everything**: Günlük log dosyası + debug günlüğü
10. **Security**: JWT, CORS, input validation, .env secrets
11. **UX Matters**: Loading, error, empty state, dark mode, responsive
