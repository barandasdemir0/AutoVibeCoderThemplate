# 3️⃣ Apple SwiftUI - Adım Adım Üretim ve Yürütme Algoritması (Step By Step)

> **OTONOM EYLEM VE YÜRÜTME KILAVUZU:** Native Apple cihaz ekosisteminde projelendirme (Workspace yapısı) ve API bağlamaları (Async) esnasında aşağıdaki 15 Kritik Kodlama Adımı, Otonom sistem tarafından **Şaşmaz/Kestirme Kullanılmaz** şeklinde işletilmelidir.

---

## 🛠️ BÖLÜM 1: İnşaat İskeleti ve Güvenlik Ağları (Adım 1 - 4)

### Adım 1: Projenin Kök Girdisi (`App.swift` Konfigürasyonu)
Proje çalıştırıldığında UIKit'den kalma `AppDelegate` VEYA `SceneDelegate` artık ana çatı olmadığı için, `@main struct MyApp: App` dosyası kontrol edilir. CoreData, Firebase gibi harici bağımlılıkların motorları (initialization) buradaki `init()` bloğunda VEYA En dıştaki `ContentView().environmentObject()` sarıcıları (wrapperları) olarak ayarlanıp mühürlenir.

### Adım 2: Info.plist Bağlamları (Cihaz İzin Zırhları)
Uygulamanın Ağı (Local Network), Kamerayı (Camera), veya Konumu (Location) isteyip istemediğini analiz et! Apple Müşteri Gizliliğinde affetmez. Otonomi, koda Sensör API'si koyduğu an otomatik olarak Target Info ayarlarına `NSCameraUsageDescription` gibi String "Gerekçeleri" ekler (Örn: "Selfie çekmek için gerekir"). Bu atlanırsa uygulama derlense dahi App Store Review (İnceleme) anında RED (Reject) edilir.

### Adım 3: Localizable.strings (Çoklu Dil Hazırlığı)
SwiftUI dünyasında metinler asla Hard-coded (`Text("Hello")`) bırakılmaz! Otonomi ilk dosya işi olarak bir `Localizable.strings` yaratır. Kullanılacak Bütün yazılar `"login_btn" = "Sign In";` şeklinde Anahtar-Sözcük eşleşmesine bağlanır ve Her metin `Text(String(localized: "login_btn"))` formülünden ekranda Draw edilir.

### Adım 4: Model/Katman (Folders Structure) Fiziksel İzolasyonu
Projede Spagettiye düşmemek adına klasör yapısı (Xcode Groups); `Models`, `ViewModels`, `Views`, `Services`, `Utils` veya Kurumsal "Özellik Bazlı" olacak şekilde (Örn: `Features/Auth/`) Yaratılır. Bomboş olsa bile klasörlerin oluşturulması Şattır.

---

## 🧠 BÖLÜM 2: Veri Omurgası ve Beyin Sistemi (Adım 5 - 8)

### Adım 5: Modellerin Codable ve Identifiable ile Deklarasyonu
Api'den JSON okumak veya CoreData verisi basmak için Modeller (Struct Object) yazılır. Mutlaka `@Identifiable` protokolüne eklenirler (içinde `let id = UUID()` Veya `let id: Int` olmak DOĞASIDIR). Cünkü List( ) componenti sadece Identifiable Objeleri looplayabilir (Döndürebilir).

### Adım 6: Ağ Modülü Kurulumu (Modern Async/Await Singleton)
Alamofire gibi 3. Parti ağır paketlere kaçmadan Native Otonomluk: `URLSession.shared.data(from: url)` kullanılarak REST Cihazı (NetworkService/APIService) inşa edilir. Callback/Closure cehennemleri (`completion(result)`) yasaktır. Modern Apple konsepti olan `async throws` fonksiyonlar Otonomi için mecburi kılınır.

### Adım 7: Veri Kütüphanesi ve Repository Külliyati 
Network Service'in çektiği "Ham Json'u" alıp Uygulamanın İş (Business) kurallarına süzdüğü `Repository` sınıfları Protokoller (`protocol IProductRepository`) ile bağımsızlaştırılır. Bunun Amacı; "Gelecekte AI bu projeye Test Yazarsa" (Mock test verisi), Ana kod kırılmadan kolayca Enjekte (Dependency Injection) yapabilmesidir.

### Adım 8: MVVM - ViewModel Mimari Sınıfının Bağlanması
`@MainActor` anotasyonu ile tetiklenen sınıflar (class) Mühürlenir. ViewModel Cihazın iş ipi kopmasın (Main Thread patlamasın) diye Data Fetch (Çekim) işlemine girildiği an `self.isLoading = true` yapar, işlem bittiğinde veya `catch`'e düştüğünde loadingi durdurur veriyi yansıtır.

---

## 🎨 BÖLÜM 3: Müşteri Yüzü Ekrana Çizimi (Adım 9 - 13)

### Adım 9: View Component (UI) Reusable Çizimler
SwiftUI ile sayfa kodlanırken 300 Satır Tek Dosya Yasak! Kendi kendine çalışabilen `CustomButtonView(title: "x", action: .. )`, `ProductCardView()` isminde küçük parçalar yazılır. Parametre aktarımıyla bir ekrana dizilmeleri saglanır (LEGO modülü gibi). 

### Adım 10: Rota (Routing) Kalkanı 
SwiftUI içinde en sinir bozucu yer Navigasyondur. Otonom yapıyı; Eğer sürüm (OS Limit) iOS 16+ ise modern yapi **`NavigationStack`** ve **`NavigationPath()`** zerk ederek kurgular. Eski sürümse `NavigationView` ile idare eder Ancak Path'leri Arrayler Üzerinde Takip eder. Bu şekilde State Üzerinden (Deeplink) Yönlendirme Kontrol altına alınır.

### Adım 11: Liste ve Lazy Mimarilerinin Kurulumu (FPS Tıkanıklık İlacı)
Otonom araçlar 500 elemanlık liste döndürüyor ise `VStack { ForEach }` YAZAMAZ (FPS ÖLÜR, CİHAZ YANAR). ZORUNLU OLARAK `ScrollView { LazyVStack { ... } }` kurgusuna yerleştirir! Gözükmeyen objeler hafızaya alınmaz.

### Adım 12: Saf OS Tuş, Klavye Yönetimi ve Alert Gösterimi
Error (Sistem Bulunamadı vs) hatası gelirse `@State private var hasError = false` izleyicisiyle UI `alert(isPresented: $hasError)` Veya modern Popups atar. Eğer Formlarda Metin giriliyorsa `.ignoresSafeArea(.keyboard)` Koruması ve Spacer ile UI'ın klayve Altında EZİLMESİNİ ENGELLER.

### Adım 13: Caching, AsyncImage (İmaj Sızıntılarının Giderilmesi)
Eğer Dış Link'ten Foto çekiliyorsa Otonomi dümdüz `AsyncImage(url:)` verebilir, ancak Liste de (Gidip gelindikçe) Resimler YENİDEN INTERNETTEN çekildiği için KOTA (Telefon Paketi) ve Memory biter. Caching Kurgusu içeren Modüller Tasarlanmalı VEYA `SDWebImageSwiftUI` Kullanılmalıdır.

Eğer bu adım-adım talimatlar anlaşıldıysa, Dosya mimarisinin ve klasörlerin izole edilmesinin kurallarına (Döküman 04) geçilebilir.
