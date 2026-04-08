# TEMPLATE-PR.md - Standart Pull Request Sablonu

Bu sablonu PR aciklamasinda kullan.

---

## PR Basligi

`[scope] Kisa degisiklik ozet basligi`

Ornek:
- `[checkout] add coupon validation flow`
- `[auth] fix refresh token null handling`

---

## 1) Ozet

Bu PR neyi degistiriyor?

- Is problemi:
- Teknik cozum:
- Kapsam:

---

## 2) Ilgili Issue

- Closes #
- Related #

---

## 3) Degisiklik Tipi

- [ ] feature
- [ ] fix
- [ ] refactor
- [ ] docs
- [ ] test
- [ ] ci/infra

---

## 4) Teknik Ayrinti

- Mimari etkisi:
- API etkisi:
- DB/migration etkisi:
- Performans etkisi:
- Guvenlik etkisi:

---

## 5) Test Kaniti

Calistirilan komutlar:
- `lint`:
- `test`:
- `build`:

Sonuc:
- [ ] Lint pass
- [ ] Test pass
- [ ] Build pass

Opsiyonel kanitlar:
- Ekran goruntusu / log / rapor

---

## 6) Risk ve Rollback

Riskler:
- 

Rollback plani:
- Geri alinacak commit/tag:
- Geri alma adimlari:

---

## 7) Branch ve Merge Kurali

- Kaynak branch: `feature/*` veya `fix/*`
- Hedef branch: `develop` (release disinda)
- [ ] Direct merge yok
- [ ] CI yesil olmadan merge yok

---

## 8) Ledger Dogrulamasi

- [ ] AI_CHAT_LEDGER.md guncel
- [ ] AI_DECISION_LOG.md guncel
- [ ] AI_FEATURE_LEDGER.md veya AI_ERROR_LEDGER.md guncel
- [ ] AI_DEVELOPMENT_LOG.md guncel
