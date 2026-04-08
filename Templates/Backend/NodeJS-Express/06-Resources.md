# 6️⃣ NodeJS-Express - Endüstri Klasikleri (Tech Stack) ve Kapsamlı Kaynak Kılavuzu

> Profesyonel, otonom bir AI (Yapay Zeka) sistemi Node.js Express.js ortamında kodu SADECE sıfırdan "Vanilla JS" ile yazıp bırakamaz. Endüstri Node.JS standartlarını, hızını, güvenliğini ve ölçeklenebilirliğini kanıtlamış büyük framework ve yardımcı paket zincirleriyle inşaa eder.
>
> Spagetti kodu YASAKLADIK ve N-tier mimarisini Kurumsal Mühürü ile Zırhlıyoruz.

---

## 📦 1. Kütüphane ve Framework Zırhları Çekirdeği

NodeJS dünyasında her küçük iş için paket kurmak ("NPM Hell") büyük bir zafiyettir. Mimar sadece The Enterprise (Kurumsal) onaylı kütüphaneleri projeye dahil edecektir.

### A. TypeScript ve ORM Zırhı
Vanilla VEYA saf Mongoose spagettisi Mimaride Yasaktır.

* **Zorunlu Başlangıç:** `typescript`, `@types/node`, `@types/express`
* **Prisma ORM (Mükemmel Karar):** `prisma` (CLI komutu), `@prisma/client` (Oluşturulan Schema Mühürü). TypeScript ile mükemmel uyumlu NoSQL VE SQL ORM'sidir. Sizi Type Safe (Tipe Duyarlı) bir kodlamaya zorlar.
* **TypeORM:** Angular bilen ekipler için en iyi Decorator tabanlı alternatiftir. Eğer Prisma kullanılmayacaksa sektörün ikinci mühürü budur.

### B. Mimaride Güvenlik Paketleri (Siber Koruma)
Otonom Zeka bir uygulama yaratırken aşağıdaki güvenlik paketlerini ENJEKTE EDECEKTİR!

* **Helmet (`helmet`):** HTTP GÜVENLİK (Header) bilgileri. Müşteri tarafı XSS (Cross Site Scripting) ve Clickjacking gibi hacking saldırılarını önler.
* **Cors (`cors`):** Sadece onaylı domainlerden API isteklerini kabul etmenizi sağlayan origin kilididir.
* **Rate-Limit (`express-rate-limit`):** Brute force (Kaba kuvvet) ve DDoS saldırılarını 15 dakikalık IP bloklama veya loglama zırhıyla engeller!

### C. Validation VE DTO Mühürleri (Zod / Joi) 
Express JS default olarak req.body verisini olduğu GİBİ OKUR!! (Bu çok büyük BİR AÇIKTIR, Mass Assignment yaratır).

* **Zod (`zod`):** TypeScript mimarisine entegre olan, otonom ajanın bayıldığı mükemmel bir DTO (Data Transfer Object) şeması ve mühürüdür!
* **Joi (`joi`):** Daha eski ama endüstride hala standart olarak kabul gören devasa bir Object/String doğrulayıcı (Validator) kalkanıdır. 

---

## 🤖 2. The Master Prompt Mühürü (Otonom Komut Şablonu!)

> **Aşağıdaki Şablon komutu otonom Zekaya projeyi yazdırırken VERMEK ZORUNDASINIZ! Aksi Halde Express Projeniz 1 Saatte Spagetti Kod Çöplüğüne Dönüşecektir!**
> 
> **Master Otonom Express.JS Komutu:**
> 
> "Bana kurumsal bir NodeJS-Express backend API'si yazacaksın.
> Kuralların: 
> 1) Kesinlikle ve KESİNLİKLE TypeScript Mühürü kullanılacak. Vanilla JS/ES6 kesinlikle KABUL EDİLEMEZ.
> 2) Mimari DÜZENİ Controller -> Service -> Repository formatında ZORUNLU olarak oluşturulacak. Controller dosyasının içerisine ASLA doğrudan veritabanı kodu (Örneğin: prisma.user.create) yazılmayacak! Bütün Veritabanı ve iş zekası Service.ts dosyalarına hapsolacak!
> 3) Bütün asenkron Hatalar (Exception) Global Error Handler Middleware zırhından geçecek. SAKIN Controller içinde 50 tane Try-Catch bloğu yazma! 1 tane catchAsync sarmalayıcısı yaz ve onu yollara uygula! 
> 4) Gelen Request verileri (Payload) DTO veya Zod Zırhıyla doğrulanmadan SAKIN Service.ts mühürüne sokulmayacak! BÜTÜN MİMARİ Mühürleri ONAYLANDI. Kodlamaya Başla!"

---

## 🌍 3. NodeJS Çöküş ve Siber Olay Log Merkezi (Winston)

`console.log()` kullanımı, geliştiricinin henüz Junior (Acemi) seviyede olduğunu gösteren bir zaafiyettir! 1 Milyon müşterisi olan devasa bir NodeJS uygulamasında loglar terminal (Console) ekranına Düşmez. (Bunun nedeni terminal kapandığında izleme sisteminin UÇUP GİTMESİDİR!).

Bunun kurumsal çözümü: `winston` veya `pino` Kütüphaneleridir!
Bütün lojistik veriler ve çökmeler sunucu devrilse bile ZORUNLU OLARAK `logs/error-2023-11.log` şeklinde fiziksel veya Cloud bir depoya kaydedilecektir!!.

```typescript
import winston from 'winston';

const logger = winston.createLogger({
  level: 'info', // Genel Information (System started vb.)
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json() // AWS, Datadog Kibana okuyabilsin diye JSON zırhı
  ),
  transports: [
    // Kritik çökmeler doğrudan error.log'a
    new winston.transports.File({ filename: 'logs/error.log', level: 'error' }),
    // Her türlü işlem buraya
    new winston.transports.File({ filename: 'logs/combined.log' })
  ]
});

// Geliştirme (Local) ortamı için Console ekranına da bas:
if (process.env.NODE_ENV !== 'production') {
  logger.add(new winston.transports.Console({
    format: winston.format.simple(),
  }));
}

export default logger;
```

**Bütün BÜYÜK Node.js UYGULAMALARI (NETFLIX, UBER VS.) BU OTONOM KURALLARLA VE MİMARİLERLE İNŞAA EDİLİR!!! Sistem zırhlandı!**
