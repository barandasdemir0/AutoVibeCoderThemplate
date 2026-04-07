# 6️⃣ Next.js - İleri Seviye Kaynaklar ve Endüstriyel Paketler

> Profesyonel, otonom bir AI sistemi Next.js (App Router) ile uygulama kurduğunda klasik React bağımlılıkları dahi farklı yapılandırılır. Seçilecek kütüphanelerin "SSR" veya "RSC" uyumlu olması hayati önem taşır.

---

## 📦 1. Kilit Taşı TS/NPM Modülleri (ŞART Kütüphaneler)

### Veritabanı / ORM Katmanı (Backend Entegrasyonu)
* **`prisma`** (ÖNERİLEN): Next.js Server bileşenlerinin içinde C# Vari zengin Typelerle db erişimi. `globalThis.prisma = new PrismaClient()` mantığı ile Development modundaki Socket/HMR yorgunluğundan oluşacak HATA Cconnections şişmelerini önleme yapısı KODLANMALIDIR.
* **`drizzle-orm`**: Prisma'nın yavaş kaldığı uç sunucusuz (Serverless) sistemler için süper hafif TypeScript ORM (Projeye göre seçilebilir).

### Authentication (Kimlik Doğrulama)
* **`next-auth` (Auth.js)**: JWT veya Veritabanı tabanlı Session kurgusu, Google, GitHub OAuth sosyal girişleri için %100 Next.js entegreli "OLMAZSA OLMAZ" paket. Middleware routing korumaları (`middleware.ts`) next-auth ile kalkanlanır.

### State Yönetimi & Veri Senkronizasyonu 
*(Next.js'in Server fetch özellikleri iyi olduğu için Axios/ReactQuery ihtiyacı azalmıştır ama tam bitmemiştir)*
* **`zustand`**: UI state için vazgeçilmez. Yalnızca Client componentlerde hooklarıyla çağrılır.
* **`nuqs` (Next-Use-Query-State)**: Pagination veya Filtre arama (Search Params) özelliklerini `useState` kullanıp client side'ı pisletmek yerine URL'de (Search Param) Reaktif yönetmek için en güçlü paket (Otonom zekanın Pagination yaparken KESİNLİKLE kullanması tavsiye edilir).

### Form ve Zod (Yüksek Performans)
* **`react-hook-form` & `@hookform/resolvers/zod`**: Client tarafındaki UX ve Loading statelerini (Server Mutation çalışana kadar) kitlemeden korumak tasarlamak için harika form builder kombinasyonu.

### UI ve Görsellik
* **`lucide-react`**: App Router uyumlu (Hata verdirmez), Premium açık kaynak icon paketi.
* **`shadcn-ui` (Veya Radix Primitives)**: Tailwind CSS tabanlı, NPM paketi OLMADAN, component kodunu doğrudan `/components/ui/` dizinine otonom çeken ve %100 Otonom Zeka KONTROLÜNDE şekillenen endüstriyel standart Accessible Bileşen arşivi.

---

## 📡 2. Yapay Zekaya (AI Agent'ına) İstem Formülleri

Aşağıdaki istemler, Next.js yeteneklerini tavan yaptırıp klasik React ameleliğinden sizi kurtarır:

> "Next.js App Router ile E-ticaret Ürün detay (/[slug]) sayfası tasarla. **Zorunlu Kurallar:**
> 1. Sayfa Server Component olacak ve Pruduct datasını Prisma DB'den çekecek.
> 2. Sepete Ekle Butonu İnteraktif olduğu için Ayrı bir Dosyada (Client Component) yazılarak Import edilecek ve Sadece ProductID ile çalışacak.
> 3. Bu sayfanın `generateMetadata` fonksiyonunu yazmayı unutma (SEO Otonomluğu).
> 4. URL'deki Search Parameterları (`?renk=kirmizi`) Client'ta `useState` ile değil, URL `nuqs` (veya UseSearchParams) mantığı ile Serverı tetikleyecek şekilde tasarla."

> "Bana bir Authentication middleware'i (`middleware.ts`) oluştur. Kullanıcı next-auth ile session'ı yoksa `/dashboard` altındaki tüm URL leri bloklasın ve paramaterlerı taşıyarak `/login?callbackUrl=...` adresine şutlasın."

---

## 🌍 Faydalı Kaynak Linkleri
* **[Next.js App Router Offical Doc]**: Veri mutasyonları, Form Actions ve Error Boundaries için mutlak incelenmesi gereken Next JS Kural kütüphanesi.
* **[Taxonomy by Shadcn]**: Otonom yapay zekanın dosya dizim hiyerarşisini öğrenebileceği Açık Kaynak Next.js Enterprise Template.
