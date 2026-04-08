# 05-Debug Tips (Sık Karşılaşılan Java/Android Kabusları ve Analizi)

> **OTONOM DEBUG KOMUTANESİ:** Android Java ekosistemi yapay zekanın "try-catch yaz geç" diyerek atlatabileceği kadar basit bir alan değildir. Bir "Application Not Responding (ANR)", RAM Şişmesi veya Memory Leak cihazı kilitleyebilir ve uygulamanın silinmesine yol açabilir. AI, debug süreçlerini yönetirken aşağıdaki listedeki kriz senaryolarını bir "Doktor" edasıyla çözecek, asla hatayı sessizce yutmayacaktır!

---

## 🛠️ Temel Karşılaşılan Native Çökmeler (Crash Scenarios)

### 1. `NetworkOnMainThreadException` (KÖKSEL HATA)
* **Krizin Sebebi:** Retrofit veya OkHttp ile bir API isteği atıldığında `call.execute()` kullanılırsa (senkron çağrı), bu çağrı bitene kadar Android Main Thread (Ana Ekran İşlemcisi) Donar. Sisteme kilitlenmeye karşı olarak O.S. anında uygulamayı çökertir.
* **Otonom Çözüm (Zorunlu):** Ajan bu hatayı gördüğü saniye `call.execute()` komutunu bulup silecek, yerine Callback (Interface) yapısı kullanan Asenkron `call.enqueue(new Callback<T>())` sistemine geçiş yapacaktır. Veya Executors altyapısına yollayıp background thread'de oyalayacaktır.

### 2. `ANR (Application Not Responding) Dialog` Görünürlüğü
* **Krizin Sebebi:** Uygulamanın Main Thread'i (`UI Thread`) 5 saniyeden fazla bir göreve hapsedilmiş demektir. Örneğin; Ana thread'de (Activity OnCreate)'te kocaman bir Veritabanı (SQLite/Room) okuması veya BitMap resmi işleme (Blur effect vs) uygulanmıştır.
* **Otonom Çözüm (Zorunlu):** Kilitlenen görevi tespit et! Hemen `new Thread(new Runnable() ...).start();` VEYA modern modern kullanım olan `ExecutorService` sistemine postala. Arka planda biten işin sonucunu UI'a bildirmek için `runOnUiThread` O.S aracını kullanmak ZORUNLUDUR! (Çünkü UI güncellemeleri hariç Background'dan UI'a erişilemez: `CalledFromWrongThreadException` patlatır!).

### 3. `NullPointerException (NPE)` (Meşhur Java Ölümü)
* **Krizin Sebebi (Tuzak):** Java bir NullPointerException verdiğinde Genelde ViewBinding kurulmayan veya `setContentView(R.layout...)` metodundan **ÖNCE** çalıştırılan klasik kodlarda meydana gelir. Oje `onCreate` içerisinde henüz "inflate" edilmemiştir (şişirilmemiştir).
* **Otonom Çözüm (Zorunlu):** Activity içerisinde UI öğelerine erişmeden önce kesinlikle `ViewBinding` kalıplarını teyit edin. Eğer Controller'da (Presenter) null değeri geldiyse, Otonom Java `if(obj != null)` kalkanını (veya `@NonNull` , `@Nullable` anotasyonlarını) kullanmayı unutmuştur!

### 4. `java.lang.SecurityException: Permission denied (INTERNET)` VEYA (READ_EXTERNAL_STORAGE)
* **Krizin Sebebi:** Resim çekme izni, galeriye girme izni veya HTTP çağrısı; ancak ajan bu tehlikeli izinleri (Dangerous Permission) kullanıcıya sormadı veya Manifest'e (Proklamasyon) yazmadı!
* **Otonom Çözüm (Zorunlu):** 
  - İnternetse: `AndroidManifest.xml` aç ve `<uses-permission android:name="android.permission.INTERNET" />` ekle.
  - Galeri ise: Android 13+ (API 33+) gereği `READ_MEDIA_IMAGES` istenmeli, API 33 altıysa `READ_EXTERNAL_STORAGE` istenmeli! Kodlarda `ContextCompat.checkSelfPermission` zırhı eklenmeden donanıma ulaşılamaz!

---

## 🛑 Özel Mimari Hatalar ve Tuhaf Çökmeler (Hard-to-Reproduce)

### 5. `IllegalStateException: Can not perform this action after onSaveInstanceState`
* **Krizin Sebebi:** Bir Network isteği attık, asenkron 10 saniye sürdü. Kullanıcı o arada Uygulamayı alta aldı VEYA ekranı döndürdü (`onSaveInstanceState` tetiklendi ve UI askıya alındı). Veri 11. saniyede gelip bir Fragment açmak istedi... Sistem patlar!
* **Otonom Çözüm (Zorunlu):** FragmentTransaction işlerken (geçişlerde), eğer sistem askıya alındıktan sonra bu işlem oluyorsa `commit()` yerine `commitAllowingStateLoss()` metodunu kullanacak!

### 6. "RecyclerView Elemanları Hızlı Kaydırınca (Scrol) Resimler ve Metinler Birbirine Karışıyor"
* **Krizin Sebebi:** RecyclerView adaptöründeki `onBindViewHolder` içinde, elemanları yeniden kullanma (`recycle`) mekanizması vardır. Eğer View recycled (geri dönüşüm) edildiyse ama yeni veri eskisinin üzerine yazılmazsa, eski veriler/görseller hortlar. Tembel yüklenen (Lazy-load) Resimlerin `Glide` asenkron işleyişi yanlış resme atanıyordur!
* **Otonom Çözüm (Zorunlu):** `onBindViewHolder` içerisinde kesinlikle IF koşullarının ELSE durumlarını da yaz. Bir texti "Kırmızı" yapıyorsan "Else" durumunda "Siyah" da yap. Ayrıca Glide ile resim yüklüyorsan, ViewHolder'ın Recycle edilmesi anında `Glide.with(context).clear(imageView)` diyerek arabellekteki kirli işi boşaltın!

### 7. O.O.M (Out of Memory) Logcat Warning'leri
* **Krizin Sebebi:** Devasa kalitede (`10 MB`) PNG veya JPG dosyaları doğrudan XML içinde `@drawable/arkaplan` edilerek yüklendi veya Listelerde Bitmap çözümsüz kaldı. Android cihazın kısıtlı Application Heap (128 MB vd) doldu taştı.
* **Otonom Çözüm (Zorunlu):** `AndroidManifest.xml` içerisindeki `<application>` tagına asla korkak gibi `android:largeHeap="true"` çakıp gitmeyin (Bu bir yara bandıdır). Resimleri `Glide` veya `Picasso` modülü ile `.override(500,500)` gibi resize ederek RAM'e optimize indirin. Sabit resimleri `.webp` (Sıkıştırılmış form) yapın.

---

## 🔍 Otonom Loglama (Logging) Disiplini

Otonomi çalışırken ekrana debug mesajı basmak için `System.out.println("TEST");` kullanamaz.
Android ekosisteminin profesyonel Logcat analizörü kullanılır:

```java
// Kötü
System.out.println("Hata var: " + t.getMessage());

// Kurumsal
Log.e("AuthPresenter", "Login isteği ağda koptu!", t);
Log.d("AuthPresenter", "Token başarıyla Parse edildi: " + tokenModel.getToken());
```

Tüm Hata bloklarında (Catch block) eziyet edilen Exceptionlar sadece `t.printStackTrace();` ile geçiştirilemez. Kullanıcıya bir UI (View Interface) üzerinden tepki verilir. (Örn: `view.showError("Bir bağlantı sorunsalı oldu")`). Bu bir Otonom Zeka protokol sözleşmesidir!
