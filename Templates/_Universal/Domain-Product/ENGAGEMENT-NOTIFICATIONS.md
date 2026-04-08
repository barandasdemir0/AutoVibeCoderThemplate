# 🔔 Kullanıcı Elde Tutma (Retention) ve Bildirim (Push) Stratejileri

Kullanıcıyı uygulamaya bağımlı kılmak ve sürekli geri dönmesini (Retention) sağlamak, özellikle mobil projelerde hayati önem taşır. Yapay zeka (AI) platform bağımsız uygulamayı kodlarken, sadece "Düz bildirim" değil, **Growth (Büyüme) odaklı, kişiselleştirilmiş ve zengin bildirim altyapısı** kurmalıdır.

## 🚀 4 Temel Bildirim Stratejisi (AI'ın Desteklemesi Gereken Senaryolar)

### 1. Duygusal Tetikleyici (Emotional Trigger) Bildirimler
Kullanıcının uygulamada duygusal bir bağ kurduğu olayları kullan.
- *Örnek:* "Pati yolda! 🐾 Tarçın'ın gezdirme raporu ve fotoğrafları geldi!"
- **Teknik:** Zengin push notification (Rich Push) içinde Resim/Thumbnail gösterme desteği.

### 2. Topluluk ve "FOMO" (Fırsatı Kaçırma Korkusu)
Kullanıcıya bölgesinde veya çevresinde olan biteni gösteren bildirimler.
- *Örnek:* "Mahallene yeni bir komşu katıldı 🏡 Yan binadaki Zeynep profilini oluşturdu!"
- **Teknik:** Konum bazlı (Geo-fenced) veya Firebase (FCM Topics) ile bölgesel abonelikler.

### 3. Oyunlaştırma (Gamification) ve Kişiselleştirme
Kullanıcının verilerine dayalı esprili/hatırlatıcı bildirimler.
- *Örnek:* "Miyav! Aşı zamanım yaklaşıyor, takvimi güncelleyelim mi?"
- **Teknik:** Sunucuya ihtiyaç duymayan Scheduled Local Notifications (Zamanlanmış Lokal bildirim).

### 4. Cross-Sell (Çapraz Satış) ve Partner Uyarıları
- *Örnek:* "Hafta sonu planı yaptın mı? Bölgedeki en iyi 3 otel indirimde."
- **Teknik:** Firebase In-App Messaging veya bildirim içine Buton ekleme.

---

## 🛠️ YZ İçin Kurulum ve Mimari Best Practice'leri (ZORUNLU UYGULAMA)

Bu sistemi tasarlarken uygulaman gereken **Best Practice** standartları:

1. **Contextual İzin (Permission) Mimarisi:** Mobil uygulamada ilk açılışta küt diye izin isteme! Önce kullanıcının güvenini kazan, ona neden bildirim göndermen gerektiğini anlatan fayda odaklı bir "Onboarding Şablonu" tasarla, onaylarsa OS iznini iste.
2. **Core FCM (Firebase Cloud Messaging) Entegrasyonu:** Arka plan (`background`), ön plan (`foreground`) ve terminal (`terminated`) durumlarında bildirim alım mimarilerini eksiksiz handle et.
3. **Deep Linking (Derin Bağlantılar) Kullanımı:** Bildirime tıklandığında uygulamanın basitçe ana sayfasına atıp bırakma. İlgili veri neredeyse (Örn: Rapor detayı) "Deep Link / Router" mekanizması ile tam olarak o spesifik sayfaya yönlendir.
4. **Rich Notifications:** Bildirimlere butonlar (Action Buttons) ve Payload JSON verişlerini düzgün ayrıştıracak interceptor/parser'lar yaz.
