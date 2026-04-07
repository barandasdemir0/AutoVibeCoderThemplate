# 🧪 TEST-STRUCTURES.md — Her Stack İçin Test Klasör Yapısı

> Bu dosya, her teknoloji için test dosyalarının NEREDE ve NASIL oluşturulacağını gösterir.
> AI bu yapıyı okuduğunda doğru yerde test dosyası oluşturur.

---

## .NET (xUnit)
```
Solution/
├── src/
│   ├── Domain/
│   ├── Application/
│   ├── Infrastructure/
│   └── WebAPI/
└── tests/
    ├── Domain.UnitTests/
    │   ├── Entities/
    │   │   └── UserTests.cs          → Entity validation, method test
    │   └── ValueObjects/
    │       └── EmailTests.cs
    ├── Application.UnitTests/
    │   ├── Services/
    │   │   ├── UserServiceTests.cs   → Mock repo ile service test
    │   │   └── ProductServiceTests.cs
    │   └── Validators/
    │       └── CreateUserValidatorTests.cs
    ├── Infrastructure.IntegrationTests/
    │   ├── Repositories/
    │   │   └── UserRepositoryTests.cs → InMemoryDb ile test
    │   └── Services/
    │       └── EmailServiceTests.cs
    └── WebAPI.IntegrationTests/
        ├── Controllers/
        │   ├── AuthControllerTests.cs → HTTP endpoint test
        │   └── ProductControllerTests.cs
        ├── CustomWebApplicationFactory.cs → Test server setup
        └── appsettings.Test.json
```
```xml
<!-- Test .csproj referansları -->
<PackageReference Include="xunit" />
<PackageReference Include="Moq" />
<PackageReference Include="FluentAssertions" />
<PackageReference Include="Microsoft.AspNetCore.Mvc.Testing" />
```
```bash
dotnet test                           # Tüm testler
dotnet test --filter "Category=Unit"  # Sadece unit
dotnet test --collect:"XPlat Code Coverage"  # Coverage
```

---

## Python (pytest)
```
project/
├── app/
│   ├── models/
│   ├── services/
│   ├── routers/
│   └── schemas/
└── tests/
    ├── conftest.py                 → Fixture'lar (test DB, client, mock)
    ├── unit/
    │   ├── test_user_model.py      → Model validation
    │   ├── test_user_service.py    → Service iş mantığı (mock repo)
    │   └── test_validators.py      → Schema validation
    ├── integration/
    │   ├── test_user_api.py        → API endpoint (TestClient)
    │   ├── test_auth_api.py        → JWT login/register
    │   └── test_product_api.py
    └── fixtures/
        ├── user_fixtures.py        → Test verileri
        └── product_fixtures.py
```
```python
# conftest.py (paylaşılan fixture)
import pytest
from fastapi.testclient import TestClient
from app.main import app
from app.core.database import get_test_db

@pytest.fixture
def client():
    return TestClient(app)

@pytest.fixture
def test_user():
    return {"email": "test@test.com", "password": "Test1234!"}
```
```bash
pytest                          # Tüm testler
pytest tests/unit/              # Sadece unit
pytest -v --cov=app --cov-report=html  # Coverage
```

---

## Node.js / Express (Jest + SuperTest)
```
server/
├── src/
│   ├── models/
│   ├── services/
│   ├── controllers/
│   └── routes/
└── tests/
    ├── setup.js                   → DB bağlantı, cleanup
    ├── unit/
    │   ├── user.service.test.js   → Mock ile service test
    │   ├── product.service.test.js
    │   └── validators.test.js
    ├── integration/
    │   ├── auth.test.js           → Login/register API test
    │   ├── product.test.js        → CRUD endpoint test
    │   └── middleware.test.js     → Auth middleware test
    └── fixtures/
        ├── users.js               → Test user data
        └── products.js
```
```javascript
// setup.js (jest.config.js → setupFilesAfterSetup)
const mongoose = require('mongoose');
beforeAll(async () => await mongoose.connect(process.env.TEST_DB_URL));
afterAll(async () => await mongoose.connection.close());
afterEach(async () => { /* cleanup collections */ });
```
```bash
npm test                        # Tüm testler
npm test -- --testPathPattern=unit  # Sadece unit
npm test -- --coverage          # Coverage
```

---

## React / Vue / Angular (Frontend Test)
```
src/
├── components/
│   ├── Button/
│   │   ├── Button.jsx
│   │   ├── Button.css
│   │   └── Button.test.jsx      → Component test (render, click)
│   └── ProductCard/
│       ├── ProductCard.jsx
│       └── ProductCard.test.jsx
├── pages/
│   └── LoginPage.test.jsx       → Page render test
├── hooks/
│   └── useAuth.test.js          → Custom hook test
├── services/
│   └── api.test.js              → Mock axios test
└── __mocks__/                   → Manual mock'lar
    └── axios.js
```
```bash
# React/Vue
npm test                        # Jest + RTL
npx cypress open                # E2E

# Angular
ng test                         # Karma + Jasmine
ng e2e                          # Protractor/Cypress
```

---

## Flutter (flutter_test)
```
lib/
├── models/
├── services/
├── providers/
└── screens/
test/
├── unit/
│   ├── models/
│   │   └── user_model_test.dart   → fromJson/toJson test
│   ├── services/
│   │   └── auth_service_test.dart → Mock API service
│   └── providers/
│       └── auth_provider_test.dart
├── widget/
│   ├── login_screen_test.dart     → Widget render + tap test
│   └── product_card_test.dart
├── integration/
│   └── app_test.dart              → Full flow E2E
└── fixtures/
    └── mock_data.dart
```
```bash
flutter test                    # Tüm testler
flutter test test/unit/         # Sadece unit
flutter test --coverage         # Coverage
```

---

## Spring Boot (JUnit 5 + Mockito)
```
src/
├── main/java/com/project/
│   ├── entity/
│   ├── repository/
│   ├── service/
│   └── controller/
└── test/java/com/project/
    ├── unit/
    │   ├── service/
    │   │   └── UserServiceTest.java     → @Mock + @InjectMocks
    │   └── entity/
    │       └── UserTest.java
    ├── integration/
    │   ├── repository/
    │   │   └── UserRepositoryTest.java  → @DataJpaTest
    │   └── controller/
    │       └── UserControllerTest.java  → @SpringBootTest + MockMvc
    └── fixtures/
        └── TestDataFactory.java
```
```bash
mvn test                         # Tüm testler
mvn test -Dtest=UserServiceTest  # Tek class
mvn verify                       # Integration dahil
```

---

## Laravel (PHPUnit)
```
tests/
├── Unit/
│   ├── Models/
│   │   └── UserTest.php         → Model method test
│   └── Services/
│       └── ProductServiceTest.php
├── Feature/
│   ├── Auth/
│   │   └── LoginTest.php        → HTTP endpoint test
│   └── Api/
│       └── ProductTest.php      → API CRUD test
├── CreatesApplication.php
└── TestCase.php
```
```bash
php artisan test                 # Tüm testler
php artisan test --filter=Unit   # Sadece unit
php artisan test --coverage      # Coverage
```
