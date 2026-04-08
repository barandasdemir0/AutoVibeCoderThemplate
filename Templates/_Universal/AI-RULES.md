# 🤖 AI-RULES.md — Yapay Zeka İçin VibeCoding Kuralları

> Bu dosya, projenizde kullandığınız AI modelin (ChatGPT, Gemini, Claude, Copilot, vb.) 
> hataları hızlı anlaması, doğru sırada çalışması ve best practice'lere uyması için 
> MUTLAKA okuması gereken kurallardır. Projeye başladığınızda AI'a bu dosyayı okutun.

---

## 📋 AI'ın Projeye Girişte Yapması Gerekenler

### 1. Önce OKU, Sonra YAZ
```
SIRA:
1. README.md oku → Projenin ne olduğunu anla
2. 01-Planning.md oku → Tech stack, MVP, hedefler
3. 02-Architecture.md oku → Mimari, klasör yapısı, deseni
4. 04-FilesStructure.md oku → Hangi dosya ne iş yapıyor
5. 05-DebugTips.md oku → Bilinen hatalar ve çözümler
6. 03-StepByStep.md oku → Hangi aşamadayız
7. SONRA kod yaz
```

### 2. Her Dosya Değişikliğinde
- Dosyanın **ne iş yaptığını** README veya dosya başındaki yorumda güncelle
- **Bağımlılıklarını** belirt (hangi dosyaları import ediyor, kimin import ediyor)
- **Debug Günlüğüne** yaz: tarih, dosya, değişiklik, neden

### 3. Hata Ayıklama Algoritması
```
HATA BULUNDU →
  1. Hata mesajını OKU (tam mesaj, stack trace)
  2. 05-DebugTips.md'de DAHA ÖNCE aynı hata var mı kontrol et
  3. İlgili dosyayı aç, hatanın olduğu satırı bul
  4. Bağımlı dosyaları kontrol et (import chain)
  5. Çöz → 05-DebugTips.md'ye KAYDET (tarih + hata + çözüm)
  6. Test et → Çalışıyor mu?
```

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
3. Model/Schema → DB tablosu / data model
4. Repository   → DB erişim katmanı
5. Service      → İş mantığı
6. Controller   → HTTP endpoint / UI handler
7. Frontend     → UI component
8. Test         → Unit + Integration
9. Debug        → Hata varsa 05-DebugTips.md'ye yaz
10. Log         → LOGGING.md'ye göre log ekle
```

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
