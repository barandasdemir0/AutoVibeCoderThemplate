# 1️⃣ Apple SwiftUI (Cross-Apple) - Master Plan ve Ölçeklenebilirlik Sözleşmesi

> **OTONOM YAPAY ZEKA İÇİN KESİN KURAL:** SwiftUI bir kütüphane değil, Apple'ın Declarative (Bildirimsel) O.S çizim kalesidir. UIKit (.xib / Storyboard) tabanlı eski spagetti Objective-C/Swift mantığıyla (Örn: `view.addSubview(button)`) EKRAN ÇİZİLEMEZ! SwiftUI, State ile Re-render olan reaktif bir ekosistemdir. Otonom ajan, bu projenin sadece iPhone'da değil iPadOS veya macOS'ta da çalışabileceği "Multiplatform" doğasını unutmadan Memory ve Performans (60-120 FPS) harikası yaratmak ZORUNDADIR!

---

## 🎯 1. Çekirdek Altyapı Kararı: State ve UI Ayrımı

Eski usül Apple geliştiricileri "ViewController" isimli devasa sınıflara tapardı. SwiftUI ile `UIViewController` KONSEPTİ YOK OLMUŞTUR.

### Otonomi İçin Saf SwiftUI Sınırları:
* **Declarative (Bildirimsel) Çizim:** Ajan "Butonun rengini mavi yap" demez, "Buton, `viewModel.isActive` true ise Mavi, değilse Gri" komutunu yazar. Her şey State Binding (Bağlı Durum) üzerinden tetiklenir.
* **Apple Silicon (M1/M2) ve Concurrency (Eşzamanlılık):** Ağ istekleri yaparken GCD (Grand Central Dispatch - `DispatchQueue.main.async`) gibi bloklu hantal yapılar büyük oranda terk edilmiştir. Otonomi, API call ve Database limitlerinde SADECE Modern Swift `async / await` yapısını veya `Combine` freamwork'ünün publisher sistemlerini kullanmak zorundadır!
* **Memory & View Lifecycle:** Struct olarak tanımlanan bir View, class olmadığı için Reference değil Value type'tır. Sürekli yıkılır ve yeniden yaratılır (Bu yüzden çok hafiftir). Otonomi View içindeki Değişkenleri korumak için ZORUNLU olarak `@State`, Obje korumak için `@StateObject` (iOS 14+) kullanacaktır!

---

## 🔒 2. Data Flow (Veri Akışı) ve Performans Çökmeleri

Apple cihazlarında ekranların hızlı akması "State (Durum)" takibine bağlıdır.

* **Kural 1 (Model Ayrışması):** SwiftUI içine gidip `URLSession.shared.dataTask` YAZILAMAZ! View'ler Kör (Kör UI) olmalıdır. Sadece kendisine dışarıdan ObservableObject olarak sunulan `ViewModel`i (Örn: `@StateObject var vm = HomeViewModel()`) dinler. Asla View içine Ağ veya Disk logic'i GÖMÜLEMEZ.
* **Kural 2 (Derin Prop Aktarımı - Prop Drilling İptali):** Sayfa 1'deki bir veriyi Sayfa 5'e taşımak için aradaki 4 sayfaya gereksiz yere parametre Verilmesi Kırmızı Çizgi İhlalidir! Apple bunun için Environment sistemini kurmuştur. Global veriler `@EnvironmentObject` ile Sisteme `ContentView` levelinden gömülür ve istenen iç sayfana çekilir.
* **Kural 3 (Listelerde Devasa Tıkanıklık):** `ScrollView` içerisine gidip 1000 elemanlı bir `ForEach` yazarsanız, ekran yüklendiği an 1000 element RAM'e basılır ve İşletim Sistemi cihazı kapatır. Otonom ajan Ekranda görünmeyen elementleri RAM'den silen C++ tabanlı **`LazyVStack`** ve **`LazyHStack`** (List/Grid) yapılarını KESİNLİKLE kullanacaktır!

---

## 🚀 3. Ekran Boyutları ve Dynamic Island / Notch Adapte (Responsive UX)

Apple Ekosistemi iPhone SE ekranından, 12 inç iPad ekranına kadar varyasyon sergiler.

* **A. Safe Area İtaati:** 
Tepede Dynamic Island var. Aşağıda Home Indicator bar var. Otonomi Tasarımı Çizerken `edgesIgnoringSafeArea(.all)` kullanıp bütün elementleri işletim sistemi bildirimlerinin altına gömemez (Sadece tam ekran resimler veya haritalar içindir). Varsayılan Safe Area saygısı esastır.
* **B. GeometryReader Tuzağı:**
Responsive yapmak için her yere `GeometryReader` koymak Ekranin durmadan Re-render olmasina ve kilitlenmesine neden olur. Çoğu durumda VBox/HBox içindeki `Spacer()` ve `.frame(maxWidth: .infinity)` komutları Ekran genişliğini kaplamak için mükemmel optimizasyon yaratır, GeometryReader sadece Cok extreme animasyonlarda (Scrolling offset olcme) kullanılmalıdır!
* **C. SF Symbols Mührü:** 
"Geri, ayarlar, çarpı" gibi ikonları App'in içine .png olarak YÜKLEMEK YASAKTIR. Yapan ajan kovulur. Apple, Dünyanın en gelişmiş vektörel ikon kütüphanesini işletim sistemine gömmüştür. Sadece `Image(systemName: "gearshape.fill")` çağrıları kullanılacaktır. (Ağırlık = 0 mb).

Bu iOS sınırlarına (Protocol-Oriented hedefler, Swift 5.9+ özellikleri) riayet edecek Ajana direkt Mimari Ayrışma (02) dosyasına geçiş izni verilmiştir.
