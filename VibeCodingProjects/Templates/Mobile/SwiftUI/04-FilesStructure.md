# 4️⃣ Native Mobil (SwiftUI/Kotlin) - Kurumsal (MVVM Otonom) Klasör Hiyerarşisi

> **ZORUNLU DİZİLİM:** Projede XCode Veya Android Studio açıldığında Ekranınıza Gelen Ana dizinlerin ("Views", "Controllers" Şeklinde Düz Bırakılması) Sürdürülebilirlik Faciasıdır. 50 Tane View Aynı Yerde Bulunursa Ekip Kodu Kaybeder! Otonom yapay zeka Feature-Based (Özellik-Tabanlı) veya MVVM Kalıbına Göre Dizecektir.

---

## 📂 En Kurumsal Yapı: Özellik Tabanlı (Feature-First) / MVVM İzolasyon Modeli

Aşağıdaki yapı Büyük Apple ve Android Projelerindeki (The Standard) yapıdır:

```text
Native-App-Workspace/
├── App/                     # UYGULAMA GİRİŞ (Root - AppDelegate / App.swift)
│   ├── TheApp.swift         # @main İle Başlayan SwiftUI Pencere (WindowGroup) Başlatıcısı
│   └── DependencyImpl.swift # (Kurumsal) Bağımlılık Enjeksiyonlarının (DI) Tetiklendiği Dosya
│
├── Core/                    # 🚀 ÇEKİRDEK PROJE DOSYALARI (Feature'lardan Bambaşka!)
│   ├── Network/             # API Istek Kalkanları
│   │   ├── ApiClient.swift  # Generic URLSession Catcher Veya Retrofit Interceptor
│   │   └── Endpoints.enum   # BÜTÜN URL'lerin HardCoded Yasakla ENUM Olarak Düzenlendiği Yer
│   │
│   ├── Storage/             # KALICI KAYIT MERKEZİ
│   │   ├── CoreDataManager/ # Veritabanı (IOS) Yönetimi (Yada RoomDB)
│   │   └── UserDefaultsMgr  # Token Veya Tema Gibi Basit Stringlerin Cihaza Gömüldüğü Araç
│   │
│   ├── Utils/               # Matematik Veya Dönüşüm Aletleri
│   │   ├── Extensions/      # Örn: String+DateExtension (Extensionlar Kök Klasöre Ayrı Yazılır)
│   │   └── Constants.swift  # "Arial", "Spacing: 16" Gibi Sihirli Numaralar Buraya!
│   │
│   └── UI/                  # TAPTAL (DUMB) ORTAK TASARIM BİLEŞENLERİ
│       ├── CustomButton.swift
│       └── LoadingSpinner.swift
│
├── Features/                # 🚀 ODAK NOKTASI: UYGULAMA DOMAIN'LERİ (Modüller)
│   ├── Authentication/      # AUTHENTICATION ÖZELLİĞİNE DAHİR HER ŞEY!
│   │   ├── Models/          # SADECE Auth İle Alakalı Veri Tipi (TokenResponse.swift)
│   │   ├── ViewModels/      # LoginViewModel.swift (İş Kuralları Burada)
│   │   └── Views/           # LoginScreen.swift, RegisterScreen.swift (Sadece Çizer)
│   │
│   ├── Shared/              # DOMAİNLER ARASI KÖPRÜLER
│   │   └── UserSession.swift# Kullanıcının Giriş Yaptığını Global Tüm Sisteme Duyuran Obje (ObservableObject)
│   │
│   ├── Home/
│   │   ├── Models/
│   │   ├── ViewModels/
│   │   ├── Views/           # HomeFeedView.swift
│   │   └── Components/      # SADECE Bu Ekranın İçinde Yaşayan Özeli UI Varsa (PostCard.swift)
│
├── Resources/               # MÜKEMMELİYETÇİ ASSETS
│   ├── Assets.xcassets      # Resimler ve Dynamic (Light/Dark) Colors
│   └── Localizable.strings  # Çoklu Dil (i18n) Key-Value Dosyaları (Otonomi Burayı Kirletemez!)
```

---

## ⚠️ Kritik Mimari Kurallar (Files Rulebook)

1. **Extensions İzolasyonu:** Saf (Native) dillerde en büyük Zenginlik Mevcut Nesneleri Genişletebilmektir (Extensions). Otonom model Eğer bir Metine Özel bir Border-Radius Çekecekse Bunu HTML Gibi Her View'da Tekrar Tekrar (Modifier zinciriyle) YAZMAZ!. `View+Extensions.swift` açar, İçine `func customCardStyle() -> some View` yazar Ve Bunu Heryerde Tertemiz `.customCardStyle()` Olarak KULLANIR! (Yüzlerce Satır Kod Yok Edilir).
2. **Localizable Metinler (Hardcoded Yasağı):** Otonom AI gidip Butonun İçine `<Text("Kayıt Ol")>` DİYE STATİK YAZI GÖMEMEZ!!. Bu Native Piyasada Amatörlüktür! Bütün Metinler `LocalizedStringKey("register_btn")` FORMATINDA Çekilip Dışarıdaki Dil Dosyasından Türkçe Olarak Okunmalıdır!! Cihaz Diline göre Otonom Değişen Bir Mimari!.
3. **Data Modelleri Birbirine Gremez:** `Authentication/Models` altındaki Obje ile `Home/Models` altındaki obje eğer İkisi de `User` ise? Domain İzolasyonuna göre Otonom Yapı Bütün Cihazın Oratk Kullandığı Tipi Ya Core Klasörüne Atar VEYA İki modelin Çakışmasını (Cross-import) Engeller.
