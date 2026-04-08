# GITHUB-BRANCH-PROTECTION.md - Main/Develop Koruma Rehberi

Bu rehber, AI dahil tum gelistirme akisinda merge kalitesini garanti etmek icin
GitHub branch koruma ayarlarini adim adim uygular.

---

## 1) Hedef Mimari

Korunacak branch'ler:
- `main` (production)
- `develop` (integration)

Calisma branch'leri:
- `feature/<issue-id>-<kisa-ad>`
- `fix/<issue-id>-<kisa-ad>`
- `hotfix/<issue-id>-<kisa-ad>`
- `release/vX.Y.Z`

Kural:
- Dogrudan `main` ve `develop` push YASAK.
- Sadece PR ile merge.

---

## 2) Required Status Checks

En az su kontroller required olmali:
- `lint`
- `test`
- `build`

Opsiyonel ama onerilen:
- `security-scan`
- `e2e`

Kural:
- Required check fail ise merge YASAK.

---

## 3) Main Branch Protection Ayari

GitHub UI yolu:
- Repo -> Settings -> Branches -> Add branch protection rule

Rule pattern:
- `main`

Aktif et:
- Require a pull request before merging
- Require approvals: en az 1
- Dismiss stale pull request approvals when new commits are pushed
- Require status checks to pass before merging
- Require conversation resolution before merging
- Require linear history
- Do not allow bypassing the above settings
- Restrict who can push (mumkunse sadece release maintainers)

---

## 4) Develop Branch Protection Ayari

Rule pattern:
- `develop`

Aktif et:
- Require a pull request before merging
- Require approvals: en az 1
- Require status checks to pass before merging (`lint`, `test`, `build`)
- Require conversation resolution before merging
- Allow auto-merge (opsiyonel)
- Restrict direct push

---

## 5) Merge Policy

Onerilen merge tipi:
- Squash merge: `develop` icin acik
- Merge commit: release PR'lerinde acik
- Rebase merge: ekip standardina gore opsiyonel

Kural:
- Commit mesajlari Conventional Commits standardini bozmayacak.

---

## 6) Tag ve Release Politikasi

Main'e merge sonrasi:
1. Semantic version tag ac: `vX.Y.Z`
2. Release notes olustur
3. `CHANGELOG.md` guncelle
4. Rollback referansini not et (onceki stabil tag)

---

## 7) AI Ajanlari Icin Zorunlu Politika

AI su kurallara tabi:
- `main` ve `develop` branch'lerine dogrudan commit yok
- Her gorev issue tabanli branch'te calisir
- PR acmadan ilerleme "done" sayilmaz
- CI yesil olmadan merge yapilmaz

---

## 8) Kontrol Listesi

- [ ] `main` protection aktif
- [ ] `develop` protection aktif
- [ ] Required checks aktif
- [ ] PR approvals en az 1
- [ ] Direct push kapali
- [ ] Semantic version + release notlari akisi aktif
- [ ] AI kurallari dokumante edildi

---

## 9) Hızlı Uygulama Komutu (AI'ya)

```txt
GITHUB-BRANCH-PROTECTION.md dosyasina gore bu repo icin main ve develop branch koruma modelini uygulama adimlarini hazirla.
PR zorunlulugu, required checks, semantic version release ve rollback politikasini dogrula.
CI yesil degilse merge akisini reddet.
```
