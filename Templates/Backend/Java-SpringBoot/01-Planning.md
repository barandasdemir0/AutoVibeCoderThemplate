# 1️⃣ Java-SpringBoot - Kurumsal Ön Planlama ve Analiz (Enterprise Planning)

> **"Kötü bir mimari, Java gibi katı tipli bir dili bile kırılgan bir spagetti yığınına çevirebilir."**
>
> 10 yıllık Enterprise/Kurumsal tecrübeye sahip otonom bir AI Mimarı olarak; Spring Boot projesine başlarken klasör açıp hemen kod (Entity/Controller) yazmaya atlayamazsın.
> Java, N-Tier (Katmanlı Mimari) ve OOP prensiplerinin doğduğu dildir. "Gevşek Bağlılık" (Loose Coupling), "Yüksek Uyumluluk" (High Cohesion) ve S.O.L.I.D. ilkeleri sadece bir öneri değil, otonom sistemin YASALARIDIR.

---

## 🏗️ 1. Mimari Kararı: Neden Feature-Based (Alan Odaklı) Klasörleme?

Java projelerinde genellikle "Folder-by-Layer" (Controllers, Services, Repositories şeklinde klasörleme) kullanılır. Fakat bu yöntem projede 50 tane controller olduğunda sürdürülemez hale gelir. Bir siparişte değişiklik yapmanız gerektiğinde Sipariş, ürün ve sepet arasında spagetti klasör takibi yaparsınız.

### Feature-Based Hiyerarşi Kuralı
Otonomi, her Spring Boot projesini DOMAIN-DRIVEN (Alan Odaklı) kurgulayacaktır:
- `/modules/auth` (Kimlik Denetimi)
- `/modules/user` (Kullanıcı İşlemleri)
- `/modules/order` (Sipariş Mantığı)
- `/modules/product` (Ürün Kataloğu)

İçerisinde kendi `controller`, `service`, `repository` ve `dto`'su bulunan bu modüller, gelecekte projenin **Microservice** mimarisine dönüşebilmesi için hazır, kapalı kutu (Encapsulated) kalelerdir asil otonomi!

---

## 🛡️ 2. Güvenliğin Kalesi: Spring Security 6.0 Kararları

Kurumsal projede güvenlik sonradan eklenen bir yama değildir, projenin İSKELETİDİR. `pom.xml` kurulduğu an Spring Security gelmek zorundadır. Otonomi şu güvenlik kararlarını baştan mühürler:

### A. Stateless (Durumsuz) JWT Mimari
API sitemlerinde "Session" VEYA "Cookie" ile kimlik tutulması yatay ölçeklenmeyi (Load Balancer arkasında çoklu sunucu çalıştırmayı) imkansız kılar. 
* Otonomi her zaman ve KESİNLİKLE kimlik kalkanı olarak Stateless (STATELESS) konfigürasyona sahip JWT (JSON Web Token) kullanacaktır.
* Token'lar Authorization başlığında (Bearer Token) gelecektir.
* `SecurityFilterChain` içerisinde `/api/v1/public/**` dışındaki TÜM endpointler kilitli kalacaktır!

### B. Şifreleme ve Hash Kalkanı
* Veritabanına şifreler "BCrypt" ile (Min. 10 round) gömülecektir. 
* Otonomi, `User` entity'sinde `password` kolonunu API'ye sızmasın diye `@JsonIgnore` veya daha güvenlisi olan DTO ayrıştırması ile tamamen kesecektir.

---

## 📥 3. DTO (Data Transfer Object) Kararları: Mass Assignment İzolasyonu

Birçok eğitici videoda `User` Entity'si doğrudan Controller'dan dışarı döndürülür: `public ResponseEntity<User> getUser()`. BU KURUMSAL DÜNYADA ÖLÜMCÜL BİR HATADIR!

### Otonominin Katı DTO Yasası
1. **Request DTO:** Kullanıcıdan gelen kayıt olma isteği `User` entitysine DEĞİL; `UserRegisterRequestDto` içerisine düşecektir. Zira kötü niyetli bir Müşteri payload'a `"role": "ADMIN"` ekleyerek Entity'yi doğrudan kaydettirip Zafiyet (Mass Assignment) yaratabilir. DTO sadece izin verilen "email" ve "password" ü kabul eder.
2. **Response DTO:** Veritabanından gelen Kullanıcı `User` Entity'si doğrudan müşteriye JSON dönülemez. Şifre ve güvenlik rolleri gizlice dışarı sızar. Otonomi, `UserResponseDto` yaratır ve MapStruct ile Model dönüştürmesi yapar.

Otonom zeka MAPSTRUCT kullanarak spagetti çeviri kodlarından `user.setEmail(dto.getEmail())` uzak durur!

---

## 🔌 4. Dependency Injection ve Interface Kuralı (S.O.L.I.D. Uyumu)

Spring'in gücü Dependency Injection (Bağımlılık Enjeksiyonu) konteyneridir (IoC). Ancak Otonom Mimar `Field Injection (@Autowired)` kullanmaktan UZAK DURACAKTIR! (Çünkü bu test edilemez sıkı bağımlılık yaratır).

### Katı Interface Kuralı:
1. `UserController` asla, doğrudan `UserServiceImpl` classını Bağımlılık (Dependecy) olarak kabul etmeyecektir!
2. Otonomi `IUserService` şeklinde bir Interface (Arayüz / Kontrat) yazacak, ve Controller SADECE bu arayüzü çağıracaktır.
3. Nesneler `@RequiredArgsConstructor` (Lombok) yardımıyla "Constructor Injection" yöntemiyle enjekte edilecektir.

Otonom Mimar, projeye başlarken bu S.O.L.I.D prensiplerini ZORUNLU KONTROL ŞARLAMASI haline getirecek. Bunlara uymayan kod, "Spagetti" olarak isimlendirilir ve Müşteriye sunulamaz! 

Başlamak İçin Her Şey Hazır! Mimari Kuralları İşletin!
