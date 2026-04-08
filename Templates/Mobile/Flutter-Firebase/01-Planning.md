# 1️⃣ Flutter & Firebase - Mükemmeliyetçi Mobil Planlama ve Çekirdek Şartnamesi

> **YAPAY ZEKA İÇİN KESİN KURAL:** Mobil platform, Web gibi "Sorun çıkarsa F5 (Reload) atıp düzeltiriz" denilebilen bir yer değildir. Kullanıcılar bir uygulamayı indirip telefonuna kurarlar ve o paket App Store / Play Store'da donmuş (compiled) haldedir. Yanlış tasarlanmış bir Firebase okuması (Query) size 1 saatte 10.000$ fatura çıkartabilir veya kötü bir "State" yönetimi (derin setState spagettileri) uygulamayı iOS ve Android'de Memory Leak sebebiyle sürekli çökertebilir. Otonom modeli (Kendini) kurarken Offline-First (önce internetsiz çalış) ve Riverpod/Bloc temellerini mecburi kılacaksın. 

---

## 🎯 1. Trafik Beklentileri, Ölçeklenebilirlik (Scalability) ve Firebase Maliyet Planlaması

Firebase (özellikle Cloud Firestore) bir "Document-based" NoSQL veritabanıdır. Her "Okuma (Read)", "Yazma (Write)" ve "Silme (Delete)" işlemi doğrudan sente/dolara mal olur. Eğer sistemin 1 Milyon aktif kullanıcısı varsa ve anasayfada her `build()` / `render` metodunda yeniden DB'ye giderseniz (listen veya get), projeyi batırırsınız. 

### A. Maliyet ve Optimizasyon Kuralları (Mecburi Direktifler)
* **Rule 1 (Abonelik / Stream Faciası Önlemi):** Stream (Canlı Veri `.snapshots()`) kullanımı YALNIZCA "Sohbet (Chat)", "Borsa", veya "Anlık Sipariş Takibi" gibi gerçekten real-time (canlı) akması gereken veriler için spesifik tutulmalıdır. Bir "Kullanıcı profil verisi" veya sabit "Hakkımızda Metni" canlı (Stream) izlenmez! Bu tip veriler her zaman Firebase'den `.get()` metoduyla Future olarak tek seferlik çekilir.
* **Rule 2 (Önbellek - Offline First Garantisi):** Firestore'un en büyük avantajı, içindeki devasa güçlü Caching (Önbellekleme) mekanizmasıdır. Yapay Zeka kod yazarken her zaman önce Local Cache'i (Yerel Hafıza) sorgulatacak, eğer orada eksik veya bayat (stale) veri varsa Remote Server'a (Firebase'e) gidecek şekilde okuma stratejileri planlamak ZORUNDADIR. (Source: `Source.cache`, Fall-back to `Source.server`).
* **Rule 3 (Sayfalama - Pagination - Limitler):** Bir sayfadaki 10.000 adet "Ürün/Product" veya "Gönderi/Post" verisi `.limit(15)` veya `.limit(20)` ile sayfalanmadan (Paginated) ASLA çağrılamaz. ListView.builder ve ScrollController kullanılarak, kullanıcı aşağıya indikçe tetiklenen sonsuz kaydırma (Infinite Scroll / Cursor pagination) altyapısı kurulması şarttır. `getDocs()` kullanıp hepsini RAM'e çekmek anında kovulma sebebidir!
* **Rule 4 (Data Duplication / NoSQL Şeması):** NoSQL mimarilerde ilişkisel tablolar (JOIN) olmadığı için veriyi denormalize etmek (kopyalamak) bir kuraldır. Eğer bir yorumun yanında kullanıcının adı yazacaksa, Firestore tarafına `userId` kaydedip, uygulamada kullanıcıyı aramak yerine; doğrudan kullanıcının adı (userName) ve profil fotoğrafı linki de (userPhoto) yorum dokümanı içine kopyalanmalıdır. Bu Okuma (Read) sayısını 10 kat düşürür.

---

## 🔒 2. Güvenlik Duvarı: Firebase Security Rules ve Mobil İstismar (Auth)

Mobil uygulama "Client-Side" (İstemci tarafı) bir üründür. Cihaza indirildiği için Hacker'lar Tersine Mühendislik (Reverse Engineering) ile uygulamanın içindeki APK veya IPA dosyalarını söküp Firebase anahtarlarınızı (API Keys) görebilir. **KORKMAYIN!** Firebase altyapısında API Key'lerin çalınması "Uygulamanın hacklendiği" anlamına GELMEZ, çünkü Firebase güvenliği Mobil koda değil, **Server tarafına (Security Rules - Güvenlik Kuralları) bulut üzerine** yazılır.

1. **Firestore Rules (Güvenlik Kuralları):** 
   Otonom Yapay Zeka, projeyi kodlamayı bitirdiğinde mutlaka bir `firestore.rules` belge veya dosyası kurgusu üretmek zorundadır. Default (varsayılan) gelen "Test modu" (`allow read, write: if true;`) ASLA canlıya donanımla çıkamaz.
   ```text
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
     
       match /users/{userId} {
          // Kural: Bir kullanıcı sadece KENDİ dökümanını (uid uyuşmasıyla) yazabilir ve güncelleyebilir!
          allow write, delete: if request.auth != null && request.auth.uid == userId;
          // Profil herkese açıksa (Instagram gibi) herkes okuyabilir
          allow read: if request.auth != null; 
       }
       
       match /admin_logs/{logId} {
          // Kural: Normal kullanıcının logs sistemini okuması YASAKTIR. Sadece tokenında admin claim olanlar yetkilidir.
          allow read, write: if request.auth != null && request.auth.token.admin == true;
       }
     }
   }
   ```
2. **Kimlik Doğrulama Katmanı (Auth):**
   Apple ve Google'ın uygulama mağazası kuralları gerği bir iOS uygulamasında "Google Login (OAuth)" ekleniyorsa, **Apple Login** butonunun koyulması mağaza onay kuralları gereği (AppStore Guidelines) %100 Otonom olarak (UI'da en azından) plana dahil edilmelidir.

---

## 🔄 3. State Management (Durum / Bellek Yönetimi ve Reactive Yapı)

Klasik, eğitimsiz bir geliştirici her veri değiştiğinde ekrana `setState({})` yazar. Flutter uygulamasında sistem çapı state yönetimi (`State Management`) kullanmamak, "Bir gökdelen yapıp asansör koymamaya" benzer. `setState({})` kullanmak SADECE basit bir "Checkbox açık/kapalı" verisi veya bir TextInput değişimi (Local Ephemeral State) içindir. Global bir veriyi (Örneğin "Kullanıcı Giriş Yaptı mı?", "Sepetteki Ürünler") Widget ağacından `setState` ile elden ele (Prop drilling yaparak) taşımak uygulamanın performansını çökertecektir.

Otonom geliştiricinin 2 kurumsal (Senşor mimari) seçeneği vardır:

* **Strateji 1 (Bloc / Cubit Mimarisi):** Kurumsal seviyede, İş kurallarını (Business Logic) ve Kullanıcı Eylemlerini (Events), Ekrandan (UI) **kesin ve somut, katı çizgilerle ayırmak** isteniyorsa kullanılır. Çok fazla kalıp kod (boilerplate) ve uzun dosya yapısı istese de Bankacılık gibi test güvencesi isteyen devasa ekiplerde en temiz, en çok test edilebilir olandır.
* **Strateji 2 (Riverpod v2++ ve Code Generation):** Otonom kodlama yapan bir ajan için (ve modern Flutter komüniteleri için) çok daha temiz, Reaktif, esnek ve "Provider Not Found" hatalarının Derleme (Compile-time) zamanında baştan yakalandığı devasa, pürüzsüz yapıdır. AI için (Code Generation / `@riverpod` anotasyonu kullanımı ile) en tavsiye edilen güncel endüstri standarttır. Ajan verileri `AsyncValue (data/loading/error)` patternine gömüp doğrudan ekran koruması sağlar.

**KURAL:** Seçtiğiniz Architecture hangisi olursa olsun, Provider'ların parçalanması zorunludur. Tüm uygulamayı "AppProvider" isimli tek bir God Object'e (Tanrı nesneye) bağlamak yasaktır! Domain odaklı (Auth Provider, Cart Provider, Theme Provider gibi) atomlara bölünmelidir.

---

## 🚀 4. Klasör ve Modüler Mimari (Feature-Driven Katı Kurallar)

Basit bir To-Do listesi öğreticisinde `lib` klasörünün içini `/screens` (Ekranlar), `/widgets` (Parçalar), `/models` (Modeller) olarak bölmek masum olabilir. Ama BÜYÜK projeler (Enterprise Scale) bu sistemle "Spagettiye" (İçinden çıkılamaz, hiçbir dosyanın nerede olduğunun bulunamadığı karmaşa ağına) dönecektir! 

**Otonom Yapı Önkoşulu:** Domain-Driven (Özellik / Feature) tabanlı bir klasörleme kullanılacaktır! Hangi dosya "ne tür bir dosya" olduğuna göre değil, "hangi özelliğin dosyası" olduğuna göre gruplanır:

```text
/lib
 ├── /core                  # Uygulama geneli kalıcılar merkezi
 │    ├── /theme            # (Renk paletleri, typografi)
 │    ├── /utils            # (Validatorlar, ortak converterlar)
 │    └── /widgets          # (Her ekranda kullanılan ortak Özel Butonlar vs)
 │
 ├── /features              # **GÜÇ BURADAN KAYNAKLANIR (Böl ve Yönet)**
 │    ├── /auth             # Sadece Login/Register konuları!
 │    │    ├── /presentation  # UI Ekranı ve Butonlar (LoginScreen.dart)
 │    │    ├── /domain        # Kullanıcı modeli (User.dart)
 │    │    └── /data          # Firebase Api Çağrı Rotaları (AuthRepository.dart)
 │    │
 │    └── /cart             # Sadece Sepet Konuları!
 │         ├── /presentation
 │         ├── /domain
 │         └── /data
 │
 └── main.dart              # Global Route (GoRouter), ProviderScope ve Firebase.initializeApp
```

---

## 🛠️ 5. CI/CD (DevOps) Otomasyon Hazırlığı İçin Önşartlar

Büyük projelerde uygulama her test sonrasında telefona kablo bağlayarak yüklenmez. Otonomi, bu uygulamanın ileride Github Actions, Codemagic, veya Bitrise gibi bir **Sürekli Entegrasyon (CI/CD)** borusundan (pipeline) geçeceğini bilir. Bu yüzden:

- Proje içerisine "Hardcoded" API KEY veya gizli parolalar GÖMÜLEMEZ.
- Yapay Zeka otonomu Flutter projesini tasarlarken `flutter_dotenv` paketi üzerinden gizli `.env` ortam dosyası mimarisini başlangıç planına kurup, CI/CD adımları için hazır (Agnostik) bir derleme sistemi planlamakla mükelleftir.

Eğer bu temel taşlar beynine yazıldıysa; Uygulamanın kalbini oluşturacak olan Klasör İçerikleri ve Mantık akışının şematize edildiği `02-Architecture.md` yönergelerine geçebilirsin. Asla sınırların dışına çıkma.
