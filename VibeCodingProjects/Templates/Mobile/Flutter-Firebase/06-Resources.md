# 6️⃣ Flutter & Firebase - Profesyonel Modüller ve Otonom NPM Paketleri

> Profesyonel, otonom bir AI sistemi Flutter the UI katmanını "sıfırdan" çizebilir ama "Business" tarafında "Endüstri Standartı Pub.dev Paketlerine" ODAKLANILMALIDIR. Projeye gereksiz ve test edilmemiş pub kütüphanesi yüklemek UYGULAMAYI çökertir (Versiyon uyumsuzlukları). Aşağıdakiler altın standarttır.

---

## 📦 1. Kilit Taşı Pub.dev Paketleri (ŞART Kütüphaneler)

### State Yönetimi & Dependency Injection
* **`flutter_riverpod`** / **`hooks_riverpod`**: (ÖNERİLEN). Provider patterninin son halidir. Inherited Widget'lara ait "Rebuild" yavaşlıklarını bitirmiş, hatasız tip kontrolü (Compile-safe) sağlayan global state deposu.
* **`flutter_bloc`**: Geniş kurumsal ekiplerde "Event (Olay) -> State (Çıktı)" felsefesi.
* **`get_it`**: Eğer bloc/riverpod kullanılmıyorsa servislerin hafıza (ram) üzerine tekil referanslı (Singleton) Dependency Injection ile yerleştirilmesini sağlayan service locator.

### Modelleme ve Tip Güvenliği (Code Generation)
* **`freezed`**: (ÖNERİLEN). Mutlaka **`freezed_annotation`**, **`json_serializable`** ve **`build_runner`** dev dependencyleri ile kullanılır. Json to Dart yaparken immutable (Değiştirilemez) objeler yaratıp, State değişimlerini `user.copyWith(name: "Ali")` şeklinde otonom rahatça yönetmeyi temin eder.

### Routing (Derin Navigasyon)
* **`go_router`**: Eskiden kullanılan `Navigator.push` tarihe karıştı (Android Back Button ve Web URL desteklemez). URL mimarisi tabanlı deklaratif Routing çözümünün en iyisidir. Rota koruma kalkanları (Redirect Auth) kolayca bu kütüphanede yapılır.

### UI (Arayüz Premium Paketleri)
* **`cached_network_image`**: İnternetten Firebase storage Url'si ile çekilen Resimleri (NetworkImage) sümüklü gibi baştan indirtirsen mobil internet tükenir. Bu kütüphane resmi İNDİRİR, TELEFONA GÖMER (Cache), bir daha internete ÇIKMAZ.
* **`flutter_svg`**: `.jpg` / `.png` ikon kullanmak RAM düşmanıdır. Responsive değillerdir. Bütün ikonlar .svg (Vektörel) olmak ZORUNDADIR ve bu paketle basılır.
* **`lottie`**: Otonom yapay zekanın "Harika Bir Animasyon" koymak istediği yerlerde Json tabanlı donanımsal ivmelendirmeli animasyonların standart modülü.
* **`shimmer`**: Skeleton Yüklenme ekranlarında parlayan gümüşü animasyon efekti kütüpü.
* **`google_fonts`**: Projeye yerel font (`.ttf`) dosyası yükleme boyut hammallığını bitiren native hook (Otonom projenin pubspec.yaml şişmesini engeller).

---

## 📡 2. Yapay Zekaya (AI Agent'ına) İstem Formülleri

Aşağıdaki istemler, sistemin sana Mobilde donan bir Java kalıntısı DEĞİL, akıcı bir Native App kodu vermesini sağlar:

> "Bir Flutter profil sayfası tasarımı oluştur. **Zorunlu Kurallar:**
> 1. Kullanıcıyı Firebase `cloud_firestore` ve `firebase_auth`dan okuyacaksın. Klasör düzeninde Clean Arch uygulayarak bu kodları `/home/data/repo.dart` şeklinde ayır.
> 2. Veriyi StateManagement olarak Riverpod (`AsyncNotifierProvider`) ile dinle. 
> 3. Profil yüklenirken State'deki `.loading` metodu devreye girsin ve ekrana Text değil `shimmer` paketi efektli BoxSkeletonWidget'i çiz.
> 4. Hiçbir Material Widget'ını `const` kelimesiz bırakma yoksa işlemi iptal edicem."

> "Bana Uygulamanın Firebase Firestore kurallarını (`firestore.rules`) otonom olarak (1 Milyon user düşünerek) optimize et. 'Comments' koleksiyonunda, kişi dökümanı silebilmeli ama sadece Uid'si dökümanın içindeki `authorUid` ye eşitse."

---

## 🌍 Faydalı Kaynak Linkleri
* **[Reso Coder - Freezed & Clean Architecture]**: Clean Arch'ın Dart diline en iyi uydurulmuş şemaları.
* **[Riverpod.dev]**: Official Doc. Widget binding mimarisindeki son evrim.
* **[Firebase Security Rules Reference]**: Firestore Cloud Security resmi yazım syntaxları.
