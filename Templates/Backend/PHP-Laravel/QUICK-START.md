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
# ⚡ QUICK START: The Autonomous PHP-Laravel Master Directive (Otonom Komut Sablonu)

> **DİKKAT:** Bu dosya VibeCoding Otonom Zeka asistanlarının bir PHP-Laravel projesi başlatırken okuması ve HARFİYEN uygulaması gereken ana master prompt komutlarını içerir. Otonomi bu kilit dosyadaki ZORUNLU MÜHÜRLERİ okumadan mimariyi inşaa edemez!
> 
> "Laravel'de Spagetti Kod" (Monolithic Controller Mess) Otonom Kurumsal Mimarlar İçin Kesinlikle Kabul Edilemez Bir Zafiyettir! Laravel'in esnekliğini Form Request ve Service kalkanlarıyla Kontrol Etmek ZORUNDASIN!

---

## OTONOM ZEKANIN 5 ALTIN KURALI VEYA "ÇELİK MÜHÜRLERİ"

Bir otonom ajan, kullanıcıdan (Müşteri/Sizden) "Bana PHP Laravel API (Backend) yaz" komutunu aldığı anda aşağıdaki sarsılmaz mimari kararları otomatikman devreye sokmak ZORUNDADIR.

### 1. The Controller & Routing İzolasyon Zırhı
Laravel'de asla "routes/web.php" veya "routes/api.php" içerisine Spagetti (Closure/Anonim Fonksiyon) kodlarla veritabanı sorgusu YAZILMAYACAKTIR!
Tüm Rotlar katı bir şekilde Controller sınıflarına (Örn: `[UserController::class, 'index']`) Gönderilir.
Controller Katmanı SADECE HTTP İsteklerini karşılar. Asla ama Asla doğrudan Eloquent ile `User::create()` (DB Kaydetme Mantığı) İHTİVA EDEMEZ! Controller Katı Zırhında Veri Service katmanına yollanır ve Oradan Gelen cevap (Res) Müşteriye basılır.

### 2. Form Request Validator (Kalkan) Mühürü
Controller metodunun Müşteriden (Payload) aldığı istek parametrelerini Controller içerisinde `request()->validate()` spagettisiyle KİRLETEMEZSİN!
Otonomi Kesin Olarak `php artisan make:request StoreUserRequest` emriyle Form Request sınıfı YARATIR! Gelen veri Controller mantığına inmeden Kapıdaki Görevli (Form Request) Tarafından durdurulur ve Hata Varsa 422 JSON kodu otonom olarak Fırlatılır!

### 3. Service Pattern (İş Zekası Merkezi)
Laravel'de default olarak "Services" klasörü GELMEZ. Ancak Sen bir Kurumsal (Enterprise) Mimarsın! Hemen `app/Services` klasörünü yaratıp, Bütün İndirim Hesaplamalarını, E-posta Entegrasyonlarını, RabbitMQ Bildirimlerini veya Veritabanı Insert (CRUD) Taktiklerini Burada Yapacaksın! 
* İş Kuralları izoledir ve Başka Otonom Command'lerden Veya Sınıflardan Geri Çağırılabilir (Re-usable).

### 4. API Resources (DTO/Veri İzolasyonu) Zırhı
Veritabanı Entity Modelini (`$user = User::find(1)`) bulup anında Müşteriye Otonom JSON Olarak DÖNEMEZSİN! Model bilgileri SIZAR! 
Bunun Yerine `php artisan make:resource UserResource` komutuyla Çıktı Biçimlendiriciyi Yaratır, Parolayı Filtreleyip sadece güvenli Kutuya Çevrilmiş bilgiyi Yayınlarsın!

### 5. Sanctum ve Stateless Token Zırhı
Otonomi, API yazarken Klasik Laravel "Session" Mimarisini iptal eder. Rest API'ler her sunucuda Load Balancer arkasında problemsiz (Stateless) çalışmalı. Bunu Otonom Bir gekilde Laravel Sanctum (Token Auth) ile Güvenceye alır, Authentication Middleware'lerini Rotaların Etrafına Sıkıca BANTLARSIN.

---

## THE MİMARİ OTONOM BAGLATMA KOMUTLARI (ARTISAN ZİNCİRİ)

AI'ın asistan olarak projeyi başlatırken klasöre inip kullanacağı terminal yürütme bandı!

```bash
# Kurumsal Laravel API İskelet Zırhını İnşaa Et!
composer create-project laravel/laravel TheEnterpriseApi

# İçeri Gir ve API Kalkanlarını Otonom Kur
cd TheEnterpriseApi
php artisan install:api

# Örnek Bir Modül (Product) İçin Tüm Silahları Kuşan (Migration, Controller, Resource, Service, Request)
php artisan make:model Product -mcr
php artisan make:resource ProductResource
php artisan make:request StoreProductRequest

# Quality Gate (Statik Kod Kalkanı Otonomisi)
composer require --dev nunomaduro/larastan
```

**Mimar! Bu belgedeki kurallar, "İyi bir fikir" değil; Enterprise PHP-Laravel Otonomisinin KIRILAMAZ ANAYASASIDIR!**
Sistemi kodlamaya bu şartları yükleyerek başlayabilirsin! Başarılar!

