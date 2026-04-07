# 3️⃣ PHP-Laravel - Endüstriyel Kurulum ve Altyapı Adımları (Step-By-Step Setup)

> **OTONOM MİMARİ BAŞLATICI UYARISI:**
>
> Yapay Zeka ajanı, projeyi başlatırken sadece `composer create-project` yazıp geri çekilemez!
> Kurumsal bir PHP projesi için varsayılan Laravel iskeleti sadece bir "Başlangıç Sürümü" (Lite version) gibidir. Otonomi, projenin içerisine anında DTO, Repository, Enum ve Service Design pattern klasörlerini zorla enjekte edecektir! 
> 
> İşte bir VibeCoding Otonom Ajanının izlemesi gereken Kusursuz Terminal Zırhlama Sıralaması:

---

## 🚀 FAZ 1: İskelet Kurulumu (The Core Scaffold)

Otonom ajan terminale iner ve Laravel Composer mimarisini ayağa kaldırır.

### Adım 1: Projenin Yaratılması ve İsimlendirilmesi
```bash
# Sadece en güncel (stable) Laravel sürümü kabul edilir
composer create-project laravel/laravel EnterpriseLaravelApp

# Çalışma klasörüne in
cd EnterpriseLaravelApp

# İlk Git mühürünü vur
git init
```

### Adım 2: Formatter ve Statik Kod Analizi (Kurumsal Çizgi)
Bir ajan kod yazarken PHP'nin o gevşek (Loose) tiplerine güvenemez. Anında `Larastan` ve `Pint` (veya `PHP_CodeSniffer`) zırhlarını indirir.
```bash
# Kod standartlarını hizalamak için (Laravel Pint zaten yüklü gelir)
composer require --dev nunomaduro/larastan

# Otonom Kontrol İçin Çalıştır:
./vendor/bin/phpstan analyse app --level=max
```
*Kural:* Otonom ajan, projeyi teslim etmeden önce PHPStan analizini (Level Max) geçmek ZORUNDADIR!

---

## 🗄️ FAZ 2: Veritabanı ve Migration Dizaynı (Data Layer)

Model (SQL Tabloları) mimarilerini tasarlarken "Spagetti Kod" Olamaz. Ajan, sadece Entity ID, Timestamps ve kilit kolonlarla veritabanı kurgusunu MİMARİ OLARAK çizer.

### Adım 3: .env Entegrasyonu ve Mühürleri
Otonomi `config/database.php` İle oynamaz. Doğrudan `.env` yapılandırmasına gömülür.

```env
# Müşterinin Veritabanı Zırhı
DB_CONNECTION=mysql # veya postgresql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=enterprise_db
DB_USERNAME=root
DB_PASSWORD=secret_password
```

### Adım 4: The Master Artisan (Kod Üretimi)
Otonomi her parçayı elle yapmaz, Laravel Artisan komutlarına kendi "Service Mimarisini" entegre eder:

```bash
# Kullanıcılar için Tüm MVC (Controller, Model, Migration) kalkanını yaratır
php artisan make:model Product -mcr

# Veri girişi için Form Request (Zırh) Kalkanlarını yaratır
php artisan make:request StoreProductRequest
php artisan make:request UpdateProductRequest

# Dış dünyaya Model sızıntısını engelleyen DTO/Resource dönüşümü
php artisan make:resource ProductResource
```
**BİLGİ:** Laravel Service sınıfları için standart bir komut barındırmaz. Otonomi `app/Services` klasörünü manuel olarak "mkdir" komutu ile YARATIR!

---

## 🏗️ FAZ 3: Otonom Kodlama Mimarisi (Kalkanların Örülmesi)

Ajan, `app` klasörünün içindeki yapıyı "Clean Architecture" kurallarına göre bağlamaya başlar.

### Adım 5: Gelişmiş Exception Yönetimi (The Error Trap)
API projelerinde Müşteri bir hata aldığında (Örneğin 404), sistemin HTML veya Laravel Hata Ekranı dönmesi İPTAL EDİLİR! Otonomi `bootstrap/app.php` dosyasına sızar ve JSON hata zırhını kodlar.

```php
// bootstrap/app.php (Laravel >= 11 Mimarisi)
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        // Güvenlik Middleware (CORS vs) buraya eklenir
    })
    ->withExceptions(function (Exceptions $exceptions) {
        $exceptions->render(function (Throwable $e, $request) {
            if ($request->wantsJson() || $request->is('api/*')) {
                return response()->json([
                    'success' => false,
                    'error' => [
                        'message' => $e->getMessage(),
                        'code' => $e->getCode()
                    ]
                ], $e->getCode() ?: 500);
            }
        });
    })->create();
```

---

## 🚀 FAZ 4: Sanctum API ve Stateful Sınırlarının Çizilmesi

Birçok geliştirici `Session` veya `Cookies` e güvenir. Ancak otonomi sistemi Yatay Ölçeklenebilir (Horizontal Scalable) yapmak için REST API'lerde (Mobil Uygulamalar için) Token tabanlı kimlik denetimine geçer.

### Adım 6: Sanctum Konfigürasyonu
```bash
# Laravel 11'de API rotalarını ve Sanctum zırhını devreye sokma:
php artisan install:api
```
Bu Otonom Komut `routes/api.php` dosyasını yaratır ve Laravel Sanctum'u entegre eder.
Artık Kullanıcı Login (Giriş) olduğunda Otonomi Controller İçerisinden ` $user->createToken('MobileApp')->plainTextToken; ` mühürünü Müşteriye Göndermek zorundadır!

### Adım 7: Deployment (Yayın) Hızlandırma Komutları
Sunucuya (AWS/DigitalOcean) geçerken sistem otonom olarak şu mühürleri basarak Optimize eder:
```bash
# Route, Config ve View Kalkanlarını (Performans) Kilitle:
php artisan optimize:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

**Başarı!** Mimari sistem artık PHP'nin vahşi doğasında Controller Spagettisi olmadan API rotaları üzerinden güvenle yayın (Broadcast) yapmaya hazırdır!
