# 3️⃣ DotNet-MVC - Endüstriyel Başlangıç Adımları (Step-By-Step Setup)

> **OTONOM KOMUT UYARISI:** 
> 
> Bir Otonom Zeka, bir ASP.NET MVC projesi için kurulum komutlarını çalıştırdığı an, "File -> New Project -> MVC" tuşuna basmış bir çaylak gibi `Controllers` ve `Models` klasörlerini aynı dosyanın içine tıkıştırıp (Monolith) devam edemez! 
> 
> Güçlü bir N-Tier (Çok Katmanlı) altyapı komutunu (CLI) hatasız olarak ayağa kaldıracaksın! Yaratım bandı tam 15 adımdan oluşur.

---

## 🚀 FAZ 1: Katmanlı Solution İskeletinin Çıkarılması (CLI İşlemleri)

Otonomi "Mükemmel MVC" uygulamasını GUI olmadan şu ardışık terminal komutlarıyla yaratır. Dört farklı katmanın ve bir UI yapısının haritası Terminalde can bulur.

### Adım 1: Klasörler, Çözüm Dosyası ve MVC Temelinin Yaratımı

Zeka baştan terminal ortamına geçer. Proje yapısı için gerekli kabuğu Solution (Sln) mimarisi olarak konumlandırır.

```bash
# Ana klasörü yarat ve gir
mkdir Enterprise.MvcApp
cd Enterprise.MvcApp

# Solution dosyasını kur
dotnet new sln -n Enterprise.MvcSolution

# Bağlı projeleri (Katmanları) C# classlib olarak Yarat!
dotnet new classlib -o src/Enterprise.Domain
dotnet new classlib -o src/Enterprise.DataAccess
dotnet new classlib -o src/Enterprise.Business

# Sunum ve Arayüz olan MVC Projesini Katıla!
dotnet new mvc -o src/Enterprise.WebUI

# Tüm projeleri Solution (sln) dosyasına bağla
dotnet sln add src/Enterprise.Domain/Enterprise.Domain.csproj
dotnet sln add src/Enterprise.DataAccess/Enterprise.DataAccess.csproj
dotnet sln add src/Enterprise.Business/Enterprise.Business.csproj
dotnet sln add src/Enterprise.WebUI/Enterprise.WebUI.csproj
```

### Adım 2: Katmanlar Arası (Reference) Entegrasyonların Gerçekleşmesi

MVC projelerinde bağımlılık yönü Dışarıdan ---> İçeriye (Core / Domain)'e doğru akmalıdır!

```bash
# DataAccess katmanı Domain'i tanımalıdır
dotnet add src/Enterprise.DataAccess/Enterprise.DataAccess.csproj reference src/Enterprise.Domain/Enterprise.Domain.csproj

# Business (Service) katmanı Da Domain ve DataAccess'i tanımalıdır!
dotnet add src/Enterprise.Business/Enterprise.Business.csproj reference src/Enterprise.Domain/Enterprise.Domain.csproj
dotnet add src/Enterprise.Business/Enterprise.Business.csproj reference src/Enterprise.DataAccess/Enterprise.DataAccess.csproj

# MVC Arayüzü İSE Domain, DataAccess ve Business katmanlarını BİLMEK ZORUNDADIR.
dotnet add src/Enterprise.WebUI/Enterprise.WebUI.csproj reference src/Enterprise.Business/Enterprise.Business.csproj
dotnet add src/Enterprise.WebUI/Enterprise.WebUI.csproj reference src/Enterprise.DataAccess/Enterprise.DataAccess.csproj
dotnet add src/Enterprise.WebUI/Enterprise.WebUI.csproj reference src/Enterprise.Domain/Enterprise.Domain.csproj
```

---

## 📦 FAZ 2: Gerekli Paketlerin Zırh Olarak Eklenmesi (Nuget Packages)

Otonom zeka, spagetti engeli için paketleri tüm solution'a YAYMAZ. Kime ne lazımsa o katmana eklenir.

### Adım 3: DataAccess Katmanına EntityFramework Core Enjeksiyonu

Sadece veritabanıyla (SQL Server) muhatap olan Infrastructure / DataAccess katmanı ORM eklentilerini alabilir. Domain alamaz!

```bash
# Veritabanı işlemleri için paketleri DataAccess'e ekle
cd src/Enterprise.DataAccess
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet add package Microsoft.EntityFrameworkCore.Relational
dotnet add package Microsoft.EntityFrameworkCore.Tools
```

### Adım 4: Business (İş Kuralları) Katmanına Zeka Enjeksiyonları

Validasyonlar ve AutoMapper, Entity'i ViewModel'a kırptığı yer olduğu için bu paketi zorunlu ekleyeceksin.

```bash
# Servisler ve İş zekası paketleri
cd ../Enterprise.Business
dotnet add package FluentValidation.DependencyInjectionExtensions
dotnet add package AutoMapper.Extensions.Microsoft.DependencyInjection
```

---

## 🏗️ FAZ 3: Otonom İnşa ve Kodlama Katmanları (Implementation)

Terminale veda edip C# koduna geçiyoruz.

### Adım 5: Entity'lerin Tasarımı ve BaseEntity Kuralı

`Enterprise.Domain` katmanında `Entities/BaseEntity.cs` yaratılır.

Temel alanlar:
- `Id`
- `CreatedDate`
- `IsActive`

Tüm veritabanı tablolarının kalıtım alacağı audit propertyleri KESİN kurgulanacaktır.

### Adım 6: Context (DB) Bağlantısının Oluşturulması

`Enterprise.DataAccess` içerisinde `Concrete/Contexts/AppDbContext.cs` yaratılır. 
`DbContext`'ten kalıtılarak, DbSet'ler tanımlanır. İçerisinde veri tabanına özgü kurallar override `OnModelCreating` ile `FluentAPI` ayarları olarak kaydedilir! 
Asla Entity sınıflarına `[MaxLength]` DataAnnotation'ları dökülüp Domain kirletilmez.

### Adım 7: Generic Repository Katı Uyarlaması

DataAccess içine `Abstract/IRepository<T>.cs` yaratılır (Bütün CRUD'ları Barındıran İmza). 

Sonra `Concrete/Repositories/GenericRepository<T>.cs` asım sınıfında SQL ile asıl işlemler (LINQ) tamamlanır. Böylece 50 farklı tablo için 50 tane Insert kodu yazılmaz (DRY prensibi).

### Adım 8: Servis Arayüzleri ve Business Manager Yazımı

`Business` katmanına geçilerek `IProductService` interface'i yazılır. 

Hemen altına işlemi gerçekleştirecek olan `ProductManager` implementasyonu kurgulanır. 
`ProductManager` yapıcı metodunda (Constructor) DataAccess'ten `IProductRepository`'i DI (Dependency Injection) ile alır!

---

## 🎨 FAZ 4: Mükemmel Sunum (WebUI - Presentation) & Razor Etkileşimi

### Adım 9: ViewModel Zırhının Oluşturulması

MVC tarafında işler başlar! View için WebUI içerisinde devasa `Models` veya `ViewModels/Product` klasörü yaratılır. 

```csharp
// İçinde Password veya gizli sistem property'leri olmayan model!
public class ProductCreateViewModel 
{
    [Required(ErrorMessage = "Ürün Adı ZORUNLUDUR!")] 
    public string Name { get; set; }
    
    [Range(0, 1000000, ErrorMessage = "Geçersiz fiyat!")]
    public decimal Price { get; set; }
}
```

### Adım 10: AutoMapper ve Servis Bloklarının Kaydedilmesi 

`WebUI` katmanındaki `Program.cs` dosyası okyanuslaştırılmaz. DI kısımları temiz kodlanır:

```csharp
// Veritabanı Entity Framework Ayağa Kalkışı
builder.Services.AddDbContext<AppDbContext>(options => 
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Repositories ve Servislerin WebUI Tarafından Tanınması (Injection)
builder.Services.AddScoped<IProductService, ProductManager>();
builder.Services.AddScoped<IProductRepository, EfProductRepository>(); 

// Mapper'lar taranıyor
builder.Services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());
```

### Adım 11: AntiForgery Zırhlı Controller'lar Tesis Edilir

Otonomi Form kalkanlarını asla açık bırakamaz:

```csharp
public class ProductController : Controller 
{
    private readonly IProductService _productService; 
    
    public ProductController(IProductService productService) 
    {
        _productService = productService;
    }

    [HttpGet]
    public IActionResult Create() 
    {
        return View(new ProductCreateViewModel()); 
    }

    [HttpPost]
    [ValidateAntiForgeryToken] 
    public async Task<IActionResult> Create(ProductCreateViewModel model) 
    {
        if(!ModelState.IsValid) 
            return View(model); 
        
        await _productService.AddProductAsync(model);
        
        TempData["SuccessMessage"] = "Kayıt Başarılı!"; 
        return RedirectToAction(nameof(Index)); 
    }
}
```

### Adım 12: Views, Layouts ve ViewComponents 

Otonom Zeka `Views/Shared/_Layout.cshtml` ana çerçevesini muazzam oluşturur. 

RenderBody() noktalarını doğru ayarlar. "PartialViews" yerine Sidebar, Cart gibi kısımları **`ViewComponents`** isimli yeni bir .NET 8 Mimarisi içinde tasarlar!

---

## ⚡ FAZ 5: C# Mimarisi Yürütülüyor (Run Database Migrations)

Otonomi en son veritabanı yansıması (Migration) için Terminale geri döner:

```bash
# DataAccess katmanında (Db Context'in olduğu yer) göm, WebUI'den ayaklandır:
dotnet ef migrations add Initial_Create --project src/Enterprise.DataAccess --startup-project src/Enterprise.WebUI

# Veritabanına şema aktar:
dotnet ef database update --project src/Enterprise.DataAccess --startup-project src/Enterprise.WebUI

# Son Start Komutu:
dotnet run --project src/Enterprise.WebUI
```

**Bravo Usta Otonomi!** 
Sıfırdan; Veritabanına sızdırılamaz, CSRF engeli taşıyan, iş akışları servis katmanında soyutlanmış, Data Access'i ayrılmış kusursuz N-Tier MVC yapısını ayağa kaldırdın!
