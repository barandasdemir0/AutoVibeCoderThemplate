# 2️⃣ Flutter & Firebase - Mimari ve Katmanların İzolasyonu (Clean Architecture Sınırları)

> **MİMARİ ZIRH UYARISI:** Eğer bir sayfada (`LoginScreen.dart` veya `Home.dart`) hem Firebase yetkilendirme (`FirebaseAuth.instance.signIn`), hem ekrandaki TextField'ın state'i (`TextEditingController`), hem de Kullanıcı model dönüşümü (`User.fromJson`) ARKA ARKAYA aynı dosyanın içerisindeyse, bu kod Bir Çöplüktür! (God Object). Değiştirilemez, test edilemez ve en geç 2. ayda çökmeye / Spagettiye mahkumdur. Tüm bunlar MİMARİ OLARAK S.O.L.I.D prensipleri ile ayrılmak zorundadır.

---

## 🏛️ 1. Uygulama Katmanları (Presentation, Domain, Data Bölünmesi)

Büyük çaplı (Kullanıcı Sayısı: 10k+) Flutter projelerinde (Özellikle Riverpod veya Bloc/Cubit kullanılıyorsa) 3 katmanlı Clean Architecture (veya Feature-Driven Architecture) yaklaşımı tercih edilmesi **MUTLAK (MUST)** kuraldır.

### 🔹 Layer 1: Data / Repository Layer (Data Source)
* **Sorumluluğu:** Dış dünya ile ve cihazın yerel diskleriyle iletişim kuran KÖR işçidir. Firebase'den veya REST API'dan (JSON formatında) veriyi alır, bunu Saf Dart Nesnesine (Model/Entity) çevirir ve bir üst katmana fırlatır.
* **Katı Kural:** Bu katman `BuildContext` (Ekran, Boyut, UI objesi) Nedir ASLA BİLEMEZ! Burada navigasyon yapılamaz. Firebase hatalarını `try-catch` veya `runCatching` kalkanlarıyla yakalar, UI'ın anlayacağı tertemiz Custom Exception'lara (veya Dartz paketi ile Either<L,R> pattern'a) dönüştürür.
* **Network ve Local Data Ayırımı:** Bir Repository içinde eğer Offline first bir kurgu varsa önce `LocalDataSource` (örneğin Hive/Isar DB) sorulur, sonra `RemoteDataSource` (Firebase) sorulur.

### 🔹 Layer 2: Domain Layer (İş Mantığı ve Kurallar Merkezi)
* **Sorumluluğu:** Projenin MANTIK kalbi. Çekirdek Saf Dart (Pure Dart) kodlarıdır. İçinde hiçbir Firebase paketi (veya `http` kütüphanesi) import edilemez. İçinde UI kütüphanesi (Material, Cupertino, Widgets) IMPORT EDİLEMEZ! Sadece veri objeleri (`User`, `Product`), Enum'lar ve şifre kuralları / iş doğrulama (Validation) işlemleri yer alır.
* **Usecases / Interactors (İsteğe Bağlı):** Bir kullanıcının sepete ürün eklemesi (AddCartItem) Domain katmanında bir UseCase'tir. Eğer altyapıyı çok sağlam yapmak isterseniz, Presentation (UI) katmanı direkt Repository'i değil, sadece bu UseCase'i çağırır.

### 🔹 Layer 3: Presentation Layer (UI, Ekranlar ve State Management)
* **Sorumluluğu:** State Manager'dan (Riverpod Provider veya Bloc) gelen verileri dinler (Listen / Watch). Duruma (Loading, Data, Error) göre Ekrana ilgili Widget'i asar (render eder).
* **Katı Kural:** Bir Sayfa (Örn. `ProfileScreen.dart`) düğmeye tıklandığında gidip kendi başına `FirebaseFirestore.instance...` diyerek ASLA veritabanına doğrudan istek ATAMAZ. Action tetiklenir (Provider'a haber verilir), Provider/Bloc Business logic ve Repository'e gider, state güncellenince UI buna tepki verir. Sınırlar Çizilmiştir!

---

## 🚫 2. YASAKLI İŞLEMLER VE KODE KOKULARI (Anti-Patterns / Code Smells)

Otonom Android/iOS geliştiricinin yapmaması gereken kodlama katliamları (Bunlar PR Red Sebepleridir!):

1. **❌ Doğrudan State/Provider İçinden Context Kullanıp Navigasyona Çıkmak (KARA LİSTE!):**
   ```dart
   // YASAK (Provider context'i parametre Alamaz. Memory leak veya Build sırasında 'context öldü' exception'ı atar!)
   authProvider.login(email, pass).then((_) => Navigator.push(context, ... )); 
   ```
   *DOĞRUSU:* Provider sadece durumu (state = loggedIn) değiştirir. UI katmanında (`Widget build` içinde veya initState üzerinde) provider dinlenerek (Örn; `authListener`) state "success" olduğunda GoRouter / AutoRoute ile ekrandan yönlendirme yapılır.

2. **❌ Dispose (Temizlik) Etmeyi Unutmak (O.O.M: Out of Memory!):**
   `StreamController`, `TextEditingController`, `AnimationController`, veya `ScrollController` açıp da stateful widget'ın `dispose()` metodunda (`controller.dispose()`) kapatmamak tam bir acemiliktir. Uygulama RAM'i çöplüğe döner, 15 dk kullanım sonrasında telefon ateş atar ve işletim sistemi uygulamayı kapatır. YASAKTIR.
   *(Modern çözüm olarak Riverpod'un `autoDispose` veya flutter_hooks `useTextEditingController` metodları tercih edilmeli, manuel dispose riski azaltılmalıdır).*

3. **❌ Hardcoded Magic Strings & Magic Numbers (Tasarımsal Boğulma):**
   Kodun içine `Colors.blue` , padding olarak rastgele `Padding(padding: EdgeInsets.all(16))`, sayfa URL'si olarak `'/home'`, firestore collection olarak `'users'` yazıp geçmek! Proje büyüdüğünde bir tablo ismini veya ana temayı değiştirmek için 300 farklı dosyayı Ctrl+F ile bulup değiştiremezsiniz.
   Bunların TÜMÜ `AppConstants` (Sabitler), `AppColors`, `AppRoutes` altında `core/` veya `constants/` paketinde toplanacaktır. UI sadece `AppColors.primaryBrand` der!

---

## 📦 3. Firestore (NoSQL) Özelinde Veri Modelleme Kuralları (Maliyet Kurtarışı)

Firestore'da bir tabloda İlişkisel Veri Tabanlarındaki (PostgreSQL/MySQL) gibi **"JOIN" SORGUSU (Operation) YOKTUR**! Yani, Bir "Post (Gönderi)" dokümanını çektiğinizde, o gönderiye ait "Yazar (Author) Detayları" (ad, soyad, avatar URL'si) için ayrı bir SQL Joini atamazsınız. Eğer atarsanız (Foreach ile her post için yazarlar tablosuna Query atarsanız), Ekranda 100 gönderi listelendiğinde arkada 100 okuma + 100 yazar okuması = Toplam **200 READ (Okuma)** faturası yersiniz. Fatura patlar!

* **KRİTİK KURAL (Data Denormalization & Duplication):** Gönderiyi (Post) Firebase'e YAZARKEN, kim yolladıysa onun *O Anki İsmini ve Avatar URL'sini* (authorName, authorAvatar) DOĞRUDAN Post Document'inin (Satırının) içine String olarak kopyalayıp kaydedin. Veriyi çoğaltın (Duplicate)! NoSQL mimarilerinde **Depolama kapasitesi (Storage/RAM) çok ama ÇOK ucuzdur; ancak OKUMA İŞLEMİ (Read Counts) inanılmaz pahalıdır.**

Eğer bu katmanlardan, tehlikelerden ve kısıtlamalardan eminsen 3. dökümana (Adım adım eylem protokolüne) geçebilirsin. Asla kuralları ihlal etme!
