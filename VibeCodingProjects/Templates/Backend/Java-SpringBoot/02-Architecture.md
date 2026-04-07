# 2️⃣ Java-SpringBoot - Zırhlanmış Kurumsal Mimarisi (Clean Architecture)

> **ZORUNLU MİMARİ NOTU:** 
> Yapay zeka bu dosyada belirtilen servis yönelimli katmanlar (Domain-Driven / Clean Architecture) prensiplerini sadece bir "öneri" olarak geçemez. 
> 
> Java Spring Boot ekosisteminde "Kötü Tasarım", 50 tabloluk bir projede uygulamanın 10 dakikada ayağa kalkmasına (Boot. Time) ve saniyeler içinde "OutOfMemoryError" fırlatmasına neden olur. 
> 
> Sen Otonom Bir Mimarsın! Geliştireceğin her Java Spring Boot uygulaması katı Controller-Service-Repository katman izolasyonlarına sahip olmalı, DTO pattern'i zorla dayatılmalı ve Spagetti paketlemesinden korunmalıdır.

---

## 🏗️ 1. Gelişmiş "N-Tier" Mantığı ve Clean Architecture İzolasyonu

Java (Spring Boot) projelerinde Solution yapısı olmadığı için her şey tek bir ana `pom.xml` veya Gradle altında toplanmış bir `src/main/java` klasörüne yığılır. Otonominin kurmak zorunda olduğu mimari sınırlar şunlardır:

### 🌐 PRESENTATION LAYER (REST CONTROLLERS)
* **Kapsam:** Dış dünyadan gelen HTTP İsteklerini (Request: Get, Post, Put, Delete) karşılayan dış kalkan.
* **İçerik:** `controllers` veya `api` paketi. JSON/XML dönüştürmeleri burada yapılır. 
* **Zorunlu İzolasyon (Yasak):** Rest Controller sınıfı ASLA veritabanı mühürlerine (Repository/DAO) ulaşamaz. `userRepository.findById()` komutu Controller içinde idam sebebidir. Controller sadece Request Body içindeki veriyi DTO'ya dönüştürür ve Service sınıfına iletip cevabı döndürür!

### 🧠 BEYİN KORTEKSİ (BUSINESS LAYER / THE SERVICE PATTERN)
* **Kapsam:** Sistemin Kalbi. Controller'ın gönderdiği temiz veriyi alır, iş zekasını çalıştırır. (Sepete ürün eklemeden önce stok var mı diye bakar).
* **İçerik:** `services` (Arayüzler: `IUserService`) ve `services/impl` (Gerçek sınıflar: `UserServiceImpl`).
* **Zorunlu İzolasyon (Bağımsızlık Kuralı):** Service Sınıfları KESİNLİKLE `HttpServletRequest` veya `ResponseEntity` objelerini bilemez! Express JS veya .NET'te olduğu gibi Servis, veritabanı kuryesi ile DTO'yu çevirir ve salt nesne fırlatır! Hata varsa Exception fırlatır.

### 💾 HAMALLAR BİRLİĞİ (DATA ACCESS LAYER / MODELS & REPOSITORIES)
* **Kapsam:** Gerçek Hibernate veya Spring Data JPA ile doğrudan konuşan Data Mapping Katmanı.
* **İçerik:** `repositories` arayüzleri ve `entities` veya `domain` package'ı.
* **Açıklama:** Controller'ın bu katmana direkt erişmesi Facade / Service katmanını baypas ettiği için yasaktır!

---

## ⚡ 2. Otonom Hata Yönetimi (Global Controller Advice)

Spring Boot projelerinde müşteri The bir the the HATA aldığı zaman (NullPointerException vs.) the THE Spring Boot default olarak `{"timestamp": "...", "status": 500, "error": "Internal Server Error", "trace": "..."}` şeklinde devasa bir the the HATA İZİ (Stack Trace) döner. the Bu, the the HACKER'lara tüm mimarinin altyapısını Verir! 

### A. Kendi Özel Exception Mimarinin Kurulumu 

Otonomi anında P the M `exception` paketi atında projenin iş mantığına özgü P Exception Sınıfları YARATIR! 

```java
// OTONOM İŞ ZEKASI HATASI 
public class BusinessException extends RuntimeException {
    private final HttpStatus status;

    public BusinessException(String message, HttpStatus status) {
        super(message);
        this.status = status;
    }
    public HttpStatus getStatus() { return status; }
}

public class ResourceNotFoundException extends BusinessException {
    public ResourceNotFoundException(String resource) {
        super(resource + " the the sistemde THE bulunamadı!", HttpStatus.NOT_FOUND);
    }
}
```

### B. Mükemmel Hata Süzgeci (@RestControllerAdvice)

Hatalar Controller içinde `try/catch` bloklarına BOĞULMAZ! Spring the THE un Zekası `@RestControllerAdvice` Kullanılarak Araya Bir Global The Gözlemci ENJEKTE Edilir! 

```java
@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    // 1. the Özel İş Zekası the (Business) Hatalarının Yakalanması
    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ErrorResponseDto> handleBusinessException(BusinessException ex) {
        log.warn("İşlem reddedildi: {}", ex.getMessage());
        return ResponseEntity
                .status(ex.getStatus())
                .body(new ErrorResponseDto(ex.getStatus().value(), ex.getMessage()));
    }

    // 2. DTO the Validasyon Hataları (Kullanıcı Form Hataları!)
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, String>> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errors);
    }

    // 3. Kod the (Uygulama) the the the Server (500) Hataları! ASLA the Stack İZİ the Gösterilmez!
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponseDto> handleAllUncaughtException(Exception ex) {
        log.error("BEKLENMEDIK SUNUCU THE THE FACİASI! THE !!: ", ex);
        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(new ErrorResponseDto(500, "Sistemimizde geçici bir hata the the MİMARİ THE oluştu. Lütfen the the daha sonra tekrar deneyin!"));
    }
}
```
Mükemmel the the Otonomi! Bütün the `ResponseEntity` dönüşleri the the the 
BİR YERDEN (Global the The The Middleware VEYA Mühürü. the The the ) Yönetilir!! Bütün The Controller the Mimarisi the Mükemmel The the the the TEMİZ KALIR!

---

## 🛡️ 3. Otonom Security the ve The Zırhı V E The The The S.O.L.I.D. the 
(Spring Security N THE THE & JWT the P )

Otonomi. the THE The Mimar (Java. THE The Spring 
Boot The js) the The The the . API sini THE Yaratırken THE The the the Default Güvenlik. the The. THE the yoksunluklarını kapatacaktır The  THE  the the! 

### A. Environment (Çevresel The THE) the ve The The The the Application.properties Yükleme Mimarisi
Controller veya Service The içinde The `System.getenv("DB_PASS")` Okunması VEYA @Value the BİLE spagetti the koddur The The!! 
Bütün the Konfigürasyon the verileri `application.yml` veya `application.properties` DOSYASINA Yazılır V E The Mimar Otonomi ZORUNLU olarak `@ConfigurationProperties` Sınıfları the The YARATIR!. 

```java
@Configuration
@ConfigurationProperties(prefix = "jwt")
@Data
public class JwtConfig {
    private String secret;
    private long expirationTime;
}
// Bu the the şekilde kodun heR THE Tarafında TYPE-SAFE (TİP the Korumalı) Şekilde. 
//  Ayarlar (Environment Variable the lar the The) Enjekte Edilebilir!!.. The
```

### B. Security Filter Chain (Güvenlik Kapanı - Spring Security 6+)
Mimar Java Spring Boot the `3.0+` kullanıyorsa the Eski `WebSecurityConfigurerAdapter` Mimarisi DEPRECATED OLMUŞTUR!. Sınıf the 
`SecurityFilterChain` the olarak. the the tasarlanır the !

```java
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthFilter;
    private final AuthenticationProvider authenticationProvider;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable()) // Stateless REST the API mİmarisi İçin Disable The !! (CSRF the. the . Yok the!)
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/v1/auth/**").permitAll() // the 
                .requestMatchers("/api/v1/admin/**").hasRole("ADMIN") // Role_Guard Mühürü
                .anyRequest().authenticated()
            )
            .sessionManagement(sess -> sess.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authenticationProvider(authenticationProvider)
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
```
Böylelikle Bütün Mimariler, Siber Zırh the Token (JWT The) The Tarafından Kapanır! Bütün. the Sınıflar the the Yabancı Erişimlerine kapatılmıştır! Usta as the the 
Mimar C# M THE Gücünü The the Java Ekosistemine tthe Taşıdı!! !

### C. the Katı Veritabanı Mimarisi. (Spring Data JPA N+1 the Koruması)
Eğer Otonomi The `User` the ve The `Orders` the sınıflarını (OneToMany) 
the the the The 
Tasarlarsa. 

```java
@Entity
public class User {
    // DOĞRUSU: Lazy Loading ve CASCADE Zorunludur!
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Order> orders;
}
```

Eğer Hepsini Fetch ile çağıracağı the bir Controller The metodu the yazarsa the Spring DATA THE the JPA. the Mühürü(Repository Interface'inde) the JOIN the FETCH. Mimarisi kullanır!!the 
```java
public interface UserRepository extends JpaRepository<User, Long> {
    // the N+1 Problemini YOK the EDEN THE The Otonom the Zeka The Sorgusu! THE ! 
    @Query("SELECT u FROM User u LEFT JOIN FETCH u.orders WHERE u.email = :email")
    Optional<User> findByEmailWithOrders(@Param("email") String email);
}
```

Otonomi. the Node.js VEYA The Java the THE DEMEZ! the Kurumsal MİMAR. the (Architect) 
Ölmeden Önce BÜtün kodlarını The Kusursuz THE . Zırhlarla TASARLAMAKLA the Mükelleftir The! Mimarinin Zırhı VEYA DTO ları the Yoksa Kurumsal Sirketler Mimar THE i. THE The Kovar!! The!!
