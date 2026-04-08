# AUTONOMOUS-OPERATING-SYSTEM.md — Tam Otonom ve Unutmayan AI İşletim Sistemi

> Hedef: Kullanıcı sadece fikri ve iş hedefini verir. AI, emir dışına çıkmadan,
> en doğru teknolojiyi seçer, mimariyi kurar, adım adım üretir, hataları çözer, her şeyi kaydeder.

---

## 1) Otonomluk Sınırı (İnsan Nerede Devralır?)

AI tam otonom çalışır, sadece aşağıdaki durumlarda kullanıcı devralır:
1. Veritabanı sunucusuna fiziksel erişim/kimlik bilgisi girişi
2. API key, secret, sertifika gibi güvenli sırların girilmesi
3. Ücretli servis aktivasyonu (cloud billing, store ödeme vb.)

Bu üçü dışındaki tüm mühendislik işleri AI sorumluluğundadır.

---

## 2) Zorunlu Adım Planı (Asla Atlanmaz)

1. Dosya Sıra Motoru: `TEMPLATE-SEQUENCE-ENGINE.md` ile 7 dosyayı sırayla işle
2. Amaç Analizi: İş hedefi, kullanıcı tipi, ölçek, güvenlik, regülasyon
3. Karar Motoru: `AI-BRAIN-ORCHESTRATOR.md` ile monolith/microservice + stack seçimi
4. Mimari Tasarım: Modüler yapı, bağımlılık yönü, veri akışı
5. V1 Dilimi: En küçük çalışan uçtan uca sürüm
6. İteratif Genişleme: Feature'ları küçük partilerle ekleme
7. Kalite Kapıları: Lint, test, build, performans, güvenlik
8. Ledger Güncelleme: Chat, karar, feature, hata, timeline logları
9. Final Kapanış: Risk listesi + sonraki adım + release notu

---

## 3) Teknoloji Seçim Motoru (Bias'sız)

AI dil/stack seçimini "alışkanlığa göre" değil, skorlamaya göre yapar.

Skor kriterleri (1-5):
- Ürün karmaşıklığı
- Beklenen trafik ve ölçek
- Ekip becerisi ve bakım maliyeti
- Performans gereksinimi
- Ekosistem olgunluğu
- Güvenlik ve kurumsal uyum
- Geliştirme hızı

Karar örnekleri:
- Kurumsal, uzun ömür, güçlü domain kuralları: Java/.NET
- Hızlı MVP, geniş paket ekosistemi: Node/TypeScript
- Veri/AI yoğun iş akışı: Python
- Yüksek kaliteli çapraz platform mobil: Flutter
- iOS-native premium deneyim: Swift

Kural:
- "JS'de iyiyim" gerekçe olamaz.
- Seçim gerekçesi `AI_DECISION_LOG.md` içine yazılmadan kodlamaya başlanmaz.
- Anlaşılamayan gereksinimde önce `AI_CHAT_LEDGER.md` kontrol edilir; halen belirsizlik varsa sadece kritik soru sorulur.

---

## 4) Mimari Öncelik Kuralı

Önce şu belgeler güncellenir, sonra kod:
1. `01-Planning.md`
2. `02-Architecture.md`
3. `04-FilesStructure.md`

Ardından kod üretimi sadece şu sırayla yapılır:
1. Config ve altyapı
2. Domain model
3. Veri erişim katmanı
4. İş mantığı
5. API/UI katmanı
6. Test

---

## 5) Hata Yönetimi Kuralı

Her hata için zorunlu davranış:
1. Belirtiyi topla (hata mesajı, stack trace)
2. Kök nedeni bul (semptom değil neden)
3. En az değişiklikle fix uygula
4. Test/build ile doğrula
5. `AI_ERROR_LEDGER.md` içine saatli kayıt gir

---

## 6) Feature Yönetimi Kuralı

Her yeni özellik için zorunlu davranış:
1. İhtiyacı bir cümlede yaz
2. Mimari etkisini yaz
3. V1'i çıkar
4. Genişlet
5. `AI_FEATURE_LEDGER.md` içine neden/nasıl/dosyalar kaydı gir

---

## 7) Sohbetten Talimat Alma Kuralı

AI, kullanıcı sohbetini komut kaynağı olarak işler:
1. Her net talimat `AI_CHAT_LEDGER.md` içine girilir
2. Talimat durumu: pending, in-progress, completed
3. Çakışma varsa en güncel talimat "active" işaretlenir

Kural:
- Kullanıcı daha önce net yanıt verdiyse aynı soruyu tekrar sorma.

---

## 8) Kalite Kapıları (Done Tanımı)

Bir iş "tamamlandı" sayılması için hepsi geçmeli:
1. Mimari dokümanlar güncel
2. Lint temiz
3. Testler geçiyor
4. Build başarılı
5. Kritik güvenlik açıkları kapalı
6. Ledger kayıtları güncel

---

## 9) Kısa Çalışma Mantrası

"Fikri al, doğru teknolojiyi seç, mimariyi kur, küçük çalışan sürümü çıkar, adım adım büyüt, her şeyi saatli logla, kalite kapısı geçmeden bitmiş sayma."
