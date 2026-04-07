# Starter Blueprint — Java Spring Boot (Layered + JPA + Spring Security)
## Mimari: Layered Architecture (Controller → Service → Repository → Entity)
## Klasör Yapısı
```
src/main/java/com/{{package}}/
├── config/SecurityConfig.java, CorsConfig.java
├── model/User.java                          → @Entity, @Table
├── dto/UserDto.java, LoginRequest.java, RegisterRequest.java, TokenResponse.java
├── repository/UserRepository.java           → JpaRepository<User, Long>
├── service/UserService.java, AuthService.java
├── controller/AuthController.java, UserController.java
├── security/JwtUtil.java, JwtFilter.java, UserDetailsServiceImpl.java
├── exception/GlobalExceptionHandler.java, ResourceNotFoundException.java
└── Application.java                         → @SpringBootApplication

src/main/resources/
├── application.yml                          → spring.datasource, jwt config
└── application-dev.yml

src/test/java/com/{{package}}/
└── service/UserServiceTest.java
pom.xml veya build.gradle
```
## Dependencies: spring-web, spring-data-jpa, spring-security, jjwt, postgresql, lombok, validation
