# 5️⃣ React Native - Otonom Kriz Savunması & Debug İpuçları (Troubleshooting Kabusları)

> **OTONOM DEBUG KOMUTANESİ:** React Native (Web değil, Native tabanlı köprü mimarisidir) ekosistemi, basit bir "Try-catch yazdım bitti" düşüncesiyle yönetilemez. Metro Bundler Kilitlenmeleri (Cache invalidation), Podfile çakışmaları ve Memory Limit aşımları Mobil projeyi tek satırda Çöp edebilir. Otonom ajan, Console uyarılarını aşağıdaki Kriz Senaryolarına göre Otonom Doktor edasıyla çözecek, Asla hiçbir Hatayı (Warning Dahil) sessizce sineye ÇEKMEYECEKTİR!

---

## 🛠️ Çekirdek (Core), Metro ve Build (Çizim) Hataları

### 1. `Metro Bundler: ENOSPC: System limit for number of file watchers reached` veya `React Native Cache Bug`
* **Krizin Sebebi:** Metro (React Native'in Paketleyici motoru) projede çok fazla dosya değişikliği nedeniyle (Watchman limiti) veya Cache'inde (Eski Kod) asılı kaldığı için Yeni kodu Derleyemiyor. Siz kod yazsanız da telefonda ESKİ uygulamayı görüyorsunuz!
* **Otonom Çözüm (Zorunlu):** Ajan KODU KURCALAMAYI BIRAKIR! Bu bir kod hatası DEĞİLDİR. Anında Console üzerinden şu Cache temizleme Komutlarını tetikler:
  ```bash
  npx expo start -c     # VEYA
  npm start -- --reset-cache
  ```
  Watchman problemi varsa İşletim sistemi limitini (sysctl) yükseltir.

### 2. `Invalid hook call. Hooks can only be called inside of the body of a function component.`
* **Krizin Sebebi:** Otonom Zeka bir Redux/Zustand Hook'unu (`useUserToken()`) VEYA Sayfa Yönlendiriciyi (`useRouter()`) Gidip de bir SAF FONKSİYONUN (`axios` çağrısı yapan bir util veya dış bir helper dosyası) İÇERSİNE yazmıştır! Hook'lar UI Ekranı olmayan yerlerde **ÇAĞRILAMAZLAR**.
* **Otonom Çözüm (Zorunlu):** React kural İhlali Anında Tespiti! Otonomi Hook fonksiyonunu, Ekran Componentinin (Body'sine) TAŞIR. Gelen veriyi İlgili Yardımcı fonksiyona PARAMETRE (`doFetch(token)`) Olarak Geçirir.

### 3. `Can't find variable: X` Veya `Module not found: Can't resolve...` (Expo SDK Mismatch)
* **Krizin Sebebi:** Standart NPM paketleri bazen Expo ile tam uyuşmaz veya Versiyonları çatışır (Dependency Hell). React Native için üretilmeyen (Dom manipülasyonu yapan `window.location` içeren) Web paketleri RN içinde Patlar!
* **Otonom Çözüm (Zorunlu):** React Native ve Expo içerisine PURE (Saf) npm paketi yüklemeden Önce Expo kütüphanesi aranır! (Yani NPM Komutu yerine `npx expo install package_name` kullanmak ZORUNLUDUR! Bu komut projedeki Expo Engine Versiyonuna en uygun ve Çökmeyen Paketi Otonom Olarak seçip indirir!).

---

## 🎨 UI/UX FPS Dropları ve Bellek Şişmeleri (Memory Leaks)

### 4. `VirtualizedList: You have a large list that is slow to update` (Kırmızı Log Yağmuru)
* **Krizin Sebebi:** Sayfanın Tamamını kaydırmak İçin (Otonomi Mimarinin en tepesine) bir `ScrollView` Koydu. Daha Sonra Sayfanın ortasına Gidip Yüzlerce Ürünü Olan bir `<FlatList>` yerleştirdi. 
* **Sistem Tepkisi:** İki Kaydırılabilir (Scrollable) alan Üst üste bindiği için FlatList "Sadece Görünen Öğeleri Render Etme (Recycling)" özelliğini KAYBEDER. Ekrana aynı anda 1000 eleman ÇİZMEYE ÇALIŞIR, Cihaz Kilitlenir ve RAM Yanar!
* **Otonom Çözüm (Zorunlu):** ScrollView içinde FlatList YASAKTIR. Ya Sayfa ScrollView'dan Kurtarılıp (Tamamen Flex kalıp) FlatListin `ListHeaderComponent` Metodu Kullanılacak Ya da Gelişmiş Shopify `<FlashList>` Kullanılarak Optimize edilecektir!

### 5. Asrın Hastalığı: `Re-Render Tıkanması (Jank Ekran Takılması)`
* **Krizin Sebebi:** Kullanıcı Arama kutusuna (TextInput) "E..L..M..A" yazarken Ekran Klavyesi takıla takıla gecikmelidir.
* **Otonomi Tespiti:** Ekranın (HomeScreen) içine yazılmış bir `useState(search)` vardır. Ancak bu state ile BİNLERCE elemanlı Filtrelenme Methodu HER HARFTE Ekranı Yeniden Baştan çizmektedir!
* **Otonom Çözüm (Zorunlu):** Debounce mekanizması atılacak! `lodash.debounce` Veya `useTransition` / `Delay` Hook'u Kullanarak Kullanıcı yazıyı bitirdikten 500ms Sonra Arama State'i Set Edilecektir! Ayrıca Büyük Listeler kesinlikle `React.memo` İle Zırhlanıp (Sarmalanıp) Lüzumsuz Çizimlerden (Unnecessary Re-Renders) Kaçırılacaktır!

---

## 🛑 Native Cihaz İzinleri (OS Crash)

### 6. Cihaza (Kameraya/Lokasyona) Basıldı, Uygulama Sessizce Çöktü (Hard Crash iOS)
* **Krizin Sebebi:** Expo uygulamasında (`ImagePicker` Veya `Location`) Tetiklendi ancak OS izin İstemediği halde Zeka Bunu atladı. `app.json` veya `Info.plist` (Prebuild ise) içerisinde Zorunlu Gerekçe Metni `NSCameraUsageDescription` Konulmadı.
* **Otonom Çözüm (Zorunlu):** Bu bir React JS Hatası DEĞİLDİR Konsolda Görünmez! OS UYGULAMAYI VURUR. Otonomi Bu kütüphaneler eklenirken `app.json` a "plugins" veya "ios.infoPlist" Objelerini otonomca basmak Vezasındadır!
* *Geri Tuşu Felaketi:* Android Donanımsal "Geri" Tuşunu Cözen `BackHandler` Sayfa Öldüğünde `removeEventListener` Ile yok Edilmezse RAM'de asılı Kalarak Başka Sayfalarda GERI Tusuna Basildiginda Alakasız Eventler Tetikler! Cleanup Functions Mükemmel Uygulanacaktır!
