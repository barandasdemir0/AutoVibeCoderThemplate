# 🏗️ Architecture | 📂 Files | 🐛 Debug | 📚 Resources — FastAPI + Vue

## Dosya Açıklamaları
| Dosya | Katman | Ne İş Yapar |
|-------|--------|-------------|
| `main.py` | Backend | FastAPI app instance, CORS, router include |
| `core/config.py` | Backend | Pydantic BaseSettings (.env parsing) |
| `core/security.py` | Backend | JWT token create/verify |
| `core/database.py` | Backend | SQLAlchemy async engine + session |
| `models/*.py` | Backend | SQLAlchemy ORM tablo tanımları |
| `schemas/*.py` | Backend | Pydantic request/response modelleri |
| `routers/*.py` | Backend | APIRouter endpoint grupları |
| `services/*.py` | Backend | CRUD iş mantığı |
| `dependencies/*.py` | Backend | Depends() — DB session, auth |
| `stores/*.js` | Frontend | Pinia reactive global state |
| `composables/*.js` | Frontend | Vue 3 custom composition functions |
| `services/api.js` | Frontend | Axios instance + interceptors |

## ORM: SQLAlchemy Async Best Practices
```python
# Async session
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
engine = create_async_engine("postgresql+asyncpg://...", echo=False)

# Repository pattern
async def get_products(db: AsyncSession) -> list[Product]:
    result = await db.execute(select(Product).options(joinedload(Product.category)))
    return result.scalars().all()
```

## Debug Tips
- **422 Unprocessable**: Pydantic schema field tiplerini kontrol et
- **CORS**: `app.add_middleware(CORSMiddleware, allow_origins=[...])`
- **Alembic**: `alembic revision --autogenerate` → `alembic upgrade head`
- **Vue reactivity**: `ref()` + `.value` script'te, template'de otomatik unwrap
- **Pinia hydration**: SSR yoksa sorun yok, SPA'da localStorage persist

## Resources
| Kaynak | Link |
|--------|------|
| FastAPI | https://fastapi.tiangolo.com |
| Vue 3 | https://vuejs.org |
| Pinia | https://pinia.vuejs.org |
| SQLAlchemy | https://docs.sqlalchemy.org |
| Alembic | https://alembic.sqlalchemy.org |

## Debug Günlüğü
| Tarih | Katman | Hata | Çözüm |
|-------|--------|------|--------|
| [—]   | [—]    | [—]  | [—]    |
