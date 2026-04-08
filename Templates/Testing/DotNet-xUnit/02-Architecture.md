# 🏗️ Architecture — .NET Test Suite

## Klasör Yapısı
```
tests/
├── Domain.UnitTests/
│   ├── Entities/
│   │   └── UserTests.cs
│   │   └── ProductTests.cs
│   └── ValueObjects/
│       └── EmailTests.cs
├── Application.UnitTests/
│   ├── Services/
│   │   ├── UserServiceTests.cs
│   │   └── ProductServiceTests.cs
│   ├── Validators/
│   │   └── CreateUserValidatorTests.cs
│   └── Mappings/
│       └── AutoMapperTests.cs
├── Infrastructure.IntegrationTests/
│   ├── Repositories/
│   │   └── UserRepositoryTests.cs
│   ├── Services/
│   │   └── EmailServiceTests.cs
│   └── TestDatabaseFixture.cs
└── WebAPI.IntegrationTests/
    ├── Controllers/
    │   ├── AuthControllerTests.cs
    │   └── ProductControllerTests.cs
    ├── CustomWebApplicationFactory.cs
    └── IntegrationTestBase.cs
```

## Naming Convention
```csharp
// Sınıf: [Test edilen sınıf]Tests
public class UserServiceTests

// Method: [Method]_[Senaryo]_[Beklenen sonuç]
public async Task GetById_WhenUserExists_ReturnsUser()
public async Task GetById_WhenNotFound_ThrowsNotFoundException()
public async Task Create_WithInvalidEmail_ThrowsValidationException()
```

## Unit Test Pattern (AAA)
```csharp
[Fact]
public async Task GetById_WhenUserExists_ReturnsUser()
{
    // Arrange — hazırlık
    var mockRepo = new Mock<IUserRepository>();
    var expectedUser = new User { Id = 1, Name = "Baran", Email = "baran@test.com" };
    mockRepo.Setup(r => r.GetByIdAsync(1)).ReturnsAsync(expectedUser);
    var service = new UserService(mockRepo.Object);

    // Act — çalıştır
    var result = await service.GetByIdAsync(1);

    // Assert — doğrula
    result.Should().NotBeNull();
    result.Name.Should().Be("Baran");
    result.Email.Should().Contain("@");
    mockRepo.Verify(r => r.GetByIdAsync(1), Times.Once);
}
```

## Integration Test (WebApplicationFactory)
```csharp
public class CustomWebApplicationFactory : WebApplicationFactory<Program>
{
    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.ConfigureServices(services =>
        {
            // Gerçek DB'yi kaldır → InMemory ekle
            var descriptor = services.SingleOrDefault(d => d.ServiceType == typeof(DbContextOptions<AppDbContext>));
            if (descriptor != null) services.Remove(descriptor);
            services.AddDbContext<AppDbContext>(o => o.UseInMemoryDatabase("TestDb"));
        });
    }
}

public class ProductControllerTests : IClassFixture<CustomWebApplicationFactory>
{
    private readonly HttpClient _client;
    public ProductControllerTests(CustomWebApplicationFactory factory) 
        => _client = factory.CreateClient();

    [Fact]
    public async Task GetAll_Returns200()
    {
        var response = await _client.GetAsync("/api/products");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
    }
}
```
