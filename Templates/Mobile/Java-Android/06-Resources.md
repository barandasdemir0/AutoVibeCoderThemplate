# 06-Resources (Kütüphane ve Kaynaklar Otonom Rehberi)

> **OTONOM ARAŞTIRMA BÖLGESİ:** Java/Android ekosistemini (Özellikle modern API seviyelerini) ezberden sıfırdan kurmak bazen hatalara neden olabilir. Yapay Zeka, kodlama sürecini zenginleştirmek veya limitasyonları / kullanım biçimlerini hatırlamak isterse aşağıdaki endüstri-standartlarındaki kütüphane ve dokümantasyon merkezlerini otonom bir referans olarak referans alacaktır.

---

## 🏛️ 1. Temel O.S (İşletim Sistemi) Katmanı ve Architectural Components

Native bir kod çıkartırken ilk referansımız `Google` ve standart Android SDK/Jetpack kalkanlarıdır:

- **Android Developers Resmi Platformu:** [https://developer.android.com/](https://developer.android.com/)
  - *Ne İşe Yarar:* Özelliklerin güncel SDK/API (Örn Android 14 API 34+ değişiklikleri) gereksinimleri, tehlikeli izin (Dangerous Permission) yönetimleri buradan bakılır. (Ajan: Runtime permission değişiklikleri için "Requesting permissions" sayfasını uygula).
- **Android Architecture Components (Jetpack Room & Lifecycle):** [https://developer.android.com/topic/libraries/architecture](https://developer.android.com/topic/libraries/architecture)
  - *Ne İşe Yarar:* Eski SQL helper kütüphaneleri (SQLiteOpenHelper) terkedildi. Yerel Veritabanı kullanılacağı an Otonomi direkt `Room Database` (ORM) yapısını uygulayacak. 

---

## 🌐 2. Network ve API Taşıyıcıları (Senkronizasyon)

Uygulamanın dış dünyayla bağlandığı en kritik kas burasıdır. Asla manuel `HttpURLConnection` ZUHALLEŞTİRİLİP KULLANILMAZ!

- **Retrofit2 (Yönlendirici):** [https://square.github.io/retrofit/](https://square.github.io/retrofit/)
  - RESTful API bağlamaları için Type-Safe HTTP client'tır.
- **OkHttp3 (Alt Motor):** [https://square.github.io/okhttp/](https://square.github.io/okhttp/)
  - Retrofit'in kullandığı asıl motor (Interceptor eklemek veya TimeOut belirlemek için okhttp3 OkHttpClient kullanılır).
- **Gson / Moshi:** 
  - Json Parsers. Eğer Null alanları veya Default Value'ları yutarken hatalar veriyorsa, `@SerializedName` yerine modern `Moshi` kütüphanesi otonomca tercih edilebilir.

---

## 🖼️ 3. Görüntü İşleme, UI ve Animasyon Enstrümanları

- **Glide (Google'ın Tavsiyesi - Hızlı Loading):** [https://github.com/bumptech/glide](https://github.com/bumptech/glide)
  - İnternetten Avatar (`"https://vibe.com/img.png"`) yüklerken ImageView içine doğrudan entegre olan caching yöneticisi. Cihaz hafızasını O.O.M (Out of Memory) crashlerinden koruyan yegane güç. (Kullanımı: `Glide.with(context).load(url).into(imageView)`)
- **Picasso (Square):** [https://square.github.io/picasso/](https://square.github.io/picasso/)
  - Glide'in bir alternatifi, daha küçük boyutta ama özelleştirmesi kısıtlı.
- **Lottie (Airbnb):** [https://github.com/airbnb/lottie-android](https://github.com/airbnb/lottie-android)
  - Dönen eski loading barları unutun. Kırmızı çizgi! Profesyonel Loading Ekranları / Başarı Animasyonları (Success tıkları) için AfterEffects çıkartısı olan `.json` Lottie animasyonları kullanılmalıdır. Projeye Premium his verir.

---

## 🎨 4. Tasarım Merkezi (Material 3 - Material You)

- **Material Components for Android:** [https://github.com/material-components/material-components-android](https://github.com/material-components/material-components-android)
  - Uygulama `themes.xml` dosyasında `Theme.Material3.DayNight.NoActionBar` VEYA benzeri bir Material3 kalkanıyla doğmak zorundadır.
  - Basit bir Edittext yerine `TextInputLayout` ve `TextInputEditText`, basit köşeli buton yerine `MaterialButton(app:cornerRadius="12dp")` mimarisi kurmak için yapay zeka buradaki spesifikasyonları emsal kabul edecektir.
- **Google Fonts (Tipografi):**
  - OS'in düz "Sans" fontu, 21. Yüzyıl uygulamalarında kabul edilemez! Otonomi `res/font/` klasörüne `Inter` veya `Oswald` font family'si yaratıp, AppTheme içinde `<item name="android:fontFamily">@font/inter_regular</item>` entegrasyonu kurmakla mükelleftir.
---

## 🛡️ 5. State (Durum) ve Event (Olay) Dinleyicileri (İleri Düzey)

- **EventBus (GreenRobot):** [https://github.com/greenrobot/EventBus](https://github.com/greenrobot/EventBus)
  - Activity A'da bir ayar yapıp, taa arkadaki Activity C'nin menüsünü veya profilini güncellemek gerektiğinde (Arada köprü yoksa) yayınla (publish) / kaydol (subscribe) metodlarıyla anlık State güncellemelerini kurtarır.
- **RxJava2/3 (ReactiveX):** [https://github.com/ReactiveX/RxJava](https://github.com/ReactiveX/RxJava)
  - "Bu butona kullanıcı çift mi tıkladı? O zaman 500ms debounce (beklet) koy da API iki kez gitmesin..." dediğimiz ileri seviye Akış (Stream) senaryoları varsa kullan. Aksi halde Callback'ler ve Java ExecutorService fazlasıyla yeterli olacaktır.
