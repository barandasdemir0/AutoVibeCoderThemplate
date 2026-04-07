# ⚡ Flutter & Firebase - OTONOM BEYİN (QUICK-START & MASTER RULES)

> **DİKKAT YAPAY ZEKA:** EĞER BU PROJEDE MOBİL UYGULAMA (FLUTTER) YAZACAKSAN, DEVAMATMADAN ÖNCE AŞAĞIDAKİ MOBİL YAZILIM KANUNLARINA (%100 UYUM) SAĞLAMAK ZORUNDASIN. BUNLARA UYACAĞINI ONAYLAMADAN ÜRETİME GEÇEMEZSİN. SPAGETTİ KOD VEYA UI/UX'İ DAĞINIK BİR YAPI ÜRETTİĞİNDE GÖREV SIFIRLANIR.

## 🚨 YASAKLAR LİSTESİ (ANTI-PATTERNS) - ASLA YAPMA!

1. ❌ **UI İÇİNDE FIREBASE ÇAĞRISI (AWAIT FIRESTORE) YASAKTIR:** 
   `ElevatedButton(onPressed: () async { await FirebaseFirestore.instance.collection('users').get(); })` Gibi bir kodu GÖRÜRSEN SİL! Flutter sayfaları SADECE ÇİZER. Bütün Firebase `.get()`, `.set()`, `.snapshots()` işlemleri `Data` veya `Repositories` dosyalarında (Repository sınıfları altında) yazılmak ve Provider/Bloc üzerinden yönetilmek (State olarak dinlenmek) ZORUNDADIR.

2. ❌ **LİSTELERDE / RESİMLERDE MEMORY LEAK (RAM TÜKETİMİ) YASAKTIR:** 
   Binlerce üyesi olan bir koleksiyonu `.listen` veya `.get()` ile Limitsiz çekemezsin. `limit(20)` koyacak ve "Scroll Edildikçe" yüklenecek Pagination kurgusu kuracaksın. Ayrıca İnternetten (Firebase Storage) gelen hiçbir resmi `Image.network` ile BOŞA ÇEKMEYECEKSİN! Tüm resimler Otonom şekilde `cached_network_image` paketi kullanılarak Cache'lenecek. 

3. ❌ **CONST KELİMESİNİ UNUTMAK VE PERFORMANS CİNAYETİ YASAKTIR:** 
   Eğer Widget ağacına `Padding(padding: EdgeInsets.all(8))` şeklinde `const` yazmadan padding veya Text basarsan Otonom Model hata yapıyor demektir. Her `build` anında hafızayı dolduran bu hatayı engelleyip, linter (analiz) kurallarını uygulayacaksın!

4. ❌ **NAVIGATOR.PUSH İLE YÖNLENDİRME (SPAGETTİ ROUTING) YASAKTIR:**
   Push / Pop mantığını terk et. Proje `GoRouter` tabanlı planlanacaktır (`context.go('/detail')`). Ayrıca, Uygulamanın Firebase Auth state'i değiştiğinde (Logout tetiklendiğinde) sistemin otomatik olarak `redirect:` parametresiyle Logine atması **ZORUNLUDUR**.

5. ❌ **MÜŞTERİYE "KIRMIZI EKRAN HATASI" GÖSTERMEK YASAKTIR:**
   Cihaz üzerinde çıkan "RenderFlex Overflow" veya "Null Check Operator on null value" gibi devasa kırmızı hata sayfalarını PRODUCTION esnasında kullanıcıya gösteremezsin! Tüm Asenkron işlemler `AsyncValue` (Riverpod) veya try-catch kalkanı ile korumalıdır. Firebase hata atarsa Error Alert/Toast fırlatılacak, UI ÇÖKMEYECEKTİR!

6. ❌ **GERİ (BACK) TUŞU UYGULAMAYI KAPATAMAZ (NAVİGASYON KIRILMASI YASAKTIR):**
   Android cihazlardaki donanımsal geri tuşuna (Hardware Back Button) veya iOS sürükleme (swipe) hareketine yanlış yanıt verilip, kullanıcının doğrudan APP'den atılması kesinlikle YASAKTIR. Root navigasyonda veya kilit sayfalarda `PopScope` (veya `WillPopScope`) kullanarak geri tuşunu intercept (yakala) et, gerekirse önce Drawer'ı, Modalları kapat, ancak en son menüde ise onayla.

7. ❌ **FIREBASE EKSİK ENTEGRASYONU YASAKTIR:**
   Web, iOS ve Android için Firebase projeye eklendiğinde `google-services.json` (Android), `GoogleService-Info.plist` (iOS) kurulumlarının eksiksiz yapılması ve proje içindeki config/initialization (Firebase Core) adımlarının platform odaklı hatasız bir şekilde tamamlanması ZORUNLUDUR.

---

## ✅ ZORUNLU MİMARİ YAPISI (FEATURE-BASED DIRECTORY)

Sistemi üretirken klasörlerini `screens/`, `services/`, `models/` diye yığmayacaksın! "04-FilesStructure" yönergesinde emredildiği şekilde, DOMAIN (Feature) bazlı izolasyonu sağla!

```text
/lib
 ├── /core                # Temel Renkler, Temalar, Sabitler, Evrensel Widgetlar 
 ├── /features            # İŞTE BURASI ODAK: /profile veya /cart adında aç,
 │    ├── /auth              
 │    │    ├── /data        => SADECE FIREBASE BİLEN REPOLAR
 │    │    ├── /presentation=> SADECE EKRAN ÇİZEN WIDGET VE RIVERPODLAR
 ├── /routes              # GoRouter Objeleri.
 └── main.dart            # Kök ve Başlangıç, Firebase init.
```

---

## 🛠️ BAŞLAMADAN ÖNCE BİLMEN GEREKEN İLK ADIM

Eğer User sana "Instagram benzeri bir app yap" dediyse dahi,
**BU DOSYA (QUICK-START)** seni bağlar. 

1. Başlangıçta Material3'ü etkin kıl ve Temayı (Siyah/Beyaz Pürüzsüz Renk Tonları) belirle.
2. Firebase Authentication mantığını Riverpod (Provider) içine sar.
3. Kullanıcı giriş yapmamışsa Ana sayfaları görmesine ASLA İZİN VERME. GoRouter `redirect` ile engelle.
4. Mükemmel bir NavigationBar oluştur, ardından ekranları tek tek (Skeleton yüklü, Lottie animasyonlu, pürüzsüz) tasarla.

**FLUTTER 60 FPS (HATTA 120 FPS) ÇALIŞAN HARİKA BİR MOTORDUR, KÖTÜ KODLA BUNU BOZMA! BAŞLAYABİLİRSİN!**
