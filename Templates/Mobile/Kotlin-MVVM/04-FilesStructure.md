# 4️⃣ Kotlin & MVVM - Dosya Mimarisi ve İzolasyon Hiyerarşisi (Files Structure)

> **MİMARİ ZORUNLULUK:** Android Studio bir projeyi yarattığında tüm her şeyi `app/src/main/java/com/sirketadi/projeadi/` isminde ana pakete doldurur. Ancak Otonom (veya Senior) Geliştirici, kodlamaya geçmeden önce S.O.L.I.D prensipleri gereği izolasyonunu Hiyerarşik Klasör (Package) Sistemine çakacaktır! Katmanların (Layer) ne olduğu paketin isminden belli olacaktır.

---

## 📂 Ana Gövde: Modern Katman Odaklı (Layer-first) Klasörleme

Geleneksel Kotlin (Android) App sistemleri modüller arası izolasyon için aşağıdaki katı dizilime %100 uymalıdır. Özellik (Feature) klasörleri yerine Mimari (Domain/Data/UI) klasörleri tercih edilmiştir. (Çok büyük Multi-module projeleri dışındaki Endüstri standardıdır).

```text
/app/src/main/java/com/sirketadi/projeadi
  │
  ├── App.kt                          # Uygulama Başlangıcı (Genelde @HiltAndroidApp burada durur)
  │
  ├── /di                             # [BAĞIMLILIK ENJEKSİYONU] Sadece Hilt/Dagger Kodları
  │    ├── AppModules.kt              # (Provides Retrofit, RoomDB instance gibi tekil oluşturmalar)
  │    └── NetworkModule.kt
  │
  ├── /data                           # [GERÇEK VERİ KALESİ] Dış Dünya Bağlantıları
  │    ├── /remote                    # Sadece Retrofit ve Network Requestleri
  │    │    ├── ApiService.kt         # REST Endpoint arayüzleri
  │    │    └── UserDto.kt            # Gelen json objesi
  │    ├── /local                     # Sadece Cihaz İçi Veritabanı ve RAM
  │    │    ├── UserDao.kt            # Room Database Queryleri (SQL)
  │    │    ├── AppDatabase.kt        # Room Root Sınıfı
  │    │    └── UserEntity.kt         # SQL Tablo gösterimi
  │    └── /repository                # DATA URETİCİLERİ
  │         └── UserRepositoryImpl.kt # Hem lokal hem uzak veriyi okuyan Ana Karar Merkezi
  │
  ├── /domain                         # [BEYİN KALESİ] Hiçbir Android Kütüphanesinin olmadığı Saf Kotlin!
  │    ├── /model                     # DTO'dan dönüşmüş temiz modeller (User.kt)
  │    ├── /repository                # IUserRepository.kt (Kurallar arayüzü)
  │    └── /usecase                   # LoginUseCase.kt (Sadece UI'ın çağırdığı tekil senaryolar)
  │
  ├── /ui                             # [MÜŞTERİ YÜZÜ] Activity, Fragment ve ViewModel'ler!
  │    ├── /auth                      # Alt klasörleme tavsiye edilir
  │    │    ├── LoginFragment.kt
  │    │    ├── LoginViewModel.kt     # O ekrana ait beyin (Asla başka klasörde olamaz)
  │    │    └── AuthUiState.kt        # StateFlow için özel sınıflandırmalar
  │    └── /main                      
  │         ├── MainActivity.kt
  │         └── HomeFragment.kt
  │
  └── /util                           # [YARDIMCI ASKERLER] 
       ├── Constants.kt               # "BASE_URL" veya "API_KEY" Sabitleri
       └── Extensions.kt              # String veya Imageview'e yazılan otonom uzantı modülleri
```

---

## 🎨 XML Kaynak (Resource) İstasyonları ve Düzen Sınırları

Tasarım klasörünün `res/` organizasyonu sadece "koy ve çalıştır" değil; Ölçeklendirilebilir bir dil matematiğidir!

```text
/app/src/main/res
  │
  ├── /layout                       # Tasarımların Yeri (Zorunlu Önek Standardı)
  │    ├── activity_main.xml        # Tüm activityler "activity_" ile başlar!
  │    ├── fragment_login.xml       # Tüm fragmentler "fragment_" ile başlar! (home_fragment DEĞİL!)
  │    ├── item_product_card.xml    # RecyclerView (Satır) öğeleri "item_" ile başlar!
  │    └── dialog_warning.xml       # Custom pop-uplar "dialog_" ile başlar!
  │
  ├── /values                       # Uygulama Teması, Ölçüleri ve Çevirisi
  │    ├── colors.xml               # Hardcoded "#FF0000" YASAKTIR. <color name="error">#FF0000</color>
  │    ├── dimens.xml               # EUI element paddingleri: <dimen name="padding_standard">16dp</dimen>
  │    ├── strings.xml              # Metin çevirilerinin yazıldığı ANA YER. Kod içerisinde 'E-mail Gir' yazılmaz!
  │    ├── themes.xml               # Day (Aydınlık) Mode Stilleri
  │    └── themes.xml (night)       # Dark Mode (Gece) Stilleri
  │
  ├── /menu                         # Navigation Component alt bar (BottomNav) ve Toolbar ayarları
  │    └── bottom_nav_menu.xml      
  │
  └── /navigation                   # Jetpack Navigation Graph Rotaları!
       └── nav_graph.xml            # Tüm ekranların ve okların (Actions) birleştirildiği harita
```

---

## 🚨 Kritik Kurallar ve Kapsülleme Yasakları

1. **`ViewModel` Paket Zorunluluğu:** 
   Otonom Zeka; ViewModel sınıfını alıp `domain` Veya `data` klasörüne Atamaz! ViewModel, UI (Arayüzey) katmanının bir parçasıdır. Her zaman ilgili Activity/Fragment'ın klasörünün Dibinde (Örnek `ui/auth/AuthViewModel.kt`) Korumaya (Package-private veya encapsulated) Alınmalıdır.

2. **Arayüzlerin (Interface) Ayrışımı:**
   `domain` alanına hiçbir şekilde (Kesnlikle İhlal Edilemez Bir Çizgi) `Context`, `LiveData`, veya SQLite Kütüphanesi İthal (Import) EDİLEMEZ. Orası "Uygulamam aslında ne yapıyor?" sorusunun teknoloji bağımsız Kotlin cevabıdır. `UserRepository` interface'i orada durur ki UI, Retrofit mi kullanılıyor yoksa GraphQL mi bilmesin!
   
3. **Hardcoded String ve Renk Yasağı:**
   XML'de Veya Kotlin Componentinde `textView.text = "Giriş Başarılı"` demek, sistem büyüdüğünde İngilizce ekle denildiğinde patlamasına neden olur. `textView.text = getString(R.string.login_success)` şekline çekilerek `values` içinde statikleştirilmek ve Tek elden yönetilmek CİDDİ ZORUNLULUKTUR!
