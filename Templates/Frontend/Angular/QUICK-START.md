## SEQUENCE-ENGINE v1 (ZORUNLU)
Bu template ile çalışırken sırayı bozmak yasak:
1) QUICK-START.md
2) 01-Planning.md
3) 02-Architecture.md
4) 03-StepByStep.md
5) 04-FilesStructure.md
6) 05-DebugTips.md
7) 06-Resources.md

Kural:
- Her dosyadan sonra 3-5 maddelik "çıkarım özeti" yaz.
- Özeti yazmadan sonraki dosyaya geçme.
- 7 dosya tamamlanmadan kod üretimine başlama.
- Bu akışın detay standardı: Templates/_Universal/TEMPLATE-SEQUENCE-ENGINE.md

---
# Angular / ASP.NET MVC için Otonom Kurumsal Direktifler (QUICK-START & Master Yasaklar)

> **DİKKAT YAPAY ZEKA:**
>
> Bu doküman, kurumsal seviyede çalışan bir Angular / MVC uygulaması üretirken uyulacak temel kuralları tanımlar.
> Hedefimiz; temiz mimari, yüksek performans, güvenlik ve sürdürülebilirliktir.

---

## Bölüm 1: Kesin Yasaklar Listesi

Razor (`.cshtml`) sayfalarında, controller'larda veya Angular bileşenlerinde aşağıdaki anti-pattern'ler bulunmamalıdır.

### 1. İş mantığını controller içine yığmak yasaktır

Controller, sadece isteği karşılar, doğrular ve servise iletir. Veritabanı erişimi, şifreleme, e-posta gönderimi ve domain logic controller içinde yazılmaz.

```csharp
// Kötü kullanım: controller içinde business logic
[HttpPost]
public IActionResult Register(User user)
{
   var existingUser = _db.Users.FirstOrDefault(x => x.Email == user.Email);
   if (existingUser != null) { return View("Error"); }

   user.Password = HashPassword(user.Password);
   _db.Users.Add(user);
   _db.SaveChanges();

   return RedirectToAction("Index");
}
```

```csharp
// Doğru kullanım: controller sadece akışı yönetir
[HttpPost]
public async Task<IActionResult> Register(UserRegisterViewModel model)
{
   if (!ModelState.IsValid)
      return View(model);

   var dto = _mapper.Map<UserRegisterDto>(model);
   var result = await _authService.RegisterAsync(dto);

   if (!result.Success)
   {
      ModelState.AddModelError("", result.Message);
      return View(model);
   }

   return RedirectToAction("Login", "Auth");
}
```

### 2. Gerçek entity sınıfını forma basmak yasaktır

Formlar ve view'lar için daima ViewModel kullanılır. Entity doğrudan view'a verilmez.

### 3. CSS ve JavaScript'i sayfanın tepesine yığmak yasaktır

Scriptler layout içinde body kapanışından önce `@section Scripts` ile yüklenir. Stil dosyaları ayrı tutulur.

### 4. CSRF korumasını unutmak yasaktır

POST işlemlerinde `Html.AntiForgeryToken()` ve `[ValidateAntiForgeryToken]` kullanılır.

---

## Bölüm 2: Zorunlu Mimari Yapı

Kurumsal yapı 4 katman olarak kurgulanır:

```text
/Solution
 ├── /Domain      (Entity ve çekirdek kurallar)
 ├── /DataAccess  (DbContext ve repository)
 ├── /Business    (Service katmanı ve iş kuralları)
 └── /WebUI       (ASP.NET Core MVC / Angular UI katmanı)
```

---

## Bölüm 3: Otonom İnşa Kılavuzu

### Adım 1: Domain katmanını oluştur

Temel entity'leri, audit alanlarını ve bağımlılıktan arındırılmış domain modelini yaz.

### Adım 2: DataAccess ve repository kur

DbContext, repository ve veri erişim sözleşmelerini oluştur.

### Adım 3: Dependency Injection altyapısını kur

Servis kayıtları extension methodlar ile düzenli biçimde eklenir.

### Adım 4: Asenkron akışı koru

Tüm action'lar asenkron çalışır; senkron ve bloklayıcı akış tercih edilmez.

### Adım 5: ViewComponent yaklaşımını kullan

Sidebar, navbar ve dinamik parçalar için tekrar eden partial yerine ViewComponent tercih edilir.

---

## Sonuç

1. SOLID prensipleri korunur.
2. Hata yönetimi görünür, kullanıcıya ham exception gösterilmez.
3. Mimari, controller'dan değil servis ve domain'den yönetilir.

**Temiz mimariyle ilerle, kodu katmanlara ayır ve güvenliği koru.**

