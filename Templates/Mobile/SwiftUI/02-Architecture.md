# 2️⃣ Apple SwiftUI - MVVM ve Clean Architecture (Mimari Kati Sınırlar)

> **MİMARİ KIRILMA UYARISI:** Apple SwiftUI, eski UIKit (`UIViewController`) yapısının aksine çok agresif bir "Re-render (Yeniden çizim)" motoruna sahiptir. Eğer bir `View` bloğunun (`HomeView.swift`) İçerisinde Ağ isteği atıp (URLSession), dönen JSON'u filtreleyip, Form state'i ile uğraşırsanız, her tuşa başışınızda sistem JSON Parse etmeyi yeniden dener! Bu (God View) mimari bir Katliamdır ve Telefonun CPU'sunu yakar. State ve Data Kesinlikle `ViewModel` arka planına atılmalıdır.

---

## 🏛️ 1. Uygulama Katmanları (MVVM Otonom Doğruları)

Apple cihazlarında Endüstri Standartı Mimarisi (özellikle Clean Code) M-V-VM (Model - View - ViewModel) çerçevesine oturur. 

### 🔹 Model Layer (Domain Özü)
* **Sorumluluğu:** Dış dünyadan JSON gelen kalıpları Swift dillerine uyarlayan saf nesneler (Struct'lar).
* **Katı Kural:** Modellerin (Örn `User`) UI Çizimi VEYA Ağ çağrısı (URL Session) içermesi yasaktır. Kodlamada `Codable` , `Identifiable` ve `Hashable` (Liste çizimleri ve Diffing (fark bulma) için hayati) protokolleri implement edilmek ZORUNDADIR!

### 🔹 ViewModel Layer (Beyin ve State)
* **Sorumluluğu:** Görsel (View) ile Veritabanı/Network arasındaki Köprüyü Yapan BEYİN. Bir class olarak (`final class HomeViewModel: ObservableObject`) yaratılır. 
* **YASAKLAR (KRİTİK):** Swift dilinde bir Class hafızadan Reference Types ile var olur. (Memory Leak üretebilir!). Bu yüzden ViewModel içinde Timer kullanırken Veya Closure (Asenkron Fonksiyon) dönütü alırken `[weak self]` ibaresi ASLA atlanamaz. Ajan Retain Cycle (Sonsuz Döngü Tutunması) bırakamaz!
* **StateFlow:** Sadece Ekrana gidecek veriler `@Published` tagi ile işaretlenmelidir. (Örn: `@Published var products: [Product] = []` ve `@Published var isLoading: Bool = false`). Özel business logic property'leri published yapılmaz (Gereksiz UI çizimine sebep olur).

### 🔹 View Layer (Kör UI ve Rendering)
* **Sorumluluğu:** ViewModel'den gelen `@Published` datalarını takip eden (`@StateObject` veya `@ObservedObject` ile) aptal bir ekrandır.
* **Katı Kural:** Ajan View'in içine mantıksal İf else yığılması yapamaz. Sadece `if viewModel.isLoading { ProgressView() } else { List(viewModel.products) }` şeklinde bir render polisi gibi çalışır.

---

## 🔄 2. Veri Taşıma (Data Flow) Silahları ve ReRender Önlemleri

SwiftUI içinde verinin aktını kontrol eden 5 Property Wrapper Otonom Tarafından ezbere BİLİNMEK ZORUNDADIR:

1. **`@State`:** View'ın ta kendisine ait, Başka kimsenin umursamadığı basit tipler. (Örn: Bu açılır menü (Dropdown) Açık mı Kapalı mı? `true/false`). Models tutulmaz!
2. **`@Binding`:** Üst ekran Alta "Al bu Rengi `@State` değiştirmek için kullan ve bana geri bildir" Demek içindir. (Cift Yönlü).
3. **`@StateObject`:** MVVM kurarkan ViewModel'in İLK kez Yaratıldığı Ana sayfada kullanılır. (Bu obje View yeniden çizilse bile Hafızada YOK OLMASIN diye koruyucu zıh giyer). En mühim kancadır!
4. **`@ObservedObject`:** Daha önce yaratılmış (StateObject olmuş) bir Viewmodel'i Gidip de ALT SAYFAYA (Child View) Parametre olarak taşırken kullanılır. (Kendi Obje Üretemez, var olanı dinler).
5. **`@EnvironmentObject`:** Login olan Kullanıcı verisini 10 sayfa aşağıya tek tek Prop aktarmamak için Sistemin Kökünden Havaya Asılan (Environment) Global objelerdir.

---

## 🚫 3. YASAKLI İŞLEMLER (Swift Anti-Patterns / Crashes)

1. **❌ Ağır İşlemleri Main Thread'te Ezmek!**
   SwiftUI ekranları her zaman Main Thread üzerinde (Aktif akış) render atar. Gidip de JSON okumasını (`Data(contentsOf: url)` senkron), CoreData aramasını View gövdesinde (veya onAppear düz blokta) dondurursan App KİLİTLENİR!
   *DOĞRUSU:* Otonomi Derhal `Task { await viewModel.fetchData() }` bloğunu kurar ve Arkada Task (Concurreny/Actor) mekanizması ile işler.

2. **❌ UI (Kullanıcı Arayüzü) Sınıflarını Ana İpliğe Döndürmeyi Unutmak (`Publishing changes from background thread`)**
   Bir Task başlattın (Ağdan asenkron veri geldi), Sonra gidip `@Published var items` listesini Arka plan (Background) threadindeyken değiştirmeye çalıştın... APPLE PURPLE CRASH EKRAN VERİR: "View değişiklikleri sadece Main Threadde olur". 
   *DOĞRUSU:* Otonomi bunu yapmak için Modern Swift özelliği olarak Sınıfı `@MainActor` olarak işaretlemelidir Veya veriyi güncellerken `DispatchQueue.main.async` a dönmelidir!

3. **❌ İçi İçe `NavigationView` / `NavigationStack` Krizi**
   Bir ekran `NavigationStack` ile yapıldıysa, ondan tıkladığınız alt detaya (Detail View) Giderken Oraya Bir daha NavigationStack KOYAMAZSIN. İç içe geçerse, Geri Tuşu kaybolur ve Üst menüler birbirine biner. En Diştaki dosya Stack kurar, içerdekiler Sadece `NavigationLink` kullanır!
