# 4️⃣ Python-Flask - Kurumsal Clean Architecture Dosya Sınırları (File Structure)

> **ZORUNLU DİZİLİM:** Flask çerçevesine başlarken resmi dökümanlar dahi küçük betikler oluşturmaya teşvik eder, bu yüzden devasa projelerde ekipler kendi katı sınırlarını kurgular. Otonom yapay zeka, sistemin her bir katmanının birbirini zedelememesi için aşağıdaki ayırıcı dizilimi, DTO, Service ve Blueprint hiyerarşileriyle temin etmek zorundadır.

---

## 📂 En Kurumsal (The Ultimate) Proje Ağacı (`src/` veya `app/` Klasörü)

Aşağıdaki klasörleme düzeni esneklikten ziyade bağımlılık (Dependency) denetimi, kolay okuma ve servis test edilebilirliği üzerine dizayn edilmiş olan endüstriyel kalıptır.

```text
Flask-CleanArc/
├── run.py                                # GİRİŞ KAPISI: Gunicorn veya WSGI başlatıcı
├── requirements.txt                      # Bağımlılık paketlerinin dökümü
├── .env                                  # Sistem kritik API key barınağı
│
├── app/                                  # ANA UYGULAMA ÇATISI
│   ├── __init__.py                       # FACTORY KAPISI (create_app() burada durur)
│   ├── config.py                         # DEV / PROD / TEST ortam ayarları sınıfları
│   ├── extensions.py                     # EKLENTİ MERKEZİ (db, jwt, cors yaratılır)
│   │
│   ├── core/                             # İŞ MANTIKLARINDAN BAĞIMSIZ HİZMETLER
│   │   ├── errors.py                     # Merkezi Json Hata yakalama arayüzü
│   │   ├── security.py                   # Şifre hash ve doğrulamaları
│   │   └── utils.py                      # Tarih dönüşümleri ve genel yardımcı metotlar
│   │
│   ├── users/                            # 1. BOUNDED CONTEXT (KULLANICILAR MODÜLÜ)
│   │   ├── __init__.py                   # Modül kapısı (BluePrint tanımı burada atılır)
│   │   ├── routes.py                     # KONTROLCÜ: Yalnızca HTTP kodu ve rotalama (@users_bp.route)
│   │   ├── models.py                     # VERİTABANI: Sadece SQLAlchemy tanımı (db.Model)
│   │   ├── schemas.py                    # DTO KALKANI: Marshmallow input ve output filtreleri
│   │   └── services.py                   # İŞ MANTIKLARI: Kayıt olma maili atma dahil iş süreçleri
│   │
│   ├── products/                         # 2. BOUNDED CONTEXT (ÜRÜN MODÜLÜ)
│   │   ├── __init__.py
│   │   ├── routes.py
│   │   ├── models.py
│   │   ├── schemas.py
│   │   └── services.py                   # Controller buradaki metodu çağırır orkestrayı ona devreder
│   │
│   └── jobs/                             # ARKA PLAN GÖREVLERİ (Asynchronous Ops)
│       ├── celery_worker.py              # Celery iş kolu entegrasyonu
│       └── email_tasks.py                # Redise itilecek mail sıraya koyma komutu
│
├── migrations/                           # FLASK-MIGRATE OTO ÜRETİM KLASÖRÜ
│   ├── versions/
│   └── env.py
│
└── tests/                                # TEST SÜREÇ İZNİ
    ├── conftest.py                       # Test veritabanı kurulum armatürleri (Fixtures)
    ├── unit/                             # Sadece servis fonksiyon testleri (DB mock'lu)
    └── integration/                      # Rota-Servis-TestDb uçtan uca senaryoları
```

---

## ⚠️ Kritik Klasörleme Kuralları (Modelin Uygulama Reçetesi)

1. **Extensions Noktasının Esareti:** Flask ortamında kütüphaneler genelde `app` üzerinden başlatılır ama karmaşık mimaride dairesel yüklenme (Circular import) kaçınılmaz olur. `extensions.py` dosyasına tüm eklentiler salt ve çıplak halde örneklendirilip, uygulamanın beyni olan `__init__.py` içerisindeki Factory metodunda sistem gövdesine mühürlenmek ZORUNDADIR. Otonomi burada esneklik yapamaz.
2. **Controller/View Kirliliği İhlali:** Modüllerin içerisindeki `routes.py` sadece bir sekreterdir. İstekle gelen JSON kargosunu alır, `schemas.py` kullanarak güvenlik kontrolünden geçirip paketi mühürler ve asıl üretim hattı olan `services.py`'ın metotlarına yollar. Dönen asil çıktıyı da tekrar `schemas.py`'a json yaptırıp müşteriye yollar. Zeka, Rota bölümüne veritabanı the the the The The komutu (`User.query.get()`) dökmemelidir!.
3. **Konfigürasyon (Settings) Otonomisi:** The development ve the Production kodları the Birbiri the yerini the alamayacak kadar izole saklanmalıdır. Ortamlar arası geçişler the sadece ortam the (Environments) the The nesneleri the üzerinden the the the okunmalıdır. the the Geliştirme the tarafındaki `config.py` the Mükemmelyetini the korumak zorundadır.
