# 🤖 AI-RULES.md — Yapay Zeka İçin VibeCoding Kuralları

> Bu dosya, projenizde kullandığınız AI modelin (ChatGPT, Gemini, Claude, Copilot, vb.) 
> hataları hızlı anlaması, doğru sırada çalışması ve best practice'lere uyması için 
> MUTLAKA okuması gereken kurallardır. Projeye başladığınızda AI'a bu dosyayı okutun.

---

## 📋 AI'ın Projeye Girişte Yapması Gerekenler

### 1. Önce OKU, Sonra YAZ
```
SIRA:
1. _Universal/UNIVERSAL-READING-ORDER.md oku → Cakisma ve okuma sırası tek kaynaktan belirlenir
2. _Universal/PROJECT-DISCOVERY-QUESTION-GUIDE.md oku → Kullaniciya sorulacak en detayli kesif sorulari
3. _Universal/CONTEXT-MEMORY-RAG-POLICY.md oku → Secmeli baglam, ozetleme ve hafiza disiplini
4. Sonra UNIVERSAL-READING-ORDER.md sirasina gore ilgili dosyalari oku
5. SONRA kod yaz
```

### 1.1 Zorunlu Hafıza Dosyaları
- Proje kökünde şu dosyalar yoksa oluştur:
  - `AI_DEVELOPMENT_LOG.md`
  - `AI_ERROR_LEDGER.md`
  - `AI_FEATURE_LEDGER.md`
  - `AI_CHAT_LEDGER.md`
  - `AI_DECISION_LOG.md`
- Kod yazmadan önce bu dosyaların son kayıtlarını oku.

### 2. Her Dosya Değişikliğinde
- Dosyanın **ne iş yaptığını** README veya dosya başındaki yorumda güncelle
- **Bağımlılıklarını** belirt (hangi dosyaları import ediyor, kimin import ediyor)
- **Debug Günlüğüne** yaz: tarih, dosya, değişiklik, neden
- `AI_FEATURE_LEDGER.md` içine "neden bu dosya eklendi/değişti" notu düş

### 3. Hata Ayıklama Algoritması
```
HATA BULUNDU →
  1. Hata mesajını OKU (tam mesaj, stack trace)
  2. 05-DebugTips.md'de DAHA ÖNCE aynı hata var mı kontrol et
  3. İlgili dosyayı aç, hatanın olduğu satırı bul
  4. Bağımlı dosyaları kontrol et (import chain)
  5. Çöz → 05-DebugTips.md'ye KAYDET (tarih + hata + çözüm)
  6. AI_ERROR_LEDGER.md'ye KAYDET (saat + kök neden + çözüm + doğrulama)
  6. Test et → Çalışıyor mu?
```

### 3.1 Kullanıcı Talimat Günlüğü (Chat Ledger)
- Kullanıcıdan gelen her net yönlendirmeyi `AI_CHAT_LEDGER.md` içine yaz:
  - Saat
  - Talimat özeti
  - Tip (feature, fix, refactor, infra)
  - Durum (pending/in-progress/completed)
- Kural: Belirsiz "evet/yes" yerine kullanıcının gerçek isteğini cümle olarak kaydet.
- Kural: Her yeni talimatta önce `AI_CHAT_LEDGER.md` içinde benzer kayıt ara; varsa tekrarlı soru sorma, mevcut karara göre ilerle.

---

## 🏗️ Kod Yazma Kuralları (AI İçin Zorunlu)

### 0. 🚨 YALITILMIŞ KLASÖR (WORKSPACE ISOLATION) İLKESİ - [KIRMIZI ÇİZGİ]
- Asla ama asla kodu doğrudan `.md` (emir) dosyalarının içine VEYA şablonların bulunduğu `Templates/` ana klasörüne üretme.
- Kaynak kodları (`src`, `lib`, `app` veya proje adıyla) her zaman size belirtilen proje kök dizini (root) içindeki alt bir klasör açarak sadece oraya inşa et. Emir dosyaları ile kaynak kodlar birbirine kesinlikle karışmamalı. `.md` yönerge dosyalarını değiştirmek, üzerlerine yazmak fiziksel olarak YASAKTIR!

### Separation of Concerns — ASLA Karıştırma
| ❌ YAPMA | ✅ YAP |
|----------|--------|
| HTML içine CSS yazma | Ayrı `.css` dosyası |
| HTML içine JS yazma | Ayrı `.js` dosyası |
| Controller'da iş mantığı | Service katmanında |
| View'da DB query | Repository/Service'den al |
| Hardcoded string/sayı | Config/Constants dosyası |
| Console.log production | Logger servisi (Serilog, Winston, logging) |

### Naming Convention (Evrensel)
| Dil | Dosya | Class/Component | Fonksiyon | Değişken | Sabit |
|-----|-------|----------------|-----------|----------|-------|
| C# | PascalCase.cs | PascalCase | PascalCase | camelCase | UPPER_CASE |
| Java | PascalCase.java | PascalCase | camelCase | camelCase | UPPER_CASE |
| Python | snake_case.py | PascalCase | snake_case | snake_case | UPPER_CASE |
| JavaScript | camelCase.js | PascalCase | camelCase | camelCase | UPPER_CASE |
| TypeScript | camelCase.ts | PascalCase | camelCase | camelCase | UPPER_CASE |
| PHP | PascalCase.php | PascalCase | camelCase | $camelCase | UPPER_CASE |
| Dart | snake_case.dart | PascalCase | camelCase | camelCase | lowerCamelCase |
| Kotlin | PascalCase.kt | PascalCase | camelCase | camelCase | UPPER_CASE |
| Swift | PascalCase.swift | PascalCase | camelCase | camelCase | camelCase |
| SQL Table | PascalCase/snake_case | — | — | — | — |
| API URL | /api/kebab-case | — | — | — | — |
| CSS Class | kebab-case / BEM | — | — | — | — |

### Her Dosyanın Başlangıç Şablonu
```
// ============================================
// Dosya: [dosya adı]
// Amaç: [tek cümle - bu dosya ne iş yapar]
// Bağımlılıklar: [import ettiği dosyalar]
// Oluşturulma: [tarih]
// Son Güncelleme: [tarih]
// ============================================
```

---

## 📐 Mimari Karar Rehberi — Top 3 Best Practice

### Backend Mimarileri
| Mimari | Ne Zaman? | Karmaşıklık | Uygun Proje |
|--------|-----------|-------------|-------------|
| **MVC** | Basit-orta projeler | ⭐⭐ | Blog, CRUD, portal |
| **Clean Architecture** | Orta-büyük, test edilebilir | ⭐⭐⭐⭐ | Enterprise, uzun ömürlü |
| **Vertical Slice** | Feature-based, pragmatik | ⭐⭐⭐ | Microservice, medium |

### Frontend Mimarileri
| Mimari | Ne Zaman? |
|--------|-----------|
| **Component-Based** | React, Vue, Angular — default |
| **Feature-Based (Atomic)** | Büyük SPA, çok ekipli |
| **Module-Based** | Angular enterprise |

### Mobile Mimarileri
| Mimari | Ne Zaman? |
|--------|-----------|
| **MVVM** | Flutter, Android, iOS — default best practice |
| **Clean + MVVM** | Büyük app, testable |
| **MVI (Model-View-Intent)** | Reactive, unidirectional data flow |

---

## 🔄 Algoritma Sırası (Her Feature İçin)

```
1. Planning     → Ne yapılacak? (01-Planning.md güncelle)
2. Design       → Nasıl yapılacak? (02-Architecture.md güncelle)
3. Basit Dilim  → Önce minimum çalışan sürüm (V1)
4. Model/Schema → DB tablosu / data model
5. Repository   → DB erişim katmanı
6. Service      → İş mantığı
7. Controller   → HTTP endpoint / UI handler
8. Frontend     → UI component
9. Test         → Unit + Integration
10. Debug       → Hata varsa 05-DebugTips.md + AI_ERROR_LEDGER.md
11. Log         → Domain-Quality-Ops/LOGGING.md + AI_FEATURE_LEDGER.md + AI_DEVELOPMENT_LOG.md
```

### 4. CI/CD ve Git Disiplini (Tamamlanma Şartı)
- Her değişiklik anlamlı commit bloklarına ayrılır (`feat:`, `fix:`, `docs:`).
- AI doğrudan `main` veya `develop` branch'ine commit atmaz; sadece `feature/*` veya `fix/*` branch'lerinde çalışır.
- Minimum CI kontrolü geçmeden feature tamamlandı denmez:
  - Lint
  - Unit test
  - Build
- CI kırmızıysa merge YASAKTIR.
- PR'siz doğrudan merge YASAKTIR.
- Release sürecinde semantic versioning (`vX.Y.Z`) ve `CHANGELOG.md` güncellemesi zorunludur.
- `Domain-Quality-Ops/DEPLOY-CICD.md` akışı referans alınır; staging doğrulaması olmadan production önerilmez.
- Ayrıntılı zorunlu akış için `AI-EXECUTION-POLICY.md` referans alınır.

---

## 🧠 AI Hata Tanıma İpuçları

### Hata Türleri ve Çözüm Yolu
| Hata Türü | İlk Bakılacak Yer |
|-----------|-------------------|
| 404 Not Found | Route/URL tanımı |
| 401 Unauthorized | JWT token, auth middleware |
| 403 Forbidden | Role/permission, [Authorize] |
| 500 Internal Error | Service/Repository, null reference |
| CORS Error | Backend CORS config |
| Type Error | DTO/Model mapping, serialization |
| Build Error | Package version, import path |
| DB Error | Connection string, migration |
| Style bozuk | CSS specificity, z-index, flex |
| State güncellenmemiyor | notifyListeners/setState/dispatch |
