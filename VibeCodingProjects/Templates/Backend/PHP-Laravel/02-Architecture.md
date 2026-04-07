# 2️⃣ PHP-Laravel - Güçlü Sistem Mimarisi & Kod Standartları (Clean Architecture)

> **ZORUNLU MİMARİ NOTU:** 
> Yapay zeka bu dosyada belirtilen servis yönelimli katmanlar (Service-Oriented / Clean Architecture) prensiplerini sadece bir "öneri" olarak GEÇİŞTİREMEZ, bu prensipler Otonom Ajanın anayasasıdır!
> 
> "Fat Controller, Fat Model" anti-pattern'ı (şişman dosyalar) artık eskide kaldı. Modern Laravel endüstrisi, uygulamanın beynine her şeyi doldurmayı yasaklıyor. Otonomi Sistemi N-Tier izole katmanlara BÖLMEK Zorundadır!

---

## 🏗️ 1. İskelet İzolasyonu: Klasörler ve Sorumlulukları 

Otonom ajan Laravel projesini başlattığında default olarak gelmeyen, ancak oluşturulması mecburi (ZORUNLU) olan "Service" ve "DTO/Helpers" katmanlarını tasarlar.

### 🌐 HTTP Kalkanı Katmanı (Controllers)
* **Kapsam:** `/app/Http/Controllers` dizinindeki sınıflardır.
* **Ne Yapar?** Sistemin kuryesidir (Postacı). HTTP trafiğini karşılar. Sadece REST rotalarını belirler.
* **NE YAPAMAZ? (Kurumsal Yasak):** Asla veritabanından karmaşık `Where In`, `join` sorguları çağıramaz (`User::where(...)->get()`). Form Validation'ı kendi içine sıkıştıramaz. Dış servislere API Request (Guzzle, Http::post) gönderici komutları İHTİVA EDEMEZ. 

### 🛡️ Karantina Kapısı (Form Requests)
* **Kapsam:** `/app/Http/Requests` dizini.
* **Ne Yapar?** Müşterinin gönderdiği (Payload) JSON datasını, Controller kapısından girmeden önce Doğrulayan (String mi? E-Posta mı? Boş mu?) Özel sınıftır. Gelen veride kötü amaçlı Injection tespit ederse, doğrudan `422 Unprocessable Entity` JSON cevabını müşteriye fırlatır ve kodun devamının çalışmasını ENGELLER.

### 🧠 Beyin Korteksi (Service Pattern)
* **Kapsam:** `/app/Services` dizini (Otonomi tarafından Yaratılmak zorundadır).
* **Ne Yapar?** Tüm uygulama kuralları (Business Logic / İş Zekası). Sepetteki %10 indirim algoritması, üçüncü parti ERP entegrasyon tetiklemeleri, veritabanına Çoklu Kayıt (Bulk Insert) işlemleri burada gerçekleşir. 
* **Avantajı:** Test edilebilir kod yaratır. İleride Controller (API) yerine bir Console Command (Artisan command) yazdığınızda, aynı servisi zahmetsizce çağırabilirsiniz. 

### 💎 Formatter Çeviriciler (API Resources)
* **Kapsam:** `/app/Http/Resources` dizini.
* **Ne Yapar?** Gelen Veritabanı Entity'lerini json objelerine eşleyen (MapStruct / DTO mantığıyla çalışan) Laravel zırhıdır. Kredi kartı Token veya Password bilgisinin yanlışlıkla müşteriye "JsonResponse" diye kusulmasını önler!

---

## ⚡ 2. Hata Yönetimi: The Exception Kalkanı

Otonom mimari her zaman çökmeleri hesaplar. Müşteri (Client), Laravel'in geliştirici ekranını "Whoops, looks like something went wrong!" (HTML veya Devasa Stack Trace kodlarını) ASLA GÖREMEZ!

### Otonom Global Handler Yöneticisi
Laravel `>= 11` sürümlerinde `bootstrap/app.php` içerisinde veya daha eski sürümlerde `app/Exceptions/Handler.php` dosyasında bütün istisnai hatalar Json formatında Merkezileştirilir. 

**Model Not Found Zırhı:** (Biri veritabanında olmayan id ile data istediğinde)
```php
// app/Exceptions/Handler.php VEYA bootstrap/app.php Zırhı
public function register(): void
{
    // Bütün Model Hatalarını Yakala ve Tertemiz 404 dön (Asla çöktürme)
    $this->renderable(function (ModelNotFoundException $e, $request) {
        if ($request->is('api/*')) {
            return response()->json([
                'success' => false,
                'message' => 'Aradığınız veri sunucuda bulunamadı!'
            ], 404);
        }
    });

    // Validasyon Hatalarını Birleştir VE Çöktürme!
    $this->renderable(function (ValidationException $e, $request) {
        if ($request->is('api/*')) {
            return response()->json([
                'success' => false,
                'message' => 'Geçersiz veri gönderdiniz.',
                'errors' => $e->errors()
            ], 422);
        }
    });
}
```

---

## 🛡️ 3. Çevre (Environment) Tembelliği Zararları

`config` VE `.env` zafiyetleri PHP projelerinde kritiktir.

### Kural: Doğrudan env() Kullanma Yasağı!
Otonomi veya Geliştirici, Controller veya Service içerisinde asla doğrudan `$apiKey = env('STRIPE_SECRET');` YAZAMAZ!!
Çünkü sunucu "Production" ortamında `php artisan config:cache` çalıştırdığı anda `.env` dosyası KİTLENİR (Optimize edilir) ve tüm `env()` çağrıları `null` (Boş) dönmeye başlar! Sistemin ÇÖKER!

**Doğru Zırh:** `.env` deki şifre veya port bilgisi `config/services.php` (vey ilgili conf dosyası) içine yazılır ve proje içinde HEP `config('services.stripe.secret')` Kullanılır!!!

---

## 👁️ 4. Artisan Console ve Kod Üretici (Scaffolding) Emirleri

Otonomi ajan projeyi hızlandırmak için spagetti kopyala-yapıştır yapmaz. Özel Maker emirleri vererek projenin kendi iskelet inşasını Mühürler:

```bash
# Kurumsal Bütün N-Tier yapısıyla Controller, Model, Request, Resource çıkarma (Ajan emri)
php artisan make:model Product -mcr

# Bağımsız Mimariler Üretimi
php artisan make:request StoreProductRequest
php artisan make:resource ProductResource
```
**`make:model Product -mcr`** the Otonom komutu (Migration, Controller, Resource) hepsini güvenli, sınıflandırılmış (class) formatta TEK HAMLEDE çıkartır. VibeCoding Enterprise Laravel kalitesi tam da budur! Sistemin yürümesi ve Mimarinin inşası için bu kanunlar geçerlidir!
