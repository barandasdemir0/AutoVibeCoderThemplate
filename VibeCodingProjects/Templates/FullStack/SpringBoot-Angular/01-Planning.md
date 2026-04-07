# 📋 Planning — Spring Boot + Angular (Enterprise Full Stack)

## 🎯 Proje
- **Backend:** Spring Boot 3 (Java) — Layered Architecture
- **Frontend:** Angular 17+ (TypeScript) — Module-based
- **DB:** PostgreSQL / MySQL
- **ORM:** Spring Data JPA (Hibernate)

## 🛠️ Tech Stack
| Katman | Backend | Frontend |
|--------|---------|----------|
| Framework | Spring Boot 3 | Angular 17+ |
| ORM | Spring Data JPA | — |
| Auth | Spring Security + JWT | Guards + Interceptors |
| Validation | Jakarta Validation | Reactive Forms |
| Docs | SpringDoc OpenAPI | — |
| Build | Maven | Angular CLI |

# 🏗️ Architecture
```
project/
├── backend/
│   └── src/main/java/com/project/
│       ├── config/ (SecurityConfig, CorsConfig, SwaggerConfig)
│       ├── controller/ (UserController, ProductController)
│       ├── service/ (interface + impl/)
│       ├── repository/ (JpaRepository interfaces)
│       ├── entity/ (User, Product — JPA entities)
│       ├── dto/ (UserRequest, UserResponse)
│       ├── mapper/ (MapStruct mappers)
│       ├── exception/ (GlobalExceptionHandler)
│       └── security/ (JwtProvider, JwtFilter)
├── frontend/
│   └── src/app/
│       ├── core/ (guards/, interceptors/, services/)
│       ├── shared/ (components/, directives/, pipes/)
│       ├── features/ (auth/, products/, dashboard/)
│       ├── app.module.ts
│       └── app-routing.module.ts
├── docker-compose.yml
└── README.md
```

## Best Practices
- **JPA**: Lazy loading default, `@Transactional` service layer'da
- **DTO Pattern**: Entity'yi direkt dönme → MapStruct ile mapping
- **Angular Lazy Loading**: Feature module'lar `loadChildren` ile
- **RxJS**: `async` pipe template'de → otomatik unsubscribe
- **Interceptor**: Backend JWT filter + Frontend token interceptor

# 📝 Steps | 🐛 Debug | 📚 Resources
## Steps: Spring Initializr → entity → repository → service → controller → Angular CLI → modules → routing → services → guards
## Debug: CORS (`@CrossOrigin` veya CorsConfig), JPA LazyInit (`@Transactional`), Angular DI (`providedIn: 'root'`)
## Resources: spring.io, angular.dev, baeldung.com
