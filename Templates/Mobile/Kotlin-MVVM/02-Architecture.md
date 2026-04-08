# 2️⃣ Kotlin & MVVM - Mimari Zırh ve Katmanların İzolasyonu (Clean Architecture)

> **MİMARİ KIRILMA UYARISI:** Bir Otonom veya insan, eğer bir Android Fragment (`HomeFragment.kt`) içine girip de Sunucudan API Çekimi (Retrofit), Sayfanın Buton Tıklamaları, Kullanıcı Giriş Logic'i ve Form Doğrulama kodlarını BİRLİKTE (Art arda tek dosyada) YAZMIŞSA o Kod ÇÖPTÜR. Spagettidir, test edilemez ve telefonu Memory Leak ile öldürmeye mahkumdur! Tüm katmanlar bıçak gibi MVVM standartlarına bölünmek ZORUNDADIR!

---

## 🏛️ 1. Uygulama Katmanları (M-V-VM Ayrışması)

Google'ın (Android Jetpack) modern uygulama geliştirme önerisi (Guide to app architecture) Çift yönlü veri bağlamalı ve tek yönlü veri akışlı (Unidirectional Data Flow) Model-View-ViewModel Mimarisi'dir!

### 🔹 Model / Data Layer (Veri ve Hakikat Katmanı)
* **Repository (Veri Deposu):** Dış dünya ile iletişim kuran KÖR işçidir. İnternetten veya Room Database'den veriyi alır, bunu Saf Kotlin Nesnesine (Data Class) çevirir ve ViewModel'e ulaştırır.
* **Katı Kural:** Bu katman `Context`, `Activity`, Veya Android OS eklentisi BİLEMEZ! Sadece Business Models döner.

### 🔹 ViewModel Layer (Beyin Merkezi)
* **Sorumluluğu:** Projenin MANTIK kalbi. Çekirdek Saf Kotlin kodlarıdır. Repository'den (Data) veriyi ister (Coroutines `suspend` metotlarla), Cihazın Ağında veri gecikirse Loading (Yükleniyor) State'i fırlatır, Veri gelince Success State'i fırlatır.
* **YASAKLAR (KRİTİK):** ViewModel'in kurucu parametresine (`constructor`) gidip de bir Otonom Zeka `Context` VEYA `View` REFERANSI ATAYAMAZ!!! (Bu yapılırsa Fragment ölse bile ViewModel onu referans gösterdiği için Hafızada Asılı kalır ve devasa Memory Leak başlar!).

### 🔹 View Layer (UI, Fragment/Activity)
* **Sorumluluğu:** Sadece Ekrana Çizim yapar ve ViewModel'deki `StateFlow`'ları (veya LiveData'ları) "Observe" eder (Dinler).
* **Katı Kural:** View (Fragment) Kendi kendine gidip `Retrofit.api.getUsers()` diyemez! UI Katmanı aptaldır, sadece ViewModel `state.value = Loading` yaptığı için ProgressBar'ı Görünür (`View.VISIBLE`) Yapar. 

---

## 🔄 2. State Management (Durum / Bellek Yönetimi) ve StateFlow Gücü

Android dünyasında eski "LiveData" yavaş yavaş terk edilmeye başlandı, Modern Kotlin otonomisi **`StateFlow` ve `SharedFlow`** üzerine inşa edilir!

* **ViewState Mimarisi:** UI Ekrana yüzlerce farklı LiveData dinletilemez. Otonom ajan her sayfa için bir `Sealed Class (UiState)` yaratmalıdır.
  ```kotlin
  // OTONOM MİMARİ DOĞRUSU
  sealed class HomeUiState {
      object Loading : HomeUiState() // ProgressBar çiz
      data class Success(val products: List<Product>) : HomeUiState() // Datayı çiz
      data class Error(val message: String) : HomeUiState() // Toast-Snackbar fırlat
  }
  ```
* **Dinleme (Collection) Tehlikesi:** Flow'lar arka planda sürekli veri pompalar. Eğer sayfa arkada kapanmış ama Flow hala çalışıyorsa CPU tüketimi devasa boyuta ulaşır. Otonomi, UI Katmanında dinleme yaparken DAİMA **`viewLifecycleOwner.lifecycleScope.launch { repeatOnLifecycle(Lifecycle.State.STARTED) { ... } }`** (veya collectAsStateWithLifecycle) bloğunu kullanmakla Yükümlüdür!

---

## 🚫 3. YASAKLI İŞLEMLER VE KOD KOKULARI (Android Anti-Patterns)

Otonom Android geliştiricinin yapmaması gereken kodlama katliamları:

1. **❌ Asenkron İşlemi Main Thread'de Boğmak `(NetworkOnMainThreadException)`:**
   ```kotlin
   // FELAKET (Ağ isteği Main Thead'de)
   fun fetchUsers() {
       val response = api.getUsers().execute() // UYGULAMA ÇÖKER
   }
   ```
   *DOĞRUSU:* Otonomi Derhal `viewModelScope.launch(Dispatchers.IO)` (Arka Plan İplikçiği) kanalını açarak işlemi oraya hapseder, değerleri `Dispatchers.Main` ile UI'a yansıtır (Coroutines devrimi).

2. **❌ God Object Activities (Şişman Sınıflar):**
   Bir E-Ticaret sistemini `MainActivity` içine Fragment yapmadan dümdüz dizip Gosteremezsin! Modüler Yapıda her Ekran bağımsız bir Fragment'tir. Navigasyon için `Jetpack Navigation Component` (`nav_graph.xml`) Kullanılarak ekranlar arası paramater geçisi ve animasyonlar otonomca kurulur.

3. **❌ Hardcoded İmaj ve Context Kaçakları:**
   Otonom Zeka `Picasso` Veya `Glide` ile resim çizerken Listelerde `ImageView` referansını asla statik tutamaz. Aksi halde Kaydırıla (Scroll) Listelerde eski resimler hortlar Veya OOM (Out Of Memory Crash) yaşanır! Context her zaman applicationContext veya WeakReference olarak yönetilir!

Bu kurallar Otonom Kotlin Üretiminin İncilidir, mutabıksanız 03 numaralı (Step by step üretim) Dökümanına geçebilirsiniz.
