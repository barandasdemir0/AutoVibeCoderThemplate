# 3️⃣ Java-SpringBoot - Endüstriyel Kurulum ve Altyapı Adımları (Step-By-Step Setup)

> **OTONOM KOMUT BAŞLATICI VEYA CLI UYARISI:**
>
> Bir Otonom Zeka asistanı Spring Boot projesi başlatırken IDE sihirbazlarına (Spring Initializr web sitesine) ihtiyaç duymaz. Ancak `pom.xml` dosyasındaki asgari bağımlılıkların (Dependencies) The Enterprise Architecture'ı (Kurumsal Mimarisi) ayağa kaldıracak kadar ZIRHLI olduğuna emin olmalıdır. 

---

## 🚀 FAZ 1: POM.XML ve Mükemmel Bağımlılık (Dependency) Zırhı

Projenin Mimarisi ayağa kalkmadan önce `pom.xml` içerisindeki bağımlılıklar "Temiz Kod" prensiplerine ve Güvenlik Zırhlarına MÜHÜRLENİR!

### Adım 1: Kurumsal Kalibre Bağımlıklar

Spring Boot Starter Web ve Data JPA zaten var diye geçiştirilemez. Security, Validation ve MapStruct Otonomi Tarafından şartlar küresine dahil edilir!
```xml
<dependencies>
    <!-- Müşterilerle İletişim: REST API Kalbi -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

    <!-- Veritabanı ve ORM Mapping -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>

    <!-- Hacking Güvenlik Kalkanı 6.0 -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-security</artifactId>
    </dependency>

    <!-- Request (Gelen DTO) Validasyon Zırhı -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-validation</artifactId>
    </dependency>

    <!-- Java Boilerplate Kodunu (Get/Set/Construct) Engelleyen Mühür -->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <optional>true</optional>
    </dependency>

    <!-- DTO-Entity Çevirici Yapay Zekası -->
    <dependency>
        <groupId>org.mapstruct</groupId>
        <artifactId>mapstruct</artifactId>
        <version>1.5.5.Final</version>
    </dependency>

    <!-- PostgreSQL Connection veya MySQL (Seçime Göre) -->
    <dependency>
        <groupId>org.postgresql</groupId>
        <artifactId>postgresql</artifactId>
        <scope>runtime</scope>
    </dependency>
</dependencies>
```

---

## 📦 FAZ 2: Otonomi Katman (Layer) Zırhının İşletimi

XML hazır. Mimar şimdi paket hiyerarşisine girecek ve N-Tier mimarisi için interface/class katmanlarını işletecektir.

### Adım 2: Çekirdek (Base) Mimarinin Kurulumu
Bir Otonomi ajanı her Entity (örneğin User, Product) class'ının içerisine `id`, `createdAt`, `updatedAt` yazarak kod duplication'ı (tekrarlaması) YAPMAZ! Bunun yerine JPA Mimarisi Olan `@MappedSuperclass` ı kurar.

```java
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
@Getter @Setter
public abstract class BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @CreatedDate
    @Column(updatable = false)
    private LocalDateTime createdAt;
    
    @LastModifiedDate
    private LocalDateTime updatedAt;
}
```

### Adım 3: İş Kuralı Zırhı (The Business Service Pattern)

Otonomi asla Controller içine veritabanı kuralı yazmaz (Monolith Spagetti).
Tamamen interface odaklı Service (İş mantığı) şablonu oluşturulur.

**Interface:**
```java
public interface IUserService {
    UserResponseDto createUser(UserCreateDto dto);
    UserResponseDto getUserById(Long id);
}
```

**Implementation (Gerçek İşleyiş):**
```java
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements IUserService {
    // FİELD INJECTION (@Autowired) YASAKTIR! CONSTRUCTOR INJECTION:
    private final UserRepository userRepository;
    private final UserMapper userMapper; // MapStruct mühürü

    @Override
    @Transactional // Exception anında SQL'i GERİ AL!
    public UserResponseDto createUser(UserCreateDto dto) {
        if(userRepository.existsByEmail(dto.getEmail())) {
            throw new BusinessException("Bu e-posta sistemde zaten var!", 400); 
        }
        
        // Entity Çevirisi
        User user = userMapper.toEntity(dto);
        User savedUser = userRepository.save(user);
        
        // DTO Çevirisi ve Response
        return userMapper.toDto(savedUser);
    }
}
```

---

## 🎨 FAZ 3: Dış Dünya İzolasyonu: Global Exception Handling

Ve Otonomi sistemin dış kalkanını (HTTP Müşteri arayüzünü) Kapatmaya Hazırlanıyor.

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ErrorResponse> handleBusinessException(BusinessException ex) {
        // İŞ KURALI HATASINI Temiz JSON olarak dışarı dön! StackTrace Gizli!!!
        ErrorResponse error = new ErrorResponse(ex.getErrorCode(), ex.getMessage());
        return new ResponseEntity<>(error, HttpStatus.valueOf(ex.getErrorCode()));
    }
}
```

**Zeka Son Dokunuşu Yapar:** `application.yml` içerisinde PostgreSQL veritabanı url bağlantısını ayarlar. `mvn spring-boot:run` emri ile Katı Enterprise kurallara harfiyen uyan Mükemmel Java Modülünü Temsili AYAĞA KALDIRIR. Başarı!
