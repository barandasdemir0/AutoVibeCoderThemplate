# 2️⃣ Native Mobil - MVVM (Model-View-ViewModel) Mimarisi

> **MİMARİ KURALI:** Eğer bir Ekran Dosyasında (`LoginView.swift` veya `LoginScreen.kt`), Veritabanına (CoreData / Room) İnsert Atıyorsan VEYA Ağ İstekleri İçin URLSession/Retrofit Kullanıyorsan Proje Mimarisi ÇÖPTÜR. Native Cihaz Geliştirmesinde **(Stateful Views YASAKTIR)**.

---

## 🏛️ 1. Mükemmel İzolasyon (MVVM Yapısı)

Otonom Yapay Zeka bir Ekran Tasarlıyorsa Bu Ekranı Düzenlemek için Gerekli Olayların Tümü View Tarafına Yazılmaz! Native Evren **MVVM (Model-View-ViewModel)** kuralıyla Yaşar!.

### A. View Katmanı (Aptal Ekran - UI)
Asla Veri Hesaplamaz! Butona Basıldığında Mı? Gider ViewModel'deki Özelliği (Methodu) Tetikler. Gelen Veriyi Şekil (Grafik) Yapar!.
```swift
// SwiftUI View Örneği (İSKELET SADECE)
struct ProductListView: View {
    // EKRNIN BEYNI (ViewModel) BURADAN BAGLANIR
    @StateObject private var viewModel = ProductListViewModel()
    
    var body: some View {
        List(viewModel.products) { product in
            ProductRow(product: product)
        }
        .onAppear {
            viewModel.fetchProducts() // ÇEK METODU BURADAN VURULUR (UI BASLARKEN)
        }
    }
}
```

### B. ViewModel Katmanı (İş Mantığı ve Proxy)
Burası Test Edilebilir olan yerdir. AĞ İsteklerini Servise Paslar, Arrayleri UI'ın Anlayacaği Formata çevirir (Data Binding).
```swift
// SwiftUI ViewModel (Ekranın Zekası)
@MainActor // Değişiklikler UI Yansıdığı İçin MainThread de Olmalı!
class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = [] // BUNA VERI DEGISTIKCE UI YENILENIR!
    @Published var isLoading = false
    
    private let apiService = ApiService() // Dış dünyayla etkileşim Modülü
    
    func fetchProducts() {
        isLoading = true
        Task {
            do {
                self.products = try await apiService.getProducts()
            } catch {
                // HATA STATE YÖNETİMİ
            }
            isLoading = false
        }
    }
}
```

---

## 🏗️ 2. Veri Taşıyıcıları (Model) Katmanı
Otonom Zeka Sunucudan Gelen JSON Verisini Doğrudan Dictionary Veya "Any" Olarak SAKLAYAMAZ. Typescript Interfacelerinin Daha da KATI halidir.

* **Swift (Decodable Kuralı):** Sunucudan Json dönüyorsa, O Json Yapısı Mutlak Bir Struct (Model) Olarak Tasarlanmalı Ve `Codable` Interfaceini İmplement Etmelidir. Aksi Halde Json Parse (Okuma) Aşaması Runtime'da Patlar.

---

## 🚫 3. YASAKLI İŞLEMLER (Native Anti-Patterns)

1. ❌ **God Class / God View (Amele Ekranı) YASAĞI:**
   Tüm Login Kutularını (Inputlar), Başlığı, Alt Resimi (Süsleri) Ve Kayıt Olma CheckBox'ını AYNI Z DOSYA Icersine (Listelern) Düzenlerseniz; XCode veya Android Studio Derleyicisi O Sayfayı Derlerken Isınmaktan YARIILIR (Compile Time Uzar). 
   *DOĞRUSU:* Otonomi Kodu Her Zaman **Küçük Structlara (Modüllere)** ayıracaktır! (`CustomTextFieldView`, `LegalTextRow`).

2. ❌ **Memory Kapanımları (Retain Cycles - Kaçaklar):**
   Bir Buton İçinde Tıklama Methodu Tanımlanırken Swift İçerisinde `self` (Class Referansı) Kullanılıyorsa Otonom Zeka ŞUNU UNUTAMAZ: Asenkron (Closure) İşlemlerin İçerisinde EĞER `[weak self]` KULLANILMAZ İSE: Ekrans Kapandığı Halde Bile O Class RAMDEN SİLİNEMEZ! Çünkü Arka planda Metod Sayfayı Tutar!! Mükemmeliyetçi Zeka Zayıf Referanlamayı (Weak) Asla UNUTMAZ.
