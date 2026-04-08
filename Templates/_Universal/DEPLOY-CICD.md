# 🚀 DEPLOY-CICD.md — Deployment & CI/CD Rehberi

> Projeyi geliştirme ortamından production'a taşıma. Docker, CI/CD, hosting seçenekleri.

---

## 🐳 Docker

### Neden Docker?
- "Bende çalışıyor, sende niye çalışmıyor?" → Docker ile aynı ortam her yerde
- Tek komutla tüm servisler ayağa kalkar (DB + Backend + Frontend)

### Backend Dockerfile (.NET)
```dockerfile
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY *.sln .
COPY src/WebAPI/*.csproj ./src/WebAPI/
COPY src/Application/*.csproj ./src/Application/
COPY src/Domain/*.csproj ./src/Domain/
COPY src/Infrastructure/*.csproj ./src/Infrastructure/
RUN dotnet restore
COPY . .
RUN dotnet publish src/WebAPI -c Release -o /app

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app .
EXPOSE 80
ENTRYPOINT ["dotnet", "WebAPI.dll"]
```

### Backend Dockerfile (Python)
```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Backend Dockerfile (Node.js)
```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json .
RUN npm ci --only=production
COPY . .
EXPOSE 3000
CMD ["node", "src/app.js"]
```

### Frontend Dockerfile (React/Vue/Angular)
```dockerfile
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json .
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
```

### Docker Compose (Full Stack)
```yaml
version: '3.8'
services:
  db:
    image: postgres:16
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - pgdata:/var/lib/postgresql/data
    ports: ["5432:5432"]
  
  redis:
    image: redis:7-alpine
    ports: ["6379:6379"]
  
  backend:
    build: ./backend
    environment:
      - DATABASE_URL=postgresql://postgres:${DB_PASSWORD}@db:5432/myapp
      - REDIS_URL=redis://redis:6379
      - JWT_SECRET=${JWT_SECRET}
    ports: ["5000:80"]
    depends_on: [db, redis]
  
  frontend:
    build: ./frontend
    ports: ["3000:80"]
    depends_on: [backend]

volumes:
  pgdata:
```

---

## 🔄 CI/CD Pipeline

### GitHub Actions (.github/workflows/ci.yml)
```yaml
name: CI/CD
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      # Backend test (.NET örnek)
      - uses: actions/setup-dotnet@v4
        with: { dotnet-version: '8.0' }
      - run: dotnet restore
      - run: dotnet test --no-restore --verbosity normal
      
      # Frontend test
      - uses: actions/setup-node@v4
        with: { node-version: '20' }
      - run: cd frontend && npm ci && npm test -- --watchAll=false
  
  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: docker-compose build
  
  deploy:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      # Vercel / Azure / AWS deploy step
      - run: echo "Deploy to production"
```

---

## 🌐 Hosting Seçenekleri

| Platform | Uygun | Fiyat | Ne Zaman |
|----------|-------|-------|----------|
| **Vercel** | Next.js, React, Vue | Free tier ✅ | Frontend, Next.js fullstack |
| **Railway** | Node, Python, Docker | $5/ay | Backend + DB, hızlı deploy |
| **Render** | Her şey | Free tier ✅ | Startup, basit projeler |
| **Azure** | .NET, Docker | Pay-as-you-go | Enterprise .NET |
| **AWS (EC2/ECS)** | Her şey | Pay-as-you-go | Büyük ölçek |
| **DigitalOcean** | Docker, VPS | $4/ay | Custom VPS |
| **Firebase** | Mobile, SPA | Free tier ✅ | Flutter, static hosting |
| **Heroku** | Node, Python | Free tier ❌ | Basit deploy (artık ücretli) |
| **Fly.io** | Docker | Free tier ✅ | Edge deploy, global |

### AI İçin Deploy Kuralı
```
1. Development → localhost (npm run dev / dotnet run)
2. Staging → Docker Compose (test)  
3. Production → Platform seç (Vercel / Azure / Railway)
4. .env.production → production secrets (CI/CD'de set et)
5. HTTPS zorunlu → platform otomatik halleder
6. Health check endpoint → /api/health
```
