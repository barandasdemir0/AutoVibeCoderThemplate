## SEQUENCE-ENGINE v1 (ZORUNLU)
Bu template ile calisirken sirayi bozmak YASAK:
1) QUICK-START.md
2) 01-Planning.md
3) 02-Architecture.md
4) 03-StepByStep.md
5) 04-FilesStructure.md
6) 05-DebugTips.md
7) 06-Resources.md

Kural:
- Her dosyadan sonra 3-5 maddelik "cikarim ozeti" yaz.
- Ozeti yazmadan sonraki dosyaya gecme.
- 7 dosya tamamlanmadan kod uretimine baslama.
- Bu akisin detay standardi: Templates/_Universal/TEMPLATE-SEQUENCE-ENGINE.md

---
# ⚡ Next.js - OTONOM BEYİN (QUICK-START & MASTER RULES)

> **DİKKAT YAPAY ZEKA:** EGER BU PROJEDE NEXT.JS (APP ROUTER) YAZACAKSAN, DEVAMTMADAN ÖNCE AGAgIDAKİ FULL-STACK YAZILIM KANUNLARINI KODLARINA 1E1 ENTEGRE ETMEK ZORUNDASIN. BUNLARA UYMAYANKOD NEXT.JS DEGİLDİR, YAVAg CALISAN BOZUK BİR REACT'TIR.

## YASAKLAR LİSTESİ (ANTI-PATTERNS) - ASLA YAPMA!

1. ❌ **SAYFANIN ("PAGE.TSX") EN ÜSTÜNE KÖRKÜTÜK `'use client'` EKLENMESİ YASAKTIR:** 
   Eğer ana sayfada buton dinleyeceğim veya animasyon yapacağım diye gidip tüm sayfayı Client component yaparsan Otonom Model hata yapıyor demektir. Sayfa (Page) her zaman Server'da olacak (`async function Page`), İnteraktif parçalar (`onClick`, `useState`) içeren butonlar veya komponentler AYRI BİR DOSYADA yazılıp import edilecek!

2. ❌ **API ROUTES (`/app/api/...`) SPAGETTİSİ YASAKTIR:** 
   Form kaydetmek, login olmak veya sepete ekleme yapmak için dışarı HTTP istekleri (Axios/fetch) açma! Next.js artık Server Actions destekliyor. Form submit butonları `action={myServerFunction}` şeklinde doğrudan klasördeki `use server` tanımlı Action metotlarına (Backend logic) gidecek. Axios/API kullanımı sadece harici webhooklar içindir.

3. ❌ **HYDRATION ÇÖKERTİCİ HTML YAZMAK YASAKTIR:** 
   `useEffect` çalışmadan tarayıcı boyutu (`window.innerWidth`) veya `localStorage` okumaya kalkışırsan SERVER'da bu API'ler olmadığı için Next.js Hydration Mismatch fırlatır! İstemci özelliklerini sadece Mount (`useEffect` içi veya dynamic ssr:false sarmalı) aşamasından sonra kullan!

4. ❌ **SİYAH-BEYAZ BASİT (UX SIFIR) ARAYÜZ YASAGI:**
   Tasarım (UX/UI) MÜKEMMEL, PREMİUM VE CANLI olacak! Sayfa geçerken pürüzsüz animasyonlar (Framer-motion) katılacak, Server Mutations (Veritabanı güncellemesi) yaparken Frontend'te Button Disable edilecek ve "Pending (Loading)" status devreye girecek (`useFormStatus` hooku ile). Ekranda kullanıcı tıkını "Bozuk mu lan bu" hissini yaşatmayacaksın!

---

## ✅ ZORUNLU MİMARİ YAPISI (ROUTE ISOLATION)

Sistemi üretirken kodlarını `components/` klasörüne yığma. "04-FilesStructure" yönergesinde emredildiği şekilde Parantez routing (Route Groups) kullan:

```text
/src
 ├── /app                 # SADECE SAYFA RENDER'I VE URL DİZİLİMİ İÇİN 
 │    ├── (auth)            => Login ve Register route'larını kaplar
 │    │    ├── login
 │    │    │    └── page.tsx 
 │    ├── (dashboard)       => /admin dashboardını kaplar (Ayrı layout ile)
 ├── /components          # UI ATOM VE LAYOUT KOMPONENTLERİ
 ├── /actions             # 'use server' TÜM VERİTABANI İGLEMLERİ (Backend/API) 
 └── /lib                 # DB (Prisma/Drizzle) bağlantıları.
```

---

## BAGLAMADAN ÖNCE BİLMEN GEREKEN İLK ADIM

Eğer User sana "Full-Stack bir Blog kur" dediyse dahi,
**BU DOSYA (QUICK-START)** seni bağlar. 

1. Başlangıçta Prisma (Veya Drizzle) ORM katmanını yapılandır ve `schema.prisma` veritabanını modelle (Model User, Model Blog).
2. Frontend iskeletini kur (Tailwind Root Layout, Metadata).
3. Sonra sayfa mantığına geç. Verileri `await db.blog.findMany()` diye doğrudan `page.tsx` içinde Server Component (RSC) ile statik çek.
4. Yeni blog ekleme formunu `/actions/blog.ts` içine yazılmış `use server` fonksiyonlarına bağla (React Query veya Axios KULLANMADAN). DTO olarak Zod ile Form verisini güvenle tara.
5. İşlem bitince `revalidatePath('/')` ile server Cachesini yıkarak anasayfada verinin anında görünmesini sağla!

**YENİ NESİL WEB DEVELOPMENT NEXT.JS'DIR, BUNU MUHTESEM KULLAN! BAGLAYABİLİRSİN!**

