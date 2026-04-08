# 🌐 REST-API.md — RESTful API Best Practices

---

## 📐 URL Yapısı
```
GET    /api/products              → Tüm ürünleri listele
GET    /api/products/123          → Tek ürün detayı
POST   /api/products              → Yeni ürün oluştur
PUT    /api/products/123          → Ürünü güncelle (tamamı)
PATCH  /api/products/123          → Ürünü kısmen güncelle
DELETE /api/products/123          → Ürünü sil
GET    /api/products/123/reviews  → Ürünün yorumları (nested)
```

### Kurallar
- ✅ Çoğul isim: `/products` (tekil `/product` değil)
- ✅ Kebab-case: `/user-profiles` (snake_case veya camelCase değil)
- ✅ Fiil yok URL'de: `/api/products` (~~`/api/getProducts`~~)
- ✅ Versiyonlama: `/api/v1/products`
- ✅ Filtreleme: Query param → `/api/products?category=electronics&sort=price`

---

## 📊 HTTP Status Codes
| Kod | Anlam | Ne Zaman |
|-----|-------|----------|
| 200 | OK | GET başarılı |
| 201 | Created | POST başarılı |
| 204 | No Content | DELETE başarılı |
| 400 | Bad Request | Validation hatası |
| 401 | Unauthorized | Token yok/geçersiz |
| 403 | Forbidden | Yetki yetersiz |
| 404 | Not Found | Kayıt bulunamadı |
| 409 | Conflict | Duplicate (unique violation) |
| 422 | Unprocessable | Veri doğrulama hatası |
| 429 | Too Many Requests | Rate limit aşıldı |
| 500 | Server Error | Beklenmeyen hata |

---

## 📦 Response Format
```json
// Başarılı
{
    "success": true,
    "data": { "id": 1, "name": "Ürün" },
    "message": "Ürün oluşturuldu"
}

// Liste + Pagination
{
    "success": true,
    "data": [...items],
    "pagination": {
        "page": 1,
        "pageSize": 20,
        "totalItems": 150,
        "totalPages": 8
    }
}

// Hata
{
    "success": false,
    "error": {
        "code": "VALIDATION_ERROR",
        "message": "Email alanı gerekli",
        "details": [{ "field": "email", "message": "Email boş olamaz" }]
    }
}
```

---

## 🔒 API Güvenlik Checklist
- [ ] HTTPS (TLS) zorunlu
- [ ] JWT/API Key authentication
- [ ] Rate limiting (429)
- [ ] Input validation (SQL injection, XSS)
- [ ] CORS doğru ayarlanmış
- [ ] Sensitive data (password hash) response'da yok
- [ ] Pagination (büyük veri setleri)
- [ ] Request/Response logging
- [ ] Error handling (500'lerde detay gösterme production'da)

---

## 📑 API Dokümantasyon
| Teknoloji | Araç |
|-----------|------|
| .NET | Swagger (Swashbuckle) |
| FastAPI | Swagger + ReDoc (built-in!) |
| Django | drf-spectacular |
| Express | swagger-jsdoc + swagger-ui-express |
| Spring | SpringDoc OpenAPI |
| Laravel | Scribe (l5-swagger) |
