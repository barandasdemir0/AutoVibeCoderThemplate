# 📝 FILE-TRACKER.md — Dosya Takip & Değişiklik Günlüğü

> **BU DOSYA KRİTİK!** AI her dosya oluşturduğunda/değiştirdiğinde buraya kayıt yapar.
> Hata olduğunda bu log'a bakarak hangi dosyanın ne zaman eklendiğini, 
> neye bağlı olduğunu anında bulursun.

---

## 📋 Kullanım Kuralı (AI İÇİN ZORUNLU)

```
AI her dosya oluşturduğunda bu tabloya bir satır ekler:
| Tarih-Saat | Dosya | Amaç | Bağımlılıklar | Adım |
```

### Örnek Kayıt:
| Tarih | Dosya | Amaç | Bağımlılıklar | Adım |
|-------|-------|------|---------------|------|
| 2026-04-06 14:00 | `Domain/Entities/User.cs` | Kullanıcı entity | — | Mimari kurulum |
| 2026-04-06 14:05 | `Domain/Entities/Product.cs` | Ürün entity | User.cs (CreatedBy FK) | Mimari kurulum |
| 2026-04-06 14:10 | `Infra/Data/AppDbContext.cs` | EF Core DbContext | User.cs, Product.cs | DB kurulum |
| 2026-04-06 14:15 | `Infra/Repos/UserRepository.cs` | User CRUD | AppDbContext.cs, IUserRepo | Repository katmanı |
| 2026-04-06 14:20 | `App/Services/UserService.cs` | İş mantığı | IUserRepo, UserDto | Service katmanı |
| 2026-04-06 14:25 | `API/Controllers/UserController.cs` | HTTP endpoint | UserService | API katmanı |
| 2026-04-06 14:30 | `API/Middleware/ExceptionMiddleware.cs` | Global hata | — | Error handling |
| 2026-04-06 15:00 | `API/Controllers/AuthController.cs` | Login/Register | UserService, JwtService | Auth ekleme |
| 2026-04-06 15:30 | ❌ HATA: `AuthController.cs:42` | JWT token null | JwtService inject eksik | **ÇÖZÜM:** DI'a `AddScoped<IJwtService>` ekle |

---

## 🔍 Hata Takip Şablonu

Hata olduğunda AI bu formatta kayıt yapar:

```
┌─────────────────────────────────────────────┐
│ ❌ HATA KARTI                                │
│ Tarih: 2026-04-06 15:30                     │
│ Dosya: AuthController.cs:42                 │
│ Hata: NullReferenceException                │
│ Mesaj: IJwtService is null                  │
│ Neden: DI container'da register edilmemiş   │
│ Bağlam: 14:25'te UserController ekledikten  │
│         sonra AuthController eklendi ama     │
│         JwtService DI'a eklenmedi           │
│ Çözüm: Program.cs → AddScoped<IJwtService>  │
│ Etkilenen: AuthController, LoginEndpoint    │
│ Durum: ✅ ÇÖZÜLDÜ                           │
└─────────────────────────────────────────────┘
```

---

## 📂 Dosya Bağımlılık Haritası

AI projeyi kurarken bu haritayı oluşturur:

```
Domain/
├── User.cs ─────────────────┐
├── Product.cs ──────────────┤
│                            ▼
Infrastructure/              │
├── AppDbContext.cs ◄────────┘ (DbSet<User>, DbSet<Product>)
├── UserRepository.cs ◄──── AppDbContext + IUserRepo
│                            │
Application/                 │
├── UserService.cs ◄─────── IUserRepo + UserDto
├── UserDto.cs               │
│                            │
WebAPI/                      │
├── UserController.cs ◄──── UserService
├── AuthController.cs ◄──── UserService + JwtService
├── Program.cs ◄─────────── Tüm DI kayıtları burada
└── Middleware/
    └── ExceptionMiddleware ← Global error handler
```

> **KURAL:** Hata olduğunda AI bu haritaya bakarak bağımlılık zincirini takip eder.
> Dosya X'te hata varsa → X'in import ettiği dosyalara bak → sorun orada mı?

---

## 📊 PROJE DOSYA TABLOSU (AI doldurur)

| # | Tarih | Dosya | Amaç | Bağımlılıklar | Durum |
|---|-------|-------|------|---------------|-------|
| 1 | — | — | — | — | ⬜ |
| 2 | — | — | — | — | ⬜ |
| 3 | — | — | — | — | ⬜ |

> Durum: ⬜ Yeni | ✅ Çalışıyor | ❌ Hatalı | 🔄 Değiştirildi

---

## 🔄 DEĞİŞİKLİK LOG

| # | Tarih | Dosya | Değişiklik | Neden |
|---|-------|-------|-----------|-------|
| 1 | — | — | — | — |

> Her dosya değişikliğinde bu tabloya kayıt düşülür.
> "2 gün önce bu dosyaya ne ekledim?" sorusunun cevabı burada.
