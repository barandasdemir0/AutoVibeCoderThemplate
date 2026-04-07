# 📋 Planning — Python Test Suite (pytest)

## 🎯
- **Framework:** pytest (Python standart)
- **Async:** pytest-asyncio
- **HTTP Test:** httpx (FastAPI TestClient) / Django TestCase
- **Mock:** unittest.mock + pytest-mock
- **Coverage:** pytest-cov
- **Fixtures:** conftest.py paylaşımlı

## Pip Paketleri
```bash
pip install pytest pytest-asyncio pytest-cov pytest-mock httpx Faker
```

## Test Türleri
1. [ ] Unit → Service/fonksiyon testi (mock DB)
2. [ ] Integration → API endpoint testi (TestClient)
3. [ ] Model → Validation/schema testi
4. [ ] Auth → JWT token, login/register endpoint

## Klasör Yapısı
```
tests/
├── conftest.py              → Paylaşılan fixture'lar
├── unit/
│   ├── test_user_service.py
│   ├── test_product_service.py
│   └── test_validators.py
├── integration/
│   ├── test_auth_api.py
│   ├── test_product_api.py
│   └── test_user_api.py
└── fixtures/
    ├── user_data.py
    └── product_data.py
```

## conftest.py (Shared Fixture)
```python
import pytest
from fastapi.testclient import TestClient
from app.main import app
from app.core.database import engine, Base

@pytest.fixture(autouse=True)
def setup_db():
    Base.metadata.create_all(bind=engine)
    yield
    Base.metadata.drop_all(bind=engine)

@pytest.fixture
def client():
    return TestClient(app)

@pytest.fixture
def auth_headers(client):
    client.post("/api/auth/register", json={"email": "test@test.com", "password": "Test1234!"})
    res = client.post("/api/auth/login", json={"email": "test@test.com", "password": "Test1234!"})
    token = res.json()["access_token"]
    return {"Authorization": f"Bearer {token}"}
```

## Unit Test
```python
def test_create_user_service(mocker):
    mock_repo = mocker.patch("app.services.user_service.UserRepository")
    mock_repo.return_value.create.return_value = User(id=1, name="Test")
    result = UserService().create(CreateUserDto(name="Test", email="t@t.com"))
    assert result.id == 1
    assert result.name == "Test"
```

## Integration Test
```python
def test_get_products(client, auth_headers):
    response = client.get("/api/products", headers=auth_headers)
    assert response.status_code == 200
    assert response.json()["success"] is True

def test_create_product_invalid(client, auth_headers):
    response = client.post("/api/products", json={}, headers=auth_headers)
    assert response.status_code == 422
```

## Debug + Resources
- **fixture not found** → conftest.py doğru yerde mi?
- **async test** → `@pytest.mark.asyncio` decorator ekle
- **DB state leak** → her test'te rollback/recreate
- pytest docs: https://docs.pytest.org | FastAPI testing: https://fastapi.tiangolo.com/tutorial/testing/
