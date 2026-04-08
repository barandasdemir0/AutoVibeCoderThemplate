# 4️⃣ DotNet-MVC - Katı Kurumsal Gelişmiş N-Tier Ağacı (File Structure)

> **ZORUNLU DİZİLİM MÜHÜRLERİ:** 
> 
> .NET Core Web API altyapısında sadece C# sınıfları varken, **.NET Core MVC** projesinde durum ikiye katlanır! 
> 
> Çünkü "Frontend" ve "Full Stack Render" olan View'lar (Arayüzler) sistemin yarısını oluşturur. 
> 
> CSS'den Javascript dağılımına, Mappings ayarlarından N-Tier Service hiyerarşisine kadar bu 4 Katmanlı Yapı (Solution) MİLİMETRİK ŞEKİLDE ÇİZİLMELİDİR. 
> 
> Hantal veya birleştirilmiş bir Model-View-Controller dizilimi Otonomiyi bitirir! Kurumsal firmalar böyle tasarımları doğrudan çöpe atar.

---

## 📂 N-Tier (Çok Katmanlı) Klasörleme Vizyonu (`src` altı)

Bu mimari en küçük blog sayfasından en devasa (Enterprise B2B/B2C Commerce) yapıya kadar C#-MVC ikilisini taşıyan altın standarttır. 

"WebUI" katmanı çekirdeği bilemez, sadece Business'e komut yollar (*Facade* ve *Delegation* görevleri). Controller yalnızca bir hizmetçidir.

### 1. Kök Dizin ve Solution Kalkanı

Ajan ilk önce çözüm kalkanını dış dünyaya inşa eder. Her katman bağımsız bir C# Library (Sınıf kütüphanesi) olarak konumlanmalıdır. Aynı projenin alt klasörü olamaz.

```text
Enterprise.Ntier.sln
├── src/
│   ├── 1. Core/
│   │   └── ECommerce.Domain/               
│   │       ├── Common/                     
│   │       │   ├── Enums/                  
│   │       │   │   ├── UserRoles.cs        
│   │       │   │   ├── PaymentStatus.cs
│   │       │   │   └── OrderStatus.cs      
│   │       │   └── EntityBases/            
│   │       │       ├── BaseEntity.cs       
│   │       │       ├── ValueObject.cs
│   │       │       └── ISoftDeleted.cs     
│   │       ├── Entities/                   
│   │       │   ├── Accounts/               
│   │       │   │   ├── ApplicationUser.cs  
│   │       │   │   ├── ApplicationRole.cs
│   │       │   │   └── UserAddress.cs
│   │       │   ├── Shopping/
│   │       │   │   ├── Product.cs
│   │       │   │   ├── Category.cs
│   │       │   │   ├── Review.cs
│   │       │   │   └── Order.cs
│   │       │   └── Settings/
│   │       │       └── SiteConfiguration.cs
│   │       └── Exceptions/                 
│   │           ├── DomainException.cs 
│   │           └── InvalidStockException.cs
│   │
│   ├── 2. DataAccess/                      
│   │   └── ECommerce.DataAccess/
│   │       ├── Abstract/                   
│   │       │   ├── IGenericRepository.cs   
│   │       │   ├── IProductRepository.cs   
│   │       │   ├── IOrderRepository.cs
│   │       │   └── IUnitOfWork.cs          
│   │       ├── Concrete/                   
│   │       │   ├── Contexts/
│   │       │   │   ├── ECommerceContext.cs
│   │       │   │   └── ApplicationDbContextSeed.cs
│   │       │   ├── EntityFramework/
│   │       │   │   ├── GenericRepository.cs
│   │       │   │   └── EfProductRepository.cs 
│   │       │   ├── Interceptors/
│   │       │   │   └── AuditableEntityInterceptor.cs
│   │       │   ├── Configurations/         
│   │       │   │   ├── ProductConfiguration.cs
│   │       │   │   └── CategoryConfiguration.cs 
│   │       │   └── Migrations/             
│   │       │       └── 20261111_InitialCreate.cs
│   │       └── Extensions/                 
│   │           └── DataAccessRegistration.cs
│   │
│   ├── 3. Business/                        
│   │   └── ECommerce.Business/
│   │       ├── Abstract/                   
│   │       │   ├── IProductService.cs      
│   │       │   ├── ICategoryService.cs
│   │       │   └── IAuthService.cs
│   │       ├── Concrete/                   
│   │       │   ├── ProductManager.cs       
│   │       │   ├── CategoryManager.cs
│   │       │   └── AuthManager.cs
│   │       ├── Mappings/           
│   │       │   ├── AutoMapperProfile.cs
│   │       │   └── ViewModelMappingProfile.cs           
│   │       ├── ValidationRules/            
│   │       │   └── FluentValidation/
│   │       │       ├── ProductCreateValidator.cs 
│   │       │       └── UserRegisterValidator.cs
│   │       └── Extensions/                 
│   │           └── BusinessRegistration.cs 
│   │
│   └── 4. WebUI/                           
│       └── ECommerce.WebUI/
│           ├── Areas/                      
│           │   ├── Admin/                  
│           │   │   ├── Controllers/
│           │   │   └── Views/
│           │   └── Vendor/
│           ├── Controllers/                
│           │   ├── HomeController.cs
│           │   ├── CartController.cs       
│           │   ├── ProductController.cs
│           │   └── AccountController.cs    
│           ├── Models/                     
│           │   ├── Product/
│           │   │   ├── ProductListViewModel.cs
│           │   │   └── ProductCreateViewModel.cs
│           │   ├── Account/
│           │   │   └── UserRegisterViewModel.cs
│           │   └── Shared/
│           │       └── ErrorViewModel.cs       
│           ├── Views/                      
│           │   ├── _ViewImports.cshtml     
│           │   ├── _ViewStart.cshtml       
│           │   ├── Shared/
│           │   │   ├── _Layout.cshtml      
│           │   │   ├── _AdminLayout.cshtml      
│           │   │   ├── _ValidationScriptsPartial.cshtml 
│           │   │   └── Components/         
│           │   ├── Product/
│           │   │   ├── Index.cshtml        
│           │   │   ├── Details.cshtml
│           │   │   └── Create.cshtml       
│           │   └── Home/
│           │       └── Index.cshtml
│           ├── ViewComponents/             
│           │   ├── CartSummaryViewComponent.cs 
│           │   ├── UserProfileWidgetViewComponent.cs
│           │   └── CategoryMenuListViewComponent.cs
│           ├── wwwroot/                    
│           │   ├── css/                    
│           │   │   └── site.css
│           │   ├── js/                     
│           │   │   └── main.js
│           │   ├── lib/                    
│           │   │   ├── bootstrap/
│           │   │   └── jquery/
│           │   └── uploads/                
│           ├── Filters/                    
│           │   ├── GlobalExceptionFilter.cs
│           │   └── ActionLoggingFilter.cs
│           ├── appsettings.json            
│           ├── appsettings.Development.json            
│           └── Program.cs                  
```

---

## ⚠️ Kritik Klasörleme Yasaları ve Otonom Reçetesi (Golden Keys)

Eğer bir yapay zeka ajanı ".NET MVC Klasör Mimarisi Kur" komutunu aldığında aşağıdaki ölümcül hatalardan birini yaparsa, bütün yetkileri elinden alınır:

### 1. `Models` Klasöründe Entity (Veritabanı Sınıfı) Yaratma Katliamı 

Eski `.NET Framework 4.5` döneminde, MVC Monolithic (Bütünleşik) kodunda Domain sınıfları (`Product.cs`, `User.cs`) direkt Web katmanının `Models` klasörüne yığılırdı. 

**N-Tier .Net Core 8 Architecture'da bu durum %100 YASAKTIR.** 

WebUI altındaki Models klasörü SADECE **VIEW-MODEL** (Ekran-Veri Tüketici Sınıfları) içermek ZORUNDADIR! Gerçek Entity'ler soyutlanıp 1. Core (Domain) katmanında tutulur. Asıl katmanlama felsefesi budur! 

Eğer Controller, View katmanına doğrudan "Entity" dönüyorsa, Mass Assignment güvenlik açıklarına (Hackerların HTML içinden yetkilerini değiştirmesine) kapı aralanmış olur. C# MVC UI yapısı sadece DTO ve VieModel'i görebilir.

### 2. "PartialView" Çöplüğü Karşıtı "ViewComponent" Kullanımı

Eski yapıda Navbar'da (Menü navigasyon barları) dinamik veri çekmek için Layout içinden `Html.Action()` kullanılırdı veya Controller'dan Partial View geçilirdi. 

**Modern C# Standardı:** 
Otonomi Layout (Master Page) bağımsız modüller kurgulayacaksa; `WebUI/ViewComponents` altına `.cs` classı yazar. 

Bu sınıf aynen bir Controller gibi DataBase Service (İş mantığı) sınıflarını enjekte edebilir (DI).
Daha sonra `return View(model)` ile sadece kendi izole `.cshtml` tasarımını Ana Header'a gömebilir! Sayfa performansı %300 artar!

Kesinlikle statik HTML haricinde `<partial>` kullanımı sınırlandırılacaktır. Döngüsel işlemler asenkron InvokeAsync üzerinden ViewComponent sınıfında gerçekleştirilmelidir.

### 3. Client-Side JS/CSS Kontaminasyonu Önlenmesi

Otonom ajan, projenin bütün Javascript ve CSS Bootstrap scriptlerini (UI araçlarını) gidip her sayfanın (`Index.cshtml` veya `Create.cshtml`) en tepesine rastgele `<script>` tag'leriyle dökemez.

* **Nasıl Yapılır?**
  `Shared/_Layout.cshtml` dosyasının sayfa kapanış bölümüne (Body kapanmadan hemen önceye) `@RenderSection("Scripts", required: false)` yazar.
  
* **Ekran İçi Kodlama Uzmanlığı:**
  Örneğin ürün kayıt ekranındaki C# sayfasında, sadece o sayfaya özel JQuery kodu varsa sayfanın tabanında `@section Scripts { ... }` içine ilgili kodu kilitler. 

Bu durum, tarayıcının ekranı (HTML) okumasını bloke etmez (Non-blocking render). Muazzam bir hijyen kalkanı örülür! Mimarinin Frontend kısmı da tam bir C# Server Rendering mühendisliğidir.

### 4. Areas Yönetimi İle Yetki İzolasyonu Ve Bounding

Uygulamanın yönetim paneli (Admin Panel), C# standart kullanıcı yüzünden izole edilmek zorundadır. 

Otonomi, `Admin` paneli veya `Vendor` (Satıcı) portalı gibi devasa yeni rotaları, düz Controller yığını içinde kaybetmek yerine, **ASP.NET Core Areas** mimarisini kurar. 

`Areas/Admin/Controllers` klasörü içinde farklı bir Routing (Yönlendirme) dünyası yaratılır. Admin'in Views klasörü bile standart Views'tan tamamen ayrışır `Areas/Admin/Views/Home/Index.cshtml`.

Bu MVC routing mekanizmalarının kurumsal düzeydeki (Enterprise) en önemli profesyonel özelliklerinden birisi haline gelmiştir! Hobi klasörlemelerini kullanmayı bırakın. Otonomi daima katı ve sert çizgilerle projeyi yönetir!
