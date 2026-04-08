# 3️⃣ Kotlin & MVVM - Adım Adım Üretim ve Yürütme Protokolü (Step By Step)

> **OTONOM EYLEM VE YÜRÜTME KILAVUZU:** Native Android ekosistemi yapısı gereği Gradle senkronizasyonlarına (Build süreçlerine) bağımlıdır. Yapay zeka ajanları (Otonom) veya insan geliştiriciler, projeyi sıfırdan oluştururken aşağıdaki 15 Kritik Adımı "Harfiyen ve Sırasını Bozmadan" takip etmek ZORUNDADIR. Paket yönetimi yapılmadan ve AndroidManifest izinleri açılmadan kod yazılamaz.

---

## 🛠️ BÖLÜM 1: Çekirdek Kurulum ve Bağımlılıkların İnşası (Adım 1 - 4)

### Adım 1: Gradle Konfigürasyonu (build.gradle.kts)
İlk eylem, Android Studio veya CLI üzerinden yaratılan boş projenin `build.gradle.kts` (App level) dosyasına dalmaktır. Otonom ajan, ViewModel, LiveData, Coroutines, Retrofit, Glide, Hilt (veya Dagger) ve Room Database gibi kritik kütüphanelerin güncel versiyonlarını dependecies bloğuna ekler ve mutlaka **Sync Now (Senkronizasyon)** işlemi olduğunu varsayarak devam eder. ViewBinding özelliği açılmak Zorundadır:
```kotlin
buildFeatures {
    viewBinding = true
}
```

### Adım 2: Manifest ve Güvenlik İzinleri
İnternet bazlı modern bir uygulama `AndroidManifest.xml` içerisine `<uses-permission android:name="android.permission.INTERNET" />` iznini kazımadan asla çalışamaz. Yapay zeka bunu en başta yapar (Offline crash yememek için). Eğer uygulama Local host (HTTP) ile test ediliyorsa `android:usesCleartextTraffic="true"` bayrağı Application tag'ına otonomca yapıştırılır.

### Adım 3: Çoklu Dil (i18n / Localization) Sisteminin Mühürlenmesi
Hardcoded (Elle yazılmış statik) UI metinleri (Örn: `android:text="Giriş Yap"`) kalmak YASAKTIR. `res/values/strings.xml` açılır, varsayılan İngilizce ve hedeflenen Türkçe vs diller için `res/values-tr/strings.xml` kopyaları oluşturularak çeviri mimarisi inşa edilir. Java/Kotlin sınıflarında da stringler sadece `getString(R.string.login)` ile çağrılır.

### Adım 4: Klasör (Feature/Domain-Driven) Ağacının Köklerinin Atılması
`app/src/main/java/com/sirketadi/projeadi/` dizini altına `data/` (Ağ ve veritabanı kurguları), `di/` (Dependency Injection ayarları hilt Modülleri), `domain/` (Modeller) ve `ui/` (Ekranlar ve viewmodellar) ana hiyerarşisi oluşturulur. Kodlamaya hazırız.

---

## 🧠 BÖLÜM 2: Veri Kalbi ve Mimari Enjeksiyonlar (Adım 5 - 8)

### Adım 5: Modellerin (Domain Entities) Yaratımı ve DTO Yapısı
Veritabanından gelecek JSON kalıpları için Data Class'lar üretilir (Örn: `data class User(val id: Int, val name: String)`). GSON veya Moshi paketi için `@SerializedName` fieldleri yerleştirilir. 

### Adım 6: Retrofit Network Singleton ve Interface Kurulumu
State yönetimini bulaştırmadan SADECE dış dünyaya REST call yapacak olan `ApiService.kt` (interface barındıran) dosya yaratılır. Retrofit objesi `ApiClient.kt` gibi bir dosya altında Singleton (Tek nesne) VEYA modern projelerde **Hilt/Dagger** modülü (`NetworkModule.kt`) üzerinden Singleton component olarak sisteme sağlanır (Provide).

### Adım 7: Repository Sınıfları ve Offline-First Room DB (Veri Kaynağı Erişimi)
Tüm istek atıcı metotlar Repository Katmanına (`UserRepository`) gizlenir. Gelişmiş otonom kurguda; eğer Offline-first isteniyorsa, gelen API yanıtı direkt Room Veritabanına (Local) fırlatılır, Repository dışarıya Local Database'deki verileri (Flow Observer ile) kusar. Bu kural veriyi inanılmaz sağlamlaştırır. (Codelabs: Single source of truth kuralı).

### Adım 8: MVVM - ViewModel Katmanının Çizilmesi
UI'da Butona basıldığında tetiklenecek `ViewModel.kt` sınıfları yazılır. State kurguları (`MutableStateFlow(UiState.Loading)`) ayarlanır. Repository `viewModelScope.launch` bloğu içinde çağrılırılır ve işlem Coroutine Dispatcher.IO (Arkaplan thredi) ile işlenir.

---

## 🎨 BÖLÜM 3: Müşteri Yüzü (UI / UX), Entegrasyon ve Rota (Adım 9 - 13)

### Adım 9: XML Çizimi, Sabitler ve Temalandırma (Theme/Dimens/Colors)
UI Cizim adımları başlar. `res/layout` içerisinde (Sectiğimiz ConstraintLayout ile) devasa Margin/Padding farkları gözetilerek form oluşturulur. Çizimlerde `16dp` gibi sabit sayılar yerine `@dimen/margin_default` referansı ve `Colors.xml`'den çekilen Material 3 uyumlu primary/secondary renkleri zerk edilir. Arayüzün Gece (Dark Mode) Modunda patlamaması için Text'lere özel `textColor` atamalarından kaçınılır.

### Adım 10: Fragment / Activity Entegrasyonu ve ViewBinding!
Kotlin tarafına asıl bağlama yapılır. Otonomi, `Activity.onCreate` VEYA `Fragment.onViewCreated` metodunun açılışını yapar. İlk iş `binding = FragmentHomeBinding.inflate(...)` ile görselleri koda kilitler! 

### Adım 11: CollectState (Dinleyici) İşleyişi
Otonom ajan ekranda Loading mi? Data mı? Olasılığını ViewModelden dinlemek için şu komut kalıbını ekler:
`lifecycleScope.launch { viewLifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) { viewModel.uiState.collect { state ->  ... } } }`.

### Adım 12: Listeler (RecyclerView) ve Adaptörleri
Eğer ekranda bir ürün dizisi/listesi varsa, `RecyclerView` konfigüre edilir. Yeni bir Kotlin dosyası olan Otonom bir Adapter (tercihen ListAdapter ve DiffUtil performansı korunarak) üretilir. RecyclerView'ın adaptoru set edilir ve UI'dan listeye veri basılır (`adapter.submitList(data)`).

### Adım 13: Cihaz Donanımı Tuş Savunması ve Navigasyon Bağlamı
Ajan sadece Activity'lere Intent yazarak projeyi kirletmez. `Jetpack Navigation Graph (nav_graph.xml)` üzerinden ekranlar arası geçişleri tetikler (SafeArgs plugin'i üzerinden Parametreler tip güvenli taşınır). Cihaz Geri/Back tuşu dinleyicisi eklenir (`OnBackPressedCallback`), Kaydedilmemiş form varsa kullanıcı tuşa basınca Uyarı (Save Before Exit) verdirilir.

Eğer bu adım-adım talimatlar eksiksiz tamamlanıp uygulandıysa, Dosya mimarisi için Döküman 04'e ilerlenebilir.
