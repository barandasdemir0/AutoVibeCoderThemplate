# 5️⃣ Kotlin & MVVM - Kriz Yönetimi, Debug İpuçları ve Memory Leak Önleme (Troubleshooting)

> **OTONOM DEBUG KOMUTANESİ:** Android İşletim Sistemi'nin RAM yönetimi devasa sınırlara tabiidir (Memory Restrictions). Yapay Zeka'nın "Çalıştı Bitti" zihniyetiyle yazdığı bir Obje referansı, Fragment ölse dahi hafızada kalırsa Garbage Collector (Çöp Toplayıcı) onu silemez ve cihaz "O.O.M (Out of Memory)" vererek 5 saniye içinde Crash (Çökme) olur. Bu Kılavuz, Otonom geliştiricinin 1 Level (Junior) geliştiriciler gibi aptalca hatalar yapmasını Engelleyen Kriz Savuşturma Kapsülü'dür!

---

## 🛠️ Çekirdek (Core) Yaşam Döngüsü ve Memory Leak (Sızıntı) Savaşları

### 1. `ViewBinding Memory Leak` (Asrın Hastalığı!)
* **Krizin Sebebi:** Fragment ekranlarındaki ViewBinding Objeleri (`private var binding: FragmentHomeBinding`), Fragment'in View'ı öldüğünde (`onDestroyView`) eğer hafızadan DÜŞÜRÜLMEZSE (Null atılmazsa), Ekrandaki tüm Butonlar, TextView'lar ve İmajlar RAM'de ASILI KALIR! Fragment öldü sanırsınız ama arkada bataryanızı yakar (Memory Leak).
* **Otonom Çözüm (Zorunlu Kırmızı Seçenek):** Fragment ViewBinding patterni YALNIZCA şu şekilde kodlanmak **zorundadır**:
  ```kotlin
  private var _binding: FragmentHomeBinding? = null
  private val binding get() = _binding!! // Sadece Valid aralıkta çağrılır

  override fun onCreateView(...): View {
      _binding = FragmentHomeBinding.inflate(inflater, container, false)
      return binding.root
  }

  // EN KRİTİK NOKTA: View Ölürken Binding Yok Edilmeli!
  override fun onDestroyView() {
      super.onDestroyView()
      _binding = null  // RAM'İ AZAD ET!
  }
  ```

### 2. `NetworkOnMainThreadException` (Klişe Sistem Kilitlenmesi)
* **Krizin Sebebi:** Room Database çağrıları veya Retrofit ağ sorguları (Suspend fonksiyonlarla sarılmazsa) `Dispatchers.Main` yani EKRAN CİZİM İPLİKÇİĞİNDE gerçekleşmektedir. Android işletim sistemi ana thread üzerinde yapılan bu I/O kitlemesini (Yani cihazın donmasını) görür görmez cezalandırıp uygulamanın kafasına Rapor çakar.
* **Otonom Çözüm (Zorunlu):** Ajan Ağ veya Disk işlemlerini tetikleyeceği an, ViewModel'den `viewModelScope.launch(Dispatchers.IO)` kanalını açar. `suspend func` keywordu kullanılarak Coroutine Threadlerinde Cihaz Boğulmaktan Kurtarılır.

### 3. `IllegalArgumentException: navigation destination X is unknown to this NavController`
* **Krizin Sebebi:** Jetpack Navigation kullanan geliştirici (veya Otonomi), bir Butona hızlıca iki kez basıldığında VEYA bir navigasyon daha bitmeden (İkinci kez) farklı bir yere yönlendirmeye çalıştığında `navController.navigate()` Çöker! Çünkü mevcut Stack artık o hedefte değildir.
* **Otonom Çözüm (Zorunlu):** Sadece `findNavController().navigate(R.id.action_x)` yazılıp GEÇİLMEZ. Butona çoklu tıklanmasını engelleyen bir Debounce metodu kullanılır VEYA try-catch zırhı eklenerek Otonom yönlendirme CurrentDestination check ile sarılır (`if (navController.currentDestination?.id == R.id.xFragment) { ... }`).

---

## 🎨 UI ve Configuration Change (Cihazı Yan Çevirme) Hataları

### 4. Fragment'ler Arası Dönüşte Veri Kaybı (Null Dönmesi)
* **Krizin Sebebi:** `MainActivity` içindeki bir değişkene veriyi koyup, Telefonu yan çevirdiğinizde o veri `NULL` döner. Çünkü Activity baştan yaratılmıştır (`onDestroy()` -> `onCreate()`). İşletim sistemi RAM tasarrufu için Cihaz yönüne (Orientation) acımaz.
* **Otonom Çözüm (Zorunlu):** Verilerin hepsi YA ViewModel'e konulur (Çünkü ViewModel Config changeslardan etkilenmeyip hayatta kalır), VEYA `onSaveInstanceState` / `SavedStateHandle` objesi içerisine Gömülerek İşletim Sistemi Bundle arayüzüne teslim edilir!

### 5. `IllegalStateException: FragmentManager is already executing transactions`
* **Krizin Sebebi:** Otonomi, Fragment içinde Flow / LiveData okurken asenkron dönen Gecikmeli bir datanın Collector'unda Gidip `FragmentTransaction` ile sayfa açtırmaya çalışmıştır. Ama asenkron yanıtı geldiğinde Kullanıcı Sayfayı Kapatmış bile Olabilir!
* **Otonom Çözüm (Zorunlu):** State Flow Collector'ı Kesinlikle `repeatOnLifecycle(Lifecycle.State.STARTED)` scope'u içinde dinlenir. Aksi halde Ekran Kapalıyken dahi API dönerse, Ekran olmadığından UI manipülasyonu sisteme "Mavi Ekran" fırlatır!

### 6. Obfuscation (R8/ProGuard) Çökmeleri
* **Krizin Sebebi:** Uygulamanızı Yayına (Google Play) Hazırlarken `minifyEnabled true` yaptınız (Boyut Düşürme). R8 aracı kodların içine daldı, Api DTO sınıflarını (JSON çeviricileri) rastgele A, B, C isimlerine Kısalttı! Gelen JSON API "user" kelimesini ararken bulamadı ve Çöktü.
* **Otonom Çözüm (Zorunlu):** Retrofit için yaratılan Model/Dto sınıflarında parametrelerin (Verilerin) Üzerine KESİNLİKLE Pürüzsüz olarak `@SerializedName("user")` Veya Moshi Kütüphanesi ise `@Json(name="..")` Annotation'u Dikilecektir! (Veya `proguard-rules.pro` dosyasına @Keep kuralı eklenecektir).
