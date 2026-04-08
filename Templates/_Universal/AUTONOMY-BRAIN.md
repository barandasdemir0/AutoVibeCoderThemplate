# AUTONOMY-BRAIN.md — Otonom AI Beyni (Context Engineering + Kalıcı Hafıza)

> Amaç: AI'nin aynı şeyleri tekrar sormasını engellemek, kararları kayıt altına almak,
> hataları ve özellik geliştirmeyi denetlenebilir hale getirmek.

---

## 1) Çekirdek Prensip: Prompt Engineering Değil Context Engineering

AI her görevde sıfırdan düşünmez; önce proje hafızasını okur, sonra karar verir.

Zorunlu okuma sırası:
1. `AI_CHAT_LEDGER.md` (kullanıcıdan gelen son talimatlar)
2. `AI_DECISION_LOG.md` (alınan teknik kararlar ve gerekçeleri)
3. `AI_ERROR_LEDGER.md` (açık/çözülen hatalar)
4. `AI_FEATURE_LEDGER.md` (eklenen feature geçmişi)
5. `AI_DEVELOPMENT_LOG.md` (zaman çizelgesi ve bir sonraki adım)

Kural:
- Bu dosyalar okunmadan kod yazma.
- Bu dosyalar güncellenmeden görev kapatma.

---

## 2) Zorunlu Hafıza Dosyaları (Proje Kökü)

AI proje başında bu dosyaları yoksa oluşturur:
- `AI_DEVELOPMENT_LOG.md`
- `AI_ERROR_LEDGER.md`
- `AI_FEATURE_LEDGER.md`
- `AI_CHAT_LEDGER.md`
- `AI_DECISION_LOG.md`

---

## 3) Hata Hafızası Protokolü

Her hata için tekil bir kayıt aç:

| Alan | Zorunlu İçerik |
|------|-----------------|
| Saat | `YYYY-MM-DD HH:mm` |
| Hata ID | `ERR-0001` formatı |
| Bağlam | Hangi görev/feature sırasında |
| Belirti | Hata mesajı + stack trace özeti |
| Kök Neden | Teknik asıl sebep |
| Çözüm | Uygulanan fix adımları |
| Doğrulama | Build/test çıktısı özeti |
| Durum | Open, Fixed, Verified |

Ek kural:
- Hata çözülünce "neden oldu" ve "neden bu çözüm" ayrı yazılır.
- Aynı hatayı ikinci kez almak yasak: önce ledger'da ara, sonra müdahale et.

---

## 4) Feature Hafızası Protokolü

Her yeni özellikte zorunlu kayıt:

| Alan | Zorunlu İçerik |
|------|-----------------|
| Saat | `YYYY-MM-DD HH:mm` |
| Feature ID | `FEAT-0001` |
| İhtiyaç | Kullanıcı hangi ihtiyacı söyledi |
| Mimari Karar | Neden bu pattern/katman seçildi |
| Basit Dilim (V1) | İlk küçük çalışan sürüm |
| Genişletme | Sonraki adımda ne eklendi |
| Dosyalar | Eklenen/değişen dosyalar |
| Neden | Her dosya için kısa gerekçe |
| Doğrulama | Test/build/manuel doğrulama |

Kural:
- Önce mimari, sonra minimum çalışan kod (V1), sonra iteratif genişletme.
- Tek seferde devasa kod yazma; adım adım ilerle.

---

## 5) Chat Talimat Hafızası Protokolü

Kullanıcıyla konuşma geçmişi sadece diyalog değil, komut geçmişidir.

`AI_CHAT_LEDGER.md` içine yazılacaklar:
- Saat
- Kullanıcı talimat özeti
- Talimat tipi: yeni özellik, hata düzeltme, refactor, infra, deploy
- AI yorumu (anlaşılan görev)
- Durum: pending, in-progress, completed
- Karşılık gelen Feature/Hata ID

Kural:
- "yes/evet" gibi zayıf onay yerine, kullanıcının net niyeti metinsel olarak loglanır.
- Son talimat ile yeni görev çelişiyorsa AI önce çelişki notu düşer, sonra en güncel talimatı uygular.

---

## 6) CI/CD + Git + GitHub Zorunlu Akış

Bu bölüm, `AI-EXECUTION-POLICY.md` ile birlikte uygulanır.

Her proje bu minimum akışı içerir:
1. Branch stratejisi: `main`, `develop`, `feature/*`, `fix/*`
2. Commit standardı: Conventional Commits (`feat:`, `fix:`, `refactor:`, `docs:`)
3. Pull Request şablonu: Amaç, değişiklik listesi, test kanıtı, riskler
4. CI zorunluluğu:
   - Lint
   - Unit test
   - Build
5. CD zorunluluğu:
   - Staging deploy
   - Main sonrası production deploy (onay kapısı ile)
6. Release notları: `CHANGELOG.md` güncellemesi

Kural:
- CI kırıkken feature "tamamlandı" sayılamaz.
- Test kanıtı olmayan commit merge edilmez.
- AI doğrudan `main` veya `develop` branch'ine commit atamaz.
- Her iş bir issue'dan açılan branch ile başlar, PR ile `develop`'a birleşir.
- `main` birleşimi yalnız release/production kapısından geçerek yapılır.

---

## 7) Unutma Önleme Kuralları

- Her görev başlangıcında "Son Bilinen Durum" bloğu yaz.
- Her görev bitişinde "Bir Sonraki Adım" bloğu yaz.
- Kullanıcı daha önce cevapladıysa aynı soruyu tekrar sorma; ledger'dan çek.
- Karar değiştirildiyse eski kararı silme, üstünü "superseded" olarak işaretle.

---

## 8) Hazır Şablonlar

### AI_ERROR_LEDGER.md Şablonu

```md
# AI Error Ledger

## ERR-0001
- Saat: 2026-04-08 10:15
- Durum: Fixed
- Bağlam: Login endpoint geliştirme
- Belirti: 500 Internal Server Error, NullReferenceException
- Kök Neden: DI container'a service kaydı eklenmemiş
- Çözüm: Program.cs içine AddScoped<IJwtService, JwtService>() eklendi
- Doğrulama: dotnet test geçti, login 200 dönüyor
- Not: Benzer hatalarda önce DI kayıtları kontrol edilecek
```

### AI_FEATURE_LEDGER.md Şablonu

```md
# AI Feature Ledger

## FEAT-0001 - Kullanıcı Girişi
- Saat: 2026-04-08 10:45
- İhtiyaç: Email/şifre ile güvenli login
- Mimari Karar: Controller + Service + Repository ayrımı
- Basit Dilim (V1): Sadece login endpoint + token dönüşü
- Genişletme: Refresh token ve remember me eklendi
- Dosyalar:
  - src/api/controllers/AuthController.cs: endpoint
  - src/application/services/AuthService.cs: iş mantığı
  - src/infrastructure/auth/JwtService.cs: token üretimi
- Neden:
  - AuthController.cs: HTTP giriş noktası
  - AuthService.cs: business logic izolasyonu
  - JwtService.cs: güvenlik ve tekrar kullanılabilirlik
- Doğrulama: unit + integration test geçti
```

### AI_CHAT_LEDGER.md Şablonu

```md
# AI Chat Ledger

| Saat | Talimat Özeti | Tip | AI Yorumu | Durum | Link |
|------|----------------|-----|-----------|-------|------|
| 2026-04-08 11:00 | Otonomi kurallarını güçlendir | infra/process | Yeni ledger kuralları eklenecek | completed | FEAT-0002 |
```

### AI_DEVELOPMENT_LOG.md Şablonu

```md
# AI Development Log

## 2026-04-08 11:15
- Yapılanlar: Otonom hafıza dosyaları oluşturuldu
- Etki: Hata/özellik takibi standardize edildi
- Sonraki Adım: CI pipeline şablonunu ekle ve doğrula
```

---

## 9) Tam Otonom Çalışma Cümlesi

AI aşağıdaki cümleyi içselleştirir:

"Önce hafızayı oku, sonra mimariyi kur, sonra küçük çalışan dilimi çıkar, sonra genişlet, her adımı saatli olarak kaydet, CI/test geçmeden işi tamamlanmış sayma."
