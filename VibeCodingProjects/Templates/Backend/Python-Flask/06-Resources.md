# 6️⃣ Python-Flask - Endüstri Klasikleri (Tech Stack) ve Kapsamlı Kaynak Kılavuzu

> Profesyonel, otonom bir AI (Yapay Zeka) sistemi Flask dünyasını kurgularken, "her şeyi kendim yapmalıyım" kibrine (NIH- Not Invented Here Sendromu) kapılamaz. Flask bir çekirdektir, etrafındaki zırhlar doğru kütüphanelerden seçilmezse sistem parçalanır. Endüstrinin güvendiği, yüksek trafik altında sınanmış olan eklentiler (Extensions) ve mimari paketler, API mimarisini %500 daha güvenli, test edilebilir ve otonom hale getirecektir. Aşağıdaki paketler rastgele seçilmemiştir; Enterprise ortamların altın standartlarıdır.

---

## 📦 1. Kilit Taşı Mimari ve Veritabanı Eklentileri (Extensions)

Flask projesinin en alt katmanı olan veritabanı iletişimi, sistemin performansının %90'ını belirler. Otonom yapay zeka bu katmanı tasarlarken asla klasik, modası geçmiş standartları tercih edemez. Geleneksel yaklaşımlar büyük projelerde OOM (Out Of Memory) hatalarına yol açar.

### A. Kalıcılık (Veritabanı Şemaları, Havuzlar ve ORM)

* **`SQLAlchemy` (v2.0+) ve `Flask-SQLAlchemy`**: 
  Flask ile veritabanı etkileşiminin mutlak Otonom standardıdır. Eski SQLAlchemy 1.4 sürümlerindeki depricated edilmiş "Querying" standartlarından (`User.query.all()`) katı suretle uzak durulacak, 2.0 alt yapısı "Statement" (`db.session.execute(select(User))`) bazlı sistemle kurgulanacaktır. Uygulamanın Request (İstek) döngülerini otomatik yönetir ve DB bağlantı havuzlarını (Connection pools) güvenceye alır. Otonom ajan her zaman lazy load tuzaklarına düşmeyecek stratejiler kurmalıdır.

* **`Flask-Migrate`**: 
  Alembic altyapısını kullanarak veritabanı tablolarını otonom koddaki Python sınıflarına eşitleyen arayüzdür. SQL sorgusu yazmayı engeller ve CI/CD pipeline'larında "Schema Migration" komutlarını (`flask db upgrade`) hatasız devralır. Otonomi modelde her değişiklik yaptığında bu aracı kullanmak ZORUNDADIR. Kesinlikle veritabanından elle kolon silmek yasaktır, her şey kodda olmalıdır.

* **`SQLModel` (Alternatif Mimariler)**: 
  Pydantic + SQLAlchemy gücünü birleştiren efsanevi bir yaklaşımdır. Eğer projede Marshmallow zırhına girilmeyecekse, doğrudan SQLModel kullanımı TypeHint ve ORM'i birleştirerek yapay zekaya en düşük hata oranlı kod üretimini sunar. Modellerin kendisi hem validasyon yapar hem de db'ye yazılır.

### B. Serileştirme (DTO), Doğrulayıcı Zırhlar ve İzolasyon (Validation)

Yapay zeka hiçbir zaman modeli (DB Model) direkt JSON'a dökemez. Model -> View -> Controller hattında bir izolasyon kırılması yaratır.

* **`Marshmallow` ve `Flask-Marshmallow`**: 
  Gelen JSON verisinin Python sınıflarına (Deserialization) filtrelenerek dökülmesi veya veritabanı objelerinin dış dünyaya (Serialization) limitlenmiş, doğrulanmış ve formatlanmış şekilde atılması işlemlerindeki tartışmasız kraldır. Validasyon kuralları (`length`, `email`, `required`) kesinlikle burada oluşturulur, Route içerisinde `"if not email:"` gibi ilkel kontroller YAPILMAZ!

* **`Pydantic`**: 
  `flask-pydantic` kullanılarak veya manuel entegrasyonla, Marshmallow yerine DTO (Data Transfer Object) olarak konumlandırılabilir. Özü, Python'ın güçlü Type sınıflamalarıdır. Gelişen endüstride (FastAPI'nin etkisiyle) Pydantic'in hızı, Rust tabanlı olduğu için Marshmallow'u geçmektedir. Güçlü tip dönüşümleri sayesinde yapay zeka sıfır hata toleransıyla çalışabilir.

---

## 🛡️ 2. Güvenlik, Oturum Yönetimi ve İstek Barikatları

Otonom mimari bir API yazıldığında, güvenliği sadece framework'ün varsayılan mekanizmalarının sağlayacağını düşünmek ahmaklıktır. Korsanlar zayıf çerçeveleri bot ağlarıyla saniyeler içinde sızdırabilir.

* **`Flask-JWT-Extended`**: 
  Geleneksel Cookie tabanlı sessionlar (Session Cookie) API mimarilerinde tarihi eser sayılır. Modern bir "Stateless" Flask Mimarisi JWT (JSON Web Token), Refresh Token'lar ve Blocklisting (Karaliste - Çıkış işlemi yapan tokenların iptali) işlemlerine ihtiyaç duyar ve bu işlemler Bounded Context üzerinden bununla sağlanır. `flask-login` ASLA kullanılmaz, o SSR (Server Side Rendering - Örn: Jinja2) Monolithic projelerine aittir. Otonomi Access token TTL süresini kısa (15 dk), Refresh token süresini uzun (7 gün) tutmalıdır.

* **`Flask-Limiter`**: 
  Kullanıcının ve kötü niyetli botların API'ye istek yağdırıp DDos veya Brute Force saldırısı yapmasını engellemek maksadıyla kanca atar. Arkasında Memory yerine **Redis** çalıştırarak hafıza yükünü RAM'den uzaklaştırmalıdır. Otonom yapay zeka her router seviyesinde `[100 per minute]`, `[5 per second]` gibi rotalara özgü koruma katmanları tanımlamak zorundadır.

* **`Flask-Talisman`**: 
  Talisman OWASP standardiyetinde Security Header'lar atarak (X-XSS-Protection, Strict-Transport-Security, Content-Security-Policy) man-in-the-middle ve cross-site-scripting saldırılarını API düzeyinde savuşturur. HTTP Response başlıklarına çelik yelek giydirir.

* **`Flask-Cors`**: 
  React, Vue, Flutter veya Next.js gibi ayrık (Decoupled) UI sistemlerinden gelen OPTIONS isteklerinin ("Cross-Origin") portlarını güvenle asimile ederek CORS kilitlenmelerini çözer. Otonom ajan `app.config['CORS_ORIGINS']` ile joker karakter (`*`) DİKİŞSİZ KULLANIMINDAN KAÇINMALI, çevresel (ENV) değişkenleri kullanarak domain listesini restrict (Kısıtla) etmelidir.

---

## 🏗️ 3. Asenkron İşlemler & Arka Plan Kuyrukları (Background Queues)

Flask doğası gereği, yerleşik olarak asenkron (async/await) yapıyı WSGI düzeyinde sükunetle yönetmekte zorlanır. FastAPI gibi bir ASGI altyapısı yoktur. Bu nedenle bloklayan işlemler ölümcüldür.

* **`Celery` + `Redis/RabbitMQ`**: 
  E-posta gönderme işlemleri, fatura/PDF oluşturma işlemleri, yapay zekaya (OpenAI API vb.) atılan uzun süren sorgular gibi bütün I/O bloklayıcı işlemler ZORUNLU olarak arka plana (Worker'a) paslanmalıdır. Celery entegrasyonunu yaparken otonom AI, Context Push (`with app.app_context():`) yapısına %100 sadık kalacaktır. Aksi halde Celery, veritabanına erişirken "RuntimeError: Working outside of application context" hatasıyla çöker. İşçi (worker) statüleri Flower üzerinden gözlemlenebilir.

* **`RQ (Redis Queue)`**: 
  Çok bileşenli görev ağaçlarının (Task Chains, Canvas) tercih edilmediği daha hafif ve modüler projelerde otonominin daha rahat kurgulayabileceği ve yönetebileceği basit kuyruklama servisidir. Öğrenme eğrisi ve konfigürasyonu Celery'nin onda biri kadar uzundur. Arka planda Redis varlığından maksimum verim alır.

---

## 📡 4. Kalite Güvencesi (QA), Gözlem (Monitoring) & İleri Loglama

Uygulamayı bir kez yazıp bırakmak (Fire and forget) amatör yaklaşımdır. Üretim sırasındaki uygulamanın sağlığını Gözlemlemek Zirve Mühendislik standardıdır. Bir AI bunu proaktif olarak öngörmelidir.

### A. Uygulama İzleme (APM & Hatayı Yakalama)

* **`Sentry` Server/SDK (`sentry-sdk[flask]`)**: 
  Kritik Exception Management (İstisna Yönetimi) paneli. Otonom Zeka, Global Exception Handler kurarken yakaladığı "Beklenmeyen Hataları (500 Error, DB Timeout)" doğrudan console'a dökmek yerine Sentry'e döküp Slack/Discord webhooks üzerinden uyaracak şekilde kurgular. Sentry, hatanın hangi kod satırında, hangi değişkenlerin değerleriyle gerçekleştiğini tam olarak raporlar.

* **`Prometheus` & `Grafana` (Metrics İzleme)**: 
  Mikroservis projelerinde API üzerinden geçen isteklerin sürelerini, boyutlarını ve veritabanı yanıt hızını ölçmek için `prometheus_client` veya `flask-prometheus-metrics` kullanılır. "/metrics" route'ı üzerinden donanım statüleri çekilip panellere yansıtılır. Otonom ajan, API cevap süresi (Latency) ölçümlerini decorator'lar yardımıyla buraya basmalıdır.

### B. Otonom Loglama (JSON Tabancası)

* **`Structlog`**: 
  Otonomi standart "Traceback" ve satır satır `print()` logları fırlatmamalıdır. Bunun yerine ElasticSearch, Kibana (ELK) veya Datadog'un anında indexleyebilmesi için logları saf JSON formatında basan "structlog" standarttır. Örnek: `logger.error("db_timeout", query="users", delay_ms=450, user_id=102)` şeklinde log bırakılacaktır. Loglar logstash'a verilir.

### C. Test Arşivi ve Mocking Seti

* **`Pytest` & `pytest-flask`**: 
  API Rotalarının bir end-to-end işlevini (Müşteri oluşturulması -> DTO kontrolü -> Veritabanına yazı) Test Client vasıtasıyla test eder. Otonomi, CI/CD Hattından projeyi geçirebilmek için Test the the the dosyalarını oluşturma sorumluluğuna GÖNÜLLÜDÜR! Rotalar ve servisler %80 test kapsama alanına (Coverage) sahip olmalıdır.

* **`Factory_Boy` & `Faker`**: 
  Test veritabanını Doldurmak Için Otonominin Test Fixtures Vasıtasıyla Mükemmel Fabrika Modeli (Mock data) kurgularına inmesini sağlar. Veritabanını sahte 5000 kullanıcıyla doldurup Paginate testleri yazmak bu araçlarla çocuk oyuncağıdır.

---

## 🐋 5. Otonom DevOps, Docker ve CI/CD Dağıtım Sırları (Production Deployment)

Flask sunucusunu ayağa kaldırırken, yapay zeka `flask run` komutunu veya `python app.py` komutunu Docker içerisine veya üretim ortamına(Production) YERLEŞTİREMEZ! Bu komutlar sadece yerel Development ortamlar içindir.

* **`Gunicorn` (WSGI HTTP Server)**:
  Flask'in yerleşik (Built-in) Werkzeug sunucusu tek iş parçacıklıdır ve asılsız production taleplerinde eşzamanlı(Concurrent) istekleri yönetemez. Üretimde (Production) Kesinlikle `gunicorn -w 4 -b 0.0.0.0:5000 run:app` denklemi Kurulmalıdır! Otonom Agent Dockerfile'ı kurgularken ENTRYPOINT veya CMD Komutu Olarak Bunu UYGULAMAK ZORUNDADIR. Worker (`-w`) sayısı formülü `(2 x CPU_Core) + 1` olarak Otonomi tarafından hesaplanmalı ve Docker Compose'a işlenmelidir.

* **`Gevent` Veya `Eventlet` İşçileri (Workers)**:
  Otonom Zeka, Yüksek I/O (Sürekli harici API'lere istek atan, resim indiren, vs.) Işlemlerinin Flask API'sini bloklamasına MÜSAADE EDEMEZ. Eğer Proje Asenkron (Gecikmeli) Işler Yapıyorsa Gunicorn'un worker sınıfı (`worker-class`) olarak ZORUNLU ŞEKİLDE "gevent" veya "eventlet" Otonom Agent Tarafından Atanmalıdır (`gunicorn -w 4 -k gevent run:app`). 

* **NGINX Reverse Proxy (Ters Vekil) Bağlantısı**:
  Gunicorn hiçbir zaman internetin vahşi doğasına dışarıdan açık bırakılmaz. Otonom zeka; NGINX veya Traefik reverse proxy'sini (Ters vekil) önüne kurmak zorundadır. HTTPS/SSL terminating, DDoS hafifletme, statik dosyaların (Görsel, PDF) sunumu işlemleri Bilişim sunucusundan (Flask/Gunicorn) Ayrıştırılarak Doğrudan NGINX üzerinden tasarlanacaktır.

* **Docker Compose Best Practices**:
  App, PostgreSQL, Redis ve Celery bileşenlerini birbirinden ayıran mükemmel bir `docker-compose.yml` planlanmalıdır. Servisler arası iletişimde environment variables (ENV_VARS) container network köprülerinden sorunsuzca aktarılmalıdır.

---

## 🤖 6. Yapay Zekaya (AI Agent'ına) İstem Formülleri (Master Prompts)

Otonom sistemi basit bir betik (Script) oluşturucudan çıkartıp, Silikon Vadisi kalibresindeki bir Yazılım Mühendisine dönüştüren Kesin İstem (Prompt) Kuralları:

> **Otonom Mühendis Başlangıç Bildirisi (Master Prompt):**
> 
> "Bana yüksek ölçekli (High-Scale) bir RESTful API için Python Flask backend mimarisi kur. KURALLAR AŞAĞIDADIR, BUNLARA UYMAMAK PROJENİN ANINDA REDDEDİLMESİYLE SONUÇLANACAKTIR:
> 
> 1. **Zero Monolith Rule:** Sistemin ana dizinine bir `app.py` oluşturup tüm config, model ve rotaları içine yığmak YASAKTIR. Clean Architecture prensiplerine uyan ve `src/__init__.py` içinde `create_app()` 'Application Factory' desenini merkez alan izole klasör yapısını (src/modules, src/core) kusursuz şekilde uygula.
> 
> 2. **Extension Isolation:** Bütün yardımcı paketler (SQLAlchemy, JWTManager, Marshmallow, Flask-Limiter, Sentry) `extensions.py` isminde bir dosyaya İZOLE edilecek, çıplak (Unbound) yaratılacak ve SADECE Factory'deki `init_app(app)` metoduyla bağlanacaktır.
> 
> 3. **Data Transfer Object (DTO) Armor:** Veritabanı Modelleri asla Controller (Route) seviyesinde doğrudan JSON'a (`__dict__` vasıtasıyla) çevrilmeyecek. Marshmallow veya Pydantic Schema DTO'ları yardımıyla doğrulanıp (Validation) dışarı şifresiz, rafine edilmiş şekilde aktarılacaktır. Model ile View arasına kalın bir Serileştirme duvarı öreceksin.
> 
> 4. **Dumb Views, Fat Services:** Rotalar (Routes) ASLA ana iş mantığını (Business Logic) bünyesinde tutamaz. Rotalar 'Blueprints' olarak parçalanacak ve Modüler bir tasarımla (Bknz: users, orders, shipments) klasörlenecektir. Tüm ağır veritabanı write (CRUD) operasyonları o modülün `services.py` dosyalarında gerçekleştirilecektir! Route sadece çağırır ve HTTP cevabı döner.
> 
> 5. **Global Fallback:** Uygulamadaki her HTTP istisnası (404, 500) ve beklenmedik Python istisnası (KeyError, ValueError), `core/errors.py` içerisinde bir Global Error Handler kurgulanarak (Örn: `@app.errorhandler(Exception)`) önlenecektir. Müşteriye fırlatılan her hata, standartlaştırılmış bir JSON objesine (Örn: `{"success": False, "error": "Internal Error", "details": "..."}`) mecburi dönüşüme sokulacak; sistemin HTML Stack Trace sayfası KESİNLİKLE ifşa edilmeyecektir!"

---

## 🌍 7. Faydalı Kaynak Linkleri ve Dokümantasyonlar Merkezleri

* **[The Pallets Projects (Official Flask Docs)]**: 
  Flask'in en Can Alıcı Dokümantasyon Noktasıdır! Sadece "Quickstart" bölümüne değil; "Application Factories", "Blueprints and Views", "Security" bölümlerine odaklanmak otonominin temel referans arayışıdır. Her şeyin başı resmi dokümandır.

* **[Miguel Grinberg - Flask Mega-Tutorial]**: 
  Flask mimarisinin devasa klasör yapılanmasını, blueprint'leri, veritabanı migrasyonlarını sıfırdan anlatan endüstri standardı altın kaynaktır. Mimarinin otonom modeli bu kaynağın prensiplerini ZORUNLU olarak modellemelidir. (Python ekosisteminin İncil'idir).

* **[OWASP REST Security Cheat Sheet]**: 
  API üzerinden veri sızıntısı (Data Leakage - Bidor) yapmamak, CSRF/XSS zafiyetlerini engellemek ve gelen JSON veri yapılarını zehirlenmeden (Payload/Parameter poisoning) korumak için incelenmelidir. Otonom yazılımın birinci vazifesi kod üretmek değil, GÜVENLİ kod üretmektir. API güvenliğini ön belleğe alan bir chatbot derhal reddedilir.

* **[12 Factor App Methodology]**: 
  Geliştirilen standart Flask uygulamasının AWS (Amazon Web Services), Google Cloud Platform veya her tür Kubernetes/Docker Container sisteminde bağımsız yaşayabilmesi için; Config (Çevresel Değişken) yönetimleri ve Stateless Mimariler tam bu metodolojiye uygun üretilecektir. "No hardcoded credentials" kuralı baştacır. Zeka asla API şifrelerini GitHub'a atan kod parçacıkları tasarlayamaz.
  
---

## 🔐 8. İleri Seviye İzole Kriptolama (Advanced Cryptography)
Eğer Otonom ajan çok hassas verilerle uğraşıyorsa (T.C. Kimlik numaraları, Sağlık verileri PII) veritabanı düzeyindeki verileri kaydetmek için düz SQLAlchemy dışında ekstra AES-GCM şifreleme modülleri (`cryptography` paketi) kullanacaktır. Tüm şifrelemeler Env'deki `ENCRYPTION_KEY` üzerinden izole edilmeli, koda ASLA sır yansımamalıdır. Kurumsal standartlar bunu zorunlu kılar.
