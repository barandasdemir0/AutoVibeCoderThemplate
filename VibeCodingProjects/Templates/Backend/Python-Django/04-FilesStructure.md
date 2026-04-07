# 4️⃣ Python-Django - Katı Kurumsal Klasörleme (File Structure)

> **ZORUNLU DİZİLİM MÜHÜRLERİ:**
>
> Python/Django sizi Klasik "Modüler" `app` sistemine mahkum eder. Sistemin Mimarisine kafa yormayan her geliştirici "manage.py" ve "core" ile "users" dosyalarını spagetti bir kazan içinde iç içe geçirir.
> Otonom Zeka (AI) Bütün Katmanların Görevini milimetrik olarak kurgulamak VE BİLMEK ZORUNDADIR!

---

## 📂 1. Kurumsal Otonom Django Klasörleme Vizyonu (Root İskeleti)

Büyük (Enterprise) projelerde klasörler aşağıdaki Zırhlara Ve Yasaklara Tabi Olacaktır!

```text
UltimateDjangoAPI/
├── venv/                                   (YASAKLI BÖLGE: AI ve İnsan GİREMEZ! Sanal Env Kabuğu)
├── requirements.txt                        (NodeJS deki package.json - Kurulum Zinciri)
├── manage.py                               (TÜM Otonom Komutların Bağlandığı Tetikleyici)
├── .env                                    (Şifreler Zırhı! GİTHUB'A YÜKLENMESİ YASAK!)
├── core/                                   (VEYA config/ - ANA PROJE KASASI)
│   ├── settings.py                         (BÜTÜN UYGULAMADAKİ GİZLİLİK VE DB AYARLARI)
│   ├── urls.py                             (ANA KAVŞAK! Sadece Dış Uygulama Rotalarını Include Eder)
│   ├── asgi.py                             (WebSocket ve Real-Time İletişim Zırhı)
│   └── wsgi.py                             (Senkron Sunucu - Gunicorn İletişim Zırhı)
│
├── api/                                    (VEYA apps/ - OTONOMİNİN KOPUP GİTTİĞİ DOMAIN DRIVEN KLASÖR)
│   ├── users/                              (User Domain - Custom Auth Mimarisi)
│   │   ├── migrations/                     (SQl Zaman Tünelleri)
│   │   ├── models.py                       (VERİTABANI Entity Tanımlamaları / Çekirdek)
│   │   ├── views.py                        (CONTROLLER KATMANI: İstek Al → Data Dön)
│   │   ├── serializers.py                  (OTONOMİ YARATTI: JSON ve Validasyon DTO Mühürü)
│   │   ├── urls.py                         (OTONOMİ YARATTI: Local Rotalama - "/login")
│   │   ├── admin.py                        (Hazır Admin Paneli İzleyicileri)
│   │   └── tests.py                        (Test Yazılmadan Teslimat Yapılmaz!)
│   │
│   ├── products/                           (Bambaşka Bir Uygulama Zırhı)
│   │   ├── models.py                       
│   │   ├── views.py                        (ListAPIView, GenericAPIView Mühürleri)
│   │   ├── serializers.py                  (ProductSerializer DTO)
│   │   └── urls.py                         
│   │
│   └── common/                             (VEYA utils/ - ORTAK YARDIMCI MİMARİLER)
│       ├── exceptions.py                   (Sistemin Çökmesini Engelleyen Global Exception JSON Dönüştürücü)
│       ├── models.py                       (BaseModel sınıfı - Herkes Burayı Miras Alır (Inherit))
│       └── pagination.py                   (Özelleştirilmiş Sayfalama Algoritmaları)
│
└── media/                                  (OTONOM MÜŞTERİ YÜKLEMELERİ - RESİMLER)
└── static/                                 (CSS / JS VEYA ASSETLER - REST API İÇİN GEREKSİZ!)
```

---

## ⚠️ 2. Kritik Klasörleme Yasaları ve OTONOM REÇETESİ

Bir Otonom Yapay Zeka Ajanı Django REST API Mimarisi Tasarlarken aşağıdaki Ölümcül Hatalardan birini yaparsa, Mimarisi Reddedilecektir!

### Yasak 1: "core/urls.py" (Root URLs) İçerisinde Sızıntı Yapmak
Zeka, projenin Ana Kavşağına (`core/urls.py`) ASLA gidip ürün id'sini Veya Model Çağrılarını doğrudan YAZAMAZ. Ana Kavşak (Root URL) sadece Yönlendirme (Include) Yapar!
* **Yanlış Spagetti:** `path('products/', views.ProductList.as_view())`
* **Mükemmel Otonom Zırh:** `path('api/v1/products/', include('products.urls'))`
Bu sayede her modül Kendi Sınırlanmış Sokağına Has olur! (Domain Driven Encapsulation).

### Yasak 2: `models.py` nin Dışında Veritabanı Zekası Yaratmak! (Fat Models Prensibini Kırmak)
Mimar Zeka Eğer E-Ticaret'teki "Stok Düştüğünde Haber Ver" Veya "Sepet Toplamını Çıkar" Algoritmalarını (Logic) Düm Düz gidip Controller (views.py) klasörü içine Yığarsa Spagetti olur.
Kurumsal (Enterprise) Kararlar `models.py` ın içinde bir Def/Fonksiyon Method olarak Yazılmalı Ya da Sistem Aşırı Büyüdüyse `services.py` adında Özel bir Klasör (Dosya) YARATILIP Oraya Depolanmalıdır!

### Yasak 3: "serializers.py" İhmali (Sistem Zafiyeti)
"Django'nun kendi model formları var, Serializer O kadar Da Değil" diyen Bir Ajan Veya İnsan Çıplak Geziyordur! API (Mobil ve Web İçin) Dış Dünyadan JSON İstekleri (Payload) alır. Gelen İstek doğrudan Model Class İçerisine İtilirse Düşman İstediği Veriyi SİSTEMDE DEĞİŞTİREBİLİR!
Mimar Zeka Her `views.py` işleminden Mütavazı Olarak Önce Veriyi `UserSerializer(data=request.data)` İçinden Geçirip Kökten Doğrulayacaktır (Validation Trap)!

### Yasak 4: Monolithic (Aşırı Şişik) Modeller
Bir Django API uygulamasında Zeka asistanının Eposta yönetimi (Mails), Kullanıcı Yönetimi (Users) ve Gemi Kargoları (Logistics) Gibi her şeyi TEK BİR klasöre (`python manage.py startapp core`) Sıkıştırması Spagettidir. Ajan her "Business" (İş Bölgesi) için ayrı `startapp` Kullanarak Micro-Service Ufkuna Hazırlanmalıdır. 
Kurumsal Dünya'ya Hoş Geldin!
