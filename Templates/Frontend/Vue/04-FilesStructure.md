# 4️⃣ Frontend Vue - Feature Based (Özellik Odaklı) Katı Klasörleme Ağacı

> **ZORUNLU DİZİLİM:** Vue/Vite ilk kuruldiğunda `src/` altı O Kadar sadedir ki, Geliştiriciler Tüm Componentleri Oraya Tüm Sayfaları Viewsa doldurur. Ancak 10 Sayfadan büyük sistemlerde `Domain-Driven/Feature` İzolasyonu Şarttır! Otonom Zeki Kodu Üretirken Bu Yapıyı Zorlayacaktır.

---

## 📂 En Kurumsal Yapı: `/src` Klasörü

Aşağıdaki yapı, Projedeki "Yeniden Kullanılabilir" (Evrensel) Araçları, SADECE Bir Domain'e Bağlı Alanlardan İzole Eder!

```text
Vue3-App/
├── src/
│   ├── assets/              # Sadece resimler, logolar, fontlar (Vite tarafından derlenecekler)
│   ├── router/              # index.ts (Tüm Route Objeleri, Child (İç içe) Routelar ve Middleware/Guards)
│   │
│   ├── components/          # GENEL UI Katmanı (Dumb/Şapşal Widgetlar Eğitimi Görmüş Componentler)
│   │   ├── ui/              # Button.vue, Modal.vue, AppInput.vue (Sadece Proplarla Çalışanlar)
│   │   └── layout/          # TheNavbar.vue, TheSidebar.vue (The ön eki = Eşsiz Tekil Bileşen anlamındadır!)
│   │
│   ├── composables/         # EVRENSEL CUSTOM HOOKLAR (React Hook = Vue Composable)
│   │   ├── useWindowSize.ts # Sayfa Boyutu izleme
│   │   └── useClickOutside.ts
│   │
│   ├── lib/                 # THIRD PARTY KÜTÜPHANELER VEYA AXIOS CONFİGLERİ
│   │   └── api.ts           # Interceptor basılmış tekil Axios Yansıması
│   │
│   ├── stores/              # PINIA GLOBAL DURUMLAR (Eski vuex yapısı yok)
│   │   ├── index.ts         # Ana Pinia başlatıcı
│   │   ├── auth.ts          # Auth Durumu (setupStore formatı)
│   │   └── theme.ts
│   │
│   ├── features/            # 🚀 ODAK NOKTASI: MÜŞTERİ MODÜLLERİ (Özellik Tabanlı)
│   │   ├── adminDash/       # Modül Adı
│   │   │   ├── components/  # SADECE Bu modülde kullanılacak Özil Componentler (Örn: AdminGraphic)
│   │   │   ├── composables/ # (useAdminStats.ts => Fetch İşlemlerini Yönetir)
│   │   │   └── views/       # Sayfalar burada durur! (AdminHomeView.vue)
│   │   │
│   │   └── auth/
│   │       ├── components/  # LoginBox.vue
│   │       ├── composables/ # useAuthAction.ts (Logic kodları)
│   │       └── views/       # LoginView.vue, OgrRegisterView.vue
│   │
│   ├── App.vue              # Zirve İskelet (Sadece <RouterView> ve <ToastProviders> taşır)
│   └── main.ts              # Uygulama Mount.
│
├── .env                     # Geliştirme Environment Keyleri (VITE_ API_URL vb)
├── tailwind.config.js       # Veya Vite config
└── package.json
```

---

## ⚠️ Kritik Mimari Kurallar (Files Rulebook)

1. **Ön Ek Pratiği (App & The):** Otonom yapay zeka bir UI parçası üretiyorsa Eğer O Düzenli Kullanılan Bir şeyse Adını `AppButton.vue` Yapar (`Button.vue` İle yerel HTML çakışmalarını kalkanla engeller). Eğer Sistemde Bir Navbar Varsa ve Bir Kere Renderlenmesi Gerekiyorise Kesinlikle `TheHeader.vue` olarak adlandırır!. Otonom Code Guidelines.
2. **Feature İzolasyonu Kuralı:** Otonom Zeka `Auth` klasörü altındaki Bir Parçayı, `adminDash` Sayfasının İçine Gömerek İmport ATAMAZ. "Domainler Birbiriyle Konuşamazlar!". Eğer iki Modülünde İhtiyaç Duyduğu Bir Modül Varsa, Demekki o O Modüllere Ait Değildir. O Parça Doğrudan `src/components/ui` Adresine Transfer edilir (Globalleşir)!!
3. **Template Sıkıştırması:** `AuthView.vue` sayfasının içine LoginBox Form HTML'ini, Submit Butonunu alt alta 300 Satır HTML olarak Gömemez! O Sayfada View dosyası Sadece Düzen (Grid vb) Atar HTML'in ve Logic'in İçini Parçaladığı Küçük `LoginForm.vue` Componentlerine Şutlar! Component Yüzde Yüz Olarak Mıncıklanır (Granular).
