# 01-Planning (Native Java-Android) - Otonom Planlama Sözleşmesi

> **OTONOM YAPAY ZEKA İÇİN KATI DİREKTİF:** Bu planlama belgesi, basit bir "Merhaba Dünya" (Hello World) uygulaması üretmek için DEĞİLDİR. Eğer bu belgeyi okuyorsan, Native Java (Android) ekosisteminin tüm ağırlığını, batarya optimizasyonunu, düşük seviye donanım (Kamera, GPS, Sensör) avantajlarını kullanarak; Kurumsal (Enterprise) düzeyde, çökmeyen, sızdırmayan (Memory-leak free) bir proje çıkartmakla MÜKELLEFSİN. 

---

## 📌 Proje Vizyonu ve Hedefi
Native Android platformu için, yüksek performanslı, batarya dostu ve işletim sistemi (Android OS) ile %100 asenkron, tam entegre çalışacak bir mobil uygulama geliştirmektir. Bu projenin yazılma amacı; Flutter veya React Native gibi cross-platform (çapraz platform) dillerinin tıkandığı "Düşük Seviye Bellek Yönetimi (Low-level memory management)", "Donanım Performansı" ve "Multithreading" potansiyelini Java ortamında köküne kadar sömürmektir. Otonom ajan, sisteme herhangi bir UI veya kütüphane eklerken "Performans Maliyetini" birinci planda tutacaktır.

## 🛠️ Katı Teknoloji Yığını (Tech Stack & Toolkit)

İstekler doğrultusunda sapmak YASAKTIR. Alt yapı şu şekilde tahsis edilmiştir:

- **Çekirdek Dil:** Java (Android API 24+ uyumluluğu gözetilerek. Lambda expressionlar, Stream API zorunlu olacak şekilde kodlanacak.)
- **Arayüz Geliştiricisi:** Android XML (Geleneksel `findViewById` **ASLA** kullanılmayacak. Tüm UI manipülasyonu katı olarak `ViewBinding` veya gerekliyse `DataBinding` üzerinden kurgulanacak. NullPointerException (NPE) çökmelerinin birincil çözümü ViewBinding'dir.)
- **Mimari Çerçeve:** MVC (Geleneksel) veya MVP (Model-View-Presenter). (Presenter katmanı asla Android Context (Activity/Service objeleri) tutmayacak. Memory leak kırmızı çizgidir.)
- **Ağ Katmanı (Network):** Retrofit2 + OkHttp3 + Gson/Moshi. (Ana iş parçacığında `execute()` ile senkron çağrı yapmak cinayettir ve YAPILMAYACAKTIR. Hepsi `.enqueue()` veya custom handlerlar ile arka planda çalıştırılacaktır.)
- **Yerel Veritabanı:** Room Database (Saf SQLite sorguları ile kod şişirilmeyecek, LiveData/Flow veya Thread observer kurgularıyla Room DAOs (Data Access Objects) üzerinden işlenecektir).
- **Görüntü İşleme (Image Tiling):** Glide veya Picasso. Ağdan çekilen görseller manuel olarak `BitmapFactory` ile RAM'e atılmayacak, muhakkak cache'lenecek.
- **Asenkron Yapı:** ExecutorService, Handler(Looper.getMainLooper()), veya karmaşık event'ler için RxJava2/3. (Çökmüş AsnycTask'ı kullanırsan sistem anında fail verecektir.)

---

## 📦 Kurumsal MVP (Minimum Viable Product) Kapsamı ve Beklentileri

Klasik bir MVP listesinden ziyade Otonomi şunları **eksiksiz** taahhüt eder:

1. **İleri Düzey Kullanıcı Arayüzü (Advanced UI/UX):** 
   Ekranda basit `LinearLayout` kullanarak birbirine yapışık bileşenler çizilemez. Ajan, Material 3 (Material You) özelliklerini kullanmak zorundadır:
   - Kenarları yuvarlatılmış (radius 16dp+) `MaterialCardView`.
   - İçi ferah, padding uyumu yakalanmış (horizontal 24dp, vertical 16dp vs.) listeler.
   - Ripple effect'leri açık (Tıklanabilir hissiyatı olan) `MaterialButton`'lar.

2. **Network ve Offline-First Senkronizasyonu:**
   Sadece internet varken çalışan uygulama İSTENMEMEKTEDİR. Bir veri listeleniyorsa (User, Post, Product), Retrofit ile çekildiği an arka planda (Room DB) cache'lenecek, internet yoksa (Offline mode) Room'dan getirilip kullanıcıya gösterilecektir (`NetworkBoundResource` mantığı uygulanabilir).

3. **İsimlendirme ve Tip Güvenliği Sınırları:**
   Otonom ajan Android frameworkünde isim koyarken;
   - Activity isimleri her zaman `Activity` kelimesiyle bitecek (`LoginActivity.java`).
   - Fragment isimleri `Fragment` kelimesiyle bitecek (`HomeFragment.java`).
   - Layoular (XML) tipine göre isimlendirilecek (`activity_login.xml`, `fragment_home.xml`, `item_post.xml`).

---

## 🚀 Proje Büyüme ve Ölçeklenebilirlik (Scalability Foresight)

Eğer bu uygulamanın 1 kullanıcıdan 1000 kullanıcıya veya 1 ekrandan 20 ekrana çıkması istenirse mimarinin patlamaması gerekir. Yapay zeka projeyi "Modüler" düşünerek şu adımları en başta kurar:

- **Stringler ve Ölçüler Ayrılmalıdır:** XML dosyasında `android:text="Giriş Yap"` veya `android:textSize="16sp"` yazarak hard-coding YAPAMAZSIN. Dışarıdan anında tema değişimi için her metin `res/values/strings.xml` dosyasında, her ölçü `res/values/dimens.xml` dosyasında saklanacaktır.
- **Temalandırma (Theming & Dark Mode):** Ajan başlangıçtan itibaren arayüz renklerini `colors.xml` ve `themes.xml` (ve `themes.xml (night)`) altında yapılandırarak tek bir butonla uygulamanın Gece/Gündüz (Dark/Light) ritmine uyum sağlamasını garanti eder.
- **Paket Hiyerarşisi:** Sınıfları ana klasöre yığmak Otonomi açısından affedilemez bir suçtur. Proje "Feature-Based" (Özellik bazlı) veya Layer-Based (Katman bazlı) alt klasörlerde tutulur. Login işlemi için `com.../login/LoginPresenter.java` gibi mantıksal klasörlere yerleştirilmesi mecburi kuraldır.

---

## ⏱️ Geliştirme Yaşam Döngüsü Tahminleri

Otonom geliştiricinin kendine belirleyeceği süre sınırları ve Test planlaması aşağıdaki gibidir:

- **Aşama 1 (Kurulum ve XML)**: `build.gradle` içindeki versiyon uyumları (TargetSDK, CompileSDK, AppCompat vs) hatasız kurulmalıdır.
- **Aşama 2 (Veri Modeli)**: JSON veya DB sınıfları yaratılmalıdır. Alanlar (fields) public bırakılamaz; daima `private` olacak ve Encapsulation (Getter/Setter) uygulanacaktır.
- **Aşama 3 (Entegrasyon)**: Java tarafında API entegrasyonu (Retrofit `Call<T>`) ve Asenkron bekleyişler arayüze (ProgressDialog/ProgressBar) bağlanmalıdır.
- **Aşama 4 (Navigasyon Kilitleri)**: Ana sayfa açıldıktan sonra "Geri (Back)" donanım tuşuna basılıp ekranın kilitlenmesini önlemek için "Çıkmak istediğinize emin misiniz?" diyaloğu yerleştirilmelidir.

> **SON UYARI:** AI, bu yönergeleri sadece "okuyup geçemez". Yazacağı her satu Java veya XML kodu bu plana, özellikle Memory Leak kurallarına %100 uygun olmalıdır. Kodlama sürecine `02-Architecture.md` dosyasını kavrayarak devam ediniz.
