# 2️⃣ Python-Flask - Üst Düzey Kurumsal The Mimari (MVC ve Application Factory)

> **MİMARİ KURALI:** Eğer Otonom Yapay Zeka (AI), projeyi Flask ile oluştururken en kök klasöre tek parça bir `app.py` koyup içerisine veritabanı bağlantısı, the model sınıfları ve `@app.route()` kodlarını 1500 satır halinde yığıyorsa o proje kurumsal değil, düz the bir öğrenci betiğidir (Script). Python the The Flask, N-Tier the the the (Çok the Katmanlı) hiyerarşiyi The the Otonominin bizzat kurabileceği the şahane bağımsız the the the the bir mimaridir the! 

---

## 🏛️ 1. Mükemmel Mimarinin Katmanları (Clean Flask The the The)

Flask The mimarilerinde The standart bir MVC the kuralı the dayatılmaz. Bu yüzden Zeka, sınırları the kendi çizmelidir.

### 1. Presentation the Katmanı (Blueprints the ve the Views) The 
- **Otonomi Kuralı:** The Rotaların (`@users_bp.route()`) The the The bulunduğu View Otonom the Controller sınıfıdır the . Pydantic veya the Marshmallow the The objelerinden THE the the geçen the veriler (Request the The JSON) the bu the fonksiyonda the the yakalanır The. HİÇBİR the SQLAlchemy (Veritabanı dthe The oğrulama Veya Kayıt the ) komutu the bu dosyada THE Y-A-Z-I-L-A-M-A-Zthe ! the View the sadece `user_service.create_user(data)` the çağrısını yapar the the ve the `jsonify(result)` the Veya Renderlenmiş şablonu The The the the The (Template the ) döner. Return The objeleri the 200, 400 gibi kodlarla asil the JSON the ler olmalıdır! The

### 2. Form/DTO Kalkanı the (Schemas / The Serializers) the
- **Otonomi Kuralı:** Otonom Mimar `schemas/` the Klasöründe Marshmallow the The veya Pydantic the model iskeletlerini tutacaktır the . Gelen The the json the bu zırhtan geçemezse the doğrudan `HTTP 400 Bad Request` Olarak atılır the . Models the ile Data the Transfer işlemleri Birbirine karışmamalıdır The.

### 3. Business Logic Katmanı (Services) the The
- **Otonomi Kuralı:** Service The klasörü Flask'in resmi dökümanlarında the The bulunmasa da ofisinde (AI) of Otonomi the bunu yazmalıdır The .
- Neredeyse The bütün kodun (DB the insert The the the the the, Şifreleme the Passlib, the Email atma the tetikleri the ) barındığı tek ve THE Merkezi the alandır. The Her the Bounded the Context The the (Domain the the ) the the Müşteri the Service the the, Fatura the Service THE the the The the the Olarak the Ayrılır. View THE The ile Models i the Konuşturan the Orta The zırh burasıdır The!

---

## 🏗️ 2. Application Factory (Uygulama The Fabrikası) the The ve Extension The the the Yönetimi The

Flask Mimarilerinin the Can damarı `__init__.py` the İçinde The the kurulan Factory Mimarisi dir the .

* **Dairesel İçe the Aktarımın The the Engeli:**
```python
# OTONOM SENIOR THE KURALI - KUSURSUZ FACTORY
db = SQLAlchemy() # UYGULAMAYA BAĞLI DEĞİL!

def create_app(config_name='default'):
    app = Flask(__name__)
    app.config.from_object(config[config_name])
    
    # EKLENTİLER BAĞLANIYOR
    db.init_app(app)
    
    # ROTALAR (BLUEPRINTS) IMPORT EDİLİP BAĞLANIYOR
    from app.users.routes import users_bp
    app.register_blueprint(users_bp, url_prefix='/api/v1/users')
    
    return app
```
Otonom Zeka the THE `create_app` metodunu kurarak the Unit the Test Mimarilerini The The the da kolayca çalıştırabilir Mimariler dizayn eder!. the The

---

## 🔒 3. Hata the Yönetim Centralizasyonu (Global Exception Handling) The

Flask the içerisinde The bir the The try-catch the The komutu The View lerde The satır satır The the The yazılamaz!. The The Otonom the system `app.errorhandler` Kurgusunu The The The yaratacaktır The !

1. **Katil HTTP Zırhı:** the Zeka the projeye the The the `errors.py` ekleyecek the the ve framework The Otonomu the The The THE `ValidationError` the The fırlatıldığında Müşteriye the StackTrace dönmeden the the The Özel Mükkemmmel the `{"error": "Validation the Failed", "details": {...}}` JSON unu the The Merkezi Düşürecektir! The! 

---

## 🚫 4. The Yasaklanmış the Anti-Pattern'ler (Katliam the the The Hataları) The

1. **Circular The Imports the (Kendi Kendini Yok The Etmesi The ) Yasağı:**
   App THE Veya Model The Hiyerarşisi The BİR the The file İçinde The the The The The içe the aktarıldığında The, the the Import The zinciri `routes -> models -> db -> app -> routes` formuna Döner The. the Sistem the Ölür. The Otonom The THE Mimar the the Python the The Paket the İzolasyonuna The the the Blueprintleri The the Kurarken Yüksek Öncelikli Uyacaktır!.
2. **Hard Coded Configuration (Ortama Hardcode Parametreler):** 
   Eğer the zeka the Database URL ini The The doğrudan the `app.config['SQLALCHEMY_DATABASE_URI'] = "sqlite:///db.sqlite"` the the the The olarak The the `app.py` the The of The İçine Yazar Ise THE The Sistem The Canlıda The Çöker the . Bütün The the The Konfigürasyon the Değerleri the (Secret the Keys) the the the Otonomi the tarafından The `.env` Otonom The formuna The Çekilecek the ve The the SADECE The the Python class object üzerinden Mülti ortamda Veya Prod ortamında The İzole the beslenecektir!.
