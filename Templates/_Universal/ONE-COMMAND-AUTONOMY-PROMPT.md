# ONE-COMMAND-AUTONOMY-PROMPT.md - Tek Komutla Tam Otonom Baslatma

Bu dosya, kullanicinin sadece urun fikrini verip geri kalan tum muhendislik surecini
AI'ya devretmesi icin tasarlandi.

---

## 1) Kullanici Komutu (Kopyala-Callistir)

Asagidaki metni AI'ya tek seferde ver:

```txt
Bu projede tam otonom calis.
Ana referans dosyalarin:
- Templates/_Universal/UNIVERSAL-READING-ORDER.md
- Templates/_Universal/PROJECT-DISCOVERY-QUESTION-GUIDE.md
- Templates/_Universal/AI-BRAIN-ORCHESTRATOR.md
- Templates/_Universal/AI-EXECUTION-POLICY.md
- Templates/_Universal/AGENT-CROSS-COMPATIBILITY.md
- Templates/_Universal/AUTONOMY-BRAIN.md
- Templates/_Universal/AI-RULES.md
- Templates/_Universal/PROJECT-SIZE-ENGINE.md
- Templates/_Universal/CONTEXT-MEMORY-RAG-POLICY.md

Calisma sirasi:
1) PROJECT-DISCOVERY-QUESTION-GUIDE.md dosyasina gore detayli kesif sorularini sor.
2) UNIVERSAL-READING-ORDER.md dosyasina gore sadece gerekli rehberleri sec.
3) Proje buyuklugunu S/M/L/XL olarak netlestir (belirtilmediyse bir kez sor, yine yoksa M varsay).
4) Monolith/moduler monolith/microservice kararini gerekcelendir.
5) Teknoloji secimini gerekcelendir.
6) API-first, Code-first, Mobile-first sirasiyla tasarla.
7) V1 calisan surumu cikar, sonra iteratif genislet.
8) Her adimda lint/test/build calistir.
9) CI yesil olmadan "bitti" deme.
10) Her net talimati ve kararini ilgili AI_* ledger dosyalarina otomatik yaz.
11) Kritik belirsizlik yoksa soru sorma; varsa sadece kritik sorulari sor.
12) Issue -> branch -> PR -> CI -> merge -> release akisini uygula.
13) Root-safe execution uygula: `Templates/` altina ve talimat markdown dosyalarina kod yazma; kodu sadece root altinda ayri uygulama klasorune uret.
14) Uzun akislarda secici hafiza ve ozetleme uygula: gereksiz sohbet gecmisini tasima, karar/riski kisa ozetleyip ledger'a yaz.

Branch kurali:
- main/develop direkt commit yok.
- Sadece feature/* veya fix/* branch.

Commit/Release kurali:
- Conventional Commits kullan.
- Semantic versioning uygula.
- Release notu ve rollback plani yaz.
```

---

## 2) Beklenen AI Ciktisi

AI su ciktilari vermelidir:
- Mimari karar ozeti
- Secilen stack ve gerekceler
- V1 kapsam listesi
- Test/CI dogrulama ozeti
- Ledger writeback ozeti
- Sonraki adim plani

---

## 3) Kritik Soru Politikasi

AI sadece asagidaki durumlarda soru sorar:
- Zorunlu teknoloji kisiti net degilse
- Regulator/hukuki zorunluluk belirsizse
- Secret/ortam erisimi olmadan ilerlenemiyorsa
- Kabul kriteri olculemiyorsa

Bunlar disinda AI otonom ilerler.

---

## 4) Hizli Kontrol Listesi

- [ ] Karar dosyalari okundu
- [ ] Mimari karari loglandi
- [ ] CI kapilari tanimlandi
- [ ] Ledger writeback yapildi
- [ ] Release/rollback notu cikti

---

## 5) Nerede Kullanilir?

- Claude Code
- Cursor
- Windsurf
- Copilot/Codex ajanlari
- AGENTS.md destekleyen diger araclar

Bu dosya tool-agnostic oldugu icin tumunde ayni niyeti uygular.
