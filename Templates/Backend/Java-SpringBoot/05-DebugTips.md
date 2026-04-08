# 5️⃣ Java-SpringBoot - Enterprise Hata Ayıklama (Advanced Debugging & Profiling)

> **SENIOR DEBUGGING BİLDİRGESİ:** 
> 
> Spring Boot ile yaratılan backend sistemlerinde, derleme esnasında (Compile-time) hiçbir hata almasanız bile, çalışma zamanında (Runtime) gizli mimari iflasları (Memory Leaks, N+1 Query problemleri, DB Kilitlenmeleri) yaşayabilirsiniz.
> 
> Otonom Zeka, kodu sadece çalışsın diye yazmaz; 10 Milyon kullanıcının getireceği yükü hesaplayarak kod yazar! İşte Java mimarisinde asla yapılmaması gereken amansız hatalar ve Enterprise Otonom çözümleri...

---

## 🛑 1. THE N+1 QUERY PROBLEMİ (Otonominin Baş Düşmanı)

Bir Spring Data JPA projesinde, tablolar arasındaki `@OneToMany` veya `@ManyToMany` ilişkileri (Relations) Otonom Mimari tarafından çok dikkatli ele alınmalıdır. "Lazy Loading" (Tembel Yükleme) varsayılandır, ancak bu büyük veri listeleri çekerken ölümcül bir "N+1" SQL krizine dönüşür!

### 🎭 A. Hatanın Doğuşu (Anti-Pattern)

Mimar Zeka bir kullanıcılar (User) listesini JSON dönecek diyelim. Her bir kullanıcının siparişleri (Orders) var. Eğer aşağıdaki SPAGETTİ kurgulanırsa Veritabanı felç olur.

```java
// ❌ ÖLÜMCÜL KULLANIM (ZAAFIYET İÇERİR! Asla Uygulama!)
@Service
public class OrderService {
    @Autowired private UserRepository userRepository;
    
    // Müşterileri çekiyor...
    public List<UserDto> getAllUsersWithOrders() {
        // Bu Komut 1 kez çalışır: SELECT * FROM users;
        List<User> users = userRepository.findAll(); 
        
        return users.stream().map(u -> {
            // DİKKAT: u.getOrders() döngü içinde Çağrıldı!
            // Eğer veritabanında 200 Kullanıcı Varsa...
            // ARKAPLANDA 200 KERE "SELECT * FROM orders WHERE user_id = X" SQL SORGUSU ATILIR!
            // Müşterinin API Cevabı Yıllar Sürer! Sunucu Kilitlenir!
            return new UserDto(u.getId(), u.getName(), u.getOrders().size());
        }).collect(Collectors.toList());
    }
}
```

### B. Çözüm: JOIN FETCH Kurumsal Zırhı

Otonom Mimar Zeka, BİRÇOK veriyi aynı anda çekerken Spagetti N+1 krizini Entity Graph veya Katı `JOIN FETCH` ile Veritabanı Katmanında (Repository) çözer!

```java
// ✅ MÜKEMMEL KULLANIM (The Architecture Savior)
public interface UserRepository extends JpaRepository<User, Long> {
    
    // Bu JQPL SADECE TEK 1 ADET SQL SORGUSU ÇALIŞTIRIR! (Inner / Left Join) 
    // Tüm kullanıcılar ve Siparişleri 1 Turda gelir! Sistem Uçuşa geçer!
    @Query("SELECT u FROM User u LEFT JOIN FETCH u.orders")
    List<User> findAllUsersWithOrders(); 
}
```

---

## 🕳️ 2. @Transactional Kilitleri (Deadlocks)

Transaction'lar veritabanı işlemlerinin atomik olmasını sağlar (Ya hep, ya hiç). Otonom zeka bunu Service metodlarına koymak ZORUNDADIR. Ama...

Eğer BÜYÜK ve Dış API gerektiren (Örn. Mail gönderme) işlemleri `@Transactional` içine alırsanız veritabanının "Connection Pool"unu kilitler ve diğer Müşterileri kapıda bekletirsiniz!

### Anti-Pattern ve Çözüm Mimarisi

**❌ YASAK KULLANIM:**
```java
@Service
public class UserService {
    @Transactional // DİKKAT!
    public void createUser(UserDto dto) {
        userRepository.save(newUser);
        
        // ÖLÜMCÜL HATA: E-posta API'si 5 saniye Yavaş Yanıt Verirse. 
        // 5 SANİYE BOYUNCA SQL BAĞLANTISI KİTLEDİ! GÜVENLİK ZAFİYETİ!
        emailService.sendWelcome(dto.getEmail()); 
    }
}
```

**✅ OTONOM MÜHÜR (Kurumsal Çözüm):**
Event mekanizması (Spring ApplicationEventPublisher) veya RabbitMQ kullanılarak zaman alan (Mail, Log) işlemler Asenkron (Transaction Dışında) TETİKLENİR! VEYA Metodun Sadece DB kısmı transaction içine alınır.

---

## 👁️ 3. PROFILING (Zorunlu Memory İzlencesi ve Actuator Endpoint'leri)

Devasa Java uygulamalarında "Ne Kadar RAM Tüketiyorum?", "API gecikmeleri Ne Durumda?" görmek için Spring Boot Actuator Mimarisi ZORUNLUDUR! Otonom zeka projeyi başlatırken Metric İzleme zırhlarını yüklemeyi UNUTAMAZ!

### Actuator Kurulum Kararı 

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-registry-prometheus</artifactId>
</dependency>
```

**Konfigürasyon Zırhı (`application.yml`):**
```yaml
management:
  endpoints:
    web:
      exposure:
        include: health, info, metrics, prometheus # Sağlık Zırhı
  endpoint:
    health:
      show-details: always
```

Böylece `http://localhost:8080/actuator/prometheus` adresinde uygulamanın tüm Ram şişlikleri, Veritabanı sorgu yavaşlıkları Cloud (Grafana Kalkanı) izlemesine takılır! 

Harika bir otonomi ajanı kod yazar, Enterprise Otonomi ise Kodu İzler ve Hatalara Kalkan Olur!
