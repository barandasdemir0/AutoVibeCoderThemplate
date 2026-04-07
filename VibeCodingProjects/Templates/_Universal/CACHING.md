# ⚡ CACHING.md — Cache Stratejileri & Implementasyonları

> Her backend ve mobile proje için caching mekanizması.
> Performans artışı, DB yükü azaltma, kullanıcı deneyimi iyileştirme.

---

## 🧠 Cache Nedir? Ne Zaman?

| Durum | Cache Kullan Mı? |
|-------|------------------|
| Sık okunan, nadir değişen veri | ✅ Evet (kategoriler, ayarlar) |
| Kullanıcıya özel dashboard | ⚠️ Kısa TTL ile |
| Gerçek zamanlı veri (chat, stock) | ❌ Hayır |
| API rate limit / session | ✅ Evet |
| DB query sonuçları | ✅ Evet |
| Statik dosyalar (CSS, JS, resim) | ✅ CDN/Browser cache |

## 📊 Cache Katmanları
```
1. Browser Cache   → Static files, ETags (CDN)
2. Application     → In-Memory (IMemoryCache, lru-cache)
3. Distributed     → Redis / Memcached (çoklu sunucu)
4. Database        → Query cache, materialized view
5. Mobile Local    → SQLite, Hive, AsyncStorage
```

---

## 🛠️ Teknolojiye Göre Cache

### .NET — IMemoryCache + Redis
```csharp
// In-Memory (tek sunucu)
builder.Services.AddMemoryCache();

public class ProductService
{
    private readonly IMemoryCache _cache;
    
    public async Task<List<Product>> GetAllAsync()
    {
        return await _cache.GetOrCreateAsync("products_all", async entry =>
        {
            entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(10);
            entry.SlidingExpiration = TimeSpan.FromMinutes(2);
            return await _repo.GetAllAsync();
        });
    }
    
    // Data değişince cache'i temizle
    public async Task CreateAsync(Product p)
    {
        await _repo.CreateAsync(p);
        _cache.Remove("products_all"); // Cache invalidation
    }
}

// Redis (distributed — çoklu sunucu)
builder.Services.AddStackExchangeRedisCache(o => {
    o.Configuration = "localhost:6379";
});
// IDistributedCache inject et, aynı pattern
```

### Python — functools.lru_cache + Redis
```python
# In-Memory (basit)
from functools import lru_cache

@lru_cache(maxsize=128)
def get_settings():
    return db.query(Settings).first()

# Redis
import redis
r = redis.Redis(host='localhost', port=6379, decode_responses=True)

async def get_products():
    cached = r.get("products:all")
    if cached:
        return json.loads(cached)
    products = await db.execute(select(Product))
    r.setex("products:all", 600, json.dumps(products))  # 10 dk TTL
    return products

# Cache invalidation
async def create_product(data):
    await db.execute(insert(Product).values(**data))
    r.delete("products:all")
```

### Node.js — node-cache + Redis
```javascript
// In-Memory
const NodeCache = require('node-cache');
const cache = new NodeCache({ stdTTL: 600 }); // 10 dk default

async function getProducts() {
    const cached = cache.get('products');
    if (cached) return cached;
    const products = await Product.find().lean();
    cache.set('products', products);
    return products;
}

// Redis (ioredis)
const Redis = require('ioredis');
const redis = new Redis();
await redis.set('products', JSON.stringify(data), 'EX', 600);
const cached = JSON.parse(await redis.get('products'));
```

### Django — django-cache-framework
```python
# settings.py
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.redis.RedisCache',
        'LOCATION': 'redis://localhost:6379',
    }
}

# View-level cache
from django.views.decorators.cache import cache_page
@cache_page(60 * 10)  # 10 dk
def product_list(request): ...

# Low-level cache
from django.core.cache import cache
cache.set('products', products, timeout=600)
products = cache.get('products')
```

### Laravel — Cache facade
```php
// Redis / File / Memcached
use Illuminate\Support\Facades\Cache;

$products = Cache::remember('products', 600, function () {
    return Product::with('category')->get();
});

// Cache temizleme
Cache::forget('products');
Cache::flush(); // Tüm cache
```

### Spring Boot — @Cacheable
```java
@EnableCaching // Application class'a ekle

@Service
public class ProductService {
    @Cacheable(value = "products", key = "#id")
    public Product getById(Long id) { return repo.findById(id); }
    
    @CacheEvict(value = "products", key = "#id")
    public void update(Long id, Product p) { repo.save(p); }
    
    @CacheEvict(value = "products", allEntries = true)
    public void deleteAll() { repo.deleteAll(); }
}
// Redis: spring-boot-starter-data-redis
```

---

## 📱 Mobile Cache

### Flutter
```dart
// Hive (key-value, hızlı)
final box = await Hive.openBox('cache');
box.put('products', jsonEncode(products));
final cached = jsonDecode(box.get('products'));

// Cache with TTL
box.put('products_time', DateTime.now().toIso8601String());
final cachedTime = DateTime.parse(box.get('products_time'));
if (DateTime.now().difference(cachedTime).inMinutes > 10) { /* refresh */ }
```

### React Native
```javascript
// AsyncStorage + TTL pattern
const CACHE_TTL = 10 * 60 * 1000; // 10 dk

async function getCached(key) {
    const raw = await AsyncStorage.getItem(key);
    if (!raw) return null;
    const { data, timestamp } = JSON.parse(raw);
    if (Date.now() - timestamp > CACHE_TTL) {
        await AsyncStorage.removeItem(key);
        return null;
    }
    return data;
}

async function setCache(key, data) {
    await AsyncStorage.setItem(key, JSON.stringify({ data, timestamp: Date.now() }));
}
```

---

## ⚠️ Cache Invalidation (En Zor Kısım!)

```
"There are only two hard things in Computer Science: 
 cache invalidation and naming things." — Phil Karlton
```

### Stratejiler
| Strateji | Açıklama | Ne Zaman |
|----------|----------|----------|
| **TTL (Time-to-Live)** | X dakika sonra expire | Basit, çoğu durumda yeterli |
| **Write-through** | Yaz → cache güncelle → DB yaz | Consistency önemli |
| **Write-behind** | Yaz → cache güncelle → DB sonra yaz | High throughput |
| **Cache-aside** | Oku: cache'e bak → yoksa DB → cache'e yaz | En yaygın pattern |
| **Invalidate on write** | Yazma olunca cache.delete() | CRUD uygulamaları |
