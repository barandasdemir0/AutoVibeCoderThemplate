# 6️⃣ DotNet-WebAPI - Endüstri Klasikleri (Tech Stack) ve Kapsamlı Kaynak Kılavuzu

> Profesyonel, otonom bir AI sistemi C# (.NET Core) dünyasını kurgularken, "her şeyi (tekerleği) kendim yeniden icat etmeliyim" (NIH- Not Invented Here Syndrome) kibrine kapılamaz. Microsoft'un kendi sunduğu Base Class Library (BCL) mükemmeldir ancak; yetkilendirme (Auth), hata yönetimi (Resilience), ve mesajlaşma gibi devasa çözümler için otonom ajanın (AI) kurumsal endüstrinin kabul ettiği Savaş Testinden Geçmiş (Battle-Tested) Nuget eklentilerini zırh gibi kuşanması şarttır! Aşağıdaki paket/mimari kılavuzu, Enterprise C# API'leri için Dünya Standartları listesidir.

---

## 📦 1. Kilit Taşı Mimari ve Tasarım Eklentileri (Extensions)

Uygulamanın merkez sinir sistemini (Application Layer) kodlarken, spagetti veya iç içe girmiş sınıf patlamalarından korunmak için kullanılan Altın Standartlar.

### A. CQRS ve Boru Hattı (Pipeline) 
* **`MediatR`**: 
  Otonom .NET mimarisinin mutlak (Mutant) standardıdır. Klasik servis-bağımlılığı (Interface enjekte edip god service yaratma) çağını kapatıp, Komut (Command) ve İstek (Query) paradigmalarını `IMediator` nesnesi aracılığıyla Event-Driven (Olay bazlı) şekline sokar. Projenin Decoupled (Bağımlılıklardan arındırılmış) olmasının yegane silahıdır.

* **`FluentValidation`**:
  Model doğrulamasını (Validation) Data Annotations (`[Required]`, `[MaxLength]`) kullanarak Controller'la veya Entity'lerle KIRLETMEK (Pollution) amatörce bir iştir! Otonom, bunun yerine `AbstractValidator<T>` kalıtım sınıfları kullanacak ve bunu MediatR'ın Pipeline Behavior'larına enjekte ederek; modellerin iş zekasına veya Controller'a HİÇ girmeden temizlenmesini (veya 400 Bad Request fırlatılmasını) sağlayacaktır.

### B. Serileştirme ve DTO Haritalama (Object-Mapping)
* **`Mapster` veya `AutoMapper`**: 
  Kocaman `UserEntity` objesini Database'den çekip kullanıcının kimlik şifrelerini yanlışlıkla Response (Yanıt) üzerinden sızdırmamak adına (Bkz: OWASP Data Leakage) modeller DTO objeleriyle "Map'lenir" (Haritalanır). Otomatik yansıma (Reflection) gücü yüksek olduğu için AutoMapper standarttır. Ancak milisaniye hızı (Performans) çok önemliyse Otonomi kesinlikle **Mapster** kütüphanesine (Compile-time code generation) geçiş yapacaktır!

---

## 🛡️ 2. Arka Plan Devleri ve Hata-Tolerans Sistemleri (Resilience & Infrastructure)

Bir API kilitlendiğinde veya dış dünyadaki (Örn: Ödeme sistemi sunucusu) servise erişemediğinde çökmemesi yeteneği (Robustness). 

### A. Hata Toleransı & Yeniden Deneme (Retry Policies)
* **`Polly`**: 
  Otonom Bir API Tasarımcısı dış dünyaya HTTP isteği (`HttpClient`) atarken Polly zırhı giymek ZORUNDADIR! Eğer karşı API o anlık bir 503 Server Error dönüyorsa veya TimeOut oluyorsa sistem çökemez! Polly ile `Retry Pattern` (3 kez tekrar dene, aralarında 2 saniye bekle), `Circuit BreakerPattern` (Şalteri 1 dk kapat, sürekli request atıp hedefi patlatma) mimarileri kurulur. `.NET 8 UseHttpClientDefaults` ile entegre edilir.

### B. Ağır İletişim (Message Brokers)
* **`MassTransit` (RabbitMQ & Azure Service Bus üzerine):**
  Kafka Veya RabbitMQ arayüzlerini doğrudan (saf TCP/IP) kullanmak yerine C# ekosisteminin devasa "Consumer/Producer" otobüsüdür (Message Bus). Event-Sourcing ve Mikroservislerin birbirleriyle konuşması için kullanılır. İkinci servisin çökmesi durumunda mesajı kaybetmeden Retry veya DeadLetterQueue'ya yollar.

### C. Geleneksel Kuyruklar & Planlanmış İşler
* **`Hangfire` veya `Quartz.NET`**:
  Eğer e-posta yollanacaksa veya her gece saat 00:00'da veritabanından fatura oluşturulacaksa WebAPI'nin `Task` sistemine asılıp unutulamaz! IIS veya Kestrel projeyi geri dönüşüme attığında (Application Pool Recycle) arka planda dönen Threadler havaya uçar. Hangfire arka plan işlerini Veritabanına yazar (Persistence Queue). Proje kapansa bile açıldığında e-postalara kaldığı yerden devam eder MÜKEMMEL BİR GÜVENLİK mekanizmasıdır!

---

## 📡 3. İzleme (Monitoring), Loglama ve Kimlik Güvenliği

"Yazdım ve Bitti" zihniyetine sahip Otonom AI, profesyonel bir üretim (Production) kurgulayamaz.

* **`Serilog`**: 
  C# tarafında klasik "Console" logları artık tarih olmuştur. JSON formatında 'Structured Logging' atarak hata anındaki bütün property değerlerini (Örn: Veritabanı N+1 hatasındaki UserId'ler) haritalayıp loglama zekası sunar. Seq veya ElasticSearch/Logstash (ELK) yollarına köprüler kurgular.
* **`JWT Bearer & Microsoft.AspNetCore.Identity`**:
  Uygulamaya salt Controller zırhı değil, kimlik (Authorization/Authentication) kılıfları kurar. Kullanıcı rollerini (Claim-Based Authentication) ve Policy'leri (`[Authorize(Policy="AdminOnly")]`) ayarlar. Refresh Token algoritmaları JWT kütüphanesi referans alınarak tasarlanmalı, asla basit Token geçerlilik tarihleri uzatılmamalıdır (Token Replay Attacks engellenmeli).

---

## 🤖 4. Yapay Zekaya (AI Agent'ına) İstem Formülleri (The Master Prompts)

Sıradan bir C# üreticisini (Kod motorunu) alıp, Silikon Vadisi kalibresinde bir "Application Architect" ve Mimar Otonomi'sine dönüştüren Altın İstemler:

> **Otonom Mimara (C# Agent) Başlangıç Bildirisi (Master Prompt):**
> 
> "Bana yüksek ölçekli (High-Scale) bir RESTful API için C# / .NET (En son LTS Sürümü) Backend mimarisi kur. KURALLAR AŞAĞIDADIR, BUNLARA UYMAMASI MİMARİNİN ANINDA ÇÖP OLARAK SAYILMASIYLA (REDDİYLE) SONUÇLANACAKTIR:
> 
> 1. **Zero Monolith Monolith Separation:** Uygulamayı katı 'Clean Architecture' kurgusuyla parçala. `Domain`, `Application`, `Infrastructure` ve `WebAPI` (Presentation) adı altında bağımlılık yönleri DOĞRU AYARLANMIŞ (.csproj Isolation) dört projeye ayır. Circular Dependency kesinlikle yasak!
> 
> 2. **Controller Sükuneti:** Controllerlar (Örn: `UsersController`) asla `[HttpPost]` operasyonlarının içerisine Business Logic (İş Zekası) yazamaz. Kendi içerilerinde DatabaseContext dahil edemez! Sadece ve Sadece Command ve Query'leri (CQRS) oluşturup, constructor'dan IMediator (`ISender` interface'i) alarak komutları Posta ederler. Başka bir işlem yapılamaz!
> 
> 3. **The Validation & Behavior Interceptor:** Command ve Querylere gelen validasyon kuralları MediatR Pipeline'ının içine gömülü bir `ValidationBehavior` T pipeline'ı oluşturularak, FluentValidation kurallarıyla filtrelenecek ve Handler'lara yük bindirilmeden HTTP 400 fırlatılacak.
> 
> 4. **Interface Isolation vs Concrete Class (Bağımlılık İzolasyonu):** Hiçbir somut `Service` Veya `DbContext` sınıfları doğrudan Controller'da Instantiate edilemez (No `new` keyword for services). Container ayağa kalkerken, Application projeleri için `AddApplicationServices()`, ve Infrastructure için `AddInfrastructureServices()` şeklinde extension methodlar oluşturularak `Program.cs` te yığınlık azaltılacak.
> 
> 5. **Stateless Fallback (Durumsuz Global Hatalar):** Sunucuya gelen tüm Exceptions/Aykırı Durumlar tek merkezden (UseExceptionHandler middleware veya GlobalExceptionHandler) alınacak; sistemin Stack Trace hatası veya Database Tablo İsimleri KESİNLİKLE ifşa edilmeden (Information Exposure zafiyeti doğurmadan) müşteriye ProblemDetails formatında standart bir JSON basılacak!"

---

## 🌍 5. Kutsal Microsoft Referans Kaynakları
Otonom Yapay Zeka her türlü syntax sızıntısında bu resmi yolları (Golden Path) kontrol edecektir:

* **[Microsoft Docs - ASP.NET Core Architecture]**: WebAPI mimarisini katmanlara bölmeyi resmi ağızdan izlediğimiz rehber kitap. .NET Core ekosisteminde CQRS ve Microservices yolları buradadır.
* **[eShopOnContainers (Microsoft GitHub)]**: Dünya standartlarında bir Mikroservis mimarisinin ve .Net API'lerin bütün Polyglot (Çoklu-Teknoloji) entegrasyonlarının, CQRS'in otonom bir mimariye nasıl harmanlanacağının KUTSAL KİTABIDIR. Bir Otonom AI, eShopOnContainers kodlarını tamamen ilham almak ZORUNDADIR! (Docker Container, K8S, YARP, MassTransit vb. içerir).
* **[OWASP Top 10 for .NET (Güvenlik Kalkanları)]**: Sistem Müşteridir. Otonomi, Swagger arayüzüne (API Docs) Auth eklemeyi unutup verileri korsanlara açarsa sistem ÇÖKER. C# deki Cookie ve Token güvenliğini OWASP zırhıyla tasarlar.
