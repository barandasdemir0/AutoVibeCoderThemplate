# 🏗️ Architecture | 📂 Files | 🐛 Debug | 📚 Resources — Laravel + Vue

## Dosya Açıklamaları
| Dosya | Ne İş Yapar |
|-------|-------------|
| `app/Models/*.php` | Eloquent ORM: DB tablo tanımı, ilişkiler, scope'lar |
| `app/Http/Controllers/*.php` | Request → business logic → Inertia/JSON response |
| `app/Services/*.php` | Controller'dan ayrılmış iş mantığı |
| `resources/js/Pages/*.vue` | Inertia sayfa bileşenleri (route = component) |
| `resources/js/Components/*.vue` | Paylaşılan UI bileşenleri |
| `database/migrations/*.php` | DB şema değişiklikleri (version control) |
| `routes/web.php` | Inertia route tanımları |
| `routes/api.php` | REST API endpoints (SPA modunda) |

## Inertia.js Akışı
```
Laravel Route → Controller → Inertia::render('Page', props)
    → Vue Component (Props olarak veri alır)
    → Form: Inertia.post('/products', data) → Controller → redirect
```

## Debug Tips
| Sorun | Çözüm |
|-------|-------|
| N+1 Query | `Product::with('category')` → Eager loading |
| 419 Expired | CSRF token / Session expired → Sanctum config |
| Mass Assignment | Model'de `$fillable` array tanımla |
| Inertia partial reload | `router.reload({ only: ['products'] })` |
| Vite HMR yavaş | `vite.config.js` → `server.hmr.host` kontrol |

## Resources
| Kaynak | Link |
|--------|------|
| Laravel | https://laravel.com/docs |
| Inertia.js | https://inertiajs.com |
| Vue 3 | https://vuejs.org |
| Laracasts | https://laracasts.com |
| Laravel Breeze | https://laravel.com/docs/starter-kits |

## CLI
```bash
composer create-project laravel/laravel project
composer require laravel/breeze --dev
php artisan breeze:install vue --inertia
npm install && npm run dev
php artisan serve
```

## Debug Günlüğü
| Tarih | Katman | Hata | Çözüm |
|-------|--------|------|--------|
| [—]   | [—]    | [—]  | [—]    |
