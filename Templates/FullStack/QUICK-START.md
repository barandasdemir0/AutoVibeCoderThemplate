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
# ⚡ FULL-STACK TYPESAFE (Monorepo/tRPC) - OTONOM BEYİN (QUICK-START & MASTER RULES)

> **DİKKAT YAPAY ZEKA:** EGER BU PROJEDE ÖLÇEKLENEBİLİR (SCALABLE) BİR `FULLSTACK MONOREPO VEYA TYPE-SAFE` ALTYAPI CALISTIRIYORSAN, AGAgIDAKİ (ZORUNLU İZOLASYON VE TIP) KURALLARINA %100 UYMAK ZORUNDASIN. BİRBİRİNİ TANIMAYAN REST API'LER VEYA SPAGETTİ REPOLAR ÜRETİRSEN İGLEM İPTAL OLUR. BİZ MÜKEMMEL FULL STACK ÜRETİMİ İSTİYORUZ!.

## YASAKLAR LİSTESİ (ANTI-PATTERNS) - ASLA YAPMA!

1. ❌ **AYRI REPOSITORYLER VEYA WORKSPACESİZ YAPI YASAKTIR:** 
   Otonom Zeka Tüm Backend Ve Frontendi Gidip Ana Dizine (Herşeyi Bir araya) YIGAMAZ VEYA Tam Terine 2 Tane Ayrı Projeymış Gibi Ortak Kodları OLAMAYAAN Bağ Kopuğu Projeler YARATAMAZ!!. TurboRepo Veya Pnpm Workspaces Kullanılarak `apps/web` ve `apps/api` (Veya packages) MÜKEMMEL İzole ve Bağlı Olacaktır!!!

2. ❌ **REST API (TİP'SİZ) ÇAGRILARI - HARFİYEN YASAKTIR:** 
   Eğer Fronted'de Sunucuya Uzanırken `axios.get('/api/getusrs')` Veya Body Sine Hard Coded `JSON.stringfy({nam: 123})` Atıyarosan SEN ZAYIF BIR OTONOMİSİN.
   *DOGRUSU:* tRPC Tarzı Bir Köprü Kurulacak. Frontend Arka Plandaki Kodu Sadece Oraya Has Tip Uyumlu Methodla: `api.users.create.useMutation( payload )` Formatında Tam Typeli Uyarılı gekilde Çağıracaktır!!! Harf Hatası (Kopukluk) Cıkan Uç Yok edileceeek!!

3. ❌ **PACKAGE (ÖZEL KÜTÜPHANE) İÇİNDEN APP ÇEKMEK YASAKTIR (CIRCULAR):** 
   Eğer sen "Shared (Ortak)" klasörünün (packages) İçine gidip, UYGULAMANIN İçideki BİR ÇEVİRİ DOSYASINI (App/i18n) Import edersen SISTEMI BAGTAN SONA Kilitlersin (Circular İmport Sızıntısı)). Paketler ASLA APP lerden Içe aktarma (Dependency) Alamaz. SADECE Uygulamalar Paketi Ceker!!. The Tek Yönlü Hiyerarşi!!.

4. ❌ **BUILD/DERLEME SIRASI (TURBO.JSON) İHLALİ YASAKTIR:**
   Otonom AI Sistemi Ayağa Kalktırırken Aynı anda Tüm Repolara (npm run dev) DİYEMEZ!. Önçelikle "Paketlerin/Shared" Klasörleri Build Olmalı, Veritabanı Generatesi Çekilmeli TAAAA SOnRa Frontend Başlamlıdır! (Aksi Halde Tipten Patlarız), Turborepo DependsOn Ayarı Mühimdir!!.

---

## ✅ ZORUNLU MİMARİ YAPISI (N-TIER ENTERPRISE)

```text
/my-fullstack-repo (Turborepo Kökenli)
 ├── /apps
 │    ├── /web          => NEXT.JS / REACT FRONTENDIMIZ (Sadece Tüketici - Consumer)
 │    └── /server       => EXPRESS / FASTIFY BACKENDIMIZ (REST veya tRPC Provider)
 ├── /packages
 │    ├── /ui           => ORTAK TAILWIND COMPONENTLERİ (Button, İcon - İki yere dağılır)
 │    ├── /db           => PRISMA MİMARİSİ (Ağ Modelleri, Veritabanı Exportu)
 │    └── /config       => ORTAK TYPESCRIPT/ESLINT Standardı (Herkes Aynı Linteri Otonom Okur)
 └── turbo.json         => İGLEM SIRASI VE CACHE VITES KUTUSU!
```

---

## BAGLAMADAN ÖNCE BİLMEN GEREKEN İLK ADIM

Eğer User sana "FullStack Bir Randevu Sistemi Çiz" dediyse dahi,
**BU DOSYA (QUICK-START)** seni bağlar. 

1. Setup Scriptini `npx create-turbo` Veya Kendi Native Workspaces Ayarlarınla `pnpm-workspace.yaml` İçerisine Paketleri Set ederek Kusurszua Yakın Kur! 
2. Monrepo İçerisinde Frontend Next.js veya Vite ise, Api İsteklerini (Mümkünse tRPC / Typesafe router ile) Backend'e Bagla VE Backendin İçindeki O Methodlara Zod İle `Validation.input` kilitleri At!. 
3. Uygulamayı Kök dizinden TEK Bir Komutla (`npm run dev`) Tüm Parçaları Beraber gaha Kaldıran (concurrently Veya turbo run dev) Betiklerini Mutlaka Pürüzsüz AYARLA!. Yoksa Müşteri Projeyi Tek Tek Başlatmak Zorunda Kalır!(Sefillik).
4. Veritabanı Pakedinde (DB) Kesinlikle Prisma Schema Dosyasını Ciz, `globalThis` ile Singleton Koruması at ve Sonuçları Export Edip Backendde İthal ET (Imports).

**TEKNOLOJİ VE TİP GÜVENLİGİ GELECEGİN THE TEK UZLASI DIR, UFAK SIZINTILAR MİLYONLARCA DOLAR PATLAMALAR YAPAR! MÜKEMMEL DİZİLİME BAGLAYABİLİRSİN!**

