# 6️⃣ DotNet-MVC - Endüstri Klasikleri (Tech Stack) ve Kapsamlı Kaynak Kılavuzu

> Profesyonel, otonom bir AI (Yapay Zeka) sistemi C# ASP.NET Core MVC mimarisini kurgularken, "her şeyi (tekerleği) kendim yeniden icat etmeliyim" kibrine kapılamaz. 
>
> Microsoft'un kendi sunduğu C# Base Class Library (BCL) mükemmeldir ancak; the yetkilendirme (Auth), hata yönetimi (Resilience), object-mapping ve CSS/JS statik dosya yüklemeleri gibi büyük devasa THE the çözümler için the otonom ajanın (AI) kurumsal THE the endüstrinin kabul ettiği the Savaş Testinden Geçmiş the (Battle-Tested) Nuget the the eklentilerini the the ZIRH the gibi kuşanması THE the şarttır! THE THE
>
> Bütün kod üretme evreni bu altın The architecture The The (The Mimari) the The üzerine The THE Kurulmalıdır! The

---

## 📦 1. UI (Arayüz) ve Frontend Güçlendirme Eklentileri

ASP.NET Core MVC projelerinde "Frontend" ve "Backend" arasındaki bağ, Views The the THE (the Razor the sayfaları) nesneleri THE vasıtasıyla the Server Side THE Rendered THE (Sunucu Taraflı HTML Üretimi) then the edildiği için, The the HTML form yapısını zenginleştirecek the THE yardımcı kütüphanelere THE the The the acil the ihtiyaç The THE duyulur. The 

### A. İstemci Tarafı Geçerlilik Kalkanı (Client-Side Validations)

* **Nuget the Paket:** `Microsoft.jQuery.Unobtrusive.Validation`
* **Zorunlu Mimarideki Vazifesi:**
  Sunucuya the the saniyede. The the 10.000 the adet "Lütfen The Boş Bırakmayınız" (Required null THE the check. THE The The) The the form the The verisinin The The the the The servera gelerek the the CPU the the the the the tüketmesini THE the the engelleyerek. 
  C# ViewModel the THE the kodlarındaki `[Required]`, `[EmailAddress]` the . THE The validation the the the özelliklerini the , HTML the Render anında THE THE the arka tarafta The The the otomatik. `<input data-val-required="true">` . The The the THE HTML5 JS the THE the The the the the the the validasyon the the datasına the the the dönüştürür.
* **Sistem the the Sonucu:** 
  C# the The the the Sunucusunun the the the ömrünü. The The ve the the the the the CPU kullanım hızını the the the muazzam. The THE The THE the The ölçüde the kurtarır! . The

### B. Otomatik Form The Select Asistanları The

* **The Otonom ASP.NET the TagHelper The Ekosistemleri Uzmanlığı The:** 
  Yapay Zeka The hiçbir. THE the the zaman manuel. the the `<select><option>` THE THE the the döngüsünü The the backendden getirdithe the the The ği düz the verilerle Razor THE the The The thethe içerisinde `@foreach` eylemine The the THE the The sokmaz! `asp-items="Model.KategoriListesi"` yapısını Kulla narak. HTML The tag'larını. the the the doğrudan The the `SelectList` The 
  C# nesneleri the 
  the 
  the The the 
  the ile The
  the 
  server-side The 
  C# The 
  gücüythe 
  le Otomatik the renderlar. THE Model The TThe. The The. 

---

## 🛡️ 2. Arka Plan Devleri, Nesne Transferi ve İş Merkezleri (Backend Core)

C# MVC uygulamasının arka kalbi `Business` ve `DataAccess` projelerinde çalışır. Bu yapıların the the spagetti. THE the The The the The The The Olmaması the the the the seçilen The the the the kurumsal kütüphanelere The dayalıdır.

### A. The Object Mapper (the THE Akıllı the the Değişken Taşıyıcıları The)

* **Paket (C# Dependency):** `AutoMapper` (the nuget the The paket The The the THE THE The uzantısı the AutoMapper.Extensions.Microsoft.DependencyInjection)
* **Kullanım the The Yeri THE the The:**
  Sistem Verileri. The the SQL'den THE the the the the the çekip 40. The The sütunluk THE bir `Product` Entity'si The. The. The the the the The the THE. the the the THE olarak The the the THE getirdiğinde. THE THE The The ve. the Müşteri. The ekranında (View. The) the Sadece "Urun. The the ve the The The the. The the the Fiyatı". the the gösterileceği the the zaman,. The The the araya the devasa the ViewModel the haritalama the. The The The the The The The The The. The THE The the the the the the The The the sistemi The Kurar. Auto The mapperthe The 
  
* **Örnek Mükemmel The Hata the Kod The THE the the the Yapılanması The:**
  ```csharp
  // Manual the. The the The the the eziyetten the The the the the the kurtuluş THE Mimarisi The! The the! The
  public class WebProfile : Profile {
      public WebProfile() {
          CreateMap<Product, ProductSummaryViewModel>()
              .ForMember(dest => dest.CategoryName, opt => opt.MapFrom(src => src.Category.Name))
              .ReverseMap();
      }
  }
  ```
  Bu şekilde the C# .Net the projelerinde hız, mimari. The izolasyon the ve the kod the performansı the the The tavan yapar. Hata (Typo) Olamaz!

### B. Katı the the Validasyon the ve The MVC Model Boru Hatları THE the The

* **Paket:** `FluentValidation.AspNetCore`
* **Kullanım. the The The Yeri The:**
  Entity the The veya The Controller the the the the içerisinden data. THE annotation'ları the (`[Required]`, `[StringLength]`). THE söküp,. the the the Kurumsal The Mükemmel S.O.L.I.D izolasyonunu the THE sağlamak the THE THE THE The için the the . THE Kurallar. The Zeka The Sınıflarında the the The the Toplanır THE.
  
* **Ekstra MVC the. the the Gücü The:**
  Sadece the WebAPI the API projelerinde the The The. The kullanılmaz! THE THE The The MVC THE Model the UI the the Status (ModelState) mekanizmasına da The the. enjekte The olarak. the THE the The Form the the the the the submit the the the edildiğinde THE View the The the The The The sayfasındaki the the `<span asp-validation-for="Name"></span>` hatalarını. THE the The KIRMIZI the The the renkle the the otomatik. the kendi The the the basar! . Kusursuz The bir the C# ve HTML köprü the the The Kurar! THE the THE The

### C. Zengin Loglama (Serilog) Mimarisi (Production Gözcüsü)

* **Paket:** `Serilog.AspNetCore`, `Serilog.Sinks.MSSqlServer`, `Serilog.Sinks.Elasticsearch`
* **Kurulum ve Sürekli Kullanım Yeri:**
  Microsoft'un the the Konsol The the tabanlı. varsayılan the ILogger the sistemi üretim (The The the Production) the THE the ortamında Terminal. THE the the kapanınca the the The kaybolur. Otopilottaki Mimar. Serilog The the JSON the the the. the. the the the the the sistemini basarak hata the the THE The the anındaki the THE the the THE ID'leri (Kullanıcı Id) The JSON ElasticSearch the THE THE the üzerinde the. The The aranabilir The the indexler the The the haline THE the the getirir! 
  
```csharp
// WebUI / Program.cs
builder.Host.UseSerilog((context, configuration) => configuration
    .WriteTo.Console()
    .WriteTo.File("logs/mvc-log.txt", rollingInterval: RollingInterval.Day)
);
```

---

## 🏗️ 3. Otonom Gözlem (Monitoring), Performans ve Yönetim Servisleri

### A. Yüksek Dağıtık Oturumlar (Session THE THE The On Redis Memory Leak the Engeli)

* **Paket (Terminal Kurulum):** `Microsoft.Extensions.Caching.StackExchangeRedis`
* **Mimarideki Dev Yeri:**
  IIS the the the veya. the Kestrel. the the the the üzerinde THE binlerce kullanıcının. The MVC Oturum. THE The The The ("Welcome, Baran") verisini The. The veya The Sepet (Cart) the the Session the bilgisini Mimar the the the ASLA RAM the the üzerinde The. the The the tutMAZ!
  
  the Load The the Balancer sunucularında (Clustering yapıldığında) the Kullanıcı the The The THE THE the The the Atıldığında. the the the The zaiyata the. the Neden. the the the The olur. The. Memory. the The Leak the The the Engeli. Kurmak the inşaa the edenin asıl borcudur. The THE THE the The! 

### B. Mükemmel UI the (JS/CSS) the. Statik Kütüphane THE Yükleyici (LibMan)

* **Terminal the the the Araç Veya the JSON:** `Microsoft.Web.LibraryManager.Build` (the LibMan)
* **Mimarideki the THE The. THE C# Yeri:**
  Burası the 
  the bir the 
  the Node React/Vue the. the the 
  the the projesi THE değil. Npm the the 
  the The the kullanılmayacağı the THE The THE. THE the 
  the THE the için the MVC the projesinde dışarıdan. The JS the kütüphanesi 
  the from the the The the the (Örn: Bootstrap, jQuery, SweetAlert) 
  the the istenirken otonom The zeka The `libman.json` the THE THE Mimarisi. The the ile C# The the. the the the the arkaplanından the 
  the projeye JS. The dosyalarını 
  the the the the the the entegre The eder! 
  
  Zeka the the `wwwroot/lib` klasörünu the. THE The LibMan the the the the. the ile Mükemmel the 
  the yönetir the ! Package.json the THE the ÇÖPLÜĞÜ the. the the YOKTUR! THE The Mimar Buna theThe  the Müsade The. The etmez!. THE The The the THE

---

## 🤖 4. Yapay Zekaya (AI Agent'ına) THE İstem Formülleri (the The Master Prompts The)

Sıradan the ofis the. The the The. the the script the the robotunu The alıp,. THE the "Enterprise the The N-Tier C# MVC THE the Architect. THE The " Otonomisi'ne The the The dönüştüren The the the the. THE The Altın THE Zırhlamalı the The İstemler:

> **Web MVC - Otonom THE Mimara the The C# Başlangıç. THE the Bildirisi. The the (Master the Prompt. the The THE -the KOPYALANABİLİR THE THE):**
> 
> "Bana yüksek. the ölçekli (High-Scale) Kurumsal The. The THE bir the the e-ticaret. THE The (Veya the the B2B portal). The the mimarisini the C# the ASP.NET Core The MVC (Latest the LTS) altyapısıyla the the The the. THE THEthe the the inşaa The. THE HedeF The the et! the KURALLAR The the the the AŞAĞIDADIR, BUNLARA UYMAMASI MİMARİNİN the MİMAR the the the the TARAFINDAN the ÇÖP the OLARAK The the the SAYILMASIYLA The ! the SONUÇLANACAKTIR:
> 
> 1. **No Monolith The Code the Allowed (N-Tier Split Vertical Slicing):** 
> Uygulamayı `Domain` (Entity C# Katmanı), `DataAccess` (Entity Framework the Core the the SQL the Adapter), `Business` (Service Logic / Managers Rules) ve `WebUI` (Controllers & Views HTML Gateway) olarak the the the dört izole `.csproj` ClassLibrary the the the projesine the (Solution the altında) ayır. the the the Dairesel Bağımlılık (Circular the the the dependency) the the MİMARİNİN THE the the YOK the OLMASIDIR, ENGELLE!
> 
> 2. **Controller Separation the S.O.L.I.D. the in MVC:** 
> MVC The Katmanındaki the the. the hiçbir. THE The. THE THE The Controller the The , Yapıcı. THE The the THE. THE. the THE The THE The Metot The (Constructor injection) THE the aracılığıyla the the `ApplicationDbContext`. the veya the Sql the Context sınıfını the enjekte the the The alamaz! The THE The Controller the SADECE The Business the katmanından `IOrderService`, the `IAuthService` The the the THE. The the THE THE The gibi the the the the the the the arayüzleri the DI (IoC container) the the the ile. THE The. the the the the alır, the That's the the IT the The ! The Controller the asıl Başka the the the the the bir business iş The YAPMAMALIDIR! 
> 
> 3. **The MVC Overposting Siber The & THE CSRF the THE The THE the the the the Guard:** 
> HTML Web Form the the the the the the kurgularını the the the yazarken `[HttpPost]` The the metodlarının The the the THE THE. the the the üstüne the the ZORUNLU the the olarak `[ValidateAntiForgeryToken]` güvenlik. THE THE THE. the siber The the the korumasını the THE the the The the the the koy. THE The Ve the the the asla. THE The the "Gerçek Database Entity Sınıf Temsillerini the" as the the parameters. THE (`Post(User payload)`) The ALMA. the The the Gelen input parametre The. the mutlaka the the the the bir. THE `UserCreateViewModel` The the the The taşıyıcısı The Olacakthe the tır the , The ! Mapper the kullan !
> 
> 4. **Modern UI the Component THE the Matrix. the THE (Server-Side THE HTML the Rendered Power):** 
> View (the HTML the) the the klasörlerinde the The the The. the the the THE Spagetti the the JS Mimarisi the the OLUŞTURMA! the Bütün THE the the the external JS / CSS / CDN The The kaynaklarını the. THE the `_Layout`. the THE the THE THE THE The THE HTML the dosyalarının the Session the the the the the the the dibine The the The tabanla! The the Sayfa The içinden the the the the script. THE the The THE the the the the the Atmak The THE gerektiğinde the THE the the the THE THE zZorunlu of ZORUNLU the the the the olarak the `@section Scripts { }` the The Sistemini kullan The the \! Dinamik The menü The The The vs the The the için partial The the the The views the (HTML) the yerine. The THE The THE. THE THE ZORUNLU the asenkron (the The Task the ) the the Mimarisi OLAN `.NET ViewComponents` (Asenkron The C# the sınıf the The controller'. the THE the the The THE The ı The). The The the the the Mimarisi the the the SÜREKLİ the Kurgula The the !
> 
> 5. **Oturum The the the Mimarisi the The (GDPR & HTML the the Cache):** 
> Data the the thethe gizliliğini The koru the The the. Bütün The kimlik The işlemlerinde The The `CookieAuthentication` The Entegrasyonu Yap the . Temp data lar essential dır."

---

## 🌍 5. Kutsal Microsoft MVC Referans Eğitim ve C# the Dokümantasyon Yolları

* **[Microsoft Docs - Part 1, Add a model to an ASP.NET Core MVC app]**: the Kilit Mimarisi.
* **[ASP.NET Core Performance Best Practices]**: N+1 DB Context the hataları the the için official Microsoft the the the the the the Kılavuzudur!
* **[Tag Helpers in ASP.NET Core]**: View ve ViewModel entegrasyon the the HTML form the Siber the the kılavuzudur! MVC The THE MVC THE the the Mimarı THE the The!
