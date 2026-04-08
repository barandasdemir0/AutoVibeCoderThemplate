# AGENT-FILES-STARTER-KIT.md - Claude/Cursor/Windsurf/AGENTS.md Hazir Sablonlar

Bu dosya, farkli araclar icin hizli baslangic metinlerini verir.
Sablonlar kisadir; detaylar alt dosyalara yonlendirilir.

---

## 1) CLAUDE.md Minimal Sablon

```md
# CLAUDE.md

## Project Purpose
Bu proje [amac] icin gelistiriliyor.
Detaylar: @README.md

## Core Operating Rules
- Once `AI_CHAT_LEDGER.md`, `AI_DECISION_LOG.md`, `AI_ERROR_LEDGER.md`, `AI_FEATURE_LEDGER.md`, `AI_DEVELOPMENT_LOG.md` dosyalarini oku.
- CI yesil olmadan gorev "done" sayma.
- `main` ve `develop` branch'lerine dogrudan commit/push yapma.
- Sadece issue kaynakli `feature/*` veya `fix/*` branch'inde calis.
- Monolith/microservice ve stack secimini gerekcesiyle `AI_DECISION_LOG.md` dosyasina yaz.

## How To Work
- Karar motoru: @Templates/_Universal/AI-BRAIN-ORCHESTRATOR.md
- Teslimat politikasi: @Templates/_Universal/AI-EXECUTION-POLICY.md
- Otonom hafiza protokolu: @Templates/_Universal/AUTONOMY-BRAIN.md

## Verification
- Lint + test + build zorunlu.
- Sonuc ve sonraki adim `AI_DEVELOPMENT_LOG.md` dosyasina yaz.
```

---

## 2) AGENTS.md Minimal Sablon

```md
# AGENTS.md

## Dev environment tips
- Repo kurallari: Templates/_Universal altindaki policy dosyalarina bak.
- Uygulama oncesi karar kurallari: AI-BRAIN-ORCHESTRATOR.md

## Testing instructions
- Her degisiklikte lint + unit test + build calistir.
- CI plani kirmiziysa merge etme.

## PR instructions
- Branch: feature/<issue-id>-<kisa-ad> veya fix/<issue-id>-<kisa-ad>
- Commit: Conventional Commits
- PR aciklamasi: amac, degisiklikler, test kaniti, riskler

## Memory protocol
- Gorev basi: AI_* ledger dosyalarini oku
- Gorev sonu: AI_* ledger dosyalarina writeback yap
```

---

## 3) Cursor Rules Kisa Sablon

```md
# .cursorrules (or project rules)

- Follow AI-BRAIN-ORCHESTRATOR.md and AI-EXECUTION-POLICY.md.
- Never push directly to main/develop.
- Use feature/fix branches only.
- Keep diffs minimal and production-ready.
- Run lint/test/build before claiming completion.
- Update AI ledgers after each task.
- Ask questions only for critical ambiguity.
```

---

## 4) Windsurf Rules Kisa Sablon

```md
# Windsurf Project Rules

- Start every task by reading AI ledgers.
- Use CI/CD-first, API-first, Code-first, AI-first, Mobile-first order.
- Decide architecture (monolith vs microservice) with explicit rationale.
- Enforce conventional commits and semantic versioning.
- No completion without verification and ledger writeback.
```

---

## 5) Hook ve Enforcement Notu

Kural dosyalari tek basina yeterli degildir.
Zorunlu davranislar icin:
- CI required checks
- branch protection
- gerekirse hook tabanli guvenlik kontrolleri

---

## 6) Kullanim Sirasi

1. Araca uygun root dosyayi sec (CLAUDE.md / AGENTS.md / rules).
2. Bu dosyaya yukaridaki minimal sablonu koy.
3. Sablonu `AI-BRAIN-ORCHESTRATOR.md` ve `AI-EXECUTION-POLICY.md` dosyalarina bagla.
4. Ilk taskta ledger writeback'in gercekten yazildigini dogrula.
