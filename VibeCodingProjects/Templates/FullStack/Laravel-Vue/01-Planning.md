# 📋 Planning — Laravel + Vue (PHP Full Stack — Inertia.js veya API + SPA)

## 🎯 Proje
- **Backend:** Laravel 11 (MVC) — Eloquent ORM
- **Frontend:** Vue 3 (Inertia.js veya standalone SPA)
- **DB:** MySQL / PostgreSQL
- **ORM:** Eloquent (Active Record Pattern)

## 🛠️ Tech Stack
| Katman | Backend | Frontend |
|--------|---------|----------|
| Framework | Laravel 11 | Vue 3 |
| ORM | Eloquent | — |
| Auth | Sanctum (SPA) / Passport | Pinia + Axios |
| Bundler | — | Vite (Laravel Vite Plugin) |
| SSR Option | Inertia.js | Vue SSR |

## İki Yaklaşım
| Yaklaşım | Ne zaman? |
|-----------|-----------|
| **Inertia.js** (Laravel + Vue tek proje) | Monolith, hızlı geliştirme, SEO az önemli |
| **API + SPA** (ayrı backend/frontend) | Microservice, mobil app de var, REST API gerekli |

# 🏗️ Architecture (Inertia.js)
```
project/
├── app/
│   ├── Http/Controllers/ (PageController, ProductController)
│   ├── Models/ (User.php, Product.php)
│   ├── Services/ (ProductService.php)
│   └── Policies/
├── resources/
│   ├── js/
│   │   ├── Pages/ (Home.vue, Products/Index.vue, Products/Create.vue)
│   │   ├── Components/ (AppLayout.vue, Button.vue)
│   │   ├── Composables/ (useForm.js)
│   │   └── app.js
│   └── views/ (app.blade.php — Inertia root)
├── routes/ (web.php)
├── database/ (migrations/, seeders/)
└── vite.config.js
```

## Eloquent ORM Best Practices
```php
// Eager loading (N+1 önleme)
Product::with(['category', 'tags'])->paginate(20);

// Scopes (tekrar kullanılabilir query)
public function scopeActive($query) { return $query->where('is_active', true); }
Product::active()->where('price', '>', 100)->get();

// Accessors & Mutators
protected function fullName(): Attribute {
    return Attribute::make(
        get: fn() => "{$this->first_name} {$this->last_name}",
    );
}
```

# 📝 Steps | 🐛 Debug | 📚 Resources
## Steps: `composer create-project laravel/laravel` → Breeze/Jetstream (Vue + Inertia) → models → controllers → Vue pages
## Debug: N+1 → `with()`, CSRF → `@csrf`, Mass assignment → `$fillable`, Inertia 419 → session
## Resources: laravel.com, vuejs.org, inertiajs.com, laracasts.com
