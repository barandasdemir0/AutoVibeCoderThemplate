# 5️⃣ Apple SwiftUI - Otonom Kriz Savunması & Debug İpuçları (Troubleshooting Kabusları)

> **OTONOM DEBUG KOMUTANESİ:** SwiftUI sihirli (Magic) çalışır; yani "Her şey kolay gibi görünür ama bir hata verdiğinde Xcode Asla Gerçek Hatayı (Root Cause) Göstermez". Basit bir virgül unuttuğunuz için Xcode size Gidip de "Type '() -> ()' cannot conform to..." diye alakasız 100 satırlık Generics hatası basar! Otonom ajan, Swift ve SwiftUI çökmelerinde (Crash logları okunamaz hale geldiğinde) bu Kriz Rehberi üzerinden "İz Sürerek (Trace)" cihazı diriltir! Sırları iyi ezberle.

---

## 🛠️ Çekirdek Otonomi (State ve Flow) Çökmeleri

### 1. Kırmızı Ekran Katliamı: `Fatal error: No ObservableObject of type X found. A View.environmentObject(_:) for X may be missing as an ancestor of this view.`
* **Krizin Sebebi:** Otonomi / Kullanıcı Bir Ekranın içine girip `@EnvironmentObject var userManager: UserManager` demiştir (Havadan global Obje istemiştir). Ancak Sistemi başlatan Ana dosyada (Örn `MyApp.swift`) Bu objeyi oluşturup, `.environmentObject(UserManager())` Kancasını ZERK ETMEYİ UNUTMUŞTUR!
* **Otonom Çözüm (Zorunlu):** Uygulama Saniyesinde çöker (Crash). Ajan hemen Ana Ekranın `.environmentObject()` ile sarmalandığını teyit eder. **KRITIK EK BİLGİ:** Sadece Sayfalar değil; sayfadan tıklanan ModaL'lar da (Sheet, FullScreenCover) Environment zıhını OTOMATIK ALMAZLAR! Onlar ayrı bir Pencere gibi olduğu için `.sheet(isPresented:) { DetailView().environmentObject(userManager) }` Şeklinde modal'a VEYA Preview Bloğuna Tekrar Enjekte (Re-inject) etmek Zorunludur! 

### 2. Ölümcül Döngü: `Modifying state during view update, this will cause undefined behavior.`
* **Krizin Sebebi:** Görsel (View) ÇİZİLMEYE DEVAM EDERKEN (Yani render metodu çalışırken), Gidip de bir İşlem (Örn: Fetch çağıran fonksiyon, Veya Liste Filtresi) State'i (`isLoading = true` vb.) Tekrar Değiştirdi. SwiftUI Motoru Baştan çizmeye kalktı... Yine Değişti... RAM sonsuz döngüden kitlendi.
* **Otonom Çözüm (Zorunlu Kırmızı Seçenek):** UI cizimi esnasinda ASLA Data Manipulasyonu State tetiklemesi YAPILMAZ! Eylem, kullanici Ekranı Görüp Girdiginde baslar. Yanı `Task { } ` Blokları `.onAppear { ... }` Modificator'u Icerisine Konur, Veya `task { await fetch() }` modifier'i ile Çizim döngüsü dısına itilir (Dispatch).

### 3. Asrın SwiftUI Gizemi: `The compiler is unable to type-check this expression in reasonable time...`
* **Krizin Sebebi:** Bir Elementin içine (VStack vs) Üst üste o kadar fazla `.padding()`, `.background()`, `.cornerRadius()`, `.shadow()`, Vb Mofifierlar zincirlendi VEYA karmasik matematik hesabı yapildi ki; Swift Derleyicisi (Compiler) kilitlendi. Kod hata vermez ama Xcode Saatlerce Çöker. 
* **Otonom Çözüm (Zorunlu):** Yapay Zeka HICBIR View i 15 - 20 Tane Modificator ile Şişiremez! Kod İzi kırılır (Break down). O Şişmiş dizilimi Alıp `extension View` icerisine Küçük, Temiz Bir `.customCardModifier()` yazarak View'in icinden dişariya cikartir. Tıkanikligin Gectigini Görür.

---

## 🎨 UI ve Çizim Limitlerinde Xcode Canvas (Preview) Zırhları

### 4. Xcode Preview Çöküşleri: "Failed to Build Preview - Cannot find type 'CustomModel' in scope"
* **Krizin Sebebi:** Otonomi, Uygulama motorunun dosyalarından birine CoreData (`NSManagedObject`) Modelini koydu. Preview çalıştığında Uygulama Başlamadığı (AppDelegate vs Tetiklenmedigi icin) için PersistentContainer (Database) Yoktur ve Preview Ekranı Çöker, Beyaz Ekran kalır.
* **Otonom Çözüm (Zorunlu):** Preview Blokları Hata Fırlatiyorsa Asla Kod ile Uğraşma (Kod Doğrudur). Sorun Preview'in "Mock Data (Sahte Verisi)" olmamasidir! Otonomi Preview bloklarina sahte InMemory Container'lar Veya Statik Modeller `HomeView(viewModel: PreviewMockData.viewModel)` atayarak Önizlemeleri Kusursuz hale getirmeye Otonomi Yasasi Geregi Mecburdur!

### 5. `Publishing changes from background thread is not allowed` (Mor Hata Ekrani / Main Thread Block)
* **Krizin Sebebi:** Ağdan (Background Thread) `URLSession` Datası Indi VEYA Uygulamada Arkaplanda İndirme islemi Gecikti... Sonuc `DispatchQueue.global(qos: .background)` Icinden ViewModel'in Icindeki `@Published var list = ...` Degistirildi! Apple Main thread de Olmayan BIR UI güncellenmesini engeller!
* **Otonom Çözüm (Zorunlu):** Eğer Otonomi Legacy Swift kullanıyorsa `DispatchQueue.main.async { self.list = data }` İle Ana isleme döner! (Geleneksel). Eğer Modern Swift kullaniyorsa Sınıfın basina `@MainActor` Anotasyonu (Zırhi) Kondurur VEYA Veri guncelleme metodunu `await MainActor.run { self.list = data }` Icerisinde Sınırlandırır! 

### 6. SafeArea İhlalleri (Tepeden Akan Resimler - Çentik Sorunu)
* **Krizin Sebebi:** iPhone x, 14, 15 vs cihazlarinda "Notch" veya "Dynamic Island" olduğu icın. NavigationBar arkasi veya klavye arkasi hesaba KAtılmadan, Dümdüz `ScrollView` konulursa yazilar ust saate kadar uçar veya TabBar in altina girip Cizgi ile kesilir. 
* **Otonom Çözüm (Zorunlu):** Klavye Cıktıgında UI'i itlemek icin `ScrollView` kullanılır. Apple Cihazi Sinarinin otesine tasmak Yalnizca `edgesIgnoringSafeArea(.all)` ile izinlidir O Da sadece FullScreen Maps (Harita) veya Splash Gorsellerinde Gecerlidir. 
