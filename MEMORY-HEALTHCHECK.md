# MEMORY-HEALTHCHECK

Amac: 10 saat veya daha uzun aradan sonra hafiza surekliligini dogrulamak.

## Dosyalarin Ana Amaci

1. `AI_CHAT_LEDGER.md`
- Ana amac: Kullanicidan gelen net talimatlarin zaman damgali kaydini tutmak.

2. `AI_DECISION_LOG.md`
- Ana amac: Teknik kararlarin nedenleriyle birlikte kaydini tutmak.

3. `AI_FEATURE_LEDGER.md`
- Ana amac: Eklenen feature degisikliklerini ve dogrulama kanitlarini takip etmek.

4. `AI_ERROR_LEDGER.md`
- Ana amac: Hata kok neden, cozum ve dogrulama bilgisini saklamak.

5. `AI_DEVELOPMENT_LOG.md`
- Ana amac: Saatlik/gorevlik ilerleme ozeti ve bir sonraki adimi yazmak.

## Proje Baslangicinda Eklenecek Ilk Kayitlar

Asagidaki bloklar kopyalanip ilgili dosyalara eklenir. Format bozulmamasi icin ayni baslik/madde duzeni korunur.

### AI_CHAT_LEDGER.md (ilk satir)
| Timestamp | Instruction Summary | Type | Status | Link |
|---|---|---|---|---|
| YYYY-MM-DD HH:mm | Proje baslatildi, ilk hedef belirlendi | infra | completed | INIT-CHAT-0001 |

### AI_DECISION_LOG.md (ilk karar)
## DEC-INIT-0001
- Timestamp: YYYY-MM-DD HH:mm
- Decision: Proje baslangic karar seti tanimlandi.
- Rationale: Ilk gelistirme kapsamini sabitlemek.
- Scope: aktif proje
- Status: active

### AI_FEATURE_LEDGER.md (ilk feature)
## FEAT-INIT-0001
- Timestamp: YYYY-MM-DD HH:mm
- Feature: Baslangic iskeleti
- Why: Proje icin minimum calisir temel olusturmak
- Files:
  - [ilk eklenen dosya]
- Validation: [lint/test/build veya manuel dogrulama]

### AI_ERROR_LEDGER.md (ilk hata varsa)
## ERR-INIT-0001
- Timestamp: YYYY-MM-DD HH:mm
- Context: [ilk hata baglami]
- Symptom: [hata belirtisi]
- Root Cause: [kok neden]
- Fix: [uygulanan cozum]
- Verification: [dogrulama]
- Status: verified

### AI_DEVELOPMENT_LOG.md (ilk gelisme girdisi)
## YYYY-MM-DD HH:mm
- Yapilanlar: Proje baslangic kayitlari acildi.
- Etki: Hafiza takibi aktif hale geldi.
- Sonraki Adim: Ilk uygulama gorevine gecilecek.

## Check 1 - Dosya Varligi
- AI_CHAT_LEDGER.md
- AI_DECISION_LOG.md
- AI_FEATURE_LEDGER.md
- AI_ERROR_LEDGER.md
- AI_DEVELOPMENT_LOG.md

## Check 2 - Son Kayit Tazeligi
- Her dosyada en az bir zaman damgali kayit olmali.
- Yeni gorev basinda once bu dosyalar okunmali.

## Check 3 - Cakisma Kontrolu
- Yeni karar, eski kararla celisiyorsa eski kayit silinmez.
- Eski kayit "superseded" notu ile saklanir.

## Check 4 - Kapanis Kurali
- Gorev kapanmadan once en az su dosyalar guncellenir:
  - AI_DEVELOPMENT_LOG.md
  - AI_CHAT_LEDGER.md
  - (Gerekirse) AI_ERROR_LEDGER.md veya AI_FEATURE_LEDGER.md

## Sonuc Kriteri
Bu 4 kontrol geciyorsa sistem uzun araliklarda "unutma" riskini ciddi oranda azaltmis kabul edilir.
