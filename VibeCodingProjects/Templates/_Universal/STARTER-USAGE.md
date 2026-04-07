# 🔧 STARTER-USAGE.md — Starter Code Kullanım Rehberi

> Her template'in `starter/` klasöründe çalışır durumda bir başlangıç kodu var.
> AI bu kodu baz alarak, sadece projeye özel business logic ekler.

---

## 📋 Starter Code Nedir?

Starter code = **mimarinin kod olarak somutlaştırılmış hali**.

| Geleneksel | Starter Code ile |
|-----------|-----------------|
| AI rehberi okur → sıfırdan yazar → tutarsız | AI hazır kodu alır → pattern'i takip eder → tutarlı |
| Her seferinde farklı yapı | Her seferinde aynı mimari |
| 200+ dosya = kaçınılmaz hatalar | Starter hazır → sadece business logic ekle |
| Bağımlılıklar eksik olabilir | pubspec.yaml / package.json hazır |

---

## 🤖 AI İçin Starter Code Protokolü

### ADIM 0: Starter Kontrol
```
Seçilen template'te starter/ klasörü var mı?
├── EVET → ADIM 1'e git
└── HAYIR → Sıfırdan yaz (02-Architecture.md + 03-StepByStep.md takip et)
```

### ADIM 1: Kopyala ve Placeholder'ları Değiştir
```
1. starter/ klasöründeki TÜM dosyaları proje klasörüne kopyala
2. Şu placeholder'ları projeye göre değiştir:
   - {{PROJECT_NAME}} → gerçek proje adı (PascalCase)
   - {{project_name}} → gerçek proje adı (snake_case)
   - {{PROJECT_DESCRIPTION}} → proje açıklaması
   - {{DB_NAME}} → veritabanı adı
   - {{API_URL}} → backend URL
   - {{PACKAGE_NAME}} → com.example.projectname
```

### ADIM 2: Config Dosyalarını Güncelle
```
- pubspec.yaml / package.json → proje adı, description
- .env.example → .env olarak kopyala → gerçek değerleri ekle
- DB adını güncelle
- API URL'ini güncelle
- Port numarasını güncelle (çakışma olmasın)
```

### ADIM 3: Çalıştır ve Test Et
```
- flutter run / npm run dev / dotnet run / python manage.py runserver
- Hata var mı? → ERROR-PATTERNS.md'ye bak
- Çalışıyorsa → ADIM 4'e geç
```

### ADIM 4: Business Logic Ekle
```
Starter code pattern'lerine bakarak yeni dosyalar ekle:

Model eklerken:
  → starter'daki user_model örneğine bak
  → Aynı pattern'i kullan (fromJson, toJson, copyWith)
  → Aynı klasöre koy (data/models/)

Repository eklerken:
  → starter'daki user_repository örneğine bak
  → Aynı interface + implementation pattern
  → Aynı CRUD method isimleri

Service eklerken:
  → starter'daki auth_service örneğine bak
  → Aynı error handling pattern

ViewModel/Controller eklerken:
  → starter'daki auth_viewmodel örneğine bak
  → Aynı state management pattern

Screen/Page eklerken:
  → starter'daki login_screen örneğine bak
  → Aynı widget'ları kullan (AppButton, AppTextField)
  → Aynı theme renklerini kullan
```

### ADIM 5: Test Ekle
```
- starter'daki test dosyalarına bak
- Her yeni model için unit test yaz
- Her yeni service için unit test yaz
- Her yeni endpoint için integration test yaz
```

### ADIM 6: Production Checklist
```
- PRODUCTION-CHECKLIST.md'yi çalıştır
- Tüm maddeler ✅ mi?
- Değilse çöz
```

---

## 📂 Starter Klasör Yapısı (Her Template İçin)

```
template-name/
├── 01-Planning.md           ← Rehber (ne yapılacak)
├── 02-Architecture.md       ← Rehber (nasıl yapılacak)
├── 03-StepByStep.md         ← Rehber (adımlar)
├── 04-FilesStructure.md     ← Rehber (dosya açıklamaları)
├── 05-DebugTips.md          ← Rehber (hatalar)
├── 06-Resources.md          ← Rehber (linkler)
└── starter/                 ← GERÇEK KOD ✨
    ├── [config dosyaları]   ← pubspec.yaml, package.json, vb.
    ├── .env.example         ← Environment değişkenleri
    ├── .gitignore           ← Git ignore kuralları
    ├── src/ veya lib/       ← Kaynak kodlar
    │   ├── core/            ← Sabitler, theme, utils
    │   ├── data/            ← Model, repository, service
    │   └── presentation/    ← UI/Controller katmanı
    └── test/                ← Test dosyaları
```

---

## ⚠️ Kritik Kurallar

```
1. Starter code'u SİLME → üzerine ekle
2. Mevcut dosyaları DEĞİŞTİR, yeniden YAZMA
3. Pattern'i TAKİP ET → starter'daki naming, structure, import style
4. Theme renklerini KULLAN → app_theme.dart / theme.css
5. Reusable widget'ları KULLAN → AppButton, AppTextField, LoadingWidget
6. .env.example'ı GÜNCELLE → yeni key eklediğinde
7. Her yeni dosyayı FILE-TRACKER.md'ye KAYDET
```
