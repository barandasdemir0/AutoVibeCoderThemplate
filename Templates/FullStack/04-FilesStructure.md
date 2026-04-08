# 4️⃣ FullStack (Monorepo) - Kurumsal Pürüzsüz Çalışma Klasör Yapısı

> **ZORUNLU DİZİLİM:** Monorepoların Dağılması İnanılmaz Derecede Kolaydır. Eğer Bir Dış Paket Hem Ana Dizinde, Hem Packagelarda, Hem Uygulamalarda Başıboş Yüklenmişse; NPM Instalar 5 Dakika Sürer ve Build'ler Yırtılır. Otonom yapay zeka Kusursuz Klasör Şemasını Takip Etmekle Şartlandırılmıştır.

---

## 📂 En Kurumsal Yapı: Turborepo / Pnpm Workspaces Modeli

```text
FullStack-Monorepo/
├── apps/                    # 🚀 ÇALIŞTIRILABİLİR PORTLU UYGULAMALAR (Port 3000, 8080 vs)
│   ├── web/                 # (Frontend) Örn. Next.js - Müşteri Arayüzü
│   │   ├── src/             
│   │   ├── package.json     # Bağımlılıkları: "dependencies": { "@repo/ui": "workspace:*", "@repo/db": "workspace:*" }
│   │   └── tsconfig.json    
│   │
│   ├── docs/                # (Opsiyonel) VitePress gibi Belgelendirme Sitesi
│   │
│   └── api/                 # (Backend) Örn. Express + tRPC Server Veya Honojs
│       ├── src/             # Backend Kontrollerleri Burada
│       └── package.json     # Bağımlılıkları: { "@repo/db": "workspace:*", "@repo/validations": "workspace:*" }
│
├── packages/                # 🧩 ORTAK BİLEŞENLER VE TİPLER (Yalnız başına başlatılmazlar, IMPORT edilirler)
│   ├── eslint-config/       # Şirketin Standart ESLint Kuralları (Tüm Ugyulamalar Burdan Çeker)
│   ├── typescript-config/   # Base (Ana) tsconfig.json Kuralları
│   │
│   ├── ui/                  # THE UI KIT (Müthiş Güç!)
│   │   ├── src/             
│   │   │   └── button.tsx   # Frontende ve Docs'a Giden Ortak Tailwind Butonları!
│   │   ├── package.json     # Name: "@repo/ui"
│   │   └── tailwind.config.ts 
│   │
│   ├── db/                  # VERİTABANI ERİŞİM (Database Abstraction Layer)
│   │   ├── prisma/          # schema.prisma Dosyası, Migrationlar
│   │   ├── src/             # export { db } (Singleton bağlantı)
│   │   └── package.json     # Name: "@repo/db" (Sadece Backend Ve Gerektiği Tipler Çeker)
│   │
│   └── shared/              # GENELGEÇER ZOD/YUP ŞEMALARI & ENUMLAR (Types)
│       └── src/             
│           └── schemas.ts   # export const UserSchema = ...
│
├── turbo.json               # Monorepo Build Cache Sistemi (Bütün Parelel Komutlar)
├── package.json             # KÖK BAĞIMLILIKLAR (SADECE Prettier, Husky, Typescript Tarzı Geliş. Ortamları)
└── pnpm-workspace.yaml      # (Eğer pnpm se) -> packages: [ "apps/*", "packages/*" ]
```

---

## ⚠️ Kritik Mimari Kurallar (Files Rulebook)

1. **"Workspace:*" Belirteci (Otonomun İmzası):** Otonom yapay zeka Frontend'in `package.json` dosyasına Gidip de Ortak klasörü `npm i ../../packages/ui` Formatında "Bağıl Path" Vererek BAGLAYAMAZ!! Kurumsal model Monorepo sisteminde Sürüm Kısmına ZORUNLU OLARAK `"@repo/ui": "workspace:*"` yazar. Bunun anlamı şudur: İnternetteki npm'e gitme! Direkt yandaki Kardeş klasörü canlı olarak ÇEK!
2. **Global ENV Taşması (Ortam Değişkenleri Hatası):** Projenin KÖK klasörüne Bütün .env Değişkenlerini Yıgmak Monorepo Mantığına Terstir!. Backendin Stripe Keyi İle, Frontendin Next_Public_Public Keyi BİRBİRİNE KARIŞTIRILMAZ!! Otonom Zeka .env dosyalarını Her projenin kendi Uygulama Dizininin İçine (`apps/web/.env` gibi) Gömecek ve İzoleleştirecektir!! (Veri Sızıntısına Engel Olur!).
3. **Ghost Dependency (Hayalet Paket Çöküşü) Yasağı:** Otonomi; Bir Kütüphaneyi SADECE Backend klasöründe `npm install moment` diyip yüklediyse Gidip Frontend projesinin içinden `import moment` YAZAMAZ (Hoisting nedeniyle geçici çalışabilir Ama Prod Buildinda ÇÖKER!). Kurallar Kati Sınır Çiziktir! Kim kullanıyorsa Package.json una Açıkça Yazılmalıdır!.
