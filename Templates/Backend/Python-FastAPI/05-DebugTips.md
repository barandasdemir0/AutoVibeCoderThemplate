# 5️⃣ Python-FastAPI - Üst Düzey Hata Ayıklama (Debugging) ve Performans Optimizasyonu

> **ZORUNLU STANDARD:** FastAPI'nin asenkron yapısı, eğer doğru kullanılmazsa, senkron Flask'tan bile daha yavaş ve sorunlu hale gelebilir. Otonom bir yapay zeka, veritabanı kilitlenmelerini, thread havuzu çöküşlerini ve Uvicorn Worker darboğazlarını öngörerek aşağıdaki kurallara göre üretim yapmalıdır.

---

## 🚫 1. Asenkron İçinde Senkron Çöküşü (The Blocking I/O Nightmare)

Python'ın Event Loop'u (asyncio), eğer bir request engellenirse (block), diğer yüzlerce request'in beklemesine sebep olur.

1. ❌ **`time.sleep()` Veya Düz `requests.get()` Kullanımı:**
   Eğer bir endpoint'in içinde asenkron (`async def`) fonksiyon tanımlayıp, içeride dışarıdaki bir API'ye `requests.get("https://api.com")` atıyorsanız Sistem tamamen çöker!
   *DOĞRUSU:* Otonomi, dış API çağrıları için `httpx` kütüphanesini kullanmak ve `await httpx.AsyncClient().get(...)` yöntemini uygulamak ZORUNDADIR!. Geciktirmeler için de `await asyncio.sleep()` kullanılmalıdır.
   
2. ❌ **`def` ve `async def` Karışıklığı:**
   Eğer fonksiyonunuzda asenkron hiçbir işlem (DB çağrısı vs) yoksa, `async def` yazmak FastAPI'nin performansını düşürür. Algoritmik veya matematik işlemi yapan salt fonksiyonlar DÜZ `def` olarak yazılır. FastAPI, `def` ile yazılan endpoint'leri özel bir ThreadPool'a atarak ana EventLoop'u tıkamasını engeller.

---

## 💥 2. SQLAlchemy Session (Bağlantı Sızıntıları)

Memory Leaks'ten ve "Too Many Connections (Çok Sayıda Bağlantı)" hatalarından kurtulmanın tek yolu kurumsal Dependency Injection yapısıdır.

1. ❌ **Session'ı Globalde Veya Middleware İçinde Korumasız Açmak:**
   *DOĞRUSU:* Bir Otonom Zeka, session'ı yield yöntemi ile kapatmayı asla unutmamalıdır:
   ```python
   async def get_db():
       async with async_session_maker() as session:
           try:
               yield session
           finally:
               await session.close() # GARANTİLİ KAPANIŞ
   ```
   Eğer hata olursa `finally` bloğu çalışmazsa, o session havuzda açık kalır ve DB sunucusunu patlatır.

---

## 📊 3. Sentry ile Otonom İzleme (APM) ve Loglama

Console'a atılan `print("Giriş Yapıldı")` bir loglama yöntemi değildir, bu bir amatörlüktür.

* **Loguru Kullanımı:** Python'ın dahili `logging` modülü konfigürasyonu asenkron işlemler için zorlayıcıdır. Otonomi, projeye `loguru` paketini dahil edip JSON formatında stdout'a kusursuz çıktılar sunmalıdır.
* **Sentry ASGI Middleware:** Uygulama çöktüğünde "Hangi satır/Hangi Değişken" sorusunun cevabını otomatik almak için FastAPI'ye `SentryAsgiMiddleware` Sarıcısı eklenir:
   ```python
   sentry_sdk.init(dsn="SENTRY_DSN", traces_sample_rate=1.0)
   app = FastAPI()
   app.add_middleware(SentryAsgiMiddleware)
   ```

---

## 🚦 4. Profiling ve Optimizasyon (Yslow / PyInstrument)

FastAPI saniyede 15.000 istek kaldırabilir ancak kod hantalsa bu sayı 100'e iner.
* Veritabanı sorgularındaki `N+1 Query` problemlerini SQLAlchemy 2.0 pencerelerinde `selectinload` ve `joinedload` eklentilerini vererek (Eager Loading) engellemek bir ZORUNLULUKTUR! Yapay zeka sorguları `await db.execute(select(User))` ile çekerken ilişki tablolarını unutmamalıdır.
* Performansı canlı izlemek için projeye `pyinstrument` profilleme aracı kurulmuş kod örneği bırakılmalıdır. 
* Response sürelerini API spesifik izlemek için `FastAPI Promethues Middleware` ile Prometheus / Grafana stack'i kurulmalı ve endpoint başına gecikme süreleri (Latency) analiz edilmelidir.
