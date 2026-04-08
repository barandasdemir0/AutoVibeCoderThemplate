# 📊 LOGGING.md — Evrensel Loglama Mekanizması

> Her projede günlük log tutma, hata takibi ve debug mekanizması.
> AI modeline bu dosyayı okutarak loglama altyapısını projeye ekletebilirsiniz.

---

## 📅 Günlük Log Dosya Yapısı
```
project/
├── logs/
│   ├── 2026-04-06.log       → Günlük log
│   ├── 2026-04-07.log       → Her gün yeni dosya
│   ├── errors/
│   │   └── 2026-04-06.log   → Sadece error seviyesi
│   └── archive/              → Eski loglar (30 gün+)
```

### Log Format (Her Satır)
```
[2026-04-06 14:32:15] [INFO] [UserService] Kullanıcı oluşturuldu: user@mail.com
[2026-04-06 14:33:01] [WARN] [AuthService] Login denemesi başarısız: user@mail.com
[2026-04-06 14:35:22] [ERROR] [ProductController] NullReferenceException → ProductService.GetById(null)
[2026-04-06 14:35:22] [DEBUG] [SQL] SELECT * FROM Products WHERE Id = @id (12ms)
```

### Log Seviyeleri
| Seviye | Ne Zaman | Renk |
|--------|----------|------|
| `DEBUG` | Geliştirme detayı (SQL, object dump) | Gri |
| `INFO` | Normal işlem (kullanıcı giriş, kayıt oluşturma) | Yeşil |
| `WARN` | Dikkat edilmesi gereken (başarısız login, yavaş query) | Sarı |
| `ERROR` | Hata (exception, API fail) | Kırmızı |
| `FATAL` | Uygulama çökmesi (unhandled exception) | Koyu Kırmızı |

---

## 🛠️ Teknolojiye Göre Loglama

### .NET (Serilog)
```csharp
// Program.cs
builder.Host.UseSerilog((ctx, cfg) => cfg
    .WriteTo.Console()
    .WriteTo.File("logs/log-.txt", rollingInterval: RollingInterval.Day)
    .MinimumLevel.Information());

// Kullanım
Log.Information("Kullanıcı {Email} giriş yaptı", user.Email);
Log.Error(ex, "Ödeme işlemi başarısız: {OrderId}", orderId);
```

### Python (logging)
```python
import logging
logging.basicConfig(
    filename=f'logs/{datetime.now().strftime("%Y-%m-%d")}.log',
    level=logging.INFO,
    format='[%(asctime)s] [%(levelname)s] [%(name)s] %(message)s')
logger = logging.getLogger(__name__)
logger.info("Kullanıcı giriş yaptı: %s", email)
logger.error("Hata: %s", str(e), exc_info=True)
```

### Node.js (Winston)
```javascript
const winston = require('winston');
const logger = winston.createLogger({
    format: winston.format.combine(winston.format.timestamp(), winston.format.json()),
    transports: [
        new winston.transports.File({ filename: `logs/${new Date().toISOString().split('T')[0]}.log` }),
        new winston.transports.File({ filename: 'logs/errors/error.log', level: 'error' }),
        new winston.transports.Console({ format: winston.format.simple() })
    ]
});
logger.info('Kullanıcı giriş yaptı', { email, ip: req.ip });
```

### Java (SLF4J + Logback)
```java
private static final Logger logger = LoggerFactory.getLogger(UserService.class);
logger.info("Kullanıcı oluşturuldu: {}", user.getEmail());
logger.error("Hata: ", exception);
// logback-spring.xml → günlük dosya, rolling policy
```

### PHP (Laravel)
```php
Log::info('Kullanıcı giriş yaptı', ['email' => $user->email]);
Log::error('Ödeme hatası', ['order_id' => $orderId, 'error' => $e->getMessage()]);
// storage/logs/laravel-2026-04-06.log (daily channel)
```

### Mobile (Flutter / React Native)
```dart
// Flutter — logger package
final log = Logger();
log.i('Sayfa açıldı: HomeScreen');
log.e('API hatası', error: e, stackTrace: st);
```
```javascript
// React Native — react-native-logs
const log = logger.createLogger();
log.info('Screen opened: Home');
log.error('API error:', error);
```

---

## 📝 Proje Günlüğü (Manuel)

Her gün proje çalışması sonunda AI'a veya kendinize şu formatı doldurun:

```markdown
## [2026-04-06] — Günlük Rapor
### Yapılanlar
- [x] User model oluşturuldu
- [x] Auth endpoint'leri yazıldı

### Karşılaşılan Hatalar
| Hata | Çözüm | Süre |
|------|--------|------|
| JWT decode fail | Secret key .env'de yanlıştı | 15dk |

### Yarın Yapılacaklar
- [ ] Product CRUD
- [ ] Frontend entegrasyonu

### Notlar
- Serilog ile günlük dosya loglama eklendi
```
