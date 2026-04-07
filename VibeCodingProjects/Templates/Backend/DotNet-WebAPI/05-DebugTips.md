# 5️⃣ DotNet-WebAPI - Enterprise Hata Ayıklama (Advanced Debugging & Performance Profiling)

> **SENIOR DEBUGGING BİLDİRGESİ:** Profesyonel bir .NET WebAPI sistemi kurulduğunda, hatalar "Aha! Object reference not set to an instance of an object." (NullReferenceException) seviyesinde olmaz. Hatalar; asenkron thread kilitlenmeleri (Deadlocks), Veritabanı N+1 sorgu havuzu (Connection Pool) patlamaları, ve Scope zehirlenmeleri (Memory Leaks) gibi milyarlarca dolara mal olacak seviyede gerçekleşir. Bir "AI Architect", bu felaketleri daha kod yazılırken öngörmeli ve aşağıdaki hata ayıklama / engelleme zırhlarını kurmalıdır!

---

## 🛑 1. Entity Framework Core Felaketleri ve Performans Girdapları

Otonom zeka; Entity Framework Core (EF Core) gibi güçlü ancak "Yanlış Kullanıma Müsait" bir ORM (Object Relational Mapper) kullanırken her an veritabanını patlatabileceğini BİLMELİDİR. En yaygın hatalar ve çözüm teknikleri şunlardır:

### 🎭 A. N+1 Sorgu Mermisi (N+1 Query Problem)
**Belirti:** Kullanıcıların siparişlerini çekerken sayfa başına 1 değil, 101 farklı SQL sorgusunun atıldığını görürsünüz.
**Hatalı Kod (Anti-Pattern):**
```csharp
var users = await _context.Users.ToListAsync();
foreach(var user in users) { // Ağa takılma!
   var total = user.Orders.Sum(o => o.Price); // Gecikmeli yükleme (Lazy Loading) her iterasyonda yeni SQL atar!
}
```
**Çözüm (The Cure):** Navigation property'ler asla sonradan döngü içerisinde yükletilmez. Ya `Eager Loading` (`.Include()`) kullanılır ya da Otonom ajan veritabanındaki işlemi direkt IQueryable üzerinden veya DTO/Projection ile (`.Select()`) çözerek (Hafızaya çekmeden veritabanı belleğinde hesaplatarak) bitirir.

### 💀 B. Lazy Loading'in Yasaklanması
Bir API servisinde `UseLazyLoadingProxies()` paketinin çalıştırılması CİNAYETTİR. Zira JsonSerializer nesneyi JSON'a dökmek istediğinde tüm alt ilişkileri okumak ister ve veritabanı kilitlenir. Kurumsal C# API mimarilerinde Lazy Loading tamamen YASAKTIR. Her zaman Include veya Projection kullanılır.

### 🕳️ C. Senkron Kilitlenmeler (Deadlock on ThreadPool)
Asenkron başlayan bir kodu, yarı yolda senkrona çekmek IIS'in veya Kestrel'ın bütün Worker Thread'lerini tüketir.
**Yasak Kilit:** `_mediator.Send(command).Result;` veya `Task.WaitAll();` KESİNLİKLE YAPILAMAZ!
**Çözüm:** Baştan sona (From Controller down to Repo), tüm boru hattı `async/await` ile kurgulanmalıdır. Eğer asenkron bir void event fırlatılacaksa (Fire and forget), `_ = Task.Run(...)` tercih edilir, bekletilmez.

---

## 💉 2. DI Container ve Scope (Yaşam Döngüsü) Zehirlenmeleri

.NET'in yerleşik Dependency Injection kapısı çok güçlüdür ancak yaşam döngüleri (Lifetimes) birbirine karıştırılırsa devasa Hafıza Kaçakları (Memory Leak) doğurur.

### Capturing Dependency (Zehirli Bağlılık)
Eğer `Singleton` (Uygulama yaşadıkça tek nesne) ömründe bir `EmailService` tanımladıysanız ve bu servisin içerisine (Constructor) gidip `Scoped` (Her Web isteği için yeni nesne) olan `ApplicationDbContext`i enjekte ederseniz (Inject), program başladığında (Host ayağa kalkarken) derleyici size **"Cannot consume scoped service from singleton"** hatasını şiddetle fırlatır! Veya daha kötüsü (Eğer kontrol kapalıysa), DbContext'i yaşam döngüsü bitmesine rağmen bellekte kilitli bırakırsınız, bu bir sünger (Memory Leak) hatasıdır.

**Otonom Çözüm:** Singleton bir servisten Scoped bir servis (Örn: Veritabanı katmanı) çağrılacaksa `IServiceScopeFactory` inject edilir. Servisin içinde scope anlık olarak manuel yaratılır:
```csharp
using var scope = _scopeFactory.CreateScope();
var dbContext = scope.ServiceProvider.GetRequiredService<IApplicationDbContext>();
// ... işlem yapılır ve context using bitiminde çöpe atılır!
```

---

## 👁️ 3. Otonom Gözlem (Observability) ve Trace Hataları

Hatalar çıktığında eğer bir API sunucusunda sadece `Console.WriteLine` basıyorsanız tebrikler; Production (Canlı) ortamdaki hiçbir müşterinin ne tür bir hatayla karşılaştığını asla bilemeyeceksiniz! Bir AI, profesyonel loglama tesisatını sormadan kurar.

### A. Yapısal Loglama (Structured Logging) - Serilog Enjeksiyonu
Sıradan string logları atılmaz (`"User 5 logged in"`). JSON tabanlı yapısal loglar atılır.
**Kural:** `Program.cs` içerisine Serilog entegre edilecek ve Seq veya ElasticSearch/Kibana (ELK) yolları döşenecektir.
```csharp
// Hatalı (Geleneksel):
_logger.LogInformation($"Sipariş eklendi: {orderId} miktarı {price}");

// Kusursuz (Yapısal / Structured):
_logger.LogInformation("Sipariş eklendi: {OrderId} miktarı {Price}", orderId, price); 
// Bu sayede ElasticSearch üzerinde 'OrderId == 1234' diyerek query atılabilir!
```

### B. Sağlık Taramaları (Health Checks) Enjeksiyonu
Mikroservis Container orkestratörleri (Örn: Kubernetes, Docker Swarm) uygulamanın yaşayıp yaşamadığını "Ping" atarak değil, uygulamanın durumunu sorarak anlar.
**Kural:** Yapay Zeka `builder.Services.AddHealthChecks().AddSqlServer(...)` paketini kuracak ve projenin `/health` rotasında Veritabanı, Redis ve RabbitMQ'nun durumlarını `Healthy/Unhealthy` olarak dış dünyaya sunacaktır. Otonomi bunu bilmek ZORUNDADIR! Aksi halde containerlar kısır döngüde kapanıp yeniden açılır.

---

## 🛠️ 4. Performans ve SQL Analiz Araçları (Profiling Tools)

Bir C# API geliştirilirken performans dar boğazları (Bottlenecks) daha API yayına çıkmadan analiz edilmelidir.

1. **Ef Core Query Tagging (Etiketleme):** Hangi C# LINQ sorgusunun, SQL Server'da nasıl göründüğünü anlamak için otonom zeka kodlara `TagWith` metodunu ilave edebilir.
   `_context.Users.TagWith("Giris_Sorgusu").FirstOrDefaultAsync(...)` 
   (*Veritabanı dba (Data Base Administrator) SQL Server Profiler ile bu sorguyu yakaladığında bu etiketi okur! Dev-ops sevgisi kazanılır.*)

2. **MiniProfiler:** WebAPI endpoint'lerinin ne kadar mikrosaniye sürdüğünü (JSON Response üzerinde veya /profiler/results uzantısında) tam detay (SQL ne kadar sürdü, Redis ne kadar sürdü) kırılımıyla loglayan asgari bir arayüz aracıdır.

3. **Application Insights (Azure tabanlı projeler):** Eğer buluta çıkılıyorsa, hatalar (Exceptions) otomatik olarak ExceptionFilter/Middleware üzerinden Azure App Insights'a kusursuzca paslanarak (Log Error) proaktif önlem alınır.

Eğer Web API çöküyor, kitleniyor veya yanıt veremiyorsa hatayı "Kodda" değil, Ya N+1 Sorgu Kilitlenmelerinde, Ya Aşırı Yüklenmiş DbContext Yaşam Döngülerinde (Memory Leaks), ya da Unobserved Task (Yakalanmamış asenkron iş parçacığı) Exception'larında ARAYACAKSIN! Otonom Mimar (AI), "The Debugger" zekasıyla bir siber güvenlik uzamında ilerler.
