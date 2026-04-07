# 2️⃣ Flutter & Firebase - Mimari ve Katmanların İzolasyonu (Clean Architecture)

> **MİMARİ KURALI:** Eğer bir sayfada (`LoginScreen.dart`) hem Firebase yetkilendirme (`FirebaseAuth.instance.signIn`) hem TextField state'i yönetimi (`TextEditingController`) hem de Kullanıcı model dönüşümü (`User.fromJson`) ARKA ARKAYA aynı dosyadaysa, bu Kötü Koddur. Çökmeye ve Spagettiye Mahkumdur. Tüm bunlar ayrılmak zorundadır.

---

## 🏛️ 1. Uygulama Katmanları (Presentation, Domain, Data)

Flutter projelerinde (Özellikle Riverpod veya Bloc kullanılıyorsa) 3 katmanlı Clean Architecture yaklaşımı tercih edilmesi MUST'tır (Zorunludur).

### 🔹 Layer 1: Data / Repository Layer (Service)
* **Sorumluluğu:** Dış dünya ile iletişim kuran KÖRDÜR. Firebase'den json alıp bunu Dart Nesnesine (Model) çevirir ve dışarı yollar.
* **Katı Kural:** Bu katman `BuildContext` nedir bilemez! Firebase hatalarını `try-catch` ile yakalar, UI'a (Ekrana) uygun Dart Exception'lara (veya Either paternleri ile Left/Right durumlara) sarar ve Presentation'a döner.
```dart
// userRepository.dart
Future<User> fetchUserProfile(String uid) async {
   try {
     final doc = await _firestore.collection('users').doc(uid).get();
     if (!doc.exists) throw UserNotFoundException();
     return User.fromJson(doc.data()!);
   } catch (e) {
     throw CustomServerException("Ağ hatası: $e");
   }
}
```

### 🔹 Layer 2: Domain Layer (Modeller ve İş Mantığı)
* **Sorumluluğu:** Saf Dart kodlarıdır. İçinde hiçbir Firebase paketi (veya Http kütüphanesi) geçemez. İçinde UI kütüphanesi (Material/Cupertino) geçemez! Sadece Data siniflari `User`, Enums, Validasyon tipleri.
* **Not:** (Küçük projelerde Data ve Domain iç içe kullanılabilir ama Kurumsalda ayrı olmalıdır).

### 🔹 Layer 3: Presentation Layer (UI ve State Management)
* **Sorumluluğu:** State Manager'dan (Riverpod Provider veya Bloc/Cubit) gelen verileri dinler. Dönen veriyi Ekrana Widget olarak çizer!
* **Katı Kural:** Sayfalar (Örn. `ProfileScreen.dart`) ASLA Gidip veritabanına doğrudan istek atamaz. Provider'a söyler, Provider Data Layer'a atar.

---

## 🚫 2. YASAKLI İŞLEMLER (Anti-Patterns)

Flutter'da Yapay Zeka otonom geliştiricinin yapmaması gereken kodlama katliamları:

1. ❌ **Doğrudan State/Provider İçinden Context Kullanıp Navigasyona Çıkmak:**
   ```dart
   // YASAK (Provider context'i taşıyamaz, Memory leak veya context ölmesi oluşur)
   authProvider.login().then((_) => Navigator.push(context, ... )); 
   ```
   *DOĞRUSU:* Provider'da sadece state döner. UI katmanında provider `.listen` ile (veya BlocListener) State dinlenir (Örn; `authState == success`), state değiştiğinde UI içinde Widget ağacı sayesinde `context.go()` ile yönlendirme yapılır. (GoRouter vs).

2. ❌ **Dispose (Temizlik) Etmemek:**
   StreamController, TextEditingController, AnimationController açıp da o Widget'ın `dispose()` metodunda bunları kapatmazsanız uygulama RAM'i şişer, Memory Leak olur ve 15 dk sonra iPhone kapanır. ZORUNLUDUR.
   *(Bunu çözmek için `flutter_hooks` (HookWidget) kullanılabilir ama Riverpod Provider'larının otomatik dispose olan autoDispose modları tercih edilmelidir).*

3. ❌ **Magic String ve Magic Numbers:**
   `Colors.blue`, `padding: 16`, `/home`, `users` (Firestore collection name). Bunların hepsi stringdir. Tasarım değiştiğinde 100 dosya gezemezsiniz.
   `AppConstants.colors.primary`, `AppRoutes.home` gibi Constants klasöründe toplanılacaktır.

---

## 📦 3. Firestore (NoSQL) Veri Modellemesi
Firestore'da bir Tabloda İlişkisel DB gibi (SQL) "JOIN" IŞLEMİ YOKTUR. Yani Bir "Yorum (Comment)" çekiyorsanız, o yoruma ait "Yazar (Author) İsmi" için ayrı bir SQL Joini atamazsınız. Atarsanız her yorum için 1 okuma daha yazılır ve 100 yorumda 101 read yersiniz. Fatura Patlar.

* KURAL (Denormalization): Yorumu Firebase'e yazarken, yazar ismini de (authorName, authorAvatar) doğrudan Yorum Document'inin içine String olarak kaydedin. (Duplicate the data!). NoSQL'de depolama (RAM) çok ucuzdur, asıl pahalı olan şey OKUMA (Read) IŞLEMİDİR.

Mimaride mutabıksanız, Firebase kodlama sıralaması "03-StepByStep" dosyasıyla devam edin.
