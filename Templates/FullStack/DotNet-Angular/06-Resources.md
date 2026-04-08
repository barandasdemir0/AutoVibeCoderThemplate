# 📚 Resources — .NET + Angular
| Kaynak | Link |
|--------|------|
| ASP.NET Core | https://learn.microsoft.com/aspnet/core |
| Angular | https://angular.dev |
| EF Core | https://learn.microsoft.com/ef/core |
| Angular Material | https://material.angular.io |
| FluentValidation | https://docs.fluentvalidation.net |
| AutoMapper | https://automapper.org |
| RxJS | https://rxjs.dev |
| NgRx | https://ngrx.io |
| Clean Architecture | https://github.com/jasontaylordev/CleanArchitecture |
| PrimeNG | https://primeng.org |

## CLI Reference
```bash
# Backend
dotnet new sln -n MyApp
dotnet new webapi -n WebAPI
dotnet new classlib -n Domain
dotnet ef migrations add Init -p Infrastructure -s WebAPI
dotnet ef database update -p Infrastructure -s WebAPI
dotnet run --project WebAPI

# Frontend
ng new frontend --standalone --style=scss --routing
ng add @angular/material
ng generate component features/products/product-list
ng generate service core/services/product
ng generate guard core/guards/auth
ng serve
ng build --configuration production
```
