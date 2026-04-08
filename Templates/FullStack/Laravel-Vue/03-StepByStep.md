# 📝 Step-by-Step | 📂 Files | 🐛 Debug | 📚 Resources — Laravel + Vue (03-06)
## Steps
1. [ ] `composer create-project laravel/laravel project`
2. [ ] `composer require laravel/breeze --dev` → `php artisan breeze:install vue`
3. [ ] `npm install && npm run dev`
4. [ ] Models + Migrations → `php artisan migrate`
5. [ ] Controllers → Inertia::render() veya API response
6. [ ] Vue Pages → Props ile veri al
7. [ ] Auth → Breeze built-in (login, register, profile)
8. [ ] `php artisan serve` + `npm run dev` (2 terminal)

## Files
```
app/ (Models/, Http/Controllers/, Services/, Policies/)
resources/js/ (Pages/, Components/, Composables/, app.js)
database/ (migrations/, seeders/)
routes/ (web.php, api.php)
```

## Best Practices
- **Eloquent**: `$fillable`, `$casts`, `with()` eager loading
- **FormRequest**: Validation logic controller'dan ayır
- **Inertia**: Props ile server data, `useForm()` ile form submit
- **Naming**: Model → tekil PascalCase, Migration → timestamp_snake_case

## Debug Günlüğü
| Tarih | Hata | Çözüm |
|-------|------|--------|
| [—]   | [—]  | [—]    |
