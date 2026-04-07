# 1️⃣ Flutter & Firebase - Mükemmeliyetçi Mobil Planlama

> **YAPAY ZEKA İÇİN KESİN KURAL:** Mobil platform, Web gibi "Reload" atılabilen bir yer değildir. Kullanıcılar bir uygulamayı indirip telefonuna kurar. Yanlış tasarlanmış bir Firebase okuması 1 saatte 10.000$ fatura çıkartabilir veya kötü bir "State" yönetimi (setState spagettisi) uygulamayı iOS ve Android'de sürekli çökertebilir. Otonom modeli kurarken Offline-First ve Riverpod/Bloc temellerini mecburi kıl.

---

## 🎯 1. Trafik, Ölçek ve Firebase Maliyet Planlaması

Firebase (Cloud Firestore) bir "Document-based" NoSQL veritabanıdır. Her "Okuma (Read)", "Yazma (Write)" ve "Silme (Delete)" ücretlendirilir. 1 Milyon kullanıcınız varsa ve anasayfada her render'da yeniden DB'ye giderseniz iflas edersiniz.

### A. Maliyet ve Optimizasyon Kuralları
* **Rule 1 (Abonelik Önlemi):** Stream (Canlı Veri) kullanımı yalnızca "Sohbet (Chat)" veya "Borsa" gibi gerçekten real-time (canlı) akması gereken veriler için kullanılır. Kullanıcı profil verisi canlı izlenmez! Olası bir durumda `.get()` ile Future olarak tek seferlik çekilir.
* **Rule 2 (Önbellek - Offline First):** Firestore'un en büyük avantajı Caching'dir. Yapay Zeka kod yazerken her zaman önce Local Cache'i sorgulatacak, yoksa Remote Server'a (Source: Cache, fall-back to Server) gidecek şekilde okuma stratejileri (Offline Persistence) planlamak ZORUNDADIR. 
* **Rule 3 (Pagination):** Bir sayfadaki 1000 adet "Ürün/Product" verisi `.limit(15)` ile sayfalanmadan ASLA çağrılamaz. ListView.builder ve ScrollController kullanılarak sonsuz kaydırma (Infinite Scroll) şarttır.

---

## 🔒 2. Güvenlik: Firebase Security Rules ve Auth

Mobil uygulama client-side'dır, yani Tersine Mühendislik (Reverse Engineering) ile API Key'ler çalınabilir. Bu durum "Uygulamanın hacklendiği" anlamına GELMEZ, çünkü Firebase güvenliği Mobil koda değil, **Server tarafına (Security Rules)** yazılır.

1. **Firestore Rules:** 
   Otonom Yapay Zeka, projeyi bitirdiğinde mutlaka bir `firestore.rules` dosyası üretmek zorundadır. Default gelen "test modu" (allow read, write: if true;) ASLA canlıya çıkamaz.
   ```text
   match /users/{userId} {
      // Bir kullanıcı sadece KENDİ dökümanını (uid uyuşmasıyla) yazabilir ve silebilir
      allow write, delete: if request.auth != null && request.auth.uid == userId;
      // Profil herkese açıksa herkes okuyabilir (ya da auth olanlar)
      allow read: if request.auth != null; 
   }
   ```
2. **Kimlik Doğrulama Katmanı (Auth):**
   Apple zorunluluğu nedeniyle bir iOS uygulamasında "Google Login" varsa "Apple Login" otonom olarak (UI'da en azından) plana dahil edilmelidir.

---

## 🔄 3. State Management (Durum / Bellek Yönetimi)

Flutter uygulamasında state yönetimi projenin omurgasıdır. `setState({})` kullanmak sadece basit bir "Checkbox açık/kapalı" verisi (Local Ephemeral State) içindir. Global bir veriyi setState ile taşımak (Prop drilling yapmak) Faciadır (Uygulamayı Kastırır).

Otonom geliştiricinin 2 kurumsal seçeneği vardır:

* **Yaklaşım 1 (Bloc/Cubit):** Kurumsal (Enterprise) seviyede, iş kuraalarını (Events), UI'dan kesin katı çizgilerle ayırmak için. Çok fazla boilerplate (uzun dosya yapısı) istese de büyük ekiplerde en temizidir.
* **Yaklaşım 2 (Riverpod v2):** Otonom kodlama için çok daha modern, esnek ve "Provider" hatalarının Derleme (Compile-time) zamanında yakalandığı devasa yapıdır. AI için (Code Generation / @riverpod kullanımı ile) en tavsiye edilen güncel standarttır.

**KURAL:** Seçtiğiniz Architecture hangisi olursa olsun (örneğin Riverpod), Provider'ların parçalanması zorunludur. (Auth Provider, Cart Provider, Theme Provider gibi).

---

## 🚀 4. Klasör ve Modüler Mimari (Feature-Driven)

Flutter'da `lib` klasörünün içini `/screens`, `/widgets` olarak bölmek ufak bir denemede olabilir. Ama büyük, PlayStore/AppStore hedeflenen projelerde bu işe yaramaz.

**Otonom Yapı Kuralı:** Özellik (Feature) tabanlı bir klasörleme kullanılacak!
`lib/features/auth/`
`lib/features/auth/presentation/` (Sayfalar)
`lib/features/auth/domain/` (Modeller)
`lib/features/auth/data/` (Firebase çağrıları)

Eğer bu kurgu anlaşıldıysa Firebase ve Mimari detayları (02) dosyasına geçin.
