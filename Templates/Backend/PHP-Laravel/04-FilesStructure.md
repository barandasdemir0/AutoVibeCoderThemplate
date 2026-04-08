# 4️⃣ PHP-Laravel - Katı Kurumsal Klasörleme (File Structure)

> **ZORUNLU DİZİLİM MÜHÜRLERİ:**
>
> Laravel framework'ü o kadar esnektir ki, sizi belirli bir yapıya asla zorlamaz. Ancak Milyon Dolarlık (Enterprise) ürünlerde bu "Esneklik", "Çöküş" ile eş anlamlıdır.
>
> Mimar! Otonom bir PHP/Laravel projesi geliştirirken, framework'ün sana verdiği "Controllers", "Models" ve "Migrations" sınırları içinde KISILIP KALAMAZSIN. Service-Oriented (Servis Odaklı) Mimari klasör düzenini otonom olarak İNŞAA ETMEK ZORUNDASIN!

---

## 📂 1. Kurumsal Laravel Klasörleme Vizyonu (`app` Altı Dağılım)

Otonom zekanın Laravel projelerinde kullanacağı "Altın Standart" klasör hiyerarşisidir. Hem Service-Oriented Architecture (SOA) kurallarına hem de Data Transfer Object (DTO) standartlarına mükemmel olarak uyarlanmıştır.

```text
EnterpriseLaravelApp/
├── app/                                    (TÜM MİMARİNİN ÇEKİRDEĞİ)
│   ├── Enums/                              (OTONOMİ OLUŞTURACAK: String durumlarını Yasaklar!)
│   │   ├── OrderStatus.php                 (Örn: 'PENDING', 'PAID', 'SHIPPED')
│   │   └── UserRole.php                    (Örn: 'ADMIN', 'CUSTOMER')
│   │
│   ├── Exceptions/                         (Özel Hata Kalkanları)
│   │   ├── InsufficientBalanceException.php
│   │   └── InvalidCredentialsException.php
│   │
│   ├── Helpers/                            (Genel Araçlar - Static)
│   │   └── ApiResponse.php                 (Bütün JSON dönüş biçimini Standartlaştıran Sınıf)
│   │
│   ├── Http/                               (SUNUM KATMANI / HTTP POSTACILARI)
│   │   ├── Controllers/
│   │   │   ├── Api/v1/                     (VERSİYONLAMA ZORUNLUDUR!)
│   │   │   │   ├── AuthController.php      (Req alır, Validasyon Yapar, Servise Atar)
│   │   │   │   └── ProductController.php   
│   │   │
│   │   ├── Middleware/                     (GÜVENLİK VE KORUMA DUVARLARI)
│   │   │   ├── EnsureAdminIsUser.php       (Erişim Yetki Kontrolleri - Role Guard)
│   │   │   └── RequestLogger.php
│   │   │
│   │   ├── Requests/                       (ZIRHLI VALIDATION / GİRİŞ KAPISI)
│   │   │   ├── Auth/
│   │   │   │   ├── LoginRequest.php        (Payload Doğrulama - email & password rules)
│   │   │   │   └── RegisterRequest.php
│   │   │
│   │   └── Resources/                      (DTO / RESOURCE FORMNATTER)
│   │       ├── ProductResource.php         (Modelin içinden secret kolonlarını süzüp Müşteriye Yollar)
│   │       └── UserResource.php
│   │
│   ├── Models/                             (VERİTABANI TEMSİLCİLERİ / ORM Entity)
│   │   ├── Traits/                         (Modeller arası Ortak Kod Zincirleri / UUID Kullanımı vs)
│   │   ├── Product.php                     (Eloquent Query Builder burada son bulur)
│   │   └── User.php                        
│   │
│   ├── Providers/                          (SİSTEM ÇEKİRDEK İZOLASYONLARI)
│   │   ├── AppServiceProvider.php          (Observer Tanımlama / Sanctum Bindings)
│   │   └── RouteServiceProvider.php        (Laravel 10 ve Öncesi için Route Tanımlamaları)
│   │
│   └── Services/                           (BEYİN KORTEKSİ / İŞ KURALLARI OTONOMİ MÜHÜRÜ)
│       ├── Auth/
│       │   └── AuthService.php             (Token Üretme, Giriş Algoritması)
│       ├── Payment/
│       │   └── StripePaymentService.php    (Dış API Entegrasyonları)
│       └── Product/
│           └── ProductService.php          (Veritabanı CRUD Logic ve Hesaplamaları)
│
├── bootstrap/                              (LARAVEL > 11 MİMARİ CHASSIS)
│   ├── app.php                             (Tüm Global Exception Yönetimi ve Route Tanımlamaları Buradadır!)
│   └── providers.php                       (Uygulama sağlayıcıları)
│
├── config/                                 (GLOBAL DEĞİŞKENLER VE GİZLİLİK ZIRHI)
│   ├── app.php
│   ├── database.php
│   └── services.php                        (Stripe, AWS Gibi dış API Key'leri)
│
├── database/                               (SQL ŞEMA KALKANLARI)
│   ├── factories/                          (Test Verisi Üreticileri)
│   ├── migrations/                         (Zaman Çizelgeli SQL Güncelleme Dosyaları)
│   └── seeders/                            (Veritabanı Başlatıcı Default Veriler - Admin User)
│
├── routes/                                 (YÖNLENDİRME HARİTASI)
│   ├── api.php                             (TÜM REST API ROTALARI: Route::apiResource())
│   ├── console.php                         (Zamanlanmış Görevler - Cron Jobs)
│   └── web.php                             (Önceki Nesil HTML rendering rotaları. API Otonomisinde Mümkünse BOŞ bırakılır)
│
├── storage/                                (SİSTEM LOJİSTİĞİ VE LOGLAR)
│   ├── app/                                (Kullanıcı Dokümanları veya Fotoğrafları)
│   └── logs/                               (Sistem Çöküş Logları: laravel.log)
│
├── tests/                                  (OTONOM TEST MİMARİSİ)
│   ├── Feature/                            (Endpoint (API Rota) Testleri)
│   └── Unit/                               (Küçük Sınıf, Hesaplama ve Servis Testleri)
│
├── .env                                    (YASAKTIR! Çevresel Şifreleme. Github'a İletilmez!)
├── phpstan.neon                            (Statik Kod Güvenliği Kuralları)
└── pint.json                               (Laravel Kod Formatlama Stili Kuralları)
```

---

## ⚠️ 2. Kritik Klasörleme Yasaları ve OTONOM MÜHÜRÜ

Bir Otonom Yapay Zeka Ajanı Laravel inşa ederken bu klasik ve ölümcül hatalardan birini yaparsa, Bütün Mimari Spagetti olarak etiketlenir!

### Yasak 1: "Controller" İçerisinde Form Validation Kullanımı (Spagetti Form)
Yapay zeka hiçbir `Controller` içerisine `request()->validate([...])` YAZAMAZ!! Tüm validation kuralları ZORUNLU olarak Form Request Sınıflarında (`app/Http/Requests`) izole edilecektir. Controller sadece `$request->validated()` fonksiyonunu çağırabilir!

### Yasak 2: "routes/api.php" Klasöründe Closure (Anonim Fonksiyon) Katliamı
Routing (Yönlendirme) klasörünün yegane vazifesi "Kavşak" olmaktır. Rota Dosyasında Kesinlikle:
`Route::get('/users', function() { return User::all(); });`
Gibi Spagetti satırları yazılamaz! Tüm rotalar katı olarak İlgili Controller fonksiyonuna yönlendirilmelidir. `[UserController::class, 'index']`

### Yasak 3: Service Sınıflarına (HTTP Request - Response) Düşürülmesi!
`UserService` klasöründeki metodlar `(Request $request)` objesini asla alamaz! Request objesi Express veya Laravel ortamında sadece HTTP Dünyasına aittir. Servis (Beyin), HTTP Request'ini çözemez. Servis Sadece Otonom "Array" veya "DTO" Verisini argüman olarak alır! JSON dönmek Controller'ın (Postacı) görevidir!
