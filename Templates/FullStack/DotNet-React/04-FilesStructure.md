# 📂 Files | 🐛 Debug | 📚 Resources — .NET + React

## Dosya Açıklamaları
| Dosya | Katman | Ne İş Yapar |
|-------|--------|-------------|
| `Domain/Entities/` | Domain | İş objeleri (DB'den bağımsız) |
| `Domain/Interfaces/` | Domain | Repository, Service kontratları |
| `Application/DTOs/` | Application | Request/Response data transfer |
| `Application/Services/` | Application | İş mantığı orchestration |
| `Application/Validators/` | Application | FluentValidation input kontrol |
| `Application/Mappings/` | Application | Entity ↔ DTO dönüşümü |
| `Infrastructure/Data/` | Infrastructure | EF Core DbContext, config |
| `Infrastructure/Repositories/` | Infrastructure | Generic + custom repository |
| `WebAPI/Controllers/` | Presentation | HTTP endpoint'ler |
| `WebAPI/Middleware/` | Presentation | Exception, JWT, logging |
| `frontend/services/api.js` | Frontend | Axios HTTP client |
| `frontend/store/` | Frontend | Global state (auth, data) |
| `frontend/hooks/` | Frontend | Custom React hooks |

## Debug Tips
- **CORS**: `builder.Services.AddCors(o => o.AddPolicy("React", p => p.WithOrigins("http://localhost:5173")))`
- **EF Migration**: `dotnet ef migrations add Init -p Infrastructure -s WebAPI`
- **401/403**: JWT token expired? ClaimTypes doğru mu? `[Authorize(Roles = "Admin")]`
- **React 422**: API validation error → backend response format kontrol
- **Hot reload**: Backend `dotnet watch run` + Frontend `npm run dev`

## Resources
| Kaynak | Link |
|--------|------|
| Clean Architecture Template | https://github.com/jasontaylordev/CleanArchitecture |
| ASP.NET Core | https://learn.microsoft.com/aspnet/core |
| React | https://react.dev |
| EF Core | https://learn.microsoft.com/ef/core |
| AutoMapper | https://automapper.org |
| FluentValidation | https://docs.fluentvalidation.net |
