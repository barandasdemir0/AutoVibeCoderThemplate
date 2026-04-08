# 🔐 AUTH-JWT.md — Kimlik Doğrulama & Yetkilendirme Rehberi

> JWT, OAuth, Session — her backend için auth mantığı ve best practice.

---

## JWT (JSON Web Token) Akışı
```
1. Client → POST /api/auth/login { email, password }
2. Server → Password hash doğrula → JWT token üret (access + refresh)
3. Server → Response { accessToken (15dk), refreshToken (7gün) }
4. Client → Token'ı sakla (HttpOnly Cookie veya localStorage)
5. Client → Her request: Authorization: Bearer {accessToken}
6. Server → Middleware: Token doğrula, claim'leri çıkar
7. Token expired → Client POST /api/auth/refresh { refreshToken }
```

## Token Nerede SAKLANIR?
| Yöntem | Güvenlik | XSS | CSRF |
|--------|----------|-----|------|
| **HttpOnly Cookie** | ✅ En güvenli | ✅ Korumalı | ⚠️ CSRF token gerekir |
| **localStorage** | ⚠️ Orta | ❌ XSS riski | ✅ CSRF'den etkilenmez |
| **sessionStorage** | ⚠️ Orta | ❌ XSS riski | ✅ |
| **Mobil Secure Storage** | ✅ Güvenli | — | — |

> **Best Practice**: Web → HttpOnly Cookie, Mobile → Secure Storage

## Access Token + Refresh Token (Rotation Kuralı Zorunludur)
```
Access Token → Kısa ömürlü (15-30 dk) → Her request'te gönderilir
Refresh Token → Uzun ömürlü (7-30 gün) → Sadece token yenileme için

ZORUNLU KURAL (Refresh Token Rotation): 
Refresh token her kullanıldığında (yeni access token alınırken) ESKİ refresh token IPTAL EDILMELI ve YENI bir refresh token dönülmelidir. Eğer çalınmış bir eski refresh token tekrar denenirse, o kullanıcıya ait TÜM refresh token zincirleri geçersiz kılınmalıdır (Invalidate all).
```

## Teknolojiye Göre JWT

### .NET
```csharp
// Token üretme
var claims = new[] { new Claim(ClaimTypes.Email, user.Email), new Claim(ClaimTypes.Role, user.Role) };
var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Jwt:Secret"]));
var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
var token = new JwtSecurityToken(claims: claims, expires: DateTime.UtcNow.AddMinutes(15), signingCredentials: creds);
return new JwtSecurityTokenHandler().WriteToken(token);

// Program.cs → Authentication
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(o => { o.TokenValidationParameters = new() { ... }; });
```

### Python (FastAPI / Django)
```python
# FastAPI → python-jose
from jose import jwt
token = jwt.encode({"sub": user.email, "exp": datetime.utcnow() + timedelta(minutes=15)}, SECRET_KEY)

# Django → SimpleJWT (otomatik)
path('api/token/', TokenObtainPairView.as_view()),
path('api/token/refresh/', TokenRefreshView.as_view()),
```

### Node.js
```javascript
const jwt = require('jsonwebtoken');
const token = jwt.sign({ id: user.id, role: user.role }, process.env.JWT_SECRET, { expiresIn: '15m' });
// Middleware
const decoded = jwt.verify(token, process.env.JWT_SECRET);
```

### Spring Boot
```java
// JwtProvider
String token = Jwts.builder().setSubject(email).setExpiration(new Date(System.currentTimeMillis() + 900000))
    .signWith(key).compact();
```

---

## 🎭 Role-Based Access Control (RBAC)
```
Roller: Admin, Editor, User, Guest
           Admin → Tüm yetkiler
           Editor → CRUD (kendi verisi + başkasını görme)
           User → Read + kendi CRUD
           Guest → Sadece public read
```

| Teknoloji | Yetkilendirme |
|-----------|---------------|
| .NET | `[Authorize(Roles = "Admin")]` |
| Django | `permission_classes = [IsAdminUser]` |
| Express | `authorize(['admin'])` middleware |
| Spring | `@PreAuthorize("hasRole('ADMIN')")` |
| Laravel | `$this->middleware('role:admin')` |
| Flutter | Route guard + token role claim |
| React | `<ProtectedRoute roles={['admin']}>` |

---

## 🔑 İleri Seviye Güvenlik (OAuth2.0 & MFA)

### 1. OAuth2.0 (Google / Apple Sign-In)
Yapay Zeka OAuth kurgularken aşağıdaki akışı ZORUNLU olarak izlemelidir:
```
1. Client (Mobil/Web) → Google/Apple SDK'sı ile login olur ve bir `id_token` alır.
2. Client → Bize (Backend) POST /api/auth/social { provider: 'google', token: id_token } atar.
3. Backend → Asla client'a güvenmez. Gidip Google'ın endpointine (Google Auth Library) bu tokenı doğrulatır (Verify).
4. Backend → Doğruysa kendi sistemimizde kullanıcıyı yaratır veya bulur.
5. Backend → KENDI JWT (Access+Refresh) token'ımızı üretip döner.
```

### 2. Multi-Factor Authentication (2FA/MFA)
Finans, Sağlık veya Yönetici panellerinde 2FA desteklenmeli/zorunlu tutulmalıdır:
```
A. TOTP (Google Authenticator) Akışı:
   - Backend bir Secret üretir (örn: speakeasy pkgs ile).
   - QR kod uri (otpauth://) dönülür. Client bunu QR koda çevirir.
   - Kullanıcı koda okutup 6 haneli şifreyi girer (POST /api/auth/2fa/verify).
   - Doğrulanırsa User tablosunda `IsTwoFactorEnabled = true` yapılır.

B. SMS / Email OTP:
   - Login sonrası token DÖNÜLMEZ. Bunun yerine 202 Accepted ve `otp_token` dönülür.
   - 6 haneli kod mail/sms atılır. Hashelenerek veya Redis'te TTL (3dk) ile tutulur.
   - Client POST /api/auth/verify-otp atar, kod doğruysa asıl JWT tokenı üretilip dönülür.
```
