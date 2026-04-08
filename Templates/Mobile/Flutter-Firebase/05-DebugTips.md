# 5️⃣ Flutter & Firebase - Kriz Çözümleri ve Debug İpuçları (Troubleshooting Kabusları)

> **OTONOM DEBUG KOMUTANESİ:** Flutter'ın platform bağımsız (Cross-platform) doğası ve Firebase'in asenkron (Latency-bound) yapısı birleştiğinde yapay zekanın "Try-catch yazdım bitti" diyerek atlatabileceği sorunlar üretmez. Meşhur `RenderFlex Overflow` veya Apple `Podfile` hataları projeyi kilitler. Otonom ajan, debug süreçlerini yönetirken aşağıdaki "Sık Karşılaşılan Kabus" senaryolarını bir Doktor edasıyla çözecektir!

---

## 🛠️ Çekirdek (Core) ve Firebase Bağlantı Hataları

### 1. `[firebase_core/no-app] No Firebase App '[DEFAULT]' has been created`
* **Krizin Sebebi:** Uygulamanın `main()` metodu tetiklendiğinde, `runApp(MyApp())` çalışmadan önce Firebase motoru cihazda uyanamamış VEYA başlatılmamıştır.
* **Otonom Çözüm (Zorunlu):** Ajan anında `main.dart` dosyasına uçar. Metodu asenkron (Future) yapar. `runApp` fonksiyonunun hemen AŞAĞISINA değil YUKARISINA (öncesine) şu 2 sihirli kodu kilitler:
  ```dart
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // runApp(const MyApp());
  ```

### 2. `PERMISSION_DENIED: Missing or insufficient permissions (Firebase)`
* **Krizin Sebebi:** Firebase (Firestore veya Storage) veritabanı okuma/yazma işlemi reddetti. Firebase ayarlarındaki `firestore.rules` dosyası "Sadece Yetkili" birini beklerken, Otonom Cihaz "Misafir (Guest)" olarak veri sorgulamaktadır.
* **Otonom Çözüm (Zorunlu):** Ajan direkt olarak Firebase Security rules'ı kapatıp riske girmez! Firebase veritabanı rules dosyasını kontrol eder (`allow read, write: if request.auth != null;`). Ve projede Auth State'inin olup olmadığını `FirebaseAuth.instance.currentUser` ile denetleyerek, işlemi yetkilendirme (login) sayfasının arkasına saklar.

---

## 🎨 UI ve Render Hataları (Görsel Kırmızı Ekranlar)

### 3. Asrın Hastalığı: `A RenderFlex overflowed by XXX pixels on the bottom` (Kırmızı-Sarı Bant Uyarısı)
* **Krizin Sebebi:** Otonomi Ekrana bir `Column` (yazı - resim - yazı) veya `Row` koydu. Fakat içindeki içerik cihazın ekranı dar olduğu için (veya klavye açıldığı için) Sığmadı! Müşteri bunu "Uygulama Bozuldu" sanır.
* **Otonom Çözüm (Zorunlu):** Kırmızı çiziktirilen alan ASLA "boyutu küçültülerek" çözülmez (Çünkü iPhoneSE ile iPad aynı boyutta değildir). 
  - Kök çözümü: Patlayan ana `Column` objesi hemen bir `SingleChildScrollView` (Kaydırılabilir alan) ile sarmalanır (Wrap widget).
  - Listelerde patladıysa: `ListView` veya içinde `Expanded` ya da `Flexible` widgetları ile cihazın boşluğuna kadar yayıl demek zorunludur!

### 4. `Null Check Operator Used on a Null Value`
* **Krizin Sebebi:** Yapay zeka Dart dilinde bir değişkeni boş (null) bırakmış, ancak zorla "Ben eminim bu dolu" manasına gelen Ünlem İşaretini (`!`) komuta eklemiştir (Örnek: `user.displayName!`). O saniye veri gelmezse UI "Kırmızı Ekran Hata Yığını" verir ve kullanıcı ölür.
* **Otonom Çözüm (Zorunlu):** Yapay Zekanın kod yazarken Null-Safety dairesi dışında ünlem (`!`) kullanması **KESİNLE YASAKTIR**. Değerler ya `?? "Varsayılan"` ile güvenceye alınacak, ya da `if (user.displayName != null)` kontrolünden (Guard clause) geçtikten sonra çizilecektir. Çizimde Asenkron varsa `FutureBuilder` içinde Snapshot hatası izlenir.

---

## 🛑 Özel Mimari ve Platform Kilitlenmeleri (DevOps & State)

### 5. `setState() or markNeedsBuild() called during build.`
* **Krizin Sebebi:** Ekranda widget Çizilmeye (Build edilmeye) DEVAM EDERKEN, ajan arka plandan gelen bir State yöneticisinden tetik çekmiş ve "Hadi baştan çiz!" demiştir. Flutter motoru saniyenin onda biri sırasında çizerken tetiklenmeyi kabul etmez ve çöker.
* **Otonom Çözüm (Zorunlu):** Tetiklenen kod parçası çizim esnasında olmak zorunda değilse (örneğin Dialog göstermek), tetik komutunun dışı `WidgetsBinding.instance.addPostFrameCallback((_) { ... dialog/state_change ... });` ile sarılır. Bu, "Sen çizimini bitir ondan hemen sonra bu koda bak" demektir!

### 6. "iOS Simulator Çalışmıyor! CocoaPods Uyarısı Veriyor: `pod install` Crash"
* **Krizin Sebebi:** Apple M serisi (M1/M2/M3) işlemcilerde veya paketlerde versiyon çakışması olması. Projede Firebase olduğu için iOS tarafı C++ paketlerini delememektedir.
* **Otonom Çözüm (Zorunlu):** Ajan hemen `ios/` klasörüne girer. `Podfile` içerisindeki `platform :ios, '13.0'` ayarını Firebase'in minimum kabul ettiği değere yükseltir. Konsoldan `cd ios && rm -rf Podfile.lock && pod repo update && pod install` komutlarını vurur. 

### 7. Veri Gelmeden Yansıyan Bembeyaz Bekleme Ekranı
* **Krizin Sebebi:** Stream veya Future dönerken ConnectionState kontrol edilmiş, fakat `ConnectionState.waiting` anında cihazın UI boş (return Container()) bırakılmıştır.
* **Otonom Çözüm (Zorunlu):** `ConnectionState.waiting` ve Riverpod/Bloc `isLoading == true` olduğunda Otonomi ASLA Beyaz ekran çeviremez. Ekranın o lokasyonunda estetik bir `CircularProgressIndicator(color: AppColors.primary)` (Veya Skeleton yüklenecekse Shimmer plugin) render edilmesi ZORUNLU bir Kullanıcı Deneyimi (UX) taktiğidir. Aksi halde proje amatör kabul edilir.
