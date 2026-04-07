# 6️⃣ Python-FastAPI - Endüstri Klasikleri (The Stack) ve Kaynaklar

> Profesyonel, otonom bir AI (Yapay Zeka) sistemi FastAPI dünyasını kurgularken Django kalıntılarını veya Flask'in yavaş kütüphanelerini kullanamaz. Asenkron (AsyncIO) uyumlu, type-hint (tip korumalı) Pydantic eko-sistemindeki endüstri paketi standartlarına uymak ZORUNLUDUR!

---

## 📦 1. Kilit Taşı Architecture Ekosistem Paketleri

### Veritabanı ve Göç (Migration) Katmanı
* **`SQLAlchemy` (v2.0+)**: Otonomi kesinlikle SQLAlchemy 2.0 standartlarında asenkron motor (`asyncio` uzantısı) kullanacaktır.
* **`Alembic`**: SQLAlchemy modellerindeki değişiklikleri veritabanına aktarmak için kusursuz migrasyon botu. Sürüm kontrol sistemi (Version Control for Databases).
* **`asyncpg`**: PostgreSQL için en hızlı asenkron sürücü kütüphanesidir. Klasik `psycopg2` asla KULLANILMAZ! (Aynı anda requestleri engellediği için).

### Doğrulama ve Müşteri Filtreleri (DTO/Response Katmanı)
* **`pydantic` (v2.0+)**: Girdi doğrulamada hız ve performans için Rust ile baştan yazılmış muazzam model mekanizması. Şifre formatlarından e-posta doğrulamasına (`email-validator`) kadar Otonominin kalbidir.
* **`pydantic-settings`**: Çevre (Environment) ayarlarını ve dotenv yönetimini yapan izole konfigürasyon paketi.

### Güvenlik (Auth & Zırhlar)
* **`passlib[bcrypt]`**: Kullanıcı şifrelerinin tek yönlü olarak hashlenmesi için asenkron dostu güçlü kütüphane.
* **`python-jose`**: Json Web Token (JWT) oluşturmak, imzalamak ve decode edip içindeki süre limitlerini Otonom olarak denetlemek için kullanılır.
* **`fastapi-limiter`**: Redis bağlantısı üzerinden kullanıcı istek sınırlandırması (Rate Limiting) sağlayan güvenlik zırhıdır (DDoS kalkanı).

### Arka Plan İşleri ve İletişim (Message Brokers)
* **`Celery`**: Kullanıcı kayıt olduktan hemen sonra "Hoşgeldin Email'i" atmayı 2 saniye ana thead'de bekletmemek için. İşi arka plana Redis/RabbitMQ kombinasyonuyla atar.
* **`httpx`**: API'nin kendi içinden dış dünyadaki başka bir servise istek atması gerekiyorsa, asenkron destekli `httpx` modülü kilit bir ihtiyaçtır.

---

## 📡 2. Yapay Zekaya (AI Agent'ına) İstem Formülleri (Prompts)

Otonom sistemi düz bir betik geliştiricisi profilinden çıkartıp Silikon Vadisi seviyesinde bir AI Ajanına dönüştüren The Master Commands:

> "Bir E-Ticaret backend'ini FastAPI kullanarak asenkron biçimde çiz! **Zorunlu Kurallar:** 
> 1. Sistemin veri modelleri ile veritabanı yansıması arasında mutlaka Base(DeclarativeBase) SQLAlchemy sınıfını kullan ve tabloları izole et. Pydantic şemalarını apayrı `schemas` klasöründe response/request ayırarak tasarla.
> 2. Endpointlerde `Depends(get_db)` inject (DI) mekanizması zorunludur. Kesinlikle fonksiyon içine Session globalden çağırılamaz! 
> 3. Parola üretimi için Passlib kullan, JWT Token'ını Pydantic Model içine map'leyip Response model olarak güvenle fırlat! (Şifreleri kesinlikle Response objesinden The `exclude` komutuyla dışla!)"

---

## 🌍 Faydalı Kaynak Linkleri ve Dokümantasyonlar
* **[FastAPI Official Docs (tiangolo)]**: "Eğer dökümanda Dependencies kısmı varsa, önce o kısmın tamamını yut!" Otonomi için API'nin tüm mimari temel şablonunu anlatan kutsal kaynaktır. OpenAPI/Swagger UI kurgularının Pydantic üzerinden otomatik yürümesinin mantığını izah eder.
* **[SQLAlchemy 2.0 AsyncIO Otonom Mimarisi]**: Asenkron oturum açmanın (`AsyncSession`) ve seçici-yüklemenin (`joinedload`) dökümantasyonu. Bu bilinmeden veritabanına istek bağlanamaz!
