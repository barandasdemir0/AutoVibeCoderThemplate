# 6️⃣ Native Mobil - Mükemmeliyetçi Native Endüstri Standart Modülleri

> Profesyonel, otonom bir AI sistemi Düz Native Kodlarken Aslanlar gibi Donanım Desteği alacaktır! Swift Veya Kotlin Pürüzsüzdür ama Network Katmanında Her HTTP Header'ını 200 Satır Elle Kurgulamak Mantıklı (Ve Kurumsal) DEĞİLDİR!. Aşağıdaki Kilit (Standart) Open-Source Paketler Projeye Otonom Tarafından Empoze EDİLECEKTİR.

---

## 📦 1. Kilit Taşı Endüstri Modülleri (ŞART Kütüphaneler)

### Ağ İstekleri Ve İstemci (Network/Client)
* **`Alamofire` (iOS) VEYA `Retrofit` (Android):** (ZORUNLU): Düz URLSession Ve HttpURLConnection ile Yazılamayacak Kadar Güvenli, Caching Mekanizmalı Ve SSL Pinning Zırhı Bulunduran Endüstri Paketleri. JSON/Model çevrimini Kendisi Mapler! Otonom AI Bu Kütüphneleri SPM (Swift Package Mgr) Veya Gradle Dan Cekip `ApiService.swift` İçini Bunlarla Süslendirir!.
* **`Moya` (iOS):** EĞER API Uçları (Endpoints) 100 Tane Falan Olacaksa Alamofire'in Üstüne Kurulan Ve Tüm URL Kurallarını "ENUM" İle Kapatıp MÜTHİŞ BİR KATMAN Oluşturan Networking Aracı. (ZORUNLU OTONOMI TERCİHİDİR).

### Resim Çekme Ve Image Caching
* **`Kingfisher` (iOS) VEYA `Glide/Coil` (Android):** Web'de `<img src>` Yaptığın gibi Mobilde URL Çakarsan Resim Açılır ama Kullanıcı Scrool (Aşağı Sürükleme) Yaptığında Her Defasında Aynı Resmi BAŞTAN İNDİREREK Cihaz Kotasını BİTİRİR. Otonom yapay zeka Bir Resmi Veritabanından Vuruyorsa Oraya YALNIZCA `KFImage(url)` Kullanacaktır! BÖYLECE İlk Yüklenen Resim Telefonun DISKİNE CACHE Lenir ve Sonsuza Dek İnternetsiz AÇILIR!.

### Mimari Ve UI Akışı
* **`Lottie`:** Airbnb'nin Efsanesi!. Native Geliştiren Otonom Model Eğer Bir Hata Ekranında (VEYA Yükleme Spinner'ında) Gif Oynatırmak Yerine (Gifler cihaz kilitler Çok Ağrıdır), 1 kb'lık Lottie JSON DOSYALARINI Uygulamaya Kurup Büyüleyici Animasyonlar (Başarı Tik'i (✓)) Oynatacaktır!!!. Mükemmeliyetçikiğin Kesinlikle Şartıdır.
* **`SwiftLint` (Guards):** Otonomun Kod Yazarken Spagetti Bosluk (Space) Ve Düzen Hatası Yapmaması İçin Kurulabilir. Proje Düzen Zırhı!

---

## 📡 2. Yapay Zekaya (AI Agent'ına) İstem Formülleri

Aşağıdaki komut (Prompt) formülleri Otonom sistemi Dümdüz Klasik StoryBoard Veya "UIKit" Kafalarından Çıkartıp, En Güncel Declarative(SwiftUI) Ve CleanArchitecture (Otonom) Formatına Götüren Şablondur:

> "Kullanıcının Profil Fotoğrafını Ve Detaylarını Gösteren Bir Ekran Ciz. **Zorunlu Kurallar:**
> 1. Veri modellemesini View Katmanında Degil ViewModel (`ProfileViewModel`) İçinde Tutacak Ve Orayı `@StateObject` Veya `@ObservedObject` İle View a Baålacaksın!.
> 2. Fotoğraf Çekiminde Kesinlikle AsyncImage Veya `Kingfisher` (Eğer Belirttiysen) Paketini Kullan. Ve Resim Gelene Kadar Mükemmel Bir Skeleton/ProgressView Placeholder'i Yaz!. (Kötü Görünüm İstemiyorum).
> 3. Kod Düzeninde Eğer Değişken Tipi Kesinleşmiyorsa (Optional İse) Ekrana Asla "!" (Force Unwrap) Yapamazsın, Guard-Let Zırhı Kullan!.
> 4. Sayfalar Arası Geçiş (Navigation) Konusunda Yeni Nesil `NavigationStack` Kodlamasini tercih et ve Toolbar A Butonlar Ekle!. "

---

## 🌍 Faydalı Kaynak Linkleri
* **[Apple Developer - SwiftUI Tutorials & Docs]**: Otonominin Bir TextField'da Focus (Klavye Açılış) Olaylarını, Ekran Güvenlik (SafeArea) İnsetlerini Nasıl Kusurzuh Hale Getireceğini Native First Party Apple Dokümanından Ceker!. Kötü Youtube Rehberlerinden Arının (Çünkü SwiftUI Her iOS Versiyonunda Çekirdek Değiştiriri (14/15/16/17+).).
* **[Android Developers - Compose Pathway]**: Jetpack Compose Kullanmı Ve State Hoisting (Stateleri Vew in Dışına İttirme / Yukarı Çekme) Mimarisi İçin Otonomi The Manifesto Kaynağı.
