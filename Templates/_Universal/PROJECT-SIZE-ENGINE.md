# PROJECT-SIZE-ENGINE.md - Proje Buyuklugu Secim Motoru (md-only)

Bu dosya, eski script tabanli hizli secimi md-only yapida geri kazandirir.
Amac: kullanicidan minimum soru ile proje kapsam seviyesini secmek ve AI'nin
mimari/teslimat stratejisini otomatik ayarlamak.

---

## 1) Neden Gerekli?

Ayni fikir, farkli kapsamda cok farkli cikar:
- "Basit e-ticaret" ile "enterprise marketplace" ayni sey degildir.
- Yanlis kapsam secimi, gereksiz over-engineering veya yetersiz mimari uretir.

Bu motor, kapsam secimini baslangicta netlestirir.

---

## 2) Zorunlu Kapsam Seviyeleri

Kullaniciya tek zorunlu secim sorusu:
- S (Starter)
- M (Standard)
- L (Advanced)
- XL (Enterprise)

Secim yapilmazsa varsayilan: `M (Standard)`

---

## 3) Seviye Bazli Uretim Politikasi

### S - Starter
- Hedef: hizli MVP
- Mimari: moduler monolith
- Infra: minimum (local + basic CI)
- Test: kritik path unit test
- Dokumantasyon: temel

### M - Standard
- Hedef: production'a yakin ilk surum
- Mimari: moduler monolith + net sinirlar
- Infra: CI zorunlu + staging
- Test: unit + integration
- Dokumantasyon: issue/pr/release tam

### L - Advanced
- Hedef: buyuyen urun
- Mimari: moduler monolith veya secili servis ayirma
- Infra: CI/CD, gozlemlenebilirlik, rollback
- Test: unit + integration + secili e2e
- Guvenlik: secret policy + dependency scan

### XL - Enterprise
- Hedef: ekipli, yuksek guvenlik, denetlenebilir sistem
- Mimari: domain bazli servislesme adayi, net bounded context
- Infra: quality gates + release governance + incident readiness
- Test: katmanli test matrisi + release smoke
- Surec: zorunlu karar kaydi, risk matrisi, rollback drill

---

## 4) AI Soru Politikasi (Kisa Mod)

AI, baslangicta sadece su iki soruyu sorabilir:
1. Proje buyuklugu seviyesi nedir? (S/M/L/XL)
2. Zorunlu teknoloji kisitin var mi? (Yoksa best practice sec)

Bunlar disinda kritik belirsizlik yoksa AI soru sormadan ilerler.

---

## 5) Mimari Etki Matrisi

Seviye arttikca otomatik artanlar:
- Loglama detayi
- Test kapsami
- CI kapilari
- Release disiplini
- Guvenlik kontrolleri

Seviye dusukse sade kal:
- YAGNI ihlali yok
- Gereksiz microservice yok
- Gereksiz cloud karmasikligi yok

---

## 6) Ledger Entegrasyonu

AI her gorevde su kaydi zorunlu yazar:
- `AI_DECISION_LOG.md` -> secilen seviye ve nedeni
- `AI_CHAT_LEDGER.md` -> kullanici kapsam tercihi
- `AI_DEVELOPMENT_LOG.md` -> seviyeye gore uygulanan plan

---

## 7) Hızlı Baslatma Mesaji

```txt
Bu proje icin once PROJECT-SIZE-ENGINE.md dosyasina gore kapsam seviyesi sec.
Kullanici secim yapmazsa M (Standard) varsay.
Secilen seviyeyi AI_DECISION_LOG.md dosyasina yaz ve tum plani bu seviyeye gore olcekle.
```
