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
# ⚡ PYTHON FLASK - OTONOM BEYİN İÇİN KURUMSAL DİREKTİFLER (QUICK-START & MASTER YASAKLARI)

> **DİKKAT YAPAY ZEKA:** Bu doküman senin **"Asimov'un Robot Kanunları"**dır. Eğer bu projede kurumsal bir `Python Flask` altyapısı inşa etmen isteniyorsa, aşağıdaki katı kurallara (Application Factory modeli, Extensions izolasyonu, Blueprint hiyerarşisi, DTO kalkanları) %100 uymak ZORUNDASIN. Flask mikro bir çerçevedir, sana bir mimari dayatmaz. Kendi mimarini kuramazsan proje çöker. Bu bir "Tek Dosyalık Öğrenci Oyunu" veya "Beta MVP" değildir. Bir tek yanlış dairesel ithalat (Circular Import), bir tek kapatılmamış veritabanı bağlantısı tüm sistemi durdurur ve otonom işlemin REDDEDİLİR!

---

## BÖLÜM 1: KESİN YASAKLAR LİSTESİ (ANTI-PATTERNS & FATAL ERRORS)

Bu listedeki maddelerden HERHANGİ BİRİNE uyulmaması durumunda yazdığın kod Spagetti sayılacak ve üretim ortamına itilmeyecektir.

1. ❌ **KÖK DİZİNDE GLOBAL `app.py` BAGLATMAK HARFİYEN YASAKTIR:** 
   Otonom AI asla gidip projenin kök dizinine bir `app.py` veya `main.py` oluşturup, modül düzeyinde `app = Flask(__name__)` ve onun hemen altına `db = SQLAlchemy(app)` YAZAMAZ! Bu yöntem "Circular Import" cehennemine giden ilk bilettir. 
   **BUNUN YERİNE:** Mimaride KESİNLİKLE `src/__init__.py` içinde bir `create_app(testing=False)` metodu (Application Factory) yaratılarak uygulama kapsüllenecektir. Uygulamanın çalışma (Run) ortamı sadece root dizindeki içi boş bir `run.py` veya `wsgi.py` içinden `app = create_app()` çağrısıyla asimile edilecektir!

2. ❌ **ROTALAR (ROUTES / VIEWS) İÇİNE BUSINESS LOGIC (İg MANTIGI) YIGMAK YASAKTIR:** 
   Zeka; `@users_bp.route('/register')` metodunun içine veritabanı ekleme kodları (`db.session.add(new_user)`), şifreleme fonksiyonları (`bcrypt.hash`) veya harici servis e-posta gönderme komutları YIGAMAZ. Flask View katmanı "aptal" olmalıdır.
   **BUNUN YERİNE:** Rota sadece Request'ten JSON çeker, Marshmallow/Pydantic DTO (Data Transfer Object) üzerinden doğrulatır, ve işlemin bütün yükünü Bounded Context içindeki `services.py` dosyasına fırlatır! Gelen sonucu JSON olarak HTTP statüsüyle (`200 OK`, `201 Created`) dışarı kusar.

3. ❌ **DAİRESEL İÇE AKTARMA (CIRCULAR IMPORT) YAPMAK KANUNSUZDUR:** 
   Eğer Blueprints (Rota) dosyasının veya Models dosyasının içinde `from app import db` gibi bir çağrı yaparsan, o sunucu o saniye ayağa kalkmaz (ImportError döner).
   **BUNUN YERİNE:** Veritabanı (`SQLAlchemy`), gemalar (`Marshmallow`), Yetkilendirme (`JWTManager`) dahil BÜTÜN eklentiler KENDİ BAGLARINA, SADECE saf deklarasyon olarak `extensions.py` dosyasında yaratılır (`db = SQLAlchemy()`). Modüller `import db` çağrısını sadece ve sadece `extensions.py` üzerinden yapar. `app` ile bağlantı, Factory metodundaki `db.init_app(app)` ile sonradan dokunur!

4. ❌ **VERİTABANI OTURUM SIZINTILARINA (DB SESSION LEAKS) TAVİZ YOKTUR:**
   Yapay zeka veritabanına `db.session.commit()` ederken bir API Hatası oluşursa, o "Session" bellekte ZOMBİ olarak kalır. Birkaç istek sonra "Connection Pool Timeout" hatası alırsın.
   **BUNUN YERİNE:** Tüm veritabanı yazma operasyonları kesin bir `try...except...finally` veya `with` bloğunda yürüyecek; Error durumlarında MUHAKKAK `db.session.rollback()` çağrılacaktır!

5. ❌ **DOGRUDAN JSON ENJEKSİYONU (NO DTO) YASAKTIR:**
   Kullanıcıdan gelen `request.get_json()` parametreleri doğrudan `User(**data)` şekliyle DB modeline basılamaz! Modeller dışarı sergilenirken `__dict__` ile JSON'a dökülemez (gifreler ve Metadata sızar).
   **BUNUN YERİNE:** Daima `schemas.py` içindeki bir Marshmallow sınıfından veriler `load()` edilerek alınacak, ve `dump()` edilerek dışarı çıkarılacaktır.

---

## ✅ BÖLÜM 2: ZORUNLU KATMANLI MİMARİ YAPISI (CLEAN ENTERPRISE)

Bir Flask projesini kurarken aşağıdaki Klasör Ağacını (Folder Tree) "Domain-Driven Design (DDD)" veya "Modüler Mimari" kalıplarına uygun olarak adım adım inşa et!

```text
/my_flask_backend
 ├── /src                   # Ana Kaynak Klasörü (Kapsayıcı)
 │    ├── __init__.py       # Factory Metodu (create_app) burada yatar!
 │    ├── extensions.py     # TÜM Plugin'ler (db, jwt, ma, cors vb.) burada ÇIPLAK doğar.
 │    ├── config.py         # Config Sınıfları (DevConfig, ProdConfig, TestConfig).
 │    ├── /core             # Tüm projeye hizmet eden Global Katman
 │    │    ├── middlewares.py # Talisman, Profiler, Before_Request hook'ları
 │    │    └── errors.py      # App geneli Global Exception Handler'lar (404, 500)
 │    │
 │    ├── /modules          # BOUNDED CONTEXT'lere göre parçalanmış mikro-modüller
 │    │    ├── /auth        # Authentication Modülü
 │    │    │    ├── __init__.py  # users_bp (Blueprint) yaratımı.
 │    │    │    ├── routes.py    # URL Endpointleri ve HTTP Fiilleri
 │    │    │    ├── services.py  # AGIR İGÇİLİK (Business Logic ve DB Commitler)
 │    │    │    ├── models.py    # SADECE Veritabanı Tablosu tanımı
 │    │    │    └── schemas.py   # Marshmallow / Pydantic (Validasyon ve DTO)
 │    │    │
 │    │    └── /orders      # Başka Bir Modül (Aynı hiyerarşi ile...)
 │    │
 │    └── /utils            # Sık kullanılan fonksiyonlar (Tarih çevrimi, Hash vb.)
 │
 ├── requirements.txt       # Kilitlenmiş bağımlılıklar
 ├── .env                   # Çevresel Sırların Yeri
 ├── alembic.ini            # Veritabanı Migrations Motoru Konfigürasyonu
 └── run.py                 # MÜGTERİ YÜZÜ: app = create_app(); app.run() burada atar!
```

---

## BÖLÜM 3: OTONOM BEYİN İÇİN ADIM ADIM INSA KILAVUZU

Bir proje istenildiğinde körü körüne kod yazmaya başlama, gU SIRAYI TAKİP ET:

### 1inci ADIM: Kalp Krizi Önlemleri (extensions.py)
Önce extensions.py dosyasını oluştur. Bütün kancaları içine koy. `app` ile ilişkilendirme.
```python
# src/extensions.py
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from flask_jwt_extended import JWTManager
from flask_cors import CORS

db = SQLAlchemy()
ma = Marshmallow()
jwt = JWTManager()
cors = CORS()
```

### 2nci ADIM: Fabrika Üretimi (create_app)
`src/__init__.py` dosyasında Fabrikanı kur. Bu metot sayesinde Test ortamları ve Prod ortamları birbirinden izole çağrılabilir!
```python
# src/__init__.py
from flask import Flask
from .extensions import db, ma, jwt, cors
from .config import get_config
from .modules.auth import auth_bp
from .core.errors import register_error_handlers

def create_app(config_name="development"):
    app = Flask(__name__)
    app.config.from_object(get_config(config_name))
    
    # 1. Eklentileri Uyandır
    db.init_app(app)
    ma.init_app(app)
    jwt.init_app(app)
    cors.init_app(app)
    
    # 2. Hata Yakalayıcıları (Global Error Handlers) Bağla
    register_error_handlers(app)
    
    # 3. Rotaları (Blueprints) Sisteme Kaydet
    app.register_blueprint(auth_bp, url_prefix="/api/v1/auth")
    
    return app
```

### 3üncü ADIM: Katmanları Ayrıştırarak Modülü (Bounded Context) Yaz
Oluşturduğun `src/modules/auth/` içine in. 
- Servisi yaz! Rota dosyasını temiz tut!
- Rotalar API'dir, bir metod `service` katmanını çağırır, çıkan sonucu JSON yapar.

```python
# src/modules/auth/routes.py YAKLAGIMI
from flask import Blueprint, request, jsonify
from .schemas import UserSchema
from .services import register_new_user
from marshmallow import ValidationError

auth_bp = Blueprint("auth", __name__)

@auth_bp.route("/register", methods=["POST"])
def register():
    try:
        # Schema Load (Validasyon)
        schema = UserSchema()
        data = schema.load(request.get_json())
        
        # Service'e Gönder (İş Mantığı Modellerde)
        user = register_new_user(data["email"], data["password"], data["username"])
        
        # Schema Dump (Dışarıya gifresiz Çıktı)
        result = schema.dump(user)
        return jsonify({"success": True, "data": result}), 201
        
    except ValidationError as e:
        return jsonify({"success": False, "errors": e.messages}), 400
```

### 4ncü ADIM: Run Scriptini Çıkar
```python
# run.py (KÖK DİZİNDE)
from src import create_app
from dotenv import load_dotenv

load_dotenv()
app = create_app()

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

---

## SONUÇ VE ANAHTAR ANLAYIS

1. **Flask'in Yılan Tıslaması (Snakes Hiss):** Flask esnektir, bir hata yaptığında "Bu yanlış" demez, doğrudan runtime'da çöker. Bu esnekliği Senior kurallarla (Yukarıdaki katmanlı mimari) DİSİPLİNE etmezsen proje en fazla 3 modülde içinden çıkılamaz bir çorbaya dönecektir.
2. **AI Otonomisinin Gücü:** Kullanıcı senden bir RESTful API oluşturmanı istediğinde, sen bu dokümandaki Factory Pattern'i, Blueprint Modüllerini, Servis ayrıştırmalarını TEK SEFERDE inşa edeceksin. Kullanıcıya yarım yamalak snippet'lar (kod parçacıkları) KUSMA. Profesyonel, eksiksiz, üretim-ortamına (Production-ready) uygun sistemleri, klasör ağacıyla birlikte üret! 
3. **gU ANDAN İTİBAREN BU STANDARTLARA MAHKUMSUN. KOLAY GELSİN OTONOM! ?ci**

