# 🏗️ Architecture — .NET + React (Clean Architecture)

## 🧱 Monorepo Yapısı
```
project/
├── backend/                        → .NET Solution
│   ├── src/
│   │   ├── Domain/                 → Entity, Value Object, Interface
│   │   │   ├── Entities/           → User.cs, Product.cs
│   │   │   ├── Interfaces/         → IUserRepository, IUnitOfWork
│   │   │   └── Enums/              → Role.cs, Status.cs
│   │   ├── Application/            → Use Case, DTO, Mapping, Validation
│   │   │   ├── DTOs/               → UserDto, CreateProductRequest
│   │   │   ├── Services/           → IUserService, UserService
│   │   │   ├── Mappings/           → AutoMapper profiles
│   │   │   └── Validators/         → FluentValidation rules
│   │   ├── Infrastructure/         → EF Core, External servisler
│   │   │   ├── Data/               → AppDbContext, Configurations
│   │   │   ├── Repositories/       → UserRepository, GenericRepository
│   │   │   └── Services/           → EmailService, FileService
│   │   └── WebAPI/                 → Controllers, Middleware, Program.cs
│   │       ├── Controllers/        → AuthController, UserController
│   │       ├── Middleware/         → ExceptionMiddleware, JwtMiddleware
│   │       └── Program.cs          → DI registration, pipeline
│   └── tests/
│       ├── UnitTests/
│       └── IntegrationTests/
│
├── frontend/                       → React SPA
│   ├── src/
│   │   ├── components/ (ui/, layout/)
│   │   ├── features/ (auth/, users/, products/)
│   │   ├── pages/
│   │   ├── hooks/
│   │   ├── services/ (api.js, authService.js)
│   │   ├── store/
│   │   ├── utils/
│   │   ├── App.jsx
│   │   └── main.jsx
│   ├── package.json
│   └── vite.config.js
│
├── docker-compose.yml              → Backend + Frontend + DB
└── README.md
```

## 📐 Clean Architecture Katmanları (Bağımlılık Yönü: Dıştan İçe)
```
WebAPI → Application → Domain (EN İÇ, bağımsız)
  ↓          ↓
Infrastructure (DB, External)
```
- **Domain**: Hiçbir şeye bağımlı değil. Entity + Interface tanımları.
- **Application**: Sadece Domain'e bağımlı. İş mantığı, DTO, validation.
- **Infrastructure**: Application'a bağımlı. EF Core, email, dosya sistemleri.
- **WebAPI**: Her şeyi bağlar. DI, Controller, Middleware.

## 🔐 Auth Akışı
```
React Login Form → POST /api/auth/login → .NET JWT Token üretir
    → Token localStorage/cookie → Axios interceptor → Authorization: Bearer {token}
    → .NET [Authorize] attribute → Token doğrula → İstek işle
```

## ORM: Entity Framework Core Best Practices
```csharp
// DbContext — Fluent API (data annotation ile karıştırma)
public class AppDbContext : DbContext {
    public DbSet<User> Users => Set<User>();
    protected override void OnModelCreating(ModelBuilder builder) {
        builder.ApplyConfigurationsFromAssembly(typeof(AppDbContext).Assembly);
    }
}

// Repository — Generic
public class GenericRepository<T> : IGenericRepository<T> where T : class {
    protected readonly AppDbContext _context;
    public async Task<T?> GetByIdAsync(int id) => await _context.Set<T>().FindAsync(id);
    public async Task<IEnumerable<T>> GetAllAsync() => await _context.Set<T>().ToListAsync();
    public async Task AddAsync(T entity) => await _context.Set<T>().AddAsync(entity);
}
```

## Frontend → Backend İletişim
```javascript
// services/api.js
import axios from 'axios';
const api = axios.create({ baseURL: import.meta.env.VITE_API_URL });
api.interceptors.request.use(config => {
    const token = localStorage.getItem('token');
    if (token) config.headers.Authorization = `Bearer ${token}`;
    return config;
});
api.interceptors.response.use(res => res, err => {
    if (err.response?.status === 401) { /* redirect login */ }
    return Promise.reject(err);
});
export default api;
```
