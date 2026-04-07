# 3️⃣ Flutter & Firebase - Adım Adım App İnşası (Step-By-Step)

> **YAPAY ZEKA ÇALIŞMA ALGORİTMASI:** "State kilitlenmeleri" denilen duruma düşüp sürekli "Render hatası" almamak için mobil uygulamalarda UI'dan önce arka servislerin (Provider'ların) izole yazılması mecburidir. Sıralamayı BOZMA!

---

## 🛠️ Aşama 1: Konfigürasyon ve Proje Setup (Scaffolding)
1. `flutter create` ile yaratılan standart Count App çöpünü tamamen SİL ve `main.dart`'ı tertemiz bırak.
2. `pubspec.yaml` dosyasına güncel "Riverpod (veya flutter_bloc)", "firebase_core", "firebase_auth", "cloud_firestore", "go_router" , "google_fonts", "freezed" paketlerini Import ET. Otonom olarak `import` hatası alma diye sürümlerini güncel tut.
3. Firebase'i Native(Kaba kurma) ayarlama. CLI (`flutterfire configure`) kullanılmış veya kullanılacak varsayımıyla `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` async metodunu `main()` içerisine tak. Mümkün olduğunca main methodunda hatasız Catch kurgula.

---

## 🎨 Aşama 2: Tema (ThemeData), Route ve Klasörleme
1. Projenin Dark ve Light temalarını kapsayacak `AppTheme.dart` (colorScheme ve textTheme) nesnesini oluştur. 
2. Saf (`Navigator.push`) devrini kapat. Deep Linking'i, Web ortamını doğrudan destekleyen ve "URL tabanlı" rota sağlayan **GoRouter** paketini (Veya AutoRoute) configure et. Projenin köküne `MaterialApp.router` ile bas.
3. Mükemmeliyetçi klasör ağacını çıkar (Bkz. `04-FilesStructure`).

---

## 🗄️ Aşama 3: Model ve Domain (Veri Tipleri)
1. Firebase'den çekilecek nesnelerin (.doc.data() bir `Map<String, dynamic>` dir) şemalarını oluştur.
2. Basit düz klasikler (`fromJson`, `toJson`) yazmak yerine, projenin büyüklüğüne göre Kod Üretici paket `Freezed` kur (`@freezed` decorator) ve immutability (değiştirilemez) durumunu garantile! Bu, Model'in state içinde güvenli bir şekilde aktarılmasını (CopyWith yeteneklerini) garanti eder.
3. Repositories (`AuthRepository`, `FirestoreRepository`) yaz! Firebase bağlantıları SADECE burada yapılsın. Repository'i Riverpod için `Provider` olarak sarmalla!

---

## ⚙️ Aşama 4: İş Mantığı ve State Katmanı (Provider/Riverpod)
*(İşte uygulamanın beyni olan Controller Burası)*
1. Ui ile Repository (Database) arasında köprü olan `StateNotifier` VEYA modern versiyonu olan `AsyncNotifier` kodla. 
2. İşlemi başlat (`state = const AsyncLoading()`), DB'den veriyi Al (await), Ve Başarı halinde `state = AsyncData(data)`. Ya da hata olursa `state = AsyncError(e)`.
3. Eğer yetki yokluk durumlarından ötürü Auth statüsü dinlemen gerekiyorsa (`StreamProvider` kullanarak `FirebaseAuth.instance.authStateChanges()` dinlenecek ve kullanıcı Logout attığı an Uygulama otomatik Redirect edecek şekilde Router bu riverpoda bağlanacak.

---

## 📱 Aşama 5: Arayüzler (UI ve Presentational Layouts)
*(Mantık hazır, artık resim çizmek serbest!)*
1. Stateless Widget'lardan ziyade Riverpod'dan gelen `ConsumerWidget` veya bloc'tan gelen `BlocBuilder` yapısıyla View ekranları çizilir.
2. Provider dinlenirken `ref.watch(userProvider).when( data: (user) => Text(user), loading: () => Spinner(), error: (e, st) => Text(e) )` şeklinde Asenkron (Gecikmeli) verilerin her durumu "Ekranda" hatasız ele alınır! 
3. Componentler olabildiğince parçalanmalıdır (Extracted Widgets). `build` metodunun içi 150 satırı aştıysa, kodu ufak Widget classlarına böl (Bölünürken Metot Extract etme, yeni bir CLASS Extract etki Flutter yapısı gereği bu ufak classı `const` olarak RAM de saklayıp gereksiz Render atmasın).

---

## 🚀 Aşama 6: Polishing (Mikro-Etkileşim, Animations ve Çevrimdışı Mod)
Burası amatörlerle otonom Zeka uzmanını ayırır.
1. Form girişlerinde (TextFields), validator mantığı (`FormState`) kullanılır. Klavyenin otomatik açılması (FocusNode) veya kapanması (TapOutside Unfocus) mükemmelleştirilir.
2. Uygulama İKONLARI (BottomBar) veya Tıklamalar dümdüz (Kuru) olamaz! Tıkladığında mutlaka `InkWell` / `Ripple` (Android) efekti veya Cupertino efektleri sergilenecek.
3. Offline First: Kullanıcı interneti kapattığında listeler bomboş Beyaz sayfa HATASINA düşmez. Çekilmiş veriler, Firebase Firestore'un "Offline Cache" desteğiyle hala ekranda görünmeye (Silik/Offline yazısıyla) veya Loading Skeleton'larıyla idare edilmeye devam ettirilir (Öngörülen Senaryo).

Adımlar tamsa `04-FilesStructure` için devam et.
