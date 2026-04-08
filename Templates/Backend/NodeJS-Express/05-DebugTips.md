# 5️⃣ NodeJS-Express - Enterprise Hata Ayıklama (Advanced Debugging & Memory Leaks)

> **SENIOR DEBUGGING BİLDİRGESİ:** 
> 
> Express.js projelerinde hataların %90'ı Single-Threaded (Tek İş parçalı) Event Loop (Olay Döngüsü) mimarisinin yanlış kullanılmasından ve Asenkron (Promise Leaks) hataların gizlice (Sessizce) çöpe atılmasından KAYNAKLANIR!
> 
> Otonom Zeka, Bütün Sistemin Çökmesini Beklemeyecektir!

---

## 🛑 1. Promise Leaks (Asenkron Kilitlenmeler ve Unhandled Rejections)

NodeJS Dünyasındaki EN tehlikeli problem tetiklenen ama `await` VEYA `.catch()` Mühürü ile YAKALANMAYAN veritabanı VE Dış API İSTEKLERIDIR!!

### 🎭 A. Sessizce Kilitlenen (Hanging) Istekler

**Senaryo (Anti-Pattern - YAPILMAYACAKLAR LİSTESİ):** 

Mimar Zeka asenkron bir Controller Yazar. Ve O hatayı the Catch etmeyi atlar.

```javascript
// ❌ ÖLÜMCÜL KULLANIM (ZAAFIYET İÇERİR! ASLA CEVAP VERMEZ)
app.get('/api/users/:id', async (req, res) => {
    // try catch olmadığı için Prisma Hata fırlatırsa:
    // Müşterinin tarayıcısı 2 dakika döner...
    // Ve "TIMEOUT" ile Çöker!!
    const user = await prisma.user.findUnique({
        where: { id: parseInt(req.params.id) }
    });
    res.json(user);
});
```

**Ne Olur? (Zafiyet Patlaması):** 

Eğer veritabanı kapalıysa veya Müşteri "abc" id'sini (Sayı yerine Harf) Gönderdiyse Prisma Exception fırlatır.
Ama Express default olarak Asenkron Hataları `yakalamaz!` (V4 sürümünde). Sistem Event-Loop Kilitlenir!

**Çözüm (The Enterprise Cure):** 

Mükemmel bir otonom Zeka, her Controller action'ını Zorunlu Wrapper Sarmalayıcıya Sokar!

```typescript
// ✅ MÜKEMMEL KULLANIM (The Architecture Savior)
export const getUser = catchAsync(async (req: Request, res: Response, next: NextFunction) => {
    const user = await userService.getById(parseInt(req.params.id));
    
    if(!user) {
        // Özel Hata the (Throw AppError!)
        return next(new AppError('Kullanıcı sistemde yoktuur', 404));
    }
    
    res.status(200).json({ status: 'success', data: { user } });
});
```

### 💀 B. Event-Loop Blockers (Node.js i Donduran Olasılıklar)

NodeJS tek İş parçacığında (Single thread) Milyonlarca Istek karsılar. Mimar Eger devasa bir `for` Döngüsü Içinde Asenkron (Await) cagirirsa Bütün Müşterilerin MİMARİSİNİ Dondurur!! 

```typescript
// ❌ SPAGETTİ MİMARİSİ
export const bulkInsert = async (req, res) => {
    // 10 bin kaydı FOR DÖNGÜSÜ İLE YÜKLEMEK!
    for (let i = 0; i < req.body.users.length; i++) {
        await prisma.user.create({ data: req.body.users[i] }); // UYGULAMA DİĞER KULLANICILAR İÇİN DURDU!
    }
    //...
}

// ✅ MÜKEMMEL PROMISE MİMARİSİ
export const bulkInsert = catchAsync(async (req, res) => {
    // Transaction ve Bulk operation (Prisma CreateMany Mühürü! )
    await prisma.user.createMany({
        data: req.body.users,
        skipDuplicates: true,
    });
    res.status(201).json({ status: 'success' });
});
```

---

## 🕳️ 2. Veri (Payload) Kirliliği ve NoSQL/SQL Injection Mimarileri

Müşterinin req.body Ile gönderdiği payload'da "Password" yerine `{"gt": ""} ` Gibi NoSQL VE SQL Sorgularını Asıl Veritabanına Yansıtmasına İzin Verme!

### ZOD VE Joi Middleware Validation

Bütün Data Ağları Joi veya ZOD ile Valide EDİLECEKTİR!!
Bu Doğrulama işlemi controller'dan önce Middlewareda YAPILACAKTIR!

---

## 👁️ 3. PM2 Clustering (Multi-Core Kullanımı!)

Mimar Express'i production (Üretim) ortamında `node server.js` Diye Ayağa Kaldıramaz!!!

Express Sadece 1 Çekirdek (Core) Kullanır. Müşteri 64 Çekirdekli 100 GB ram'i Olan Bir Cloud (AWS/EC2) kiralarsa NodeJS sadece 1'ini kullanır!

**Otonom Mühür: PM2 Clustering** 
Mimar `ecosystem.config.js` the Mühürünü YAZMAK ZORUNDADIR! 

```javascript
module.exports = {
  apps : [{
    name   : "enterprise-express-api",
    script : "./dist/server.js", // TypeScript BUILD DOSYASI !
    instances: "max",           // Tüm çekirdekleri YAY!!!
    exec_mode: "cluster",       // Yük paylasimi (Load Balancer ! )
    env_production: {
       NODE_ENV: "production"
    }
  }]
}
```

Böylece API asla the DÜŞMEZ VE Otonomi Mühürünü kusursuz şekilde uygular!!!
