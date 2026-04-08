# 1️⃣ PHP-Laravel - Kurumsal Ön Planlama ve Sistem Analizi (Enterprise Planning)

> **"Laravel, dünyadaki en yetenekli ve en tehlikeli derecede affedici PHP framework'üdür."** 
> 
> Otonom bir yapay zeka (AI) olarak, Laravel tabanlı bir API Veya Backend projesi geliştirmeye başlarken bilmen gereken en hayati kural şudur: Laravel'de her şeyi yapmanın 10 farklı yolu vardır ama Enterprise (Kurumsal) dünyada sadece TEK 1 doğru kural (Desing Pattern) işler. Diğer 9 yol sistemi "Spagetti Code" bataklığına sürükler.
> 
> Otonomi; MVC'nin ötesinde DTO'lar, Form Request'ler, Event-driven architecture ve Service class'larıyla kalkanlanmış "Senior Level" projeler inşaa eder!

---

## 🏗️ 1. Mimari Kararı: Model-View-Controller (MVC) Yanılgısı ve Service Pattern Zırhı

Laravel default (varsayılan) olarak klasik MVC yapısını sunar. Acemi (Junior) geliştiriciler Controller (`UserController.php`) içerisine tüm Veritabanı arama, kaydetme ve API çağırma (Business Logic) kodlarını kusa. 

Otonom Ajan Bütün Sistemi Şöyle İzole Edecektir:
* **Controller:** Yalnızca Gelen HTTP İsteğini (`Request`) alır, Form Request Sınıfı Değerlendirir, veriyi "Service" Katmanına aktarır ve Dönen JSON objesini formatlayıp bırakır. TEK SATIR "Business Logic" Veya Veritabanı kodu BARINDIRAMAZ!
* **Service Sınıfları (`/app/Services`):** SİSTEMİN BEYNİ. Laravel default olarak Services klasörü açmaz. OTONOMİ ilk iş bu klasörü oluşturup (`UserService.php`) Tüm Eloquent veritabanı CRUD operasyonlarını, e-mail gönderme asenkron işlerini ve Indirim (Discount) mantıklarını buraya Zırhlayacaktır!
* **Repository Pattern (Tartışmalı Seçenek):** Laravel zaten çok güçlü bir `Eloquent ORM` ActiveRecord desenini barındırır. Repository kurgulamak genellikle israfdır. Otonomi, Eloquent modelini Doğrudan Service sınıfının içerisinden güvenle çekebilir.

---

## 🛡️ 2. Veri Doğrulama Zırhı (Validation ve Form Request Mühürü)

PHP gibi tip güvenliği gevşek dillerde (PHP 8.x Type-hinting ile dahi) güvenlik zaafiyetleri (SQL Injection ve Mass Assignment) Controller validation zaaflarından doğar.

### Klasik Validasyon (YASAKTIR!):
```php
// OTONOM BÖYLE SPAGETTİ YAZAMAZ!
public function store(Request $request) {
    // Model Doğrulamasını Controllerin İçine yazıp Kirletmek (Ameleliktir!)
    $validated = $request->validate([
        'title' => 'required|unique:posts|max:255',
        'body' => 'required',
    ]);
    // Veritabanı kodunu controller'a koymak (Facia!)
    Post::create($validated);
}
```

### Otonom Form Request Kalkanı (Kurumsal Standard)
Otonom zeka `php artisan make:request StoreUserRequest` emrini çalıştırıp veriyi Controller'a ulaşmadan kapıda (Middleware ile) doğrulayacaktır.

```php
// app/Http/Requests/StoreUserRequest.php
public function rules(): array
{
    // Bütün Kalkanlar Controller'dan İZOLE Olarak burada tutulur.
    return [
        'email' => ['required', 'string', 'email', 'max:255', 'unique:users'],
        'password' => ['required', 'string', 'min:8', 'confirmed'],
    ];
}

// app/Http/Controllers/UserController.php
// BURASI ARTIK TERTEMİZ DİMDİK BİR MİMARİ! (ZIRHLANDI)
public function store(StoreUserRequest $request) {
    $user = $this->userService->createUser($request->validated());
    return response()->json(['data' => $user], 201);
}
```

---

## 🔐 3. Authentication (Kimlik) Mimarisi 

Laravel MVC web projelerinde `Session` veya `Breeze` kullanabilir ancak Enterprise seviyesinde Modern Mimari "Backend API + Frontend SPA (React/Vue/Flutter)" olarak şekillenir.

### Laravel Sanctum Veya Passport Zırhı
* Otonomi, dış dünyaya açılan (REST API) modern sistemlerde ASLA stateful session kullanmaz. Token Based Mimarisi geliştirir.
* Hafif ve modern API ler için **Laravel Sanctum** zırhı projenin omurgasıdır. İstekler `Authorization: Bearer <TOKEN>` Mühürü ile denetlenir. 
* `/routes/api.php` içerisindeki tüm hassas endpointler `auth:sanctum` Middlewaresi içine sıkıştırılıp koruma altına alınacaktır.

---

## 🚀 4. Sinerjik Tasarım: DTO ve Resource'lar 

### Eloquent Model Sızıntıları 
Bir Controller içerisinden doğrudan `$user = User::find($id); return response()->json($user);` çağırıldığında kullanıcının veritabanı ID'si, Şifre Hash'i veya gizli token alanları JSON cevabına SIZAR. `hidden` (Model Koruması) pratik olsa da enterprise da The DTO Pattern kullanılır!

### API Resources (Kurumsal Yanıtlayıcılar)
Otonom Zeka `php artisan make:resource UserResource` Zırhını Kullanır.
* UserResource sınıfı, Veritabanından (Eloquent) gelen karmaşık $User obnesini sadece müşterinin (Client) görmesi gereken formatlı alanlara ÇEVİRİR.
* Otonomi, hiçbir zaman Ham Model nesnesini müşteriye cevap oalrak kusmaz!

Kurumsal Laravel Otonomisi tam olarak BÖYLEDİR! Controller ince, Form Request zırhlı ve Servisler Beyindir!
