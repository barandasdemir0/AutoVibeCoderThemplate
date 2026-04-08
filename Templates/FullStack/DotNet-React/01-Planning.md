# 📋 Planning — .NET Web API + React (Full Stack)

## 🎯 Proje
- **Proje Adı:** [—]
- **Tip:** Full Stack Web Application
- **Backend:** ASP.NET Core 8 Web API (Clean Architecture)
- **Frontend:** React + Vite (SPA)
- **Açıklama:** [—]

## 🛠️ Tech Stack
| Katman | Teknoloji | Versiyon |
|--------|-----------|----------|
| **Backend** | | |
| Framework | ASP.NET Core | [8.0] |
| Mimari | Clean Architecture | — |
| ORM | Entity Framework Core | [8.x] |
| DB | SQL Server / PostgreSQL | [—] |
| Auth | JWT Bearer + Identity | [—] |
| Mapping | AutoMapper | [—] |
| Validation | FluentValidation | [—] |
| API Docs | Swagger (Swashbuckle) | [—] |
| **Frontend** | | |
| UI | React | [18+] |
| Build | Vite | [5.x] |
| Routing | React Router v6 | [—] |
| State | Redux Toolkit / Zustand | [—] |
| HTTP | Axios | [—] |
| Forms | React Hook Form + Zod | [—] |
| **DevOps** | | |
| Container | Docker + Compose | [—] |
| CI/CD | GitHub Actions | [—] |

## ⭐ MVP
1. [ ] Backend: Clean Architecture katmanları
2. [ ] Frontend: React + Vite proje
3. [ ] API CRUD endpoints
4. [ ] React → API entegrasyonu (Axios)
5. [ ] JWT Auth (login/register)
6. [ ] Protected routes (frontend + backend)
7. [ ] Docker Compose (single `docker-compose up`)

## 📝 Best Practices
- **Backend**: Repository Pattern, CQRS (opsiyonel), Unit of Work
- **ORM**: EF Core → Code First, migrations, DbContext per-request scope
- **Frontend**: Component-based, custom hooks, lazy loading
- **API**: RESTful naming, proper HTTP status codes, pagination
- **Auth**: Access + Refresh token, HttpOnly cookie (güvenli)
- **CORS**: Sadece frontend origin'ine izin ver
