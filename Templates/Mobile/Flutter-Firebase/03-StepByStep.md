# 3️⃣ Flutter & Firebase - Adım Adım Üretim ve Yürütme Protokolü (Step By Step)

> **OTONOM EYLEM VE YÜRÜTME KILAVUZU:** Yapay zeka ajanları (Otonom) veya insan geliştiriciler, projeyi sıfırdan oluştururken aşağıdaki 15 Kritik Adımı "Harfiyen ve Sırasını Bozmadan" takip etmek ZORUNDADIR. Önce ev boyanıp sonra temel atılmaz! Paket yönetimi yapılmadan kod yazılamaz.

---

## 🛠️ BÖLÜM 1: Çekirdek Kurulum ve Bağımlılıkların İnşası (Adım 1 - 4)

### Adım 1: Temiz Flutter Projesi ve Paket Tanımlaması (pubspec.yaml)
İlk eylem, boş bir Flutter projesi ürettikten sonra `pubspec.yaml` dosyasını yapılandırmaktır. Bir projede kullanılacak kütüphaneler (Firebase Core, Auth, Firestore, Riverpod/Bloc, Freezed, GoRouter, Google Fonts) en başından projeye dahil eklenecek ve mutlaka **uyumlu (conflict yaratmayan)** sürümleriyle test edilip `flutter pub get` çalıştırılacaktır. Otonom ajan "Kodu yazarım sonra yüklerim" diyemez.

### Adım 2: Firebase CLI ve Native Platform Entegrasyonu (Senkronizasyon Kırmızı Çizgisi)
Otonom ajan, sadece `pubspec.yaml` dosyasına Firebase'i eklemekle yetinemez. Projenin Android (`google-services.json`), iOS (`GoogleService-Info.plist`), Web (`firebaseConfig`) platformlarına Otonom CLI veya manuel ayarlar aracılığıyla Firebase Initialize (Başlatma) ayarlarını entegre etmek mecburidir. `main.dart` üzerinde `Firebase.initializeApp()` yazılmadan ve `WidgetsFlutterBinding.ensureInitialized()` kurulmadan hiçbir şeye başlanamaz.

### Adım 3: Çoklu Dil (i18n / Localization) Sisteminin Mühürlenmesi
Hardcoded string kalmak YASAKTIR. En baştan `flutter_localizations` eklenmeli, proje kökünde `l10n/app_en.arb` ve `l10n/app_tr.arb` gibi çeviri iskeletleri atılmalıdır. Bu adımdan sonra UI tarafına yazılacak tüm metinler `AppLocalizations.of(context)!.helloWorld` şablonuyla gelmek zorundadır.

### Adım 4: Klasör (Feature-Driven) Ağacının Köklerinin Atılması
`lib/` klasörü altına `core/` (Tema, Butonlar, Sabitler) ve `features/` (Özellik bazlı: auth, home, profile vb.) ana hiyerarşisi (Empty Folders) oluşturulur. Artık spagetti kodlama iptal edilmiş, mimari mühürlenmiştir.

---

## 🧠 BÖLÜM 2: Veri Kalbi ve Mimari Enjeksiyonlar (Adım 5 - 8)

### Adım 5: Modellerin (Domain Entities) Yaratımı ve Freezed/JsonSerializable
Otonom süreç veritabanından gelecek modelleri (User, Product) çıplak sınıflardan değil, Null Safety ve Kopyalanabilir (copyWith) metotlarını kendiliğinden üreten otomasyonlardan geçirir (Dart `built_value` veya `Freezed` paketleri). Model katmanında verilerin Firebase alanlarıyla tam eşleşecek Property'leri (Değişkenleri) belirlenir.

### Adım 6: Firestore Repository (Veri Kaynağı Erişimi) Sınıfları
State yönetimini bulaştırmadan SADECE Firebase çağrısı (`get()`, `set()`, `update()`) yapan Saf Dart Sınıfları (Repositories) kurulur. Tüm çağrılar Olası ağ kopmalarına karşın "Try-Catch" zırhı ile kaplanır ve Hatalar (Exception) yakalanır. Hiçbir zaman UI'ya çiğ FirebaseException ERROR uyarısı (Örn: `PERMISSION_DENIED`) geçirilmez, kullanıcı-dostu statülere dönüştürülür.

### Adım 7: State Management (Riverpod/Provider) İskelesinin Kurulması
Repository'i kullanacak olan `StateNotifier` veya modern `Notifier (Riverpod)` katmanı yazılır. Ekranın dinleyeceği Durumlar (Loading, Success(Data), Error) sınıflandırılır. "Düğmeye basınca" repository'ye git, sonucu al ve state'i güncelle mimarisi hazırda tutulur.

### Adım 8: Çekirdek Router (Navigasyon) Kurulumu
Projede iç içe geçmiş (Nested) navigasyon yapıları olabileceği öngörülerek, klasik `Navigator.push()` terkedilir. Bunun yerine Deep Linking'i ve Web URL uyumluluğunu şahlandıracak olan **GoRouter** paketi ile `router.dart` dosyası konfigüre edilir. Tüm rotalar sabit statik adreslere (`/login`, `/home`) bağlanır.

---

## 🎨 BÖLÜM 3: Müşteri Yüzü (UI / UX), Entegrasyon ve Test (Adım 9 - 13)

### Adım 9: Core Widgets ve Temalandırma (Colors/Typography)
Proje boyunca tekrarlanacak Custom Component'ler çizilir:
* Cihaz karanlık moda (Dark Mode) alındığında patlamayan Dinamik Renk Paletleri ayarlanır.
* `PrimaryButton`, `CustomTextField`, `LoadingOverlay` gibi bileşenler `core/widgets` altına standartlaştırılır ve her sayfada bu merkezi UI araçları kullanılır.

### Adım 10: Ekranların (Screens) Çizimi ve State Dinlenmesi (Consume/Watch)
Özelliklere ait ekranlar oluşturulur. `ref.watch(provider)` VEYA `BlocBuilder` dinleyicileri ekranda veri durumunu kontrol eder. Veri null ise / geliyorsa bembeyaz ekran göstermek yerine mutlaka modern Skeleton Loading (Shimmer) veya Lottie Animasyonu gösterilir. Kesinlikle Ekranda "Çıplak CircularProgressIndicator" gösterip bırakılmaz, Premium his şarttır.

### Adım 11: Klavye Bindirmesi (Keyboard Overlap) Koruma Testleri
Bir sayfada form (Input) varsa Otonom Zeka `SingleChildScrollView` ve Platforma uygun Padding ayarları (bottom insets) yapmayı unutamaz! Kullanıcı telefon klavyesini açtığında altta yazdıklarını göremiyorsa Proje Ret Yer!

### Adım 12: Güvenlik, Firebase Rules Mührü
UI tamamlandıktan sonra Firebase Console'da güvenlik ayarsız bırakılamaz; ilgili `.rules` dökümanına (kim hangi dosyaya dokunabilir?) ilişkin kurallar yazılır ve CLI ile deploy hazır edilir. 

### Adım 13: Cihaz Donanımı Tuş Savunması (Hardware Navigations)
Sadece Android cihazlarda olan "Gerçek Geri Tuşuna" basıldığında Eğer form dolduruluyorsa veya ana menüdeyse uygulamanın lak diye (kazara) kapanmasını engellemek için `PopScope` koruması ve onay pop-upları yerleştirilir. U/X kusursuzlaştırılır!

Eğer bu adım-adım talimatlar anlaşıldıysa ve otonom süreçte "adım atlama" gibi tehlikeli kestirmeler yok edildiyse, Dosya mimarisi için Döküman 04'e ilerlenebilir.
