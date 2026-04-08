# 🔗 INTEGRATION-GUIDE.md — HERHANGİ Backend + Frontend Birleştirme Rehberi

> Bu dosya sayesinde her backend + her frontend'i birleştirebilirsiniz.
> Her permütasyon için ayrı klasör GEREKMEZ — bu rehber evrensel connector'dır.

---

## 🧩 Backend + Frontend Nasıl Birleşir?

Her fullstack proje 5 noktada birleşir:
```
1. CORS          → Backend, frontend'in hangi origin'den geldiğini bilmeli
2. API URL       → Frontend, backend'in adresini bilmeli (.env)
3. Auth Token    → Frontend → token al → her request'e ekle → Backend doğrula
4. Data Format   → JSON request/response, DTO ↔ TypeScript interface eşleşmeli
5. Proxy (Dev)   → Development'ta CORS sorunu olmasın diye proxy ayarla
```

---

## 1️⃣ CORS Ayarları (Backend Tarafı)

| Backend | CORS Nasıl? |
|---------|-------------|
| **.NET** | `builder.Services.AddCors(o => o.AddPolicy("Frontend", p => p.WithOrigins("http://localhost:5173")))` → `app.UseCors("Frontend")` |
| **FastAPI** | `app.add_middleware(CORSMiddleware, allow_origins=["http://localhost:5173"])` |
| **Django** | `pip install django-cors-headers` → `CORS_ALLOWED_ORIGINS = ["http://localhost:5173"]` |
| **Express** | `app.use(cors({ origin: 'http://localhost:5173', credentials: true }))` |
| **Spring** | `@CrossOrigin` veya `CorsConfig` bean |
| **Laravel** | `config/cors.php` → `'allowed_origins' => ['http://localhost:5173']` |

## 2️⃣ API URL (Frontend Tarafı)

| Frontend | Nasıl? |
|----------|--------|
| **React (Vite)** | `.env` → `VITE_API_URL=http://localhost:5000/api` → `import.meta.env.VITE_API_URL` |
| **Angular** | `environments/environment.ts` → `apiUrl: 'http://localhost:5000/api'` |
| **Vue (Vite)** | `.env` → `VITE_API_URL=...` → `import.meta.env.VITE_API_URL` |
| **Next.js** | `.env.local` → `NEXT_PUBLIC_API_URL=...` |
| **Flutter** | `lib/core/constants.dart` → `static const baseUrl = '...'` |
| **React Native** | `.env` → `API_URL=...` (react-native-config) |

## 3️⃣ Auth Token Akışı (Frontend → Backend)

```javascript
// Axios instance (React/Vue/Angular benzer)
const api = axios.create({ baseURL: import.meta.env.VITE_API_URL });

// Request interceptor → her isteğe token ekle
api.interceptors.request.use(config => {
    const token = localStorage.getItem('accessToken');
    if (token) config.headers.Authorization = `Bearer ${token}`;
    return config;
});

// Response interceptor → 401 yakalama
api.interceptors.response.use(
    response => response,
    async error => {
        if (error.response?.status === 401) {
            // Refresh token dene veya login'e yönlendir
            localStorage.removeItem('accessToken');
            window.location.href = '/login';
        }
        return Promise.reject(error);
    }
);
```

## 4️⃣ Data Format Eşleşmesi

```
Backend DTO (C#):                    Frontend Interface (TypeScript):
public class ProductDto              interface Product {
{                                        id: number;
    public int Id { get; set; }          name: string;
    public string Name { get; set; }     price: number;
    public decimal Price { get; set; }   categoryName: string;
    public string CategoryName { get; }  createdAt: string;
    public DateTime CreatedAt { get; }   }
}
```

> **Kural:** Backend `PascalCase` → Frontend `camelCase` 
> JSON serializer otomatik çevirir (.NET: `JsonSerializerOptions.PropertyNamingPolicy = CamelCase`)

## 5️⃣ Proxy (Development Ortamı)

| Frontend | Proxy Config |
|----------|-------------|
| **Vite (React/Vue)** | `vite.config.js → server.proxy: { '/api': { target: 'http://localhost:5000' } }` |
| **Angular** | `proxy.conf.json` → `ng serve --proxy-config proxy.conf.json` |
| **Next.js** | `next.config.js → rewrites: [{ source: '/api/:path*', destination: 'http://localhost:5000/api/:path*' }]` |

---

## 📊 Kombinasyon Matrisi — Hangi Backend + Hangi Frontend?

> Aşağıdaki tablodan herhangi bir satırı seçin. Birleştirme bu dosyadaki 5 adımla yapılır.

| Backend | React | Angular | Vue | Next.js | Flutter | RN |
|---------|-------|---------|-----|---------|---------|-----|
| **.NET** | ✅ Modern | ✅ **Enterprise #1** | ⚠️ Nadir | ⚠️ Nadir | ✅ | ⚠️ |
| **FastAPI** | ✅ ML+Web | ⚠️ Nadir | ✅ İyi | ✅ | ✅ ML | ⚠️ |
| **Django** | ✅ Popüler | ⚠️ Overkill | ⚠️ | ⚠️ | ✅ | ⚠️ |
| **Express** | ✅ **MERN** | ⚠️ | ⚠️ | ✅ | ⚠️ | ✅ **JS Full** |
| **Spring** | ✅ | ✅ **Enterprise #2** | ⚠️ | ⚠️ | ⚠️ | ⚠️ |
| **Laravel** | ⚠️ API | ⚠️ | ✅ **Inertia** | ⚠️ | ⚠️ | ⚠️ |

> ✅ = Önerilen combo | ⚠️ = Yapılabilir ama yaygın değil

**Bu tablo + bu dosyadaki 5 adım ile herhangi bir backend + frontend'i birleştirebilirsiniz.**
**Her kombinasyon için ayrı 6 dosya oluşturmak GEREKSIZ — bu rehber evrensel connector'dır.**
