# ⚙️ CONFIG-RULES.md — Konfigürasyon Kuralları (Dil/Framework Bazlı)

> Her dil/framework'ün kendi config dosyası, pipeline sırası, ortam ayarları var.
> Bunları bilmeden yazarsan çalışmaz. AI bu dosyayı okuyarak doğru config yapar.

---

## 🔵 .NET (ASP.NET Core)

### Config Dosyaları
| Dosya | Ne İçerir | Ortam |
|-------|----------|-------|
| `appsettings.json` | Genel ayarlar (loglama, default bağlantı) | Tüm ortamlar |
| `appsettings.Development.json` | Dev DB bağlantısı, detaylı log | Development |
| `appsettings.Production.json` | Prod DB, minimal log | Production |
| `launchSettings.json` | Port, URL, ortam değişkeni | Sadece dev |

### Pipeline Sırası (Program.cs — SIRA ÖNEMLİ!)
```csharp
var builder = WebApplication.CreateBuilder(args);

// 1. Services (DI Container)
builder.Services.AddDbContext<AppDbContext>();      // DB
builder.Services.AddScoped<IUserRepository, UserRepository>(); // Repository
builder.Services.AddScoped<IUserService, UserService>();       // Service
builder.Services.AddAuthentication().AddJwtBearer();           // Auth
builder.Services.AddAuthorization();                           // Authorization
builder.Services.AddCors();                                    // CORS
builder.Services.AddControllers();                             // Controllers
builder.Services.AddSwaggerGen();                              // Swagger

var app = builder.Build();

// 2. Middleware Pipeline (SIRA KRİTİK!)
app.UseExceptionHandler();        // 1️⃣ İlk: Hata yakala
if (app.Environment.IsDevelopment()) app.UseSwagger(); // 2️⃣ Dev: Swagger
app.UseHttpsRedirection();        // 3️⃣ HTTPS
app.UseCors("Frontend");          // 4️⃣ CORS (Routing'den ÖNCE!)
app.UseAuthentication();          // 5️⃣ Kim bu? (token doğrula)
app.UseAuthorization();           // 6️⃣ Yetkisi var mı?
app.MapControllers();             // 7️⃣ Son: Route'ları eşle
app.Run();
```

### ⚠️ Sık Yapılan Hatalar
- CORS `UseRouting`'den önce → çalışmaz
- `UseAuthentication` `UseAuthorization`'dan önce olmalı
- `AddScoped` yerine `AddSingleton` → DbContext thread-safe değil!

---

## 🟡 Python (FastAPI / Django)

### FastAPI Config
```python
# core/config.py
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    APP_NAME: str = "MyApp"
    DATABASE_URL: str
    JWT_SECRET: str
    JWT_EXPIRE_MINUTES: int = 30
    CORS_ORIGINS: list[str] = ["http://localhost:5173"]
    
    class Config:
        env_file = ".env"

settings = Settings()
```

### FastAPI Middleware Sırası
```python
app = FastAPI(title=settings.APP_NAME)

# 1. CORS (ilk)
app.add_middleware(CORSMiddleware, allow_origins=settings.CORS_ORIGINS, allow_methods=["*"], allow_headers=["*"])

# 2. Exception handlers
@app.exception_handler(NotFoundException) ...
@app.exception_handler(Exception) ...

# 3. Routers (sonra)
app.include_router(auth_router, prefix="/api/auth")
app.include_router(product_router, prefix="/api/products")
```

### Django Config (settings.py)
```python
# SIRA ÖNEMLİ — INSTALLED_APPS
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',          # Auth sistemi
    'rest_framework',               # DRF
    'corsheaders',                  # CORS (middleware'den ÖNCE ekle)
    'apps.accounts',                # Kendi app'lerin
    'apps.products',
]

# MIDDLEWARE SIRA
MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',  # 1️⃣ İLK: CORS
    'django.middleware.security.SecurityMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',  # Auth
    'django.contrib.messages.middleware.MessageMiddleware',
]
```

---

## 🟢 Node.js (Express)

### Config Pattern
```javascript
// config/index.js
require('dotenv').config();
module.exports = {
    port: process.env.PORT || 3000,
    mongoUri: process.env.MONGO_URI,
    jwtSecret: process.env.JWT_SECRET,
    jwtExpiry: process.env.JWT_EXPIRY || '15m',
    corsOrigin: process.env.CORS_ORIGIN || 'http://localhost:5173',
};
```

### Express Middleware Sırası
```javascript
const app = express();

// 1. Parser (ilk)
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// 2. CORS
app.use(cors({ origin: config.corsOrigin, credentials: true }));

// 3. Logging
app.use(morgan('dev'));

// 4. Static files
app.use('/uploads', express.static('uploads'));

// 5. Routes
app.use('/api/auth', authRouter);
app.use('/api/products', authMiddleware, productRouter);

// 6. 404 handler
app.use((req, res) => res.status(404).json({ message: 'Not found' }));

// 7. Error handler (EN SON!)
app.use(errorHandler);
```

---

## ☕ Java (Spring Boot)

### Config Dosyaları
| Dosya | Format |
|-------|--------|
| `application.properties` | `key=value` (basit) |
| `application.yml` | YAML (okunabilir, önerilen) |
| `application-dev.yml` | Dev ortamı |
| `application-prod.yml` | Prod ortamı |

```yaml
# application.yml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/myapp
    username: ${DB_USER}
    password: ${DB_PASS}
  jpa:
    hibernate:
      ddl-auto: update  # Dev: update, Prod: validate
    show-sql: true       # Dev: true, Prod: false
server:
  port: 8080
jwt:
  secret: ${JWT_SECRET}
  expiration: 900000     # 15 dakika (ms)
```

### Bean/Config Sırası
```java
@Configuration
public class SecurityConfig {
    // FilterChain sırası önemli
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http
            .csrf(c -> c.disable())                    // 1. CSRF kapat (API)
            .cors(c -> c.configurationSource(corsConfig())) // 2. CORS
            .authorizeHttpRequests(a -> a
                .requestMatchers("/api/auth/**").permitAll()  // 3. Public
                .anyRequest().authenticated())                 // 4. Protected
            .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class) // 5. JWT
            .build();
    }
}
```

---

## 🟣 PHP (Laravel)

### Config Dosyaları
```
config/
├── app.php        → APP_NAME, APP_ENV, timezone, providers
├── database.php   → DB bağlantısı (MySQL/PG)
├── auth.php       → guards, providers
├── cors.php       → CORS ayarları
├── cache.php      → Cache driver (file/redis)
├── mail.php       → SMTP ayarları
└── sanctum.php    → API token ayarları
```

### Middleware Sırası (app/Http/Kernel.php)
```php
protected $middleware = [
    TrustProxies::class,
    HandleCors::class,           // CORS (ilk)
    PreventRequestsDuringMaintenance::class,
    ValidatePostSize::class,
    TrimStrings::class,
    ConvertEmptyStringsToNull::class,
];

protected $middlewareGroups = [
    'api' => [
        EnsureFrontendRequestsAreStateful::class,  // Sanctum
        'throttle:api',                              // Rate limit
        SubstituteBindings::class,
    ],
];
```

---

## 📱 Flutter

### Config Dosyaları
| Dosya | Ne İçerir |
|-------|----------|
| `pubspec.yaml` | Dependencies, assets, fonts |
| `lib/core/constants.dart` | API URL, app name, timeouts |
| `android/app/build.gradle` | Min SDK, target SDK, permissions |
| `ios/Runner/Info.plist` | iOS permissions, URL scheme |
| `.env` | API keys (flutter_dotenv) |

### Dependency Injection Sırası
```dart
void main() async {
    WidgetsFlutterBinding.ensureInitialized();  // 1. Flutter binding
    await dotenv.load();                         // 2. Env yükle
    await Hive.initFlutter();                    // 3. Local DB
    await Firebase.initializeApp();              // 4. Firebase (varsa)
    runApp(
        MultiProvider(                           // 5. State management
            providers: [
                ChangeNotifierProvider(create: (_) => AuthProvider()),
                ChangeNotifierProvider(create: (_) => ProductProvider()),
            ],
            child: MyApp(),
        ),
    );
}
```

---

## ⚠️ EVRENSEL CONFIG KURALLARI

```
1. Secret → .env → .gitignore (ASLA hardcode)
2. Ortam ayrımı → dev/staging/prod ayrı config
3. Middleware/pipeline SIRA önemli → yanlış sıra = çalışmaz
4. Port çakışması → her servis farklı port
5. DB connection string → ortama göre değişir
6. Log seviyesi → Dev: Debug, Prod: Warning
7. CORS → Dev: localhost, Prod: gerçek domain
```
