# 2️⃣ NodeJS-Express - Zırhlanmış Kurumsal Sistem Mimarisi (Clean Architecture)

> **ZORUNLU MİMARİ NOTU:** 
> Yapay zeka bu dosyada belirtilen servis yönelimli katmanlar (Service-Oriented / Clean Architecture) prensiplerini sadece bir "öneri" olarak GEÇİŞTİREMEZ, bu prensipler yasadır!
> 
> Express.js'in yapısı gereği framework size hiçbir dosya klasörü veya mimari diretmez. Node kültürünün zaafı da budur; isteyen her kodu tek `server.ts` dosyasına bile dökebilir.
> Sen Otonom Bir Mimarsın! Geliştireceğin her NodeJS uygulaması katı Controller-Service-Repository katman izolasyonlarına sahip olmalı, DI (Dependency Injection) yapısını kendi kurgulamalı ve "Spaghetti Import Hell" problemlerinden korunmalıdır.

---

## 🏗️ 1. Gelişmiş "N-Tier" Mantığı ve Clean Architecture İzolasyonu

JavaScript (NodeJS) dünyasında .NET veya Java gibi "Class Library" (Ayrı projeler) oluşturmak yaygın değildir. Bunun yerine tek bir ana proje (`src` klasörü) içerisinde devasa "Katı Sınırlar" (Strict Boundaries) çizilir.

Otonominin çizmek ZORUNDA olduğu katmanlar ve sorumlulukları:

### 🌐 PRESENTATION LAYER (ROUTER & CONTROLLER)
* **Kapsam:** Dış dünyadan gelen HTTP İsteklerini (Request: Get, Post, Put, Delete) karşılayan kalkan.
* **İçerik:** `routes` klasörü, `controllers` klasörü, ve gelen JSON Payload'u denetleyen `middlewares` (Joi/Zod DTO Validator).
* **Zorunlu İzolasyon (Yasak):** Controller asla Veritabanı Mimarisine (Prisma/Mongoose/Sequelize) ulaşıp `findById()` tarzı ORM komutları YAZAMAZ!! Ayrıca "Banka Bakiyesi Hesaplama" gibi Business Logic de yazamaz. Sadece Body'yi alır, Servise paslar ve JSON'ı Müşteriye basar!

### 🧠 BEYİN KORTEKSİ (BUSINESS LAYER / THE SERVICE PATTERN)
* **Kapsam:** Sistemin Kalbi. Controller'ın gönderdiği temiz veriyi anlar, iş zekasını (Business Rules) çalıştırır.
* **İçerik:** `services` Klasörü. Müşteri bakiye kontrolü, E-posta gönderimi tetiklemesi, Sepet (Cart) indirim hesaplaması. 
* **Zorunlu İzolasyon (Bağımsızlık Kuralı):** Service sınıfları KESİNLİKLE `req` (Request) veya `res` (Response) objelerini BİLEMEZ! Servis SADECE parametre (Kullanıcı_ID, string, Dto objesi) alır. Eğer bir Servisin parametresi Express `req` objesi ise o Mimar Zeka çöp olmuştur!

### 💾 HAMALLAR BİRLİĞİ (DATA ACCESS LAYER / MODELS & REPOSITORIES)
* **Kapsam:** Gerçek veri tabanıyla SADECE bu katman konuşabilir. (Prisma, TypeORM, Mongoose vs.)
* **İçerik:** Eğer Otonomi Repo Mimarisi kuracaksa `repositories` klasörü veya Model tasarımları (`models` Klasörü).
* **Açıklama:** Eğer Prisma ORM Kullanılıyorsa özel bir repository Sınıfı yazmadan, PrismaClient'ı Service içinde güvenle kullanabilirsiniz.

---

## ⚡ 2. Otonom Hata Yönetimi (Global Error Pipeline)

Node.JS projelerinde Müşteri bir hata aldığında sunucunun "Uncaught exception" ile çökmesi YASAKTIR! Otonomi bütün mimaride şu hata kuralını çizer:

### A. Kendi Özel Exception Sınıfının Kurulumu 
NodeJS `Error` objesi yetersizdir. Otonomi hemen `utils/AppError.ts` sınıfını yaratır. 

```typescript
// MÜKEMMEL THROW KALKANI
export class AppError extends Error {
    public statusCode: number;
    public status: string;
    public isOperational: boolean;

    constructor(message: string, statusCode: number) {
        super(message);

        this.statusCode = statusCode;
        this.status = `${statusCode}`.startsWith('4') ? 'fail' : 'error';
        this.isOperational = true; // Programlama hatası değil, Mantık Hatası (Bilinçli fırlatılan)

        Error.captureStackTrace(this, this.constructor);
    }
}
```

### B. Global Express Error Guard (Toplayıcı Middleware)

Bütün Controller'lardan fırlatılan hatalar ( `throw new AppError('Müşteri Bulunamadı', 404)` ) veya asenkron çökmeler Express'in `app.ts` dosyasının EN ALT SATIRINDAKI Global Error middleware'inden alınır: 

```typescript
// BÜYÜK SUNUCU MÜHÜRÜ (app.ts'in en alt satırları)

// Tanımlanamayan veya Hatalı Rotalar İçin Guard
app.all('*', (req: Request, res: Response, next: NextFunction) => {
    next(new AppError(`Bu sunucuda ${req.originalUrl} rotası bulunamadi!`, 404));
});

// Dev Otonom Global Hata Yönetici
app.use((err: any, req: Request, res: Response, next: NextFunction) => {
    err.statusCode = err.statusCode || 500;
    err.status = err.status || 'error';

    // Development (Geliştirici) ortamı için Stack İzleri bas
    if (process.env.NODE_ENV === 'development') {
        res.status(err.statusCode).json({
            status: err.status,
            error: err,
            message: err.message,
            stack: err.stack
        });
    } 
    // Üretim (Production) için Stack İzini ASLA (Siber Güvenlik) basma!
    else if (process.env.NODE_ENV === 'production') {
        let error = { ...err };
        error.message = err.message;
        
        // Operasyonel ise müşteriye bilgi dön
        if (err.isOperational) {
            res.status(error.statusCode).json({
                status: error.status,
                message: error.message
            });
        } 
        // Bilinmeyen (Programlama) hata ise durumu 500'e çevir!
        else {
            console.error('BÜYÜK HATA VAR💥', err);
            res.status(500).json({
                status: 'error',
                message: 'Çok kritik bir sistem hatası meydana geldi!'
            });
        }
    }
});
```

---

## 🛡️ 3. Otonom Siber Güvenlik Kilitleri Mimarisi 

Otonomi Mimar Express API'sini yaratırken Default güvenlik yoksunluklarını kapatacaktır! 

### A. Environment (Çevresel) Değişken Zırhı ve Token Kilidi
Controller içinde `process.env.JWT_SECRET` Okunması ZAYIF KODDUR!! 
Bütün ENV ayarları config klasöründe `index.ts` veya `env.ts` dosyasında TOPLANIR. Programın mimarisi ayağa kalkarken (Server.ts) Eğer JWT secret eksik ise sunucu kendisini Başlatmayı (Boot) engeller ve BOOT CRASH verir! (Fail-Fast Mimarisi). Sistem tehlikeli halde çalıştırılmaz.

### B. Payload Validation (Joi ve Zod data Filter)
Client'dan Gelen verileri middleware üzerinde DOĞRULA! 

```typescript
// DTO Validation Middleware 
import { z } from 'zod';

export const userRegistrationSchema = z.object({
  email: z.string().email("Geçerli E-Posta Giriniz!"),
  password: z.string().min(8, "Şifre Min 8 Karakter OLMALI!"),
});

// Middleware Mimarisi Olarak 
export const validateSchema = (schema: z.AnyZodObject) => {
    return async (req: Request, res: Response, next: NextFunction) => {
        try {
            await schema.parseAsync(req.body); // ONAY İŞLEMİ
            next();
        } catch (error: any) {
            const errorMessages = error.errors.map((err: any) => err.message).join(', ');
            next(new AppError(errorMessages, 400));
        }
    };
};

// Route dosyasında Kullanimi!
// router.post('/register', validateSchema(userRegistrationSchema), AuthController.register);
```
Böylelikle Controller asla eksik bir veriyi işleme sokmaz. NODE.JS dükkanı Otonom Zekanın en mükemmel esnekliğinin sisteme dönüştüğü alandır!
