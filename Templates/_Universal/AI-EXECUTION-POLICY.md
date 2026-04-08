# AI-EXECUTION-POLICY.md - Tam Otonom Teslimat Politikasi

Bu dosya, yapay zekanin projeyi yarim birakmadan ve best practice disina cikmadan A'dan Z'ye teslim etmesi icin zorunlu operasyon politikasidir.

---

## 1) Zorunlu Oncelik Sirasi (FIRST prensibi)

Her projede bu sira sabittir:

1. CI/CD First
2. Backend API First
3. DB Code First
4. Proje AI First
5. UI Mobile First

Kural:
- Sirayi bozma.
- Bir adim tanimlanmadan sonraki adim "tamamlandi" sayilamaz.

---

## 2) CI/CD First - Baslamadan Once Kur

Kod yazmadan once asgari CI iskeleti kurulur.

Zorunlu kontroller:
- Lint
- Unit test
- Build
- Guvenlik taramasi (en az dependency scan)

Merge kapisi:
- CI kirmiziysa merge YASAK.
- Test kaniti olmayan PR YASAK.

---

## 3) Git Akisi - Branch Governance (AI dahil)

Zorunlu branch modeli:
- `main`: Production
- `develop`: Entegre gelistirme
- `feature/<issue-id>-<kisa-ad>`: Yeni ozellik
- `fix/<issue-id>-<kisa-ad>`: Hata duzeltme
- `hotfix/<issue-id>-<kisa-ad>`: Acil production fix
- `release/vX.Y.Z`: Release hazirlik

AI kurali:
- AI dogrudan `main` veya `develop` branch'ine commit atamaz.
- AI sadece issue'dan uretilmis kendi `feature/*` veya `fix/*` branch'inde calisir.

PR kurali:
- Her branch bir PR ile `develop`'a birlesir.
- `develop` -> `main` gecisi release PR ile olur.

---

## 4) Issue -> Branch -> PR -> CI -> Merge -> Deploy Akisi

1. Issue acilir (hedef, kapsam, kabul kriteri).
2. Issue'dan branch acilir.
3. AI kodu yazar, testleri yazar/gunceller.
4. Conventional commit ile commitler atilir.
5. PR acilir, CI calisir.
6. Tum kontroller yesilse `develop` merge edilir.
7. Staging deploy ve smoke test gecilir.
8. Release PR ile `main` merge edilir.
9. Version tag basilir ve production deploy edilir.

---

## 5) Conventional Commit Zorunlulugu

Commit basliklari asagidaki tiplerden biriyle baslar:
- `feat:`
- `fix:`
- `refactor:`
- `perf:`
- `test:`
- `docs:`
- `build:`
- `ci:`
- `chore:`
- `revert:`

Ornek:
- `feat(auth): add refresh token rotation`
- `fix(api): handle null user profile`
- `ci(workflow): block merge on failing tests`

---

## 6) Semantic Versioning ve Release Politikasi

SemVer:
- MAJOR (`X.0.0`): Breaking change
- MINOR (`0.X.0`): Geriye uyumlu yeni ozellik
- PATCH (`0.0.X`): Geriye uyumlu bug fix

Release zorunlulugu:
- Her `main` release'inde tag bas (`vX.Y.Z`).
- `CHANGELOG.md` guncelle.
- Release notuna migration ve rollback notu ekle.

Rollback politikasi:
- Sorunlu release'te bir onceki stabil tag'e don.
- Rollback nedeni `AI_ERROR_LEDGER.md` ve release notlarina yazilir.

---

## 7) API First - Backend Kontrati Onceliklidir

UI'dan once API kontrati netlesir:
- Endpoint listesi
- Request/response DTO
- Error contract
- Auth/permission kurali

Kural:
- Swagger/OpenAPI veya esit bir kontrat ciktisi olmadan frontend tam gelisime gecme.

---

## 8) DB Code First - Shema Koddan Uretilir

Kural:
- Entity/model degisikligi migration ile versiyonlanir.
- Elle SQL degistirip migration kaydi atlamaz.

Zorunlu adimlar:
- Model/entity guncelle
- Migration uret
- Migration review et
- Test ortaminda uygula
- Geri alma adimini (down/rollback) dogrula

---

## 9) AI First - Unutmayan Isletim

AI her gorevde once bunlari okur:
- `AI_CHAT_LEDGER.md`
- `AI_FEATURE_LEDGER.md`
- `AI_ERROR_LEDGER.md`
- `AI_DECISION_LOG.md`
- `AI_DEVELOPMENT_LOG.md`

AI her gorev sonunda bunlari gunceller:
- Ne yapildi
- Neden yapildi
- Riskler
- Sonraki adim

---

## 10) Mobile First - UI Kurali

UI tasariminda once mobil ekran baz alinir:
- Kucuk ekranda kritik akislari once coz
- Sonra tablet/desktop genislet
- Responsive kirilimlari acik tanimla

Kural:
- Mobilde calismayan akisin desktop versiyonu "tamamlandi" sayilamaz.

---

## 11) Definition of Done (DoD)

Bir gorevin bitti sayilmasi icin tumu gerekli:
- Kod tamam
- Testler guncel ve yesil
- CI yesil
- PR aciklamasi tamam
- Ledger kayitlari tamam
- Gerekliyse changelog/release notu tamam

---

## 12) AI'nin Soru Sorma Politikasi

AI varsayimla ilerler, sadece kritik belirsizlikte soru sorar.

Kritik soru siniflari:
- Zorunlu teknoloji kisiti
- Hukuki/guvenlik kisiti
- Uretim ortami kisiti
- Kabul kriteri belirsizligi

Bunlar disinda AI, best practice'e gore otonom karar alip uygular.

---

## 13) Kopyala-Calistir Ust Komut

Asagidaki komut, bu politikayi dogrudan uygulatmak icin kullanilir:

```txt
Bu projede AI-EXECUTION-POLICY.md dosyasini zorunlu anayasa olarak uygula.
CI/CD-first, API-first, Code-first, AI-first, Mobile-first sirasini bozma.
Issue'dan branch ac, yalniz feature/fix branch'inde calis, PR ac, CI yesil olmadan merge etme.
Conventional commit ve semantic versioning uygula.
Tum adimlari ledger dosyalarina saatli olarak kaydet.
Kritik belirsizlik yoksa soru sorma; A'dan Z'ye otonom tamamla.
```

---

## 14) Root-Safe Uretim Politikasi (Zorunlu)

Kod uretim siniri:
- `Templates/` altina kaynak kod uretme.
- Talimat markdown dosyalarina kaynak kod gomerek ilerleme.

Kod uretim hedefi:
- Proje root altinda ayri uygulama klasoru (`src/`, `app/`, proje-adi).

Kural:
- Dokuman alani ile uygulama alani fiziksel olarak ayrik tutulur.

---

## 15) Ozetleme ve Hafiza Disiplini

Uzun gorevlerde AI su disiplini uygular:
- Tum sohbeti prompt'a geri tasimaz.
- Sadece kararlar, acik riskler, acik gorevler ve sonraki adim ozetini ledger'a yazar.
- Cakisma varsa en yeni onayli karar gecerlidir; eskisi `superseded` notuyla saklanir.

Detayli kural seti icin:
- `CONTEXT-MEMORY-RAG-POLICY.md`
