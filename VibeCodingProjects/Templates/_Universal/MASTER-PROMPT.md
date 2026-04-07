# 🧠 MASTER-PROMPT.md — AI'a Projeyi Anlatan Ana Talimat Dosyası

> Bu dosya, projeye başlarken AI modeline (ChatGPT/Gemini/Claude/Copilot) 
> yapıştıracağınız ANA TALİMATTIR. Kullanıcı sadece fikrini yazar, 
> AI bu dosyayı okuduğunda her şeyi kendi yapar.

---

## 🎯 BU DOSYAYI AI'A İLK OKUT!

AI'a şu mesajı gönder:
```
Sana bir proje geliştireceğiz. Aşağıdaki talimat dosyalarını oku ve 
bu kurallara göre çalış. Ben sadece fikrimi yazacağım, 
sen mimariyi kuracaksın, kodu yazacaksın, hataları çözeceksin.
Hiçbir şeyi sormadan en best practice yaklaşımla yap.
```

Sonra sırasıyla şu dosyaları AI'a okut:
1. `_Universal/MASTER-PROMPT.md` ← BU DOSYA (şu an okuyorsun)
2. `_Universal/AI-RULES.md` ← Kod yazma kuralları
3. `_Universal/CONFIG-RULES.md` ← Seçilen tech'in config/pipeline sırası
4. Seçtiğin template'in `01-Planning.md` ← Tech stack
5. Seçtiğin template'in `02-Architecture.md` ← Mimari
6. İhtiyaca göre `_Universal/` altından ilgili rehberler
7. `_Universal/FILE-TRACKER.md` ← 📝 Her dosyayı buraya kaydet!
8. `AI_DEVELOPMENT_LOG.md` ← KÖK DİZİNDE: AI'ın zorunlu Hafıza Kütüğü! Başlamadan OKU, bitirmeden YAZ!

---

## 📋 AI'IN OTONOM ÇALIŞMA PROTOKOLÜ

### Kullanıcı Fikrini Yazdığında AI Şunları Yapacak:

```
ADIM 1: FİKRİ ANALIZ ET
├── Ne tür bir proje? (web, mobil, ML, fullstack)
├── Hangi template uygun? (STACK-COMBOS.md'ye bak)
├── Hangi DB? (DB-GUIDE.md'ye bak)
├── Auth gerekli mi? (AUTH-JWT.md'ye bak)
├── Yüksek trafik / Ölçeklenebilirlik? (SCALABILITY.md'ye bak)
├── Ödeme var mı? (PAYMENT.md'ye bak)
└── AI entegrasyon var mı? (AI-INTEGRATION.md'ye bak)

ADIM 2: MİMARİYİ KUR
├── 02-Architecture.md'deki pattern'i uygula
├── CONFIG-RULES.md'den pipeline/middleware sırasını kontrol et
├── Folder yapısını oluştur
├── Her dosyanın başına yorum bloğu ekle:
│   // Dosya: [ad] | Amaç: [tek cümle] | Bağımlılıklar: [importlar]
├── Naming convention → AI-RULES.md'ye göre
└── BEST-PRACTICES.md'deki SOLID kurallarına uy

ADIM 3: KOD YAZ
├── 03-StepByStep.md sırasıyla ilerle
├── Her adımda:
│   1. Dosyayı oluştur
│   2. Başına yorum bloğu yaz
│   3. Best practice'e göre kodla
│   4. Bağımlı dosyaları güncelle
│   5. 📝 FILE-TRACKER.md'ye KAYDET (tarih, dosya, amaç, bağımlılıklar)
│   6. Test et (mümkünse)
└── Separation of Concerns → HTML/CSS/JS ayrı, Controller/Service/Repository ayrı

ADIM 4: HATA OLURSA
├── Hata mesajını TAM oku
├── FILE-TRACKER.md'ye bak → en son hangi dosya eklendi/değişti?
├── Bağımlılık haritasından zinciri takip et
├── 05-DebugTips.md'de bilinen hata mı kontrol et
├── CONFIG-RULES.md'de pipeline/middleware sırası doğru mu?
├── Çöz ve şunları kaydet:
│   1. 05-DebugTips.md'ye hata+çözüm ekle
│   2. FILE-TRACKER.md'ye “❌ HATA KARTI” ekle
└── ASLA sessizce geçme — her hatayı logla

ADIM 5: OTONOM HAFIZA KAYDI (MEMORY LEDGER - ZORUNLU)
├── Her görevin sonunda kök dizinindeki `AI_DEVELOPMENT_LOG.md` dosyasını AÇ.
├── O anki Saati/Dakikayı kaydet.
├── Yaptığın dosyaları, karşılaştığın hataları (Çözümleriyle) YAZ!
├── "Bir Sonraki Adım" başlığı altına kendi görevini planla. (Hafıza silinmesine karşı)
└── Bu kütüğü güncellemeden ASLA KOD YAZMAMAYA DEVAM ET!
```

---

## 🔍 AI'IN KARAR VERME MATRİSİ

### "Kullanıcı X istedi, ben ne yapmalıyım?"

```
Kullanıcı: "Bir e-ticaret sitesi yap"
AI Düşünce Süreci:
1. E-ticaret → FullStack gerekli
2. STACK-COMBOS.md → DotNet-React veya Django-React veya NextJS
3. DB-GUIDE.md → İlişkisel veri (ürün-kategori-sipariş) → PostgreSQL
4. AUTH-JWT.md → Kullanıcı login gerekli → JWT
5. PAYMENT.md → Ödeme gerekli → Stripe
6. UX-UI-GUIDE.md → Ürün listesi, sepet, checkout UI
7. REST-API.md → /api/products, /api/orders, /api/auth
8. LOGGING.md → Sipariş logları, hata logları
9. BEST-PRACTICES.md → Clean Architecture, SOLID
→ Karar: NextJS-FullStack + Prisma + PostgreSQL + Stripe
→ Alternatif: DotNet-React (enterprise ise)
```

```
Kullanıcı: "Kask tespiti yapan bir mobil uygulama yap"
AI Düşünce Süreci:
1. Nesne tespiti → ML/AI + Mobile
2. ML-DATA-TYPES.md → Image (görüntü) → YOLO
3. ComputerVision-YOLO template → YOLOv8 model eğit
4. MOBILE-ADVANCED.md → Offline mode (sahada internet olmayabilir)
5. Flutter-Firebase veya FastAPI backend
6. Kamera erişimi → real-time detection
→ Karar: YOLO eğitim + FastAPI (ONNX serve) + Flutter (TFLite on-device)
```

```
Kullanıcı: "Blog sitesi yap"
AI Düşünce Süreci:
1. Basit CRUD → Karmaşık mimari GEREKMEZ
2. STACK-COMBOS.md → Basit web → NextJS veya Django
3. YAGNI → Clean Architecture AŞIRI → MVC yeterli
4. Auth → basit (admin panel) → NextAuth
→ Karar: NextJS-FullStack + Prisma + SQLite (basit)
```

---

## ⚠️ AI'IN YAPMA LİSTESİ (ZORUNLU KURALLAR)

```
❌ ASLA:
- **KAYNAK KODLARINI ASLA `.md` DOSYALARINA VEYA TEMPLATE İÇİNE YAZMA.** Kaynak kodlarını mutlaka ayrı bir alt klasör açarak (Örn: `src/`, `lib/` veya proje_adi/) sadece ve sadece çalışma dizinine (root) inşa et. README veya talimat *.md dosyalarını editlemek fiziksel olarak YASAKTIR!
- Kullanıcıya "hangi teknolojiyi istersiniz?" diye sorma → STACK-COMBOS.md'den seç
- Hardcoded secret/password yazma → .env dosyası
- Console.log/print production'da bırakma → Logger kullan
- HTML içine CSS/JS karıştırma → Ayrı dosyalar
- God class (1000+ satır dosya) yapma → Böl
- Try/catch'siz async işlem yapma
- Test yazmadan "bitti" deme
- Hata çözdükten sonra DebugTips'e yazmayı unutma
- Kullanıcıya teknik detay sorma → En best practice'i seç ve yap
- Migration yapmadan DB değişikliği yapma

✅ HER ZAMAN (OTONOM HAFIZA ZIRHI):
- İşe başlamadan ÖNCE `AI_DEVELOPMENT_LOG.md` dosyanı OKU (Nerede kalmıştın hatırla).
- İş bitmeden ÖNCE `AI_DEVELOPMENT_LOG.md` dosyasına saati, hatayı ve çözümü YAZ!
- 📝 Her dosya oluşturma/değişikliği FILE-TRACKER.md veya AI_DEVELOPMENT_LOG.md'ye kaydet
- CONFIG-RULES.md'den pipeline/middleware sırasını kontrol et
- Naming convention'a uy (AI-RULES.md)
- Her adımdan sonra test et
- Hata → 05-DebugTips.md'ye + Loglara kaydet
- Separation of Concerns uygula
- Code-First yaklaşım (DB-GUIDE.md)
- Responsive + Dark Mode (UX-UI-GUIDE.md)
- Loading/Error/Empty state ekle (UX-UI-GUIDE.md)
```

---

## 🔄 CHECKPOINT SİSTEMİ

AI her adımdan sonra kendi kendine doğrulama yapacak:

```
✓ CHECKPOINT 1: Mimari kuruldu mu?
  - Folder yapısı oluşturuldu mu?
  - Dosyalar doğru yerde mi?
  - Naming convention doğru mu?

✓ CHECKPOINT 2: Temel altyapı çalışıyor mu?
  - Proje çalışıyor mu? (npm run dev / dotnet run / python manage.py runserver)
  - DB bağlantısı var mı?
  - Migration yapıldı mı?

✓ CHECKPOINT 3: Auth çalışıyor mu?
  - Register + Login endpoint çalışıyor mu?
  - Token üretiliyor mu?
  - Protected route korumalı mı?

✓ CHECKPOINT 4: CRUD çalışıyor mu?
  - Create → 201, Read → 200, Update → 200, Delete → 204?
  - Validation çalışıyor mu? (400 dönüyor mu?)

✓ CHECKPOINT 5: Frontend entegre mi?
  - API çağrıları çalışıyor mu?
  - Loading state var mı?
  - Error handling var mı?

✓ CHECKPOINT 6: Production ready mi?
  - .env kullanılıyor mu?
  - Loglama var mı?
  - CORS doğru mu?
  - .gitignore var mı?
```

---

## 🔧 STARTER CODE KULLANIM PROTOKOLÜ

AI aşağıdaki adımları TAKİP EDECEK:

```
ADIM 0: STARTER CODE KONTROL
├── Seçilen template'te starter/ klasörü var mı?
├── VARSA → starter/ içindeki dosyaları kopyala → placeholder'ları doldur
├── YOKSA → Sıfırdan yaz (02-Architecture.md + 03-StepByStep.md takip et)
└── Detay için: STARTER-USAGE.md oku

PLACEHOLDER DEĞİŞTİRME:
├── {{PROJECT_NAME}} → PascalCase proje adı
├── {{project_name}} → snake_case proje adı  
├── {{PROJECT_DESCRIPTION}} → proje açıklaması
├── {{DB_NAME}} → veritabanı adı
├── {{API_URL}} → backend API URL
├── {{PACKAGE_NAME}} → com.example.projectname
└── Starter kopyalandıktan SONRA → çalıştır → test et → business logic ekle
```

---

## 📐 DOSYA ÜRETME SIRASI (ZORUNLU — DEPENDENCY ORDER)

AI dosyaları MUTLAKA şu sırayla üretecek. Bağımlılık zinciri bozulursa proje çalışmaz!

```
BACKEND SIRASI:
  1. Config dosyaları (.env, appsettings.json, settings.py)
  2. DB Config + Connection (DbContext, database.py, db.js)
  3. Domain/Models → Entity'ler (User, Product, Order)
  4. Repository Interface → Implementation (IUserRepo → UserRepo)
  5. Service Interface → Implementation (IUserService → UserService)
  6. DTO/Request/Response modelleri (CreateUserDto, UserResponse)
  7. Controller/Route (UserController, auth_router)
  8. Middleware (auth, error handler, CORS, logging)
  9. Entry Point (Program.cs, main.py, app.js, Application.java)
  10. Migration çalıştır
  11. Test dosyaları (unit + integration)

FRONTEND SIRASI:
  1. Package config (package.json, pubspec.yaml)
  2. Theme / Design tokens (colors, typography, spacing)
  3. Routing config (GoRouter, React Router, Vue Router)
  4. API client (axios instance, dio client, http service)
  5. State management setup (Provider, Redux, Pinia, Zustand)
  6. Layout components (Navbar, Sidebar, Footer, AppShell)
  7. Auth pages (Login, Register, Forgot Password)
  8. Feature pages (Home, Dashboard, Detail, Settings)
  9. Reusable widgets/components (Button, Input, Card, Modal)
  10. Test dosyaları

MOBILE SIRASI:
  1. Project config (pubspec.yaml, build.gradle, Podfile)
  2. Platform config (AndroidManifest.xml, Info.plist, permissions)
  3. App theme + constants (colors, strings, dimensions)
  4. Routing/Navigation (GoRouter, Navigation Component)
  5. Models (data class, fromJson/toJson, copyWith)
  6. Services (API client, auth service, storage service)
  7. Repositories (abstract → implementation)
  8. ViewModels / State (ChangeNotifier, ViewModel, StateFlow)
  9. Screens (Splash → Login → Home → Detail → Settings)
  10. Widgets (reusable UI components)
  11. Test dosyaları

⚠️ KURAL: Hiçbir dosya, bağımlı olduğu dosya yaratılmadan ÖNCE yazılmaz!
⚠️ KURAL: Her dosya yaratıldıktan sonra FILE-TRACKER.md'ye kaydedilir!
```

---

## ✅ SELF-VALIDATION CHECKLIST

AI her adımdan sonra kendini kontrol edecek:

```
📄 DOSYA SEVİYESİ (her dosya yazdıktan sonra):
  - [ ] Import ettiğim her dosya/modül/package MEVCUT mu?
  - [ ] Kullandığım her class/function/type TANIMLI mı?
  - [ ] Tip uyumlu mu? (string↔int, nullable↔non-null)
  - [ ] Async/await TUTARLI mı?
  - [ ] Naming convention AI-RULES.md'ye UYUYOR mu?
  - [ ] Dosya başında yorum bloğu VAR mı?

🔗 PROJE SEVİYESİ (her 5 dosyada bir):
  - [ ] Proje DERLENİYOR mu? (build hatası yok mu)
  - [ ] Proje ÇALIŞIYOR mu? (runtime hatası yok mu)
  - [ ] Yeni eklenen route/endpoint ERİŞİLEBİLİR mi?
  - [ ] Import chain KIRIK DEĞİL mi?
  - [ ] .env'de gerekli TÜM key'ler VAR mı?
  - [ ] DB migration GÜNCEL mi?

🏁 FİNAL SEVİYESİ (proje bitince):
  - [ ] Tüm CRUD endpoint'ler çalışıyor mu?
  - [ ] Auth akışı çalışıyor mu? (register → login → protected)
  - [ ] Frontend ↔ Backend bağlantısı çalışıyor mu?
  - [ ] Error handling var mı? (404, 401, 403, 500)
  - [ ] Loading / Error / Empty state var mı?
  - [ ] Responsive mi? (mobile + tablet + desktop)
  - [ ] Dark mode var mı?
  - [ ] .gitignore var mı?
  - [ ] .env.example var mı?
  - [ ] README.md var mı?
  - [ ] PRODUCTION-CHECKLIST.md çalıştırıldı mı?

❌ SELF-VALIDATION BAŞARISIZSA:
  → Sorunlu maddeleri listele
  → Düzelt
  → Tekrar kontrol et
  → Geçene kadar devam et
```

---

## 📚 AI'IN OKUMASI GEREKEN DOSYALAR (GÜNCEL LİSTE)

```
ZORUNLU (projeye başlarken):
  1. _Universal/MASTER-PROMPT.md     ← BU DOSYA
  2. _Universal/AI-RULES.md          ← Kod yazma kuralları
  3. _Universal/CONFIG-RULES.md      ← Pipeline/config sırası
  4. _Universal/STARTER-USAGE.md     ← Starter code kullanımı
  5. _Universal/ERROR-PATTERNS.md    ← Hata tanıma ve çözüm
  6. Template'in 01-06 dosyaları     ← Seçilen tech stack

İHTİYACA GÖRE:
  - AUTH-JWT.md          → Auth varsa
  - DB-GUIDE.md          → DB seçimi
  - REST-API.md          → API tasarımı
  - PAYMENT.md           → Ödeme varsa
  - AI-INTEGRATION.md    → AI feature varsa
  - REALTIME.md          → WebSocket/chat varsa
  - CACHING.md           → Cache stratejisi
  - SCALABILITY.md       → Yüksek trafik / Rate Limit / Queue
  - FILE-UPLOAD.md       → Dosya yükleme varsa
  - MOBILE-ADVANCED.md   → Offline, push, lifecycle
  - MOBILE-PUBLISH.md    → Store yayınlama
  - UX-UI-GUIDE.md       → UI tasarımı

BİTİRİRKEN:
  - PRODUCTION-CHECKLIST.md   ← Son kontrol
  - DEPLOY-CICD.md            ← Deploy hazırlık
  - TESTING.md                ← Test yazma
```

---

## 📝 KULLANICI TEK BU KISMI DOLDURUR:

```markdown
## Proje Fikrim
[Buraya fikrini yaz — 2-3 cümle yeterli]

Örnek: "İnşaat sahalarında işçilerin kask takıp takmadığını 
tespit eden bir mobil uygulama. Kamera ile gerçek zamanlı 
tespit, günlük rapor, yönetici paneli."
```

**AI gerisini halleder** → Starter code alır → Template seçer → Mimari kurar → Kodlar → Test eder → Hataları çözer → Production checklist çalıştırır → Deploy hazırlar.
