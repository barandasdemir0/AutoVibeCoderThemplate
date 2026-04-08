## SEQUENCE-ENGINE v1 (ZORUNLU)
Bu template ile calisirken sirayi bozmak YASAK:
1) QUICK-START.md
2) 01-Planning.md
3) 02-Architecture.md
4) 03-StepByStep.md
5) 04-FilesStructure.md
6) 05-DebugTips.md
7) 06-Resources.md

Kural:
- Her dosyadan sonra 3-5 maddelik "cikarim ozeti" yaz.
- Ozeti yazmadan sonraki dosyaya gecme.
- 7 dosya tamamlanmadan kod uretimine baslama.
- Bu akisin detay standardi: Templates/_Universal/TEMPLATE-SEQUENCE-ENGINE.md

---
# ⚡ NATIVE MOBILE (SwiftUI / Kotlin) - OTONOM BEYİN (QUICK-START & MASTER RULES)

> **DİKKAT YAPAY ZEKA:** EGER BU PROJEDE MOBİL UYGULAMA İÇİN `NATIVE (SWIFT VEYA KOTLIN)` KULLANIYORSAN, AGAgIDAKİ TİP-GÜVENLİ, DERLEMELİ (COMPİLED) VE DONANIMA YAKIN (ENTERPRISE) STANDARTLARA %100 UYMAK ZORUNDASIN. BU BİR WEB VEYA CROSS-PLATFORM PROJESİ DEGİL. UFAK BİR "ZORLA CALISTIRMA (!)" HATASINDA VEYA KÖTÜ ASYNC MİMARİSİNDE BÜTÜN UYGULAMAYI KULLANICIDA ÇÖKERTİRSİN (CRASH YER). KESİN KONTROL İLE İLERLE!

## YASAKLAR LİSTESİ (ANTI-PATTERNS) - ASLA YAPMA!

1. ❌ **FORCE UNWRAPPING (!) KULLANIMI KESİN VE NET OLARAK YASAKTIR:** 
   Eğer Otonom AI; Swift Kodlarken veya Kotlin'de Nullable bir Girdiye `user.name!` diyerek "Ben eminim bu var" Derse ve Çekerse MÜTHİg BİR KATLİAM YAPMIGTIR!! Kullanıcının Profili O an Yüklenmediyse Cihaz Hata Basıp Ana Ekrana Atar (SIGABRT). 
   *DOGRUSU:* Otonomi Projeyi Asla Tehlikeye atamaz. `guard let` veya `if let` (Kotlin için `?let`) geklinde Kalkanlı Kod Kodlayacaktır! Yada Çökmesi Yerine Placeholder (Boş String) "Belirsiz" döndürecektir `user.name ?? "isimsiz"`.

2. ❌ **VIEW (EKRAN) DOZYALARI İÇERİSİNDE API/SQL MATEMATİGİ (İg MANTIGI) YASAKTIR:** 
   Eğer Otonom AI; `ContentView.swift` veya `MainActivity.kt`'nin İçine Gidiyor, Ekranda Çizdiği Butonun Tıklama Func'ının İçine Http Request (İstek) Açıyor ve Dönen JSON'ı Kendi Parse Ediyorsa (God Class Formatı) Sistem MİMARİYİ ÇÖPE ATMIGTIR.
   *DOGRUSU:* Mükemmel Native Mimarinin Zirvesi MVVM (Model-View-ViewModel) dir. Otonomi Her Ekranın Yanına O Ekranın İş ve Ağ yükünü üstlenen Bir View-Model Yaratacak, Data (State) Bindingle UI'a verecektir!

3. ❌ **NETWORK (Ag) İSTEKLERİNİ MAIN THREAD'DE (ANA AKIGTA) ÇAGIRMAK YASAKTIR:** 
   Kabul edilemez Native Hatası! Ağı Beklerken `URLSession` senkron çekilirse O anki Ekran (ScrollView VEYA Butonlar) Sunucudan 200 Ok dönene Kadar 2 Saniye DONMUg (KİTLENMİg) Gözükür!! Kullanıcı Uygulamanın Bozulduğunu Sanar!
   *DOGRUSU:* Bütün Download ve Fetch, Asenkron (Task / Coroutines Dispatchers.IO) da Atılır, UI (Ekrana Rengi/Veriyi Basma Tarafı) KESİNLİKLE `DispatchQueue.main.async` veya (MainActor) da Çekilerek Güncellenir!!!

4. ❌ **LOKAL İg KURALLARINDA MAGIC STRINGLER VE KÖTÜ KAYNAK KULLANIMI YASAKTIR:**
   `Text("Ana Menü")` Diye Elle Her Yere Yazılmaz (Erişilebilirlik ve Translates Biter). `Color(hex: "#FF00")` diye Hardcoded Yapılamaz (Karanlık Tema Çöker). Bunlar Assetlere atılır, Semantic Colors (Color.primary vb) İle Dinamik Native Yaklaşımlarası (Sistem ayarlarına Otonom Olan Tasarım) Dizilir!.

---

## ✅ ZORUNLU MİMARİ YAPISI (N-TIER ENTERPRISE)

```text
/native-workspace
 ├── /App               => UYGULAMA GİRİg Noktası, DI Enjeksiyonu ve Global Sentry/Firebase INITleri
 ├── /Core              => DOMAINE(Özeliğe) AİT OLMAYAN Generic Ağ İstemcileri, Helper Classları Bütünleşik Olarak
 ├── /Features          => ?ci MÜTHİg İZOLASYON (Tüm Ürün, Login, Sipariş Sınırları) Ayrı Modüller Olarak!
 │    ├── /Login           => İçerisinde (Models, ViewModels(Beyin), Views(Ekran)) Mimarisiyle Saf tutar!
 └── /Resources         => RESİMLER (Assets) ve Localizable (Diller)
```

---

## BAGLAMADAN ÖNCE BİLMEN GEREKEN İLK ADIM

Eğer User sana "Çalışan Haritalı (MapKit) Bir Takip Uygulaması Ver" dediyse dahi,
**BU DOSYA (QUICK-START)** seni bağlar. 

1. Başlangıçta Tüm SwiftUI Veya Compose Projeni Declarative Temelde MVVM ile Konfigüre edeceksinn. Asla (UIView VEYA Eski XML) Layoutları Üretmeyeceksin! YENI NESİL YAZILIM!
2. Dış Network işlemleri ve Veri Çekimleri İçin Kapsüllü Generic API Manager Çiz! (Tek yerden Handle Error). 
3. Ekranda Dönen Yükleme İşlemleri için Cihazın ProgressView'ıni ve Skeleton yapıları Mükemmel Kullan ve KESİNLİKLE Veri Gelmeden Uygulamanın Kullanıcıya Boş Bir Ekran Gostermesine (Zayıf Ux) İzin Verme!.
4. Otonomi Motoru Native Dünyada RAM şişikliklere Yol Açmamak İçin Memory (Closure) kilitlerini Açmalı `[weak self]` ibaresi Kullanımını Tüm Closure Callbacklerinde Asla UNUTMAMALIDIR!

**NATIVE UYGULAMALAR ZİRVE PERFOMANSI İFADE EDER, WEB SİTESİ UCUZLUGUNA KAÇMAMALISIN! BAGLAYABİLİRSİN!**

