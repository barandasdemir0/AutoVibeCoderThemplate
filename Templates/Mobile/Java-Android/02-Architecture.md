# 02-Architecture (Native Java MVC/MVP Katmanları) - Otonom Mimari Protokolü

> **MİMARİ ZIRH UYARISI:** Bir Android projesi geliştiren Otonom Model, standart (frontend) bir mantıkla çalışamaz. Android Context (Activity veya Fragment nesnesi) dünyanın en ağır, en tehlikeli nesnelerindendir. Mimarinin asıl amacı `Context` sızıntısını (Memory Leak) engellemektir. Bu belge %100 UYULMASI GEREKEN Kurumsal Katman Protokolüdür!

---

## 🏗️ Mimari Şema: İzole Java (Clean Context Separation)

Aşağıdaki UML gösterimi otonom zekanın kurgulayacağı Java (Android) mimarisinin sınırlarını çizer. Sistem 3 (üç) net bloğa ayrılacaktır. Geleneksel Java Android geliştirme döngüsünde En büyük tuzak "God Object Activity (Binlerce satırlık iş yapan ekranlar)" üretilmesidir. Sistemde UI (XML) ile Logic (Veritabanı, Ağ) birbirinden İZOLE EDİLMEK ZORUNDADIR.

```mermaid
graph TD
    subgraph UI Katmanı (Android Lifecycles)
    UI[View - Activity/Fragment + XML]
    end

    subgraph İş Mantığı (Logic - Sadece Java Sınıfları)
    Presenter[Controller / Presenter]
    end

    subgraph Data Katmanı (Veri Yönetimi)
    Model[Repository / Data Source]
    Network[Retrofit Cihazı / REST API]
    LocalDB[Room DB / SharedPreferences / Cache]
    end

    UI <-->|Kullanıcı Girdisi (Butona Basıldı) / UI Update (Göster)| Presenter
    Presenter <-->|Veri Getir / Caching İsteği| Model
    Model -->|Eğer Yoksa Çek| Network
    Model <-->|Eğer Varsa Getir/Kaydet| LocalDB
```

---

## 🛡️ Ana Prensipler ve Android "Context" Yönetimi

### 1. View (XML & Activity/Fragment) - Kısıtlamalar
- **Görevi:** Sadece ama sadece ekranı çizmek, ViewBinding aracılığıyla butonlara (Listeners) kulak asmak ve Controller'dan gelen temiz/formatlanmış (Örn: "₺500" String) verileri TextView veya RecyclerView'a yapıştırmak.
- **YASAKLAR:** `MainActivity.java` içine Retrofit `call.enqueue()` YAZAMAZSIN! Veritabanı (SQLite/Room) açıp veri okumak YASAKTIR. Form (Email/Password) denetimi yapmak (örn: `if(email.contains("@"))`) Controller'a yönlendirilmeden View içinde yapılamaz.
- **Uygulama Şekli:** Bütün ekranlar (Activities/Fragments) bir View Interface uygular (`loginView` interface'i gibi). Ve bir `Presenter` nesnesi yaratıp, kendisini parametre (`this`) olarak atar.

### 2. Controller/Presenter (Java) - Beyin Katmanı
- **Görevi:** İşi yapan beyindir. Repository'ye "veriyi çek" emri verir, Asenkron dönüşü (Callback) bekler, dönen Json nesnesini filtreler, View'a `view.showProgressBar()` ve ardından `view.showData(list)` komutlarını gönderir.
- **YASAKLAR (KRİTİK):** Bir Presenter'ın parametre olarak bir `Context` (Örn: Activity'nin ta kendisi) tutması ve Uygulama kapandığında ya da ekran yan döndüğünde (Activity Destroy) o referansı bırakmaması MEMORY LEAK (Hafıza Çöküşü) sebebidir. Uygulama anında çöker!
- **Uygulama Şekli:** Otonomi, Controller içerisinde mutlaka View referansını serbest bırakan (Null atayan) bir `onDestroy()` ve `onDetach()` fonksiyonu yazacak ve View yok olduğunda arka plandaki tüm Retrofit çağrılarını `.cancel()` yapacaktır.

### 3. Model / Repository (Java) - Tek Kaynak Doğrusu (Single Source of Truth)
- **Görevi:** Controller gelip "Kullanıcı verisini getir" dediğinde verinin API'den mi geleceğine, yoksa İnternet olmadığı için Room DB'den mi alınacağına Repository karar verir. Controller bunu bilmez ve umursamaz.
- **Uygulama Şekli:** Gelen JSON objesini GSON vasıtasıyla Saf Java objelerine (POJO) dönüştürür ve geriye Controller'a (Observer pattern veya Callbacks ile) sunar.

---

## 🚀 Network Katmanı (Retrofit) Kuralları (Hard Bounds)

Network katmanı şakaya gelmez; API haberleşmesi esnasında donma, crash veya hatalı veri kabul edilemez.

1. **Singleton İstemci:** Otonom ajan `ApiClient.java` isminde bir sınıf açacak ve Retrofit objesini **Singleton Design Pattern** (Sadece 1 kez RAM'e yüklenen obje) ile kuracaktır. Her istekte `new Retrofit.Builder()` yapılamaz!
2. **DTO (Data Transfer Objects) Kullanımı:** API'den gelen verilerin 100 tane alanı (field) olabilir. Bizim uygulamamız sadece 3 alanını (id, isim, fiyat) kullanacaksa; Models içine devasa sınıflar koymak yasaktır. Sadece ihtiyacımız olan alanları (`@SerializedName`) kapsayan bir DTO üretilir. Çöp veriler (Garbage) RAM'e sokulmaz.
3. **Timeout Stratejileri:** OkHttpClient (Bina bloğu) içine zorunlu olarak connectTimeout, readTimeout, writeTimeout (Örn: 15-20 saniye) parametreleri yerleştirilecektir. Kötü interneti olan kullanıcılar (3G vb) sonsuza dek beyaz ekran bekleyemez, zaman aşımı Exception'ı UI tarafında yakalanıp "Ağ yavaş!" uyarısına çevrilecektir.

---

## 🛠️ State Management ve Lifecycle Senaryoları (Hayatta Kalma)

- Eğer kullanıcı veri beklerken (API Load) ekranı yana çevirirse (Landscape Mode), Android O.S mevcut Activity'yi öldürür (`onDestroy()`) ve yeni bir Activity baştan çizer (`onCreate()`). Eğer zeka bu durumu "Handle" etmezse uygulamanız ÇÖKER (`NullPointerException`).
- **Otonomi Emri:** Ya ViewModel / LiveData konseptini (Android Architecture Components) kullanıp veri akışını Activity yaşantısından bağımsız tutacaksın, ya da klasik MVC kullanırken `onSaveInstanceState` / `onRestoreInstanceState` kullanarak ekran yan dönmelerinde veriyi geçici Bundle'lar içine kaydedip tekrar ekranı çizeceksin. 

**Bu mimarinin dışına çıkıp dümdüz spagetti kod yazıp, sadece çalışıyor diye teslim etmek Kırmızı Çizgi ihlalidir!**
