# ⚠️ ERROR-HANDLING.md — Global Hata Yönetimi (Her Stack İçin)

> Her proje için merkezi exception handling — try/catch her yere yazmak yerine tek noktada yakala.

---

## 🎯 Prensip
```
Controller → Service → Repository
     ↑ Hata fırlatır her katmandan
     └── Global Exception Handler YAKALAR → Sentry Düşer → Kullanıcıya düzgün mesaj döner
```

🚨 **İÇ GÜVENLİK KURALI (Client-Safe vs Stacktrace):** 
Uygulamada bir `Exception` (NullReference, DatabaseConnectionError vs.) meydana geldiğinde ZİNHAR Stack Trace (hataya sebep olan dosya yolları, satırlar) HTTP response olarak Frontend/Mobil uygulamaya (*Client*) gönderilmemelidir (Development ortamı hariç).
- **Log (Server-Side):** Tüm Stack trace, payload ve hatanın kendisi Konsola, dosyaya veya Sentry/Datadog APM'e basılmalıdır (`logger.LogError(ex, "DB Failed")`).
- **Response (Client-Side):** Client'a sadece `{"success": false, "message": "Sunucu hatası. Kayıt kodu: X-123"}` dönülmelidir.

## ❌ YAPMA vs ✅ YAP
| ❌ | ✅ |
|----|-----|
| Her method'a try/catch | Global handler + custom exception |
| Stack trace kullanıcıya göster | Production'da genel mesaj, Dev'de detay |
| Exception yutma (catch boş) | Log + anlamlı response |
| HTTP 500 her yerde | Doğru status code (400, 404, 409, 422) |

---

## .NET — Global Exception Middleware
```csharp
// Middleware/ExceptionMiddleware.cs
public class ExceptionMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<ExceptionMiddleware> _logger;
    
    public ExceptionMiddleware(RequestDelegate next, ILogger<ExceptionMiddleware> logger)
    { _next = next; _logger = logger; }
    
    public async Task InvokeAsync(HttpContext context)
    {
        try { await _next(context); }
        catch (NotFoundException ex)
        {
            _logger.LogWarning(ex, "Not found: {Message}", ex.Message);
            context.Response.StatusCode = 404;
            await context.Response.WriteAsJsonAsync(new { success = false, message = ex.Message });
        }
        catch (ValidationException ex)
        {
            _logger.LogWarning(ex, "Validation: {Errors}", ex.Errors);
            context.Response.StatusCode = 400;
            await context.Response.WriteAsJsonAsync(new { success = false, errors = ex.Errors });
        }
        catch (UnauthorizedException ex)
        {
            context.Response.StatusCode = 401;
            await context.Response.WriteAsJsonAsync(new { success = false, message = "Yetkisiz" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Unhandled exception");
            context.Response.StatusCode = 500;
            await context.Response.WriteAsJsonAsync(new { success = false, message = "Sunucu hatası" });
        }
    }
}
// Program.cs → app.UseMiddleware<ExceptionMiddleware>();

// Custom exceptions
public class NotFoundException : Exception { public NotFoundException(string msg) : base(msg) {} }
public class ValidationException : Exception { public List<string> Errors { get; set; } }
```

## Python (FastAPI) — Exception Handler
```python
from fastapi import HTTPException, Request
from fastapi.responses import JSONResponse

class NotFoundException(Exception):
    def __init__(self, message: str): self.message = message

class ValidationError(Exception):
    def __init__(self, errors: list): self.errors = errors

@app.exception_handler(NotFoundException)
async def not_found_handler(request: Request, exc: NotFoundException):
    return JSONResponse(status_code=404, content={"success": False, "message": exc.message})

@app.exception_handler(ValidationError)
async def validation_handler(request: Request, exc: ValidationError):
    return JSONResponse(status_code=400, content={"success": False, "errors": exc.errors})

@app.exception_handler(Exception)
async def global_handler(request: Request, exc: Exception):
    logger.error(f"Unhandled: {exc}", exc_info=True)
    return JSONResponse(status_code=500, content={"success": False, "message": "Sunucu hatası"})
```

## Node.js (Express) — Error Middleware
```javascript
// Custom errors
class AppError extends Error {
    constructor(message, statusCode) {
        super(message);
        this.statusCode = statusCode;
        this.isOperational = true;
    }
}
class NotFoundError extends AppError { constructor(msg) { super(msg, 404); } }
class ValidationError extends AppError { constructor(msg) { super(msg, 400); } }

// Async handler wrapper
const asyncHandler = fn => (req, res, next) => Promise.resolve(fn(req, res, next)).catch(next);

// Global error handler (app.js en son)
app.use((err, req, res, next) => {
    const status = err.statusCode || 500;
    const message = err.isOperational ? err.message : 'Sunucu hatası';
    logger.error(`${status} - ${err.message}`, { stack: err.stack, url: req.url });
    res.status(status).json({ success: false, message });
});
```

## Django — DRF Exception Handler
```python
# core/exception_handler.py
from rest_framework.views import exception_handler
from rest_framework.response import Response

def custom_exception_handler(exc, context):
    response = exception_handler(exc, context)
    if response is not None:
        response.data = {"success": False, "error": response.data}
    else:
        logger.error(f"Unhandled: {exc}", exc_info=True)
        response = Response({"success": False, "message": "Sunucu hatası"}, status=500)
    return response

# settings.py → REST_FRAMEWORK = {'EXCEPTION_HANDLER': 'core.exception_handler.custom_exception_handler'}
```

## Spring Boot — @ControllerAdvice
```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(EntityNotFoundException.class)
    public ResponseEntity<?> handleNotFound(EntityNotFoundException ex) {
        return ResponseEntity.status(404).body(Map.of("success", false, "message", ex.getMessage()));
    }
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<?> handleValidation(MethodArgumentNotValidException ex) {
        var errors = ex.getBindingResult().getFieldErrors().stream()
            .map(e -> e.getField() + ": " + e.getDefaultMessage()).toList();
        return ResponseEntity.badRequest().body(Map.of("success", false, "errors", errors));
    }
    @ExceptionHandler(Exception.class)
    public ResponseEntity<?> handleAll(Exception ex) {
        logger.error("Unhandled", ex);
        return ResponseEntity.status(500).body(Map.of("success", false, "message", "Sunucu hatası"));
    }
}
```

## Laravel — Exception Handler
```php
// app/Exceptions/Handler.php
public function render($request, Throwable $exception)
{
    if ($exception instanceof ModelNotFoundException) {
        return response()->json(['success' => false, 'message' => 'Kayıt bulunamadı'], 404);
    }
    if ($exception instanceof ValidationException) {
        return response()->json(['success' => false, 'errors' => $exception->errors()], 422);
    }
    Log::error($exception);
    return response()->json(['success' => false, 'message' => 'Sunucu hatası'], 500);
}
```

---

## 📱 Frontend Error Handling

### React / Vue / Angular — Axios Interceptor
```javascript
// Tüm HTTP hatalarını tek noktada yakala
axios.interceptors.response.use(
    response => response,
    error => {
        const status = error.response?.status;
        const message = error.response?.data?.message || 'Bir hata oluştu';
        
        if (status === 401) { /* logout + redirect login */ }
        else if (status === 403) { toast.error('Yetkiniz yok'); }
        else if (status === 404) { toast.error('Bulunamadı'); }
        else if (status === 422) { /* form validation errors göster */ }
        else if (status === 429) { toast.warn('Çok fazla istek, bekleyin'); }
        else { toast.error(message); }
        
        return Promise.reject(error);
    }
);
```

### Flutter
```dart
try {
    final response = await dio.get('/products');
} on DioException catch (e) {
    if (e.response?.statusCode == 401) { /* navigate to login */ }
    else if (e.type == DioExceptionType.connectionTimeout) { /* offline mesaj */ }
    else { showSnackBar('Hata: ${e.message}'); }
}
```

---

## 🛠️ Merkezi Loglama ve İzleme (Sentry / Datadog)
Yapay Zeka kodlamayı yaparken `console.log` veya standart terminal logları bırakmakla yetinmemelidir. Global Error Middleware içerisine mutlaka bir merkezi log mekanizması bağlamalıdır.

**Zorunlu Hata İzleme Standardı:**
1. Error handler içerisinde bir 500 hatası düştüğünde, bu hata bir izleme servisine (Örn: **Sentry**, Datadog, Winston file-logger veya Serilog) iletilmelidir.
2. Bu izleme request body, user ID, IP gibi bağlamları (context) hataya dahil etmelidir ki hata kolay çözülebilsin.
