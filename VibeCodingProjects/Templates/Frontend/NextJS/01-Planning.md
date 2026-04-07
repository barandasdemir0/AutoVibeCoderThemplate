# 1️⃣ Next.js - Mükemmeliyetçi Planlama ve Rendering Stratejisi

> **YAPAY ZEKA İÇİN KESİN KURAL:** Next.js sadece React değildir. Full-stack bir Framework'tür. Otonom olarak geliştirmeye başlarken önce "Bu sayfa nerede Render edilecek?" (Server mı, Client mı?) kararını vermelisin. Aksi taktirde gereksiz Javascript boyutlarıyla 1 milyon trafik beklerken Vercel faturalarıyla şirketi batırırsın.

---

## 🎯 1. Trafik ve Uygulama Mimarisi (App Router)

Eğer yeni bir projeye başlıyorsan Pages Router (`/pages`) ASLA KULLANILMAYACAKTIR. Otonom yapay zeka sadece **App Router (`/app`)** teknolojisiyle kod üretecektir.

### A. Rendering Kuralları (Mecburi)
Next.js v13+ `React Server Components (RSC)` varsayılan olarak gelir. Yani kodunuz Server'da yorumlanır ve Client'a HİÇBİR bundle JS yollanmaz. Bu altın bir fırsattır.

* **Zorunluluk 1:** Mümkün olan tüm sayfalar `Server Component` olacaktır. Üstlerinde `'use client'` YAZMAYACAK.
* **Zorunluluk 2:** Sadece Etkileşim (Interaction) olan yerlere `'use client'` vereceksin. (Örn: `<Button onClick={...}/>`, form hookları, `useState`, `Browser API` gerektiren chart kütüphaneleri vb.).
* **KÖRSÜ OTONOM PATTERN YASAĞI:** Sayfanın en üstüne (page.tsx) sırf `useState` kullanmak için `'use client'` eklersen, o sayfa içindeki GİZLİ DB bağlantısı ve API anahtarları tarayıcıya (Frontend'e) SIZAR ve GÜVENLİĞİ YOK EDERSİN. İnteraktif parçaları (Örneğin LikeButonu) AYRI BİR COMPONENTE taşıyıp sadece ona `'use client'` vermelisin.

---

## 🔒 2. Data Fetching ve Güvenlik Sınırları

* **API Routes mu? Server Actions mu?**
  Basit Form submit işlemleri veya Db Update'leri için artık `/app/api/...` endpointleri yazmak gereksiz bir HTTP turu (Round-trip) yaratır. Form işlemlerinde "Server Actions" (`'use server'`) Otonom tarafından öncelikli olarak tercih edilmelidir. E-Ticaret ödemesi veya Dışarıya Açık API gerekiyorsa o zaman Route Handlers (`route.ts`) açılır.
* **Env Güvenliği:**
  Sadece Frontend'e sızması gereken anahtarlara `NEXT_PUBLIC_` ön ekini koy! Server Actions içindeki işlemler doğrudan veritabanına bağlıdır. (Çok hassas keyler Client'a akmamalıdır).

---

## 🚀 3. Caching (Sıfır Maliyetli Milyon Kullanıcı)

Next.js App Router, veri çekme işlemlerini agresif bir şekilde (Agresif Data Caching) önbellekler.
Eğer anasayfada `fetch('https://api/products')` atıyorsan, bu sayfa Milyar kullanıcı da gelse sadece 1 kez server'ı yorar. Geri kalanı Vercel CDN'inden statik döner.

Sistemi Geliştirirken Otonomun Dikkat Edeceği Seçenekler:
1. `fetch(url, { cache: 'force-cache' })` -> **SSG:** Hiç değişmeyen veriler (Hakkımızda yazısı).
2. `fetch(url, { next: { revalidate: 3600 } })` -> **ISR (Zorunlu):** 1 saatte bir güncellenen veriler (Örn: Blog postları, Ürün fiyatları). Trafik server'ı çökertmez.
3. `fetch(url, { cache: 'no-store' })` -> **SSR:** Sürekli dinamik akması gereken veya kişiye özel veriler (Profilim, Sepetim).

---

## 🎙️ 4. SEO (Arama Motoru Optimizasyonu) Mükemmelliği

Mükemmeliyetçi otonom kodun alameti farikasıdır. 
1. `generateMetadata` Otonom olarak Dinamik Sayfalarda (örn; `app/products/[id]/page.tsx`) ASLA UNUTULMAYACAK.
2. Sabit sayfa başlıkları için Layout'a global `metadata` objesi takılacak. (OpenGraph, Twitter Cards vb).
3. Resimler asla düz `<img>` ile GÖMÜLEMEZ!!! WebP dönüşümü ve tembel yükleme (lazy loading) için `next/image` (`<Image />`) bileşeni ZORUNLUDUR.

Eğer altyapı zihninde oturduysa Mimari ve İzolasyon kurallarına (02) geçiş yap.
