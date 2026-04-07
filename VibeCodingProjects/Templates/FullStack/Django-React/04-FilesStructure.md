# 📂 Files | 🐛 Debug | 📚 Resources — Django + React (Supplementary)
## Files
```
backend/ → config/ (settings, urls), apps/ (accounts/, products/), manage.py, requirements.txt
frontend/ → src/ (components/, pages/, services/, hooks/, store/), package.json, vite.config.js
```
## Best Practices
- **Fat Model, Thin View**: İş mantığı model'de, view sadece orchestration
- **select_related/prefetch_related**: N+1 query engelle
- **Serializer Validation**: `validate_<field>()` ve `validate()` method
- **Pagination**: `REST_FRAMEWORK → DEFAULT_PAGINATION_CLASS`
- **Filtering**: `django-filter` + `filterset_fields`

## Debug Günlüğü
| Tarih | Katman | Hata | Çözüm |
|-------|--------|------|--------|
| [—]   | [—]    | [—]  | [—]    |
