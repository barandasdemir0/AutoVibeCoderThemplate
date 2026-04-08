# 3️⃣ Next.js - Adım Adım Modern Otonom İnşa Süreci

> **YAPAY ZEKA ÇALIŞMA ALGORİTMASI:** "Next.js kurdum içini dolduruyorum" diye bir dünya yok. App Router, layout bazlı Nested hiyerarşi sunar ve bu yapı sırasıyla (Top to Bottom) oturtulmazsa sayfalar birbirinin üzerine biner veya Cache patlar.

---

## 🛠️ Aşama 1: Scaffolding, Provider ve Çatı Yapısı
1. Kurulum Otonom TS destekli yapılmalıdır: `npx create-next-app@latest . --typescript --tailwind --eslint --app`
2. **Global Providers:** Projede kullanılacak ThemeProvider (next-themes), StoreProvider (Zustand veya Redux), TanStack Query Client... gibi özellikler `app/layout.tsx` içine **DOĞRUDAN YAZILAMAZ** (Çünkü Providers genelde Context API barındırır ve 'use client' gerektirir. Root layout'u clienta çevirirseniz SEO ölür). 
   * *Çözüm:* Bir `components/providers.tsx` yaratılır. Başına `'use client'` eklenip sarmallar buraya alınır. Root layout (`app/layout.tsx`) sarmalı import ederek Server Component olarak kalmaya devam eder!

---

## 🎨 Aşama 2: Theming, Tailwind, Fonts ve Metadata
1. SEO yapılandırması olarak `app/layout.tsx` dosyasında ana `metadata` (Title, Description, OpenGraph) tanımları yapılır. Font optimizasyonu `next/font/google` (örneğin Inter veya Roboto) importlanarak layout kalıbına giydirilir. Sıfır yavaşlık.
2. Styling CSS ve Tailwind üzerinden (Örneğin Shadcn-UI componentleri kurularak) renk ve radius değerleri `tailwind.config.ts` üzerinden ayarlanır. Inline styling kesinlikle yasaktır.

---

## 🗄️ Aşama 3: Veri Bağlantısı (Prisma / Drizzle ORM)
*(Artık API ayrı Backend Nodejs repo'nda olmayabilir. NextJS Full-Stack yeteneğe sahiptir)*
1. `lib/db.ts` (Veya Drizzle config) bağlantısı eklenir. `Server Action`larda veya `React Server Components` içinde bu instanceler çağrılır.
2. ORM şemaları modeline göre schema.prisma dosyasına işlenir.

---

## 🔌 Aşama 4: Layouts (Sayfa İskeletleri ve Navigasyon)
1. `/app` altındaki her ana dizin, paylaştığı bir Navbar veya UI parçası varsa o klasörde bir `layout.tsx` sahibi olabilir. (Örn: `/app/(dashboard)/layout.tsx`) Parantezli Route Grupları `(auth)`, `(dashboard)` Otonom UI dizgisini ve layout mantığını çok kolaylaştırır, Browser URL'sini kirletmez (Url'de /dashboard kısmı çıkmaz, içindekiler route geçer).
2. Sayfada veri yüklenirken beyaz ekran çıkmaması adına, ilgili klasöre `loading.tsx` eklenir. (Behind the scenes React Suspense tetikleyecektir.) Skeletonlar buraya konulur.

---

## 🧩 Aşama 5: Actions ve API Handlers (İletişim)
1. Client bileşenlerinin tetikleyeceği Database Mutasyonları (Ekle/Sil/Düzenle), `/actions/` klasörü altına `use server` başlıklı fonksiyonlar olarak yerleştirilir. Zod validasyonları bu fonksiyonlara atılıp, DTO ayrıştırması yapılır.
2. Harici bir Mobile App veya Third-Party Entegrasyon var ise (Stripe Webhook vs) data formlarında Actions YETMEZ. Sadece bu durumlarda `app/api/webhook/route.ts` gibi Route Handlers yaratılır.

---

## ⚙️ Aşama 6: Sayfalar ve Polishing (Cilalama)
1. Sayfalar (Pages) oluşturulurken `page.tsx` default export olarak async component (`export default async function Page() { ... }`) yapılır! 
2. Gereksiz Render Darboğazlarını açmak için `next/image` etiketi, `Link` bileşeni (prefetch için) standart olarak koda yansıtılır. Klasik `<a href>` kullanıldığı AN uygulamadaki SPA (Single page app) reaksiyonu BİTER Uygulama komple Refresh atar! `Link` kullanılacaktır.

Aşama 6 tam ise "04-FilesStructure" yönergelerindeki mükemmel ağacını klasörlerinde doğrula.
