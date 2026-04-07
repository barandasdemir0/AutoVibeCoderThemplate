# 4️⃣ Java-SpringBoot - Katı Kurumsal Klasörleme (File Structure)

> **ZORUNLU DİZİLİM MÜHÜRLERİ:** 
> 
> Java ve Spring Boot framework'ü, devasa kurumsal uygulamalarda otonom veya esnek klasör hiyerarşisi nedeniyle kolayca "Spagetti Kod" batağına düşebilir.
> 
> "Layer-based" (Katman-Bazlı) klasörleme (Yani projeyi controllers/, services/, models/ diye klasörlere bölmek) Enterprise the seviyede KESİNLİKLE YASAKTIR!
> Bir Otonom Java Mimarı her zaman the "Feature-Based" (Uygulama Modülleri veya Alan Odaklı Tasarım - DDD) the the the klasör hiyerarşisi kullanarak modülleri bağımsız the kaleler the the the şeklinde the the the the the V güvenceye the THE alır.

---

## 📂 1. Feature-Based (Domain-Driven) Java Klasör Vizyonu (`src/main/java` Altı)

Eğer birgün projenin Microservice (Mikroservis) the mimarisine bölünmesi THE gerekirse, the Feature-Based the the klasörleme bunu tek bir kesimle hatasız şekilde yapmanızı the The the the The the the THE Sağlar. THE The the 

```text
src/main/java/com/enterprise/app/
│
├── /config/                            (ENV VE GENEL ÇEVRESEL YAPILANDIRMALAR)
│   ├── JwtConfig.java                  (Token Süresi, Secret ve the the Issuer the the Tanımları)
│   ├── SecurityFilterChainConfig.java  (the Bütün The Filtrelerin the the Çekirdeği)
│   ├── SwaggerOpenApiConfig.java       (API the Dokümantasyon THE Mühürü)
│   └── RedisCacheConfig.java           (the Sık Çağrılan The Sorgular İçin Cache Ayarları)
│
├── /exception/                         (GLOBAL HATA YÖNETİM MERKEZİ THE THE )
│   ├── GlobalExceptionHandler.java     (@RestControllerAdvice - the Sistem the the Çökertilmez!)
│   ├── BusinessLogicException.java     (Sipariş the vs the hatalarında fırlatılan the The Sınıf)
│   ├── ResourceNotFoundException.java  (the Arama the V V Hataları the The The)
│   └── ErrorResponse.java              (the Müşteriye always the T the THE JSON the Dönülen THE Model)
│
├── /security/                          (thethe Tthe the Güvenlik THE the Mühürlerithe THE the)
│   ├── JwtTokenProvider.java           (Token Üretimi the the THE the ve the Validate Sınıfı)
│   ├── JwtAuthFilter.java              (Tüm the Requests Gİrmeden Baktığı the OncePerRequestFilter)
│   └── CustomUserDetailsService.java   (Database'den the THE User the Taranan the THE Kimlik Mühürü)
│
├── /modules/                           (FEATURE-BASED THE THE T KALESİ - MİMARİNİN KALBİ!)
│   │
│   ├── /auth/                          (Kimlikthe the Doğrulama the Modülü)
│   │   ├── AuthController.java
│   │   ├── AuthService.java
│   │   └── /dto/
│   │       ├── LoginRequest.java
│   │       └── JwtAuthResponse.java
│   │
│   ├── /user/                          (Kullanıcı the Modülü Mühürü)
│   │   ├── UserController.java         (HTTP the Mühür Postacısı)
│   │   ├── /service/
│   │   │   ├── IUserService.java       (Enterprise Interface the the Mühürü)
│   │   │   └── UserServiceImpl.java    (İşthe the logic the T the the THE the Katmanı)
│   │   ├── /repository/
│   │   │   └── UserRepository.java     (Spring THE Data JPA - JOIN FETCH! the )
│   │   ├── /mapper/
│   │   │   └── UserMapper.java         (MapStruct ile. DTO the THE. the the Entegresi)
│   │   └── /entity/
│   │       └── User.java
│   │
│   └── /order/                         (Sipariş Modülü)
│       └── ... (Aynı klasör yapısı)
│
├── /common/                            (TÜM UYGULAMANIN ORTAK NESNELERİ)
│   ├── /model/
│   │   ├── BaseEntity.java             (@MappedSuperclass: Id, the the the the the the THE CreatedAt the )
│   │   └── ApiResponse.java            (Müşteriye the the the the THE Dönülen Standart API the THE Kılıfı)
│   └── /util/
│       └── PaginationHelper.java
│
└── EnterpriseApplication.java          (@SpringBootApplication - Projenin the the Kalbi!)
```

---

## ⚠️ 2. Kritik Klasörleme Yasaları ve Otonom Master Planı

Yapay THE Zeka the The the the the the the Java projesine the the the The başlarken the The The aşağıdaki altın the The the The THE the the the the THE the kurallara Harfiyen uymakla the the THE the yükümlüdür.

### Kural 1: DTO (Data Transfer Object) ve Mapper the the the The Mühürlemesi the 
Hiçbir the Controller the the Sınıfı, the The the the methods the the the `ResponseEntity<User>` (YANİ GERÇEK ENTITY THE ) dönemez.
the Her the the the Modülün the THE the Kendi The `/dto` klasörü the The the The MUST THE The MUST The exist!!!
Gerçek `User` Entity'sini THE DTO'ya The The The MapStruct veya the The ModelMapper the The aracı The The Otonom the The THE THE the The the class tarafından `UserMapper.java` içerisinde haritalandırılacaktır THE. 

### Kural 2: Dependency Injection the The Zırhı the The (Interface Zorunluluğu THE)
Service the The sınıfları The Doğrudan Sınıf the The (Class) the the the olarak enjekte the edilemez!. The THE THE 
Spring The projesinde The ZORUNLU The the olarak The the The The The `IUserService` the adında bir Interface the The yazılacak the ve `UserController` bu The Interface'i The the The The `@RequiredArgsConstructor` the ile the final the the the property or the (Constructor) the The The olarak The The The the alacaktır! THE The Field The The The Injection the (`@Autowired`) the the the The YASAKTIR! THE The

### Kural 3: Layer-by-Layer the (Katman the Mühürü) the The THE Yasakları THE the 
Eski The the spring The the The the The patternlarındaki the THE the THE the gibi the the Bütün The the The sistem The THE the V The `src/main/java/controllers` the 
altında THE 100 the the The tane THE Controller the The V THE KALESİ THE the T the Yığması Yasaktır! The the The 
Sen Otonomsun! the THE Müşteri Modülü (`/user`) ile Sipariş Modülü (`/order`) klasör yapısı olarak ASLA birbirine the The Spagetti The the gibi KARIŞAMAZ! The The V The The 

### Kural 4: Global Müşteri the The Kalkanı (`/exception`) the The The
Otonomi the THE Müşteriye the The \`Internal the the The Server Error\` the 
the döndüğünde the the THE the StackTrace the the the the the (Kod the THE the Satır the the İzini the The ) HTML the veya The the the JSON Olarak the Asla 
DÖNEMEZ! Bütün The Exception the Lar The `GlobalExceptionHandler.java` the . the da `{"status": 500, "message": "Sistemde. The the bir Hata Vardır!"}` 
Seklinde The Süzülecektir! Mimar The Güvenliğini the The the Otonom The The The Olarak 
İnşaa. The Etmek. The Zorundadır! The THE 

Mimariyi the Java nın The Zırhıyla the Bütünleştir! The The The 150 the The Satıra the Otonom the the Mimarın the the 
Kararları Yetecektir!
