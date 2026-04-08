# 5️⃣ Next.js - İzleme, Loglama ve SEO (Debug) Cila Ustalıkları

> **ZORUNLU STANDART:** Mükemmeliyetçi otonom AI; projenin çalışmasını yeterli görmez. O proje google'da 1. Sıraya çıkacak şekilde SEOnun Optimize edilmesini, konsolda Hydration Hatası bulunmamasını ve Data kirleniği olmamasını ZORUNLU standartta yerine getirir.

---

## 🚫 1. Hydration Hataları

Klasik React'ten çok daha fazla görülen devasa problem: "Client ile Server'da oluşan HTML'in BİRBİRİNİ TUTMAMASIDIR". 

1. ❌ **Browser API'lerini Sayfa Mount Olmadan Kullanmak:**
   ```jsx
   // FELAKET - Server'da window olmadığı için sayfa render atar ve Serverda boş olur, Clientta veriyle dolar. NextJS Patlar!
   export default function TimeCheck() {
     const isMobile = window.innerWidth < 768; // SERVERDA BU YOK!
     return <div>{isMobile ? "Mobil" : "PC"}</div>
   }
   ```
   *DOĞRUSU:* Pencere boyutunu veya localstorage'i ölçecekseniz, `useEffect` mount olana kadar (true dönene kadar) varsayılan null basmalısınız! Veya Dynamic Import ssr: false kullanmalısınız. `const DynamicChart = dynamic(() => import('./Chart'), { ssr: false })`

2. ❌ **Div içinde p tagi, P tagi içinde span tagini yanlış kullanmak:** HTML standartlarına aykırı renderlar Next'te affedilmez ve Hydration'ı çökertir.

---

## ✅ 2. SEO (Search Engine Optimization) Hileleri

Otonom model, her geliştirdiği dinamik sayfaya Metadata atamak ZORUNDADIR.

1. **Dinamik Verilerde SEO Basımı (`generateMetadata`):**
   Bir Blog detay sayfası (`/blog/[slug]/page.tsx`) yazdın diyelim. Sadece sayfa basarak bitmez. Sayfanın en üstüne Otonom aşağıdaki API'yi asmak zorundadır:
   ```tsx
   export async function generateMetadata({ params }): Promise<Metadata> {
      const post = await getPostBySlug(params.slug); // Cache'den gelir, ekstra yormaz.
      return {
          title: `${post.title} | Şirket Adı`,
          description: post.excerpt,
          openGraph: { images: [post.thumbnailUrl] }
      }
   }
   ```

2. **Sitemap ve Robots.txt:** Mükemmel otonom süreçte uygulamanın kök dizininde `app/sitemap.ts` OLUŞTURULACAK. Bu dosya dinamik olarak DB'deki tüm URL leri döndürecektir. SEO zayıf kalırsa sistem çöp sayılır.

---

## 💥 3. Server Actions'ları Cache'den Çıkarmak (Revalidate)

App routerda Next.js datayı CACHELER. Ürün ismini güncelledin, anasayfaya gittin... Eski isim oradaysa KOD PATLAK DEMEKTİR.

* Server actions update, create veya delete fonksiyonlarında DB sorgusunu çalıştırdıktan HEMEN SONRA otonom zeka `revalidatePath('/admin/products')` (ya da Tag bazlı `revalidateTag('products')`) methodunu çağırmak MECAZİ DEĞİL ZORUNLUDUR! Değişiklik yaptığın an veritabanı yansımalarının cacheini yık!

---

## 📊 4. Error Boundaries (`error.tsx` - Hata Yakalayımı)

`error.tsx` sayfaları default olarak **KULLANICI BİLEŞENİ (use client)** olmak ZORUNDADIR!. Çünkü hata tetiklenip kullanıcı hatadan "Try Again" metoduyla bir daha istek atarken bu işlem tarayıcıda yönetilir.

* Eğer Error sayfasına detaylı Sentry veya Datadog entegrasyonu yazılırsa hata otomatik oraya paslanır. AI sistemi hatayı boş beyaz sayfada göstermekten men edilmiştir. Kullanıcının gözüne premium, animasyonlu bir "Bunu Bulamadık..." sayfası çizecektir.

```tsx
'use client'
export default function ErrorBoundary({ error, reset }: { error: Error, reset: () => void }) {
  return (
    <div className="flex flex-col items-center justify-center p-24">
      <h2 className="text-xl font-bold">Eyvah! Bir Hata Meydana Geldi.</h2>
      <button onClick={() => reset()} className="mt-4 p-2 bg-red-600 text-white">Yeniden Dene</button>
    </div>
  )
}
```
