# Starter Blueprints — Testing Templates
# Her test template'i ilgili stack'in test pattern'ini gösterir.

## Tüm Test Template'leri İçin Ortak Kural
```
1. Arrange → Act → Assert (AAA) pattern
2. Her test dosyası tek bir class/module'ü test eder
3. Mock/Stub kullanılacak yerler: DB, external API, file system
4. test/ klasöründe: unit/, integration/, e2e/
5. fixture/ veya __mocks__/ → test verileri
6. CI'da otomatik çalışacak script: npm test / pytest / dotnet test / flutter test
```

## DotNet-xUnit
```
tests/UnitTests/ → xUnit + Moq + FluentAssertions
tests/IntegrationTests/ → WebApplicationFactory<Program>
```

## Python-pytest
```
tests/unit/ → pytest + fixtures
tests/integration/ → TestClient (FastAPI) / Django TestCase
conftest.py → shared fixtures, test DB
```

## NodeJS-Jest
```
tests/unit/ → Jest + mock functions
tests/integration/ → SuperTest + in-memory MongoDB
jest.config.js → testEnvironment, coverage
```

## Java-JUnit
```
src/test/java/ → JUnit 5 + Mockito + @SpringBootTest
@MockBean, @WebMvcTest, MockMvc
```

## Frontend-React
```
src/__tests__/ → React Testing Library + Jest/Vitest
src/mocks/ → MSW (Mock Service Worker)
cypress/e2e/ → Cypress E2E tests
```

## Frontend-Angular
```
src/app/**/*.spec.ts → Karma + Jasmine
cypress/e2e/ → Cypress
HttpClientTestingModule, TestBed
```

## Mobile-Flutter
```
test/unit/ → flutter_test
test/widget/ → WidgetTester + pumpWidget
integration_test/ → IntegrationTestWidgetsFlutterBinding
mockito + build_runner → Mock generation
```
