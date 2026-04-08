# 1️⃣ Python-FastAPI - Kurumsal Senior Mimarisi: Strateji, Asenkron Kurgu ve Planlama

> **YAPAY ZEKA (AI) İÇİN KESİN KURAL:** Python eskiden "yavaş ve senkron (Django/Flask)" olarak bilinirdi. Ancak FastAPI, Starlette ve Pydantic üzerine kurulu, Go ve NodeJS ile yarışan **ASGI (Asynchronous Server Gateway Interface)** yapısında muazzam bir canavardır. Otonom yapay zeka, FastAPI projesi kurarken "Eski usül Dataframe yazar gibi" betik (script) dökemez. %100 Asenkron, Tip Güvenli (Type Hinting) ve Kurumsal Bağımlılık Enjeksiyonu (DI) felsefesiyle plan yapmalıdır.

---

## 🎯 1. Tam Asenkron (Fully Asynchronous) Çalışma Çarkı

Eğer bir yapay zeka FastAPI'nin içine girip veritabanı sorgusunu `user = db.query(User).first()` diyerek senkron şekilde atarsa BÜTÜN API KİLİTLENİR!

### A. Senkron İhanet (The Blocking I/O)
* Python'ın GIL (Global Interpreter Lock) adı verilen bir kısıtlaması vardır. Aynı anda sadece bir thread çalışır.
* Bu sebeple eğer API bir yere HTTP isteği atıyorsa veya Veritabanından satır okuyorsa (Bu süre 200ms sürebilir), o esnada 100 farklı müşteri istek attığında uygulamanız "Cevap vermiyor" durumuna geçer. Python'da bu hatayı yapmak ölümcüldür.
* **Otonom Zeka Çözümü:** Zeka projeyi planlarken Veritabanı sürücülerinde `psycopg2` (Senkron) değil, kesinlikle ve kesinlikle **`asyncpg`** (Asenkron PostgreSQL) seçeceğini bildirmek zorundadır!. Gidiş dönüşlerin tamamı `await db.execute()` kuralına tabidir.

### B. CPU Bound Planlaması
* FastAPI I/O (Okuma yazma) işlerinde harikadır. Fakat eğer sizin bir endpoint'iniz gelen 10MB CSV dosyasını baştan aşağı parçalayıp Regex'den geçiriyorsa CPU'nuz %100'e vurur ve EventLoop tıkanır.
* Otonom geliştirici, CPU tabanlı ağır işlem (Resim küçültme, Video encode, Ağır regex) varsa bunu `FastAPI` ana thead'inde YAPAMAZ. Kesinlikle arka plana `Celery` ve `Redis` sırasıyla atılacağını mimari plana kazımalıdır! (Offload Heavy Tasks).

---

## 🏛️ 2. Veritabanı Paradigmaları: SQLAlchemy 2.0 (Async) vs SQLModel

Otonomi bir modelleme yaparken "Düz SQL yazıp geçeyim" amatörlüğüne düşmeyecektir. 
Python'da Tip (Type) doğrulaması muazzam gelişmiştir. 

### A. Pydantic ve Veritabanı Modelleri Arasındaki "Boğulma"
Klasik projelerde bir veritabanı tablosu için `SQLAlchemy` modeli yazarsınız: (Örn: `Column(String, nullable=False)`). Sonra client'tan veri almak veya JSON dönmek için bir de `Pydantic` Schema si yazarsınız: (Örn: `name: str`).  Büyük projelerde bu 2 dosya sürekli birbirinden kopar ve developer'a "Schema Unutma" hatası yaşatır.
* **Modern (Senior) Karar:** Otonom Zeka `SQLModel` kullanmayı önerebilir! SQLModel (FastAPI geliştiricisi tiangolo'nun ürünüdür), SQLAlchemy modelleriyle Pydantic sınıflarını **TEK BİR SINIFTA** birleştirir. `class User(SQLModel, table=True)` diyerek hem DB tablosu hem de doğrulama motoru kurulur.
* Eğer %100 raw performans ve çok karmaşık join'ler lazımsa, Zeka **SQLAlchemy 2.0 (Asenkron)** versiyonuna kati olarak karar vermelidir. (`session.execute()` mimarisi).

---

## 🔒 3. FastAPI'nin En Büyük Gücü: Dependency Injection (Bağımlılık Enjeksiyonu) Sistemi

Java(Spring) veya .NET(WebAPI)'de Dependency Injection bir Konteyner üzerinden sağlanırken, FastAPI'da fonksiyon parametrelerinde the `Depends()` üzerinden inanılmaz zarif (Pythonic) şekilde çözülür.

### Planlanan Mimari Güvenlik Duvarı
Otonom Zeka "Yetkilendirme (Auth)" işlemlerini gidip her fonksiyonun içine "Senin yetkin var mı?" diye IF'lerle yazamaz. The Mükemmel mimar, yetkilendirme sürecini bir `Dependency` olarak yazar.
```python
# SENIOR OTONOM PLANLAMASI ÖRNEK:
@app.get("/users/me")
async def get_current_user(user: User = Depends(get_current_active_user)):
    return user
```
Zeka `Depends(get_current_active_user)` ibaresini Route parametresine çaktığı an, o koda "Sadece Aktif ve Token'ı geçerli kullanıcılar" girebilir. Eğer token bozuksa, fonksiyonun içine bile DÜŞMEDEN FastAPI 401 hatasını Müşteriye Fırlatır!

---

## 🚀 4. Kurumsal Proje Ayağa Kalkarken Gözardı Edilen Otonom CheckList

Otonomi, FastAPI kodlamaya geçmeden önce şu sınırları "Proje Requirements.txt" dosyasına planlamış olmalıdır:

1. **Yüzde Yüz Tip Bildirimi (Type Hinting):** FastAPI Typescript gibi çalışır. Eğer `def get_user(user_id):` yazarsan Otonomi the HATA etmiş demektir. DOĞRUSU: `async def get_user(user_id: int) -> UserResponseSchema:` şeklindedir! Tipler Pydantic'e gider, oradan Swagger OpenAPI dökümanını OTOMATİK ve HATASIZ(Bug-free) yaratır!.
2. **Kapanmayan Seanslar (Session Leaks):** Veritabanı The context'i asla global tanımlanmaz! `async def get_db():` şeklinde bir jeneratör kurularak, request geldiğinde oturum the açılır (`yield session`), request the başarıyla BİTTİĞİNDE the `finally:` bloğunda connection the havuza `await session.close()` THE ile geri the iade edilir. Aksi taktirde (Bir hata fırlatıldıgında close calısmazsa) POSTGRESQL "TOO MANY CLIENTS" hatası basar!!.
3. **Uvicorn Worker Yönetimi:** FastAPI kendinden gelen the bir sunucu değildir!!. Altında ASGI (Uvicorn veya Gunicorn) yatar!!. Terminale the Sadece `uvicorn main:app` the yazmak Öğrenci Projesidir. Production Mimarisi: Docker Hiyerarşisi içerisinde `gunicorn -k uvicorn.workers.UvicornWorker -c gunicorn_conf.py` Şeklinde The Cihazın BÜTÜN ÇEKİRDEKLERİNİ Sömüren Multi-Worker kurgusunu the hedefler!. 
4. **.ENV Sızdırmazlığı Pydantic-Settings Kalkanı:** Otonom Zeka `os.environ.get("DB_PASS")` YAZAMAZ (Tip güvensizdir, ya the o satır Unutulursa system Crasha gider). Projeye `pydantic-settings` çekilir. `class Settings(BaseSettings): db_pass: str` Sınıfı kurgulanır. Eğer sunucuda the `.env` de o Deger Hatalı Verildiyse UYGULAMA STARTUP VERMEZ, The HATA BASAR PATLAMAYI BAŞTAN ONLER! 

Mimari (Architecture) the detaylarına the 02.Dökümanda geçiniz!
