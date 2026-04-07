# 3️⃣ Python-Flask - Kurumsal Seviye Adım Adım Geliştirme Rehberi (15 Aşama)

> **YAPAY ZEKA (AI) İÇİN KESİN KURAL:** Flask çatısı ile geliştirme yapmak, sıfırdan bir motor inşa etmeye benzer. Sınırları sizin belirlemeniz gerekir. Aşağıdaki adımlar, projeyi kırılgan tek-dosya düzeninden kurtarıp, şirketin 10 yıl kullanabileceği bir mimariye taşımanın yegane formülüdür.

---

## 🛠️ Aşama 1: İzolasyon ve Bağımlılıkların Ayarlanması
1. Flask, işletim sistemi genelindeki paketlerle karıştırılmamalıdır. Mutlaka bir sanal ortam oluşturulur.
2. `requirements.txt` dosyasında `Flask`, `Flask-SQLAlchemy`, `Flask-Migrate`, `Marshmallow` ve `python-dotenv` kütüphaneleri sürüm numaralarıyla kilitlenir. 
3. `SQLAlchemy` için 2.0 varyantının desteklendiğinden emin olunup eski nesil sorgular kodlanmaz.

## 🗄️ Aşama 2: Çevre Değişkenleri ve Konfigürasyon İzolasyonu
1. Şifrelerin github üzerindeki kod depolarına sızmasını engellemek amacıyla `.env` dosyası başlatılır.
2. Bir `config.py` modülü yaratılır. Bu modül `Config`, `DevelopmentConfig`, `ProductionConfig` sınıflarından oluşur. Veriler ortamdan (environment) okunarak bu sınıflarda nesneleşir.

## 🧬 Aşama 3: Eklenti (Extensions) Düğüm Noktası
1. Dairesel bağımlılığı engellemenin (Circular Import) sırrı buradadır. Projeye `extensions.py` dosyası eklenir.
2. `db = SQLAlchemy()`, `migrate = Migrate()`, `ma = Marshmallow()` tanımları izole olarak bu dosyada yaratılır ancak Flask ile Mühürlenmezler! 

## 🛡️ Aşama 4: Uygulama Fabrikası (Application Factory) Kurulumu
1. Kök dizinde yer alan `__init__.py` içerisine `create_app` fonksiyonu kodlanır.
2. Extensions dosyasından alınan kütüphaneler otonom bir şekilde burada canlandırılır: `db.init_app(app)`.
3. Uygulamanın bağlamı (Application Context) fabrikaya itaat eder ve test edilebilir bir ürün sahası oluşturur.

## 🚀 Aşama 5: Arayüz ve DTO Doğrulaması (Marshmallow/Pydantic)
1. Gelen verilerin doğrulanması Controller seviyesinde yapılamaz.
2. `UserSchema` adı altında bir sınır objesi yazılır. Kullanıcı yaşının eksi değere düşememesi, posta kutusu standart kuralları bu şema içerisinde beyan edilir. Hatalar doğrudan 400 (Bad Request) olarak geriye sarılır.

## 🔀 Aşama 6: Model Zırhı ve Veri Kapsülleme (SQLAlchemy)
1. Modeller, yalnızca tablonun fiziksel durumunu ifade eder. İş mantıkları (Örneğin: Ürün stok düşürme eylemi) bu nesneler içine yazılmaz.
2. Sütun indekslemeleri ve asil anahtarlar (Primary Key/Foreign Key) doğru şekilde indekslenerek veritabanı okuma performansı baştan tasarlanır. N+1 sorununu önlemek için yavaş yüklenmesi gereken (Lazy) alanlara özen gösterilir.

## ✨ Aşama 7: Denetleyici Dağıtımı (Blueprints)
1. Flask'in rotaları (Root View) global uygulamada tutulmaz.
2. Her bir iş birimi için `users_bp = Blueprint('users', __name__)` oluşturulur ve rotalama o nesneye devredilir. Sonrasında, oluşturulan bu mavi kopyalar uygulamanın ana şanzımanına kaydedilir: `app.register_blueprint()`.

## 🎭 Aşama 8: Hizmet Katmanı (Service Layer) Kurgusu
1. Mimaride Controller, veriyi okuyup sadece onay makamı olarak işi devreden memur statüsündedir. Gerçek operasyon `services` katmanında yürütülür.
2. Satın alma işlemi, fatura bağlama, API token yaratma süreçleri bu katmanda yazılır. Hem birim testleri (unit test) yazmak kolaylaşır hem de spagetti blokları önlenir.

## 🔑 Aşama 9: Kimlik Doğrulama Mekanizması (Auth ve JWT)
1. Bir SPA (React/Vue) ile konuşuluyorsa Flask-Login modülü devreden çıkarılıp yerine `Flask-JWT-Extended` kurgulanır.
2. Token'ların oluşturulması, süresinin bitme kuralları ve kimlik iptal senaryoları (Blacklist/Redis) rotalara yetkilendirme olarak işlenir (`@jwt_required()`).

## 👮 Aşama 10: Küresel Hata Denetleyicisi (Global Exception Handler)
1. Sunucuda kırılan bir kodun HTTP 500 html formatında dönmesini engellemek bir elzemdir.
2. Mimar, `@app.errorhandler` etiketleriyle özel hataları, standart JSON kalıplarına giydirip tüm uygulamanın hataları asil bir arayüz stili ile iletmesini sağlar.

## ⚡ Aşama 11: Görev İşçileri (Celery ve Redis) Entegrasyonu
1. E-posta atma işlemi Flask'in asıl sunucu kuyruğunu yoramaz. İşlemin beklemesi (blocking) tüm sunucunun API yanıt vermesini kitler.
2. Zaman alan görevler Celery aracılığıyla Redis aracılarına iletilir. İstemciye gecikmesiz onay gönderilir.

Bu disiplinler doğrultusunda inşa edilmiş bir Flask uygulaması saniyede milyonlarca ziyareti taşıyabilecek bir Enterprise kapasitesine sahip olacaktır. Mimari klasör hiyerarşisi sıradaki (04) dosyada verilmiştir.
