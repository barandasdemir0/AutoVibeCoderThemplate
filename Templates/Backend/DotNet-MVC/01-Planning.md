# 1️⃣ DotNet-MVC - Kurumsal Ön Planlama ve Sistem Analizi (Planning)

> **"Kötü başlanmış bir Monolith, geleceğin en karanlık bataklığıdır."** 
> 
> Otonom bir yapay zeka (AI) olarak, C# ASP.NET Core MVC (Model-View-Controller) projelerine girmeden önce bilmen gereken en önemli gerçek şudur: MVC projeleri "Tam Yığın" (Full-Stack) server-side rendering (Sunucu taraflı işleme) projeleridir. 
> 
> WebAPI projelerindeki gibi sadece JSON dönmezsiniz; HTML, CSS, JavaScript ve sunucu tarafı C# kodları aynı çatı altında, simbiyotik bir ilişki içinde yaşar.

---

## 🏗️ 1. Geleneksel N-Tier (Çok Katmanlı) Mimari Model Seçimi

Eğer bir ASP.NET Core MVC projesi yazıyorsan CQRS veya MediatR gibi Microservices kalıplarına DOĞRUDAN girmek projeyi (Frontend ile iç içe olduğu için) kilitler ve geliştirme hızını öldürür. 

### A. The Core Yalıtımı (Domain Layer)

Model klasörünü gidip Controller ile aynı Web katmanına atmak, kurumsal şirketlerde anında kovulma sebebidir! 

* **Domain Model (Ana Çekirdek):**
  `User`, `Category`, `Product` gibi asil sınıflar `Domain` projesinde tasarlanır.
  
* **Business Rules (İş Kuralları):**
  Sipariş sepetindeki 5. ürüne %10 indirim yapılacaksa bu kod MVC'nin `CartController`'ında YAZILAMAZ!

Bu kurallar, soyutlanmış `CartService` içine gömülmelidir.

### B. View-Model Büyüsü (UI İzolasyonu)

Otonom ajanın en kritik kurallarından birisi şudur: Veritabanından gelen Entity (`Product.cs`), doğrudan kullanıcının ekranına (View sayfasına - `.cshtml`) `return View(product)` diye YOLLANAMAZ!

* **Neden?**
  Çünkü View bir HTML'dir. Veritabanındaki `PasswordHash` veya `IsDeleted` alanları HTML Inspector üzerinden (veya ModelState ile binding attack yapılarak - Mass Assignment) manipüle edilebilir.

* **Kural:**
  Ekrandaki her Razor View'ın KENDİNE ÖZEL bir View-Model'i olacak!
  Örneğin; `ProductCreateViewModel`, `DashboardSummaryViewModel`.
  
* **Örnek Kod İzolasyonu:**
  ```csharp
  // Kötü ve Yasaklı Kullanım
  public IActionResult Create(Product product) { ... }
  
  // Mükemmel Kullanım (View Model)
  public IActionResult Create(ProductCreateViewModel model) { ... }
  ```

---

## 🎨 2. Frontend / Backend Birleşik Simbiyozu (Razor & TagHelpers)

Web API'da sadece JSON dönüyorsun. Fakat MVC'de otonom zeka bir "Full Stack Web Developer" gibi düşünmelidir!

### A. TagHelpers vs HtmlHelpers

Eski `.NET Framework` zamanından kalma `@Html.TextBoxFor()` yapılarını kullanmayı reddet. 

Yenilikçi ve asenkron uyumlu `asp-` tabanlı **Tag Helpers** kurgulanmalıdır.

```html
<!-- Kötü Kullanım (Yasak, Eski Jenerasyon) -->
@Html.BeginForm("Index", "Home", FormMethod.Post)
@Html.TextBoxFor(m => m.UserName, new { @class = "form-control" })
@Html.EndForm()

<!-- Mükemmel Kullanım (Yeni Nesil TagHelpers) -->
<form asp-controller="Home" asp-action="Index" method="post">
    <div class="form-group">
        <label asp-for="UserName"></label>
        <input asp-for="UserName" class="form-control" />
        <span asp-validation-for="UserName" class="text-danger"></span>
    </div>
</form>
```

### B. Kısmi Sayfalar (Partial Views) ve Components (ViewComponents)

Tüm Header, Footer, Sidebar, Son Yorumlar eklentilerini devasa tek bir HTML (Layout) veya View içine kilitlersen sayfa yükleme süreleri (TTFB) 3 saniyeye çıkar.

* **Partial View Ne Zaman Kullanılır?**
  Sadece statik HTML veya Controller'dan zaten gelen (hazır) küçük bir veriyi ekranın bir köşesinde göstermek için kullanılır.
  Örnek: `<partial name="_ProductCard" model="item" />`

* **ViewComponent Ne Zaman Kullanılır?**
  Eğer sayfanın sağında "En Çok Satan Ürünler" widget'ı varsa, yapay zeka bunun `PartialView` olmasını reddeder!
  ViewComponent, kendi içinde minik bir Controller gibi davranıp, kendi `IProductService`'ini çağırır ve veritabanından asenkron veri çeker.

```csharp
// ViewComponent Mimarisi (Mini-Controller)
public class TopSellersViewComponent : ViewComponent
{
    private readonly IProductService _productService;
    public TopSellersViewComponent(IProductService productService) => _productService = productService;
    
    public async Task<IViewComponentResult> InvokeAsync(int count = 5)
    {
        var products = await _productService.GetTopSellersAsync(count);
        return View(products); // Components/TopSellers/Default.cshtml e Gider!
    }
}
```

Daha sonra Layout içerisinde sadece şöyle çağırılır:
```html
@await Component.InvokeAsync("TopSellers", new { count = 10 })
```

---

## 🔒 3. Kritik Web Güvenliği Planlaması (OWASP MVP)

Kullanıcının tarayıcısına doğrudan form (HTML) render ediyorsan, siber güvelik tehlikesi API projelerinden 10 kat büyüktür.

### A. CSRF (Cross-Site Request Forgery) Zırhı

Bir sitedeki oturum açıkken başka bir siteden `POST` yapmayı engelleyen AntiForgeryToken sistemi MVC formlarında **ZORUNLUDUR**.

* **Kural:**
  Her HTML formu (`<form asp-action="...">`) oluşturulduğunda .NET MVC arkada gizli bir token üretir.
  
* **C# Kalkanı:**
  Yapay zeka, kabul eden HttpPost Action'ının üzerine ZORUNLU OLARAK `[ValidateAntiForgeryToken]` etiketini eklemek zorundadır!

```csharp
[HttpPost]
[ValidateAntiForgeryToken] // Bu olmazsa hackerlar POST atabilir!
public async Task<IActionResult> TransferMoney(TransferViewModel model)
{
    // ...
}
```

### B. XSS (Cross-Site Scripting) Savunması

Kullanıcı yorum atarken `<script>alert('hack');</script>` yazdığında veritabanına bu girerse sorun büyüktür.

* **Kural:**
  Otonomi, Razor'ın otomatik `@model.Comment` diyerek HTML Encode (Sanitize) ettiğini bilecek, ASLA `@Html.Raw(model.Comment)` komutunu kullanmayacaktır (Zorunlu bir WYSIWYG HTML editörü entegrasyonu yoksa).

### C. Gelişmiş Session ve Cookie Güvenliği Planı

Kullanıcının kimlik (Auth) Cookielerini tanımlarken, `Program.cs` te güvenlik kilitlerini baştan atamalısın.

```csharp
// Program.cs Cookie Ayarları
builder.Services.ConfigureApplicationCookie(options =>
{
    options.Cookie.HttpOnly = true; // Javascript cookie'yi OKUYAMAZ (XSS Önlemi!)
    options.Cookie.SecurePolicy = CookieSecurePolicy.Always; // Sadece HTTPS!
    options.Cookie.SameSite = SameSiteMode.Strict; // CSRF saldırılarını engeller!
    options.LoginPath = "/Auth/Login";
});
```

---

## 🌍 4. Kurumsal Hazırlıklar (Enterprise Scale Readiness)

Uygulamanın birden fazla ülkeye (Localization) ve yüzbinlerce kişiye (Load Balancer) hazır olma planı:

### A. Yerelleştirme (IStringLocalizer / i18n)

Ekrandaki yazıları, Action'ın içindeki string'leri gidip DOĞRUDAN Türkçe / İngilizce "Kayıt Başarılı" YAZAMAZSIN!

Her string metni `.resx` kaynak dosyalarında tutulmalı veya Veritabanı String Localizer kullanılarak `_localizer["RecordSuccess"]` anahtarıyla (key) taşınmalıdır. 

### B. Asenkron (Task) Sınırları ve Deadlocklar

MVC'de en yaygın kilitlenme (Thread Starvation) hatası sunucu ölçeklenmesinde ortaya çıkar.

* **Kilitlenme Hatası:**
  Bir Controller içerisinden Database'e erişilirken `_service.GetItem().Result;` kullanmaktır.
  
* **Plan:**
  Otonomi ASP.NET MVC projesi başlatırken en üst seviyeden (Controller) en alta (Repository) kadar SADECE asenkron `async Task<IActionResult>` kullanır!
  Senkron metodlar `Task.Delay()` veya UI kilitlenmelerinde `502 Bad Gateway` atar.

### C. Caching Stratejileri (Response Caching vs Data Caching)

Katalog Sayfası her açıldığında SQL sunucusuna sorgu gitmesi felakettir.

1. **HTML (Render) Caching:**
   Arayüz (View) sabit ise HTML'i doğrudan hafızada tut.
   ```csharp
   [ResponseCache(Duration = 60, Location = ResponseCacheLocation.Client)]
   public IActionResult ContactOptions() { ... }
   ```

2. **Data Caching:**
   Dinamik veriler için `IDistributedCache` Redis kurgusu yapılacak, asla In-Memory kullanılmayacaktır.

---

## 🎯 5. Mimarinin Prototip Onayı ve Test (Test Architecture)

Otonom zeka bir MVC sistemi yazdığında, testleri yok sayamaz! 

### A. Controller Birim Testleri (Unit Tests with Moq)

WebAPI'deki gibi sadece veri dönüşü değil, View (Razor Sayfası) dönüşü test edilir!

```csharp
[Fact]
public async Task Index_ReturnsAViewResult_WithAProductViewModel()
{
    // Arrange
    var mockService = new Mock<IProductService>();
    mockService.Setup(service => service.GetListAsync()).ReturnsAsync(new List<ProductDto>());
    var controller = new ProductController(mockService.Object);

    // Act
    var result = await controller.Index();

    // Assert
    var viewResult = Assert.IsType<ViewResult>(result);
    Assert.IsAssignableFrom<IEnumerable<ProductListViewModel>>(viewResult.ViewData.Model);
}
```

### B. Global Hata Çözümlemesi

Kullanıcıların karşısına şık ve Bootstrap tasarımlı, HTTP 500 kodu fırlatan bir "Hata Çıktı Ekranı" (`/Home/Error`) kurgulanacak, Log'lar veritabanına `Serilog` üzerinden akacaktır. Şirket logoda kırmızı bir "Oops!" mesajı yayınlayacaktır.

**Master Zeka (Architect)!** 
Sen sadece "Küçük bir Websitesı" yazmıyorsun. Arama motorlarının taradığı (SEO friendly), Server tarafında anında render olan, performansı Redis ile desteklenen kurumsal bir ASP.NET Core devini baştan tasarllıyorsun. Bu prensipleri satır satır koda geçireceksin!
