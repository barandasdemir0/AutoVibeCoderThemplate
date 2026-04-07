# 📋 Planning — .NET Test Suite (xUnit + Moq + FluentAssertions)

## 🎯 Proje
- **Framework:** xUnit (Microsoft'un önerisi)
- **Mocking:** Moq (interface mock)
- **Assertion:** FluentAssertions (okunabilir assertion)
- **Integration:** WebApplicationFactory (in-memory API test)
- **Coverage:** coverlet (.NET CLI)

## 🛠️ NuGet Paketleri
| Paket | Amaç |
|-------|------|
| xunit | Test framework |
| xunit.runner.visualstudio | VS test runner |
| Moq | Mock nesneleri |
| FluentAssertions | Okunabilir assertion |
| Microsoft.AspNetCore.Mvc.Testing | Integration test |
| Microsoft.EntityFrameworkCore.InMemoryDatabase | InMemory DB |
| coverlet.collector | Code coverage |
| Bogus | Fake data generation |

## ⭐ Test Türleri Checklist
1. [ ] Unit Test — Service katmanı (mock repo)
2. [ ] Unit Test — Validator (FluentValidation)
3. [ ] Unit Test — Domain entity method'ları
4. [ ] Integration Test — Repository (InMemory DB)
5. [ ] Integration Test — Controller (WebApplicationFactory)
6. [ ] Auth Test — JWT token üretme/doğrulama
