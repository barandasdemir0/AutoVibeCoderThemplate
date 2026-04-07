# 📋 BEST-PRACTICES.md — Evrensel Yazılım Best Practice Rehberi

---

## 🏗️ Mimari Best Practices (Top 3 Her Kategori)

### Backend
| # | Mimari | Prensip | Uygun Proje |
|---|--------|---------|-------------|
| 1 | **Clean Architecture** | Bağımlılık içe doğru, testable | Enterprise, uzun ömürlü |
| 2 | **MVC + Repository** | Basit, anlaşılır, hızlı | CRUD, medium projeler |
| 3 | **Vertical Slice** | Feature-based, pragmatik | Microservice, agile |

### Frontend
| # | Yaklaşım | Prensip |
|---|----------|---------|
| 1 | **Component-Based** | Küçük, reusable, tek sorumluluk |
| 2 | **Feature-Based** | Her feature kendi klasöründe |
| 3 | **Atomic Design** | Atoms → Molecules → Organisms → Templates → Pages |

### Mobile
| # | Mimari | Prensip |
|---|--------|---------|
| 1 | **MVVM** | View ↔ ViewModel ↔ Model (standart) |
| 2 | **Clean + MVVM** | UseCase katmanı ekle (enterprise) |
| 3 | **MVI** | Unidirectional data flow (reactive) |

---

## 📝 Kod Yazma Kuralları

### SOLID Prensipleri
| Harf | Prensip | Açıklama |
|------|---------|----------|
| **S** | Single Responsibility | Her class/fonksiyon TEK bir iş |
| **O** | Open/Closed | Genişlemeye açık, değişikliğe kapalı |
| **L** | Liskov Substitution | Alt sınıf, üst sınıfın yerine geçebilmeli |
| **I** | Interface Segregation | Küçük, spesifik arayüzler |
| **D** | Dependency Inversion | Somuta değil soyuta bağlan (DI) |

### DRY, KISS, YAGNI
| Prensip | Açıklama |
|---------|----------|
| **DRY** | Don't Repeat Yourself — Kod tekrarı yapma |
| **KISS** | Keep It Simple — Gereksiz karmaşıklık ekleme |
| **YAGNI** | You Ain't Gonna Need It — İhtiyaç olmadıkça ekleme |

### Kod Organizasyonu
```
✅ DOĞRU:
- Mantıksal gruplama (feature-based veya layer-based)
- Her dosya tek sorumluluk (max 200-300 satır)
- Import sırası: stdlib → 3rd party → local
- Yorum: "neden" yaz, "ne" değil (kod kendini açıklasın)

❌ YANLIŞ:
- Tek dosyada her şey (God class/file)
- HTML içinde CSS ve JS (ayrı dosyalar kullan)
- Magic number/string (const/config kullan)
- Console.log/print production'da (logger kullan)
- Try/catch'siz async işlemler
```

---

## 🔐 Güvenlik Best Practices
| Kural | Uygulama |
|-------|----------|
| Password → Hash | bcrypt, argon2 (MD5/SHA ASLA!) |
| Secrets → .env | Connection string, API key → .env → .gitignore |
| Input → Validate | SQL injection, XSS, path traversal engelle |
| Auth → JWT/OAuth | Session-based veya token-based (karıştırma) |
| HTTPS → Zorunlu | Production'da HTTP kabul etme |
| CORS → Whitelist | `*` kullanma, sadece izinli origin |
| Rate Limit | Brute force engelle (login, API) |
| File Upload | Tip kontrol, boyut limiti, virus scan |

---

## 📁 Dosya/Klasör Yapısı Best Practice

### Backend
```
src/
├── config/         → Ayarlar, DB bağlantısı, env
├── models/         → DB şeması (Entity/Model)
├── repositories/   → DB erişim (CRUD soyutlama)
├── services/       → İş mantığı (Repository kullanır)
├── controllers/    → HTTP endpoint (Service kullanır)
├── middleware/     → Auth, error handler, logging
├── validators/    → Input doğrulama
├── utils/         → Helper fonksiyonlar
└── tests/         → Unit + Integration testler
```

### Frontend
```
src/
├── components/    → Reusable UI (Button, Card, Modal)
├── pages/         → Tam sayfa (route = page)
├── services/      → API çağrıları (Axios/fetch)
├── store/         → Global state (Redux/Pinia/Zustand)
├── hooks/         → Custom hooks/composables
├── utils/         → Helper fonksiyonlar
├── assets/        → Resim, font, ikon
└── styles/        → Global CSS, tema
```

---

## ✅ Her Proje Başlangıç Checklist
- [ ] Git repo → `.gitignore` oluştur
- [ ] `.env` → secrets, SLA (gitignore'da)
- [ ] README.md → proje açıklaması, kurulum
- [ ] Linter → ESLint / Pylint / dotnet format
- [ ] Formatter → Prettier / Black / dotnet format
- [ ] CI/CD → GitHub Actions / GitLab CI
- [ ] Logging → günlük log dosyaları
- [ ] Error handling → global middleware
- [ ] Health check → `/api/health` endpoint
