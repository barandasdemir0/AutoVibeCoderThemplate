# 🧪 TESTING.md — Test Stratejisi Rehberi (Her Stack İçin)

---

## 🔺 Test Piramidi
```
        /  E2E  \          → Az ama kritik (Selenium, Cypress, Playwright)
       / Integration \      → Orta (API test, DB test)
      /    Unit Tests   \   → Çok (fonksiyon/method test)
     /____________________\
```

## Test Tipleri
| Tip | Ne Test Eder | Araç |
|-----|-------------|------|
| **Unit** | Tek fonksiyon/method | xUnit, JUnit, pytest, Jest |
| **Integration** | Birden fazla katman birlikte | TestServer, Testcontainers |
| **E2E** | Tüm akış (kullanıcı gibi) | Cypress, Playwright, Selenium |
| **API** | HTTP endpoint'ler | Postman, SuperTest, httpx |

---

## Teknolojiye Göre Test Araçları

### .NET
```csharp
// xUnit + FluentAssertions + Moq
[Fact]
public async Task GetUser_ReturnsUser_WhenExists()
{
    var mockRepo = new Mock<IUserRepository>();
    mockRepo.Setup(r => r.GetByIdAsync(1)).ReturnsAsync(new User { Id = 1, Name = "Test" });
    var service = new UserService(mockRepo.Object);
    var result = await service.GetByIdAsync(1);
    result.Should().NotBeNull();
    result.Name.Should().Be("Test");
}
// dotnet test
```

### Python
```python
# pytest
def test_create_user():
    user = User(name="Test", email="t@t.com")
    assert user.name == "Test"
    assert user.email == "t@t.com"

# FastAPI TestClient
from fastapi.testclient import TestClient
client = TestClient(app)
def test_get_products():
    response = client.get("/api/products")
    assert response.status_code == 200
# pytest -v
```

### Node.js
```javascript
// Jest + SuperTest
const request = require('supertest');
const app = require('../src/app');
describe('GET /api/products', () => {
    it('should return 200', async () => {
        const res = await request(app).get('/api/products');
        expect(res.status).toBe(200);
        expect(res.body.success).toBe(true);
    });
});
// npm test
```

### Frontend (React)
```jsx
// React Testing Library + Jest
import { render, screen } from '@testing-library/react';
test('renders login button', () => {
    render(<LoginPage />);
    expect(screen.getByText('Giriş Yap')).toBeInTheDocument();
});
// npm test
```

### Mobile (Flutter)
```dart
// flutter_test
void main() {
    test('User model fromJson', () {
        final json = {'name': 'Test', 'email': 'test@test.com'};
        final user = User.fromJson(json);
        expect(user.name, 'Test');
    });
}
// flutter test
```

---

## 📋 Ne Zaman Ne Test Et?

| Katman | Test Edilecek | Öncelik |
|--------|-------------|---------|
| Model/Entity | Validation, computed property | ⭐⭐⭐ |
| Service | İş mantığı, edge case | ⭐⭐⭐⭐⭐ |
| Repository | CRUD doğru çalışıyor mu (integration) | ⭐⭐⭐⭐ |
| Controller/API | HTTP status, response format | ⭐⭐⭐⭐ |
| Auth | Login, register, token, guard | ⭐⭐⭐⭐⭐ |
| UI Component | Render, interaksiyon | ⭐⭐⭐ |
| E2E | Kritik akışlar (login → dashboard → CRUD) | ⭐⭐⭐ |

## AI İçin Test Kuralı
```
Her yeni feature yazıldığında:
1. En az service katmanı için unit test yaz
2. API endpoint için integration test yaz
3. Hata senaryosunu da test et (not found, unauthorized)
4. Edge case: null, empty, max length, special chars
```
