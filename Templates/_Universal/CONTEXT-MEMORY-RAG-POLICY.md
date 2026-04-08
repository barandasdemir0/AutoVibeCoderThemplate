# CONTEXT-MEMORY-RAG-POLICY.md - Hafiza, Ozetleme ve Secmeli Baglam Politikasi

Bu dosya, gereksiz token tuketimini azaltirken AI'nin kritik bilgiyi unutmamasini saglayan operasyon kurallarini tanimlar.

Kaynak ilhami:
- Kisa root talimat + moduler dokuman yukleme yaklasimi
- RAG (retrieval-augmented generation) prensibi
- Ozetleme yerine secici hafiza olusturma yaklasimi

---

## 1) Minimal Root Talimat Kurali

Kural:
- Root talimat dosyasi (CLAUDE.md / AGENTS.md / rules) kisa tutulur.
- Root dosyasi bilgi deposu degil, yonlendirme noktasidir.
- Ayrintili kurallar `Templates/_Universal/` altindaki ilgili dosyalarda kalir.

Sinir:
- Root dosyada uzun teknik detay tutma.
- Root dosya; okuma sirasi, kalite kapilari ve writeback zorunlulugunu isaret eder.

---

## 2) Secmeli Baglam Yukleme (Progressive Disclosure)

Kural:
- Tum dokumanlari tek seferde yukleme.
- Once kesif sorulari ve okuma sirasi ile sadece ilgili dosyalari sec.

Uygulama adimi:
1. `UNIVERSAL-READING-ORDER.md` ile cekirdek dosyalari oku.
2. `PROJECT-DISCOVERY-QUESTION-GUIDE.md` ile ihtiyaci netlestir.
3. Sadece gerekli domain rehberlerini yukle.
4. Kodlama fazinda gerekmedikce yeni dokuman acma.

---

## 3) RAG Benzeri Kanitli Cevap Kurali

Bilgi yogun gorevlerde cevaplar su kaynaklardan beslenir:
- Proje ici dokumanlar (template + universal)
- Proje kodu
- Gerekirse dis kaynak referanslari

Kural:
- Kritik kararlar "hangi belgeye dayanarak" alindigiyla birlikte yazilir.
- Karar ve dayanak `AI_DECISION_LOG.md` icine gecirilir.

---

## 4) Ozetleme ve Hafiza Katmanlari

AI, tum sohbeti her seferinde tasimaz; katmanli hafiza uygular:

1. Working memory:
- Son aktif gorev, son talimat, acik hata, bir sonraki adim.

2. Episodic memory:
- Dikkat ceken hata, mimari karar, donus noktasi.

3. Semantic memory:
- Kalici kural, tekrar eden pattern, proje standardi.

Kural:
- Ozetleme "her seyi sikistirma" degil, "neyin kalici oldugunu secme" isidir.

---

## 5) Ozetleme Tetikleyicileri

Asagidaki durumlardan biri olunca ozetleme calistir:
- Uzun sureli gorev ilerleyisi (birden fazla faz tamamlandi)
- Ayni konu etrafinda cok sayida mesaj olustu
- Yeni bir alt goreve geciliyor

Ozet formati:
- Kararlar (degismeyenler)
- Acik riskler
- Acik gorevler
- Sonraki adim

Yazim hedefi:
- Kisa, maddeli, tekrar etmeyen ozet.

---

## 6) Cakisma Cozumu ve Tazelik Kurali

Eger iki bilgi cakisiyorsa:
1. En yeni onayli karar onceliklidir.
2. Kullanici son acik talimati her seyin ustundedir.
3. Eski karar `superseded` notuyla saklanir, silinmez.

---

## 7) Repo Guvenlik Cizgisi (Root-Safe Execution)

Asla kod uretme:
- `Templates/`
- Talimat markdown dosyalarinin ici

Her zaman kod uret:
- Proje root altinda ayrik bir uygulama klasoru (`src/`, `app/`, proje-adi)

Kural:
- Dokuman klasoru bilgi kaynagi, uygulama klasoru ise kod alanidir.

---

## 8) Seans Sonu Refine Kurali

Her ana gorev sonunda kisa bir refine dongusu uygulanir:
1. Bu seansta tekrar eden hata var mi?
2. Yeni bir anti-pattern ogrendik mi?
3. Hangi dokumana tek satirlik kural eklenmeli?

Sonuc:
- Ilgili dosyaya minimal guncelleme yap.
- Gereksiz yeni dosya acma.

---

## 9) Done Kriteri (Memory-Aware)

Is bitmis sayilmasi icin:
- Karar dayanaklari yazilmis olmali
- Ozet kaydi guncel olmali
- Ledger writeback tamam olmali
- CI kalite kapilari gecmis olmali
