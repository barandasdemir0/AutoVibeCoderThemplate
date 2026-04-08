## SEQUENCE-ENGINE v1 (ZORUNLU)
Bu template ile calisirken sirayi bozmak YASAK:
1) QUICK-START.md
2) 01-Planning.md
3) 02-Architecture.md
4) 03-StepByStep.md
5) 04-FilesStructure.md
6) 05-DebugTips.md
7) 06-Resources.md

Kural:
- Her dosyadan sonra 3-5 maddelik "cikarim ozeti" yaz.
- Ozeti yazmadan sonraki dosyaya gecme.
- 7 dosya tamamlanmadan kod uretimine baslama.
- Bu akisin detay standardi: Templates/_Universal/TEMPLATE-SEQUENCE-ENGINE.md

---
# ⚡ QUICK START: The Autonomous Java-SpringBoot Master Directive (Otonom Komut Sablonu)

> **DİKKAT:** Bu dosya VibeCoding Otonom Zeka asistanlarının bir Java Spring Boot projesi başlatırken okuması ve HARFİYEN uygulaması gereken ana master prompt komutlarını içerir. Otonomi bu kilit dosyadaki ZORUNLU MÜHÜRLERİ okumadan mimariyi inşaa edemez!
> 
> "Spagetti Kod" (Monolithic Mess) Otonom Kurumsal Mimarlar İçin Kabul Edilemez Bir Zafiyettir! Spring Boot'un gücünü DTO zırhlarıyla kullanmak ZORUNDASIN!

---

## OTONOM ZEKANIN 5 ALTIN KURALI VEYA "ÇELİK MÜHÜRLERİ"

Bir otonom ajan, kullanıcıdan (Müşteri/Sizden) "Bana Java Spring Boot API (Backend) yaz" komutunu aldığı anda aşağıdaki sarsılmaz mimari kararları otomatikman devreye sokmak ZORUNDADIR.

### 1. Klasörleme Zırhı "Feature-Based (Domain Driven)" 
Spring Boot API projelerini klasik katmanlara (Layer-Based) yani sadece `controllers`, `services`, `repositories` diye ayırarak içini çöp tenekesine çeviremezsiniz! Otonomi *ZORUNLU OLARAK* "Feature-Based" (Uygulama Modülleri) tasarımı yapacaktır. Yani her özellik (Örneğin: Ürün Modülü, Sipariş Modülü) kendi kapalı `product` klasörü içinde kurgulanacak, kendi `controller`'ı kendi `service`'i kendi kabuğu içinde izole edilecektir!
`(com.enterprise.app.modules.user.controller, com.enterprise.app.modules.user.service vb.)`

### 2. DTO (Data Transfer Object) Kalkanı ve MapStruct
Entity Sınıfları (Veritabanıyla SQL bağlantısı olan Asıl Class'lar) ASLA `Controller` Katmanında müşteriye Dönülemez! Otonomi bu güvenlik açığını önlemek için DTO kalkanları yaratır! Gelen istekleri (`UserRequestDto`) ile tutar, dışarı verilen cevapları (`UserResponseDto`) ile sınırlar.
* Bu dönüşümü yapmak için Java'da kendi `setX(dto.getX())` ameleliğini (Spagetti'yi) KULLANMAZ!
* `MapStruct` ile Otonom interface Çeviricisi yaratır ve Performans Zırhını Giydirir.

### 3. Controller - Service İzolasyonu ve S.O.L.I.D.
Otonomi, REST Endpointlerini yazdığı hiçbir `Controller` dosyasında Asla Business Logic (Veritabanı Araması, Mantıksal İşlem) YAZMAYACAKTIR!
* Bütün Mantık `Service` katmanına aktarılacaktır.
* Sinyal iletişimi Interface üzerinden S.O.L.I.D kurallarıyla yapılacaktır. (`IUserService`)
* Enjeksiyon asil ve zırhlı biçimde LOMBOK (`@RequiredArgsConstructor`) ile Constructor Base olacak şekilde tasarlanacaktır. `@Autowired` Cümlesi YASAKTIR!

### 4. Global Error (Exception) Çöküş Engeli (Kurumsal Filtre)
Otonom ajanın yazdığı sistem çöktüğünde StackTrace (HTML İçeren Hata İzleri) dışarı sızamaz! `GlobalExceptionHandler` Mimarisi kurularak Sınıf Mühürlenecektir! Bütün 404 (Not Found) veya 500 (Internal Server Error) formatları Standart bir JSON kılıfına Dürülüp müşteriye aktarılacaktır!

### 5. Spring Security 6.0 ve Stateless Token (JWT) Zırhı
Kurumsal bir Uygulamanın default özelliği Güvenliktir. Spring Boot default kurularak bırakılamaz. SecurityFilterChain içerisinde;
* JWT (JSON Web Token) kalkanı `OncePerRequestFilter` sınıfından yazılacaktır!
* Mimar `SessionCreationPolicy.STATELESS` Politikasını uygulayarak uygulamanın Milyonlarca Yükte ölçeklenebilir olmasını MÜHÜRLEYECEKTİR.

---

## THE MİMARİ OTONOM BAGLATMA KOMUTLARI (MAVEN / GRADLE ZİNCİRİ)

AI'ın asistan olarak projeyi başlatırken kullanacağı terminal yürütme bandı!
Eğer Spring Initializr (Web Arayüzü) yoksa POM dosyası Zırhlanır!

```xml
<!-- Kurumsal Zırhları Çek (Lombok, Security, Web, JPA, MapStruct) -->
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-security</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-validation</artifactId>
    </dependency>
    
    <!-- LOMBOK ZIRHI -->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <optional>true</optional>
    </dependency>
    
    <!-- OTONOM ÇEVİRİCİ MÜHÜRÜ -->
    <dependency>
        <groupId>org.mapstruct</groupId>
        <artifactId>mapstruct</artifactId>
        <version>1.5.5.Final</version>
    </dependency>
</dependencies>
```

**Mimar! Bu belgedeki kurallar, "İyi bir fikir" değil; Enterprise Uygulama Otonomisinin KIRILAMAZ ANAYASASIDIR!**
Sistemi inşa etmeye başlayabilirsin! Başarılar!

