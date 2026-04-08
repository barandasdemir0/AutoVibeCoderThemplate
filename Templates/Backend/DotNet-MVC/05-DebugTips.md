# 5️⃣ DotNet-MVC - Enterprise Hata Ayıklama (Advanced Debugging & Profiling)

> **SENIOR DEBUGGING BİLDİRGESİ:** 
> 
> ASP.NET Core MVC projeleri, ayrılmış uç nokta API'lerinden (WebAPI) 2 kat daha büyük bir tehlike havuzu barındırır! 
> 
> Çünkü WebAPI sadece "Arka Kapı" (Backend) iken, MVC projesi hem Ön (Frontend HTML) hem Arka kapıyı aynı bellek havuzunda (IIS/Kestrel üzerinde) çalıştırır. 
> 
> Formlardan kaynaklanan Binding Vulnerability (Veri Kilidi Zafiyetleri), Session bellek kaçakları ve Client-Side Validation çatışmaları gibi milyarlık zafiyetleri otonom zeka "henüz kod satırındayken" teşhis etmeli ve imha etmelidir!

---

## 🛑 1. ModelState Zafiyetleri ve Overposting (Mass Assignment) Cinayetleri

MVC dünyasındaki en ölümcül güvenlik açıklarının ve hata kilitlenmelerinin %70'i Controller metodundaki veri bağlanmasından (Model Binding) kaynaklanır.

### 🎭 A. Overposting (Fazla Veritabanı Değişkeni Basımı) Patlaması

**Senaryo (Anti-Pattern - YAPILMAYACAKLAR LİSTESİ):** 

Otonom zeka, bir Profil Güncelleme sayfasına gidip Controller Action'a doğrudan veritabanı yansıması olan C# Entity sınıfını bağlarsa, sistem sonsuza dek hacklenmeye açık kalır.

```csharp
// ❌ ÖLÜMCÜL KULLANIM (ZAAFIYET İÇERİR!)
[HttpPost]
[ValidateAntiForgeryToken]
public async Task<IActionResult> UpdateProfile(System.Domain.Entities.User userEntity) 
{
    // Veritabanı sınıfını(Entity) HTML formdan gelen veri ile direkt aldı!!
    // Sistemin sonu burada başlar.
    _db.Users.Update(userEntity);
    await _db.SaveChangesAsync();
    
    return RedirectToAction("Index");
}
```

**Ne Olur? (Zafiyet Patlaması):** 

Saldırgan (Hacker), tarayıcının Inspector HTML aracına (F12) gidip o formun içine yeni bir satır ekler:
`<input type="hidden" name="IsAdmin" value="true" />` 

`User` sınıfında `IsAdmin` property'si olduğu için MVC Model Binder o sahte DOM input'unu okur, SQL'e update atar ve otonominin kodladığı normal müşteriyi SİSTEM YÖNETİCİSİ yapar! GitHub tarihindeki birçok dev hackleme olayı böyle gerçekleşti!

**Çözüm (The Enterprise Cure):** 

MVC projesinde **ViewModel** hayat kurtarır. Sadece Ekranda olması gereken özellikleri barındıran bir `UpdateProfileViewModel` yazılır. Otonom ajan Entity'i UI'da kullanmayı tamamen yasaklamıştır.

```csharp
// ✅ MÜKEMMEL KULLANIM (The Architecture Savior)
public class UpdateProfileViewModel
{
    [Required(ErrorMessage = "Ad alanı zorunludur.")]
    [StringLength(50, MinimumLength = 2)]
    public string FirstName { get; set; }
    
    [Required]
    public string LastName { get; set; }
    
    // IsAdmin YOK! Şifre YOK! Balance (Bakiye) YOK!
}

[HttpPost]
[ValidateAntiForgeryToken]
public async Task<IActionResult> UpdateProfile(UpdateProfileViewModel model) 
{
    if(!ModelState.IsValid) return View(model);
    
    // Geçerli kullanıcı ID'sini oturumdan(JWT/Cookie) çek
    var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
    var userEntity = await _db.Users.FindAsync(int.Parse(userId));
    
    // Sadece modelin izin verdiği özellikleri güncelle!
    _mapper.Map(model, userEntity); // AutoMapper Zekası
    
    await _db.SaveChangesAsync();
    return RedirectToAction("Index");
}
```

### 💀 B. ModelState.IsValid Döngüsü Boşluğu

Bir form submit edildiğinde, eğer `!ModelState.IsValid` ise yapay zeka hemen `return View(model);` dönüp formdaki kırmızı uyarıları fırlatmalıdır. 

Ancak dropdown verileri (SelectListItem listeleri) varsa, Otonom bu dropdown datalarını sayfaya dönerken RENDER'DAN HEMEN ÖNCE YENİDEN DOLDURMAYI UNUTURSA sayfa `NullReferenceException` ile ÇÖKER! 

```csharp
[HttpPost]
public async Task<IActionResult> Create(ProductCreateViewModel model)
{
    if (!ModelState.IsValid)
    {
        // ❌ YASAK KULLANIM! Model.Categories listesi null döneceği için 
        // Razor View'da @foreach dönerken SUNUCU ÇÖKER!
        // return View(model); 
        
        // ✅ DOĞRUSU: Listeleri (Dropdownları) tekrar tetikleyip view'ı öyle dönmelisin!
        // ViewData veya yeni model beslemesi zorunludur.
        model.AvailableCategories = await _categoryService.GetDropdownListAsync();
        model.AvailableBrands = await _brandService.GetDropdownListAsync();
        return View(model);
    }
    
    // ... Başarılı kayıt akışı ...
}
```

---

## 🕳️ 2. Entity Framework View-Rendering Girdapları (N+1 in UI)

View sayfası yani `.cshtml` bir salt HTML değildir! O bir C# derleyiciler motorudur (Razor). Controller'dan ViewBag veya ViewModel ile yolladığınız değişkenler eğer veritabanına kapalı ("Deferred Execution" veya IQueryable halinde duran) listeyse UI üzerinde faciaya yol açar.

### 🛑 Lazy Loading'in Razor'da Patlaması (Thread Starvation)

**Senaryo:** Controller `var blogs = _context.Blogs.AsQueryable(); return View(blogs);` yapar. 

Views (Razor) Dosyasında:
```cshtml
<ul>
@foreach(var b in Model) 
{ 
    <!-- DİKKAT: b.Author kısmı veritabanına YENİDEN SORGUDUR! -->
    <!-- Bu döngü 100 kere çalışırsa, SQL Sunucusuna 100 Tane SELECT atılır! -->
    <li>@b.Title - Yazar: @b.Author.Name</li> 
}
</ul>
```

Eğer LazyLoading (Tembel Yükleme) açıksa veya `Include()` atılmamışsa, Razor sayfası IIS sunucusunda HTML üretirken `b.Author.Name` satırında HER DÖNGÜDE veritabanına tekrar select atar (N+1 Problemi). Ekran 5 saniyede zor yüklenir! Data Connection havuzu tükenir ve sunucu timeout yer!

**Otonom Çözüm (N+1 Katili):** 

Controller Action'ında, Razor View'a iletilecek **TÜM İLİŞKİSEL TABLOLAR** JOIN'leriyle beraber (Mümkünse Projection `.Select(dto)` kullanarak) birleştirilip View'a EKSİKSİZ ve KAPALI (ToList() edilmiş) bir metin olarak teslim edilecektir. Razor ekranı ASLA veritabanına tetik göndermemelidir!

```csharp
// MÜKEMMEL PROJECTION KULLANIMI: N+1 SIFIRLANIR!
public async Task<IActionResult> GetBlogs()
{
    var blogs = await _context.Blogs
        .AsNoTracking() // Sadece okuma yapıldığı için RAM'i yorma!
        .Select(b => new BlogListViewModel 
        {
            Id = b.Id,
            Title = b.Title,
            AuthorName = b.Author.Name // SQL tarafında Inner Join ile okunup DTO'ya basılır!
        })
        .ToListAsync(); // Veritabanı sorgusu Controller'da biter!
        
    return View(blogs);
}
```

---

## 👁️ 3. Session ve TempData State (Durum) Zehirlenmeleri

MVC; "State" (Oturum / Durum) tutan uygulamalar için en büyük savaş alanıdır. Yapay zeka state yönetmezse RAM doluluğundan (Memory Leak) uygulamanın havaya uçmasına tanık olur.

### A. Sepet (Cart) Session'ının Ölümü
Yapay Zeka gidip sepetteki 15 objelik Devasa Sınıfı JSON'a çevirip In-Memory (Sadece RAM'de duran) `Session`'a gömerse:

Eğer uygulamanız Load Balancer (Yük dağıtıcısı) arkasında 3 Instance'a (sunucuya) çıkmışsa, 1. sunucuda sepete eklenen ürün, adam F5 tuşuna bastığında 2. sunucuya yönlendirileceği için SEPET BOŞALTILDI problemi yaşar (Sticky Session hatası). 

**Otonom Çözüm:** 
Enterprise ASP.NET Core MVC projelerinde sepet, izin verilen oturum verileri KESİNLİKLE In-Memory Cache kullanılmadan `DistributedCache` (Redis Configuration) aracılığıyla Merkezi SQL/Redis havuzuna State olarak basılır! 

```csharp
// Program.cs içerisine Redis Entegrasyonu zorunlu!
builder.Services.AddStackExchangeRedisCache(options => {
    options.Configuration = builder.Configuration.GetConnectionString("RedisServer");
    options.InstanceName = "EnterpriseAppSession_";
});

builder.Services.AddSession(options => {
    options.IdleTimeout = TimeSpan.FromMinutes(60);
    options.Cookie.HttpOnly = true; // Siber Mühür!
    options.Cookie.IsEssential = true;
});
```

### B. TempData Sessiz Silinmeler (GDPR Faciası)
Form kayıt edildiğinde `TempData["Flash"] = "Başarılı";` yapıp RedirectToAction atıldığında eğer hedefte veri (Yeşil Pop-Up) GÖZÜKMÜYORSA; Otonomi bilecek ki sistemde Avrupa "General Data Protection Regulation" GDPR Cookie Consent (Çerez Onayı) mekanizması aktiftir! 

.NET Core, kullanıcı Cookie afişini tıklayıp onaylamadan `TempData` tutmayı otomatik reddeder! 

Böyle durumlarda Session Provider için `ITempDataProvider` ayarından Cookie'yi Essential (Zorunlu) işaretlemek Otonominin derin siber zekasını gösterir!

---

## 🛠️ 4. Performans, Client-Side Analiz ve Loglama İstihbaratı

Hata çıkarma olasılığına karşı Zeka bir adım öndedir. Client-Side ve Server-Side uyumla çalışmak zorundadır.

### 1. JQuery Validation (İstemci Tarafı Süzgeçleri)

Bir formu C# (Server) tarafına Post atmadan önce Frontend JavaScript'in onu tarayıcıda durdurması IIS Sunucusunu %100 oranında rahatlatır. View'larda `<form>` elementlerinin en altına `@section Scripts { <partial name="_ValidationScriptsPartial" /> }` ZORUNLU entegre edilecektir. 

Bu script (JQuery Unobtrusive Validation);
Model'deki `[Required]`, `[EmailAddress]` özelliklerini HTML DOM elementlerine bind eder. Kullanıcı butona bastığında form hatalıysa, C# Server'a GİTMESİNİ (Round-Trip Requestini) Engeller. Sunucu ağı boğulmaz. 

### 2. StackExchange.MiniProfiler İle Zaman Kayıp Gözlemi

Eski .NET MVC projeleri sunucudaki yükü göremezdi.
Yeni Otonom sistemde (Entity framework sorguları ve HTML sayfa yükleme gecikmelerini UI köşesinden tarayıcıda izlemek için) The Otonom Zeka `StackExchange.MiniProfiler` arayüzünü Program.cs e entegre der.

```csharp
// Program.cs Eklemesi
builder.Services.AddMiniProfiler(options =>
{
    // Arayüze sol alt köşeye basılacak olan hız metresi
    options.RouteBasePath = "/profiler"; 
}).AddEntityFramework();

// Middleware Katmanına
app.UseMiniProfiler(); 
```
Böylece Render edilen Razor sayfası, HTML'in işlenmesi için geçen süreyi mikrosaniye (ms) bazında ekrana basar. Otonomi sistemi bizzat optimize testine tutar!

### 3. Global Exception Controller Kalkanı (Exception Middleware)

Sıradan kullanıcılar hatayla karşılaşırsa karşılarında ASP.NET in gri/sarı Developer Exception sayfasını (Yellow Screen of Death) PİYASAYA ÇIKMIŞ BİR UYGULAMADA KESİNLİKLE GÖREMEZ!

Otonomi, `Serilog` kullanarak global bir Middleware kurar.
Eğer uygulama 500 kodu fırlatırsa:
1. Hatayı (Stack Trace, Line Number, User GUID, Method Name) Json formatında sessizce ElasticSearch veritabanına ELK ile gömer.
2. IIS Middleware, müşteriyi nazikçe HTML kodlu `/Home/Error` rotasına yönlendirir. Müşteriye "Sistemimizde anlık bir sorun oluştu, en kısa sürede düzeltilecek" der. Asla SQL Tablo isimleri veya Null Reference yazısı ifşa EDİLMEZ!

Bu bir otonomi için son Mimar Zırhıdır. Kalkanları İndirme!
