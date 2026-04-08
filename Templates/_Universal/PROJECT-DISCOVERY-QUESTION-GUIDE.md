# PROJECT-DISCOVERY-QUESTION-GUIDE.md - Detayli Proje Soru Rehberi

Bu dosya, kullanicidan fikri aldiktan sonra AI'nin hangi sorulari hangi sirayla soracagini belirler.
Hedef: eksik bilgi kalmadan en dogru mimari/teknoloji secimini yapmak.

---

## 1) Kullanim Kurali

AI su akisi izler:
1. Kullanici fikrini detayli anlatir.
2. AI asagidaki soru bloklarini sirayla sorar.
3. Kullanici "sana birakiyorum" dedigi yerde AI best practice secer.
4. Secilen tum kararlar `AI_DECISION_LOG.md` ve `AI_CHAT_LEDGER.md` dosyalarina yazilir.

Kural:
- Kritik bilgi netlesmeden mimariyi kilitleme.
- Kritik bilgi yoksa gereksiz soru sorma.

---

## 2) Blok A - Urun ve Hedef Netlestirme

Zorunlu sorular:
1. Bu proje hangi problemi cozecek?
2. Hedef kullanici kim? (B2C, B2B, ic ekip)
3. Ilk surumde mutlaka olmasi gereken 3-7 ozellik neler?
4. Basari olcutu nedir? (kullanici, satis, performans, sure)

---

## 3) Blok B - Platform Secimi (Web/Mobil/Her ikisi)

Zorunlu sorular:
1. Platform: Web mi, mobil mi, her ikisi mi?
2. Mobilse: iOS, Android, cross-platform mi?
3. Webse: sadece frontend mi, fullstack mi?
4. Bu secimde net tercihin var mi, yoksa best practice secimini AI'ya mi birakiyorsun?

Kural:
- Kullanici "AI secsin" derse secim gerekcesi loglanir.

---

## 4) Blok C - Kapsam ve Buyukluk Seviyesi

Zorunlu soru:
1. Proje buyuklugu S/M/L/XL hangisi?

Opsiyon:
- Cevap yoksa `PROJECT-SIZE-ENGINE.md` ile otomatik sec ve `M` varsayimini acikca kaydet.

---

## 5) Blok D - Mimari Tercih ve Operasyon Seviyesi

Zorunlu sorular:
1. Monolith, moduler monolith, microservice tercihin var mi?
2. Yoksa AI'nin trafik/ekip/operasyon skoruna gore secmesine izin veriyor musun?
3. Projede DevOps olgunluk hedefi nedir? (basic, standard, advanced)

---

## 6) Blok E - Veri ve Is Kurallari

Zorunlu sorular:
1. Ana varliklar (entity) neler? (or: User, Product, Order)
2. Iliskiler neler? (1-N, N-N)
3. Veri saklama tercihi var mi? (PostgreSQL, MySQL, MongoDB, Firebase)
4. Verinin yasal/saklama kisiti var mi?

---

## 7) Blok F - Auth, Odeme, Entegrasyon

Duruma gore sor:
1. Auth gerekli mi? (email/sifre, sosyal login, SSO)
2. Rol/izin modeli var mi? (admin, staff, user)
3. Odeme var mi? (Stripe, Iyzico, PayTR vb.)
4. Dis servis entegrasyonlari neler? (ERP, kargo, CRM, webhook)

---

## 8) Blok G - UI/UX ve Lokalizasyon

Zorunlu sorular:
1. UI onceligi: mobile-first, desktop-first, esit mi?
2. Tasarim dili var mi? (minimal, corporate, premium)
3. Coklu dil gerekli mi?
4. Gerekliyse hedef diller neler?

Kural:
- Coklu dil "evet" ise `Domain-Product/LOCALIZATION-LANGUAGES.md` zorunlu okunur.
- Coklu dil "hayir" ise localization rehberi skip edilir.

---

## 9) Blok H - Kalite, Test ve CI/CD

Zorunlu sorular:
1. Test seviyesi beklentisi nedir? (minimum, standard, strict)
2. CI gate zorunlu mu? (lint + test + build)
3. Branch modeli: main/develop/feature standardi uygulanacak mi?
4. Release ve rollback disiplini gerekli mi?

---

## 10) Blok I - Teslimat ve Zamanlama

Zorunlu sorular:
1. Oncelik: hiz mi kalite mi?
2. MVP teslim suresi nedir?
3. Yayina alma hedefi var mi? (staging, production)
4. Sonraki faz backlog mantigi istenecek mi?

---

## 11) Karar Kilitleme (Decision Lock)

Soru fazi bitince AI su ozeti cikarir:
1. Platform karari
2. Kapsam seviyesi
3. Mimari karari
4. Stack karari
5. Test/CI seviyesi
6. Lokalizasyon durumu
7. Bilincli olarak AI'ya birakilan noktalar

Bu ozet onaylanmadan implementasyona gecilmez.

---

## 12) Kisa Soru Modu

Kullanici hizli mod isterse sadece su 6 soru sorulur:
1. Platform (web/mobil/her ikisi)
2. Buyukluk (S/M/L/XL)
3. Zorunlu teknoloji kisiti
4. Auth/odeme gerekli mi
5. Coklu dil gerekli mi
6. Hiz mi kalite mi

Eksik kalanlar AI tarafindan best practice ile tamamlanir ve loglanir.
