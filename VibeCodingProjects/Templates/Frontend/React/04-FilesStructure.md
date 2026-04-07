# 4️⃣ React - Atomic Design veya Feature-Based Ağaç Yapısı

> **ZORUNLU DİZİLİM:** Vite veya Create-React-App boş bir `/src` üretir. Ve bir AI oradaki her şeyi components/ sayfasına tıkıştırırsa işler 10 sayfa sonra tamamen kontrolden çıkar. Component hiyerarşisi en az 5 milyon satırlık kodu okuyabilmek için tasarlandı, Otonom Mimariler aşağıdaki kuralları birebir uygulamak ZORUNDADIR.

---

## 📂 En Çok Tercih Edilen Yapı: Feature-Based Domain Driven Design (Frontend)

Klasik `components/`, `services/`, `pages/` bölme yapısı küçük projelerde iyidir. Enterprise / Sürekli Büyüyen Mükemmeliyetçi Otonom sistemlerde **Domain/Feature tabanlı** dizilim (Öne çıkarılmış "Features" klasörü) şarttır:

```text
React-App/
├── src/
│   ├── assets/              # Sadece resimler, ikonlar, fontlar ve Svgler
│   │   ├── images/
│   │   └── styles/          # Sadece global CSS, Tailwind directives (App.css vb)
│   │
│   ├── components/          # GENEL / EVRENSEL (Global Reusable Atomlar)
│   │   ├── ui/              # (Button, Input, Card, Modal, Spinner)
│   │   ├── layout/          # (Header, Sidebar, Footer, PageWrapper)
│   │   └── forms/           # (FormController, FormInput, FileUploader)
│   │
│   ├── config/              # Çevre değişkenleri ve Sabitler
│   │   ├── env.js           # (import.meta.env proxy / zod validasyonu)
│   │   └── constants.js     # MAGIC STRING yasağı -> "Roles.ADMIN"
│   │
│   ├── hooks/               # Sadece projenin genelini bağlayan özel hooklar
│   │   ├── useAuth.js
│   │   ├── useLocalStorage.js
│   │   └── useDebounce.js
│   │
│   ├── lib/                 # Üçüncü Parti araç yapılandırmaları
│   │   ├── axios.js         # Interceptor kurulu HTTP Client
│   │   └── queryClient.js   # React Query Default Options
│   │
│   ├── features/            # 🚀 ODAK NOKTASI (Her Domain Kendi Dünyasıdır)
│   │   ├── auth/
│   │   │   ├── api/         # Sadece Auth API Çağrıları (login.js, register.js)
│   │   │   ├── components/  # Sadece Auth'a ait UI (LoginForm.jsx, AuthLayout.jsx) 
│   │   │   ├── hooks/       # Yalnızca bu alana ait (useLoginMutation.js)
│   │   │   ├── stores/      # Sadece Auth tutan (Zustand authStore.js)
│   │   │   └── utils/       # Token decode helper
│   │   │
│   │   └── dashboard/       # Başka Bir Domain...
│   │       ├── api/
│   │       ├── components/
│   │       └── hooks/
│   │
│   ├── store/               # Global State (Zustand Modülleri birleşimi)
│   ├── utils/               # Uygulama geneli fonksiyonlar (FormatDate, formatCurrency)
│   ├── routes/              # Route kurgusu, Protected Route, Router definitions
│   │
│   ├── App.jsx              # Ana Provider, Tema, ToastContainer bağlama alanı
│   └── main.jsx             # React DOM baglama
│
├── .env.development
├── tailwind.config.js       # Veya Vite config
└── package.json
```

---

## ⚠️ Kritik Mimari Kurallar (Files Rulebook)
1. **İç İçe Klasör (Nesting) Sınırı:** Bir dosya dizini `src/features/dashboard/components/list/items/` şeklinde derine the GİDEMEZ! Maksimum 3-4 kuralı uygulanmalıdır. Çok derin hiyerarşi import krizlerine (`../../../../Button`) yol açar.
2. **Absolute Yollar (Alias):** Klasör mimarisi genişlerken Otonom AI'ın Vite Config (`vite.config.js`) yardımı ile veya `.eslintrc` ile Alias ayarlarını KESİNLİKLE YAPMASI GEREKİR.
   * *Yanlış:* `import Button from '../../../../components/ui/Button'`
   * *Doğru:* `import Button from '@components/ui/Button'`
3. **Index.js (Barrel Pattern):** Klasörlerde her dosyayı tek tek export almak kod çöplüğü yaratır. `features/auth/components/index.js` üzerinden hepsini export edip, kullanan sayfalarca tek satırda çektirmelisin:
   * `import { LoginForm, RegisterForm } from '@features/auth/components';`
4. **Feature İzolaysonu Yasağı (Kesin Kural):** Bir X özelliği (Örn: `/features/orders`) gidip başka bir Y özelliğinin (`/features/auth`) içindeki spesifik hook'u ve componenti `IMPORT EDEMEZ` (Circular Dependency). Y Özelliğinin export ettiği yapılar global `store` veya global `components` üzerinden talep edilmelidir! Cross-feature bağımlılıkları felaket getirir.
