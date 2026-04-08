# 4️⃣ Apple SwiftUI - Dosya Mimarisi ve Grup (Group) Hiyerarşisi (Files Structure)

> **MİMARİ ZORUNLULUK:** Xcode Projeleri (özellikle SwiftUI), Fiziki klasörlerinden (Finder File System) çok "Project Groups" sistemine odaklıdır. Bir iOS veya macOS projesinin omurgasını "Düzleştirilmiş (Her şeyin aynı kökte `Views/`) olduğu" bir yapı ile başlatmak, uygulamanın 3 ay sonra refactor edilememesine sebep olur. Otonom yapay zeka, Domain-Driven Design veya Feature-Based Separation kurallarını Xcode Groups ağacına yansıtmak ZORUNDADIR!

---

## 📂 Ana Gövde: Otonom (Feature-Based) Group Klasörlemesi

Apple Silicon / SwiftUI dünyasında en efektif ve sürdürülebilir yöntem "Özellik Odaklı" paketlemedir (Package by Feature). `Views` içine tüm uygulamanın view'ları, `ViewModels` içine hepsi doldurulmaz! Sayfanın ve mantığın Kendi Özelliği (Auth, Settings, Home, Feed vb.) olan kaleye kapatılması ZORUNLUDUR.

```text
/MyAppProject (Root)
  │
  ├── MyAppApp.swift                  # Uygulama Başlangıcı (Root @main)
  │                                   # (.environmentObject ve CoreData PersistenceController Başlatma Noktası)
  ├── /App                            # [SİSTEMİN ÇEKİRDEĞİ]
  │    ├── AppState.swift             # Global Uygulama Durumu (Kullanıcı Oturum Kontrolü)
  │    └── MainTabView.swift          # Rotalar, Ana Menü, Bottom Navigation Bar! (Root Router)
  │
  ├── /Core                           # [EKOSİSTEM YARDIMCILARI - ORTAK KULLANIM ZIRHLARI]
  │    ├── /Networking                # Sadece Http Network Kalesi
  │    │    ├── APIClient.swift       # Modern async/await Ağ İsteği Altyapısı
  │    │    ├── APIError.swift        # HTTP Error Kodları Enumları
  │    │    └── Endpoints.swift       # `baseURL = ...` String Sabitleri çöplüğü!
  │    ├── /Storage                   # Veritabanı ve Hafıza
  │    │    ├── CoreDataManager.swift 
  │    │    └── KeychainHelper.swift  # Apple Keychain (Şifreli Kasa) Yönetimi 
  │    └── /Extensions                # String, Color, View gibi O.S Objelerine eklentiler
  │         └── Color+App.swift       # `Color.theme.primary` Yazabilmek icin custom eklentiler
  │
  ├── /Features                       # [BÖL VE YÖNET KALESİ - MÜKEMMEL IZOLE ALAN]
  │    ├── /Auth                      # Oturum Açma Modülü
  │    │    ├── /Views                
  │    │    │    ├── LoginView.swift  
  │    │    │    └── SignupView.swift 
  │    │    ├── /ViewModels           
  │    │    │    └── AuthViewModel.swift # SADECE Login/Register işleriyle sorumlu State Zekası
  │    │    ├── /Models               
  │    │    │    └── UserSession.swift   # Sadece login formuna ait veriler
  │    │    └── /Services             
  │    │         └── AuthService.swift   # Login işlemlerinin Interface i (Mocks icin)
  │    │
  │    ├── /Feed                      # Kullanıcılar, Gönderiler (Anasayfa Akışı) Modülü
  │    │    ├── /Views                
  │    │    ├── /ViewModels
  │    │    └── /Models               # (Post.swift)
  │    │
  │    └── /Settings                  # Ayarlar Sekmesi (Uygulama İçi Satınalmalar vs)
  │         └── SettingsView.swift
  │
  ├── /SharedUI                       # [ORTAK DUMB COMPONENTLER VE TEMA]
  │    ├── /Components                # Özelliğe (Feature) ait OLMAYAN, Aptal Cizimler
  │    │    ├── CustomTextField.swift # Saf UI: State alisi_verisi sadece @Binding ile olur
  │    │    ├── PrimaryButton.swift 
  │    │    └── EmptyStateView.swift
  │    └── /Modifiers                 # SwiftUI Custom ViewModifiers (.customShadow() vb)
  │
  └── /Resources                      # [ÖLÜ VARLIKLAR - STATIC ASSETS]
       ├── Assets.xcassets            # ICONLAR, RENK PALETLERİ ve GÖRSELLER (Color Sets zorunlu!)
       ├── Info.plist                 # Apple Sensor izinleri, Versionlama.
       └── Localizable.strings        # Çeviri Eşleştirmesi "login_btn" = "Giriş"
```

---

## 🚨 Katı Disiplinler ve Yasaklar (Dosya Mimari İhlalleri)

1. **`Assets.xcassets` Dışı Renk Çöplüğü Yasaktır:**
   Otonom Zeka `Color(hex: "#FF0000")` VEYA `Color(red: 0.1, green: 0.2)` şeklinde koda gömülü TASARIM STRINGLERİ URETEMEZ (Hardcoded Colors)! Projenin Asset kataloğunda Dark / Light Mode (Aydınlık-Karanlık) için "Color Sets" yaratılır (Örn. Adı: `AppTheme-Primary` olur). Kod ise bu rengi Otonom olarak `Color("AppTheme-Primary")` diyerek Çeker! Böylece telefon teması değiştikçe Renkler Otonomca Kendini Günceller Göz Yakmaz.

2. **Dairesel Bağımlılık İhlali (Circular Dependency Limitleri):**
   `Features/Auth/ViewModels` içindeki zeka Gidip de `Features/Feed/Models/Post.swift` dosyasını Okuyamaz! O özellik diğerinden İzole Olup Yaşamalıdır. (Modular Development Standardı). Böyle yapmazsanız Swift Derleyicisi Index'lerken (Compile Time) Şişer! İki sistemin haberleşmesi `AppState` üzerinden Observer'lara (Bildirimlere) Bağlı olmalıdır.

3. **`PreviewProvider` Terk Edilmesi (Boş Hata Üretmemesi İçin):**
   SwiftUI'ın en iyi yanı Canvas (Önizleme - Preview) dır. Otonom yapay zeka Dosyaları üretirken EN ALT İNDEKS'e `struct LoginView_Previews: PreviewProvider` koyar ZORUNLUDUR! (Veya IOS 17 ise yeni Macro `#Preview { LoginView() }` i koyar!). Fakat Preview içine sahte `mockData` koymazsan Kod çöker ve Preview Error verir. Zeka bunu bilerek Mock Enjeksiyonu ekler. 
