# 📂 Files | 🐛 Debug | 📚 Resources — FastAPI + Vue (04-06 Combined)
## Files
```
backend/ → app/ (main.py, core/, models/, schemas/, routers/, services/, dependencies/), alembic/, .env
frontend/ → src/ (components/, views/, composables/, stores/, services/, router/), vite.config.js
```

## Debug Tips
- **422**: Pydantic field tipi → `Optional[str] = None`, required alanlar kontrol
- **CORS**: `CORSMiddleware` → `allow_origins`, `allow_methods`, `allow_headers`
- **async DB**: `AsyncSession` → `yield` ile aç/kapat
- **Vue watch**: `watch(ref, callback)` → deep watch için `{ deep: true }`

## Resources
FastAPI (fastapi.tiangolo.com), Vue (vuejs.org), Pinia (pinia.vuejs.org), SQLAlchemy (sqlalchemy.org)

## Debug Günlüğü
| Tarih | Hata | Çözüm |
|-------|------|--------|
| [—]   | [—]  | [—]    |
