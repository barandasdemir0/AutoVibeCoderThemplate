# 2️⃣ Python-Django - Modern Sistem Mimarisi & Kod Standartları (Clean Architecture)

> **ZORUNLU MİMARİ NOTU:** 
> Yapay zeka bu belgedeki yapıları (app parçalanması, Serializer kalkanı, Model Managers) sadece tavsiye olarak ALGILAYAMAZ!
> 
> "Django ile her şey 5 dakikada yapılır" kandırmacası acemi (Junior) işidir. Evet 5 dakikada yapılır ama 3 ay sonra spagetti kod yüzünden projeyi ÇÖPE ATARSINIZ. Otonom ajan, projeyi kurumsal Service katmanlarıyla, Base (Temel) sınıflarla ve "Mükemmel İzolasyon" kurallarıyla tasarlayacaktır.

---

## 🏗️ 1. İskelet İzolasyonu: Klasörler ve App Sorumlulukları 

Bir Django projesi oluşturduğunuzda, `manage.py` size boş bir alan sunar. Otonomi Sistemi N-Tier (Katmanlı) olarak hayal edip şu mimariyi basacaktır:

### 🌐 API ÇIKIŞ KAPISI (Views / ViewSets)
* **Kapsam:** `views.py` veya `api.py` dosyaları.
* **Ne Yapar?** Sistemin postacısıdır. Gelen HTTP İsteğini (`request`) alır, Doğru DTO (Serializer) sınıfına yönlendirir. İş Mantığını Varsa Service dosyasına Atar ve sonucu JSON (Response) Olarak fırlatır.
* **Kurumsal Uyarı:** Mimar, Klasik `APIView` yerine Django REST Framework'ün devasa silahı olan `ModelViewSet` ve `GenericAPIView` yapılarını otonom olarak kullanır. (Böylece GET, POST, PUT, DELETE metotları spagetti if/else öbekleri Olmadan Tertemiz yönetilir!)

### 🛡️ DOĞRULAMA KALKANI (The Serializers)
* **Kapsam:** `serializers.py` dizini.
* **Ne Yapar?** Node.js'deki DTO / Zod Mantığı neyse, Django'daki Serializer aynıdır. Gelen çamurlu (Kirli) JSON verisini alır, temizler, validasyon uygular ve Model Objesine (Dictionary) Dönüştürür.
* **Kilit Otonomi Kuralı:** Otonom Zeka, şifre değişikliği veya kullanıcı Validasyonu kuralını (Örn: "Şifre Min 8 Karakter") ASLA `views.py` içine yazamaz! Mühür yeri ZORUNLU olarak Serializların `.validate()` methodudur!

---

## 🧠 2. The Custom Model Manager Zekası (İş Kuralı İzolasyonu)

Django'nun ORM'si Çok Güçlüdür. Ancak Sürekli Her View İçine `Product.objects.filter(is_deleted=False, is_published=True)` Yazarsanız Kod Duplication'dan (Tekrardan) Zehirlenirsiniz!

### Anti-Pattern View Zehirlenmesi (YASAKTIR):
```python
# API View İçerisinde Aynı Kodun Sürekli Tekrarı
def get_published_posts():
    return Post.objects.filter(published=True, deleted_at__isnull=True)
```

### Otonomi Kurumsal Mimarisi (Custom Managers):
Otonom Zeka `managers.py` veya `models.py` içindeki Custom Manager mühürlerini kullanarak Query Zekasını Soyutlar:

```python
from django.db import models

class PublishedPostManager(models.Manager):
    def get_queryset(self):
        # Bu mühürlenen zeka artık bütün sisteme yayılabilir!
        return super().get_queryset().filter(published=True, deleted_at__isnull=True)

class Post(models.Model):
    title = models.CharField(max_length=200)
    published = models.BooleanField(default=False)
    
    objects = models.Manager() # Default Pervane
    published_objects = PublishedPostManager() # OTONOM ZEKALI ÇEKİCİ

# Controller (View) Artık Sadece Çağırır ve Çıkar!
# Post.published_objects.all()
```

---

## ⚡ 3. Global Hata Filtresi (Exception Handling Mühürü)

Django ve DRF (Django REST Framework) default olarak Hataları Kendi Formatında Döner.
Eğer Projeyi "Production" moduna (Debug=False) Aldığınızda Müşterinin Karşısına düz HTML "Server Error (500)" Basılırsa Yapay Zeka Başarısız Olmuştur!

**Otonom Sistem Zırhı:**
Otonom mimar projenin `core/exceptions.py` (Custom Exception) Mühürünü yaratarak Hataları "Tek Bir Tip JSON" yapısına oturtur!!

```python
# core/exceptions.py
from rest_framework.views import exception_handler
from rest_framework.response import Response

def custom_exception_handler(exc, context):
    # Standart DRF hata yakalayıcısını otonom olarak çağır!
    response = exception_handler(exc, context)

    # Eğer hata Standart (400, 401, 404) değilse (Çöküş 500 ise)
    if response is None:
        return Response({
            'success': False,
            'message': 'Bilinmeyen Kurumsal Sistem Hatası!',
            'error_code': 'CRITICAL_500'
        }, status=500)

    # Özel JSON Kalkanını Formüle et
    custom_data = {
        'success': False,
        'message': 'Geçersiz Veri Girişi',
        'errors': response.data
    }
    response.data = custom_data

    return response
```
`settings.py`'de bu Mühürü aktif etmezsen Müşteri Spagettinin İçinde Boğulur!

---

## 👁️ 4. Base Model (Tohum Model) Anayasası

Bütün Django App'lerindeki "User", "Order", "Product" sınıfları `created_at` ve `updated_at` kolonlarına Muhtaçtır! Otonomi Gidip her modele bunu AMALELER GİBİ tek tek YAZMAZ! Sistemin köküne soyut (Abstract) Bir Sınıf Atar:

```python
class BaseModel(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True # Veritabanında (SQL) Bunun İçin Tablo ÇIKARTMAZZZZ!

# Tüm Otonom Modeller Bunu Miras (Inherit) Alır!
class Product(BaseModel):
    name = models.CharField(max_length=200)
```
Bu Anayasa Django zekasının Zirvesidir. Mimar, bu mimari zırhlara uymadan Otonom Kod Çıktısını Tamamlayamaz!
