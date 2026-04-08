# 🐛 Debug Tips — Spring Boot + Angular
- **CORS 403**: `CorsConfig` → `addAllowedOrigin("http://localhost:4200")`
- **JPA LazyInit**: `@Transactional` service method'da
- **N+1 Query**: `@EntityGraph(attributePaths)` veya `JOIN FETCH`
- **Angular DI**: `providedIn: 'root'` veya module `providers` array
- **RxJS leak**: `takeUntilDestroyed()` veya `async` pipe
- **JWT 401**: Token expired? Header `Bearer` prefix doğru mu?

## 📓 Debug Günlüğü
| Tarih | Hata | Çözüm |
|-------|------|--------|
| [—]   | [—]  | [—]    |
