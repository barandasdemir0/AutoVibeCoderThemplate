# 📝 Step-by-Step — FastAPI + Vue
## Backend
1. [ ] `python -m venv venv && pip install fastapi uvicorn sqlalchemy alembic python-jose`
2. [ ] `core/` → config, database, security
3. [ ] Models → Schemas → Services → Routers
4. [ ] Alembic init → migrations → `upgrade head`
5. [ ] JWT auth endpoints → `/api/auth/login`, `/api/auth/register`
6. [ ] `uvicorn app.main:app --reload` → `/docs` test

## Frontend
7. [ ] `npm create vite@latest frontend -- --template vue`
8. [ ] `npm i vue-router pinia axios`
9. [ ] Router → Views → Components
10. [ ] Pinia stores (auth, products)
11. [ ] Axios service + interceptors
12. [ ] Auth flow → login → store token → protected views
13. [ ] `npm run build`

## Naming Kuralları
| Katman | Kural |
|--------|-------|
| Python module | snake_case.py |
| Python class | PascalCase |
| Python function | snake_case |
| Vue Component | PascalCase.vue |
| Vue Composable | useCamelCase.js |
| Pinia Store | camelCaseStore.js |
| API Endpoint | /api/kebab-case |
