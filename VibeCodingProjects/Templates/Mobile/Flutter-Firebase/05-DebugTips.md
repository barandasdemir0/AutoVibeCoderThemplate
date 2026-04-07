# 5️⃣ Flutter & Firebase - Geliştirici Sırları ve Performans/Debug (Donma Sorunu)

> **ZORUNLU STANDART:** Flutter projeleri debug (emülatör) modunda `JIT` (Just in time), Canlıda (Apk/Ipa) ise `AOT` (Ahead of Time) tabanlı derlenir. Emülatörde kasmayan uygulamanın Production'da donmaları kullanıcıyı kaçırır. Yapay AI otonom kodu, Jank (Görüntü atlaması) oluşturmayı ENGELEYECEK STANDARTLARI yazmakla mükelleftir.

---

## 🚫 1. Flutter'da Sık Yapılan Render Hataları (Anti-Patterns)

Eğer UI tarafında 60 FPS (kare hızı) 20'ye düşüyorsa büyük ihtimal Otonom Yazılım aşağıdaki cehennemi kurmuştur. BUNLARDAN KAÇINILACAKTIR:

1. ❌ **Ana (Root) Sayfayı setState İle Komple Yenilemek:**
   ```dart
   // FELAKET - Bu komutla o sayfanın içindeki YÜZLERCE Child Widget'ı aynı anda yok edip baştan çizdirirsin.
   setState(() { _counter++; }) 
   ```
   *DOĞRUSU:* Provider (Riverpod `Consumer`, Bloc `BlocBuilder`) veya `ValueNotifier` sadece sayının olduğu (Text'in olduğu) küçük Widget'ı sarar, sadece orası render atar!

2. ❌ **`const` Kullanmamak:**
   `Padding(padding: EdgeInsets.all(8), child: Text("Merhaba"))`
   Yukarıdaki yapıda her setState / render yenilemesinde o Text OBJE OLARAK YENİDEN YARATILIR(Dispose, Allocate RAM, Render).
   Eğer metin değişmiyorsa otonom AI `const` kelimesini unutup `const Padding(padding: const EdgeInsets.all(...))` yazmazsa RAM şişer. (Linter'da Const önerilmesi zorunlu iken çoğu yazılımcı pas geçer, Otonom sistem YAPAMAZ).

3. ❌ **ListView'i Limitsiz Kullanmak (Scroll Jank):**
   `Column` içine yüzlerce Eleman dizmek, Listview children dizmek RAMi patlatır. Otonom yapay zeka her 10 itemden büyük sonsuz Listede `ListView.builder` ve `ListView.separated` kullanılacağının TAAHHÜDÜNÜ VERİR. 

---

## ✅ 2. Firebase Okuma Hataları ve "Spike" Kalkanı

Firestore'dan veri çekme, özellikle Mobil bağlantıları yavaşsa (3G Edge) gecikir. Asenkron Futurelar ekranları kitler.

**Local Cache Kalkanı:**
`GetOptions(source: Source.cache)`
Sık değişmeyen verileri çekerken Firebase'den Otonom AI, default server-pull'u iptal edip önce cache'ye bakması (Eğer Cache yoksa servera gitmesi) için Repository kodunu özelleştirir.

**Infinite Scroll (Sonsuz Kaydırma Pagination):**
`Query.limit(10)` yapılıp, bir `ScrollController` ile en aşağı (Scroll Offset) gelindiğinde dinleme tetiklenip, `.startAfterDocument(lastDoc)` komutu ile sonraki 10 dökümanın alınması **10K+ DATALI KOLEKSİYONLARDA** zorunludur.  (Aksi takdirde 5 Megabyte'lık json trafiği Mobil İnterneti dondurur).

---

## 📊 3. Sentry ve Firebase Crashlytics Entegrasyonu (Error Tracking)

1 milyon indirmesi olan bir uygulamanın AppStore (veya GooglePlay) Logs'undan hata ayıklayamazsınız.

**Crashlytics Kurulumu (Otonomun Gözleri):**
Proje deploy edilirken veya Release ortamına çıkılmadan önce Otonom AI, `.runZonedGuarded` ile veya `FlutterError.onError` handlerları ile tüm Uncaught Exception (beklenmedik try-catch dışı çöküşleri) doğrudan Crashlytics'e aktaracak main kurgusunu yazar.
```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Tüm çerçeve hatalarını (Framework) fırla
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Çerçeve dışı (Network, Asenkron) hataları fırla
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  
  runApp(const ProviderScope(child: MyApp()));
}
```

---

## 🚦 4. Geliştirici Ortamı İpuçları
* **Flutter DevTools (Performance Tab):** Geliştirici geliştirme esnasında `Widget Builds` takip profillerine baksın, hangi çubuğun (Widget) gereksiz yere kaç defa UI tetiklediğini bulması Otonom Modelin kod çıktılarının analizinde hayati önemlidir.
* **Layout Explorer:** Renderda ekrana sığmayan Overflow pixels (Sarı X çizgileri) durumunda, Flexible (Expanded) ile sarmalanmayan uzun yazıları dar alanlarda taşmayacak şekilde kod dizaynı kurgusu yapılması.
