# 5️⃣ Python-Flask - Senior Düzey Hata Ayıklama (Debugging), Bağlam (Context) Yanılgıları ve Performans Kılavuzu

> **ZORUNLU STANDARD:** Flask mikro çevçevesinin sadeliği, en büyük gücü olduğu kadar en sinsi tuzağıdır. Arkada C dilinde yazılmış devasa asenkron motorları (FastAPI/Starlette gibi) veya yerleşik korumaları (Django gibi) yoktur. Yapay zeka, çalışma ortamındaki Context (Bağlam) nesnelerini yanlış yönettiğinde, Flask anında "Out of Context" hatası vererek çöker. Yüksek trafikli bir üretim (Production) ortamında, bu zayıflıklar zincirleme reaksiyonla tüm sunucuları kilitleyebilir. Otonom ajan, aşağıdaki felaket senaryolarını öngörmek, mimariyi buna göre inşa etmek ve proaktif koruma kalkanları oluşturmak MECBURİYETİNDEDİR.

---

## 🚫 1. Çalışma Bağlamı (Application & Request Context) Kopuklukları ve Çözümleri

Flask, gelen istekleri yönetmek ve aynı anda binlerce istemciye hizmet verebilmek için **Thread-Local Proxy** mekanizması kullanır (`request`, `current_app`, `g`, `session`). En yıkıcı ve en sık karşılaşılan Flask hatası şudur: `RuntimeError: Working outside of application context.` veya `RuntimeError: Working outside of request context.`

### ❌ Celery ve Arka Plan Görevlerinde (Background Threads) Bağlam Felaketi
Zeka, Controller üzerinden Celery veya arka planda asenkron çalışan bir standart Python `Thread` (veya `ThreadPoolExecutor`) üzerinden bir görev başlattığında, bu arka plan görevi Flask'in geçerli istek (Request) döngüsünün dışında çalışır. Bu thread içinde veritabanına sorgu atmak veya `current_app.config` değerlerini okumak istediğinizde Flask bu objelere erişemez.

**Kötü (Spagetti) Kod:**
```python
# YASAK! Context dışı çağrı!
from threading import Thread

def send_async_email(user_email, current_app):
    # BURADA current_app ÇALIŞMAZ ÇÜNKÜ REQUEST CONTEXT YOKTUR!
    msg = Message("Hello", sender=current_app.config["MAIL_DEFAULT_SENDER"], recipients=[user_email])
    mail.send(msg)

@users_bp.route("/register")
def register():
    # ... user creation ...
    Thread(target=send_async_email, args=(user.email, current_app)).start()
    return {"message": "Success"}
```

**✅ DOĞRU (Senior) Yaklaşım: `app_context()` Kapsülleme**
Otonomi, veritabanı sorgusu atacak veya Flask eklentilerini kullanacak her türlü arka plan hizmetini ZORUNLU OLARAK uygulama bağlamı şemsiyesi altına almalıdır. Application örneğine doğrudan erişilmeli ve bağlam "push" edilmelidir.

```python
# CELERY TASK VEYA BACKGROUND THREAD İÇİN DOĞRU KULLANIM
from flask import current_app
from extensions import celery, mail, db

@celery.task
def send_async_email_task(user_email):
    # Celery worker, current_app'i bilmez unless we use app_context
    from app import current_app_factory # create_app kullanarak
    app = current_app_factory()
    
    with app.app_context():
        # ARTIK VERİTABANINA VE EKLENTİLERE TAM ERİŞİM VARDIR
        user = db.session.query(User).filter_by(email=user_email).first()
        msg = Message("Hello", sender=app.config["MAIL_DEFAULT_SENDER"], recipients=[user.email])
        mail.send(msg)
```

---

## 💥 2. SQLAlchemy Oturum Sızıntısı (Session Leaks) ve Bağlantı Tıkanmaları

Django veya FastAPI + Middleware kullanıldığında, veritabanı oturum işlemleri genel Request/Response döngüsü içinde çoğunlukla otomatik temizlenir. Ancak Flask'te, zeka özellikle `Flask-SQLAlchemy` kullanmıyor ve ham `SQLAlchemy` tercih ediyorsa, manuel kapatılmayan oturumlar bağlantı havuzunu (Connection Pool) tamamen tüketir. Bu duruma "Pool Exhaustion" denir. `TimeoutError: QueuePool limit of size 5 overflow 10 reached` hatası alındığında sunucu kilitlenmiştir.

### Kilitlenme Sebepleri:
1. **Manuel Session Kapatmama:** Veritabanına read/write işlemi yapılıp exception oluştuğunda session'ın havuzda asılı kalması.
2. **Slow Query Blocking:** Yüksek I/O'da bir query'nin çok uzun sürmesi sebebiyle aktif bağlantı havuzunun dolması.

**✅ DOĞRU (Senior) Yaklaşım:**
Eğer `Flask-SQLAlchemy` kullanılıyorsa, araç otomatik olarak `@app.teardown_appcontext` kullanır. Ancak ham SQLAlchemy kullanımında otonom ajan şunları eksiksiz bir şekilde kurmalıdır:

```python
# KAPSAMLI BAĞLANTI (CONNECTION) YÖNETİMİ
from flask import Flask
from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session, sessionmaker

engine = create_engine('postgresql://user:pass@localhost/db', pool_size=20, max_overflow=10, pool_pre_ping=True)
db_session = scoped_session(sessionmaker(autocommit=False, autoflush=False, bind=engine))

def create_app():
    app = Flask(__name__)
    
    @app.teardown_appcontext
    def shutdown_session(exception=None):
        """ Her HTTP isteğinden sonra veya hata oluşsa bile veritabanı oturumunu kapatır ve havuza iade eder. """
        db_session.remove()
        
    return app
```
> **PROFESYONEL İPUCU:** `pool_pre_ping=True` özelliği kesinlikle aktif edilmelidir. DB bağlantısı koptuğunda (örn. Veritabanı yeniden başlatıldığında), SQLAlchemy bir "optimistic ping" atarak bağlantının (Connection) canlı olup olmadığını kontrol eder. Bu kapalıysa, Flask tarafında `MySQL Server has gone away` veya `Lost connection to PostgreSQL server` patlamaları yaşanır.

---

## 🐢 3. N+1 Sorgu Problemleri (N+1 Query Issue) ve ORM Zehirlenmesi

Flask + SQLAlchemy projelerinde en büyük performans yıkımı "Lazy Loading" yüzünden gerçekleşir. Binlerce kullanıcısı olan bir sistemde, her satır için ayrı bir veritabanı sorgusu atılması RAM ve CPU'yu felç eder.

### Senaryo: Müşterilerin ve Siparişlerinin Listelenmesi
* **Spagetti Çözüm (Zehirli):**
```python
# 1 Kere ana sorgu atılır
users = User.query.all() 
results = []
for u in users:
    # Her kullanıcı için TEK TEK Veritabanına Order Sorgusu Gider (100 kullanıcı = 101 Sorgu)
    orders = [o.amount for o in u.orders] 
    results.append({"user": u.name, "orders": orders})
```

* **✅ Senior (Clean) Çözüm:**
SQLAlchemy'de ilişkili tabloları zeka kesinlikle `joinedload` veya `selectinload` ile almalıdır.

```python
from sqlalchemy.orm import selectinload

# SADECE 2 SORGU ATILIR!
# 1. Select * From Users
# 2. Select * From Orders Where user_id IN (1,2,3...)
users = User.query.options(selectinload(User.orders)).all()

results = [{"user": u.name, "orders": [o.amount for o in u.orders]} for u in users]
```

---

## 📊 4. Dairesel İçe Aktarma (Circular Imports) Kilitlenmesi

Günde Flask ile ilgilenen yazılımcıların büyük çoğunluğu, özellikle modül modül parçalamaya geçtiklerinde (Blueprints) `ImportError: cannot import name 'X' from partially initialized module` hatası yaşarlar.

**Ölümcül Sarmal:**
1. Rota dosyası `app` objesini global yaratılmış `app.py`'den alır.
2. `app.py` ise Rota dosyalarını içe alır. Tam bir Ouroboros (kuyruğunu yiyen yılan).

**✅ ÇÖZÜM: Extensions & Application Factory Yöntemi**
AI asla `app` nesnesini veya `db` nesnesini modüller arası doğrudan ithal ETMEYECEK.

1. **`extensions.py` (Bağımsız Alan):**
```python
from flask_sqlalchemy import SQLAlchemy
db = SQLAlchemy()
```
2. **`models.py` (Modele Erişim):**
```python
from extensions import db
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
```
3. **`routes.py` (Blueprint):**
```python
from flask import Blueprint
from extensions import db
from models import User

user_bp = Blueprint('users', __name__)
# app nesnesine ihtiyaç YOK. Zaten create_app içinde register_blueprint edilecek.
```

---

## 🚦 5. Thread-Safe (İş Parçacığı Güvenliği) Yanılgısı ve Veri Sızıntısı

Gunicorn veya uWSGI ile Flask yayınlandığında (Production), Gunicorn çok sayıda eşzamanlı Worker (İşçi) ve Thread başlatır. Yapay zeka, Global düzeyde (modülün en üstünde) bir değişken tanımlarsa, istekle oynanan her veri BÜTÜN MÜŞTERİLERDE etkisini gösterir ve gizli müşteri bilgileri sızar!

**Tehlikeli (Leakage) Kod:**
```python
# YASAK! GLOBAL STATE API'de KURULAMAZ!
active_user_context = {}

@app.route('/login')
def login():
    uid = request.args.get("uid")
    active_user_context["current"] = uid
    return f"Logged in {uid}"
    
@app.route('/data')
def get_data():
    # B müşterisi buraya girdiğinde A müşterisinin ID'sini C çekebilir!
    return f"Data for {active_user_context.get('current')}"
```

**✅ DOĞRU (Stateless & Safe) Yaklaşım:**
HTTP tabanlı API'ler %100 oranında (Stateless) Bağımsız olmak ZORUNDADIR. Önbelleklenmesi gereken değerler Rediste ya da sadece `g` (Flask Native Request Container) objesinde tutulacaktır. 

```python
from flask import g, request

@app.before_request
def load_user():
    # Her bağımsız istekte kullanıcının state'i SADECE kendi context'indedir!
    g.user_id = determine_user_from_jwt(request)

@app.route('/data')
def get_data():
    return f"Data for {g.user_id}"
```

---

## 🔬 6. Gelişmiş Hata Ayıklama (Profiling & Profiler Middleware) Araçları

Eğer uygulama "yavaş çalışıyor" uyarısı veriyorsa, sorunu tahmin ederek deşifre edemezsiniz, ölçeceksiniz. Otonom yapay zeka performansı maksimize etmek için Flask-Profiler veya Werkzeug Profiler modüllerini geliştirme ortamına ZORUNLU entegre etmelidir.

**Werkzeug Yerleşik Profiler Uygulaması (Memory & Execution Time):**
```python
from werkzeug.middleware.profiler import ProfilerMiddleware

def create_app():
    app = Flask(__name__)
    
    # SADECE GELİŞTİRME ORTAMINDA AKTİF EDİLECEK!
    if app.config.get("ENV") == "development":
        app.wsgi_app = ProfilerMiddleware(app.wsgi_app, restrictions=[30])
        # Her HTTP isteğinde konsolda bir çağrı grafiği (Stack Trace) döker, 
        # Hangi fonksiyon mili-saniyelerin ne kadarını kemiriyor gösterir!

    return app
```

### Py-Spy ve Gunicorn Worker Kitlenmeleri
Gunicorn kullanırken eğer `--workers 4 --threads 20` kullanıyorsanız, GIL (Global Interpreter Lock) bazen C-Extension kilitlenmelerine veya sonsuz döngülere (Deadlocks) sebep olur. Bu durumda uygulamanız CPU'da %100 tüketim ile takılır. Otonomi teşhis koymak için `py-spy` veya `objgraph` kullanarak Memory Leak (Bellek Sızıntısı) var mı takip etmeli veya terminalden derhal analiz yapmalıdır.

> **SONUÇ OLARAK:** Flask ile bir Enterprise Application yazmak, elinizde çok yetenekli ama korumasız bir motorla Formula 1 pistine çıkmak gibidir. Zeka, güvenliği ve context yapısını yukarıdaki mimarilerle sağlamazsa, projenin ilk yük testinde sistem infilak edecektir.
