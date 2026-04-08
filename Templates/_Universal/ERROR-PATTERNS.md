# 🔍 ERROR-PATTERNS.md — AI İçin Hata Pattern Tanıma ve Otomatik Çözüm

> AI bu dosyayı okuyarak, hata mesajından ANINDA sebep ve çözüm bulacak.
> Her stack için en sık karşılaşılan hatalar ve kesin çözümleri.

---

## 📱 Flutter / Dart Hataları

| Hata Mesajı | Sebep | Çözüm |
|-------------|-------|-------|
| `MissingPluginException` | Plugin native tarafta register olmamış | `flutter clean && flutter pub get && flutter run` |
| `setState() called after dispose()` | Widget dispose edildikten sonra state güncelleme | `if (mounted) setState(...)` kontrolü ekle |
| `RenderFlex overflowed by X pixels` | UI taşması (yatay/dikey) | `SingleChildScrollView` sar, `Expanded` veya `Flexible` kullan |
| `type 'Null' is not a subtype of type 'String'` | Null safety hatası | `?.` operatörü veya `?? defaultValue` kullan |
| `Firebase not initialized` | `Firebase.initializeApp()` çağrılmamış | `main()` → `WidgetsFlutterBinding.ensureInitialized()` + `await Firebase.initializeApp()` |
| `CERTIFICATE_VERIFY_FAILED` | SSL sorunu (debug modda) | `HttpOverrides.global = MyHttpOverrides()` (SADECE debug) |
| `Unhandled Exception: PlatformException` | Platform izni eksik | AndroidManifest.xml / Info.plist'e permission ekle |
| `A build function returned null` | Widget build() null döndürüyor | `return Container()` veya `SizedBox.shrink()` |
| `Navigator operation requested with a context` | Context yanlış scope'da | `Builder` widget kullan veya `GlobalKey<NavigatorState>` |
| `Waiting for another flutter command to release the startup lock` | Önceki flutter process takılmış | `flutter pub cache repair` veya lock dosyasını sil |
| `Could not find the correct Provider` | Provider ağaçta yukarıda değil | `MultiProvider` en yukarıda mı kontrol et |
| `Bad state: Stream has already been listened to` | Broadcast olmayan stream'e 2. listener | `.asBroadcastStream()` kullan |

---

## ⚛️ React / Next.js Hataları

| Hata Mesajı | Sebep | Çözüm |
|-------------|-------|-------|
| `Hydration failed / Text content mismatch` | Server/client render farklı | `useEffect` içine taşı, `suppressHydrationWarning` veya `dynamic(ssr:false)` |
| `Cannot read properties of undefined` | Object null/undefined | Optional chaining `?.` + default value `?? []` |
| `Module not found: Can't resolve` | Yanlış import path | Büyük/küçük harf kontrol, relative/absolute path doğru mu |
| `Too many re-renders` | useState sonsuz loop | `useEffect` dependency array kontrol et, event handler'da setState |
| `Objects are not valid as React child` | Object'i direkt render etme | `JSON.stringify()` veya `obj.property` kullan |
| `Each child should have a unique "key" prop` | List render'da key eksik | `key={item.id}` ekle (index kullanma) |
| `React Hook cannot be called conditionally` | Hook if/for içinde | Hook'ları component'in en üstüne taşı |
| `Unhandled Runtime Error: fetch failed` | API bağlantı hatası | URL doğru mu, server çalışıyor mu, CORS var mı |
| `NextRouter was not mounted` | Router context dışında kullanım | `'use client'` direktifi ekle |
| `Error: Invariant: headers() expects to have requestAsyncStorage` | Server component'te client işlem | `'use client'` ekle veya server action kullan |

---

## 🔵 .NET / C# Hataları

| Hata Mesajı | Sebep | Çözüm |
|-------------|-------|-------|
| `Unable to resolve service for type` | DI'da register edilmemiş | `builder.Services.AddScoped<IService, Service>()` |
| `A second operation was started on this context` | DbContext thread-safe değil | `AddScoped` kullan, `AddSingleton` KULLANMA |
| `No authenticationScheme was specified` | Auth config eksik | `AddAuthentication().AddJwtBearer(options => ...)` |
| `CORS request rejected` | CORS ayarı eksik/yanlış | `UseCors()` sırası kontrol + `AllowAnyOrigin` veya spesifik origin |
| `Object reference not set to an instance` | NullReferenceException | Null check, `?.` operatörü, `?? default` |
| `The entity type 'X' requires a primary key` | Entity'de [Key] eksik | `[Key]` attribute veya `HasKey()` Fluent API |
| `Cannot implicitly convert type` | Tip uyumsuzluğu | DTO → Entity mapping kontrol (AutoMapper) |
| `Sequence contains no elements` | Boş koleksiyonda First/Single | `FirstOrDefault()` kullan |
| `The SSL connection could not be established` | DB SSL sorunu | Connection string'e `TrustServerCertificate=true` ekle (dev) |
| `An error occurred while updating the entries` | Migration/DB uyumsuzluğu | `dotnet ef database update` çalıştır |

---

## 🐍 Python / FastAPI / Django Hataları

| Hata Mesajı | Sebep | Çözüm |
|-------------|-------|-------|
| `ModuleNotFoundError: No module named` | Package yüklenmemiş | `pip install package_name` + requirements.txt güncelle |
| `422 Unprocessable Entity` | Pydantic validation hatası | Request body schema'yı kontrol et, field tipleri doğru mu |
| `sqlalchemy.exc.OperationalError` | DB bağlantısı yok | Connection string doğru mu, DB çalışıyor mu |
| `RuntimeError: no running event loop` | Async hata | `async def` + `await` kullanmamışsın |
| `ImportError: cannot import name` | Circular import | Import'u fonksiyon içine taşı veya yapıyı değiştir |
| `IntegrityError: UNIQUE constraint failed` | Unique field duplicate | Önce mevcut kayıt kontrol et |
| `PermissionError: [Errno 13]` | Dosya izni yok | Dosya/klasör izinlerini kontrol et |
| `django.db.utils.OperationalError: no such table` | Migration yapılmamış | `python manage.py makemigrations && python manage.py migrate` |
| `TemplateDoesNotExist` | Template path yanlış | `TEMPLATES` settings'deki DIRS kontrol et |
| `CORS header 'Access-Control-Allow-Origin' missing` | CORS middleware eksik | `django-cors-headers` kur + MIDDLEWARE'e ekle |

---

## 🟢 Node.js / Express Hataları

| Hata Mesajı | Sebep | Çözüm |
|-------------|-------|-------|
| `Cannot find module` | Module yüklenmemiş veya path yanlış | `npm install` + path kontrol |
| `Error: listen EADDRINUSE` | Port kullanılıyor | Port değiştir veya `npx kill-port 3000` |
| `UnhandledPromiseRejectionWarning` | Async hata yakalanmamış | `try/catch` ekle veya `.catch()` |
| `SyntaxError: Unexpected token` | JSON parse hatası | Request body'de `Content-Type: application/json` header |
| `MongoServerError: E11000 duplicate key` | Unique index çakışması | Duplicate check ekle |
| `JsonWebTokenError: invalid signature` | JWT secret uyuşmuyor | `.env`'deki JWT_SECRET aynı mı |
| `TypeError: Cannot destructure property` | Object undefined | Default value ekle, null check |
| `ECONNREFUSED 127.0.0.1:27017` | MongoDB çalışmıyor | MongoDB servisini başlat |
| `PayloadTooLargeError` | Request body çok büyük | `express.json({ limit: '10mb' })` |

---

## ☕ Java / Spring Boot Hataları

| Hata Mesajı | Sebep | Çözüm |
|-------------|-------|-------|
| `Consider defining a bean of type` | Bean DI'da register değil | `@Service`, `@Repository`, `@Component` annotation |
| `No qualifying bean of type` | Interface'in implementation'ı yok | `@Service` annotation eklendi mi |
| `Access Denied (403)` | Yetki yetersiz | SecurityConfig'de endpoint izinleri kontrol |
| `Table 'X' doesn't exist` | Migration/DDL yapılmamış | `spring.jpa.hibernate.ddl-auto=update` |
| `HttpMediaTypeNotSupportedException` | Content-Type yanlış | `@RequestBody` + `application/json` |
| `LazyInitializationException` | Session kapalıyken lazy load | `@Transactional` veya `JOIN FETCH` |
| `MethodArgumentNotValidException` | `@Valid` validation hatası | `@ExceptionHandler` ile yakalayıp 400 dön |
| `CircularDependencyException` | Döngüsel bağımlılık | `@Lazy` annotation veya yapıyı refactor et |

---

## 🟣 PHP / Laravel Hataları

| Hata Mesajı | Sebep | Çözüm |
|-------------|-------|-------|
| `SQLSTATE[42S02]: Table not found` | Migration yapılmamış | `php artisan migrate` |
| `Class "App\Models\X" not found` | Namespace yanlış | `composer dump-autoload` + namespace kontrol |
| `TokenMismatchException` | CSRF token eksik | `@csrf` directive form'a ekle |
| `Unauthenticated (401)` | Sanctum/Passport token yok | `Authorization: Bearer token` header ekle |
| `CORS error` | CORS config eksik | `config/cors.php` → allowed_origins ayarla |
| `The GET method is not supported` | Route method yanlış | `Route::post()` vs `Route::get()` kontrol |
| `Mass assignment exception` | `$fillable` tanımlı değil | Model'de `$fillable = [...]` ekle |

---

## 📱 Kotlin / Android Hataları

| Hata Mesajı | Sebep | Çözüm |
|-------------|-------|-------|
| `NetworkOnMainThreadException` | Ana thread'de network | `viewModelScope.launch { }` + `Dispatchers.IO` |
| `android.os.FileUriExposedException` | File URI paylaşımı | `FileProvider` kullan |
| `Hilt: Missing binding` | DI modül eksik | `@Module` + `@Provides` + `@InstallIn` |
| `RecyclerView: No adapter attached` | Adapter set edilmemiş | `onCreateView`'da adapter'ı bağla |
| `Activity not found` | Manifest'te tanımlı değil | `AndroidManifest.xml`'e `<activity>` ekle |
| `Room schema changed` | DB version güncellenmemiş | `@Database(version = X+1)` + migration ekle |

---

## 🍎 Swift / SwiftUI Hataları

| Hata Mesajı | Sebep | Çözüm |
|-------------|-------|-------|
| `Thread 1: Fatal error: Unexpectedly found nil` | Force unwrap nil | `guard let` veya `if let` kullan |
| `Cannot convert value of type` | Tip uyumsuzluğu | Explicit type casting veya correct type |
| `Publishing changes from background thread` | UI update background'da | `@MainActor` veya `DispatchQueue.main.async` |
| `Modifying state during view update` | View render sırasında state change | `DispatchQueue.main.async` ile ertele |
| `The compiler is unable to type-check` | View body çok karmaşık | Sub-view'lara böl |

---

## 🌐 Genel / Cross-Stack Pattern'ler

### Hata Tipi → İlk Kontrol Noktası
```
Import/Module Error    → Package installed? Path doğru? Büyük/küçük harf?
Type Error             → Gönderilen tip doğru mu? Null mı? Cast gerekiyor mu?
Network Error          → URL doğru? CORS? Server açık? SSL?
Auth Error             → Token var mı? Geçerli mi? Header format doğru mu?
Build/Compile Error    → Syntax? Version uyumu? Missing dependency?
Runtime Error          → Null check? Async/await? Lifecycle? Threading?
DB Error               → Connection string? Migration? Table exists?
Permission Error       → File/folder izni? Platform permission? Auth role?
```

### AI İçin Hata Çözme Algoritması
```
1. Hata mesajını TAM oku (stack trace dahil)
2. Bu dosyada (ERROR-PATTERNS.md) ara → eşleşme var mı?
3. VARSA → çözümü uygula
4. YOKSA →
   a. Hatanın olduğu dosyayı aç
   b. Import chain'i kontrol et (bağımlı dosyalar)
   c. Son değişiklikleri gözden geçir (FILE-TRACKER.md)
   d. CONFIG-RULES.md'de pipeline/middleware sırası doğru mu kontrol et
   e. Çöz
5. ÇÖZDÜKTEN SONRA:
   a. Bu dosyaya (ERROR-PATTERNS.md) yeni pattern ekle
   b. 05-DebugTips.md'ye hata+çözüm kaydet
   c. FILE-TRACKER.md'ye hata kartı ekle
```
