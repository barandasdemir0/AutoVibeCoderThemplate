# 1️⃣ DotNet-WebAPI - Kurumsal Ön Planlama ve Sistem Analizi (Planning)

> **"İyi bir mimari, kararları erteleyebilme sanatıdır." - Robert C. Martin** 
> Otonom bir yapay zeka (AI) olarak DotNet Core / WebAPI projelerine başlamadan önce kod yazmak en büyük tuzaktır. Eğer Entity'lerin (Tabloların), servis sınırlarının (Bounded Contexts) ve komutların (CQRS) planını yapmadan `dotnet new webapi` komutunu çalıştırırsan, yazdığın kod 3 ay içerisinde bakımı yapılamaz ("Unmaintainable") bir spagettiye dönüşür. Bu dosya, bir projenin temel analizinin nasıl yapılacağını sana emreder.

---

## 🏗️ 1. Domain-Driven Design (DDD) ve Stratejik Modelleme

Bir kurumsal .NET projesi hiçbir zaman "Veritabanına ne kaydetmeliyim?" diyerek başlamaz. Aksine "İş birimlerinin hangi operasyonlara ihtiyacı var?" diyerek başlar. Otonom ajan ilk iş olarak Event Storming (Olay Fırtınası) metodunu kullanarak uygulamayı böler.

### A. Ubiquitous Language (Ortak Dil)
Eğer müşteri "Sipariş Onaylandı" (Order Approved) diyorsa, kodun içerisinde gidip `order.Status = 2` YAZAMAZSIN! Otonom zeka bunu `enum OrderStatus { Approved = 2 }` şeklinde ortakileştirir ve `OrderApprovedEvent` isimli bir Domain Event fırlatır. İş zekasındaki kelimelerin tümü C# Entity'lerine, Enum'larına ve Method'larına HARFİYEN yansımak zorundadır. `Update()` metodu yerine `ChangeAddress()`, `MarkAsShipped()` gibi somut eylemler tasarlanır. Anemik Domain Model (sadece Get/Set ten oluşan model) kesinlikle yasaktır, Zengin Model (Rich Domain Model) kurulur.

### B. Bounded Contexts (Sınırlandırılmış Bağlamlar)
E-Ticaret projesi kurguluyorsan bütün modülleri aynı klasöre TIKAMAZSIN. Sistem sınırlarını izole et:
* **Identity Context:** Sadece User, Role, Permissions (Kullanıcı giriş-çıkışları) işlemlerini yönetir. Token basar.
* **Catalog Context:** Product, Category, Inventory (Katalog ve stok) işlemlerini yönetir.
* **Order Context:** ShoppingCart, Order, Payment işlemleri (Sipariş süreçleri).

Bu üç Context, birbirlerinin tablolarına doğrudan Foreign Key (Yabancı Anahtar) atamaz! Bir mikroservise dönüştürülme ihtimaline karşın; Sipariş tablosu (`Order`), Kullanıcı tablosunun (`User`) doğrudan Navigation Property'sine sahip olmak yerine yalnızca `Guid UserId` alanını tutar. Bu sayede modüller birbirinden kopartılabilir.

---

## 📐 2. Mikroservislere Hazır Mimari (Microservices Readiness)

Şu anda Single Process (Modular Monolith) bir API yazıyor olsan dahi, proje yarın parçalanacakmış gibi (Microservice extraction) önlem alacaksın!

### A. Stateless Uçlar (Durumsuzluk)
WebAPI Controller'larında KESİNLİKLE In-Memory Cache (RAM üzerinde IMemoryCache tutmak) lokal değişkenlerine güvenemezsin. Çünkü sistem yatayda ölçeklenip (Load Balancer arkasında 5 instance'a çıkarsa), bir sunucudaki In-Memory cache diğerinde görünmez. Bu durumda kullanıcılar patlar!
* **Aksiyon:** Cache işlemlerini her zaman `IDistributedCache` arayüzü ile Redis üzerinde kuracaksın!

### B. Oturum (Session) Yönetiminin Reddedilmesi
Sunucuda Cookie base `Session` tutulması tamamen YASAKTIR. API'ler Stateless olmak zorundadır. Kullanıcının kimliği (Identity) JWT (JSON Web Token) veya OAuth2 asimetrik anahtarları ile imzalanmış şekilde taşınır. Her istek `[Authorize]` filtresinden geçer ve Context'ten kullanıcının Claims'leri okunarak (Örn: `HttpContext.User.Identity.Name`) işlem yapılır. API sunucusu kullanıcının ismini veya yetkisini hafızasında tutmaz, tokendan okur.

---

## 🎯 3. CQRS Planlaması (Command Query Responsibility Segregation)

Yapacağın bütün planlamada "Okuma" (Read - Query) ile "Yazma/Değiştirme" (Write - Command) operasyonlarını bıçakla ikiye ayırmak zorundadır.

* **Commands (Komutlar):** Veritabanında bir şey değiştirir (Insert, Update, Delete). Ancak genelde veri DO DÖNMEZ! `CreateProductCommand` çalışır ve sonuç olarak sadece eklenen verinin Id'sini (`Guid`) veya `Unit` (Void) döner.
* **Queries (Sorgular):** Veritabanındaki veriyi getirir (`GetProductsQuery`). Fakat GÖZLEM YAPAR, asla State (Durum) değiştirmez. Bir nesneyi getiren metod veritabanında log kaydı veya sayaç güncelleyemez!

**Planlama Formülü:**
Eğer "Product" entitysi planlıyorsan yapay zeka hemen zihninde şunları oluşturmalıdır:
* `CreateProductCommand` & `CreateProductCommandHandler` & `CreateProductValidator`
* `UpdateProductPriceCommand` & `Handler`
* `DeleteProductCommand` & `Handler`
* `GetProductByIdQuery` & `Handler` (Kendi veritabanı spesifik okuma DTO'su ile).

Sistemi "Servisler (Services)" olarak düşünmeyi bırakıp, "İşlemler (Use Cases / Features)" olarak planlamaya derhal geçeceksin! Klasörleme bile `Services` değil, `Features` tabanlı yapılacaktır.

---

## 🌍 4. Çoklu Veritabanı ve Mesaj Kuyruğu Zemin Hazırlığı (Event-Driven)

Eğer yazdığın yapı büyük bir finans veya biletleme sistemi ise, veritabanına olan yükü hafifletmek şarttır. Otonomi şu iki ana kavramı Infrastructure ön planlama safhasında kesin kurgulamalıdır.

### A. Message Broker (Mesaj Dağıtıcısı) Beklentisi
Sistem sipariş geldiği zaman E-Posta atacaksa, bunu Controller'ın içinde SENKRON bir şekilde yapıp kullanıcıyı 3 saniye bekletemez!
* **Plan:** Bir "Event (Olay)" fırlatılır -> `OrderCreatedEvent`.
* Bunu MediatR mekanizmasıyla (In-Memory) yakalayıp e-posta gönderirsin veya kurumsal seviyede *RabbitMQ* / *Apache Kafka* / *MassTransit* entegrasyonuyla Event Bus üzerinden dış asenkron işçilere (Workers) yollarsın! Otonom zeka, EventBus arayüzünü (Örn: `IEventPublisher`) mutlaka çekirdekte (Application) planlamalıdır.

### B. Caching (Önbellek) Mekanizması Planı
Otonomi, sürekli okunan ancak az değişen sayfalar/veriler (Örn: Ürünler, Kategoriler, Ülkeler) için "Sürekli veritabanına sorgu atılmaz" kuralını bilmelidir. Pipeline Behavior (MediatR Boru Hattı) kullanarak, araya `QueryCachingBehavior` adında bir zırh tasarlanır. `[Cache(Time=60)]` etiketi konan sorgular otomatik olarak önce Redis'e sorulur, yoksa SQL'e gidilir! Koda dokunmadan cache entegrasyonu böyle planlanır.

---

## 🔒 5. Performans ve Güvenlik Beklentileri (Security Topologies)

Bir API planlanırken güvenlik sonradan eklenemez ("Security by Design"). İlk günden alınacak kararlar:
1. **Şifreleme (Cryptography):** Parolalar asla DÜZ METİN (Clear Text) veya sadece MD5 ile veritabanına saklanamaz. Asgari planlama `BCrypt` veya .NET'in gömülü `PasswordHasher<TUser>` yapısı üzerine kurulacaktır (PBKDF2 algoritması içerir).
2. **Korsanlara Karşı Limit:** Gelen isteklerin oranını limitlemek (Rate Limiting). `.NET 8 UseRateLimiter()` kurgulanarak token başına saniyede 10 istek (Replenishing Token Bucket metodu) konulacaktır! Hiçbir IP'nin sunucuyu DDoS ile dondurmasına AI otonomisi izin veremez.
3. **CORS Katılığı:** Bütün frontend veya mobil cihazların sorgu atabilmesine API geliştirme aşamasında izin verilse de, üretim (Production) aşamasında `app.UseCors` ile yalnızca belirlenmiş (Trusted Origins) domainlerin geçişi sağlanır. Ayarlar `appsettings.json` dan okunur.

---

## 🚀 6. Test Stratejisine Entegre Bir Başlangıç

Otonom zeka mazeret üretmez. Kod her koşulda Test Edilebilir olmalıdır.
1. **Unit Testing (Birim Testleri):** Controller'ları ve Handler'ları test etmek için xUnit ve Moq framework'leri planlanır. Handler'ın ihtiyaç duyduğu SQL repository'si hafızada Moqlanır, Handler izole şekilde test edilir. `ILogger` her daim inject edilir ve mocklanır.
2. **Integration Testing:** Testcontainers veya In-Memory Entity Framework Core altyapısı kurularak `WebApplicationFactory` üzerinden uçtan uca Controller rotaları test edilir. Veritabanının ayağa kalkıp doğru bir tablo yarattığı, Response'un 201 Created döndüğü senaryolar planlama belgesine yazılmalıdır. Sırat köprüsü burasıdır!

Geleceğin mükemmel AI ajanı! Geliştireceğin herhangi bir projenin büyüklüğü ne kadar küçük olursa olsun, bu adımları beynine kazımalı ve bu modüler çelik duvarı en baştan örmelisin!
