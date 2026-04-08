# 6️⃣ React Native - Endüstri Standartı Kaynak Göstergeleri (Otonom Rehber)

> **OTONOM ARAŞTIRMA MÜHRÜ:** React Native ve Expo (The Framework) dünyası inanılmaz hızlı gelişen (Sürekli Deprecate Olan/Kalkan komutların yaşandığı) bir ekosistemdir. Otonom ajan, projeye bir paket eklemeden VEYA bir UI/UX problemiyle karşılaştığında ilk olarak aşağıdaki "Best-Practice" kaynak merkezlerinden güncel (Current) yaklaşımı tarayacaktır. "Legacy (Eski)" RN çözümlerini koda dökmek Yasaklanmıştır!

---

## 🏛️ 1. Çekirdek Ekosistem ve Engine (Navigasyon Doğruları)

Projenin omurgasını dikerken (Bootstrapping) asıl başvurulacak olan "Meta" ve "Expo" onaylı O.S. (İşletim Sistemi) Katmanı yönergeleri:

- **Expo Resmi Dokümantasyon (Ana Kıble):** [https://docs.expo.dev/](https://docs.expo.dev/)
  - *Ne İşe Yarar:* Artık "React Native" dendiğinde "Expo" kastedilmektedir. Otonomi, Uygulama Logosu (`app.json` splash dizaynları), Bildirim (Push Notifications - EAS Push) eklentileri ve `npx expo install` uyumluluk gereksinimleri için her zaman burayı ana referans noktası kabul eder.
- **Expo Router (File-Based Navigasyon):** [https://docs.expo.dev/router/introduction/](https://docs.expo.dev/router/introduction/)
  - *Ne İşe Yarar:* Eski `react-navigation` çöpe atılmış, Next.js benzeri `app/(tabs)/index.tsx` şeklindeki URL tabanlı Navigasyon gelmiştir. Deep-linking, Query Parametreleri geçirme (`/user?id=5`) işlemleri doğrudan bu dokümandan alınacak standartlara göre işlenir.
- **React Native (Yenilenmiş Yönerge):** [https://reactnative.dev/docs/getting-started](https://reactnative.dev/docs/getting-started)
  - Cihaza Platform bazlı FlexBox davranışları çizerken Platform kütüphanesi komutları ve Keyboard Avoiding limitleri için spesifik metot depolamasıdır.

---

## 🌐 2. Mimari, State (Durum) & Data (Veri) Yöneticileri

Uygulamanın `Re-render` krizlerinden (Spagetti State Cehennemi) kurtulmasını Sağlayacak Senyor-Seviye Kütüphaneler:

- **Zustand (State Yönetimi):** [https://docs.pmnd.rs/zustand/getting-started/introduction](https://docs.pmnd.rs/zustand/getting-started/introduction)
  - *Sebep:* Redux'un ağır Boilerplate eziyetine düşmeden Global Authentication (Login statüsü), Tema Rengi gibi verileri tutan Hızlı State Yöneticisi. Otonomi "Persist" özelliğini (Telefona Kaydetmeyi) `AsyncStorage` veya `MMKV` ile bağlamak için burayı hatmerder.
- **TanStack Query (eski adıyla React Query):** [https://tanstack.com/query/latest](https://tanstack.com/query/latest)
  - *Sebep:* Ekrana Yansıyan Tüm API (Axios/Fetch) Verileri `useQuery` veya `useMutation` zırhı üzerinden geçer. Uygulamanın Caching, Yeniden Deneme (Retry), Loading ve Error Handling gibi belalı süreçleri Yapay Zeka Tarafından otonomca pürüzsüz yönetilir.
- **Axios:** [https://axios-http.com/docs/intro](https://axios-http.com/docs/intro)
  - Network Interceptor'ları (Bearer Tokenların araya girmesi) yönetmek için endüstri standardı İstek modülü.

---

## 🖼️ 3. UI, Animasyon (60 FPS) ve Estetik Silahlar

Kamera açmak veya cihazı titreştirmek VEYA Yüksek performanslı LİSTELER dökmek:

- **Shopify FlashList (Memory Koruyucu):** [https://shopify.github.io/flash-list/](https://shopify.github.io/flash-list/)
  - Normal bir React Native listesi (FlatList) içine E-Ticaret ürünleri düştükçe RAM yer bitirir (Crash). Bu eklenti "Otonomlar İçin" ZORUNLUDUR! Gözükmeyen item'ları (Recycle pattern) yok ederek performansı C++ seviyesine (`UI Thread`) kitler.
- **NativeWind (TailwindCSS in RN):** [https://www.nativewind.dev/](https://www.nativewind.dev/)
  - StyleSheet ile sayfa sonlarında Binlerce satır stil KODU kalabalığından ajanı kurtarır. `className="flex-1 bg-white items-center justify-center"` şeklindeki TailwindCSS komutlarını anında native elementlere Render Eden Kütüphane.
- **React Native Reanimated (v3):** [https://docs.swmansion.com/react-native-reanimated/](https://docs.swmansion.com/react-native-reanimated/)
  - Ekran Gecişlerini, Dönen/Kaybolan (Fade, Slide) veya İnteraktif PanGesture hareketlerini JS İşlemcisini (Thread'i) Boğmadan, Worklet metoduyla UI Thread üzerinden Akışkan (120 FPS) yapabilen ZORUNLU Animasyon kütüphanesidir. (Asla Animated.spring kullanilmaz).

---

## 🚀 4. CI/CD Otomasyon Test ve Dağıtım Pipelines (EAS)

Yapay zeka sadece kod üreten bir klavye değildir, Kurumsal uygulamayı mağazaya hazırlayan Delivery Mimarıdır:

- **EAS (Expo Application Services - Submit / Build):** [https://docs.expo.dev/build/introduction/](https://docs.expo.dev/build/introduction/)
  - Projenin Windows/Linux veya Mac ortamından bağımsız biçimde, Dev bulutlarında "IPA" (Apple App Store) veya "AAB" (Google Play) Çıktısına dönüştüğü yerdir. Ajan projeyi hazırlarken gizli dosyaları (`.env` ayarlarını) Cloud Variables olarak ayarlar, GitHub Actions veya GitLab CI/CD kurgusunda Müşteriye tam-otomatik bir Production Dağıtım (Delivery) Hattı Kurar! (Örn: `eas build --profile production --platform ios`).
