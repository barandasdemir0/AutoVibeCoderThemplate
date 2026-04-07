# 4️⃣ React Native - Expo Router Katı Hiyerarşik Klasör Ağacı

> **ZORUNLU DİZİLİM:** Next.js'ten alışık Olanlar Dosya bazlı Yönlendirmeyi bilsede, React Native'de Klasör Düzeni Cihaz Build (Derleme) Sürecini ve UX'i Etkiler! Otonom yapay zeka Expo Router (v3+) Otonomisini Kesin Standartta İzolasyonla (Src kalıplarıyla) Çizecektir.

---

## 📂 En Kurumsal Yapı: `/src` vs `/app` Kurgusu (Otonom Dizilim)

Expo Router default olarak ana kükte `app` klasörünü alır. Ama `components` gibi Yapılar dışarıda dağınık Tutar. Biz KURUMSAL MÜKEMMELİYET İÇİN HERŞEYİ KAPSÜLLEYECEK Bir Sisteme Sahibiz.

```text
ReactNative-Expo-App/
├── app/                     # 🚀 EXPO ROUTER (ROUTING KATMANI) SADECE BURADA!
│   ├── _layout.tsx          # ROOT (APP) BAŞLATICISI (Providers, SafeArea, Sentry burada bağlanır)
│   ├── +not-found.tsx       # Sayfa Bulunnamadı (404 Fallback ekranı)
│   ├── (auth)/              # 🛡️ GİRİŞ / KAYIT EKRANLARI (Stack - Parantez URL'de gİZLENİR)
│   │   ├── _layout.tsx      # Yalnızca Header'ı gizleyen Stack yapısı
│   │   ├── login.tsx        # url: /login
│   │   └── register.tsx     # url: /register
│   │
│   └── (tabs)/              # 📱 ALT MENU (BOTTOM TAB BAR) EKRANLARI
│       ├── _layout.tsx      # Tab Bar Iconlarının (Home, Settings) Yapılandırıldığı İskelet!
│       ├── index.tsx        # AnaSayfa (url: /)
│       ├── search.tsx       # Arama (url: /search)
│       └── profile.tsx      # Profil (url: /profile)
│
├── src/                     # 🚀 ÇEKİRDEK İŞ/UI DOSYALARI (SAYFADAN BAĞIMSIZ)
│   ├── assets/              # Sadece resimler, Custom Fontlar ve i18n
│   ├── components/          # GENEL UI Katmanı (Dumb/Şapşal Widgetlar Eğitimi Görmüş Componentler)
│   │   ├── ui/              # Button.tsx, InputField.tsx (Tailwind/Nativewind Sınıflı!)
│   │   ├── cards/           # ProductCard.tsx, UserCard.tsx
│   │   └── sheets/          # BottomSheetler (Aşağıdan açılan menüler)
│   │
│   ├── hooks/               # REACT NATIVE CUSTOM HOOKLAR (Cihaz/UI Durumları)
│   │   ├── useKeyboard.ts   # Keyboard Açık/Kapalı Dinleyicisi
│   │   └── useDebounce.ts
│   │
│   ├── services/            # DIŞ SERVİSLER
│   │   ├── api.ts           # Axios İstemcisi Kök (Interceptorlu)
│   │   └── storage.ts       # SecureStore VEYA MMKV (Çok hızlı cihaz Belleği) Veritabanı
│   │
│   ├── stores/              # ZUSTAND GLOBAL DURUMLAR
│   │   └── useAuthStore.ts  # Tokenları, User() verisini tutar
│   │
│   ├── utils/               # Uygulama Mateği, Font Ölçekleyicileri
│   │   └── device.ts        # Platform.OS === 'ios' Checkleyen Araçlar!
│   │
│   └── constants/           # MAGIC STRING KATLİAMINA KARŞI
│       ├── Colors.ts        # Uygulamanın Tema (Dark/Light) Renk Palette Değişkenleri
│       └── Endpoints.ts     # Tüm API url Paths'leri
│
├── app.json                 # EXPO MOBİL Konfigürasyonu (İkon, Splash Screen, Paket Adları)
├── babel.config.js          # Reanimated veya Nativewind Pluginleri
├── tailwind.config.js       # Nativewind Conf
└── package.json
```

---

## ⚠️ Kritik Mimari Kurallar (Files Rulebook)

1. **Parantez İçi Routelar İzölesi:** Expo Router'da bir klasörün adı Parantez (Örn: `(tabs)`) içindeyse, O URL'de Görünmez (Path atlanır). Bu Klasörü Gruplandırmak İçin Otonom model Olarak ZORUNLU KULLANILACAKTIR! Login ekranına giderken Dosya Sistemi `/(auth)/login` olsada Router `router.push('/login')` olarak yollar.
2. **Kör Importlar ve Alias Pathler:** Otonom Zeka Proje İçinde Bileşen Import Ederken `../../../../src/components/ui/Button` Şeklinde Amator ve Kırılgan Yol KullanMAZ!!. `tsconfig.json` dosyasından Otonomca `@/*`: `["./src/*"]` Aliası Kurar ve Tüm Projede Mutlak Zırhlı İçe aktarır: `import Button from '@/components/ui/Button'`.
3. **Sayfalar İş Kodunu TUTAMAZ:** `/app/` içindeki route Tsx dosyaları (Örn `login.tsx`) View'ı (UI'ı) İçinde Barındırmaz!! SADECE Sayfa Düzenini ayarlar. Login formu Otonom zeka tarafından `src/components/forms/LoginForm.tsx` den çağırılmak ZORUNDADIR. Kod Kapsüllenecektir!
