# 4️⃣ React Native - Dosya Mimarisi ve İzolasyon Hiyerarşisi (Files Structure)

> **MİMARİ ZORUNLULUK:** React Native, Klasör dizilimi dayatan (Opinionated) bir yapı değildir (Eğer Expo Router sarmalı kullanılmıyorsa). Klasör hiyerarşisi kural koymadan başlatılırsa, Sistem 3 hafta içerisinde içine ulaşılamaz, hiçbir componentin nerden geldiği bulunamaz Devasa Bir `Spagettistan`'a dönüşür. Bir Otonom veya Senior Mühendis geliştirmeye başlamadan önce S.O.L.I.D izolasyonunu **Dosya Sistemine** aşağıdaki gibi çakar!

---

## 📂 Ana Gövde: Modern Expo Ağacı ve Feature-Driven Klasörleme

Yeni nesil (Next.js esinlenmesi) React Native projeleri `app/(tabs)` (Rotalar) ve Geri kalan kodlar (`src/`) olarak Çift Başlı (İki ana gövdeli) yürütülmelidir. Asla Business Logic'ler app klasörü içinde yatmaz.

```text
/my-expo-app
  │
  ├── /app                            # [ROUTER KALESİ] Expo Router Navigasyon Rotaları (Dosyalar Sayfadır)
  │    ├── /(tabs)                    # Alt Menu (Bottom Tabs) Olan Rotalar
  │    │    ├── index.tsx             # AnaSayfa URL -> '/'
  │    │    ├── profile.tsx           # Profil URL -> '/profile'
  │    │    └── _layout.tsx           # Tab Bar Menüsünün Cizim Çerçevesi (Nav Bar UI Çizimi vs.)
  │    ├── /auth                      # Alt Menu OLMAYAN rotalar
  │    │    └── login.tsx             # Login URL -> '/auth/login'
  │    ├── _layout.tsx                # ANA UYGULAMA ROOT'u (Providerların Global State vs sarıldığı dosya!)
  │    └── +not-found.tsx             # Sayfa Bulunamadı Hatası (Catch-All route)
  │
  ├── /src                            # [GERÇEK KOD KALESİ] Bütün İş Mantığı ve Tasarımlar Burada!
  │    ├── /components                # DUMB COMPONENTLER VE ORTAK PARÇALAR
  │    │    ├── /ui                   # Kendi zekası olmayan basit Elementler (Button, Input, Card)
  │    │    └── /shared               # Sistem Boyu kullanilan TopBar, Footer gibi birleşik UI parcalari
  │    │
  │    ├── /constants                 # SABİT DEĞERLER ÇÖPLÜĞÜ KORUMASI
  │    │    ├── theme.ts              # Renk Kodlari (Colors.light, Colors.dark), Padding Oranlari
  │    │    └── apiRoutes.ts          # "/api/users", "/api/login" Stringleri TEK ELDEN!
  │    │
  │    ├── /hooks                     # (Özelleştirilmiş Kancalar / Abstractions)
  │    │    ├── /queries              # TanStack Query Kullanarak API baglantı fonksiyonları (useGetProfile.ts)
  │    │    └── useHardwareBack.ts    # Android tuşlarını vs dinleyen sistem kancaları
  │    │
  │    ├── /store                     # ZUSTAND VEYA GLOBAL DURUMLAR
  │    │    ├── authStore.ts          # Kullanıcının Token'ı veya ID'si (Global)
  │    │    └── themeStore.ts         # Seçilen UI Temasi
  │    │
  │    ├── /network                   # AXIOS KÖPRÜSÜ
  │    │    ├── apiClient.ts          # Axios Interceptors, Error Handling
  │    │    └── endpoints.ts          # (Fetch yapilan gercek servis fonksiyonlari)
  │    │
  │    └── /utils                     # SAF YARDIMCI METHODLAR (Gorsel is icermezler)
  │         ├── dateUtils.ts          # "Dün saat 14:00" e donduren zaman ceviricileri
  │         └── storage.ts            # SecureStore (Sifreli RAM) fonksiyonlari
  │
  ├── /assets                         # PNG, SVG, LOTTIE (.json) VE FONTLAR (O.S Okuma yeri)
  │    ├── /images
  │    └── /fonts
  │
  ├── .env                            # GİZLİ ŞİFRELER! (API KEYLER ASLA GIT'E GÖNDERİLMEZ)
  ├── app.json                        # EXPO KONFİGÜRASYONU (Iconlar, İzinler, SPLASH!)
  ├── tailwind.config.js              # NativeWind Temellendirmeleri
  └── tsconfig.json                   # PATH ALIAS AYARLARI!
```

---

## 🚨 Katı Disiplinler ve Yasaklar (Dosya Taşınımı & İsimlendirme)

1. **Absolute (Kesin) Import Zinciri Yasası (Path Aliases):**
   Otonom Zeka `import Button from '../../../../components/ui/Button'` DOSYA KOKMUŞ YOL (Relative Path) SPAGETTİSİNİ KULLANAMAZ! Klasör değişiminde uygulama Kırmızı Ekran Verip Çöker. `tsconfig.json` ayarlarında `"@" : ["./src/*"]` konfigüre edilmeli ve Importlar Daime **`import Button from '@/components/ui/Button'`** Şeklinde Çekilmelidir!

2. **`app/` İçine Zeka Konmaz (Smart Route Isolation):**
   `app/(tabs)/index.tsx` Sayfası gidip direkt `axios.get` YAZAMAZ (Dosya İzolasyon İhlali). O sayfa YALNIZCA ekrandır, Otonomi bu mantıkları Mutlaka `src/hooks` Veya Ekrana cizilecek parcayi `src/components` uzerinden IMPORT eder. 

3. **Asset (Varlık) Limitasyonları:**
   Otonomi `assets/` icine PNG atacagi zaman Asla devasa 10 MB arka plan Resmi koyamaz Uygulama PAKET BOUTU (AAB/APK) Şişer ve magaza 100MB asım uyarısı verir. Mümkün olduğunca Native Cizim, SVG VEYA Sıkıstırılmıs WebP Formati otonom zekanın Onceligidir!

Dizin ağacını okuduysanız, uygulamanın çökebileceği ve otonom debug eylemleri gerektiren `05-DebugTips.md` adımına geçebilirsiniz!
