# ☕ QUICK START: Native Java-Android (MVC/MVP) Otonom Başlatma Komutları

> **DİKKAT YAPAY ZEKA:** EĞER BU PROJEDE NATIVE ANDROID (JAVA) YAZACAKSAN, GELENEKSEL AMA GÜÇLÜ OLAN JAVA-XML MİMARİSİNE %100 UYUM SAĞLAMAK ZORUNDASIN. BU BİR FLUTTER VEYA KOTLIN-COMPOSE PROJESİ DEĞİLDİR! SPAGETTİ KOD YASAKTIR!

## 🚨 YASAKLAR LİSTESİ (ANTI-PATTERNS) - ASLA YAPMA!

1. ❌ **ACTIVITY İÇİNDE İŞ MANTIĞI YASAKTIR (God Object):**
   Tüm veritabanı (SQLite/Room) veya API (Retrofit) işlemlerini doğrudan `MainActivity.java` veya fragmentlar içine yazamazsın. Activity ve Fragment SADECE UI (XML) elementlerini birbirine bağlar. Mutlaka bir Controller/Presenter Sınıfı oluştur ve işi ona devret (MVC/MVP kuralı).

2. ❌ **MAIN THREAD (UI THREAD) BLOKLAMAK YASAKTIR:**
   Network isteklerini (API) veya ağır veritabanı okumalarını Main/UI thread üzerinde yaparsan uygulama çöker (ANR hatası). Asenkron görevler için modern ExecutorService, Handler, RxJava veya düzgün Retrofit callback'leri (Call<T>) KULLANMAK ZORUNDASIN.

3. ❌ **GERİ (BACK) TUŞU UYGULAMAYI KAPATAMAZ:**
   Aktiviteler arası veya fragmentlar arası geçişte yığın (BackStack) yapısını bozmak yasaktır. Donanımsal geri tuşuna (onBackPressed / OnBackPressedDispatcher) doğru müdahale edilecek. Eğer kullanıcı iç bir menüdeyse uygulamanın kökden kapanması ENGELLENECEK.

4. ❌ **XML TASARIMLARINDAKİ 'BERBAT' GÖRÜNÜM YASAKTIR:**
   Düz ve çirkin LinearLayout butonlarıyla iş bitirilemez! Material Design bileşenleri (`MaterialButton`, `CardView`, `TextInputEditText`) kullanılacaktır. Padding (`16dp`, `24dp`), elevation, cornerRadius özellikleri eklenerek arayüze "Premium" his verilecektir. Hardcoded strings yerine `res/values/strings.xml` kullan.

---

## ✅ ZORUNLU MİMARİ YAPISI (MVC / MVP DIRECTORY)

Sistemi üretirken paketleri (package) MVC/MVP mantığına göre sınıflandır. Uygulama "com.example.app" altında şu yapıyı sağlamalı:

```text
/app/src/main/java/com/example/app
 ├── /models          # Veri nesneleri ve Room Entity'ler
 ├── /controllers     # İş mantığı, Retrofit çağrıları (Presenter)
 ├── /adapters        # RecyclerView adaptörleri
 ├── /ui              # Activity ve Fragment sınıfları (Feature bazlı alt klasörlenebilir: /ui/login)
 ├── /network         # Retrofit Client, API Interfaceleri
 └── App.java         # Application sınıfı (Global state/init)
```

**XML Kaynakları:**
Tasarım sadece `/res/layout` klasöründen yönetilecek. Renk paleti (`colors.xml`) Material 3 standartlarında (koyu gri dark mode destekli) yapılandırılacak.

---

## 🛠️ BAŞLAMADAN ÖNCE BİLMEN GEREKEN İLK ADIM

Eğer User sana "Java ile bir Todo uygulaması veya E-Ticaret uygulaması yap" aediyse dahi, **BU DOSYA (QUICK-START)** seni bağlar.

1. `build.gradle` (Gereken kütüphaneleri ekle: Retrofit, Glide/Picasso, Material Components, Room vb.).
2. Eğer "Çoklu Dil" (i18n) isteniyorsa, ActionBar/Menu'ye dil değiştirici buton ekle ve Android `Configuration` `Locale` update yapısını kur. Arayüz Dili DEĞİŞEBİLMELİ.
3. Tasarımlar XML tarafında görsel kaliteye sahip olacak (dp/sp birimlerini doğru kullan).
4. Uygulamayı ayağa kaldır ve Logcat'e temiz hata logları (Log.e) bastığından emin ol. 

**JAVA GÜÇLÜ VE KÖKLÜ BİR DİLDİR, DİSİPLİNLİ KODLA, XML VE JAVA'YI TEMİZ AYIR!**
