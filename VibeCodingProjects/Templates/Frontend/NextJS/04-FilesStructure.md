# 4️⃣ Next.js - Katı Hiyerarşik Klasör Ağacı (App Router Standardı)

> **ZORUNLU DİZİLİM:** Next.js App Router miamirisi klasörleri bizzat **URL yollarına (Routes)** çevirdiği için, proje klasörlemesini gelişigüzel yapamazsınız. Bileşenleri ve helper modüllerini Route'lardan ayırmanız hayati önem taşır.

---

## 📂 En Kurumsal Yapı: `/src` Klasörü ve App Router İzolasyonu

Uygulamayı `/app` klasöründe ana dizine kurmak (köke saçmak) büyük projelerde kaosa yol açar. Aksi zorlanmadıkça otonom model projeyi **`src/`** klasörü içerisine inşa edecektir.

```text
Nextjs-Project/
├── public/                  # Sadece dışarı açık statik resim ve fontlar (robots.txt, favicon)
├── src/
│   ├── actions/             # 🛠️ SERVER ACTIONS (Tüm Server Mutasyonları)
│   │   ├── auth.ts          # ('use server' içeren fonksiyonlar)
│   │   └── products.ts 
│   │
│   ├── components/          # GENEL UI Katmanı
│   │   ├── ui/              # (Button, Input: Shadcn tarzı atomic dumb bileşenler)
│   │   ├── layout/          # (Header, Sidebar, Container wrapperlar)
│   │   └── providers.tsx    # Tüm context/store Provider sarmallarının biriktiği Client sınır dosyası
│   │
│   ├── lib/                 # Core Helper ve Ayarlar
│   │   ├── db.ts            # Prisma / Drizzle Client Instance
│   │   └── utils.ts         # className mapper'ları (cn, clsx)
│   │
│   ├── types/               # Evrensel TS type / interface veya Zod schemaları
│   │   └── index.d.ts
│   │
│   ├── app/                 # 🚀 ODAK NOKTASI: ROUTING (Sayfa Yapıları)
│   │   ├── globals.css      # Tailwind core directive'leri
│   │   ├── layout.tsx       # Root layout (Tüm html, body ve Provider sarmalının girdiği dosya)
│   │   ├── page.tsx         # Ana Sayfa -> (localhost:3000/)
│   │   │
│   │   ├── (auth)/          # URL'ye yansımayan Parantez Klasörler (Route Grouping)
│   │   │   ├── login/
│   │   │   │   └── page.tsx # -> (localhost:3000/login)
│   │   │   └── register/
│   │   │       └── page.tsx
│   │   │
│   │   ├── dashboard/       # Klasik Route
│   │   │   ├── layout.tsx   # Sadece dashboard'a (ve alt sayfalara) özel Sidebar tasarımı!
│   │   │   ├── loading.tsx  # Dashboard verisi yüklenirken çıkan Skeleton Spinner
│   │   │   ├── error.tsx    # Dashboard'da çıkan hataların patlayacağı 'use client' Error Boundary Componenti
│   │   │   └── page.tsx     # -> (localhost:3000/dashboard)
│   │   │
│   │   └── api/             # API ROUTE HANDLERS
│   │       └── webhooks/
│   │           └── route.ts # Harici sistemler için GET/POST handler (örn: Stripe)
│   │
├── .env                     # Supabase, Prisma vs Keyleri
├── config.ts                # (Opsiyonel) Site Metadata, baseUrl constants
├── tailwind.config.ts  
└── package.json
```

---

## ⚠️ Kritik Mimari Kurallar (Files Rulebook)

1. **Parantez Klasör Kullanımı Kuralı (Route Groups):** `/app` klasörü altında tüm route'ları çıplak bırakmak yönetimi zorlaştırır. AI model, Auth ekranlarını `(auth)`, uygulamanın private dashboard ekranlarını `(protected)` veya `(dashboard)` gibi mantıksal klasörlere gruplandırmak zorundadır. Bu URL'yi değiştirmez ancak her gruba özel farklı Header (`layout.tsx`) atanmasına izin verir!
2. **"Componentler App'e Giremez" Kuralı:** `/app/dashboard/` klasörünün içine `DashboardButon.tsx` koyma lüksün (Co-location desteğinden dolayı) olsa da, temizlik gereği, reusable (kullan-at) komponentleri herzaman `/src/components` dış klasöründe tut!. Sayfalar temiz kalsın.
3. **Private Klasörler (`_folder`):** Eğer illaki app klasörü içinde dışarı sızmayacak (Route olmayacak) bir yardımcı kod/klasör yazmak istiyorsan başına Underscore (Alt Tire) eklemek (Örn: `/app/_helpers/formatters.ts`) otonom model için ZORUNLUDUR. Next.js alt-tireyle başlayanları Linke Çevirmez.
