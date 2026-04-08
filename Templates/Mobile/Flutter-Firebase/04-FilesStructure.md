# 4️⃣ Flutter & Firebase - Kurumsal Dosya ve Klasör Hiyerarşisi (Files Structure)

> **MİMARİ ZORUNLULUK:** Flutter'da "Her şeyi anadizine yığmak" (lib altına 30 dosya) spagetti kodun en berbat halidir ve projeyi 1 ay sonra bakımı yapılamaz hale (Legacy Code) getirir. Otonom Geliştirici, kodlamaya geçmeden önce Dart ekosisteminin limitlerini Domain bazlı, S.O.L.I.D standartlarında aşağıdaki gibi keskin duvarlarla ayıracaktır!

---

## 📂 Ana Gövde: Feature-Driven (Özellik Odaklı) Mimari Ağacı

Bir uygulamanın klasörlerine bakıldığında (Sadece `lib/` klasörü), uygulamanın "Ne uygulaması" olduğu anlaşılmalıdır, "Hangi mimariyi" kullandığı değil! E-Ticaret'se `cart` (sepet), `products` klasörleri görülmelidir. Aşağıdaki şema Kurumsal Seviye Çekirdek (Clean Architecture by Feature) şemasıdır:

```text
/lib
  ├── main.dart                       # Root! Uygulama Başlangıç Noktası (Provider Scope, Firebase Init)
  │
  ├── /core                           # [BÜTÜN UYGULAMANIN DEPOLARI - ORTAK ALAN]
  │    ├── /constants                 # Magic String/Number çöplüğüne karşı Sabitler (AppColors.dart, AppStrings.dart)
  │    ├── /network                   # Custom HTTP Client, Firebase Service Base Class'ları
  │    ├── /routing                   # `router.dart` (GoRouter rotaları) Sadece burada!
  │    ├── /theme                     # AppTheme.dart (Dark/Light mode paleti ve Fontlar)
  │    └── /widgets                   # (Ortak) Her ekranda olabilecek CustomButton.dart, CustomTextField.dart
  │
  ├── /features                       # [BÖL VE YÖNET - ÖZELLİK KALESİ]
  │    ├─ /auth                       # Sadece Giriş ve Kayıt İşleri
  │    │   ├── /presentation          # UI (Ekranlar) ve Widgetları
  │    │   │    ├── screens           # (LoginScreen.dart)
  │    │   │    ├── widgets           # Sadece oturum ekranlarına has widgetlar (SocialLoginButton.dart)
  │    │   │    └── providers         # UI Tarafından dinlenen Riverpod/Bloc Sınıfları (auth_state.dart)
  │    │   ├── /domain                # Sadece İş Mantığı
  │    │   │    ├── models            # (UserModel.dart) - Sadece class tanımı
  │    │   │    └── repositories      # (IAuthRepository.dart) - Sadece kural arayüzleri
  │    │   └── /data                  # Sadece Veri Okuma Yazma
  │    │        ├── repositories      # (AuthRepositoryImpl.dart) - Arayüzün Firebase ile Doldurulan Hali
  │    │        └── sources           # (RemoteDataSource.dart, LocalCache.dart)
  │    │
  │    ├─ /home                       # Sadece Anasayfa İşleri (Feed, Bannerlar vs)
  │    │   ├── /presentation
  │    │   ├── /domain
  │    │   └── /data
  │    │
  │    └─ /profile                    # Kullanıcı Profil Detayları
  │        ├── /presentation
  │        ├── /domain
  │        └── /data
  │
  └── /utils                          # Uygulamanın saf statik yardımcı metotları
       ├── formatters.dart            # Paraları virgüle, tarihleri okunaklı formata (12 Eyl) çeviren foksiyonlar
       └── validators.dart            # Regex işlemleri (Email geçerli mi değil mi checkerları)
```

---

## 🎨 Varlık Yönetimi (`/assets`) ve Dosya Güvenliği İklimi

Dart kodları dışında bulunan `.png`, `.json`, `.svg`, `.env` kaynakları proje kökünde (lib dışında) klasörlenirken asla rastgele isimlendirilmez. `pubspec.yaml` da klasör adresleri kesin olarak deklare edilecektir (Otonom Ajan için En Sık Yapılan Hatalardan biri: Assets adresi deklare etmemek).

```text
/assets
  ├── /images                         # PNG ve JPEGLar TAVSİYE EDİLMEZ. Lütfen .WebP kullanın! (RAM dostu)
  ├── /svgs                           # Vektör ikonlar (Logo vs. Çözünürlük bağımsız) ('flutter_svg' paketiyle okunur)
  ├── /lottie                         # Mükemmel Loading animasyonları (.json formatlı AEP çıktıları)
  ├── /translations                   # Eğer pubspec.yaml içinde tutulmayıp, easy_localization vb kullanılacaksa dil .json'ları
  └── .env                            # GİZLİ ŞİFRELER BURADA OLUR! (Github'a gönderilmemesi için .gitignore'e ÇAKILIR)
```

---

## 🚨 İsimlendirme Kuralları (Naming Conventions) ve Kodun Düzeni

Flutter/Dart ekosisteminde standartlara (Linter) aykırı kod yazmak uygulamanın gelecekte refactor edilememesine sebep olur.

1. **Dosya İsimleri Kesinlikle `snake_case` (Küçük ve Alttan tireli):**
   * YANLIŞ: `LoginScreen.dart`, `userModel.dart`, `AppTheme.dart`
   * DOĞRU: `login_screen.dart`, `user_model.dart`, `app_theme.dart`

2. **Class İsimleri Kesinlikle `PascalCase`:**
   * DOĞRU: `class LoginScreen extends ConsumerWidget { ... }`

3. **Sayfa İsimlendirmeleri (Suffix):**
   Bir UI dosyasına bakınca tam bir ekran mı (`...Screen`), küçük bir bileşen mi (`...Widget` veya `...Card`), alt form mu (`...Form`) olduğu isim sonunda beli edilmek zorundadır.

4. **Klasör Taşıma Yasağı:** 
   Otonomi `features/auth/presentation` altındaki bir sayfanın içinde, `features/cart/domain/cart_model.dart` kütüphanesini doğrudan dahil (Import) EDEMEZ! Modüller arası katı bağımlılık yaratmak Clean Architecture kalkanını deler. Gerekiyorsa iletişim router (yönlendirici argümanlar) veya Core katmanı üzerindeki ortak model ve eventlerle sağlanır.
