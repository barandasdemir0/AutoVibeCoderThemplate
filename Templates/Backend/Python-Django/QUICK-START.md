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
# ⚡ QUICK START: The Autonomous Python-Django Master Directive (Otonom Komut Sablonu)

> **DİKKAT:** Bu dosya VibeCoding Otonom Zeka asistanlarının bir Python Django projesi başlatırken okuması ve HARFİYEN uygulaması gereken ana master prompt komutlarını içerir. Otonomi bu kilit dosyadaki ZORUNLU MÜHÜRLERİ okumadan mimariyi inşaa edemez!
> 
> "Spagetti Kod" (Monolithic Mess) Otonom Kurumsal Mimarlar İçin Kabul Edilemez Bir Zafiyettir! Django'nun Pilleri İçinde (Batteries Included) vizyonunu REST API ve DTO (Serializer) standartlarıyla kullanmak ZORUNDASIN!

---

## OTONOM ZEKANIN 5 ALTIN KURALI VEYA "ÇELİK MÜHÜRLERİ"

Bir otonom ajan, kullanıcıdan (Müşteri/Sizden) "Bana Python Django API (Backend) yaz" komutunu aldığı anda aşağıdaki sarsılmaz mimari kararları otomatikman devreye sokmak ZORUNDADIR.

### 1. The Django REST Framework (DRF) Zırhı
Modern mobil ve web projeleri bağımsızdır. Django ile "Jinja2" Veya HTML Template Render KURGULAMAYACAKSIN!
Tüm geri dönüşler (Responses) Kesinlikle Katı JSON Formatında DRF mimarisinden geçerek gönderilir. Tüm yönlendirmeler REST API Endpoints (URL) mantığındadır!

### 2. DTO (Serializer) Kalkanı ve Fat Model Prensibi
Controller (View) Katmanında Müşteriden (Payload) aldığı istek parametrelerini View içerisinde Spagetti tarzı if/else veya Model Save mantığıyla KİRLETEMEZSİN!
Otonomi Kesin Olarak bir `serializers.py` dosyası yaratır ve veriyi ModelSerializer içinden DOGRULAYARAK geçer. Ayrıca hesaplamalar (İndirim hesaplama vb) View'da değil, Doğrudan Class (Model) içinde bir fonksiyon olarak MÜHÜRLENİR!

### 3. N+1 Sorununa Karşı Katı "select_related" Alarmı
Otonomi, REST Endpointlerini yazdığı `views.py` dosyasında Asla Veritabanı Belleğini YORAMAZ!
* Eğer JSON çıktısında ForeignKey Dönecekse (Örneğin: Siparişin Sahibi), SQL tarafında 500 kere sorgu attırmamak için `select_related()` veya `prefetch_related()` komutlarını kullanmaya MECBURDUR. Bu performans Mühürüdür!

### 4. Global Error (Exception) Çöküş Engeli (Kurumsal Filtre)
Otonom ajanın yazdığı sistem çöktüğünde StackTrace (HTML İçeren Hata İzleri) dışarı sızamaz! `core/exceptions.py` Mimarisi kurularak Sınıf Mühürlenecektir! Otonomi DRF'nin Hata Yakalayıcısını üzerine yazar ve tüm çöküşleri (500 vb) "Standard Bir JSON Formatında" döndürür!

### 5. Stateless Token (JWT) ve CSRF İptali Zırhı
Kurumsal API dünyasında CSRF Token Çerez (Cookie) Zafiyetidir. Güvenlik `django-cors-headers` ve `SimpleJWT` kalkanı ile sağlanır! Auth middleware'leri Rotaların ETRAFINA sıkıca bantlanır! `settings.py` içinde Rest Framework ayarlarına IsAuthenticated Sınıfı İşlenir!

---

## THE MİMARİ OTONOM BAGLATMA KOMUTLARI (TERMINAL ZİNCİRİ)

AI'ın asistan olarak projeyi başlatırken kullanacağı terminal yürütme bandı!
Sanal Makine Kurulmadan Root İçine Pip Install YASAKTIR!

```bash
# Kurumsal Zırhları Kurmak İçin Virtual Environment Kabuğu (Yalıtım)
python -m venv venv

# Aktifleştir! Otonomi buradan devam etmeli (Windows)
venv\Scripts\activate

# Pip Kalibre Zırhları İndir (Django, DRF, JWT, CORS, Postgres-Connector, Environ)
pip install django djangorestframework django-cors-headers djangorestframework-simplejwt psycopg2-binary django-environ

# OTONOM APP ÜRETİMİ (Ana Kavşak core, Servis Kavşağı products gibi)
django-admin startproject core .
python manage.py startapp products
python manage.py startapp users

# Model Yapısı Oluştuktan Sonra OTO MİGRASYON!
python manage.py makemigrations
python manage.py migrate
```

**Mimar! Bu belgedeki kurallar, "İyi bir fikir" değil; Enterprise Uygulama Otonomisinin KIRILAMAZ ANAYASASIDIR!**
Sistemi inşa etmeye başlayabilirsin! Başarılar!

