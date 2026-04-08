# 2️⃣ DotNet-MVC - Architect Katman C# Dosyası (Clean & N-Tier Architecture)

> **ZORUNLU MİMARİ NOTU:** 
> Yapay zeka bu dosyada belirtilen servis yönelimli katmanlar (Service-Oriented / N-Tier Architecture) prensiplerini sadece bir "öneri" olarak GEÇİŞTİREMEZ, bu prensipler yasadır! 
> 
> ASP.NET MVC modelinin, WebAPI denemesinden farklı olduğunu kavramalısın. "Dış katman çekirdeği bilir, çekirdek hiçbir yeri bilmez" mantığını buradaki Dependency Injection kilitleriyle pekiştireceksin. Controller'lar sadece kurye işlevi görür!

---

## 🏗️ 1. Geleneksel Gelişmiş "N-Tier" Katman Tasarımı

MVC için devasa kurumsal boyutta, birbirlerini referanslayan 4 temel ".NET Class Library" projesi ve en son Presentation katmanı kurgulanır. Aşağıdaki referans kilitleri kesinlikle bozulamaz (Circular Dependency'ye yol açar).

### ÇEKİRDEK (DOMAIN LAYER - BAĞIMSIZ ENTITY/ENUM KALBİ)

* **Kapsam:** 
  Veritabanı tablosuna dönüşecek Asıl Nesneler (Entities: Örn `User`, `Blog`, `Order`), Temel soyutlamalar (`BaseEntity`, `IAuditableEntity`), Sabitler (Constants) ve sistem kuralları içeren Enumlar.

* **Bağımlılık (Project References):** 
  SIFIR! (Hiçbir projeyi referans ALMAZ).

* **Kalıtım Kuralı (Base Entity):** 
  Her nesne, id ve datetime izleyici özelliklerini kapsayan bir `BaseEntity`den kalıtım almak ZORUNDADIR. 

```csharp
// Domain/Common/BaseEntity.cs
public abstract class BaseEntity 
{
    public int Id { get; set; }
    
    // Otomatik Doldurulan Audit Propertyleri
    public DateTime CreatedAt { get; set; }
    public string CreatedBy { get; set; } // Oluşturan User'ın Id'si
    
    public DateTime? UpdatedAt { get; set; }
    public string UpdatedBy { get; set; }
    
    public bool IsDeleted { get; set; } // ZORUNLU E-TİCARET KURALI (Soft Delete)
}
```

```csharp
// Domain/Entities/Category.cs
public class Category : BaseEntity 
{
    public string CategoryName { get; set; }
    public string Slug { get; set; } // MVC Routing için çok önemli (SEO)
    
    // Navigation Properties
    public ICollection<Product> Products { get; set; }
}
```

### HAMALLAR BİRLİĞİ (DATA ACCESS LAYER / INFRASTRUCTURE)

* **Kapsam:** 
  Gerçek veri tabanı (Context) sınıfı (`ApplicationDbContext`). Entity Framework Core yapılandırma (Configuration/FluentAPI) sınıfları. Repository Interfacelerinin somut uyarlamaları (`ProductRepository : IProductRepository`). Veritabanı Migration'ları buraya yerleşir!

* **Bağımlılık:** 
  SADECE `Domain` katmanını referans alır. `Service/Business` katmanını BİLEMEZ!

* **Açıklama:** 
  Controller'ın bu katmanı direkt görmesi spagettiye yol açar. Gerekli DI bağlamaları IoC container veya Extension sınıfları aracılığıyla UI'dan sağlanır, fakat UI (MVC) klasörleri içindeki kod ile (Örn: Controller içinde `using DataAccess;`) kullanılmaz!

### İŞ ZEKASI / BEYİN KORTEKSİ (BUSINESS / SERVICE LAYER)

* **Kapsam:** 
  Sipariş mi kargolanacak? Veriler mi doğrulanacak? İndirim mi hesaplanacak? Hepsi BURADA yapılır. Arayüzler (`IProductService`) ve Onların Gerçekleşmeleri (`ProductManager`). FluentValidation klasörlenmiş sınıfları. Mapper sınıfları (AutoMapper).

* **Bağımlılık:** 
  `Domain` ve `DataAccess` (Infrastructure) projelerini referans alır. 

* **Zorunlu İzolasyon (DTO Kuralı):** 
  Bu servis katmanı veritabanından `Product` objesini Domain modülden bulur, ama dışarıdaki Controller'a (MVC UI tarafına) `ProductViewModel` VEYA `ProductDto` döner! Asla Controller, ham Entity'e elini süremez.

### SUNUM / ARAYÜZ (PRESENTATION - WEB MVC LAYER)

* **Kapsam:** 
  Controller nesneleri, `.cshtml` Razor Views dosyaları, TagHelpers, Modellerarası dönüşüm yapılandırmaları, `wwwroot` CSS/JS statik dosyaları, `appsettings.json` ve DI kilit dosyası `Program.cs`.

* **Bağımlılık:** 
  Diğer üç katmanı (Domain, DataAccess, Business) referans almak zorundadır (.csproj içerisine the referans olarak eklenir).

* **Kilit Kural:** 
  Controller içinde `ApplicationDbContext` newlenmesi veya enjeksiyonu doğrudan yasaktır! Eğer the C# Otonomu, `public HomeController(ApplicationDbContext context)` yazarsa Mimarinin tecavüzüdür! Puan sıfırlanır!

---

## ⚡ 2. Tasarım Kalıpları ve İzolasyon Zorunlulukları

Bir Otonom Mimari, düz prosedürel C# kodu yerine Kurumsal Tasarım Kalıpları (Design Patterns) uygulayarak yapıyı ölçeklenebilir ve değiştirilebilir (Maintainable) hale getirir.

### A. Generic Repository & Unit Of Work (Katı Kullanım veya Modern Terk)

Eğer çok kompleks JOIN işlemleri yapılmıyorsa ve MVC projesi tipik bir Veri (CRUD) akışı sunuyorsa:

1. `IGenericRepository<T>` arayüzü kurulur. Bu repository `Insert`, `Update`, `Delete`, ve lambda ifadeleriyle filtrelenebilir `GetList(Expression<Func<T, bool>> filter = null)` yetki metodları taşır.

2. Ancak `SaveChanges()` komutu repository'ler içerisinden fırlatılmaz! Mimarinin ortasına bir `IUnitOfWork` oturtturacaksın. 

3. Servis katmanı, birden fazla repo ile işlem yapar ve en son `unitOfWork.Commit()` diyerek asıl transaction save olayını tek nefeste kapatır. (Eksik tablo insertinden kaynaklı corrupt/bozuk datayı engeller).

```csharp
// DataAccess/Abstract/IGenericRepository.cs
public interface IGenericRepository<T> where T : class
{
    Task<IEnumerable<T>> GetAllAsync();
    Task<T> GetByIdAsync(int id);
    Task AddAsync(T entity);
    void Update(T entity); // EF Core'da Update asenkron değildir!
    void Remove(T entity);
}

// DataAccess/Abstract/IUnitOfWork.cs
public interface IUnitOfWork : IDisposable
{
    // Bütün repolar tek merkezde toplanır!
    IProductRepository Products { get; }
    ICategoryRepository Categories { get; }
    
    Task<int> CommitAsync(); // Veritabanına asıl KAYDEDİŞ burasıdır!
}
```

### B. Mükemmel Dependency Injection (Bağımlılık Enjeksiyonu ve IoC)

`Program.cs` dosyası spagetti gibi uzayıp gitmemesi için Service (Business) katmanında ve `DataAccess` katmanında özel C# extension (uzantı) metotlar yazılır!

```csharp
// BusinessLayer/Extensions/DependencyInjection.cs
public static class BusinessServiceRegistration 
{
    public static IServiceCollection AddBusinessServices(this IServiceCollection services) 
    {
        // Servis Katmanı Kayıtları İşleme
        services.AddScoped<IProductService, ProductManager>();
        services.AddScoped<ICategoryService, CategoryManager>();
        
        // AutoMapper Enjeksiyonu (Profil Sınıfları Taranır)
        services.AddAutoMapper(Assembly.GetExecutingAssembly());
        
        // Fluent Validatorleri Reflection ile Bul ve Container'e At
        services.AddValidatorsFromAssembly(Assembly.GetExecutingAssembly());
        
        return services;
    }
}
```

```csharp
// WebUI/Program.cs (TEMİZLİĞE BAKIN)
var builder = WebApplication.CreateBuilder(args);

// Data Katmanı Fişi Takılıyor
builder.Services.AddDataAccessServices(builder.Configuration);

// İş Zekası (Business) Katmanı Fişi Takılıyor
builder.Services.AddBusinessServices();

builder.Services.AddControllersWithViews();
// ...
```
WebUI (`Program.cs`) temiz ve modüler bir mimari kalesi olarak kalır.

---

## 🛡️ 3. Razor Views ve Controller Bağlantı Güvenliği (Data Passing)

Web API'da JSON döner arayüze karışmazdın. Şimdi hem sunucu hem de arayüz kodunu (Full Stack) Otonomi kodluyor! Veriyi güvenli ve performanslı taşıman ZORUNLUDUR.

### A. ViewModel Felsefesi ve Form Kalkanı

Bir "Kullanıcı Profili Güncelle" formunda `User` entity'sine ait "IsAdmin", "CreatedAt" gibi kritik özellikleri (propertyleri) Controller'a Model Bind edip MVC'in kanca atmasına (`Overposting / Mass Assignment` saldırısına) asla göz yumamazsın!

Sadece o HTML ekrana özgü `UserProfileUpdateViewModel` yaratırsın (`FullName`, `PhoneNumber`, `BirthDate` içerir). MVC tarafında View'den bu ViewModel'i alırsın, Server katmanında asıl Veritabanı (Entity) nesnesine Mapper aracılığı ile çekersin.

```csharp
// UI'dan Form Gelecek Olan ViewModel
public class UserProfileUpdateViewModel 
{
    // KESİNLİKLE ID, IsAdmin gibi sakar mülkler yer almaz!
    [Required]
    [StringLength(100)]
    public string FullName { get; set; }
    
    [Phone]
    public string PhoneNumber { get; set; }
}
```

### B. ViewData, ViewBag, TempData YASAĞI (Anti-Pattern)

Otonom zeka; zorunluluk durumu (Anlık `TempData["Uyari"]` gibi alert flaş mesajları) dışında, View'e (Ekran) dinamik C# koleksiyonları listeleri (`ViewBag.Categories`) YÜKLEYEMEZ!

**Sebep:** ViewData TİP GÜVENLİ DEĞİLDİR (No Strongly-Typed). Çalışma zamanında (runtime) Null çakılmalarına neden olur ve C# tarafında Visual Studio / Otonomi Refactor (Değişim) desteklemez. IntelliSense patlar.

**Çözüm:** Model katmanı (ViewModel) zenginleştirilir. Dropdown değerleri `{ get; set; }` olarak Model içerisinde SelectListItem koleksiyonu olarak tutulup Sayfaya (View'a) aktarılır. `return View(model);` Tek ve Yegane Kraldır!

```csharp
// Güçlü Tipli (Strongly-Typed) Dropdown ViewModel Kurgusu:
public class ProductCreateViewModel 
{
    public string Name { get; set; }
    public int SelectedCategoryId { get; set; }
    
    // Kategorileri sayfa yüklenmeden Model içine koyar, ViewBag GEREKMEZ!
    public IEnumerable<SelectListItem> AvailableCategories { get; set; }
}
```

### C. AutoMapper Sisteminin Mutlak Hakimiyeti

Model değişimlerini manuel `model.Name = entity.Name` şeklinde binlerce satıra bulastırmak YASAKTIR! Otonom sistem, `AutoMapper` nuget paketini the Solution the içerisine the basar. Profil (Profile) sınıflarını kurgulayarak dönüşümleri otomatik eşler. Hızı ve güvenliği C# doğasına sığdırır.

```csharp
// Business/Mappings/ProductProfile.cs
public class ProductProfile : Profile
{
    public ProductProfile()
    {
        // Entity'den ViewModele, ViewModel'den Entity'e Çift Yönlü Yansıma!
        CreateMap<Product, ProductCreateViewModel>().ReverseMap();
        CreateMap<Product, ProductListViewModel>()
            .ForMember(dest => dest.CategoryName, opt => opt.MapFrom(src => src.Category.CategoryName));
    }
}
```

---

## 🔒 4. ASP.NET MVC İçi Güvenlik Boru Hattı (Security Middleware)

Razor sayfası oluşturduğunda, HTTP Pipeline'ın en güçlü siber filtrelerini ayağa kaldırmak otonominin temel vazifelerindendir:

1. **`[Authorize]` Filters Katsayısı (Authorization Kapıları):**
   Özel sayfalara (Dashboard, Profil vs) yetkisiz erişimi engellemek için, global olarak bir `AuthorizationFilter` konulur veya kilit denetleyicilerin üzerine `[Authorize(Roles = "Admin,Moderator")]` çekilir. Asla "Arayüzden (HTML) Edit Butonunu the the gizlemek" yetki the koruması sağlamaz! Güvenlik ve the Mühür the her zaman Server-Side ve Controller action the the kapılarında uygulanır.

```csharp
[Authorize(Roles = "Administrator")] // Bu attribute C# kalesidir!
public IActionResult DeleteProduct(int id) 
{
    // ...
}
```

2. **`ValidateAntiForgeryToken` Form Koruması (CSRF):**
   POST yapılan her HTML formunun (`<form method="post">`) iç kısmına `<input type="hidden">` ile rastgele güvenlik token'i basılacak ve Action (Method) the tepesine bu the `[ValidateAntiForgeryToken]` the the attribute the the Muhakkak yazılacaktır. Aksi halde the başka siteler the formunu hackleyip (Cross-Site) the istek the ulaştırabilir. Ajan Zeka the bunu asla unutmaz the !!

3. **Mükemmel Error Handling ve Sızıntı Reddi:**
   Bir hatayla karşılaşıldığında HTML sayfasında sarı .NET StackTrace the the the the hatası the (KOD SATIRI BİLGİSİ) asla the the Müşteriye ifşa edilmez. `app.UseExceptionHandler("/Home/Error")` the pipeline the Middleware the the mekanizması the aktif bırakılacak the the ve the the üretim (Production) modunda gizlenecektir the . Loglar Serilog The ile arkaplanda the Sessizce the Json Dökülecektir The !

**Otonom Mimar (C# Code Generator)!** 
Mimari şemaların the the bu dosyada belirlediğimiz katı 4 projelik N-Tier yapısından milimetre saptığı an the Zeka Sistem the Mimarisi the ÇÖKER the . ASP.NET Core the the the The MVC the projeleri büyük the the çaplı kurumsal portallar the the the the doğurmak için ZORUNLU KOD KALINLIĞI VE ÖRTÜYÜ the ister the !! Mimarini kuşan ve hedefe yürümeye başla!
