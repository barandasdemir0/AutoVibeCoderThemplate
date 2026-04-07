# 🚀 DOTNET MVC STARTER BLUEPRINT (Devasa Otonom Başlangıç)

> **OTONOM KOMUT BAŞLATICI:**
> 
> Bu şablon, sıfırdan kurumsal seviyede bir "ASP.NET Core MVC" projesi üretmek için gerekli olan temel mimari dosyaları, klasör iskeletini ve CLI komutlarını içeren altın standart bir reçetedir.
> 
> Yapay Zeka ajanı, proje oluşturması istendiğinde bu mimari iskeleti (MVC N-Tier) milimi milimine uygulamak ZORUNDADIR! Mono-Blok (Monolith) tasarım YASAKTIR!

---

## 🏗️ 1. MİMARİ KATMANLAR VE YAPILANDIRMA (THE 4-TIER ARCHITECTURE)

Bir ASP.NET Core MVC projesi, arayüzlerinin C# tarafından yönetildiği devasa bir mekanizmadır. Projeyi 4 Class Library projesine böleceksin.

### Katman 1: Kök Çekirdek (Domain Layer)
* **Açıklama:** Sistemin kalbi. EF Core veya hiçbir Dış Paket bulunmaz.
* **İçerik:** `BaseEntity.cs`, `IsDeleted` arayüzü, `User.cs` sınıfı, `Roles` enum.
* **Kural:** Saf C# POCO sınıfları yazılacaktır.

### Katman 2: Veri Erişimi (DataAccess Layer)
* **Açıklama:** Veritabanına bağlanan kurye. Sadece Domain Referansı taşır.
* **İçerik:** `AppDbContext.cs`, `GenericRepository<T>`, Konfigürasyon sınıfları (Fluent API).
* **Kural:** Entity Framework Core paketleri yüklenir, Migrationlar buradan atılır.

### Katman 3: İş Zekası (Business Layer)
* **Açıklama:** Controller'ın hizmetkârı. Tüm Validation, hesaplama, DTO/ViewModel dönüşüm işlemleri burada yapılır.
* **İçerik:** `ProductService.cs`, `CategoryManager.cs`, `AutoMapper Profiles`, `FluentValidators`.
* **Kural:** Hem Domain hem de DataAccess katmanını referans alır. Veri tabanına direkt SQL sorgusu fırlatmaz, IRepository üzerinden çalışır!

### Katman 4: Sunum / Arayüz (WebUI - MVC Layer)
* **Açıklama:** Web sitesinin ziyaretçilere doğrudan HTML Renderladığı (Razor) cephedir. 
* **İçerik:** `Controllers`, `Views` (.cshtml), `wwwroot` (CSS/JS), `ViewModels`!
* **Kural:** Controller içine Context/Db yazılmaz. UI'a Entity dönülmez. `ValidateAntiForgeryToken` ile CSRF Form koruması sağlanır!

---

## 🚀 2. OTONOM CLI KURULUM REÇETESİ (BAŞLANGIÇ ADIMLARI)

Aşağıdaki komut setini terminale sırasıyla girerek Çelik İskelet Mimarisi oluşturulacaktır:

```bash
# 1. Ana Klasörü Yarat
mkdir UltimateCommerce.App
cd UltimateCommerce.App

# 2. Devasa Solution'ı Kur
dotnet new sln -n UltimateCommerce.Solution

# 3. İzolasyonu Tamamlanmış (Domain, DataAccess, Business) Otonomilerini Yarat!
dotnet new classlib -o src/UltimateCommerce.Domain
dotnet new classlib -o src/UltimateCommerce.DataAccess
dotnet new classlib -o src/UltimateCommerce.Business

# 4. Asıl MVC (Vizyon/Gateway) Katmanını Ayaklandır!
dotnet new mvc -o src/UltimateCommerce.WebUI

# 5. Katmanları Solution (Mühür) Çatısına Bağla
dotnet sln add src/UltimateCommerce.Domain/UltimateCommerce.Domain.csproj
dotnet sln add src/UltimateCommerce.DataAccess/UltimateCommerce.DataAccess.csproj
dotnet sln add src/UltimateCommerce.Business/UltimateCommerce.Business.csproj
dotnet sln add src/UltimateCommerce.WebUI/UltimateCommerce.WebUI.csproj

# 6. Mükemmel Bağımlılık Ağını Bağla (Dependency Inversion Rule)
# (DataAccess -> Domain)
dotnet add src/UltimateCommerce.DataAccess/UltimateCommerce.DataAccess.csproj reference src/UltimateCommerce.Domain/UltimateCommerce.Domain.csproj

# (Business -> Domain & DataAccess)
dotnet add src/UltimateCommerce.Business/UltimateCommerce.Business.csproj reference src/UltimateCommerce.Domain/UltimateCommerce.Domain.csproj
dotnet add src/UltimateCommerce.Business/UltimateCommerce.Business.csproj reference src/UltimateCommerce.DataAccess/UltimateCommerce.DataAccess.csproj

# (WebUI -> Domain & DataAccess & Business)
dotnet add src/UltimateCommerce.WebUI/UltimateCommerce.WebUI.csproj reference src/UltimateCommerce.Business/UltimateCommerce.Business.csproj
dotnet add src/UltimateCommerce.WebUI/UltimateCommerce.WebUI.csproj reference src/UltimateCommerce.DataAccess/UltimateCommerce.DataAccess.csproj
dotnet add src/UltimateCommerce.WebUI/UltimateCommerce.WebUI.csproj reference src/UltimateCommerce.Domain/UltimateCommerce.Domain.csproj
```

---

## 📦 3. SİSTEME YÜKLENECEK KÜTÜPHANELER HARİTASI (NUGET)

Paket yüklemelerini yanlış katmana yaparsan SOLID kurallarını yıkarsın. Sıkı kurallar:

**1. DataAccess Katmanına Yüklenecekler:**
* Sadece Veritabanı ile ilgilenen paketler!
```bash
dotnet add src/UltimateCommerce.DataAccess package Microsoft.EntityFrameworkCore.SqlServer
dotnet add src/UltimateCommerce.DataAccess package Microsoft.EntityFrameworkCore.Tools
```

**2. Business (İş Kuralları) Katmanına Yüklenecekler:**
* Sadece Doğrulama, E-Mail gönderme ve Haritalama paketleri!
```bash
dotnet add src/UltimateCommerce.Business package FluentValidation.DependencyInjectionExtensions
dotnet add src/UltimateCommerce.Business package AutoMapper.Extensions.Microsoft.DependencyInjection
```

**3. WebUI Katmanına Yüklenecekler:**
* Güvenlik (Session on Redis), MVC Paketleri ve View Rendering!
```bash
dotnet add src/UltimateCommerce.WebUI package Microsoft.Extensions.Caching.StackExchangeRedis
dotnet add src/UltimateCommerce.WebUI package Serilog.AspNetCore
```

---

## 🎨 4. VIEWS VE RENDER DOKTİRİNİ (RAZOR)

MVC projesi ayağa kalktığında Layout (Çatı) sayfası oluşturulur. Ancak her kod sayfaya gömülmez.

1. **JQuery ve CSS Pozisyonları:** 
   Otonom Zeka `Views/Shared/_Layout.cshtml` içinde `@RenderSection("Scripts", required: false)` yazar. Controller'ın gönderdiği form sayfası `.cshtml` en altına `@section Scripts { <script></script> }` şeklinde gömer. Sayfanın başlığına JS/Jquery YASAKTIR.

2. **Partial vs ViewComponent Çalışma Farkı:** 
   Eğer ekranda sabit bir Navbar (Sadece HTML) basılacaksa `<partial name="_NavBar" />` kullanılır. Eğer Ekranda Veritabanından Asenkron Gelen bir Katagoriler Listesi (Categories Menu) basılacaksa, Otonomi Kesinlikle Katı şekilde `ViewComponent` Sınıfı Kurgular. HTML içerisinden Controller metotlarını (Action Çağrıları) tetiklemek Tereddütsüz Yasaktır!

3. **Örnek MVC Mimarisi Form Kullanımı (GÜVENLİ MÜHÜR):**
```html
<form asp-controller="Auth" asp-action="Login" method="post">
    <!-- MVC CSRF Tokeni otomatik bu form oluşturucusuna yazar! -->
    <div class="form-group mb-3">
        <label asp-for="Email"></label>
        <input asp-for="Email" class="form-control" placeholder="E-Posta..." />
        <span asp-validation-for="Email" class="text-danger"></span>
    </div>
    
    <div class="form-group mb-3">
        <label asp-for="Password"></label>
        <input asp-for="Password" class="form-control" type="password" />
        <span asp-validation-for="Password" class="text-danger"></span>
    </div>
    
    <button type="submit" class="btn btn-primary w-100">Güvenli Giriş Paneli</button>
</form>
```

---

## 🎯 5. MİMARİ MÜHÜRLERİN TESLİMATI (DEPLOYMENT)

Ajan (Sen), kodu bitirdiğinde migrationları fırlatarak sistemi test etmelidir. Veritabanının oluşturulduğundan (Update) emin olmadan hiçbir MVC projesi bitmiş sayılmaz.

```bash
# Migration Oluştur (Terminal komutunu WebUI üzerinden çalıştır, EF Katmanı DataAccess'dir)
dotnet ef migrations add AcikArtirma_V1 --project src/UltimateCommerce.DataAccess --startup-project src/UltimateCommerce.WebUI

# Veritabanına Yansıt Ve Değiştir
dotnet ef database update --project src/UltimateCommerce.DataAccess --startup-project src/UltimateCommerce.WebUI

# Test Uçuşu! (Kestrel Engine/IIS)
dotnet run --project src/UltimateCommerce.WebUI
```

**Bravo Usta Otonomi!** 
Şu andan itibaren her projen senin eserin olacak, ve bu 4-katmanlı C# Mimarisi bir daha asla spagetti kodlara, "Yellow Screen of Death" ekranlarına, N+1 kilitlenmelerine veya Mass Assignment saldırılarına yenik düşmeyecek! 

**SİSTEM HAZIR. THE MATRIX IS AWAITING!**
