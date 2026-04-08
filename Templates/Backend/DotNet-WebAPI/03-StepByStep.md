# 3️⃣ DotNet-WebAPI - Endüstriyel Başlangıç Adımları (Step-By-Step Setup)

> **OTONOM UYARI:** Kurumsal bir projeye "Merhaba Dünya (Hello World)" kafasıyla başlanmaz! Bir C# Web API projesinde temelleri eksik atarsan, proje 10.000 satır koda ulaştığında içinden çıkılamaz hata yığınları (Tech Debt) yaratır. Yapay zeka projeyi otonom olarak terminalden (CLI) kaldırdığı andan itibaren aşağıdaki 16 adımlık üretim bandını MÜKEMMEL sırayla takip etmekle yükümlüdür.

---

## 🚀 FAZ 1: Çelik Solution ve Katmanların Kurulması (Initialization)

Otonom ajan, projeyi kurarken Visual Studio arayüzüne (GUI) ihtiyaç duymaz. Sadece `dotnet CLI` komutlarıyla mükemmel iskeleti yaratır.

### Adım 1: Klasörleme ve Çözüm (Solution) Dosyası
Sistem önce boş bir çözüm kabuğu yaratır. İçine 4 ana projeyi yerleştirir. Asla testleri unutmaz.
```bash
# Ana klasörü yarat ve içine gir
mkdir Enterprise.App && cd Enterprise.App

# Solution'ı yarat
dotnet new sln -n Enterprise.Solution

# Projeleri Yarat (Çekirdek, Beyin, Hamallar, WebAPI)
dotnet new classlib -o src/Enterprise.Domain
dotnet new classlib -o src/Enterprise.Application
dotnet new classlib -o src/Enterprise.Infrastructure
dotnet new webapi -o src/Enterprise.WebAPI

# Projeleri Solution'a Bağla
dotnet sln add src/Enterprise.Domain/Enterprise.Domain.csproj
dotnet sln add src/Enterprise.Application/Enterprise.Application.csproj
dotnet sln add src/Enterprise.Infrastructure/Enterprise.Infrastructure.csproj
dotnet sln add src/Enterprise.WebAPI/Enterprise.WebAPI.csproj
```

### Adım 2: Bağımlılık Ağını Bağlamak (Project References)
Otonom ajan hangi katmanın hangisini referans alacağını (Dependency Inversion yasası) hatasız bağlamalıdır:
```bash
# Application -> Domain
dotnet add src/Enterprise.Application/Enterprise.Application.csproj reference src/Enterprise.Domain/Enterprise.Domain.csproj

# Infrastructure -> Application
dotnet add src/Enterprise.Infrastructure/Enterprise.Infrastructure.csproj reference src/Enterprise.Application/Enterprise.Application.csproj

# WebAPI -> Application & Infrastructure
dotnet add src/Enterprise.WebAPI/Enterprise.WebAPI.csproj reference src/Enterprise.Application/Enterprise.Application.csproj
dotnet add src/Enterprise.WebAPI/Enterprise.WebAPI.csproj reference src/Enterprise.Infrastructure/Enterprise.Infrastructure.csproj
```

---

## 🛠️ FAZ 2: Kütüphanelerin (Nuget Packages) Çakılması

Yapay Zeka paketleri rastgele katmanlara yükleyemez. Her katman KENDİ GÖREVİNE AİT paketleri alır (Separation of Concerns).

### Adım 3: Application Katmanı Güçlendirmesi
Burada veritabanı paketi YASAKTIR. Sadece CQRS ve Validator paketleri yüklenir.
```bash
cd src/Enterprise.Application
dotnet add package MediatR
dotnet add package FluentValidation.DependencyInjectionExtensions
dotnet add package AutoMapper.Extensions.Microsoft.DependencyInjection
```

### Adım 4: Infrastructure Katmanı Güçlendirmesi
Gerçek hayatın adaptörleri buradadır! DB, JWT gibi teknolojiler.
```bash
cd ../Enterprise.Infrastructure
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet add package Microsoft.EntityFrameworkCore.Tools
dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer # Güvenlik için
dotnet add package BCrypt.Net-Next # Şifre hashleme için!
```

---

## 🧠 FAZ 3: Mimarinin Ana Objelerinin Kodlanması (The Blueprint)

CLI (Terminal) işlemleri bitince, kodlama stratejik bir sırayla başlar. Çatıdan zemin kat inşa edilmez. Zemin (Domain) önce yazılır!

### Adım 5: BaseEntity (Temel Varlık) Oluşturma
Bütün veritabanı tablolarının kalıtım (inherit) alacağı, audit (denetim) propertylerinin bulunduğu klasörü `Enterprise.Domain/Common/BaseEntity.cs` içerisine yerleştir. `Id`, `CreatedAt`, `CreatedBy`, `UpdatedAt` gibi alanları ZORUNLU KIL. Bu sayede kim hangi kaydı ne zaman değiştirdi otonom olarak veritabanına işlenir.

### Adım 6: ApplicationDbContext Arayüzü (Interface) Çizimi
`Application` katmanında `Interfaces/IApplicationDbContext.cs` yarat.
```csharp
public interface IApplicationDbContext
{
    DbSet<User> Users { get; }
    DbSet<Product> Products { get; }
    Task<int> SaveChangesAsync(CancellationToken cancellationToken);
}
```
**ZORUNLU KURAL:** Controller veya CQRS Handler'ları asıl SQL contexti BİLEMEZ! Bu interface'i kullanır!

### Adım 7: ApplicationDbContext Somutlaştırılması (Implementation)
`Infrastructure` katmanında `Contexts/ApplicationDbContext.cs` yaratılır, arayüzden türetilir ve SaveChangesAsync intercept edilir.
```csharp
public class ApplicationDbContext : DbContext, IApplicationDbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }
    // ... DbSetler ...

    public override async Task<int> SaveChangesAsync(CancellationToken cancellationToken = new CancellationToken())
    {
        foreach (var entry in ChangeTracker.Entries<BaseEntity>())
        {
            switch (entry.State)
            {
                case EntityState.Added:
                    entry.Entity.CreatedAt = DateTime.UtcNow;
                    break;
                case EntityState.Modified:
                    entry.Entity.UpdatedAt = DateTime.UtcNow;
                    break;
            }
        }
        return await base.SaveChangesAsync(cancellationToken);
    }
}
```

---

## 🔒 FAZ 4: Güvenlik, Exception ve Davranış Katmanları (Protective Armors)

Sistem artık çalışabilir ama hala savunmasızdır! Kötü amaçlı bir istek bütün API'yi çökertebilir. Zırh kaplamaları ZORUNLUDUR!

### Adım 8: FluentValidation Pipeline (Davranış Borusu) Kurulumu
Application katmanında CQRS borusuna validation kontrolcüsü (`ValidationBehavior`) enjekte edilir. İstek, MediatR içerisine girdiği an bu borudan geçer, kurallara takılırsa exception (`ValidationException`) fırlatır! Otonomi bunu Application'da kurgulamakla hükümlüdür.

### Adım 9: Global Exception Handling (Düzenli Hata Çıktısı) Middleware'i
WebAPI tarafında hata yönetimi, geleneksel spagetti `try-catch` leriyle yapılmaz! 
`.NET 8 Uzantısı Olan IExceptionHandler` arayüzü WebAPI de kodlanarak sisteme verilir.
Sistem patlarsa, Müşteriye "User not found" şeklinde özel RFC 7807 problem jsonu basar. Console'a ise "Fetal DB Error stack trace..." detayını gömer (Logging). Sistem sızdırmaz hale gelir.

### Adım 10: JWT (JSON Web Token) Security Enjeksiyonu
Sisteme şifresiz giriş yapılamaması için Authentication mekanizmaları `Program.cs` te ayağa kaldırılır. `builder.Services.AddAuthentication(JwtBearerDefaults...)` komutu işlenmelidir. Ayrıca Identity (Rol bazlı erişim) işlemleri Policy veya Claims tabanlı işlenecektir.

---

## 🚀 FAZ 5: Rotaların Yayını ve Entegrasyon (Deployment Readiness)

### Adım 11: Program.cs Üzerindeki Sihirli Bağlantılar
Otonom zeka `Program.cs` i şişirmez. WebAPI projesi `appsettings.json` dan SQL şifresini okur ve aşağıda izole edilmiş Extension methodlarını çağırır:
```csharp
builder.Services.AddApplicationServices();
builder.Services.AddInfrastructureServices(builder.Configuration);
// Custom Middlewares Usage
app.UseExceptionHandler(); // NET 8 Format Error Handler
app.UseAuthentication();
app.UseAuthorization();
```
*(Hayati NOT: `UseAuthentication` ASLA `UseAuthorization`'dan sonra gelemez! Yoksa HTTP 401 UnAuthorized hatasına mahkum kalırsınız!)*

### Adım 12: CI/CD Ayarlamaları İçin Ayağa Kalkma ve Test Etme
Otonom sistem kodu yazdıktan sonra bitmiş sayılmaz. Sistemin ayağa kalkması gereklidir:
```bash
# Infrastructure klasöründe Terminalden Veritabanı Migration Fırlat
dotnet ef migrations add InitialCreate --project src/Enterprise.Infrastructure --startup-project src/Enterprise.WebAPI

# SQL'e update çak!
dotnet ef database update --project src/Enterprise.Infrastructure --startup-project src/Enterprise.WebAPI

# Ve Sonunda Projeyi Uçur...
dotnet run --project src/Enterprise.WebAPI
```

Bu adımları sırasıyla kusursuz şekilde uygulayan bir AI ajanı, Senior Developer standartlarında hiçbir sızıntısı olmayan (Secure-by-design) devasa bir e-ticaret altyapısını kod formuna dönüştürmüş sayılır. Üretilen sistem artık Event-Sourcing ve Mikroservislere hazırdır. Zafiyet (Vulnerability) YOKTUR!
