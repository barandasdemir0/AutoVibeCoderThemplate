# UNIVERSAL-READING-ORDER.md - Hangi Dosya Ne Zaman Okunur?

Bu dosya, _Universal altindaki kalabaligi duzene sokar.
AI'nin hangi dosyalari hangi sirayla okuyacagini ve cakisma halinde hangi kurala uyacagini tanimlar.

---

## 1) Oncelik Kurali (Cakisma Cozumu)

Kural onceligi yuksekten dusuge:
1. Kullanicinin acik son talimati
2. Secilen template'in QUICK-START + 01..06 dosyalari
3. `AI-BRAIN-ORCHESTRATOR.md`
4. `AI-EXECUTION-POLICY.md`
5. `AI-RULES.md`
6. Domain rehberleri (`Domain-Backend/DB-GUIDE.md`, `Domain-Product/LOCALIZATION-LANGUAGES.md`, vb.)
7. Ornek/sablon dosyalar

Not:
- Domain rehberi genel kurali, kullanicinin acik talimatini gecersiz kilmaz.

---

## 2) Zorunlu Cekirdek Okuma Sirasi (Her Projede)

AI implementasyondan once mutlaka su sirayla okur:
1. `AI-BRAIN-ORCHESTRATOR.md`
2. `PROJECT-SIZE-ENGINE.md`
3. `PROJECT-DISCOVERY-QUESTION-GUIDE.md`
4. `CONTEXT-MEMORY-RAG-POLICY.md`
5. `AI-EXECUTION-POLICY.md`
6. `AI-RULES.md`
7. `AUTONOMY-BRAIN.md`
8. `AUTONOMOUS-OPERATING-SYSTEM.md`
9. `TEMPLATE-SEQUENCE-ENGINE.md`

Sonra:
10. Secilen template QUICK-START
11. 01-Planning
12. 02-Architecture
13. 03-StepByStep
14. 04-FilesStructure
15. 05-DebugTips
16. 06-Resources

---

## 3) Kosullu Rehber Matrisi (Sadece Gerekiyorsa Oku)

| Ihtiyac | Okunacak Dosya |
|---|---|
| Veritabani/model/migration | `Domain-Backend/DB-GUIDE.md` |
| Auth ve yetki | `Domain-Backend/AUTH-JWT.md` |
| API tasarimi | `Domain-Backend/REST-API.md` |
| Gercek zamanli ozellik | `Domain-Backend/REALTIME.md` |
| Odeme | `Domain-Backend/PAYMENT.md` |
| Dosya yukleme | `Domain-Backend/FILE-UPLOAD.md` |
| Cache/perf | `Domain-Backend/CACHING.md`, `Domain-Backend/SCALABILITY.md` |
| Coklu dil i18n | `Domain-Product/LOCALIZATION-LANGUAGES.md` |
| Mobil ileri seviye | `Domain-Mobile/MOBILE-ADVANCED.md`, `Domain-Mobile/MOBILE-PUBLISH.md` |
| Test stratejisi | `Domain-Quality-Ops/TESTING.md`, `Domain-Quality-Ops/TEST-STRUCTURES.md` |
| Deployment | `Domain-Quality-Ops/DEPLOY-CICD.md`, `GITHUB-BRANCH-PROTECTION.md` |

---

## 4) Lokalizasyon Konumu (Karisiklik Cozumu)

`Domain-Product/LOCALIZATION-LANGUAGES.md` her projede zorunlu degildir.
Zorunlu olma kosulu:
- Kullanici "coklu dil" istiyorsa
- Hedef pazar birden fazla ulkeyi kapsiyorsa

Degilse:
- Dosya referans olarak kalir ama uygulama kapsamina alinmaz.

---

## 5) Uygulama Fazlari ve Dosya Seti

Faz 0 - Kesif:
- `PROJECT-DISCOVERY-QUESTION-GUIDE.md`
- `PROJECT-SIZE-ENGINE.md`

Faz 1 - Karar:
- `AI-BRAIN-ORCHESTRATOR.md`
- `STACK-COMBOS.md`
- gerekli kosullu domain dosyalari

Faz 2 - Uretim:
- template 01..06
- `CONFIG-RULES.md`

Faz 3 - Dogrulama:
- `Domain-Quality-Ops/PRODUCTION-CHECKLIST.md`
- `Domain-Quality-Ops/TESTING.md` / `Domain-Quality-Ops/TEST-STRUCTURES.md`

Faz 4 - Teslimat:
- `GITHUB-BRANCH-PROTECTION.md`
- `TEMPLATE-PR.md`
- `TEMPLATE-RELEASE.md`

---

## 6) AI'nin "Neye Gore Soru Soracagi" Kurali

1. Once `PROJECT-DISCOVERY-QUESTION-GUIDE.md` soru setini uygula.
2. Cevaplardan kosullu rehber matrisini sec.
3. Secilen rehberler disindakileri context'e yukleme.

Bu yapi, gereksiz token tuketimini ve kural karmasasini azaltir.

Ek not:
- Uzun oturumlarda ozetleme ve secici hafiza kurallari icin `CONTEXT-MEMORY-RAG-POLICY.md` dosyasini uygula.
