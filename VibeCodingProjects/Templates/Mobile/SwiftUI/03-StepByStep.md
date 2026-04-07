# 3️⃣ Native Mobil - Adım Adım App İnşası (Step-By-Step)

> **YAPAY ZEKA ÇALIŞMA ALGORİTMASI:** Native kodlama Script yazmaya benzemez, Build Setuplarını otonom zeka en baştan kurmazı lazım. Paket Yöneticiler (SPM GİBİ) veya Gradle Ayarları (Android) Projenin DNA'sını Verir!.

---

## 🛠️ Aşama 1: Konfigürasyon ve Paket Yöneticileri (Dependencies)
1. **iOS (SwiftUI):** Otonom Zeka projeyi XCode formatında inşaa ederken Podfile yerine Yeni Nesil "Swift Package Manager (SPM)" mimarisi İle Dış kütüphaneleri (Alamofire, Kingfisher vb) Yükler.
2. **Android (Kotlin):** Otonom Zeka `build.gradle.kts` (Kotlin Script Formati) Dosyasına Dalıp Jetpack Compose, Retrofit ve Coroutines Dependencies (Bağlantılarını) Sızdırmazlık kurallarıyla Çakar!

---

## 🗄️ Aşama 2: Theming (Renk Tasarımı) ve Assets Kayıtları
1. Mobil projenin Kötü görünmesine Fırsat Verilemez! Dark mode Ve Light mode Desteklenmelidir (Otonomun İçgüdüsü).
2. iOS'ta `Assets.xcassets` klasörüne, Android'de ise `res/values/colors.xml` (veya Compose Theme.kt) İçine Kurumsal Renk Paletleri Değişken Olarak Asılır!!. Tasarım Hardcode (Statik `#FF00`) verilmez!.

---

## 🧬 Aşama 3: API İstemcisi ve Ortak Ağ (Network) Katmanı
1. Otonom yapay zeka `Services/NetworkManager` isimli Klasörde (URLSession veya Retrofit Kullanarak) **Generic** Bir Ağ Sınıfı Kurgular. (Yani Hangi Model Yollarsan O Modeli Json'dan Translate Eden Mükemmel Ortak Ağ İstemcidi).
2. Api Keyler veya URL Adresleri "Doğrudan Klasörde Şifrelenmeden" Bırakılmaz. `Environment` Veya `Config` Objelerinden Cekilir.

---

## 🌐 Aşama 4: ViewModellerin İnşası Ve Data İzoleleri (MVVM)
*(UI Çizilmezden Önce Data Cizilir)*
1. `ViewModels` Dosyaları açılır, İşlemler (API'den Çekip Data modeline Atama) Yapılır. Loading ve Error için Özel Durumlar (Enum: Loading, Success, Error) gibi Hiyerarşide Tutulur!

---

## 🔒 Aşama 5: Arayüzlerin ve Geri Bağlantıların Çizilmesi (Compose / SwiftUI)
1. Viewlar Tasarlanırken Sürükle Bırak YOKTUR. Her Şey Kod (Declarative) ile CİZİLİR!.
2. Bir Liste Görünümüne (List) Tıklandığı zaman İç Sayfaya (Detail) Gitmek Için Navigasyon Objelerinde Parametre Geçilir. (SwiftUI İçin `NavigationStack` -> `NavigationLink(value:)` Mimarisi Kullanılır - Eski Navigation View DEPRECEATED'DIR (Ölmüştür)).

---

## ⚙️ Aşama 6: Polishing (Üst düzey Animasyon ve Haptics)
* **Dokunmatik Titreşim (Haptics):** Kullanıcı Satın Al Düğmesine Bastığında Veya Sepete Bir Ürün Eklendiğinde DÜMDÜZ Gecemez!. Otonom Zeka Cihazın (Taptic Engine / Vibrator) Modülüne Ulaşarak ÇOK KÜÇÜK Bir Çarpma (Light Impact - Haptic Feedback) EKLEYECEKTİR. Native Hissiyatın The Zirvesidir.
* **Geçiş (Transition) Animasyonları:** Modal Açılışları Native Cihazda Çok Sertse Kötü görnür. View'lere Otonom `.animation(.easeInOut, value: isShowing)` Eklemesi yapılarak Sürterek ve Saydamlasarak Büyüme (Scale) EFEKTI Kazandırılır. Bütün uygulamayı Şaha Kaldırır!

Adımlar tamsa "04-FilesStructure" yönergelerindeki mükemmel ağaca geçiniz.
