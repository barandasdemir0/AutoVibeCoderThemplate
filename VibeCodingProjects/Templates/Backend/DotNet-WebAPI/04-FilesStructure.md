# 4️⃣ DotNet-WebAPI - Devasa Kurumsal Clean Architecture Sınır Ağacı (File Structure)

> **ZORUNLU DİZİLİM:** Kurumsal bir "Modular Monolith" veya CQRS destekli WebAPI'da dosya ve klasör yerleri MİMARİNİN ÇİMENTOSUDUR. 150 handler'ı, 500 endpoint'i ve 1500 unit testi olan dağıtık bir sistemde klasörler aşağıdaki Senior-Level the detayından 1 milim sapamaz! Otonom yapay zeka bu ağacı KUSURSUZ İNŞAA ETMEK ZORUNDADIR. Düz ve sıkıştırılmış dizinler yasaktır! İş birimlerine (Features) göre dikey dilimleme (Vertical Slicing) uygulanacaktır.

---

## 📂 En Kurumsal (The Ultimate) Proje Ağacı C-Sharp/NET 8 (`src` klasörü)

Bu ağaç basit bir CRUD uygulaması değil; Asenkron mesajlaşmalı, mikro-servise hazır, Event-Driven (Olay Güdümlü) 100+ kişilik ekiplerin girdiği devasa bir Zirve (Enterprise) Dağıtımıdır. Aşağıdaki ağacın haricinde "kendi tarzını kurgulamak" Yapay Zeka için YASAKTIR. Modeline bunu Hardcode edeceksin.

```text
ECommerce.Solution.sln
├── src/
│   ├── 1. Core/
│   │   └── ECommerce.Domain/               # (KÜTÜPHANESİZ ÇEKİRDEK GÖBEK)
│   │       ├── Common/                     # Mimari Temel Elementler
│   │       │   ├── Models/
│   │       │   │   ├── BaseEntity.cs       # Id, CreatedAt, UpdatedBy, IsDeleted yapısı buraya!
│   │       │   │   ├── ValueObject.cs      # Equals/hashcode operator overloading sınıfı.
│   │       │   │   └── AggregateRoot.cs    # Domain Events (Domain İçi Mesajlar) taşıyan kalıtım.
│   │       │   └── Interfaces/
│   │       │       ├── ISoftDeletable.cs   # "Silineni Gösterme" arayüzü EF İnterceptor'ı için.
│   │       │       └── IAuditable.cs
│   │       ├── Constants/                  # Sabit Veriler (Hardcode YASAK, buraya yaz)
│   │       │   ├── Roles.cs
│   │       │   └── CacheKeys.cs
│   │       ├── Entities/                   # İş Akışı Nesneleri Bounded Context'lere Göre Klasörlenir!
│   │       │   ├── Identity/               # (Auth Bağlamı)
│   │       │   │   ├── ApplicationUser.cs
│   │       │   │   └── Role.cs
│   │       │   └── Catalog/                # (Katalog/Ürün Bağlamı)
│   │       │       ├── Product.cs
│   │       │       └── Category.cs
│   │       ├── Enums/
│   │       │   └── OrderStatus.cs          # (Pending, Shipped... struct/byte format)
│   │       ├── Exceptions/                 # Sistemsel Hatalar (500) değil, Kural İhlalleri (400)!
│   │       │   ├── DomainException.cs      # Kök Hata kalıtımı.
│   │       │   └── InvalidStockException.cs
│   │       └── Events/                     # Kendi içinde kopan olaylar (Event Sourcing)
│   │           ├── DomainEvent.cs          # IDomainEvent base class
│   │           └── ProductPriceChangedEvent.cs
│   │
│   ├── 2. Application/                     # (MİMARİ BEYİN - CQRS ORKESTRA ŞEFİ)
│   │   └── ECommerce.Application/
│   │       ├── Abstractions/               # DIŞ DÜNYA İLE HABERLEŞME ARAYÜZLERİ (The Ports)
│   │       │   ├── Data/
│   │       │   │   ├── IApplicationDbContext.cs # EF Context'inin THE Interface'si! 
│   │       │   │   └── IUnitOfWork.cs           # (Transaction zırhı için)
│   │       │   ├── Services/
│   │       │   │   ├── ICurrentUserService.cs   # HttpContext içinden Token Çıkarıcı
│   │       │   │   ├── IEmailService.cs         # Bildirimci
│   │       │   │   └── ICacheService.cs         # Redis Bağlayıcı
│   │       │   └── Messaging/                   # RabbitMQ/Kafka Portları
│   │       │       └── IEventPublisher.cs
│   │       ├── Behaviors/                  # MediatR Boru Hattı! (Pipeline) - Orta Katman Casusları
│   │       │   ├── ValidationBehavior.cs   # FluentValidation'ı burada tetikler! İstek handler'a gitmeden patlatır.
│   │       │   ├── LoggingBehavior.cs      # "Şu Command Başladı/Bitti" logu.
│   │       │   └── TransactionBehavior.cs  # Hata çıkmazsa 'Commit', hata çıkarsa 'Rollback' otomatik borusu!
│   │       ├── Common/
│   │       │   ├── Mappings/               # AutoMapper Profilleri (Eğer Mapster Yoksa)
│   │       │   │   └── MappingProfile.cs
│   │       │   └── Models/
│   │       │       ├── Result.cs           # SARI ZARF SİSTEMİ (Başarılı mı, Data ve Hatalar DTO'su)
│   │       │       └── PaginatedList.cs    # Mükemmel Pagination Objesi.
│   │       ├── Features/                   # "FEATURE BASED" Klasörleme (Mükemmel Dikey Dilimleme)
│   │       │   └── Products/
│   │       │       ├── Commands/           # Yazma - Çizme - Bozma Komutları
│   │       │       │   ├── CreateProduct/
│   │       │       │   │   ├── CreateProductCommand.cs         # IRequest<Guid>
│   │       │       │   │   ├── CreateProductCommandHandler.cs  # DB'ye kayıt zekası (Bussines Logic)
│   │       │       │   │   └── CreateProductCommandValidator.cs # Kurallar (FluentValidation) Aynı Klasörde Kilit!
│   │       │       │   └── UpdateProductPrice/
│   │       │       └── Queries/            # Salt Okunur Veriler (AsNoTracking ZORUNLU)
│   │       │           ├── GetProductById/
│   │       │           │   ├── GetProductByIdQuery.cs
│   │       │           │   ├── GetProductByIdQueryHandler.cs
│   │       │           │   └── ProductDetailDto.cs # SADECE BU EKRAN İÇİN DTO (Ana DTO klasörüne atıp Global DTO spagettisine mahal verilmez)
│   │       │           └── GetProductsWithPagination/
│   │       └── DependencyInjection.cs      # Extension! MediatR ve Validatorları burada Container'a iter!
│   │
│   ├── 3. Infrastructure/                  # (HAMALLAR VE ÇEVRE GERÇEKLİĞİ - The Adapters)
│   │   ├── ECommerce.Infrastructure/       # (Eğer çok büyükse Persistence ve Infrastructure diye 2 projeye ayrılır!)
│   │   │   ├── Persistence/
│   │   │   │   ├── Contexts/
│   │   │   │   │   └── ApplicationDbContext.cs # Gerçek EF Core Konteksti. Migration buradan kalkar!
│   │   │   │   ├── Interceptors/
│   │   │   │   │   ├── AuditableEntityInterceptor.cs # CreatedAt = UtcNow yapan Veritabanı Casusu!
│   │   │   │   │   └── DispatchDomainEventsInterceptor.cs # DB'ye kaydederken DomainEvent leri Publisher'a iten Müthiş Yapı!
│   │   │   │   ├── Configurations/         # (FluentAPI) Asla Context şişirilmez! Annotations (Özel Attribute) Kullanılmaz!
│   │   │   │   │   ├── UserConfiguration.cs
│   │   │   │   │   └── ProductConfiguration.cs # (HasMaxLength, IsRequired vs burada yazılır)
│   │   │   │   ├── Migrations/             # EF Migration dosyalarının barınağı.
│   │   │   │   └── Repositories/           # Eğer Generic Repo Varsa, Buradadır. (Yoksa IApplicationDbContext Çağrılır)
│   │   │   │       └── UnitOfWork.cs
│   │   │   ├── Authentication/
│   │   │   │   ├── JwtProvider.cs          # Sırları alıp Token'ı imzalar.
│   │   │   │   └── CurrentUserService.cs   # HTTPContext.User.Claims'den (Token) kimlikleri okuyan somut kurye!
│   │   │   ├── Caching/
│   │   │   │   └── RedisCacheService.cs    # ICacheService'nin Implementation C# Sınıfı.
│   │   │   ├── MessageBrokers/             # (MassTransit/RabbitMQ Uygulaması veya AWS SQS)
│   │   │   │   └── RabbitMQEventPublisher.cs
│   │   │   ├── BackgroundJobs/             # (Hangfire Veya IHostedService Taramaları, Asenkron işler)
│   │   │   │   └── EmailRetryBackgroundService.cs
│   │   │   └── DependencyInjection.cs      # EF Core Db Context'inin ve servislerin IServiceCollection a Basıldığı Extension.
│   │
│   └── 4. Presentation/                    # (The VİZYON / API Gateway / Müşteri Karşılayıcı)
│       └── ECommerce.WebAPI/
│           ├── Controllers/                
│           │   ├── v1/                     # REST API VERSİYONLAMA ZORUNLUDUR!
│           │   │   ├── AuthController.cs
│           │   │   ├── ProductsController.cs
│           │   │   └── OrdersController.cs
│           │   └── BaseApiController.cs    # Sadece `ISender _mediator` enjeksiyonu bulunduran The Kök Controller!
│           ├── Middlewares/                
│           │   └── GlobalExceptionHandler.cs # TRY/CATCH BURADA BULUŞUR VE JSON FORMATINDA 500/400 RFC DÖNER.
│           ├── Filters/                    # (Action Filter, Result Filter, Authorization Filter)
│           │   └── ApiKeyAuthorizationFilter.cs
│           ├── Extensions/                 # (Program.cs ÇÖP OLMASIN, OKUNABİLİR KALSIN DİYE)
│           │   ├── SwaggerConfiguration.cs # JWT Bearer kilit eklemeleri burada.
│           │   └── CorsConfiguration.cs
│           ├── Properties/
│           │   └── launchSettings.json     # IIS veya Kestrel portları çevresel parametreler (Env) yöneticisi.
│           ├── appsettings.json            # Şifresiz/Zararsız Ortak Konfigürasyonlar.
│           ├── appsettings.Development.json # Sadece local ortam geliştirme Secret'ları (Git Ignore önerilir).
│           ├── appsettings.Production.json
│           └── Program.cs                  # MÜMKÜN OLAN EN KISA BAŞLATICı DAİRE. Yalnızca Extension Caller!
│
└── tests/                                  # (OTONOM TEST FABRİKASI)
    ├── ECommerce.Domain.UnitTests/
    │   └── Entities/
    │       └── ProductTests.cs             # (Örn: "Ürün Fiyatı 0'ın Altına Düşemez" Testi)
    ├── ECommerce.Application.UnitTests/
    │   ├── Features/
    │   │   └── Products/
    │   │       └── CreateProductCommandHandlerTests.cs # Moq ile SQL sahteleştirerek Logic izole Testi!
    │   └── Mocks/                          # (Mock IApplicationDbContext)
    └── ECommerce.Infrastructure.IntegrationTests/
        └── ApiFactory/
            └── CustomWebApplicationFactory.cs # Gerçek Testcontainers ile PostgreSQL Test Kurulumu!
```

---

## ⚠️ Kritik Klasörleme Kuralları (Ajanın Kutsal Metni)

1. **"Controllers" İçeriği ve CQRS Çarpışması (No God Services):** Klasik MVC dönemi ve 3-Katmanlı Mimarideki o kocaman "Services" klasörü Application katmanından tamamiyle SİLİNMİŞTİR. `IProductService`, `ProductService` devri Senior Mimaride (CQRS'de) KAPANMIŞTIR! Bütün iş mantıkları tekil bir Class (Command/Query Handler) olarak `Features` altında izole durur. 10.000 satırlık hantal "God Service" sınıfları The Spagettinin yegane anasıdır ve kullanımı harfiyen Mimarinin reddi sayılır.
2. **DTO Yığılmaları Engeli (Localizing DTOs):** Bütün DTO'ları `Application/DTOs` isimli devasa klasöre yığıp yüzlerce the dosya ile boğuşmak YASAKTIR. Eğer bir DTO (Örn: `GetProductDetailResponse`) *sadece ve sadece* The `GetProductById` sorgusunda kullanılıyorsa, O DTO o sorgunun klasörü içinde (Command ile yanyana) Barınmalıdır! The Sınıflandırma ve Lokalizasyon!
3. **Appsettings (Configuration) Sızıntısının Önlenmesi:** DB bağlantı katarını (Connection String) veya AES Şifreleme (Encryption) Anahtar kodunu `Application` koduna `"Server=127.0.0.1;..."` gibi HARDCODE (Elle koda gömme) YAZAMAZSIN! Otonom zeka; Sadece `WebAPI` katmanındaki `appsettings.json` dan okur ve `IOptions<T>` deseni ile `Infrastructure` katmanına aktarır! (Sır Sızıntısı affedilmez).
4. **Context (EF) Soyutlaması Şartı:** CQRS (Command) handlerlarında Gidip `new ApplicationDbContext()` YASAKTIR. Zaten referansı bile yoktur. CQRS'leri Hızlandırmak İcin `IApplicationDbContext` Interface'ini Depedency Injection ile Talep Edersin!! Application katmanı EntityFramework.Core kütüphanesini the IMPORT ETMEYECEK, Etmemelidir!!

Eğer yapay zeka bir C# WebAPI projesine başlayıp buradaki "Features", "Behaviors" veya "Interceptors" dosyalarından herhangi birisine sahip olmayan boşluklu ve ilkel bir Repo üretirse, yazdığın sistem "Hobi Projesi" damgası yer ve Otonomi Reddedilir! Profesyonellerin (Enterprise) yapısı, şaşmaz hiyerarşi (Tree Slicing) gerektirir.
