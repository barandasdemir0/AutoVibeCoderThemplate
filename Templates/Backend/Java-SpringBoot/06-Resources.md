# 6️⃣ Java-SpringBoot - Endüstri Klasikleri (Tech Stack) ve Otonom Komut Şablonu

> Siber Güvenlik Mühürleri, N-Tier (Alan Odaklı) Mimari Kuralları, Object Mapper Zırhları ve Global Hata Filtreleri Otonom Ajan tarafından sadece kurulmuş olmak için kurulmaz!
> 
> Mükemmel bir Spring Boot (Java) projesi 6-7 Endüstri Standardı paketin kusursuz entegrasyonuyla oluşur. Eğer bunlar projeye Mühürlenmezse, o uygulama "Spagetti Kod" olarak değerlendirilir.

---

## 📦 1. Kütüphane ve Framework Zırhları (Java Stack)

Bir Enterprise sistemi şunları İçermek ZORUNDADIR! Ajan Mimar Aşağıdaki Mühürleri Kullanmaktan Kaçınamaz!

### A. Çekirdek Güç Yönetimi
* **Lombok (`org.projectlombok:lombok`):** Java'nın `get()`, `set()`, `constructor` kazan dairesi satırlarını Temizleyerek sınıfı Zırhlar. Kodu inanılmaz şıklaştırır. (`@Data`, `@RequiredArgsConstructor`).
* **MapStruct (`org.mapstruct:mapstruct`):** Entityleri (DB Sınıflarını) DTO'lara (Müşteri Payloadlarına) Çeviren En Hızlı THE Object Mapper! Asla Reflection (Java native) Kullanmadığı İÇİN CPU Ram israfını engeller.

### B. Otonom Güvenlik & Doğrulama (Validation)
* **Spring Security 6.0 (`spring-boot-starter-security`):** Sistemin Kalp Zırhı. API Mimarilerinde Stateless JWT Kullanılacaktır. Session Yönetimi Kapatılacaktır.
* **Spring Boot Validation (`spring-boot-starter-validation`):** RequestBody ile gelen Müşteri DTO verilerini (`@NotNull`, `@Email`, `@Size`) kurallarıyla ONAYLAYAN kalkan.
* **JJWT (`io.jsonwebtoken`):** Token üretimi, süresinin belirlenmesi (Expiration) ve Secret İmzalaması İçin Otonominin Bir Numaralı Silahı.

### C. Veritabanı Pompaları (ORM)
* **Spring Data JPA (`spring-boot-starter-data-jpa`):** Hibernate Katmanının en güçlü Sarıcısıdır. JPQL kurallarını Kullanır.
* **PostgreSQL Driver (`org.postgresql:postgresql`):** Kurumsal Sistemin Kalbi Postgresql İlişkisel Mimarisine Dayanacaktır!

---

## 🤖 2. The Master Prompt (Zorunlu Otonom Ana Komut)

> **Otonom (AI) ajana projeyi YAZDIRIRKEN aşağıdaki Şablon Komutu Harfiyen the Bildireceksin. Aksi Halde Ajan Projeyi Acemi Bir Spagetti gibi Kurgular!**
> 
> "Bana The Enterprise Mimaride bir Spring Boot / Java V 17+ Backend API projesi the oluşturacaksın. The 
> 
> KURALLARIM (THE S.O.L.I.D. MÜHÜRLERİ): THE
> 1) Klasörleme The yapısı ASLA The Controller, Service the şeklinde the klasik the Katman (Layer Based) Olmayacak! Kesinlikle the Domain-Driven (Feature-Based) the the The şeklinde the Modüler The (the `/user`, the `/auth`) Olacak! THE 
> 2) the Güvenlik the Sistemi the Olarak MİMARI THE The `SecurityFilterChain` V The Kullanılarak the ZORUNLU the StateLess The JWT THE Olarak Kurgulanacak. The 
> 3) The Hiçbir Controller The Dosyasında The The Doğrudan V the the Veritabanı V `Repository.save()` the The MİMARİSİ the Çağrılmayacak. the Her The Endpoint DTO the (Data The Transfer Object) the the ile THE Zırhlı the Olarak Koru The ve Service Sınıfına as Kalkanını as Yolla!! THE 
> 4) THE THE The Model Çevirileri the the İçin MapStruct Kullanılacaktır. DTO dan the The Entity e as Dönüşümler The interface Uzerinden Otonom Mapper ile THE Yürütülecek. THE THE 
> 5) Globalthe Hata Yakalayıcı (`@RestControllerAdvice`) HİÇ EKSİKSİZ The YAZILACAK! the Müşteriye Asla The the 500 V The THE the Internal Server Error The the StackTrace i V (Java The Sınıf THE Kodları) fırlatılmayacak. Temiz the JSON Formatında THE `{status: error, message: message}` DÖNÜLECEK! 
> 6) Database the THE SORGULARI Yaparken The as the as as N+1 Sorununa Karşı JPQL THE de JOIN FETCH Mimarisi The zorunlu olarak THE Kullanılacak!! The THE "

---

## 🌍 3. REST API the Otonom Dizayn (Standardizasyon Mühürü)

Ajanlar API tasarlarken Klasik, rastgele the HTTP Verbs the (Aksiyonlar) The Kullanamaz! Endpoint isimleri Mükemmel the Uyum the The Standartlara The Dayanmalıdır:

* **DOĞRU HTTP the Katmanları:**
  * Kötü (Anti-Pattern): `/api/v1/user/createUser` Veya `/api/getAllOrders` 
  * Otonom Kurumsal (Mühürlü): `POST /api/v1/users` VEYA `GET /api/v1/orders`
* **JSON Yanıtı the The (Payload Wrapper Kalkanı):**
  Bütün REST Otonomileri Controller'dan Sadece Gelen `String` i Dönmez. THE Ortak API Kapsayıcısı (`ApiResponse` Şablonu) Yaratır:
  ```json
  {
     "success": true,
     "data": { "email": "test@test.com" },
     "timestamp": "2024-12-10T15:00:00Z"
  }
  ```

BÜTÜN MÜHÜRLER KALKANLANDI. SİSTEM ÇALIŞMAYA VE OTONOMA EMİR İLETMEYE HAZIR.
