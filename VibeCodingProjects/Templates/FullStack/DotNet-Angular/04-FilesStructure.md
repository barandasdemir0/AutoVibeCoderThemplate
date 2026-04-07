# 📂 Files | 🐛 Debug | 📚 Resources — .NET + Angular

## Dosya Açıklamaları
| Dosya | Katman | Ne İş Yapar |
|-------|--------|-------------|
| `Domain/Entities/*.cs` | Domain | İş objeleri — DB'den bağımsız |
| `Domain/Interfaces/*.cs` | Domain | Repository/Service kontratları |
| `Application/DTOs/*.cs` | Application | Request/Response data transfer |
| `Application/Services/*.cs` | Application | İş mantığı, orchestration |
| `Application/Validators/*.cs` | Application | FluentValidation giriş kontrol |
| `Infrastructure/Data/AppDbContext.cs` | Infra | EF Core DB bağlamı |
| `Infrastructure/Repositories/*.cs` | Infra | Generic/custom repository impl |
| `WebAPI/Controllers/*.cs` | API | HTTP endpoint'ler |
| `WebAPI/Middleware/*.cs` | API | Exception, JWT, logging |
| `core/guards/*.ts` | FE | Route koruma (auth, role) |
| `core/interceptors/*.ts` | FE | HTTP token/error interceptor |
| `core/services/*.ts` | FE | Auth, API HTTP çağrıları |
| `features/*/` | FE | Lazy-loaded feature component |
| `shared/components/` | FE | Paylaşılan UI bileşenleri |

## Debug Tips
| Sorun | Çözüm |
|-------|-------|
| CORS 403 | `AddCors()` + `UseCors()` pipeline sırası |
| JWT 401 | Token expired? `ClaimTypes` doğru mu? Secret 32+ char? |
| Angular "No provider" | `providedIn: 'root'` veya `providers` array |
| RxJS memory leak | `async` pipe veya `takeUntilDestroyed()` |
| EF LazyInit | Service'de `@Transactional` / `Include()` |
| Angular routing 404 | `useHash: true` veya server-side rewrite |
| Reactive Form invalid | `form.markAllAsTouched()` → hataları göster |
| Angular Material theme | `@use '@angular/material' as mat;` SCSS'de |

## Resources
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

## Debug Günlüğü
| Tarih | Katman | Hata | Çözüm |
|-------|--------|------|--------|
| [—]   | [—]    | [—]  | [—]    |
