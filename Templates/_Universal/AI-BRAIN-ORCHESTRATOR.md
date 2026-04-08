# AI-BRAIN-ORCHESTRATOR.md - Otonom Karar ve Hafiza Motoru

Bu dosyanin amaci, kullanici ayni seyleri tekrar tekrar chat'e yazmadan AI'nin kendi kendine dogru karar alip A'dan Z'ye teslim etmesini saglamaktir.

Kapsam:
- Mimari secimi (monolith mi microservice mi)
- Teknoloji secimi (backend, frontend, DB, cache, queue)
- Risk analizi ve cozum planlari
- Chat talimatlarini otomatik hafizaya yazma
- Anlamadigi yerde sadece kritik soru sorma

---

## 1) Tek Giris Kurali

Kullanici sadece sunu verir:
1. Urun fikri
2. Istedigi ozellikler
3. Varsa zorunlu teknoloji kisitlari

AI bundan sonrasini otonom yonetir.

Okuma ve cakisma disiplini:
- `UNIVERSAL-READING-ORDER.md` dosyasina gore hareket edilir.
- Hangi rehberin okunacagi bu dosya ile secilir.

---

## 2) Otonom Isletim Dongusu (Ajan Beyni)

Her gorevde bu dongu zorunludur:

1. INPUT PARSE
- Is hedefi
- Fonksiyonel gereksinimler
- Fonksiyonel olmayan gereksinimler (guvenlik, performans, maliyet)

1.2 DISCOVERY QUESTIONS
- `PROJECT-DISCOVERY-QUESTION-GUIDE.md` soru bloklari uygulanir
- Cevaplara gore kosullu rehberler secilir

1.5 SIZE SYNC
- `PROJECT-SIZE-ENGINE.md` ile kapsam seviyesi belirle (S/M/L/XL)
- Kullanici secim yapmazsa `M` varsay
- Secimi `AI_DECISION_LOG.md` dosyasina yaz

2. MEMORY SYNC
- `AI_CHAT_LEDGER.md` oku
- `AI_DECISION_LOG.md` oku
- `AI_FEATURE_LEDGER.md` oku
- `AI_ERROR_LEDGER.md` oku
- `AI_DEVELOPMENT_LOG.md` oku
- Uzun oturumsa `CONTEXT-MEMORY-RAG-POLICY.md` kurallarina gore secici ozet cikar

3. DECISION ENGINE
- Mimari secimi
- Teknoloji secimi
- Veri modeli ve entegrasyon secimi

4. EXECUTION PLAN
- V1 (minimum calisan surum)
- Iteratif feature plani
- Test plani
- CI/CD plani

5. BUILD + VERIFY
- Kod, test, lint, build, guvenlik kontrolleri

5.5 ROOT-SAFE CHECK
- Kod olusumu `Templates/` altina sizdi mi kontrol et
- Kod sadece root altindaki uygulama klasorunde mi dogrula

6. WRITEBACK
- Talimat ve karar kaydi
- Feature/hata kaydi
- Sonraki adim

Kural:
- Writeback yapmadan gorev "tamamlandi" denmez.
- Ozetleme yapmadan uzun oturum kapatilmaz.

---

## 3) Monolith vs Microservice Karar Motoru

AI asagidaki skora gore karar verir (1-5):
- Domain karmaşıkligi
- Ekip sayisi ve bagimsiz deployment ihtiyaci
- Trafik olcegi
- Operasyon kapasitesi (DevOps/SRE)
- Veri tutarliligi ihtiyaci

Karar:
- Toplam skor <= 11: Monolith (moduler monolith)
- Toplam skor 12-17: Moduler monolith + ayrisabilir sinirlar
- Toplam skor >= 18: Microservice

Zorunlu kural:
- Ilk asamada gereksiz microservice onermesi YASAK.
- "Once moduler monolith, sonra parcala" varsayilan yaklasimdir.

---

## 4) Teknoloji Secim Motoru

Secim eksenleri:
- Time-to-market
- Bakim maliyeti
- Performans
- Ekosistem olgunlugu
- Ekip yetkinligi
- Guvenlik uyumu

Ornek varsayilanlar (kisit yoksa):
- Fullstack web hizli teslim: Next.js + PostgreSQL + Prisma
- Kurumsal backend: .NET/Java + PostgreSQL + Redis
- AI/ML agirlikli: Python + FastAPI + worker queue
- Mobil odakli: Flutter veya native stack

Kural:
- Secim nedeni `AI_DECISION_LOG.md` dosyasina yazilmadan implementasyona gecme.
- Secim, kapsam seviyesi (S/M/L/XL) ile uyumlu olmak zorundadir.

---

## 5) API First + Code First + Mobile First

1. API First:
- Endpoint kontratlari, DTO, hata modeli once yazilir.

2. Code First:
- Entity/model koddan uretilir.
- Migration zorunlu, elle SQL kacagi YASAK.

3. Mobile First:
- UI once kucuk ekran kiriliminda tasarlanir.
- Masaustu sonradan genisletilir.

---

## 6) Chatten Gelen Talimati Otomatik Kayit

AI, kullanicidan gelen her net talimatta sunlari otomatik yapar:
- `AI_CHAT_LEDGER.md` icine saat + talimat ozeti + durum yazar
- Talimati bir feature ile eslerse `AI_FEATURE_LEDGER.md` linkler
- Mimari etkisi varsa `AI_DECISION_LOG.md` kaydi acar

Kural:
- Kullanici "ayni seyi tekrar" yazmak zorunda kalmaz.
- AI once ledger'i kontrol eder, sonra hareket eder.

---

## 7) Ne Zaman Soru Sorulur?

AI normalde soru sormaz.
Sadece bu 4 kritik durumda sorar:
0. Proje kapsam seviyesi (S/M/L/XL) hic belirtilmediyse bir kez sorar (cevap yoksa M varsay).
1. Zorunlu teknoloji kisiti cakisiyorsa
2. Hukuki/regulasyon riski varsa
3. Uretim ortami/secret olmadan ilerlenemiyorsa
4. Kabul kriteri olculemiyorsa

Bunlar disinda AI best practice'e gore otonom karar alir.

---

## 8) Cross-Tool Uyumluluk (Claude/Codex/OpenCode/Droid vb.)

Bu dosya model bagimsiz calisir.
Kurallar metin tabanli oldugu icin tum ajanlarda ayni sekilde uygulanir:
- Claude Code
- GitHub Copilot/Codex tabanli ajanlar
- OpenCode turevleri
- Mobil/edge coding ajanlari

Kural:
- Arac fark etmeksizin ayni ledger ve quality gate zorunludur.
- Detayli uyum matrisi icin `AGENT-CROSS-COMPATIBILITY.md` dosyasina bak.
- Hazir root dosya sablonlari icin `AGENT-FILES-STARTER-KIT.md` dosyasini kullan.

---

## 9) Kalite Kapilari (Tam Otonom Bitis Kriteri)

Tum maddeler gecmeden teslim YASAK:
- Mimari dokumanlar guncel
- Testler yesil
- Lint temiz
- Build basarili
- CI yesil
- Ledger kayitlari tamam
- Release/rollback notu hazir

---

## 10) Kullaniciya Tek Satir Baslatma Komutu

```txt
Bu projede AI-BRAIN-ORCHESTRATOR.md dosyasini ana beyin olarak uygula.
Fikrimi ve ozellikleri al, architecture/stack kararlarini kendin ver, gerekli kayitlari ledger dosyalarina otomatik yaz, sadece kritik belirsizlikte soru sor, CI yesil olmadan is bitirme.
```

Tam paket baslatma ve governance dosyalari:
- `ONE-COMMAND-AUTONOMY-PROMPT.md`
- `GITHUB-BRANCH-PROTECTION.md`
- `TEMPLATE-ISSUE.md`
- `TEMPLATE-PR.md`
- `TEMPLATE-RELEASE.md`
