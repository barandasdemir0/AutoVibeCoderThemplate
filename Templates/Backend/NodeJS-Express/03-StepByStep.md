# 3️⃣ NodeJS-Express - Endüstriyel Başlangıç Adımları (Step-By-Step Setup)

> **OTONOM KOMUT BAŞLATICI VEYA CLI UYARISI:** 
> 
> Bir Otonom Zeka asistanı Node.js Express projesi yaratırken `npm init -y` diyerek klasörü başıboş bırakıp single file Javascript yazmaz (Spagetti Monolith Yoktur). 
> 
> Güçlü bir enterprise Mimarisi C#'daki gibi TSC (Typescript Compiler), Eslint, prettier ve ORM yapılandırmasını CLI ile MÜKEMMEL bir hatasız komut zinciriyle Ayağa Kaldırır. Kusursuz yaratım bandı tam 5 FAZDAN oluşur...

---

## 🚀 FAZ 1: Node.JS Solution İskeletinin Çıkarılması ve TypeScript İnşası

Otonomi. Mükemmel NodeJS Uygulamasını Terminal'de şu ardışık komutlarla yaratır.

### Adım 1: Klasör, NPM Init ve Paket Yüklenmeleri 

Zeka baştan terminal ortamına geçer. Proje yapısı için gerekli kabuğu NodeJS paket yöneticisi kullanarak mühürler.

```bash
# Ana klasörü yarat ve içine gir
mkdir Ultimate.ExpressApp
cd Ultimate.ExpressApp

# NPM'i başlat
npm init -y

# Temel Express Kütüphanelerini Yükle
npm install express dotenv cors helmet compression morgan cookie-parser

# Kurumsal Zeka Mühürü İÇİN Zorunlu Olan TypeScript ve Tip Desteklerini Kur!
npm install -D typescript @types/node @types/express @types/cors ts-node-dev tsx

# Linter ve Code Formatter Kurulumları
npm install -D eslint prettier
```

### Adım 2: TypeScript (tsconfig.json) Konfigurasyonu

Vanilla JS YASAKTIR. TypeScript compile kuralları `tsconfig.json` dosyasıyla katı bir hale getirilir. 

```bash
npx tsc --init
```

Oluşan `tsconfig.json` İçerisindeki KATI Otonom Kurallar şunlar olmalıdır:
```json
{
  "compilerOptions": {
    "target": "es2022",                /* Modern Özellikler JS! */
    "module": "commonjs",             
    "rootDir": "./src",                /* Otonom SRC Klasörü Zorunlu! */
    "outDir": "./dist",                /* Build edilecek Çıktı Klasörü! */
    "strict": true,                    /* NO ANY! NO NULL FAILURES! */
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src/**/*"]
}
```

---

## 📦 FAZ 2: Veritabanı ve ORM Zırhının Inşası

Otonom zeka, spagetti SQL cümleleriyle `SELECT * FROM Users` mimarisi yazmaz! Modern Node projeleri Prisma veya Sequelize ORM'siyle inşaa edilir.

### Adım 3: Prisma ORM (Güvenli Mimarinin Kalkanı) 

```bash
# Prisma ORM'yi Projeye OTONOM Enjekte Et!
npm install @prisma/client
npm install -D prisma

# Prisma Başlat
npx prisma init
```

Bu komut, `prisma/schema.prisma` ve `.env` Dosyalarını otomatik tasarlar. Ajan bu şemaya Entity/Model verilerini yükleyecektir.

---

## 🏗️ FAZ 3: Otonom Kodlama Mimarisi (Src Katmanları VE DI)

Terminal'e Veda Edip Bütün Mimarileri TypeScript'in güçlü tip güvencesine döküyoruz.

### Adım 4: Klasör İskeletinin Oluşturulması
Otonomi `src` klasörünü açar. İçine `controllers`, `services`, `routes`, `middlewares`, `dtos`, `utils` Klasörlerini oluşturur. Zırhlar bu klasörlerde işlenir!

### Adım 5: Env (Config) Kilitinin Yaratımı
Sistemin environment Variables'lerini toplayan modülü yazar. Eksik Varsa sistemin başlamasını Boot anında bloklar! (Fail-Fast prensibi).

---

## 🎨 FAZ 4: Mükemmel Express Server (App.ts && Server.ts) Kurulumu!

Akan kodu tek bir Server.js dosyasına BOĞMAYACAKSIN! APP.TS (EXPRESS MÜHÜRÜ) ve SERVER.TS (SADECE BAŞLATICI BOOT) ayrımını yapmak ZORUNDASIN.

### Adım 6: `src/app.ts` (Uygulamanın Başı Ve Güvenlik Ağları) 

```typescript
import express, { Application, Request, Response, NextFunction } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import v1Routes from './routes/v1'; // Bütün Mimarisi Buradan Geçecek!
import { globalErrorHandler } from './middlewares/errorHandler';
// import { AppError } from './utils/AppError';

const app: Application = express();

// Otonom Zeka Güvenlik Mühürleri 
app.use(helmet()); 
app.use(cors()); 
app.use(express.json({ limit: '10kb' })); // Body payload Mühürü!

// Route Mühürü
app.use('/api/v1', v1Routes);

// Tanımsız Route Hataları İçin 404 Catcher
/*
app.all('*', (req: Request, res: Response, next: NextFunction) => {
    next(new AppError(`Rota bulunamadı!`, 404));
});*/

// Küresel Müşteri Exception Guard Mühürü!
app.use(globalErrorHandler);

export default app;
```

### Adım 7: `src/server.ts` (Sadece App Ayaklar Ve DB Mühürü)
```typescript
import app from './app';
// import config from './config/env';
import { PrismaClient } from '@prisma/client';

export const prisma = new PrismaClient(); // DataAccess

async function bootstrap() {
    try {
        await prisma.$connect();
        console.log('✅ Veritabanı Mükemmel Mühürlendi!');
        
        const server = app.listen(3000, () => {
            console.log(`🚀 Otonom Sunucu 3000 portunda UÇUYOR!`);
        });
        
        // İşletim Sistemi Asenkron (Promise) Hatalarını İzole Et.
        process.on('unhandledRejection', (err: any) => {
            console.log('UNHANDLED REJECTION! 💥 Kapanıyor...');
            server.close(() => {
                process.exit(1);
            });
        });
        
    } catch (error) {
        console.error('Veritabanı Çöktü!! ', error);
        process.exit(1);
    }
}

bootstrap();
```

---

## ⚡ FAZ 5: Mimarinin Yürütülmesi (Run & Migration)

1. `package.json` a ekle : `"dev": "tsx watch src/server.ts"`
2. ORM deki class Entity'leri (KULLANICI TABLOSUNU vs) Prisma Schema'da Çiz!
3. Migrate Et VE Sunucuyu CALISTIR!

```bash
npx prisma migrate dev --name init_schema
npm run dev
```

**Mimar!** Sen Javascript'in o vahşi batısını katı bir sözleşmeye (N-TIER EXPRESS) bağlamayı başardın. Uçuşa geçebilirsin!
