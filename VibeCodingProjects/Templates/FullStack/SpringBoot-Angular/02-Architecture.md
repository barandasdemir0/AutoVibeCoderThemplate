# 🏗️ Architecture | 📂 Files | 🐛 Debug | 📚 Resources — Spring Boot + Angular

## Dosya Açıklamaları
| Dosya | Ne İş Yapar |
|-------|-------------|
| `entity/*.java` | JPA Entity → DB tablo tanımı (`@Entity`, `@Id`, ilişkiler) |
| `repository/*.java` | `JpaRepository<T, ID>` → CRUD + custom query |
| `service/*.java` | İş mantığı, `@Transactional`, exception handling |
| `dto/*.java` | API request/response (Entity'den ayrı) |
| `mapper/*.java` | MapStruct `@Mapper` → Entity ↔ DTO |
| `controller/*.java` | `@RestController` → HTTP endpoints |
| `security/JwtFilter.java` | Her request'te token doğrulama |
| `core/guards/*.ts` | Angular route koruma |
| `core/interceptors/*.ts` | Angular HTTP token ekleme |
| `features/*/*.module.ts` | Angular lazy-loaded feature module |

## JPA Best Practices
```java
// Lazy loading + N+1 çözümü
@EntityGraph(attributePaths = {"category", "tags"})
List<Product> findAll();

// Projection (sadece gerekli alanlar)
@Query("SELECT new com.project.dto.ProductSummary(p.id, p.name, p.price) FROM Product p")
List<ProductSummary> findAllSummaries();

// Pagination
Page<Product> findByCategory(String category, Pageable pageable);
```

## Angular Service + RxJS
```typescript
@Injectable({ providedIn: 'root' })
export class ProductService {
    constructor(private http: HttpClient) {}
    getAll(): Observable<Product[]> {
        return this.http.get<Product[]>(`${environment.apiUrl}/products`);
    }
}
// Template: {{ products$ | async }}
```

## Debug Tips
| Sorun | Çözüm |
|-------|-------|
| LazyInitException | `@Transactional` service'e ekle |
| N+1 Query | `@EntityGraph` veya JPQL fetch join |
| CORS 403 | `CorsConfig` bean veya `@CrossOrigin` |
| Angular "No provider" | `providedIn: 'root'` veya module providers |
| RxJS memory leak | `async` pipe veya `takeUntilDestroyed()` |

## Resources
| Kaynak | Link |
|--------|------|
| Spring Boot | https://spring.io/projects/spring-boot |
| Angular | https://angular.dev |
| Spring Data JPA | https://spring.io/projects/spring-data-jpa |
| MapStruct | https://mapstruct.org |
| Baeldung | https://www.baeldung.com |
