# Starter Blueprint — PHP Laravel (MVC + Service + Eloquent + Sanctum)
## Mimari: MVC + Service Layer
## Klasör Yapısı (Laravel default + service layer)
```
app/
├── Models/User.php           → Eloquent model ($fillable, $hidden, $casts)
├── Http/
│   ├── Controllers/AuthController.php, UserController.php
│   ├── Middleware/
│   ├── Requests/LoginRequest.php, RegisterRequest.php   → Form Request validation
│   └── Resources/UserResource.php                       → API Resource
├── Services/UserService.php  → İş mantığı (Controller'da tutma!)
├── Repositories/UserRepository.php → DB soyutlama (opsiyonel)
config/                       → app.php, auth.php, cors.php, sanctum.php
database/migrations/
routes/api.php                → Route::apiResource, Route::group
.env.example
```
## Paketler: laravel/sanctum, intervention/image (opsiyonel)
## Komutlar: php artisan make:model/controller/migration/request/resource
