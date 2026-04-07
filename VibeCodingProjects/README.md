# 🚀 VibeCoding Projects — Multi-Technology Template System v2.1

> **Tam bir VibeCoding canavarı** — Backend, Frontend, Mobile, ML/AI ve FullStack projelerini tek bir merkezi sistemden başlatın.
> **v2.1**: QUICK-START dosyaları, validate script, AI araç rehberi, otonom workflow eklendi!

## 🆕 v2.1 Yenilikler

| Özellik | Açıklama |
|---------|----------|
| ⚡ **QUICK-START.md** | Her template'te tek dosyalık yoğunlaştırılmış başlangıç talimatı — AI'a sadece bunu ver! |
| ✅ **validate-project.ps1** | Proje bittikten sonra otomatik doğrulama (güvenlik, yapı, kod kalitesi) |
| 🤖 **AI-TOOL-GUIDE.md** | Hangi AI aracıyla (Cursor, Claude Code, ChatGPT) en iyi sonuç alınır |
| 🚀 **AUTONOMOUS-WORKFLOW.md** | Tek dosyayla otonom proje üretme akışı (6 faz, checkpoint'ler) |
| 🔧 **Starter Code** | Her template'te gerçek çalışan boilerplate kod |
| 📄 **STARTER-BLUEPRINT.md** | AI'ın hangi pattern'i takip edeceği |
| ✅ **PRODUCTION-CHECKLIST.md** | Yayınlamadan önce 60+ maddelik kontrol listesi |
| 🔍 **ERROR-PATTERNS.md** | 100+ hata pattern'i ve çözümleri (tüm stack'ler) |
| 📱 **MOBILE-PUBLISH.md** | Play Store + App Store yayınlama rehberi |
| 🐳 **Deploy Dosyaları** | Dockerfile, docker-compose, GitHub Actions (gerçek dosyalar) |
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
│   │   ├── AI-TOOL-GUIDE.md       → 🆕 Hangi AI aracı en iyi?
│   │   ├── STARTER-USAGE.md       → Starter code kullanım rehberi
│   │   ├── ERROR-PATTERNS.md      → 100+ hata pattern → çözüm
│   │   ├── PRODUCTION-CHECKLIST.md→ Yayınlamadan önce kontrol
│   │   ├── MOBILE-PUBLISH.md      → Store yayınlama rehberi
│   │   ├── CONFIG-RULES.md        → Pipeline/middleware sırası
│   │   ├── AUTH-JWT.md, DB-GUIDE.md, REST-API.md, ...
│   │   └── deploy/               → Gerçek deploy dosyaları
│   │       ├── docker/            → Dockerfile.dotnet, .python, .node, .frontend
│   │       ├── compose/           → docker-compose (4 stack)
│   │       ├── ci/                → GitHub Actions (5 stack)
│   │       └── nginx.conf
│   ├── Backend/ (8 template — HER BİRİ QUICK-START.md içerir)
│   ├── Frontend/ (6 template)
│   ├── Mobile/ (4 template)
│   ├── ML-AI/ (4 template)
│   ├── FullStack/ (8 template)
│   └── Testing/ (7 template)
├── init-project.ps1               → 🚀 Gelişmiş proje başlatma (v2.0)
├── validate-project.ps1           → 🆕 Proje doğrulama (v1.0)
└── README.md                      → Bu dosya
```

## 🚀 Kullanım

### Yöntem 1: Tam Otonom (QUICK-START) — ÖNERİLEN

```
1. Template seç (ör: Mobile/Flutter-Firebase)
2. O template'in QUICK-START.md dosyasını aç
3. Agentic AI aracına (Cursor, Claude Code, Windsurf) ver:
   - QUICK-START.md içeriğini yapıştır
   - Proje fikrini yaz
   - "A'dan Z'ye tamamla" de
4. AI otonom çalışır → bitti!
5. validate-project.ps1 çalıştır → doğrula
```

### Yöntem 2: Script ile Proje Başlatma

```powershell
.\init-project.ps1
# → Kategori seç → Template seç → Proje adı gir
# → Starter code kopyalanır
# → Placeholder'lar değiştirilir
# → _Universal/ rehberler kopyalanır
# → .env oluşturulur
# → Git init yapılır
# → HAZIR!
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

```powershell
.\validate-project.ps1 -ProjectPath "C:\path\to\project"
# → Dosya yapısı ✅
# → Güvenlik kontrolleri ✅
# → Kod kalitesi ✅
# → Teknoloji bazlı kontroller ✅
# → Sonuç: PRODUCTION READY! 🚀
```

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
| `starter/` | **Gerçek çalışan kod** veya **BLUEPRINT** |

## 🧠 _Universal Rehberler (31 Dosya)

| Rehber | İçerik |
|--------|--------|
| `MASTER-PROMPT.md` | 🧠 AI otonom çalışma protokolü + starter code protokolü + self-validation |
| `AI-RULES.md` | 🤖 Dosya okuma sırası, hata algoritması, naming convention |
| `AUTONOMOUS-WORKFLOW.md` | 🚀 **YENİ** — Tam otonom üretim akışı (6 faz, checkpoint'ler) |
| `AI-TOOL-GUIDE.md` | 🤖 **YENİ** — Hangi AI aracıyla en iyi sonuç? |
| `STARTER-USAGE.md` | 🔧 Starter code kullanım rehberi |
| `ERROR-PATTERNS.md` | 🔍 100+ hata → çözüm (Flutter, React, .NET, Python, Node, Java, Swift, Kotlin) |
| `PRODUCTION-CHECKLIST.md` | ✅ 60+ maddelik yayınlama kontrol listesi |
| `MOBILE-PUBLISH.md` | 📱 Play Store + App Store yayınlama (signing, listing, review) |
| `CONFIG-RULES.md` | ⚙️ Pipeline/middleware sırası (tüm stack'ler) |
| `INTEGRATION-GUIDE.md` | 🔗 Backend+Frontend birleştirme |
| `deploy/` | 🐳 Dockerfile, docker-compose, CI/CD, nginx.conf |
| + 18 diğer rehber | Auth, DB, REST, Cache, Logging, Testing, UX, vb. |

## 💡 VibeCoding İlkeleri

1. **AI-First**: Her projeye başlamadan AI'a `QUICK-START.md` okut (veya detaylı okutma)
2. **Starter-First**: Hazır kodu al → üzerine business logic ekle
3. **Code-First**: DB şeması koddan üretilir (migration)
4. **Test-First**: Her feature için en az unit test yaz
5. **Self-Validate**: AI her adımda kendini kontrol eder
6. **Error-Aware**: Hata olunca QUICK-START → ERROR-PATTERNS.md
7. **Production-Ready**: Bitince PRODUCTION-CHECKLIST.md + validate-project.ps1
8. **Tool-Aware**: Doğru AI aracını kullan (AI-TOOL-GUIDE.md)
9. **Log Everything**: Günlük log dosyası + debug günlüğü
10. **Security**: JWT, CORS, input validation, .env secrets
11. **UX Matters**: Loading, error, empty state, dark mode, responsive
