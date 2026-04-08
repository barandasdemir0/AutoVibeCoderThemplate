# AGENT-CROSS-COMPATIBILITY.md - Claude, Cursor, Windsurf, Codex Ortak Beyin Standardi

Bu dosya, farkli coding agent araclarinda tek bir ortak davranis elde etmek icin yazildi.
Amaç: Ayni proje fikri verildiginde, hangi arac kullanilirsa kullanilsin benzer kalite, benzer karar ve benzer hafiza davranisi.

---

## 1) Problemin Koku

LLM ajanlar cogu zaman session bazli calisir, hafizalari kalici degildir.
Bu nedenle davranisi belirleyen sey model degil, yuklenen baglam ve kurallardir.

Sonuc:
- Her oturumda onboarding gerekir.
- Kisa ve evrensel kural seti daha iyi sonuc verir.
- Deterministik enforcement (CI, hook, branch protection) olmadan otonomi dagilir.

---

## 2) Ortak Cekirdek (Tool-Agnostic Brain)

Tum araclar su cekirdek dosyalari referans alir:
- `AI-BRAIN-ORCHESTRATOR.md`
- `AI-EXECUTION-POLICY.md`
- `AUTONOMY-BRAIN.md`
- `AI-RULES.md`
- `AUTONOMOUS-OPERATING-SYSTEM.md`

Proje hafiza dosyalari (runtime memory):
- `AI_CHAT_LEDGER.md`
- `AI_DECISION_LOG.md`
- `AI_FEATURE_LEDGER.md`
- `AI_ERROR_LEDGER.md`
- `AI_DEVELOPMENT_LOG.md`

Kural:
- Agent implementasyondan once bu hafiza dosyalarini okur.
- Gorev bitisinde writeback yapmadan "tamamlandi" denmez.

---

## 3) Progressive Disclosure Modeli

Root talimat dosyasini kisa tut.
Nadir veya task-specific kurallari alt dosyalara bol.

Ornek yapi:
- `agent_docs/building.md`
- `agent_docs/testing.md`
- `agent_docs/architecture.md`
- `agent_docs/db-migrations.md`
- `agent_docs/release.md`

Kural:
- Root dosya "nereye bakilacagini" soylesin.
- Ayrintiyi alt dosyalar tasisin.

---

## 4) CLAUDE.md ve AGENTS.md Icin Kritik Prensipler

1. Az ama kritik talimat:
- Dosyayi gereksiz uzatma.
- Evrensel olmayan talimatlari root'a koyma.

2. WHAT + WHY + HOW:
- WHAT: stack ve proje haritasi
- WHY: urunun amaci ve mimari mantik
- HOW: test/build/verify akisi

3. Tavsiye vs Enforcement ayrimi:
- CLAUDE.md / AGENTS.md: rehber
- Hook + CI + branch protection: enforcement

4. Linter isi modele birakma:
- Stil ve format kontrolleri deterministic araclarla calissin.

---

## 5) Cursor ve Windsurf Uyum Katmani

Cursor/Windsurf kurallari icin:
- Kisa, taske uygun, stacke spesifik rule setleri kullan.
- Token sisirmeyen, net anti-pattern listesi tut.
- "Tam dosya yaz" yerine "minimal diff" prensibi kullan.

Kural:
- Rule dosyalari modelin yerini almaz.
- Rule + CI + test birlikte calisirsa kalite stabil olur.

---

## 6) Otonomlukta Zorunlu Güvence Katmanlari

1. Branch governance:
- `main` ve `develop` protected
- AI sadece `feature/*` veya `fix/*`

2. Merge gate:
- lint + test + build yesil olmadan merge yok

3. Release safety:
- semantic version tag (`vX.Y.Z`)
- changelog + rollback plani

4. Secret safety:
- `.env`, key, credential dosyalarina hook korumasi

---

## 7) Onerilen Dosya Esleme (Ayni Beyin, Farkli Arac)

- Claude Code: `CLAUDE.md`
- Open agents ekosistemi: `AGENTS.md`
- Cursor: `.cursorrules` veya project rules
- Windsurf: workspace rules / memory docs
- Codex/Copilot tabanli ajanlar: root instruction docs + repo ledgers

Tumunde ortak referans:
- `AI-BRAIN-ORCHESTRATOR.md`
- `AI-EXECUTION-POLICY.md`

---

## 8) Hata Tekrarini Azaltan Kural

Ayni hata ikinci kez cozulduyse:
1. `AI_ERROR_LEDGER.md` kaydi guncelle
2. Ilgili root rule dosyasina anti-pattern ekle
3. CI veya hook ile enforce edilebiliyorsa otomasyona tasi

Bu dongu, "agent memory compounding" etkisi olusturur.

---

## 9) Baslatma Komutu (Tool-Agnostic)

```txt
Bu repoda AGENT-CROSS-COMPATIBILITY.md ve AI-BRAIN-ORCHESTRATOR.md dosyalarini ana referans al.
Kisa root talimat + progressive disclosure + ledger writeback + CI gate modelini uygula.
Monolith/microservice, stack, risk ve release kararlarini gerekceli ver.
Kritik belirsizlik yoksa soru sorma; gorev sonunda hafiza dosyalarini guncelle.
```

---

## 10) Kaynak Notu

Bu standard, Claude.md best-practice yazilari, agents.md acik format yaklasimi,
Claude Code resmi repo pratikleri ve cursor rule kataloglarindaki tekrar eden patternlerden derlenmistir.
