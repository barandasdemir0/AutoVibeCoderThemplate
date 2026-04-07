# 📝 Step-by-Step — .NET Test Suite
## Adımlar
1. [ ] `dotnet new xunit -n Application.UnitTests`
2. [ ] `dotnet add package Moq FluentAssertions Bogus`
3. [ ] Service unit test yaz (mock repo ile)
4. [ ] Validator unit test yaz
5. [ ] `dotnet new xunit -n WebAPI.IntegrationTests`
6. [ ] `dotnet add package Microsoft.AspNetCore.Mvc.Testing`
7. [ ] CustomWebApplicationFactory oluştur
8. [ ] Controller integration test yaz
9. [ ] `dotnet test` → tüm testler geçmeli
10. [ ] `dotnet test --collect:"XPlat Code Coverage"` → coverage raporu

## 📂 Files
| Dosya | Ne İş Yapar |
|-------|-------------|
| `*Tests.cs` | Test sınıfı — [Fact] veya [Theory] |
| `CustomWebApplicationFactory.cs` | Test server oluştur (InMemory DB) |
| `TestDatabaseFixture.cs` | Shared DB setup/cleanup |
| `Bogus Faker<T>` | Fake test verisi üret |

## 🐛 Debug Tips
- **Test çalışmıyor**: `dotnet build` → derleme hatası var mı?
- **DI hatası**: Test'te doğru service register edilmiş mi?
- **InMemory DB boş**: Her test'te seed data oluştur
- **Async mock**: `.ReturnsAsync()` kullandığından emin ol

## 📚 Resources
| Kaynak | Link |
|--------|------|
| xUnit | https://xunit.net |
| Moq | https://github.com/moq/moq4 |
| FluentAssertions | https://fluentassertions.com |
| MVC Testing | https://learn.microsoft.com/aspnet/core/test/integration-tests |
