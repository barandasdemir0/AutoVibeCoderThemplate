# 🐛 Debug Tips — .NET + React FullStack

## Backend (.NET)
- **CORS**: `app.UseCors("React")` → Pipeline sırası önemli (UseRouting'den sonra)
- **JWT Config**: `appsettings.json` → Secret en az 32 karakter
- **EF Core**: `dotnet ef database update` → migration uygulanmış mı?
- **AutoMapper**: `CreateMap<>` tanımlı mı? DI'da `AddAutoMapper(Assembly)` var mı?
- **FluentValidation**: `AddFluentValidationAutoValidation()` DI'da var mı?

## Frontend (React)
- **CORS blocked**: Vite proxy ayarla VEYA backend CORS origin ekle
- **Token expired**: Interceptor'da 401 yakaladığında refresh token veya login'e yönlendir
- **State kaybolması**: Token'ı localStorage + state'te tut
- **Build**: `npm run build` → `dist/` → Nginx ile serve et

## Integration
- **Env variables**: Backend `.env`, Frontend `.env` (VITE_ prefix)
- **API URL**: Production'da `https://api.domain.com`, Dev'de proxy

## 📓 Debug Günlüğü
| Tarih | Katman | Hata | Çözüm |
|-------|--------|------|--------|
| [—]   | [—]    | [—]  | [—]    |
