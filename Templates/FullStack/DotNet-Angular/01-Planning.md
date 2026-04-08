# 📋 Planning — .NET + Angular (Enterprise Full Stack)

## 🎯 Proje
- **Backend:** ASP.NET Core 8 Web API — Clean Architecture
- **Frontend:** Angular 17+ (Standalone Components / Module-based)
- **DB:** SQL Server / PostgreSQL
- **ORM:** Entity Framework Core (Code-First)
- **Auth:** JWT + ASP.NET Identity + Angular Guards

## 🛠️ Tech Stack
| Katman | Backend | Frontend |
|--------|---------|----------|
| Framework | ASP.NET Core 8 | Angular 17+ |
| ORM | EF Core | — |
| Auth | Identity + JWT | Guards + Interceptors |
| Validation | FluentValidation | Reactive Forms + Validators |
| Docs | Swagger (Swashbuckle) | — |
| State | — | NgRx / Signals |
| UI | — | Angular Material / PrimeNG |
| Test | xUnit + Moq | Karma + Jasmine / Jest |

## ⚠️ Neden .NET + Angular?
- İkisi de **enterprise-grade, strongly typed**
- Angular'ın TypeScript yapısı C# ile uyumlu (tip güvenliği)
- Büyük takımlar, uzun ömürlü projeler, finans/sağlık/kurumsal
- Her ikisinde de **dependency injection** native

## ⭐ MVP
1. [ ] .NET Clean Architecture + Web API
2. [ ] Angular CLI + Module/Standalone yapı
3. [ ] EF Core → Models → Migrations
4. [ ] JWT Auth (Identity + token)
5. [ ] Angular → .NET API entegrasyonu (HttpClient)
6. [ ] Angular Guards + HTTP Interceptor
7. [ ] Docker Compose
