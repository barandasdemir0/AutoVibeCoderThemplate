# ⚡ NATIVE MOBILE (SwiftUI / Kotlin) - OTONOM BEYİN (QUICK-START & MASTER RULES)

> **DİKKAT YAPAY ZEKA:** EĞER BU PROJEDE MOBİL UYGULAMA İÇİN `NATIVE (SWIFT VEYA KOTLIN)` KULLANIYORSAN, AŞAĞIDAKİ TİP-GÜVENLİ, DERLEMELİ (COMPİLED) VE DONANIMA YAKIN (ENTERPRISE) STANDARTLARA %100 UYMAK ZORUNDASIN. BU BİR WEB VEYA CROSS-PLATFORM PROJESİ DEĞİL. UFAK BİR "ZORLA ÇALIŞTIRMA (!)" HATASINDA VEYA KÖTÜ ASYNC MİMARİSİNDE BÜTÜN UYGULAMAYI KULLANICIDA ÇÖKERTİRSİN (CRASH YER). KESİN KONTROL İLE İLERLE!

## 🚨 YASAKLAR LİSTESİ (ANTI-PATTERNS) - ASLA YAPMA!

1. ❌ **FORCE UNWRAPPING (!) KULLANIMI KESİN VE NET OLARAK YASAKTIR:** 
   Eğer Otonom AI; Swift Kodlarken veya Kotlin'de Nullable bir Girdiye `user.name!` diyerek "Ben eminim bu var" Derse ve Çekerse MÜTHİŞ BİR KATLİAM YAPMIŞTIR!! Kullanıcının Profili O an Yüklenmediyse Cihaz Hata Basıp Ana Ekrana Atar (SIGABRT). 
   *DOĞRUSU:* Otonomi Projeyi Asla Tehlikeye atamaz. `guard let` veya `if let` (Kotlin için `?let`) Şeklinde Kalkanlı Kod Kodlayacaktır! Yada Çökmesi Yerine Placeholder (Boş String) "Belirsiz" döndürecektir `user.name ?? "isimsiz"`.

2. ❌ **VIEW (EKRAN) DOZYALARI İÇERİSİNDE API/SQL MATEMATİĞİ (İŞ MANTIĞI) YASAKTIR:** 
   Eğer Otonom AI; `ContentView.swift` veya `MainActivity.kt`'nin İçine Gidiyor, Ekranda Çizdiği Butonun Tıklama Func'ının İçine Http Request (İstek) Açıyor ve Dönen JSON'ı Kendi Parse Ediyorsa (God Class Formatı) Sistem MİMARİYİ ÇÖPE ATMIŞTIR.
   *DOĞRUSU:* Mükemmel Native Mimarinin Zirvesi MVVM (Model-View-ViewModel) dir. Otonomi Her Ekranın Yanına O Ekranın İş ve Ağ yükünü üstlenen Bir View-Model Yaratacak, Data (State) Bindingle UI'a verecektir!

3. ❌ **NETWORK (AĞ) İSTEKLERİNİ MAIN THREAD'DE (ANA AKIŞTA) ÇAĞIRMAK YASAKTIR:** 
   Kabul edilemez Native Hatası! Ağı Beklerken `URLSession` senkron çekilirse O anki Ekran (ScrollView VEYA Butonlar) Sunucudan 200 Ok dönene Kadar 2 Saniye DONMUŞ (KİTLENMİŞ) Gözükür!! Kullanıcı Uygulamanın Bozulduğunu Sanar!
   *DOĞRUSU:* Bütün Download ve Fetch, Asenkron (Task / Coroutines Dispatchers.IO) da Atılır, UI (Ekrana Rengi/Veriyi Basma Tarafı) KESİNLİKLE `DispatchQueue.main.async` veya (MainActor) da Çekilerek Güncellenir!!!

4. ❌ **LOKAL İŞ KURALLARINDA MAGIC STRINGLER VE KÖTÜ KAYNAK KULLANIMI YASAKTIR:**
   `Text("Ana Menü")` Diye Elle Her Yere Yazılmaz (Erişilebilirlik ve Translates Biter). `Color(hex: "#FF00")` diye Hardcoded Yapılamaz (Karanlık Tema Çöker). Bunlar Assetlere atılır, Semantic Colors (Color.primary vb) İle Dinamik Native Yaklaşımlarası (Sistem ayarlarına Otonom Olan Tasarım) Dizilir!.

---

## ✅ ZORUNLU MİMARİ YAPISI (N-TIER ENTERPRISE)

```text
/native-workspace
 ├── /App               => UYGULAMA GİRİŞ Noktası, DI Enjeksiyonu ve Global Sentry/Firebase INITleri
 ├── /Core              => DOMAINE(Özeliğe) AİT OLMAYAN Generic Ağ İstemcileri, Helper Classları Bütünleşik Olarak
 ├── /Features          => 🚀 MÜTHİŞ İZOLASYON (Tüm Ürün, Login, Sipariş Sınırları) Ayrı Modüller Olarak!
 │    ├── /Login           => İçerisinde (Models, ViewModels(Beyin), Views(Ekran)) Mimarisiyle Saf tutar!
 └── /Resources         => RESİMLER (Assets) ve Localizable (Diller)
```

---

## 🛠️ BAŞLAMADAN ÖNCE BİLMEN GEREKEN İLK ADIM

Eğer User sana "Çalışan Haritalı (MapKit) Bir Takip Uygulaması Ver" dediyse dahi,
**BU DOSYA (QUICK-START)** seni bağlar. 

1. Başlangıçta Tüm SwiftUI Veya Compose Projeni Declarative Temelde MVVM ile Konfigüre edeceksinn. Asla (UIView VEYA Eski XML) Layoutları Üretmeyeceksin! YENI NESİL YAZILIM!
2. Dış Network işlemleri ve Veri Çekimleri İçin Kapsüllü Generic API Manager Çiz! (Tek yerden Handle Error). 
3. Ekranda Dönen Yükleme İşlemleri için Cihazın ProgressView'ıni ve Skeleton yapıları Mükemmel Kullan ve KESİNLİKLE Veri Gelmeden Uygulamanın Kullanıcıya Boş Bir Ekran Gostermesine (Zayıf Ux) İzin Verme!.
4. Otonomi Motoru Native Dünyada RAM şişikliklere Yol Açmamak İçin Memory (Closure) kilitlerini Açmalı `[weak self]` ibaresi Kullanımını Tüm Closure Callbacklerinde Asla UNUTMAMALIDIR!

**NATIVE UYGULAMALAR ZİRVE PERFOMANSI İFADE EDER, WEB SİTESİ UCUZLUĞUNA KAÇMAMALISIN! BAŞLAYABİLİRSİN!**
