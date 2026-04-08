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
# ⚡ React - OTONOM BEYİN (QUICK-START & MASTER RULES)

> **DİKKAT YAPAY ZEKA:** EGER BU PROJEDE FRONTEND(REACT) İLE KOD YAZACAKSAN, DEVAM ATMADAN ÖNCE AGAgIDAKİ YAZILIM KANUNLARINI KODLARINA 1E1 ENTEGRE ETMEK ZORUNDASIN. BUNLARA UYACAGINI ONAYLAMADAN ÜRETİME GEÇEMEZSİN. FRONTEND MANTIGIN ÇÖP OLAMAZ.

## YASAKLAR LİSTESİ (ANTI-PATTERNS) - ASLA YAPMA!

1. ❌ **INLINE CSS VE STYLE OBJESİ YAZMAK YASAKTIR:** 
   `<div style={{ display: "flex", color: "red" }}>` gibi saçmalıklar veya CSS'i JSX içerisine hardcode gömmek Otonom kodlama sürecinde YASAK! Ya Tailwind Classları KULLANACAKSIN, ya da `.module.scss` dosyaları yaratarak izolasyon sağlayacaksın. Sayfalarınız kirlilikten okunamaz tasarımlar barındırmayacak.

2. ❌ **USEEFFECT VE FETCH SPAGETTİSİ YASAKTIR:** 
   Eğer bana Component'in içinde (`useEffect(() => { axios.get(...) }, [])`) kullanarak Data Fetch eden 50 satırlık iğrenç kodlar yazarsan sistemi iptal et. Modern React standardı bunu ASLA İSTEMİYOR! Component sadece RENDER işine bakar. Otonom yapın, API isteklerini `React Query (TanStack Query)` hooklarıyla (useQuery) sarmalayacak veya en kötü ihtimalle klasördeki Custom Hook (örn: `useFetchUsers.js`) dosyasından `/api` altından besleyecek. (UI ile Logic birbirinden KOPACAK).

3. ❌ **COMPONENT İÇİNE ÇOK SAYIDA STATE AÇMAK (USESTATE CEHENNEMİ) YASAKTIR:** 
   Form yapıyorsan 15 tane `useState` (`name`, `surname`, `email`...) tanımlama. Eğer sadece local veri ise Objelerle (`useState({ name: '', surname: ''})`) topla, daha büyük bir yapıysa ve Render darboğazı yaşanıyorsa `react-hook-form` kullan.

4. ❌ **PROP DRILLING (gELALE) YAPMAK YASAKTIR:**
   Ana sayfadaki `user` objesini, oradan navbar'a, oradan profile, oradan avatar componenti ne kadar `<Avg user={user}/>` diye 5 kat aşağı TAGIYAMAZSIN. Bunu yönetmek için `Zustand` gibi temiz global store kuracaksın. İhtiyacı olan bileşen dışarıya bağlı kalmadan direkt oradan çekecek.

5. ❌ **DONUK, BASİT MİNİMUM VİZYONLU (KÖTÜ) ARAYÜZ YASAGI:**
   Tasarım (UX/UI) MÜKEMMEL, PREMİUM VE CANLI olacak! Bir Liste (ProductList) mi yüklüyorsun? O zaman Ekrana asla beyaz beyaz boş bir şey çizilmeyecek, veri gelene kadar `<SkeletonLoader>` parlayacak. Kullanıcı hover yaptığında yumuşatılmış `transform hover:-translate-y-1` tepkisi alacak. Renkler standart maviler değil (HSL Premium Gradientler, Border Raduisi iyi ayarlanmış (rounded-xl) zarif kart blokları) hissi yaratacak. Ekranda animasyonsuz ve tepkisiz tek element bırakma!

---

## ✅ ZORUNLU MİMARİ YAPISI (FEATURE-BASED DIRECTORY)

Sistemi üretirken klasörlerini Components-Pages diye yığma! "04-FilesStructure" yönergesinde emredildiği şekilde, DOMAIN (Feature) bazlı izolasyonu sağla!

```text
/src
 ├── /components          # SADECE DUMB (Aptal) BUTON, INPUT EVRENSELLERİ 
 ├── /features            # İGTE BURASI ODAK: /users veya /auth adında açın,
 │    ├── /auth              kendisine has API, COMPONENTS, HOOK, STORE ne varsa 
 │                           (Sadece O Domaini Kapsayan) buraya kodlayın.
 ├── /lib                 # Axios configs, Query Client configs.
 ├── /router              # React router V6 Objeleri.
 └── /store               # GLOBAL storelar.
```

---

## BAGLAMADAN ÖNCE BİLMEN GEREKEN İLK ADIM

Eğer User sana "Login sayfası yap" dediyse dahi,
**BU DOSYA (QUICK-START)** seni bağlar. 

1. Önce Frontend iskeletini kur (Tailwind ve Alias (örn: `@components/...`) rotaları dahi dahil).
2. Temel bir Layout bileşeni hazırla (NavBar tepende hazır olsun).
3. Sonra sayfa mantığına in. Zod validasyonu yap, Login componentine bağla.
4. Başarı durumunu Toast ile süsle ve token'ı güvenli şekilde (Store'da reaktif olarak) sakla.

**TAMAMEN PROFESYONEL VE CANLI BİR UYGULAMA SUN! BAGLAYABİLİRSİN!**

