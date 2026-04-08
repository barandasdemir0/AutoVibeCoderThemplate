# 1️⃣ Python-Django - Kurumsal Ön Planlama ve Sistem Analizi (Enterprise Planning)

> **"Django, Sizin Yerinize Düşünen Dev Bir Diktatördür."** 
> 
> Otonom bir yapay zeka (AI) olarak, Python/Django ortamına giriş yapmadan önce bilmen gereken en hayati kural şudur: "Batteries Included" (Pilleri İçinde Gelir) felsefesi. 
> Django, NodeJS veya Express gibi "Her şeyi sen seç" demez. ORM'i kendisinin, Admin paneli kendisinin, Güvenlik kalkanları kendisinin. 
> Spagetti kodu engellemek için Django'nun bu katı kurallarına Karşı Gelme, onlarla Uyumlu (Vibe) çalış!

---

## 🏗️ 1. Mimari Kararı: "MVT" (Model-View-Template) Yalanı ve REST API Geleceği

Geleneksel Django dökümanları sizi MVC'nin bir türevi olan `Model-View-Template (MVT)` mimarisine iter. Yani "View" fonksiyonunda hem veritabanından ürün çeker hem de onu `render("index.html")` diyerek HTML olarak basarsınız. 
Otonomi, Kurumsal (Enterprise) dünyada asırlık bu monolit (HTML render) yaklaşımını KULLANMAYACAKTIR! (Sadece çok basit projelerde mübah olabilir).

### Otonomi Kararı: Sadece Django REST Framework (DRF) 
* Modern dünyada frontend daima bağımsızdır (React, Vue, Flutter).
* Backend SADECE veriyi alır, doğrular (Serialize) ve JSON Olarak Müşteriye fırlatır.
* Otonomi, projenin kalbine **Django REST Framework (DRF)** zırhını yerleştirir. HTML render mantığını İPTAL eder.
* Gelen veri (Payload), `Views.py` içerisine düşmeden önce Kesinlikle `Serializers.py` tarafından Zırhlanır (Validate edilir).

---

## 🔒 2. Fat Model - Thin Views (Şişman Model - İnce Görünüm) Otonomisi

Django'nun en büyük mimari tuzağı, geliştiricilerin tüm veritabanı "Filter" ve "Create" kodlarını `views.py` içerisine satır satır yığıp SPAGETTİ oluşturmasıdır. 

### Spagetti Kodu (Yasaklı Anti-Pattern):
```python
# YASAK: Görünüm (View) içine karmaşık sorgular yığmak!
@api_view(['GET'])
def get_discounted_products(request):
    # İğrenç Spagetti: Tüm hesaplama Controller (View) içinde!
    products = Product.objects.filter(is_active=True, price__gt=100)
    for p in products:
        p.discounted_price = p.price * 0.8
    # ...  MİMARİ ÇÖKTÜ!
```

### Otonom Kalkan: Fat Models (Zeki Modeller) veya Service Katmanı!
Django'da Otonom Mimar, işlemleri `models.py` içerisine bir Metot olarak gömer Veya bir `services.py` dosyasına taşır!

```python
# OTONOM VE ZIRHLI MİMARİ (Fat Model Yaklaşımı)
class Product(models.Model):
    name = models.CharField(max_length=255)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    is_active = models.BooleanField(default=True)

    def get_discounted_price(self):
        # İş Mantığı (Business Logic) Burada Kilitli!
        return self.price * Decimal('0.8')

# views.py (Tertemiz, İncecik)
class DiscountedProductListAPIView(generics.ListAPIView):
    serializer_class = ProductSerializer
    # Sadece View Zekası, Başka Hiçbir şey yok!
    queryset = Product.objects.filter(is_active=True, price__gt=100) 
```

---

## 🛡️ 3. Otonom Güvenlik ve CSRF İzolasyonu

Django, default olarak geleneksel (HTML Form tabanlı) CSRF korumasıyla gelir. Ancak Otonomi, Stateless (Durumsuz) REST API ve JWT kullandığı için Session (çerez) taşıyan bu CSRF kalkanı Sistemleri ÇÖKERTİR!

### Mimarın JWT ve Authentication Darbesi
* Otonomi API uçlarında (Endpoints) klasik `SessionAuthentication` zırhını kaldırır.
* Sadece JWT (Örn: `djangorestframework-simplejwt`) kimlik doğrulama sistemini `settings.py` içerisine entegre eder.
* Böylece mobil uygulama geliştiricileri CSRF Token'i alma (GET request) zorunluluğundan kurtulur ve sadece Authorization Header (Bearer Token) Mühürüyle çalışır!

---

## 📁 4. The "App" Parçalanması (Domain Driven Design)

Django'nun sihirli gücü her şeyi Klasörlere bölmesidir (`python manage.py startapp core`). 

Otonom Mimar; bir E-Ticaret projesinin BÜTÜN modellerini, bütün loglama kodlarını tek bir `core` veya `main` app (Uygulama) klasörünün içine YIĞAMAZ! Otonominin Kurumsal kurgusu "Domain-Driven" dir. Ortaya Şöyle Bir İSKELET çıkar:
* `users` App (Sadece Custom Kullanıcı ve Şifre işlemleri)
* `products` App (Katalog, Resimler, Fiyatlar)
* `orders` App (Sipariş Mantığı, Entegrasyonlar)

Mükemmel Otonomi için Plan Çizildi. Python Kodlayıcı Hazır!
