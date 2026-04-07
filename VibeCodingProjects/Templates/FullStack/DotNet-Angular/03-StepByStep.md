# 📝 Step-by-Step — .NET + Angular

## Backend (.NET 8)
1. [ ] `dotnet new sln -n MyApp`
2. [ ] `dotnet new classlib -n Domain` + `Application` + `Infrastructure`
3. [ ] `dotnet new webapi -n WebAPI`
4. [ ] Solution'a projeleri ekle + referansları kur
5. [ ] Domain: Entity'ler (User, Product, Category)
6. [ ] Infrastructure: DbContext, Repository, EF migration
7. [ ] Application: DTO, Service/Handler, Mapping (AutoMapper), Validation (FluentValidation)
8. [ ] WebAPI: Controllers, Middleware (Exception, CORS)
9. [ ] Auth: ASP.NET Identity + JWT → `[Authorize]`
10. [ ] Swagger: `dotnet run` → `/swagger` test

## Frontend (Angular 17+)
11. [ ] `ng new frontend --standalone --style=scss --routing`
12. [ ] `ng add @angular/material` (Material UI)
13. [ ] Core: Guards, Interceptors, Auth Service, API Service
14. [ ] Feature modules: `ng generate component features/products/product-list`
15. [ ] Lazy loading routes
16. [ ] Reactive Forms + validation
17. [ ] HTTP Interceptor (token ekleme + 401 handling)
18. [ ] Environment dosyaları (`apiUrl`)
19. [ ] `ng build --configuration production`

## Integration
20. [ ] CORS: Backend'de `builder.Services.AddCors()`
21. [ ] Docker Compose: `dotnet`, `angular`, `postgres`/`sqlserver`
22. [ ] Test: Backend xUnit + Frontend Karma/Jest

## Naming Kuralları
| Katman | Kural |
|--------|-------|
| C# Class | PascalCase |
| C# Method | PascalCase |
| C# Private | _camelCase |
| Angular Component | kebab-case (product-list.component) |
| Angular Service | camelCase (product.service) |
| Angular Variable | camelCase |
| TypeScript Interface | IPascalCase (IProduct) veya PascalCase |
| CSS Class | kebab-case / BEM |
| API Endpoint | /api/kebab-case |
