## SEQUENCE-ENGINE v1 (ZORUNLU)
Bu template ile calisirken sirayi bozmak YASAK:
1) QUICK-START.md
2) 01-Planning.md
3) 02-Architecture.md
4) 03-StepByStep.md
5) 04-FilesStructure.md
6) 05-DebugTips.md
7) 06-Resources.md

Kural:
- Her dosyadan sonra 3-5 maddelik "cikarim ozeti" yaz.
- Ozeti yazmadan sonraki dosyaya gecme.
- 7 dosya tamamlanmadan kod uretimine baslama.
- Bu akisin detay standardi: Templates/_Universal/TEMPLATE-SEQUENCE-ENGINE.md

---
# ⚡ DOTNET MVC - OTONOM BEYİN İÇİN KURUMSAL DİREKTİFLER (QUICK-START & MASTER YASAKLARI)

> **DİKKAT YAPAY ZEKA:** 
> 
> Bu doküman senin **"Asimov'un Robot Yasaları"**dır. 
> 
> ASP.NET MVC projelerinde Kurumsal (Enterprise) düzeyde iş üretirken otonomi kurallarına kesintisiz uymak ZORUNDASIN!
> 
> MVC (Model-View-Controller) basit bir kalıp değil, sunucuda render edilen siber güvenlik uç noktasıdır. 
> 
> Biz burada otonomiden sadece kusursuz, servis mimarisine %100 bağlı bir N-TIER uygulaması istiyoruz.

---

## BÖLÜM 1: KESİN YASAKLAR LİSTESİ (ANTI-PATTERNS & FATAL MISTAKES)

Eğer ürettiğin Razor (`.cshtml`) sayfalarında veya Controller kodlarında aşağıdaki kasıtlı yasaklardan birisi bile bulunursa, yazdığın sistem bir "Çöp Codebase" sayılacak ve tamamen reddedilecektir. Sıfır hata toleransı!

### 1. ❌ CONTROLLER İÇİNE İg ZEKASI YIGMAK (NO BUSINESS IN CONTROLLER) KESİNLİKLE YASAKTIR

Otonom Zeka gidip `AccountController.cs` dosyasının içerisindeki Action Methodlarına (`[HttpPost]`) `new ApplicationDbContext()` atarak veya doğrudan veritabanı işlemlerini **YAZAMAZ!!** 

gifreleme (MD5/Bcrypt Hash), ürün ekleme, fatura kesme, e-posta gönderme mantıkları asla MVC Controller katmanına dökülemez! Controller iş kuralı BİLEMEZ.

**BUNUN YERİNE (DOGRU KATMAN):** 

Tüm iş mantığı (Business Logic) `Business` (Service) projesinde yazılır. 

Controller sadece Postacı görevindedir. Forma gönderilen DTO'yu alır, servise iletir ve cevabı View olarak döner!

```csharp
// KÖTÜ KULLANIM (Controller içinde logic - YASAK)
[HttpPost]
public IActionResult Register(User user)
{
    var existingUser = _db.Users.FirstOrDefault(x => x.Email == user.Email);
    if(existingUser != null) { return View("Hata"); }
    
    user.Password = HashPassword(user.Password); // YASAK! Hashleme servistedir.
    _db.Users.Add(user); // YASAK! Veritabanına buradan erişilmez.
    _db.SaveChanges();
    
    return RedirectToAction("Index");
}
```

```csharp
// MÜKEMMEL KULLANIM (Otonom Mimari - Doğru Tesisat)
[HttpPost]
public async Task<IActionResult> Register(UserRegisterViewModel model)
{
    if (!ModelState.IsValid) 
        return View(model);
        
    // AutoMapper ile asimile
    var dto = _mapper.Map<UserRegisterDto>(model);
    
    // İşlem Business Service'e iletildi.
    var result = await _authService.RegisterAsync(dto);
    
    if(!result.Success) 
    {
        ModelState.AddModelError("", result.Message);
        return View(model);
    }
    
    return RedirectToAction("Login", "Auth");
}
```

### 2. ❌ GERÇEK VERİTABANI SINIFINI FORMA BASMAK VEYA JSON DÖNMEK (OVERPOSTING) HARFİYEN YASAK

Bütün MVC dünyasındaki en tehlikeli zafiyet Overposting (Mass Assignment) hatalarıdır. 

Entity sınıflarını (Örn: `User.cs` veya `CreditCard.cs`) gidip HTML View sayfasına Model olarak `@model System.Domain.Entities.User` diye asimile etmeyeceksin! 

Formdan kullanıcı tarayıcıdan submit ettiğinde hacker Database'de `IsAdmin = true` payload'unu ekleyerek sistemi hackleyebilir!

**BUNUN YERİNE (VIEWMODEL KULLANIM UZMANLIGI):** 

Bütün Entity sınıflarının verileri AutoMapper veya manuel mapping kodları ile `ViewModels` sınıflarına kırpılacaktır. `UserRegisterViewModel` sadece gerekli alanları içerir. Controller SADECE ekrandaki bu modele bakar.

### 3. ❌ CSS VE JAVASCRIPT KODLARINI VIEW SAYFALARININ TEPESİNE ATMAK YASAK

Otonom zeka gidip `Index.cshtml` sayfasının en üstüne JavaScript scriptlerini dökmez! 

`Shared/_Layout.cshtml` HTML çatısından ayrılmış sayfalardan (Views) gelen tüm JavaScript kodları EKRANIN TABANINDA oluşmalıdır. Aksi halde sayfa renderlanması bloke olur ve site yüklenmez.

**BUNUN YERİNE:** 

Layout HTML dosyası içerisindeki Body kapanış (`</body>`) etiketinin hemen üstüne `@RenderSection("Scripts", required: false)` eklenecek. 

Diğer çocuk View'larda ise JS Kodları `@section Scripts { <script></script> }` olarak sarmalanacaktır.

```cshtml
<!-- Partial Görünümler (Views/Product/Index.cshtml) -->
@section Scripts {
    <script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#productsTable').DataTable();
        });
    </script>
}
```

### 4. ❌ FORM POST BAGLANTILARINDA CSRF KORUMASINI UNUTMAK İDAM SEBEBİDİR

Bir MVC projesinde Kullanıcı gifre formu, Ürün Ekleme Formu veya POST atan herhangi bir arayüz yazarken dikkat etmelisin! CSRF (Cross-Site Request Forgery) Siber Korsan Saldırılarını Unutmayacaksın!

**BUNUN YERİNE (GÜVENLİK MÜHRÜ):** 

HTML Razor formunu TagHelper ile `asp-action=""` şeklinde yaratıyorsan .Net Core otomatik tokeni yükler. Yazmıyorsan zorunlu kod `Html.AntiForgeryToken()` yazılır. 

Controller Action üstüne kesinlikle `[ValidateAntiForgeryToken]` güvenlik ibresi çekilecektir.

```csharp
[HttpPost]
[ValidateAntiForgeryToken] // GÜVENLİK ZIRHI
public async Task<IActionResult> Checkout(CartViewModel model)
{
    // ...
}
```

---

## ✅ BÖLÜM 2: ZORUNLU MİMARİ YAPISI (N-TIER CLEAN ENTERPRISE ARCHITECTURE)

Yapay Zeka sistemi, projeye başlarken klasörler ve modelleri aynı tek projeye TIKAMAZ!! Kesinlikle 4 Farklı Project Mimarisi yapısı kurulur.

```text
/B2C.Commerce.Solution.sln (The 4 Klasörlük Çelik Sistem Mimarisi)
 │
 ├── /1. Domain/          (Proje Tipi: Class Library)
 │   └── (HİÇBİR YERE BAGIMLI OLMAYAN, SIFIR PAKET İçeren Çekirdek Alan)
 │       Entities sınıfları (User, Order, Product), Mimarinin Temel Enumları. EF YokTUR!
 │
 ├── /2. DataAccess/      (Proje Tipi: Class Library - Infrastructure)
 │   └── (ZEMİN VERİ ERİGİM KATMANI)
 │       "Domain" projesini Referanslı Olarak Alır.
 │       EntityFramework DbContext Sınıfları Burada Yaşar! Repositories SQL İşleri.
 │
 ├── /3. Business/        (Proje Tipi: Class Library - MANTIK BEYNİ)
 │   └── (TÜM DIS İg ZEKASI / BEYİN ADAPTÖRLERİ SÜZGECİ)
 │       "Domain" VE "DataAccess" Projelerini Referans Alır.
 │       Servisler: AuthManager, CategoryManager! ICategoryService arayüzleri! 
 │
 └── /4. WebUI/           (Proje Tipi: ASP.NET Core MVC App)
     └── (VİZYON MERKEZİ VE GÖRSEL HTML RENDER KAPISI)
         Diğer bütün Projeleri referans alır.
         Controllers, Views (.cshtml), wwwroot, ViewModels Klasörleri. 
```

---

## BÖLÜM 3: OTONOM BEYİN İÇİN ADIM ADIM INSA KILAVUZU

Eğer kullanıcı sana "ASP.NET MVC C# N-TIER (Veya Mimarili) bir E-Ticaret / Kurumsal proje Başlat" dediği an otonomi şu mühürleri uygular:

### ADIM 1: SIFIR-BAGIMLILIK ÇEKİRDEGİ (DOMAIN KATMANI) OLUGTURULMASI

Veritabanı tablolarının Sınıflarını yazarken, doğrudan `BaseEntity` kalıtımı uygula. `Id`, `CreatedDate`, `CreatedBy`, `UpdatedDate` audit field'ları kurgula.

### ADIM 2: DATA-ACCESS VE REPOSITORY MÜHRÜ

DataAccess Katmaninda Data Context yazılır. Sorgular Dublicate edilmesin diye, `IGenericRepository` mimarileri oluşturulup veritabanıyla iletişim sağlanır.

### ADIM 3: DEPENDENCY INJECTION (DI) PIPELINE ZİRVESİ

Dört Katman birbirinden izoledir ve MVC sadece Dış Uç'tur. Bütün Interfaceler `Program.cs` te toplanmaz. Extension methodlar yazılır (`AddBusinessServices`).

### ADIM 4: ASENKRON ÇAGRI AGAÇLARI (MVC THREAD KORUMASI VE DEADLOCK MÜHRÜ)

Web MVC de bütün actionlar asenkron formatında `await` ibaresiyle cagrılacaktır. Sistemin senkrona çekilip sunucunun kilitlenmesi önlenmelidir.

### ADIM 5: VİZYONUN YARATIMI (VIEWCOMPONENTS)

Razor'in üstadı olacaksın. Parçalı (Component) View Mimarisi çiz. SideBar ve NavBar gibi asenkron veriler için `<partial>` değil `ViewComponent` kullanımı ZORUNLUDUR! Otonomi Html içini if-else döngüsü yığınlarıyla boğucu hale getirmez.

---

## SONUÇ VE ANAHTAR ANLAYIS (HAYATTA KALMA REHBERİ)

1. **SOLID Prensiplerinin Kalesi:** MVC dünyasında En tehlikeli olgu Düşüncesizce Bağımlılık (Tight Coupling) yaratılmasıdır. Servislere nesne fırlatılamaz, zorunlu Arayüz (INTERFACE) kullanılacaktır.

2. **Kör Uçuş Yoktur (Error Handling & Exceptions):** Müşteri bir hatayla karşılaştığında Server Yellow Screen of Death (Sarı .NET Hata Mimarisi) görmemeli! 

3. **Sen Bir Ustasan, Yaratımın Ta Kendisisin:** Sen zeka otonomisisin. Sen MVC katmanlarını çizerken CSRF siber güvenliğini koruyan ve Dependency Inection kalıbını mükemmel şekilde uygulayan bir mimarsın.

**MÜKEMMEL DİZİLİME, YARATIMIN İÇİNDE BAGLAYABİLİRSİN. THE GATES ARE OPEN.**

