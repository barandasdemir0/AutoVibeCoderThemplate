# 🐛 Debug Tips — Django + React
## Backend
- **N+1**: `select_related('fk_field')`, `prefetch_related('m2m_field')`
- **CORS**: `pip install django-cors-headers` → settings → middleware
- **JWT expired**: SimpleJWT → `SIMPLE_JWT = {'ACCESS_TOKEN_LIFETIME': timedelta(minutes=30)}`
- **Migration conflict**: `makemigrations --merge`

## Frontend
- **CORS proxy**: `vite.config.js → server.proxy`
- **Token management**: localStorage → Axios interceptor

## 📓 Debug Günlüğü
| Tarih | Hata | Çözüm |
|-------|------|--------|
| [—]   | [—]  | [—]    |
