# 🚀 AUTONOMOUS-WORKFLOW.md — Tek Dosyayla Otonom Proje Üretimi

> Bu dosya, VibeCoding framework ile A'dan Z'ye otonom proje üretme akışını tanımlar.
> Kullanıcı sadece bir fikir yazar, AI geri kalan her şeyi yapar.

---

## 🎯 Hedef

```
KULLANICI GİRDİSİ:
  1. Template seçimi (ör: Mobile/Flutter-Firebase)
  2. Proje fikri (2-3 cümle)

AI ÇIKTISI:
  ✅ Çalışan proje kodu
  ✅ Test suite
  ✅ Dokümantasyon (README, .env.example)
  ✅ Deploy dosyaları
  ✅ Production checklist geçmiş
```

---

## 📋 TAM OTONOM AKIŞ (AI İçin)

### FAZE 1: ZORUNLU HAFIZA KONTROLÜ VE HAZIRLIK (0-5 dakika)

```
1. QUICK-START.md oku (seçilen template)
   → Tech stack, mimari, kurallar, dosya sırası

2. ZORUNLU HAFIZA PROTOKOLÜ (MEMORY LEDGER):
   → Projenin kök dizininde `AI_DEVELOPMENT_LOG.md` (veya FILE-TRACKER.md) var mı bak.
   → Varsa: En son nerede kalındığını, hangi hataların çözüldüğünü OKU. (Amnesia Engelleyici)
   → Yoksa: Dosyayı YARAT ve "Proje Başlangıcı" olarak ilk kaydını düş.

3. Proje fikrini analiz et:
   → Ana entity'ler neler? (User, Product, Order...)
   → Auth gerekli mi?
   → Özel feature var mı? (ödeme, harita, kamera, AI...)

4. Dosya listesi çıkar (BUILD ORDER):
   → QUICK-START'taki sıraya göre tüm dosyaları listele
   → Entity-specific dosyaları ekle
```

### FAZE 2: ALTYAPI (5-15 dakika)

```
4. Config dosyaları oluştur:
   → package.json / pubspec.yaml / .csproj
   → .env.example
   → .gitignore

5. Core/Config katmanı:
   → Theme / design tokens
   → Constants
   → Utils / helpers

6. Data katmanı:
   → Models (entity tanımları)
   → Services (API client)
   → Repositories (data access)

7. CHECKPOINT: Derleniyor mu?
   → Build/compile çalıştır
   → Hata varsa düzelt
   → Devam et
```

### FAZE 3: İŞ MANTIĞI (15-30 dakika)

```
8. Auth:
   → Login / Register / Logout
   → Token yönetimi
   → Route koruma

9. CRUD:
   → Her entity için Create, Read, Update, Delete
   → Validation
   → Error handling

10. CHECKPOINT: API/Service çalışıyor mu?
    → Endpoint'leri test et
    → Auth akışını test et
    → Hata varsa düzelt
```

### FAZE 4: UI/FRONTEND (30-45 dakika)

```
11. Layout:
    → Navigation / Routing
    → Header / Sidebar / Footer
    → Main layout

12. Auth screens:
    → Login screen (form, validation, feedback)
    → Register screen
    → Splash / loading screen

13. Feature screens:
    → Home / Dashboard
    → Liste sayfası (loading, empty, error state)
    → Detay sayfası
    → Form sayfası (create + edit)
    → Settings / Profile

14. Reusable components:
    → Button, TextField, Card, Modal
    → Loading widget
    → Empty state widget
    → Error widget

15. CHECKPOINT: UI çalışıyor mu?
    → Tüm sayfalar arası navigation
    → Form'lar çalışıyor mu
    → Responsive mi
    → Dark mode var mı
```

### FAZE 5: TEST (45-60 dakika)

```
16. Unit testler:
    → Her model: fromJson, toJson, equality
    → Her service: success + error case
    → Her ViewModel/Controller: state transitions

17. Widget/Component testler:
    → Login screen: render, input, submit, validation
    → Home screen: loading, data, empty, error

18. Integration test:
    → Auth flow: register → login → home → logout
    → CRUD flow: create → read → update → delete

19. CHECKPOINT: Testler geçiyor mu?
    → flutter test / npm test / dotnet test / pytest
    → Coverage kontrol
```

### FAZE 6: FİNALİZASYON (60-75 dakika)

```
20. Dokümantasyon:
    → README.md (kurulum, çalıştırma, yapı)
    → .env.example (tüm key'ler)
    → API doc (Swagger / Postman / açıklama)

21. Production Checklist:
    → Güvenlik: .env, CORS, validation, auth
    → Performans: caching, pagination, optimization
    → UX: loading, error, empty, responsive, dark mode
    → Kod: naming, SoC, no god class, no debug logs
    → Test: coverage %60+

22. validate-project.ps1 çalıştır

23. Son düzeltmeler

24. ✅ PROJE TAMAMLANDI
```

---

## ⏱️ TAHMİNİ SÜRE

| Proje Tipi | Agentic AI | Web AI (Manuel) |
|-----------|:----------:|:---------------:|
| Basit CRUD (blog, todo) | 30-45 dk | 3-5 saat |
| Orta (e-ticaret, social) | 60-90 dk | 8-12 saat |
| Karmaşık (FullStack + ML) | 2-4 saat | 1-3 gün |
| Mobile + Store yayınlama | 2-3 saat + manuel | 1-2 gün + manuel |

---

## 🔄 HATA KURTARMA PROTOKOLÜ

```
HATA OLUNCA:
  1. Hata mesajını oku (stack trace dahil)
  2. QUICK-START'taki "SIK HATALAR → ÇÖZÜM" tablosuna bak
  3. Çözüm bulunamazsa → ERROR-PATTERNS.md'ye bak
  4. Düzelt → build/test tekrar çalıştır
  5. Geçiyor mu?
     EVET → devam et
     HAYIR → farklı yaklaşım dene (max 3 deneme)
     HALA HAYIR → Kullanıcıya bildir + alternatif öner
```

---

## 📝 AI'A GÖNDERİLECEK TEK MESAJ ŞABLONU

Aşağıdaki tek mesajı AI'a gönderin (QUICK-START.md ile birlikte):

```
[QUICK-START.md içeriği yapıştır]

---

## Projem

**Fikir:** [2-3 cümle proje açıklaması]

**Ek İstekler (opsiyonel):**
- [varsa özel istekler: ödeme, harita, belirli API, vs.]

---

Yukarıdaki QUICK-START kurallarına göre bu projeyi A'dan Z'ye oluştur.
Hiçbir şey sorma, en best practice yaklaşımla tamamla.
Her adımda build et + hataları düzelt.

DİKKAT (ZORUNLU KURAL): Kodlamaya başlamadan ÖNCE projenin kök dizinindeki `AI_DEVELOPMENT_LOG.md` dosyasını oku. Eğer yoksa Yarat. 
Her 1 saatin sonunda VEYA bir hatayı çözdükten hemen sonra O dosyaya; Saati, yapılanı ve çözülen hatayı KAYDET! Aksi halde kod yazma!

Bitince PRODUCTION CHECKLIST'i çalıştır.
```

---

## ✅ BAŞARI KRİTERLERİ

Proje "tamamlandı" sayılması için:

```
1. ✅ Build hatasız (compile/bundle)
2. ✅ Run hatasız (runtime error yok)
3. ✅ Auth çalışıyor (register → login → protected → logout)
4. ✅ CRUD çalışıyor (create → read → update → delete)
5. ✅ UI: Loading + Error + Empty state
6. ✅ UI: Responsive (mobile + tablet + desktop)
7. ✅ UI: Dark mode
8. ✅ Test: coverage %60+
9. ✅ Güvenlik: .env secrets, no hardcoded, CORS
10. ✅ Dokümantasyon: README.md, .env.example
11. ✅ validate-project.ps1 → %80+ başarı
```
