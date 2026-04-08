# 6️⃣ Kotlin & MVVM - Endüstri Standartı Kaynak Göstergeleri (Otonom Referans)

> **OTONOM ARAŞTIRMA MÜHRÜ:** Android Dünyası, eski Java mimarisinin çamurlarından sıyrılıp tamamen Kotlin tabanlı "Jetpack ve Compose" çağına girmiştir. `FindViewById`, `AsyncTask`, `ListView` veya Düz `XML` animasyonları Antik Çağa aittir! Otonom ajan, projeye bir paket eklemeden VEYA O.S entegrasyonu kurmadan önce "Modern Yaklaşımları" teyit etmek için aşağıdaki "Kurumsal Seviye" dev dökümantasyon merkezlerini otonom bir referans kalesi kabul eder.

---

## 🏛️ 1. Çekirdek Ekosistem ve Engine (Navigasyon Doğruları)

Projenin omurgasını dikerken (Bootstrapping) Google'ın (Android Dev) Orijinal ve Modern O.S Katmanı Dökümanları:

- **Android Developers Resmi Dokümanı (Ana Kaynak):** [https://developer.android.com/](https://developer.android.com/)
  - *Ne İşe Yarar:* Android'in Permissions (İzinler) politikaları, Her Android 14+ / 15+ (API 34/35) yeni güncellemelerinde Ekranlara getirilen "Edge-To-Edge" zorunluluk limitasyonları ve Manifest kodları için direkt Otonom Teyit merkezidir.
- **Android Architecture Components (Guide to app architecture):** [https://developer.android.com/topic/architecture](https://developer.android.com/topic/architecture)
  - *Ne İşe Yarar:* ViewModel'in yaşantısı (Lifecycle), M-V-VM Katmanlarının nasıl bölünmesi gerektiği tam olarak Google Mimarisi standartlarında izah edilir. (LiveData / StateFlow Entegrasyonları)
- **Jetpack Navigation Component:** [https://developer.android.com/guide/navigation](https://developer.android.com/guide/navigation)
  - *Ne İşe Yarar:* Projede 20 farklı fragment'i birbirine spagetti kodlarla (Intent/Transaction) bağlamayı ortadan kaldıran, SafeArgs ile ekrandan ekrana int/string parametreleri tip güvenli GEÇİREN (Type safe) navigasyon canavarı kütüphane.

---

## 🌐 2. Mimari, Enjeksiyon & Veritabanı Yöneticileri

Uygulamanın `Class.new` nesne üretme bağımlılığından (Tight coupling) ve Thread çöküşlerinden Kurtulmasını İstiyoruz:

- **Hilt (Dependency Injection - Bağımlılık Zerk Eden Sistem):** [https://dagger.dev/hilt/](https://dagger.dev/hilt/)
  - *Sebep:* ViewModel'in veya Repository'in kendi içinde gidip "Retrofit ve Database Objesi Üretmemesi" için, dışarıdan (Hilt/Dagger) enjekte edilmesi gerekir. Test Edilebilen kod yazmanın ZORUNLU Mimari Katı Standardı'dır. Otonomi `@HiltAndroidApp` ve `@Inject constructor` kullanımını emsal alır.
- **Room Database (Local Cache):** [https://developer.android.com/training/data-storage/room](https://developer.android.com/training/data-storage/room)
  - *Sebep:* Çıplak SQLite Query'lerini önleyen Google ORM Katmanı. İnternet kesilse bile verilerin ekranda Flow ile pürüzsüz aktığı Offline-First standardı sağlar.
- **Retrofit & Moshi/Gson:** [https://square.github.io/retrofit/](https://square.github.io/retrofit/)
  - *Sebep:* Kapsamlı (REST API) Asenkron bağlantılarının JSON dönüşüm arabirimi.

---

## 🖼️ 3. UI, Animasyon (120 FPS) ve Görüntü Mimarları

Ekrana saf XML koyup bırakılmaz, "Memory Caching (Resim Havızası)" Otonom Koruma Kalkanıdır:

- **Glide (Google Recommendation for Caching):** [https://bumptech.github.io/glide/](https://bumptech.github.io/glide/)
  - Profil Avatar'ları (`"url.png"`) vs yüklenirken RecyclerView Listelerinde Memory Şişmesini önleyen otonom Cache/Resim Yükleyici Kütüphanesi.
- **Lottie Android (Performans Animasyonları):** [https://github.com/airbnb/lottie-android](https://github.com/airbnb/lottie-android)
  - Kaba SVG veya Gif'lerin yerini alan; Adobe After Effects Çıktılarını (Animasyonlu Check marklar, Loading spinnerlar) cihaz GPU'sunu sömürmeden renderlayan .json animasyon pultu.

---

## 🚀 4. Gelişmiş Coroutines (Thread) ve Güvenlik Birlikleri

Yapay zeka sadece kod üretmez; Cihazın Main Thread'ini donmaktan saniyeler içinde Alıkoyar!

- **Kotlin Coroutines (Flow, StateFlow, SharedFlow):** [https://kotlinlang.org/docs/coroutines-overview.html](https://kotlinlang.org/docs/coroutines-overview.html)
  - Uygulama içinde sonsuz donguler Veya 10 Saniyelik Ağ İsteikleri (I/O Operations) yapildiginda Ajanın O isi Main Threadden Kesip `Dispatchers.IO` ipligine GONDERDIGI DEVASA ASENKRON MIMARISIDIR!
- **EncryptedSharedPreferences (Jetpack Security):** [https://developer.android.com/topic/security/data](https://developer.android.com/topic/security/data)
  - Kullanici Login oldugunda Gelen JWT Toke'u Normal "SharedPreferences" icine dümdüz String olarak kaydetmek GUVENLIK ACIGIDIR! Rootlu bir cihazda aninda okunur! Otonomi Kurumsal kalitede "EncryptedSharedPreferences" kullanarak Bu Tokelari AES Sifrelemesi ile Gizler. Cihaz calinip rootlanani bile Hackenemez!!

Yapay Zeka bu Otonom Klasör Sistemlerinin (01, 02.. 06) tamımına hakim olduktan sonra Geliştirdiği Android/Kotlin ürünü Endüstriyel seviye Pürüzsüzlüge (App Crash-Free Rate: %99.9) Ulasacaktır! Hemen Çizime Baslanabilir.
