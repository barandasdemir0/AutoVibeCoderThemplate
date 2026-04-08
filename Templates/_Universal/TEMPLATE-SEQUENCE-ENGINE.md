# TEMPLATE-SEQUENCE-ENGINE.md — 6 Dosya + QUICK-START Sıra Motoru

> Amaç: AI'nin her template'te aynı disiplinle ilerlemesi.
> "Önce bunu oku, sonra diğerini" mantığı kesin kurallara bağlanır.

---

## Zorunlu Okuma Sırası

AI her template için şu sırayı izler:
1. `QUICK-START.md`
2. `01-Planning.md`
3. `02-Architecture.md`
4. `03-StepByStep.md`
5. `04-FilesStructure.md`
6. `05-DebugTips.md`
7. `06-Resources.md`

Kural:
- Bir önceki dosyadan "çıkarım özeti" yazmadan bir sonrakine geçilmez.

---

## Her Dosyada Zorunlu Çıktı

### QUICK-START sonrası
- Stack önerisi
- Kapsam sınırı
- İlk sprint hedefi

### 01-Planning sonrası
- Problem tanımı
- MVP kapsamı
- Başarı kriteri

### 02-Architecture sonrası
- Mimari desen
- Katmanlar
- Kritik teknik kararlar

### 03-StepByStep sonrası
- Uygulama adımları
- Öncelik sırası
- Riskli adımlar

### 04-FilesStructure sonrası
- Dosya üretim sırası
- Her dosyanın amacı
- Bağımlılık zinciri

### 05-DebugTips sonrası
- Muhtemel ilk 10 hata
- Teşhis ve çözüm yolu

### 06-Resources sonrası
- Referans kaynak listesi
- Kullanılacak örnek snippet seti

---

## Geçiş Kuralları (Step Gate)

AI her geçişte şunu uygular:
1. "Ne öğrendim" özeti (3-5 madde)
2. "Bir sonraki dosyada ne arayacağım" (2-3 madde)
3. Ledger güncelleme:
   - `AI_DECISION_LOG.md`
   - `AI_DEVELOPMENT_LOG.md`

Kural:
- Gate tamamlanmadan kod üretimi başlamaz.

---

## Kod Üretim Başlatma Şartı

Kod ancak şu koşullarda başlar:
1. 7 dosya sıralı işlendi
2. Teknoloji kararı gerekçeli şekilde yazıldı
3. Dosya üretim sırası netleşti
4. İlk V1 dilimi tanımlandı

---

## Kalite ve Otonomi Notu

- AI kullanıcıyı gereksiz sorularla bölmez.
- AI, kapsam dışı iş eklemez.
- AI, önce mimari sonra kod yaklaşımını korur.
- AI, hatayı çözmeden ilerlemez.
