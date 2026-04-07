# Starter Blueprints — FullStack Templates
# Bu blueprint AI'ın Backend + Frontend'i nasıl birleştireceğini gösterir.

## Genel Kural
FullStack = Backend starter + Frontend starter + INTEGRATION-GUIDE.md
Her FullStack template için:
1. Backend'i ilgili Backend template'inden al
2. Frontend'i ilgili Frontend template'inden al
3. INTEGRATION-GUIDE.md kurallarına göre birleştir

## Klasör Yapısı (HER FullStack için aynı)
```
{{project_name}}/
├── backend/
│   ├── [Backend starter dosyaları]
│   ├── Dockerfile
│   └── .env.example
├── frontend/
│   ├── [Frontend starter dosyaları]
│   ├── Dockerfile
│   └── nginx.conf (production)
├── docker-compose.yml
├── .github/workflows/ci.yml
├── .gitignore
├── .env.example
└── README.md
```

## Template → Backend + Frontend Mapping
| FullStack Template | Backend | Frontend |
|---|---|---|
| DotNet-React | DotNet-WebAPI starter | React starter |
| DotNet-Angular | DotNet-WebAPI starter | Angular blueprint |
| Django-React | Python-Django blueprint | React starter |
| FastAPI-Vue | Python-FastAPI starter | Vue blueprint |
| SpringBoot-Angular | Java-SpringBoot blueprint | Angular blueprint |
| Laravel-Vue | PHP-Laravel blueprint | Vue blueprint |
| Express-React | NodeJS-Express starter | React starter |
| NextJS-FullStack | NextJS App Router (monolith) | — (aynı proje) |

## Entegrasyon Kuralları (INTEGRATION-GUIDE.md'den)
1. CORS: Backend'de frontend URL'ini izin ver
2. Proxy: Frontend dev'de `/api → backend_url` proxy
3. Auth: JWT token localStorage'da, Axios interceptor ile header'a ekle
4. Env: Backend port ≠ Frontend port
5. Docker: docker-compose ile tek komutta ayağa kalk
