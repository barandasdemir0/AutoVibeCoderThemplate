# 2️⃣ DotNet-WebAPI - Clean Architecture ve Bileşen Mimarisi Zirvesi (Architecture)

> **ZORUNLU MİMARİ NOTU:** Yapay zeka bu dosyada belirtilen Soğan (Onion) veya Clean Architecture (Temiz Mimari) prensiplerini sadece bir "tavsiye" olarak göremez, bunlar yasanın ta kendisidir! Bağımlılıkların dışarıdan içeriye doğru aktığı, Çekirdek (Domain) katmanının framework (ASP.NET) dahil hiçbir kütüphaneye muhtaç olmadığı katı bir otonom dizilim istiyoruz. Dış katmanlar çekirdeği bilir, çekirdek ise sadece kendini bilir. Prensibimiz *Dependency Inversion* ve *Separation of Concerns*!

---

## 🏗️ 1. Mimari Çemberler ve Bağımlılık Kuralları (Clean Architecture 101)

Projeyi .NET Solution (`*.sln`) olarak ayağa kaldırdığın saniye; birbirinin bağımlılık (Reference - DLL) kilitlerini aşağıdaki gibi ayarlayacaksın. Yanlış bağlama, dairesel bağımlılık (Circular Dependency) patlatır!

### ÇEKİRDEK (DOMAIN LAYER - SIFIR BAĞIMLILIK)
* **Kapsam:** Veritabanı Entity'leri, Enum'lar, Rich Domain Objeleri (Value Objects, Aggregate Roots), Domain Events, Kurumsal Kilit Kuralları (Domain Exceptions).
* **Bağımlılık (Project References):** HİÇBİR ŞEY. Sıfır!
* **Dış Paket (Nuget):** HİÇBİR ŞEY. EntityFramework Core dahil hiçbir paket yüklenemez.
* **Açıklama:** Veritabanı SQL serverdan MongoDB'ye geçse bile bu katmanda tek satır kod değişmez. Çünkü burası Saf C# Object Oriented kalbidir. Zeka bunu kesinlikle kavramalı, `User.cs` entitysi içine orm bağımlılığı olan `[Table]` veya `[Key]` gibi Entity Framework Data Annotations KESİNLİKLE YAZMAMALIDIR! FluentAPI'de konfigüre edilir.

### BEYİN (APPLICATION LAYER)
* **Kapsam:** Sistemin Kullanım Senaryoları (Use Cases). CQRS Command'leri, Query'leri, Bütün Business Logic (İş kuralları), Validation (Doğrulama), Davranış Boruları (MediatR Pipeline Behaviors), DTO sınıfları, Mapping Profilleri ve Dış Kapı Arayüzleri (Interfaces).
* **Bağımlılık:** YALNIZCA `Domain` katmanını referans alır.
* **Dış Paket:** `MediatR`, `MediatR.Extensions.Microsoft.DependencyInjection`, `FluentValidation.DependencyInjectionExtensions`, `AutoMapper.Extensions.Microsoft.DependencyInjection`.
* **Kilit Kural:** `Application` katmanı, ORM işlemlerini yapabilmek için kendi içinde `IApplicationDbContext` arayüzünü oluşturur. Asla asıl veritabanını (`DbContext`) new'lemez veya çağırmaz! `IEmailService` yazar ancak SMTP Mail servisini burada KULLANMAZ! Soyutu tanımlar, somutu dışarı atar.

### HAMALLAR (INFRASTRUCTURE & PERSISTENCE LAYER)
* **Kapsam:** Dış dünyanın gerçekliği. Veritabanı işlemleri (Entity Framework Core Implementation'ları, DB Context'in kendisi), Email gönderme servisleri (SMTP/SendGrid), Önbellekleme servisleri (Redis), Dosya Sistemleri (AWS S3, Blob Storage).
* **Bağımlılık:** `Application` katmanını referans alır. (Dolayısıyla Domain'e de otomatik erişir).
* **Dış Paket:** `Microsoft.EntityFrameworkCore.SqlServer`, `Microsoft.EntityFrameworkCore.Design`, `StackExchange.Redis`, `MailKit` vb. bütün üçüncü parti (3rd party) gerçek bağımlılıklar buradadır! Veritabanı Migrasyonları (Migrations) da burada durur.
* **Kilit Kural:** Bu katmanda Application katmanında açılmış olan 인터페이스(Interface)'lerin (*ŞABLONLARIN*) Asım Somut (Concrete) sınıfları yazılır. Örn: `ApplicationDbContext : DbContext, IApplicationDbContext` şeklinde uygulanır.

### VİZYON (PRESENTATION / WEB API LAYER)
* **Kapsam:** Gelen HTTP isteklerini alıp `Application` katmanına yönlendirmek. Swagger/OpenAPI gösterimi, Global Exceptions Middleware üzerinden hata mesajlarını temiz bir şekilde JSON (RFC7807 problem details) formatında dışarı yansıtmak. Controller'lar. JSON Serileştirme ayarları. 
* **Bağımlılık:** `Application` ve `Infrastructure` projelerini referans alır.
* **Dış Paket:** Sadece Swashbuckle, Serilog, AspNetCore bağımlılıkları. (Mümkün olan en az eklenti).
* **Kilit Kural:** Controller'da sadece Input alırız ve o Input'u (Command) alıp `await mediator.Send(command);` deriz. Başka bir numara YOKTUR! Spagettiyi öldüren son altın kılıç darbesidir.

---

## ⚡ 2. CQRS ve MediatR Kalıplarının Zorunlu İzolasyonu

Clean Architecture ile CQRS mükemmel ikilidir. Otonom ajan MediatR'ı kullanırken büyük nesne yaratma hatalarına (God Object Anti-Pattern) düşemez!

### Komutlar ve Yöneticileri (Commands & Handlers)
Komut (Command), sistemi değiştiren niyettir. Otonomi, `CreateProductCommand` sınıflarını bir C# 9+ `record` olarak (değişmez/immutable) kurgulayacaktır:

```csharp
// 1. Gelen Veri Temsilcisi (Immutable Record)
public sealed record CreateProductCommand(string Name, decimal Price, int CategoryId) : IRequest<Guid>;

// 2. İşlemi Yapan Beyin
internal sealed class CreateProductCommandHandler : IRequestHandler<CreateProductCommand, Guid>
{
    private readonly IApplicationDbContext _context; // DI Vasıtasıyla
    
    public CreateProductCommandHandler(IApplicationDbContext context) => _context = context;

    public async Task<Guid> Handle(CreateProductCommand request, CancellationToken cancellationToken)
    {
        var product = new Product {
            Name = request.Name,
            Price = request.Price, // Daha detaylı business rule'lar check edilebilir.
            CategoryId = request.CategoryId
        };
        _context.Products.Add(product);
        await _context.SaveChangesAsync(cancellationToken);
        return product.Id; // Gerçek Id dönülür.
    }
}
```

Bu kod parçacığındaki sadelik otonom AI'ın hedefidir. Ajan, Validation logic'lerini bu handler içerisine `if(string.IsNullOrEmpty(request.Name))` diye YAZAMAZ! Bu, CQRS prensibine küfürdür.

---

## 🛡️ 3. Pipeline Behaviors (Davranış Boruları) ve Cross-Cutting Concerns

Cross-Cutting Concerns dediğimiz (Doğrulama, Loglama, Önbellek, Yetki Denetimi) işler API handlerlarında yüz defa yazılıyorsa orada "Don't Repeat Yourself - DRY" ihlali vardır.

### A. Yıkılmaz Kalite Duvarı: FluentValidation Katılımı
Validation (Doğrulama) kuralları command class'ının yanında duran bir `AbstractValidator` ile yazılır. Peki bu Validator nasıl tetiklenir? Middleware ile mi? HAYIR! Otonom zeka bir **ValidationBehavior** yazar. Bu behavior, komut `Handler`'a gitmeden önce araya girer, Validator dosyalarını bulup doğrular, hata varsa `ValidationException` fırlatıp işlemi o noktada iade eder! Handler sadece Doğruysa Çalışır!

```csharp
// Application/Behaviors/ValidationBehavior.cs 
public class ValidationBehavior<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse> where TRequest : IRequest<TResponse>
{
    private readonly IEnumerable<IValidator<TRequest>> _validators;
    public ValidationBehavior(IEnumerable<IValidator<TRequest>> validators) => _validators = validators;

    public async Task<TResponse> Handle(TRequest request, RequestHandlerDelegate<TResponse> next, CancellationToken cancellationToken)
    {
        if (!_validators.Any()) return await next();
        
        var context = new ValidationContext<TRequest>(request);
        var errors = _validators
            .Select(v => v.Validate(context))
            .SelectMany(result => result.Errors)
            .Where(f => f != null)
            .ToList();

        if (errors.Any()) throw new ValidationException(errors); // Kendi Exception sınıfımız!
        
        return await next();
    }
}
```

### B. Otomatik Transaction Yönetimi
SQL operasyonlarında hata durumunda işlemin (Transaction) geri alınması (Rollback) gerekir. Yapay zeka yüzlerce Handle metodu içinde manuel transaction başlatmaz. Otonom yapıcı, MediatR pipeline'ı içerisine `TransactionBehavior` kodlayarak, Handler asenkron işlemi bittiğinde otomatik `Commit` atmayı, hata varsa otomatik `Rollback` atmayı mimari olarak bir kez yerleştirmelidir. Aksi halde veritabanı kilitlenir.

---

## 🔌 4. Dependency Injection Modüler Entegre Stratejisi (The Magic Binding)

`Program.cs` dosyasına bütün projelerdeki arayüzleri yüzlerce satır boyunca bağlayamazsın. Otonomi, katmanları izole tutmalıdır.

1. **Application Katmanı:** `public static IServiceCollection AddApplicationServices(this IServiceCollection services)` eklenti metodunda MediatR meclisleri, FluentValidation sınıfları (Assembly Scanner ile) ve AutoMapper bağlamaları yapılır.
2. **Infrastructure Katmanı:** `AddInfrastructureServices` içerisinde DbContext, RedisCacheService, JwtProvider bağımlılıkları eklenir. `Program.cs` bir satır kod ile bunu çağırır. Modülerlik şaheseridir!
3. **WebAPI Katmanı:** Kendi `AddWebAPIServices` kısmında Swagger dokümantasyon kilitleri, Global Exception Middleware kayıtları (`builder.Services.AddExceptionHandler<GlobalExceptionHandler>()`) uygulanır.

Eğer bu katmanlar ve ayrıştırmalar ZORUNLU TUTULMAZSA, üretilen kod Enterprise kelimesinin utancı olur. Otonom ajanın yazacağı mimaride en ufak bir SOLID ihlali (Örn: Open-Closed Prensibine uymayan kocaman if/else bloklu indirim servisleri) OLMAMALIDIR! 

Mimari dizilim Tanrı'dır. Mimarinin üzerine atılan kodlar fanidir. Asla fani özellikler (Features) uğruna kusursuz mimari duvarlarını delme!
