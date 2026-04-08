# 📝 Step-by-Step | 📂 Files | 🐛 Debug | 📚 Resources — .NET + React

## Adımlar
### Backend (.NET)
1. [ ] `dotnet new sln -n MyApp` → Domain, Application, Infrastructure, WebAPI projeleri oluştur
2. [ ] Domain: Entity + Interface tanımla
3. [ ] Infrastructure: EF Core DbContext, Repository, migrations
4. [ ] Application: DTO, AutoMapper, FluentValidation, Service
5. [ ] WebAPI: Controller, DI registration, CORS, JWT config
6. [ ] `dotnet run` → Swagger test

### Frontend (React)
7. [ ] `npm create vite@latest frontend -- --template react`
8. [ ] Routing, Layout, Pages oluştur
9. [ ] `services/api.js` → Axios + interceptors
10. [ ] Auth: Login/Register → token → ProtectedRoute
11. [ ] CRUD pages → API entegrasyonu
12. [ ] `npm run build`

### Integration
13. [ ] CORS ayarı (backend → frontend origin)
14. [ ] `.env` dosyaları (API URL, DB connection, JWT secret)
15. [ ] Docker Compose: backend + frontend + DB

## Debug Tips
| Sorun | Çözüm |
|-------|-------|
| CORS hatası | Backend'de `AddCors()` + frontend origin ekle |
| 401 Unauthorized | Token expired? Bearer prefix doğru mu? |
| EF Migration hatası | `dotnet ef migrations add Init` → DbContext config kontrol |
| React proxy | `vite.config.js` → `server: { proxy: { '/api': 'https://localhost:5001' } }` |
| AutoMapper missing map | Profile'da `CreateMap<Source, Dest>()` tanımlı mı? |

## Resources
| Kaynak | Link |
|--------|------|
| ASP.NET Core | https://learn.microsoft.com/aspnet/core |
| React | https://react.dev |
| EF Core | https://learn.microsoft.com/ef/core |
| Clean Architecture (Jason Taylor) | https://github.com/jasontaylordev/CleanArchitecture |

## Docker Compose
```yaml
services:
  db:
    image: mcr.microsoft.com/mssql/server:2022-latest
    environment: [ACCEPT_EULA=Y, MSSQL_SA_PASSWORD=YourPassword123!]
    ports: ["1433:1433"]
  backend:
    build: ./backend
    ports: ["5000:80"]
    depends_on: [db]
    environment: [ConnectionStrings__Default=Server=db;Database=MyApp;...]
  frontend:
    build: ./frontend
    ports: ["3000:80"]
    depends_on: [backend]
```
