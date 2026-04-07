# 🐛 Debug Tips — .NET + Angular

## Backend
- **CORS**: `app.UseCors()` → `UseRouting()` sonra, `UseAuth()` önce
- **JWT**: `appsettings.json` → Secret min 32 char, Issuer/Audience eşleşmeli
- **EF Core**: `dotnet ef database update` → migration uygulanmış mı?
- **Identity**: `UserManager.CreateAsync()` → password policy'ye uygun mu?
- **AutoMapper**: `CreateMap<Source, Dest>()` tanımlı mı? Assembly scan doğru mu?

## Frontend
- **rxjs memory leak**: Template'de `| async` kullan → otomatik unsubscribe
- **Lazy loading fail**: `loadChildren` path doğru mu? `export const ROUTES` var mı?
- **Material theme**: `angular.json` → styles array'e `@angular/material/prebuilt-themes/`
- **Form validation**: `form.get('field')?.errors` ile kontrol et
- **Environment**: `ng build --configuration production` → `environment.prod.ts`

## Integration
- **CORS + Credentials**: `withCredentials: true` ise backend'de `AllowCredentials()` gerekli
- **Proxy (dev)**: `proxy.conf.json` → `ng serve --proxy-config proxy.conf.json`

## 📓 Debug Günlüğü
| Tarih | Katman | Hata | Çözüm |
|-------|--------|------|--------|
| [—]   | [—]    | [—]  | [—]    |
