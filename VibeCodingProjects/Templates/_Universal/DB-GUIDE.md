# 🗄️ DB-GUIDE.md — Veritabanı Seçim & ORM Rehberi

---

## 💾 Hangi Veritabanı, Ne Zaman?

| Veritabanı | Tip | Ne Zaman Kullan? | Ne Zaman KULLANMA |
|-----------|-----|-----------------|-------------------|
| **PostgreSQL** | RDBMS | Karmaşık ilişkiler, JSONB, büyük veri | Çok basit projeler |
| **MySQL/MariaDB** | RDBMS | Web, Laravel/PHP, bilinen | Karmaşık query, JSONB |
| **SQL Server** | RDBMS | .NET, enterprise, Windows | Linux-first, startup |
| **MongoDB** | NoSQL | Flexible schema, document-based | Çok ilişkili veri |
| **Firebase** | NoSQL+BaaS | Mobile MVP, hızlı prototip | Karmaşık query |
| **SQLite** | Embed RDBMS | Mobile local DB, dev/test | Production server |
| **Redis** | In-Memory | Cache, session, pub/sub | Primary DB (tek başına) |

## 🏗️ Code-First vs DB-First

### VibeCoding İçin: ✅ CODE-FIRST
```
Neden Code-First?
1. Kod = tek kaynak (single source of truth)
2. Migration version control'da (Git)
3. AI modeli kodu okuyarak DB'yi anlayabilir
4. Ortam değişikliği kolay (dev→staging→prod)
5. Test veritabanı otomatik oluşturulur

⚠️ MIGRATION KURALI: AI, veritabanı tablolarında güncelleme yaptığında ASLA mevcut veritabanını manuel değiştirdiği kodu varsaymaz. Her model değişikliğinden sonra (Django: makemigrations, EF Core: add-migration) mutlaka bir migration komutu çalıştırılmalı ve repoya (git) commitlenmelidir.
```

### Teknoloji → Code-First Aracı
| Teknoloji | ORM | Migration Aracı |
|-----------|-----|----------------|
| .NET | EF Core | `dotnet ef migrations add` |
| Django | Django ORM | `python manage.py makemigrations` |
| FastAPI | SQLAlchemy | Alembic (`alembic revision --autogenerate`) |
| Laravel | Eloquent | `php artisan migrate` |
| Spring | JPA/Hibernate | `spring.jpa.hibernate.ddl-auto` + Flyway |
| Express | Mongoose | Schema-based (no migration) |
| Express | Prisma | `npx prisma migrate dev` |
| Next.js | Prisma | `npx prisma db push` |
| Flutter | — | Firebase auto / sqflite manual |
| Android | Room | `@Database(version = N)` + Migration |

## 🔗 ORM İlişki Tipleri
```
1-1 (One-to-One):    User ↔ Profile
1-N (One-to-Many):   Category → Products
N-N (Many-to-Many):  Student ↔ Course (junction table)
```

| ORM | 1-1 | 1-N | N-N |
|-----|-----|-----|-----|
| EF Core | `.HasOne().WithOne()` | `.HasMany().WithOne()` | `.HasMany().WithMany()` |
| Django | `OneToOneField` | `ForeignKey` | `ManyToManyField` |
| SQLAlchemy | `relationship(uselist=False)` | `relationship()` | `secondary=assoc_table` |
| Eloquent | `hasOne()` | `hasMany()` | `belongsToMany()` |
| JPA | `@OneToOne` | `@OneToMany` | `@ManyToMany` |
| Mongoose | embedded/ref | `ref` + populate | embedded array |
| Prisma | `@relation` | `[]` array | implicit M2M |

## ⚡ ORM Performance Best Practices
| Sorun | Çözüm |
|-------|-------|
| **N+1 Query** | Eager loading: EF `Include()`, Django `select_related()`, JPA `@EntityGraph` |
| **Büyük veri** | Pagination: `Skip/Take`, `LIMIT/OFFSET`, cursor-based |
| **Yavaş query & Eksik Index** | Sık filtre (WHERE), sıralama (ORDER BY) ve Foreign Key alanlarına mutlaka INDEX konmalıdır (örn: `[Index(nameof(Email))]`). Indexsiz tablolar 100k kayıtta sistemi çökertir. |
| **Connection leak** | Connection pooling, scoped lifetime (per-request) |
| **Veri Kaybı** | SOFT DELETE. Tablolarda asla `DELETE FROM` çalıştırılamaz. Her temel entity'de `IsDeleted` (boolean) ve `DeletedAt` (datetime) olmalıdır. Silme işlemleri sadece bu flagleri günceller (Update). Sorgular default olarak `WHERE IsDeleted = false` koşulunu içermelidir (Global query filter). |
| **Migration conflict** | Merge migration, takım coordination |
