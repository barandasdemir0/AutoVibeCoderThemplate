# 03-Step By Step (Adım Adım Üretim ve Kurulum Algoritması)

> **OTONOM EYLEM KILAVUZU:** Yapay zeka, Native Java Android projesini ayağa kaldırırken veya yeni bir özellik modülü eklerken, bu listedeki sıralamaya "Zorunlu bir kodlayıcı makine" olarak uymak mecburiyetindedir. Klasör oluşturmadan UI çizmeye, bağımlılıkları inşaa etmeden teste kadar Adım 1 den Adım 15'e kadar asla adımları "Atlayamaz veya Yanlış Sıraya" koyamaz.

---

## BÖLÜM 1: İnşaat İskeleti ve Güvenlik Ağları (Adım 1 - 4)

### Adım 1: Gradle Konfigürasyonu ve Paket Sınırları
Daha ilk saniyede kodu oluşturmaya başladığında:
* Proje root'undaki (Veya app modülündeki) `build.gradle` (veya `build.gradle.kts`) açılır.
* Temel Java desteği kontrol edilir (Minimum SDK 24+, Target SDK güncel tutulur).
* ViewBinding özelliği devasa memory leak'leri engellemek için açılır:
  ```groovy
  android {
      ...
      buildFeatures {
          viewBinding true
      }
  }
  ```
* Projenin tek seferde doğru çalışmasını sağlayacak olan Bağımlılıklar (Retrofit, OkHttp, Glide, Gson, Room) eklenir ve **Mutlaka Sync edilir!**

### Adım 2: Manifest ve Güvenlik Duvarları
* Uygulamanın İnternet isteyip istemediğine dair yetkiler `AndroidManifest.xml` root düğümünde `android.permission.INTERNET`, gerekliyse (Lokasyon vs) diğer yetkiler tanımlanır. Güvenlik açıkları doğmaması adına Network Security Config eklenebilir veya PlainText HTTP (Clear-Text) destekleri kurumsal normlara göre ayarlanır.

### Adım 3: Çoklu Dil (i18n) ve Kaynak Değişkenliği (Tasarım Temelleri)
* Yapay zeka hiçbir TextView komponentinin içine hardcoded text yazmayacaktır (`android:text="Gönder"` Hatalı). 
* `res/values/strings.xml` açılır, varsayılan İngilizce (ve projedeki taleplere göre) `res/values-tr/strings.xml` vs oluşturularak çeviri mimarisi inşa edilir.
* Aynı şekilde renkler de (Colors) Material Design prensibine göre (Primary, Sec, Surface, Outline) `colors.xml` üzerine yazılır.

### Adım 4: Model/Katman (Package) Hiyerarşisinin Oluşturulması
* Root app dosyasına gidilir (Örn: `com.vibe.app`). Burada Java Class değil; sadece klasörleme (Domain Layering) yapılır.
* `models`, `ui`, `network`, `adapters`, `controllers` (veya presenters) isimli fiziksel paketler boş olarak yaratılır. Hiçbir obje henüz kodlanmaz.

---

## BÖLÜM 2: Beyin ve Omurga (Adım 5 - 9)

### Adım 5: Gelen Verilerin Modellenmesi (POJO & DTOs)
* Sistem `models` klasörüne odaklanır. API'den çekilecek veya RoomDB'de tutulacak Obje kalıpları (örneğin User, Product) yaratılır. 
* Gson kütüphanesi için tüm field'lara anotasyonları (`@SerializedName("id")`) eklenir. Asla CamelCase gelen API'ye güvenilerek Anotasyonsuz class yaratılamaz! Obfuscation (ProGuard/R8) yapıldığında sistem ÇÖKER.

### Adım 6: Ağ Omurgası (Network Singleton Cihazı)
* `network` paketine `ApiClient.java` açılır. Otonomi burada "Singleton (Anti-Instantiation)" yapısını kurar. Constructor'ı "private" hale getirerek dışarıdan instancce oluşturulmasını yasaklar. 
* OkHttp Interceptor'lar ile tüm giden isteklere Headerlar (Auth Token vs) eklenir. `Retrofit.Builder().client(httpClient)` ile birleşmesi sağlanır.

### Adım 7: Repository Kurulumu
* Model üzerinden beslenecek bir `UserRepository.java` açılır. Controller'mız direk Retrofit çağırmamalıdır. Retrofit bu Repository'nin içindedir. Eğer ileride Local Database gelirse, yapay zeka buraya ekleme yapar, mimarinin geri kalanı bozulmaz. 

---

## BÖLÜM 3: Müşteri Deneyimi ve Arayüz (Adım 8 - 12)

### Adım 8: XML Tasarımı (Responsive Material)
* Yapay zeka tasarım bölümüne geçer (`res/layout`). Ekranda istenilen içeriği dökmek için Flat (Düz) LinearLayout YERİNE, iç içe yapıyı azaltıp render maliyetini (%40'a varan CPU kurtarışı) kestiği için **`ConstraintLayout`** tercih eder.
* Form varsa `TextInputLayout` kullanılır (Hata metinlerini altından verebilmek için).
* Liste varsa `RecyclerView` zorunludur (ve her bir liste elemanı için `item_...xml` ayrıca çizilir).

### Adım 9: View ve Adaptörlerin Bağlanması
* Java Activity'ye (`MainActivity.java`) geçilir. `setContentView` içerisinden `ActivityMainBinding.inflate()` ile ViewBinding aktif edilir (FindViewById artık terkedilir). 
* Gelen listeler `adapters` içindeki Sınıf'a paslanır. Adaptörde `ViewHolder` konsepti %100 düzgün kurulur.

### Adım 10: Otonom Controller/Presenter Senkronizasyonu
* O Controller (Presenter) çağrıldığında, View'ın (ekranın) ne tepki göstereceği senkron edilir.
* UI Thread'i dondurmamak için Repository'den gelen sonuç bir Callback/Interface üzerinden (OnSuccess, OnError) Activity'ye gelir. 
* **KRİTİK HAMLE:** OnError çalıştıysa (Sistem api atarken error 500 kodu aldı veya parse patladıysa); Yapay zeka hiçbir zaman ekranı beyaz veya donuk bırakamaz. Anında "Sisteme erişilemedi / Bir şeyler ters gitti" pop-up/toast/snackbar tasarlamalısınız.

---

## BÖLÜM 4: Yayına Hazırlık ve Kalibrasyon (Adım 11 - 15)

### Adım 11: İnternet Algılama ve Hata Savuşturma
* Müşterinin interneti kesik olduğunda patlamamak için, istek atılmadan önce Network Util (ConnectivityManager) metodlarından geçirilip "Ağ Yok" hata mesajı UI üzerinden atılır.

### Adım 12: Geri Tuşu Yönetimi (Tuzaklar)
* Ana giriş sayfasında, kullanıcı Geri Butonuna (Hard Button / Swipe back) bastığında anında uygulama KAPANAMAZ. Bir Alert Dialog (Çıkmak istiyor musunuz?) çizilir. İç ekranlardaysa yığın (Stack) mimarisine uygun şekilde Fragment/Activity pop() edilir.

### Adım 13: Kaynak Optimizasyonu (Image Leakage)
* Eğer RecyclerView içerisinde veya Listelerde 100 Tane resim varsa, bunların Glide/Picasso ile gösterildiği teyit edilir. Custom AsnycTask ile resim indiren AI direkt iptal edilir. Cache strategy (DiskCacheStrategy.ALL) zorunludur.

### Adım 14: Lint ve Denetim (Self-Validation Test)
* Uygulama bittikten sonra AI kendi kodunu okuyup Lint kontrolü yapar. Stringleri Strings.xml'e taşımamış mı? `unused` importlar var mı? Memory Leak oluşturabilecek statik objeler var mı? Tüm bu Warning'ler silinir.

### Adım 15: Production-Ready Hali
* Proje hiçbir uyarı vermeden pırıl pırıl çalışmaktadır. Gerekli debug kodları (System.out.println) veya Hardcoded `Log.d` test satırları temizlenmelidir. Tüm proje, "Otonom Test" adımlarına uygun şekilde hazırdır. Teslim edilebilir.
