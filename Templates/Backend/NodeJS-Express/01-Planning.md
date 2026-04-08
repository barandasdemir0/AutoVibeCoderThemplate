# 1️⃣ NodeJS-Express - Kurumsal Ön Planlama ve Sistem Analizi (Enterprise Planning)

> **"Spagetti JavaScript, ölçeklenebilir bir Node projesinin en sinsi katilidir."** 
> 
> Otonom bir yapay zeka (AI) olarak, NodeJS ve Express iskeletine giriş yapmadan önce bilmen gereken en hayati kural şudur: "Express.js aşırı derecede esnektir." 
> 
> Bu esneklik, tecrübesiz ellerde Route, Controller, Model ve Service katmanlarının tek bir `index.js` dosyasına sıkıştırılarak "Callback Hell / Promise Hell" çukuruna düşmesine sebep olur. Otonomi, bu düzensizliği reddeder! BİZ SADECE TYPESCRIPT VE OOP/MODÜLER DİSİPLİNLER İLE YAZILMIŞ, DOMAIN-DRIVEN (DDD) VEYA FEATURE-DRIVEN BİR EXPRESS MİMARİSİ İSTİYORUZ.

---

## 🏗️ 1. Mimari Seçimi ve Tür Güvenliği (TypeScript Zorunluluğu)

NodeJS projelerinde runtime (çalışma zamanı) hatalarını bitirmenin tek yolu "Tip Güvenliği" sağlamaktır. Otonomi, JavaScript'i "Vanilla JS" olarak kurumsalda KULLANMAYACAKTIR.

### A. TypeScript: Sistemin Zırhı
JS ile yazılan Express projelerinde, fonksiyona giren verinin türü (String mi, Object mi?) ancak HTTP 500 kodu fırlatıldığında anlaşılır.
* **Kural:** Her otonom NodeJS-Express projesi BAŞTAN SONA `TypeScript (.ts)` ile derlenecektir.
* **İzolasyon:** Entity arayüzleri (`IUser`), DTO tipleri (`CreateUserDto`) ve hata dönüş kalıpları katı bir şekilde tanımlanacaktır. 
* **Avantajı:** Ajanın (Otonominin) yazdığı kod, compile (transpile) aşamasında hataları yakalar ve "Property 'email' does not exist on type 'object'" şeklindeki klasik çökmeleri önler.

### B. Mimaride Controller ve Service Ayrımı (Service Layer Pattern)
Express dökümanlarında bile Controller içinde `UserModel.create(req.body)` kullanılır. Bu YASAKTIR!
* **Router (Route):** Sadece isteğin nereye gideceğini (URL Path ve Middleware kontrolü) haritalar. Asla logic içermez!
* **Controller:** HTTP isteğini (Request) karşılar, DTO Validasyonundan geçer, işlemi "Service" Sınıfına Pompalar ve sonucu JSON formatında HTTP Response olarak Müşteriye döner. Veritabanını BİLMEZ!
* **Service:** Bütün iş zekasının (Business Logic) yürüdüğü kalptir. Kargo hesaplaması, şifre doğrulama, Veritabanı işlemleri BURADA OLMALIDIR! 

**Anti-Pattern Örneği (Yasaklı):**
```javascript
// OTONOMİ BÖYLE SPAGETTİ YAZAMAZ!
app.post('/api/users', async (req, res) => {
    try {
        const { email, password } = req.body;
        if (!email) return res.status(400).send("Email required");
        
        // Şifre hashi buradaysa MİMARİ YIKILDI!
        const hashedPassword = await bcrypt.hash(password, 10); 
        
        // ORM doğrudan route içindeyse MİMARİ YIKILDI!
        const user = await db.User.create({ email, password: hashedPassword }); 
        
        // Eposta gönderimi buradaysa MİMARİ YIKILDI!
        await mailService.sendWelcome(user.email); 
        
        res.status(201).json(user);
    } catch(err) {
        res.status(500).json({ error: err.message }); // Gizliliği ifşa ettin!
    }
});
```

---

## 🎨 2. ORM Kararı: Prisma vs Sequelize vs TypeORM

NodeJS ortamında veritabanı etkileşimleri SQL injection zafiyetlerini önlemek ve migrationları yönetebilmek için Otonom Mimar ORM Mimarisi kurgular!

### A. Prisma ORM (Otonominin Altın Seçeneği)
TypeScript ile kusursuz uyum sağlar. `schema.prisma` dosyasında veritabanı tasarlanır. N+1 sorunlarını `include` ve `select` bloklarıyla engeller.
* Kural: Otonomi, kompleks foreign key ilişkilerini (Örn: Kullanıcı ve Siparişleri) Prisma'da zorunlu olarak "Referential Actions" (Cascade Delete vs) ile güvenceye almalıdır.

### B. TypeORM (Enterprise Geçmiş)
Mimar Angular veya SpringBoot (Java) geçmişine sahipse, Decorator pattern ile (`@Entity`, `@Column`) Sınıfı Model klasöründe inşaa eder!

### C. Katı Repository Mimarisi Gerekli Mi?
Prisma veya TypeORM kullanılıyorsa zaten altyapıları IQueryable / Promise Repo mantığındadır. "Repository Pattern"i Service katmanının arkasına kurmak Node.js projelerinde kod israfına neden olabilir. Express projelerinde Otonom Ajan Service Sınıfı içinde ORM'yi doğrudan çağırabilir (Fakat Controller'da ASLA çağrılamaz).

---

## 🔒 3. Enterprise Express Siber Güvenlik Mimarisi

Express.js varsayılan olarak SADECE Http(s) portlarını tutar. Kendi içerisinde hiçbir güvenlik middleware'i barındırmaz. Otonom Zeka bu Zırhları kurgulamakla Yükümlüdür!

### A. Helmet and CORS Shield
Uygulama ayağa kalkarken `app.use(helmet())` zırhını geçmek ZORUNDASINIZ! Güvenlik Header'ları (X-XSS-Protection, X-Frame-Options) tarayıcı bazlı saldırıları anında bloke eder! CORS ayarları vahşi batıdaki gibi `origin: '*'` şeklinde BIRAKILAMAZ! Sadece otorize URL'lere izin verilecektir!

### B. Express Rate Limiting (DDoS Engeli)
NodeJS single-threaded (tek iş parçacıklı) bir mimaridir. Eğer hacker saniyede 5000 GET isteği yollarsa Event-Loop (Olay Döngüsü) kilitlenir!
* Otonom Zırh: `express-rate-limit` paketiyle IP bazlı engeller konulacaktır! 
  
```typescript
import rateLimit from 'express-rate-limit';

const apiLimiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 dakika
    max: 100, // IP başına limit
    message: 'Too many requests from this IP, please try again after 15 minutes.'
});
app.use('/api/', apiLimiter); // Bütün Apilere Uygula!
```

### C. DTO Validasyon Mühürü (Joi / Zod)
Express projelerinde JSON olarak frontend'den Müşteri Verisi (Payload) gelir! Controller'ın ilk satırında bu veri doğrulanmadan Service katmanına atılamaz!
* Zod veya Joi paketleri kurularak kalkan kurgulanır. Gelen istek payload'u Middleware içerisinde parse edilir, hatalıysa 400 Bad Request fırlatılarak reddedilir!

---

## 🌍 4. Hata Kalkanı Merkezileştirmesi (Global Error Handling)

Node.JS ve Express ekosisteminin en büyük belası `UnhandledPromiseRejectionWarning` veya asenkron hataların sessizce çökmeleridir.

### Merkezileştirilmiş Try-Catch (The Async Handler Wrap)
Express'te asenkron bloklar otomatik çalışmaz. Otonom Zeka `catchAsync` sarmalayıcısı yazmak ZORUNDADIR. 

```typescript
// OTONOM BEYİN: Tüm Controller'ları Kapsayan Exception Wrapper
export const catchAsync = (fn: Function) => {
    return (req: Request, res: Response, next: NextFunction) => {
        fn(req, res, next).catch(next);
    };
};

// Bu şekilde Controller tertemiz olur! Zeka Hata Fırlatır, Express Yakalar!
export const getUser = catchAsync(async (req: Request, res: Response) => {
    const user = await userService.getUserById(req.params.id);
    if(!user) throw new AppError('User not found', 404); // Özel 404 Exception'ı
    res.status(200).json({ status: 'success', data: { user } });
});
```

Hatalar `app.use((err, req, res, next) => { ... })` GLOBAL EXPRESS MIDDLEWARE'i içerisinde toplanacak. Müşteriye temiz ve düzgün loglanmış bir JSON formatında 500 veya 400 dönülecektir! Yıkılmaz bir Express.js Zekası budur!
