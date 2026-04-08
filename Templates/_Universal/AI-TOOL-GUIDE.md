# 🤖 AI-TOOL-GUIDE.md — Hangi AI Aracıyla En İyi Sonuç Alınır?

> VibeCoding framework'ünü kullanırken hangi AI aracını seçmelisiniz?
> Bu rehber, her aracın güçlü/zayıf yönlerini ve en iyi kullanım senaryosunu açıklar.

---

## 🏆 Araç Karşılaştırma Tablosu

| Araç | Otonom Seviye | Terminal | Dosya Yazma | Multi-File | Context | Maliyet |
|------|:---:|:---:|:---:|:---:|:---:|---------|
| **Claude Code (CLI)** | ⭐⭐⭐⭐⭐ | ✅ | ✅ | ✅ | 200K | API key bazlı |
| **Cursor IDE** | ⭐⭐⭐⭐⭐ | ✅ | ✅ | ✅ | 128K+ | $20/ay |
| **Windsurf IDE** | ⭐⭐⭐⭐ | ✅ | ✅ | ✅ | 128K+ | $15/ay |
| **GitHub Copilot Agent** | ⭐⭐⭐⭐ | ✅ | ✅ | ✅ | 128K+ | $10/ay |
| **Gemini Code Assist** | ⭐⭐⭐⭐ | ✅ | ✅ | ✅ | 1M+ | Free/paid |
| **Cline (VS Code)** | ⭐⭐⭐⭐ | ✅ | ✅ | ✅ | Model bağlı | API key |
| **Aider (CLI)** | ⭐⭐⭐ | ✅ | ✅ | ✅ | Model bağlı | API key |
| **ChatGPT (web)** | ⭐⭐ | ❌ | ❌ | ❌ | 128K | $20/ay |
| **Claude (web)** | ⭐⭐⭐ | ❌ | ❌ | ❌ | 200K | $20/ay |
| **Gemini (web)** | ⭐⭐ | ❌ | ❌ | ❌ | 1M+ | Free/$20 |

---

## 🎯 Senaryo Bazlı Öneriler

### 🏗️ "Sıfırdan proje üret" (tam otonom)
**En İyi:** Claude Code CLI, Cursor, Windsurf
```
Neden: Terminal çalıştırır → build kontrol eder → hataları gerçek zamanlı düzeltir
Nasıl: QUICK-START.md + proje fikri → AI tüm dosyaları yazar + test eder
```

### 🔧 "Mevcut projeye feature ekle"
**En İyi:** Cursor, GitHub Copilot Agent, Cline
```
Neden: Mevcut codebase'i okur → contextual code yazar → refactor yapar
Nasıl: Template rehberlerini .cursor/rules'a ekle → proje fikri yaz
```

### 📱 "Mobil uygulama geliştir"
**En İyi:** Cursor + Claude, Claude Code CLI
```
Neden: flutter run / expo start çalıştırır → hata çıkarsı düzeltir
Dikkat: Emulator kontrolü sınırlı — hot reload ile test
```

### 📝 "Kod review + analiz"
**En İyi:** ChatGPT (web), Claude (web), Gemini (web)
```
Neden: Tüm kodu yapıştır → analiz al → önerileri manuel uygula
Dikkat: Dosya yazamaz ama detaylı analiz yapar
```

### 🚀 "CI/CD + Deploy"
**En İyi:** Claude Code CLI, GitHub Copilot
```
Neden: GitHub Actions workflow yazar → Docker build test eder
```

---

## 📋 VibeCoding Framework ile Kullanım

### Agentic Araçlar (Cursor, Claude Code, Windsurf)

```
ADIM 1: Proje başlat
   → Template seç + QUICK-START.md + AUTONOMY-BRAIN.md + AI-BRAIN-ORCHESTRATOR.md okut
   
ADIM 2: AI'a talimat ver
   → "Bu projenin QUICK-START.md dosyasını oku ve aşağıdaki fikri gerçekleştir:
      [Proje fikriniz]"

ADIM 3: AI otonom çalışır
   → Dosyaları yazar → build eder → hataları düzeltir → test yazar
   → Chat talimatlarını ledger dosyalarına otomatik kaydeder
   → Monolith/microservice ve stack kararını gerekçesiyle decision log'a işler

ADIM 4: Validate
   → Domain-Quality-Ops/PRODUCTION-CHECKLIST.md + ledger kontrolü yap
   
ADIM 5: Review
   → AI'a "Domain-Quality-Ops/PRODUCTION-CHECKLIST.md'yi çalıştır" de
```

### Web Tabanlı AI (ChatGPT, Claude web)

```
ADIM 1: QUICK-START.md içeriğini kopyala → yapıştır
ADIM 2: Proje fikrini yaz
ADIM 3: AI kod üretir → sen dosyaları manuel oluştur
ADIM 4: Hata olursa → hata mesajını AI'a gönder
ADIM 5: Her dosya için tekrarla (emek yoğun!)
```

> ⚠️ Web tabanlı AI ile 50+ dosyalık proje üretmek SAATLER sürer.
> Agentic araçla dakikalar içinde tamamlanır.

Not:
- Araç fark etmeksizin otonomluk standardı için `AI-BRAIN-ORCHESTRATOR.md` zorunlu referanstır.

---

## 🔑 Cursor İçin VibeCoding Kuralları Ekleme

Cursor kullanıyorsanız, `.cursor/rules` dosyasına şunu ekleyin:

```
# .cursor/rules
Bu projeyi VibeCoding framework ile geliştiriyoruz.
Aşağıdaki kurallara uy:

1. Dosya başına yorum bloğu ekle (amaç, bağımlılıklar)
2. Naming convention: [template'e göre]
3. Her dosya değişikliğinde test güncelle
4. Loading/Error/Empty state her sayfada
5. Hardcoded secret ASLA → .env kullan
6. Separation of Concerns → Controller/Service/Repository ayrı
7. Console.log/print ASLA → Logger kullan
8. God class (1000+ satır) ASLA → böl

Hata olursa Domain-Quality-Ops/ERROR-PATTERNS.md'ye bak.
Proje bitince Domain-Quality-Ops/PRODUCTION-CHECKLIST.md'yi çalıştır.
```

---

## 💡 İpuçları

1. **Context limitini aşma:** MASTER-PROMPT + AI-RULES yerine QUICK-START.md kullan (tek dosya, yoğunlaştırılmış)
2. **Adım adım çalış:** Tüm dosyaları tek seferde yazdırma → gruplar halinde (models → services → controllers → UI)
3. **Build kontrol:** Her 5 dosyada bir "derle ve hataları göster" de
4. **Checkpoint kullan:** MASTER-PROMPT'taki 6 checkpoint'i takip et
5. **Hata olursa:** Domain-Quality-Ops/ERROR-PATTERNS.md'yi AI'a referans ver

---

## 🌐 Cross-Agent Uyum (Claude/Cursor/Windsurf/Codex)

- Ortak davranis standardi: `AGENT-CROSS-COMPATIBILITY.md`
- Hazir root dosya sablonlari: `AGENT-FILES-STARTER-KIT.md`
- Karar motoru ve hafiza protokolu: `AI-BRAIN-ORCHESTRATOR.md`
- Branch protection ve merge governance: `GITHUB-BRANCH-PROTECTION.md`
- Issue/PR/Release md sablonlari: `TEMPLATE-ISSUE.md`, `TEMPLATE-PR.md`, `TEMPLATE-RELEASE.md`
- Tek komut otonom baslatma: `ONE-COMMAND-AUTONOMY-PROMPT.md`
- Proje buyuklugu secim motoru: `PROJECT-SIZE-ENGINE.md`
- Otomatik secim scripti (tek non-md dosya): `project-autoselect.ps1`
- Detayli proje soru rehberi: `PROJECT-DISCOVERY-QUESTION-GUIDE.md`
- Universal okuma ve cakisma sirasi: `UNIVERSAL-READING-ORDER.md`

Hizli baslatma:
1. Aracina uygun root dosya sablonunu al (CLAUDE.md / AGENTS.md / rules).
2. Sablonu projeye koy ve AI-BRAIN-ORCHESTRATOR.md dosyasina bagla.
3. Ilk gorevde ledger writeback + CI gate calistigini dogrula.

PowerShell hizli kullanim:
1. `./project-autoselect.ps1 -Idea "B2C e-ticaret sitesi" -NoPrompt -SavePlan`
2. Cikan `SelectedSize`, `RecommendedTemplate` ve `RecommendedArchitecture` sonucuna gore ONE-COMMAND-AUTONOMY-PROMPT.md komutunu calistir.
