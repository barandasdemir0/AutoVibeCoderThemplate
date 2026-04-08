# 1️⃣ React Native (Expo) - Kurumsal Mobile Planlama & Ölçeklenebilirlik Sözleşmesi

> **OTONOM YAPAY ZEKA İÇİN KESİN KURAL:** React Native (JS Framework) basitçe bir "Web Sitesini Küçültüp Ekrana Sığdırma" aracı DEĞİLDİR. Mobil dünya Web'den 10 Kat daha acımasız ve daha performans-odaklıdır. Native (Yerel C++/Java/Obj-C) performans kaybı, Hiyerarşik DOM çöküşleri ve Bridge/Re-render tıkanıklıkları (Jank/Frame Drop) yaşamamak İçin Otonom Yapı PROJEYE **EXPO EKO-SİSTEMİ (Expo Router)** ile Başlamak ZORUNDADIR. Düz "Bare Workflow (npx react-native init)" kullanmak tamamen Yasaklanmıştır.

---

## 🎯 1. Çekirdek Altyapı Kararı: Bare Native Mi, Expo Mu? (Geçmişe Veda)

Uygulamanın inşasında Otonom Zeka eski usül CLI komutlarını (`react-native run-android`) veya Bare projede CocoaPods krizlerini KULLANMAYACAKTIR. React Native'in asıl geliştiricisi **Meta (Facebook) ekibi dahi** artık yeni projelere doğrudan Expo ile (Bir Meta-Framework olarak) başlanmasını emretmektedir! (Örn: Next.js'in React'ı sarmalaması gibi).

### Otonomi İçin Expo'nun Süper Avantajları ve Zorunluluğu:
* **File-Based Routing (Dosya Tabanlı Rotalama - Expo Router):** Tıpkı NextJS gibi Dosya Klasör isimlerinden (`app/(tabs)/index.tsx`) Otomatik Navigasyon Yapar!. Manuel olarak `react-navigation` kullanarak Spagetti yığınlar oluşturup Context ölümüne yol açmayı ÇÖPE ATAR.
* **EAS (Expo Application Services - Prebuild):** Native Modüller (`XCode` veya `Android Studio`) kurmaya gerek Kalmadan (Prebuild konseptiyle) Bulutta Build (IPA/AAB) aldırabilir. Cihaz hafızasını ve çevre birimlerini C++ seviyesinde ayarlamayı basitleştirir. 
* **Over-The-Air (OTA) Updates:** Otonom Zeka acil bir UI bug'ı (hatası) düzeltip bunu AppStore ve Google Play Store bekleme sürelerine (Red yemeye) maruz kalmadan Kullanıcının Cihazında anında değiştirebilecek Güncelleme mimarisi vaat eder (EAS Update).
* **Güvence (Stability):** 3. parti kütüphanelerin OS çökmelerine (Native Crash) sebep olması Expo modüllerinin `Continuous Development` testi sayesinde büyük oranda engellenir.

---

## 🔒 2. Re-Render Faciası ve Thread Tıkanıklıkları (FPS Düşüşü Katliamı)

Desktop Browser (Web Client) yavaştır Ancak donanımı güçlü olduğu için CSS/JS yığılmaları Hissedilmeyebilir. Ancak bir Mobil İşletim Sistemi Cihazda (60 ile 120 FPS akıcılıkta) bir "Scroll (Kaydırma)" yaparken ana JS Thread'i Tıkanırsa Ekran saniyelik olarak "Takılır (Stuttering/Jank)". Bu durum uygulamanın 1 puan (1-Star Review) alarak PlayStore çöpüne düşmesine sebep olur!

Otonom Yapı, React Native'in `JS Thread` (Mantık) ve `UI Thread` (Görüntü) şeklindeki İki Katmanlı (Köprü / Asenkron Bridge mekanizmalı veya JSI) Mimarisine Hakim Olacaktır!

* **Kural 1 (Asenkron Animasyonlar):** Otonom Zeka sıradan JS içinden (`setInterval` veya standart React `setState` ile periyodik) Animasyon yapamaz! Main JavaScript Thread'ini boğar. **Reanimated (v3)** kütüphanesini ve UI iplikçiklerini kullanarak animasyonları "C++ & UI Thread" i Üzerine Atmayı (Worklet olarak) BİLMEK ZORUNDADIR. (Eski Animated.spring bile useNativeDriver:true olmadan KULLANILAMAZ).
* **Kural 2 (Yığın Listeler - FlatList/FlashList):** Scroll View İçine art arda .map() çalıştırarak Yüzlerce `<View>` Elementi GÖMÜLEMEZ. Ekranda çoklu liste çizerken Otonom Sistem Kesinlikle `FlashList` (Shopify'ın efsanevi performansı) VEYA Optimize Edilmiş `<FlatList>` kullanarak Cihazın Ekranda Gözükmeyen Elemanları RAM'den (Recycle mekanizması ile) Silmesini/Tutmasını Temin Edecektir. Bellek Caching yönetimi (keyExtractor kullanımı vb.) Şarttır.
* **Kural 3 (Saf İşlevler ve React.memo):** Bileşenler gereksiz yere her state değişiminde baştan ÇİZİLEMEZ (Re-Render Olamaz). Ağır bileşenler otonom olarak `React.memo()`, callbackler `useCallback()` veya hesaplamalar `useMemo()` zırhından geçirilmeden koda sokulmayacaktır.

---

## 🚀 3. Ekran Boyutları, Donanım Tuşları ve Platform Uyumu (Responsive UX)

Mobil cihazlar sadece ekran boyutlarıyla değil; çentikler, klavye açıldığında değişen yükseklik ve OS-specific geri dönme refleksleriyle web'den tamamen ayrılır!

* **A. Çentik ve Kavisli Ekran Sensesi (Safe Area):** 
Uygulamanın tepesine Toolbar yaptığınızı zannederken Yazıların ve Butonların iPhone "Çentiği (Notch/Dynamic Island)" arkasında kaybolması kabul edilemez. Kök dizin (Root Layout) kesinlikle en tepede `SafeAreaProvider` ve ardından kilit sayfalarda `SafeAreaView` sarıcısını (Wrapper) barındıracaktır.
* **B. Klavye Binişleri (Keyboard Overlap):**
Kullanıcı kayıt formunda en alt input'a (Şifre) tıkladığında Telefon Klavyesi (SoftKeyboard) çıkar ve yazdığı alanı kapatır! Kullanıcı ne yazdığını göremiyorsa bu Otonom ürün çöp sayılır. Formlar Kesinlikle OS'e Native olarak haber veren `<KeyboardAvoidingView behavior={Platform.OS === 'ios' ? 'padding' : 'height'}>` Zırhı ile çevrelenmelidir.
* **C. Sabit Boyut Yasağı (Hardcoded Dimensions):**
Otonom araçlar kod yazarken `width: 400`, `top: 50` gibi PİXEL değerlerini Ekrana göre hesap yapmadan, esnetmeden Yazıp GeçeMEZ! Müşteri 13 Inç Tabletle veya katlanabilir (Foldable) cihazla girdiğinde minyatür bir ekranla karşılaşmamalıdır. Flexbox (`flex: 1` , `justifyContent`) ve oranlamalar Otonom olarak %100 oranında tasarlanacaktır.

## 📡 4. Cihaz İzni Beklentileri (Native Permissions)

Mobil uygulamada Kamera açmak veya Galeri seçmek web browser alert'i çıkartmaz. Native (OS) düzeyde `expo-permissions` veya `expo-image-picker` üzerinden `app.json` doyasına mutlaka açıklama metinleri (`NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`) enjekte edilecektir. Yoksa Apple, AppStore'dan 10 saniye içinde uygulamanızı "Usage Description Missing" sebebiyle kalıcı olarak reddeder. Otonom yapının bunu bilmesi ölüm kalım meselesidir!
