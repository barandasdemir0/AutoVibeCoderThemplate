# 📋 Planning — FastAPI + Vue 3 (Async API + Reactive SPA)

## 🎯 Proje
- **Backend:** FastAPI (Python, async) — Layered + DI
- **Frontend:** Vue 3 + Vite (Composition API)
- **DB:** PostgreSQL
- **ORM:** SQLAlchemy (async) + Alembic migrations

## 🛠️ Tech Stack
| Katman | Backend | Frontend |
|--------|---------|----------|
| Framework | FastAPI | Vue 3 + Vite |
| ORM | SQLAlchemy async | — |
| Auth | OAuth2 + JWT (python-jose) | Pinia + Axios |
| Validation | Pydantic v2 | VeeValidate + Zod |
| Docs | Swagger/ReDoc (built-in) | — |
| State | — | Pinia |

## ⭐ MVP
1. [ ] FastAPI + SQLAlchemy async proje
2. [ ] Vue 3 + Vite frontend
3. [ ] Pydantic schemas + CRUD routers
4. [ ] JWT Auth (login/register)
5. [ ] Vue → FastAPI API entegrasyonu
6. [ ] Docker Compose

# 🏗️ Architecture
```
project/
├── backend/
│   ├── app/
│   │   ├── main.py              → FastAPI app, startup, CORS
│   │   ├── core/ (config.py, security.py, database.py)
│   │   ├── models/              → SQLAlchemy ORM models
│   │   ├── schemas/             → Pydantic request/response
│   │   ├── routers/             → APIRouter per feature
│   │   ├── services/            → Business logic
│   │   └── dependencies/        → Depends() injections
│   ├── alembic/
│   ├── requirements.txt
│   └── .env
├── frontend/
│   ├── src/ (components/, views/, composables/, stores/, services/, router/)
│   ├── package.json
│   └── vite.config.js
├── docker-compose.yml
└── README.md
```

## Best Practices
- **Pydantic vs SQLAlchemy**: Schema (API) ≠ Model (DB) — ayrı tut
- **Async all the way**: `async def` endpoint + `AsyncSession`
- **Depends()**: DB session, auth her yerde DI ile
- **Vue Composables**: `useAuth()`, `useFetch()` → logic reuse
- **Pinia**: Auth store + feature store → reactive state

# 📝 Steps | 🐛 Debug | 📚 Resources
## Steps: `pip install fastapi sqlalchemy alembic` → models → schemas → routers → Vue SPA → Axios
## Debug: 422 → Pydantic schema mismatch, CORS → `CORSMiddleware`, async session → `yield`
## Resources: FastAPI (fastapi.tiangolo.com), Vue (vuejs.org), Pinia (pinia.vuejs.org), SQLAlchemy (sqlalchemy.org)
