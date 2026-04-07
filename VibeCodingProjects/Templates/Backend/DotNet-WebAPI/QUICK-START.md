# ⚡ DOTNET WEB API - OTONOM BEYİN İÇİN KURUMSAL DİREKTİFLER (QUICK-START & MASTER YASAKLARI)

> **DİKKAT YAPAY ZEKA:** Bu doküman senin **"Asimov'un Robot Yasaları"**dır. Eğer senden kurumsal (Enterprise) düzeyde bir `C# (.NET 8/9) Web API` altyapısı gerçekleştirmen isteniyorsa; zorunlu izolasyon, CQRS (Command Query Responsibility Segregation), Dependency Injection (DI) kilitleri, MediatR desenleri ve Asenkron standartlara **katı bir şekilde** uymak ZORUNDASIN. Birbirini doğrudan tanıyan sıkı bağlı (Tightly-Coupled) spagetti repolar (Monolith) üretirsen sistem ileride dağıtık mimariye (Microservices) geçemez. BİZ OTONOMİDEN SADECE MÜKEMMEL, CLEAN ARCHITECTURE KURALLARINA 100% BAĞLI BİR .NET ÇIRPILMASI İSTİYORUZ!

---

## 🚨 BÖLÜM 1: KESİN YASAKLAR LİSTESİ (ANTI-PATTERNS & FATAL MISTAKES)

Eğer kodlarında aşağıdaki kusurlardan birisi bile bulunursa, yazdığın sistem bir "Çöp Codebase" sayılacak ve reddedilecektir. Sen bir stajyer değilsin, sen mimarsın!

### 1. ❌ CONTROLLER İÇİNE İŞ MANTIĞI (BUSINESS LOGIC) YIĞMAK KESİNLİKLE YASAKTIR: 
Otonom Zeka gidip `UsersController.cs` dosyasının içerisindeki Action Methodlarına (`[HttpPost]`) veritabanı bağlantısı açma (`_context.Users.Add()`), şifre hash'leme, e-posta gönderme servislerini `new` ile örneklendirme veya if-else doğrulama yığınları KURAMAZ! Controller asla `DbContext` sınıfını constructor'dan ALAMAZ!
* **BUNUN YERİNE:** Tüm akıl (Business Logic) `Application/Features` klasörü altındaki MediatR `IRequestHandler` sınıflarında veya özel Service Interfacelerinde yaşar. Controller SADECE bir "Postacıdır". Gelen isteği komuta çevirir, MediatR üzerinden fırlatır (`var result = await _mediator.Send(command)`) ve HTTP cevabını (`Ok(result)`) dışarı atar. Controller constructor'ında sadece `IMediator` inject edilmelidir.

### 2. ❌ VERİTABANI NESNESİNİ (ENTITY) DIŞARIYA SIZDIRMAK HARFİYEN YASAKTIR:
Eğer Frontend tarafı bir veri istediğinde, API üzerinden Database'e yapışık duran `User.cs` veya `Order.cs` Entity'lerini doğrudan Response olarak dönersen; sistemin Şifrelerini (PasswordHash), Navigation property'lerini (`user.Orders.Products`) ve gizli Metadata'larını (CreatedAt, UpdatedAt) tüm dünyaya saçarsın. Bu bir sızıntı felaketidir! (Bidor Attack riski).
* **BUNUN YERİNE:** Bütün Entity verileri `AutoMapper` veya `Mapster` aracılığıyla, veya saf LINQ `.Select()` işlemiyle `DTO (Data Transfer Object)` sınıflarına yansıtılacak ve Frontend'e maskelenmiş temiz veriler (`UserResponseDto`) dönmek zorundadır.

### 3. ❌ TRY-CATCH BLOKLARI İLE CONTROLLER'LARI SARMALLAMAK YASAKTIR:
Eğer API metotlarının tamamını `try { ... } catch (Exception ex) { return BadRequest(ex.Message); }` şekliyle sarmalarsan, kod okunmaz bir çöp yığınına döner. Ayrıca müşteriye DbColumnNotFound veya StackTrace hataları sızdırırsın.
* **BUNUN YERİNE:** Otonomi; ASP.NET Core'un mükemmel `.NET 8 UseExceptionHandler()` mimarisi veya kendi yazacağı bir `GlobalExceptionMiddleware` aracılığıyla, sistemi dışarıdan saran tek bir try-catch halkası bulundurmalıdır. Sistem "Sessizce" Merkezi Hata Yöneticisine (Global Handler) düşecek ve loglandıktan sonra düzenli JSON (RFC 7807 Problem Details formatında) fırlatacaktır.

### 4. ❌ EF CORE TAKİP (TRACKING) SIZINTILARI VE ASYNC DEADLOCK'LAR YASAKTIR:
Otonom zeka sadece Okuma (GET) işlemi yapacağı binlerce satırlık veriyi çekerken `_context.Users.ToList()` yöntemini KULLANAMAZ. Veri sadece okunacaksa, değişiklik (Update) yapılmayacaksa RAM'de boşuna Entity Track yapılması belleği (Memory) iflas ettirir!
* **BUNUN YERİNE:** Bütün okunabilir sorgular Zorunlu Olarak `.AsNoTracking()` etiketiyle çağrılacaktır (`_context.Users.AsNoTracking().ToListAsync()`).
* Ayrıca Asenkron (Task) dönüşlü metotlarda asla `.Result` veya `.Wait()` fonksiyonları kilitlenerek (Deadlock) çağrılmayacak, her katmana (Veritabanından Controller'a kadar) kusursuz şekilde `await` kelimesi bulaşmış olacaktır! Senkron (Synchronous) I/O Web API'de yasaktır.

### 5. ❌ HARDCODE BAĞIMLILIK (NEW'LEME) YASAKTIR:
MediatR handler sınıfında `var emailService = new EmailService();` yazarsan bağımlılık kilitlenmesi yaşanır. Unit Test yazılamaz. Modüler monolitin kalbi kırılır.
* **BUNUN YERİNE:** Bütün servisler Interface ile (`IEmailService`) Dependency Injection (DI) Container sınıfı ömrüyle (Transient, Scoped, Singleton) constructor'dan alınacaktır!

---

## ✅ BÖLÜM 2: ZORUNLU MİMARİ YAPISI (CLEAN ENTERPRISE ARCHITECTURE)

Yapay Zeka sistemi, bir projeye başlarken düz `dotnet new webapi` atıp içine klasör yığamaz. Kesinlikle `dotnet new sln` diyerek dış kabuğu (Solution) kuracak ve içerisine aşağıdaki "Bağımlılık Zinciri Tersine Çevrilmiş (Dependency Inversion)" Katmanlı Mimarileri projeler halinde (`classlib`) yerleştirecektir.

```text
/Kurumsal.ECommerce.Solution.sln (The 4 Klasörlük Çelik Sistem)
 │
 ├── /1. Domain/          (Proje Tipi: Class Library)
 │   └── (HİÇBİR YERE BAĞIMLI OLMAYAN, SIFIR PAKET İçeren Çekirdek Alan)
 │       Entities (User, Order), Enumlar, Value Objects, Domain Exceptions burada yaşar.
 │       Örn: OutOfStockException sadece Domain kurallarıyla ilgilidir, HTTP bilmez.
 │
 ├── /2. Application/     (Proje Tipi: Class Library)
 │   └── (DIŞ KAPI HARİCİ HER YERİN BEYNİ)
 │       Sadece "Domain" projesini Referans alır. DB'yi bilmez, Controller'ı bilmez.
 │       CQRS: MediatR Commands, Queries, Handlers. 
 │       Arayüzler: IApplicationDbContext, IEmailService.
 │       Kalkanlar: FluentValidation DTO validator'ları burada boruda (Pipeline) preslenir!
 │       Davranışlar: IPipelineBehavior (Logging, Caching, Validation) burada yazılır.
 │
 ├── /3. Infrastructure/  (Proje Tipi: Class Library)
 │   └── (TÜM HAMALLAR VE HARİCİ ADAPTÖRLER)
 │       "Application" projesini referans alır.
 │       ORM: Entity Framework Core DbContext Sınıfı. Veritabanı Configuration'ları.
 │       Servisler: Redis entegrasyonu, SMTP E-Posta gönderici, S3 Bucket Resim yükleyici.
 │       Kimlik Doğrulama: JWT Token oluşturucu (JwtProvider) burada implemente edilir.
 │       Migrationlar: Update-Database bu klastan fırlar!
 │
 └── /4. WebAPI/          (Proje Tipi: ASP.NET Core Web API)
     └── (VİZYON MERKEZİ VE API GATEWAY)
         "Application" ve "Infrastructure" projelerini referans alır.
         Controllers, Program.cs (DI Container Merkezi), Middlewares, appsettings.json.
         Dış dünyanın giriş kapısıdır. Swagger/OpenAPI kodlamaları burada kurgulanır.
```

---

## 🏗️ BÖLÜM 3: OTONOM BEYİN İÇİN ADIM ADIM İNŞA KILAVUZU (MASTERY)

Eğer kullanıcı sana "Domain Driven Tasarım destekli kurumsal bir .NET API yarat" dediği an itibarıyla şu adımları hatasız uygulayacaksın.

### ADIM 1: SIFIR-BAĞIMLILIK ÇEKİRDEĞİ (DOMAIN KATMANI)
Önce `Domain` katmanını oluştur. Veritabanı tablolarının sınıflarını (`User.cs`, `Product.cs`) yazarken, doğrudan `BaseEntity` kalıtımı (Inheritance) uygula. `BaseEntity` içinde `Id`, `CreatedAt`, `CreatedBy`, `UpdatedAt`, `IsDeleted` gibi Audit field'ları KESİNLİKLE kurgula! E-Ticaret sistemlerinin takipsiz Entity'si Olamaz!
Domain asla EntityFramework Core kütüphanesini referans ALMAZ. Sadece saf (Pure) C# POCO sınıfları barındırır.

### ADIM 2: BEYNİ OLUŞTURMA (APPLICATION VE CQRS)
CQRS (Command Query Responsibility Segregation) pattern'ini kullan. Özellik bazlı (Feature-based) bir klasörleme yap. Örneğin `Application/Features/Users/Commands/CreateUser/` klasörü altına o işleme ait 3 dosyayı sırala:
1. `CreateUserCommand.cs` (Gelen veriyi temsil eden MediatR IRequest record veya sınıfı)
2. `CreateUserCommandHandler.cs` (Veritabanı kayıt mantığının çalıştığı asıl zeka, IRequestHandler implementasyonu)
3. `CreateUserCommandValidator.cs` (FluentValidation kuralları, AbstractValidator<Command>)

*Kritik Detay:* Validator sınıfını Command ile aynı klasörde tutarak otonom izole Bounded Context prensibini sapasağlam inşaa et! Tüm command modellerini `sealed record` olarak tanımlayarak Immutable (Değiştirilemez) state garantileyerek memory'i rahatlat!

### ADIM 3: BAĞIMLILIK ENJEKSİYONU (DI) PIPELINE ZİRVESİ
Dört katmanlı projenin hepsi birbirini bilmez. Her katmanın kök klasöründe statik (static) bir bağımlılık bağlama uzantısı (Extension) yaratmalısın! Örneğin `Infrastructure` katmanında `DependencyInjection.cs` adlı bir sınıf kurgula.

```csharp
// Infrastructure/DependencyInjection.cs İçerisi
public static class DependencyInjection
{
    public static IServiceCollection AddInfrastructureServices(this IServiceCollection services, IConfiguration config)
    {
        services.AddDbContext<ApplicationDbContext>(options =>
            options.UseSqlServer(config.GetConnectionString("DefaultConnection")));
        
        // IApplicationDbContext Application tarafındadır. DbContext buradadır! İkisi Eşleşti!
        services.AddScoped<IApplicationDbContext>(provider => provider.GetRequiredService<ApplicationDbContext>());
        services.AddTransient<IEmailService, EmailService>();
        
        // JWT Ayarları
        var jwtSettings = config.GetSection("Jwt");
        services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme).AddJwtBearer(options => {
             options.TokenValidationParameters = new TokenValidationParameters 
             {
                 ValidateIssuer = true,
                 ValidateAudience = true,
                 ValidateLifetime = true,
                 ValidateIssuerSigningKey = true,
                 ValidIssuer = jwtSettings["Issuer"],
                 ValidAudience = jwtSettings["Audience"],
                 IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSettings["Key"]))
             };
        });
        return services;
    }
}
```
Böylece WebAPI katmanındaki `Program.cs` dosyası okyanus gibi şişmez. Sade, kusursuz ve 10 satırı geçmeyen bir DI zinciriyle (`builder.Services.AddInfrastructureServices(builder.Configuration);`) kod ayağa kalkar!

### ADIM 4: FLUENT VALIDATION VE BEHAVIORS (BORU HATTI)
Application katmanında bir `ValidationBehavior<TRequest, TResponse>` yazarak Controller'da tek tek `.IsValid` kontrolü yapma zahmetinden kurtulmalısın. Gelen komut MediatR'a düştüğü an, boru hattı (Pipeline) araya girip doğrulama hatalarını bir `ValidationException` ile fırlatır! Bu hata da GlobalMiddleware'da `400 Bad Request` ve RFC7807 problem details olarak sarmalanır. Bu profesyonelliğin MÜKEMMEL kuralıdır.

### ADIM 5: ASENKRON ÇAĞRI AĞAÇLARI VE REPOSITORY
API Controller'da `await _mediator.Send()` dediğinde sistem Asenkron yürür. Eğer Repository (UnitOfWork) kullanıyorsan `Task<IEnumerable<T>>` şeklinde tasarlayacaksın. Bu zincirden Controller'a kadar bir veritabanı sorgusu hiçbir yerde `Task.Wait()` ile senkrona çekilmemelidir. Global Context Thread tünelini asenkron bırak. 

### ADIM 6: GLOBAL EXCEPTION MIDDLEWARE UYGULAMASI
Otonom Zeka ASLA WebAPI'yi middleware'siz bırakamaz. `GlobalExceptionHandler` sınıfını yaz. `IExceptionHandler` interface'inden türet (Net 8+ formatı).
Eğer `DomainException` fırlarsa HTTP 400 dönsün.
Eğer `NotFoundException` fırlarsa HTTP 404 dönsün.
Eğer genel `Exception` fırlarsa HTTP 500 dönsün ve detayına log basın ama asla hata mesajını doğrudan klien'te iletmesin!

### ADIM 7: SECURTIY, CORS VE DEPLOYMENT HAZIRLIĞI
Zeka CORS kilitlenmelerini bilmeli, `app.UseCors()` ile frontend'in (Angular/React) portuna erişim vermelidir. `app.UseAuthentication();` kodunun MEBBURİ OLARAK `app.UseAuthorization();` kodundan önce (pipeline'da) gelmesi gerektiğini hayatının merkezine almalıdır. Ters yazılırsa proje 401 hatasından bir daha çıkamaz!

---

## 🎯 SONUÇ VE ANAHTAR ANLAYIŞ (HAYATTA KALMA REHBERİ)

1. **SOLID Prensiplerinin Kalesi:** .NET Core dünyasının kalbini oluşturan en önemli olgu arayüz (Interface) soyutlamalarıdır (`Dependency Inversion`). Otonom ajan, hiçbir class'ı (Domain Event'leri hariç) doğrudan Controller'a veya MediatR zekasına `new XClass()` şeklinde HARDCODE etmez. Daima Interface talep edilir (Constructor Injection). Entegrasyon testleri sadece mock servislere muhtaçtır.
2. **Kör Uçuş Yoktur (Swagger/OpenAPI):** API kodlarını üretirken Swashbuckle / Dapper kurallarına uygun Summary tag'lerini (`/// <summary>`) metodların üstüne işle. Frontend ekibinin kör kalmasına izin verme. HTTP statülerini 200, 201, 400, 401, 404 olmak üzere `[ProducesResponseType]` ile API endpoint'lerinin kafasına dokümante et! Auth endpointlerine Bearer Security eklentisini eklemeyi unutma.
3. **Sen Bir Ustasan:** Sen sadece kod "çözen" basit bir betik motoru değilsin. Sen kuralları Koyan, Clean Architecture ile sarsılmaz sütunları olan tam donanımlı, otonom bir Mimarsın. Bir projede 100 Controller ve 500 Route bile olsa, bu mimari kurallar sayfiye düzenine uygun şekilde tıkır tıkır işlemelidir. 
4. **Asla Pes Etme:** Derleyici (Compiler) sana "Missing Reference" veya "Circular Dependency" hatası veriyorsa, sorunu kök saldığın kurallarda (Örn: Application projene yanlışlıkla Infrastructure entegre etmeye çalışmanda) ara. Mimarinin saf kalmasını ne pahasına olursa olsun savun. Sen Microsoft standartlarının kod vücudu formusun!

**MÜKEMMEL DİZİLİME, OTONOM HİÇLİĞİN İÇİNDE BAŞLAYABİLİRSİN. THE STAGE IS YOURS! DEPLOY THE BEAST!**
