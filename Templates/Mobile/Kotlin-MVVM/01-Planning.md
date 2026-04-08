# 1️⃣ Kotlin & MVVM - Native Android Planlama & Yüksek Ölçeklenebilirlik

> **OTONOM YAPAY ZEKA İÇİN KESİN KURAL:** Kotlin & MVVM ekosistemi, Java'nın hantal ve çöküşe meyilli yapısını yok eden "Modern Native Android" kalesidir. Bir Otonom Geliştirici, bu şablonu kullanırken ASLA eski Java pratiklerini (AsyncTask, FindViewById, Null Pointer bırakan kodlar) KULLANAMAZ! Sisteme 60-120 FPS Native performans, "Coroutines" asenkron yönetimi ve "Jetpack Compose / ViewBinding" UI zırhları entegre edilmek **ZORUNDADIR**.

---

## 🎯 1. Çekirdek Altyapı Kararı: Cihazın Kök Kaynaklarına Erişim
Android cihazlar, dünyanın en bölünmüş donanım havuzuna (Fragmentation) sahiptir. Biri 16GB RAM'e sahipken diğeri 2GB RAM barındırır. Web browserlarda olduğu gibi "Çalışırsa çalışır" mantığı yoktur. Otonom ajan, projeyi kodlarken Bellek Tüketimini (Memory Consumption) ve Pil Kullanımını (Battery Drain) 1. sınıf vatandaş sayacaktır!

### Otonomi İçin Kotlin MVVM Süper Avantajları:
* **%100 Native Erişim (No Bridge):** React Native veya Flutter gibi bir "Köprü (Bridge)" mekanizması OLMADIĞI için, otonom zeka Bluetooth, Kamera, NFC, Arka Plan Hizmetleri (WorkManager) veya Dosya İndirme işlemlerini %100 saf hızda cihaza işlettirir.
* **Coroutines ve Flow (Asenkron Devrim):** Ağ çağrısını beklerken "Callback Cehennemi (Hell)" yaratılmaz. Ajan, Asenkron işlemleri tamamen `viewModelScope.launch` ile fırlatır ve Cihazın Main (UI) Thread'ini bir milisaniye bile KİLİTLEMEZ! 
* **Null Safety (Sıfır Çökme Garantisi):** Kotlin'in `?` (Nullable) ve `!!` (Not Null Assertion) yapısı sayesinde Yapay Zeka NullPointerException hatalarını derleme (Compile) zamanında yok eder. Fakat Otonomi `!!` işaretini (Zorlayıcı Not-Null) KULLANMAMAK ZORUNDADIR (Bu kırmızı bir aciliyet çizgisidir).

---

## 🔒 2. Re-Render Faciası ve Veri Kaybı (Configuration Changes)

Android İşletim sisteminde Kullanıcı telefonu YAN (Landscape) çevirdiğinde, veya bir arama geldiğinde O.S (İşletim Sistemi) o anki ekranı "ÖLDÜRÜR" (Activity.onDestroy) ve baştan çizer (Activity.onCreate). Eğer Otonomi Dümdüz (Spagetti) kod yazmışsa, kullanıcının girdiği form bilgileri tamamen kaybolur!

* **Kural 1 (ViewModel Hayat Ağacı):** Otonomi, İş mantığını ASLA Activity/Fragment içine yazmaz! Veriler (State) yalnızca `ViewModel` içerisinde `StateFlow` veya `LiveData` olarak Yaşar. Ekran yan dönüp ölse (Destroy) dahi ViewModel hayatta kalarak veriyi yeni doğan ekrana anında Zerk eder (Inject).
* **Kural 2 (ViewBinding / Compose Mührü):** Eski nesil `findViewById` otonomi tarafından yasaklanmıştır! `ActivityMainBinding.inflate` (ViewBinding) komutları kullanılarak arayüze %100 Tip Güvenli (Type-safe) erişilir.

---

## 🚀 3. Ekran Boyutları ve Sıkı Tablet Ölçeklemesi (Responsive UX)

Android dünyasında binlerce ekran çözünürlüğü mevcuttur. Foldable (Katlanabilir) cihazlar, saatler, televizyonlar ve telefonlar aynı işletim sistemindedir.

* **A. ConstraintLayout (Bükülmez Şablon):** 
Uygulama arayüzü Çizilirken, Otonom araç "Eski LinearLayout" pratiklerini Çöpe Atar. %90 Oranında `ConstraintLayout` kullanılarak her element birbirine zıncırlanır (Constraint). Böylece ekran devasa da olsa, küçükte olsa elementler dinamik matematik ile ekranda hatasız konumlanır.
* **B. Hardcoded Pixel Yasağı:**
Otonom araçlar kod yazarken `layout_width="400dp"` gibi değerleri Yazıp GeçeMEZ! Müşteri Tabletle girdiğinde minyatür bir tasarımla karşılaşmamalıdır. Mümkün olan heryerde `0dp (match_constraint)`, `match_parent` veya `wrap_content` ve Oranlamalar (Ratio) tasarlanacaktır. `res/values/dimens.xml` dosyası otonomca güncellenir.
* **C. Geri Tuşu Tıkanması (Pop BackStack):**
Kullanıcı kayıt formunda işini bitirdiğinde Navigasyonla Ana Ekrana atan Ajan, Eğer `navController.popBackStack()` kurgusunu VEYA `requireActivity().onBackPressedDispatcher`'ı kurmazsa; kullanıcı Geri Tuşuna Bastığında TEKRAR "Kayıt Başarılı!" formuna geri düşer (Kısır Navigasyon Döngüsü - Navigation Stack leak). Otonomi BackStack'i her geçişte temizlemeye mecburdur!

## 📡 4. Veri Senkronizasyonu: Offline-First ve Room Database

Native bir uygulama SADECE internet varken çalışamaz! İnternetsiz iken de cache (Önbellek) verilmelidir:
Otonom Yapay Zeka RestAPI'den (Retrofit ile) Bir Liste Çeker Çekmez (Örn: Ürünler), Ekrana vermeden evvel onu HEMEN Cihazın SQLite yerel motoruna (`Room Database`) Insert (Kaydet) eder. LocalDB tetiklenir ve Flow (Akış) üzerinden Ekranı çizer. Buna **"Single Source of Truth (Tek Hakikat Kaynağı)"** denir.
Sırada Katman ayrışmaları (Architucture - 02) var.
