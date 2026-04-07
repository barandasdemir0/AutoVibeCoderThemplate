# Starter Code — DotNet WebAPI (Clean Architecture)
# Bu dosya, AI'ın bu template için starter code oluşturma rehberidir.

## Mimari: Clean Architecture
## Pattern: Domain → Application → Infrastructure → WebAPI

## Klasör Yapısı
```
src/
├── Domain/                          → Entity'ler, Enum'lar, Interface'ler
│   ├── Entities/User.cs
│   ├── Enums/Role.cs
│   └── Interfaces/IUserRepository.cs
├── Application/                     → DTO, Service Interface/Implementation, Mapping
│   ├── DTOs/UserDto.cs, CreateUserRequest.cs
│   ├── Interfaces/IUserService.cs
│   ├── Services/UserService.cs
│   └── Mapping/MappingProfile.cs    → AutoMapper
├── Infrastructure/                  → DB Context, Repository Implementation, Config
│   ├── Data/AppDbContext.cs
│   ├── Repositories/UserRepository.cs
│   └── Config/UserConfiguration.cs  → Fluent API
└── WebAPI/                          → Controllers, Middleware, Program.cs
    ├── Controllers/AuthController.cs, UserController.cs
    ├── Middleware/ExceptionMiddleware.cs
    └── Program.cs                   → DI, Pipeline sırası

test/
├── UnitTests/Services/UserServiceTests.cs
└── IntegrationTests/Controllers/AuthControllerTests.cs
```

## Config Dosyaları
- appsettings.json → ConnectionStrings, Jwt (Secret, Issuer, Audience), Logging
- .env → Yok (.NET appsettings kullanır)
- .gitignore → bin/, obj/, appsettings.Development.json

## NuGet Paketleri
- Microsoft.EntityFrameworkCore + Npgsql.EntityFrameworkCore.PostgreSQL
- Microsoft.AspNetCore.Authentication.JwtBearer
- AutoMapper.Extensions.Microsoft.DependencyInjection
- FluentValidation.AspNetCore
- Swashbuckle.AspNetCore (Swagger)
- Serilog.AspNetCore

## AI Talimatı
Bu klasörde starter/ yoksa, yukarıdaki yapıyı takip ederek sıfırdan oluştur.
CONFIG-RULES.md'deki .NET pipeline sırasına MUTLAKA uy.
