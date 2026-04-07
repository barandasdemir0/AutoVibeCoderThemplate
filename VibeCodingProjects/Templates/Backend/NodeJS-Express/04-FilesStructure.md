# 4️⃣ NodeJS-Express - Katı Kurumsal Klasörleme (File Structure)

> **ZORUNLU DİZİLİM MÜHÜRLERİ:**
>
> Node.js ve Express.js ekosisteminde en büyük sorun (ve aynı zamanda en büyük esneklik) framework'ün size otonom veya kurumsal bir klasör hiyerarşisi (Directory Structure) diretmemesidir!
>
> Eğer siz katı mimari kurallar çizmezseniz, tecrübesiz geliştiriciler bütün mantığı tek bir `server.js` veya `routes.js` içerisine yığar.
> Mimar! Otonom bir NodeJS/Express projesi Domain-Driven Design (Alan Odaklı Tasarım) veya Feature-Based (Modül Odaklı) klasör standardıyla milimetrik olarak mühürlenmelidir!

---

## 📂 1. Kurumsal Express Klasörleme Vizyonu (`src` Altı Dağılım)

Bu mimari, otonom zekanın NodeJS projelerinde kullanacağı "Altın Standart" klasör hiyerarşisidir. Hem Service-Oriented Architecture (SOA) kurallarına hem de temiz kod (Clean Code) standartlarına mükemmel uyum sağlar.

```text
UltimateExpressAPI/
├── src/                                (TÜM MİMARİNİN ÇEKİRDEĞİ)
│   ├── /config/                        (ENV VE ÇEVRESEL YAPILANDIRMALAR)
│   │   ├── env.ts                      (Tüm process.env'lerin Zod ile Doğrulanıp Export Edildiği Yer)
│   │   ├── logger.ts                   (Winston Kofigürasyonu - Sistemin Gözü)
│   │   ├── database.ts                 (Bağlantı Mimarileri)
│   │   └── redis.config.ts             (Session ve Catch için In-Memory Mühürleri)
│   │
│   ├── /controllers/                   (HTTP POSTACILARI / SUNUM KATMANI)
│   │   ├── auth.controller.ts          (Gelen Req/Res/Next objelerini alır)
│   │   ├── user.controller.ts          (Servise veri atıp dönen sonucu JSON yapar)
│   │   └── order.controller.ts         
│   │
│   ├── /dtos/                          (ZOD/JOI VERİ DOĞRULAYICI KALKANLARI)
│   │   ├── auth.dto.ts                 (LoginDto, RegisterDto)
│   │   └── common.dto.ts               (PaginationDto, Genel şablonlar)
│   │
│   ├── /middlewares/                   (GÜVENLİK VE KORUMA DUVARLARI)
│   │   ├── authGuard.middleware.ts     (Tokenı Okur, Req.user objesine atar)
│   │   ├── roleGuard.middleware.ts     (Yetki Kontrolü Mühürü!)
│   │   ├── validateRequestBody.ts      (DTO Kalkanı - Bozuk veri içeri giremez)
│   │   ├── rateLimiter.middleware.ts   (DDoS Saldırı Engeli)
│   │   └── errorHandler.middleware.ts  (Kurumsal 500/400 MÜHÜRÜ! Tüm hataların toplandığı son durak)
│   │
│   ├── /services/                      (BEYİN KORTEKSİ / İŞ KURALLARI)
│   │   ├── auth.service.ts             (Bcrypt Hash, Prisma Sql, JWT Sign işlemleri yapılır)
│   │   ├── user.service.ts             (Req veya Res GİREMEZ! Sadece string/dto/number alır!)
│   │   └── mail.service.ts             (3. Parti Entegrasyon Mantıkları)
│   │
│   ├── /routes/                        (YÖNLENDİRME HARİTASI)
│   │   ├── v1/                         (Versioning / Versiyonlama Sistemi)
│   │   │   ├── auth.routes.ts          ( router.post('/login', validator, authController.login) )
│   │   │   ├── user.routes.ts          
│   │   │   └── index.ts                (Bütün v1 rotalarını birleştirip app.ts'e teslim eder)
│   │
│   ├── /prisma/                        (VEYA /models/ klasörü - ORM KATMANI)
│   │   ├── schema.prisma               (SQL Tablo Çizimleri, İlişki tanımları!)
│   │   └── migrations/                 (Otomatik DB Update betikleri)
│   │
│   ├── /utils/                         (YARDIMCI OTONOM ARAÇLAR)
│   │   ├── AppError.ts                 (Özel Fırlatma Sınıfı: Custom Error Exception!)
│   │   └── catchAsync.ts               (Spagetti Try-Catch bloklarını temizleyen Hata Sarmalayıcı)
│   │
│   ├── app.ts                          (EXPRESS Uygulamasının Kurulduğu, Middleware'lerin Eklendiği Yer)
│   └── server.ts                       (Sadece HTTP Server'ı ve DB Bağlantısını Ayağa Kaldırır)
│
├── .env                                (YASAKTIR! GitHub'a Asla Yüklenmez!)
├── .env.example                        (Sisteme girecek olan Örnek Şifre formatları)
├── .eslint.json                        (Kod standart kalkanı)
├── .prettierrc                         (Kod hizalama mühürü)
├── tsconfig.json                       (TYPESCRIPT MÜHÜRÜ ve katı kurallar)
└── package.json                        (Node NPM Bağımlılık Mühürü)
```

---

## ⚠️ 2. Kritik Klasörleme Yasaları ve OTONOM REÇETESİ

Eğer bir Otonom Yapay Zeka Ajanı "NodeJS Express API Mimarisi Çiz" komutunu aldığında aşağıdaki Ölümcül hatalardan birini yaparsa, Bütün Mimari Çökmüş demektir!

### Yasak 1: `routes` Klasöründe Controller Katliamı
Otonomi gidip `routes/user.routes.ts` dosyası içerisine doğrudan `router.post('/', async (req, res) => { model.find(); return res.json() })` YAZAMAZ!! 
Routing (Yönlendirme) klasörünün yegane vazifesi "Kavşak" olmaktır.

Rotalar: `[Path] -> [Middlewares] -> [Controller]` olarak 3 kelimede BİTMELİDİR! Ana mimari Controllers içinde yatar.

### Yasak 2: "CatchAsync" ve "AppError" Dosyaları İle Global Çöküş Kalkanının Unutulması
Otonomi "Tekerleği yeniden icat etme" kibrine kapılamaz. Bütün 100 tane Controller fonksiyonunu tek tek `try { ... } catch { ...}` ile SARMALAMAYACAKSIN! 
Bunun yerine OTONOMİ `utils/catchAsync.ts` mühürünü yazar ve bütün mimarileri BURADA SARMALAR.

### Yasak 3: Service Layer (İş zekası) ve Req/Res Yasakları
NodeJS API Mimarilerinde, eğer Service katmanında `UserService.create(req, res)` şeklinde parametre alıyorsan MİMAR ÇÖKMÜŞTÜR! Service, `req` ve `res` JSON objelerini BİLEMEZ! Express kütüphanesi sadece Controller katmanına aittir!. Service SADECE Otonom DTO'yu (`createUser(dto: CreateUserDto)`) bilir! JSON dönmek Controller'ın işidir!

### Yasak 4: Environment Variables (Config Klasörü Mühürleme)
`process.env.DB_PASS` gibi kritik şifreler, uygulamada rastgele çağırılamaz! Mimar sadece config klasöründen `import config from '@config/env';` şeklinde zırhları çeker.. !!

Eğer Mimar config'i UNUTURSA Node.js API Server ayağa kalkmadan otomatik olarak Crash Eder! Sistem tehlikeli kodu çalıştırmaz!
