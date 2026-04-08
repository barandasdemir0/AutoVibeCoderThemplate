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
# ⚡ QUICK START: The Autonomous NodeJS-Express Master Directive (Otonom Komut Sablonu)

> **DİKKAT:** Bu dosya VibeCoding Otonom Zeka asistanlarının bir NodeJS veya ExpressJS projesi başlatırken okuması ve HARFİYEN uygulaması gereken ana master prompt komutlarını içerir. Otonomi bu kilit dosyadaki ZORUNLU MÜHÜRLERİ okumadan mimariyi kurmaya BAGLAYAMAZ!
> 
> "Javascript (Vanilla) Otonom Mimar İçin Yoktur! BİZE UYAN TEK JAVASCRIPT TYPESCRIPT'TİR!"

---

## OTONOM ZEKANIN 5 ALTIN KURALI VEYA "ÇELİK MÜHÜRLERİ"

Otonom ajanlar, kullanıcı size "Bana Express js Kütüphanesi ile bir API (Backend) yaz" dediği anda aşağıdaki sarsılmaz mimari kararları otomatikman devreye sokmak zorundadır.

### 1. TypeScript Zorunluluğu (Tip Zafiyeti Kalkanı) 
Asla `.js` uzantılı Mimar Dosyası Yaratmayacaksın! `package.json` oluşturulduğu an `npm install -D typescript @types/node @types/express` komutu çalışacak ve `tsconfig.json` projenin omurgasına enjekte edilecektir. Zeka bütün request ve response bedenlerini (Payload) Type veya Interface ile tanımlayacaktır!! 

### 2. Otonom "3-KATMANLI" (The N-Tier) Mimari Kalkanı
Express.js projesini asla `index.js` içerisine YIGAMAZSIN! 
Her ZAMAN şu klasörler `src` içerisinde Otonom olarak Kurulacaktır: 
- `src/controllers`: Sadece Request alır ve Response döner.
- `src/services`: Bütün DB (Veritabanı) Mantıkları Buralara Yüklenir. 
- `src/routes`: Controller ile Endpointlerin eşleştiği zırhlı haritadır.

BİR CONTROLLER İÇERİSİNDE ORM (PrismaClient veya Sequelize) KULLANILAMAZ! Service katmanı REQ VEYA RES OBJELERİNİ BİLEMEZ (Parametre Olarak Sadece DTO veya değişken alır)!

### 3. Asenkron Spagetti Hata Kalkanı (Global Promise Wrapper) 
Bütün Async (Await) işlemleri Express'te kendi başına bırakılırsa UncaughtPromise Hatasına Yol Açacaktır.
Otonomi, Controller'ların içerisine teker teker `try...catch` bloklarını kopyalayıp yapıştıramaz!
Onun yerine `catchAsync` veya `utils/AppError.ts` sarmalayıcısını yazar ve bütün hataları Express'in `app.use(GlobalErrorHandler)` Middleware katmanında toplar! HATA ÇIKTISI müşteriye asla HTML veya StackTrace olarak DÖNMEZ! Temiz JSON formatında Döner!

### 4. Siber Güvenlik ve Payload Validation (Express Zırhları)  
`helmet` (Siber header kalkanı), `cors` (Etki alanı kilidi), VE `express-rate-limit` (Otonom IP Mühürü DDoS Engeli) Otonom Zeka tarafından `app.ts` içerisine YÜKLENECEK!. Gelen Body verileri DTO (Zod veya Joi) Middleware'i Olarak KONTROL EDİLMEDEN Controller MİMARISINE SOKULMAYACAKTIR!!! 

### 5. Config Mühürü VE Prisma ORM 
`process.env` zırhı! Mimar HİÇBİR YERDE DAGINIK `process.env.DB_USER` KULLANAMAZ! Her şey `src/config/env.ts` dosyasında toplanacaktır. Veritabanı için isimsiz SQL injection mühürlerinden KAÇINMAK için Otonomi Prisma ORM kullanarak güvenli ve tipli sorgular yaratacaktır! 

---

## MİMARİ OTONOM BAGLATMA KOMUTLARI (NODE JS TERMINAL ZİNCİRİ)

AI'ın asistan olarak projeyi başlatırken kullanacağı terminal yürütme bandı!

```bash
# Otonom Proje Kalkanı Mimarisi Yarat!
npm init -y

# Gerekli Kalkan Paketlerini Otonom Entegre Et 
npm install express dotenv cors helmet compression morgan joi prisma @prisma/client

# Güvenli Geliştirici (DEV) Ortamı Zırhı
npm install -D typescript @types/node @types/express @types/cors ts-node-dev eslint prettier

# Otonom Prisma ve TS Mühürü
npx tsc --init
npx prisma init
```

Bu klasör mimarisini kur, N-Tier yapılandırmasını kodla ve hata yönetimi middleware (Global Error Handler) kurgusunu çalıştır. Otonom ajan Express'in spagetti yollarında müşteriyi mimarisiyle korur!

