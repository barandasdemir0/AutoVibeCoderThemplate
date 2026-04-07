# 3️⃣ Python-Django - Endüstriyel Başlangıç Adımları (Step-By-Step Setup)

> **OTONOM KOMUT BAŞLATICI VEYA CLI UYARISI:**
> 
> Python projeleri Spagetti'ye Dönüşmemek için `virtualenv` VEYA `poetry` yalıtımına İhtiyaç Duyar! Otonom bir yapay zeka, Anaconda kullanıcısının bilgisayarında Root Python üzerine Paket (Library) yükleyemez! Sistemlerin çökmesini sağlayan bu vahşi acemi ortamlarına son veriyoruz.
> 
> Terminali ele alıyoruz!

---

## 🚀 FAZ 1: Sanal Ortam Zırhı ve Çekirdek Sistem Yüklemeleri

Ajan, projeyi başlatmak için kullanacağı izole kapsülü (Virtual Environment) oluşturur.

### Adım 1: Klasör ve Çevresel Kapsül (Virtual ENV)
```bash
# Ana Klasör
mkdir UltimateDjangoAPI
cd UltimateDjangoAPI

# Çevresel Zırhı Yarat (Windows/Linux Farketmez)
python -m venv venv

# Windows İÇİN Etkinleştir! OTONOM ZEKANIN İLK İŞİ BUDUR!
venv\Scripts\activate
# (Linux olsaydı: source venv/bin/activate)
```

### Adım 2: Dev Kurumsal Paket (Dependencies) Yüklemeleri
Otonomi `django` yükleyip geçemez. DRF (Rest Framework), JWT ve CORS Zırhları yüklenmeden API yapamazsın!

```bash
# Çekirdek ve API
pip install django djangorestframework

# API Güvenlik Çeperleri (Frontend Haberleşmesi İçin)
pip install django-cors-headers djangorestframework-simplejwt

# Veritabanı ve Çevresel Güvenlik (Environment Mühürü)
pip install python-dotenv psycopg2-binary
```
Otonom Zeka yükleme biter bitmez `pip freeze > requirements.txt` emrini verip bu kilit dosyayı Yaratır!

---

## 🏗️ FAZ 3: Django Mimarisi ve App (Modül) Tasarımları

Paketler indi, Otonomi "manage.py" Mühürünü masaya vuracak.

### Adım 3: İskelet Konstrüksiyon İşlemi
```bash
# Proje Kapsayıcısını (Kök) Üretme (Dikkat: Nokta ( . ) var sonunda!)
django-admin startproject core .

# Domain-Driven Design Kuralına Tabi Asıl Uygulamayı Yarat!
python manage.py startapp products
```

### Adım 4: Kurumsal Kalkanların (Settings) Birleştirilmesi
Otonomi `core/settings.py` dosyasına sızar! İndirilen Pilleri Mühürleme İşlemi:

```python
# settings.py içerisine ENJEKTE EDİLEN MİMARİLER:

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    
    # Otonom Kalkanlar Eklendi
    'rest_framework',
    'corsheaders',
    'rest_framework_simplejwt',
    
    # Domain Modülleri Eklendi 
    'products', 
]

# MIDDLEWARE GÜVENLİK BARİYERİ (Listede EN ÜSTE 'CorsMiddleware' Ekle!)
MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware', # EN ÜSTTE ZORUNLU
    'django.middleware.security.SecurityMiddleware',
    #...
]

# REST FRAMEWORK GLOBAL MÜHÜRLERİ 
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.IsAuthenticated', # Sistemi dışarıya Kapat Rata-Limiterları vs ekle
    ]
}
```

---

## 🎨 FAZ 4: Veritabanı Entity ve DTO Uygulaması

Products Klasörüne Otonomi Model çizer.

### Adım 5: Modelleri Üretme (products/models.py)
```python
from django.db import models

class Category(models.Model):
    name = models.CharField(max_length=150)
    
class Product(models.Model):
    category = models.ForeignKey(Category, on_delete=models.CASCADE, related_name='products')
    name = models.CharField(max_length=200)
    price = models.DecimalField(max_digits=10, decimal_places=2)
```

### Adım 6: DTO (Serializer) Zırhı Üretimi!
Django `startapp` modülü Otonomiye `serializers.py` dosyası VERMEZ! Otonomi bu dosyayı `products/` altına MANUEL OLARAK YARATIR!

```python
# products/serializers.py MÜHÜRÜ!
from rest_framework import serializers
from .models import Product

class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = ['id', 'category', 'name', 'price']
```

---

## ⚡ FAZ 5: Mimarinin Yürütülmesi (Migrations & Test)

Model Çizildi. Sıra Onu Veritabanına (Sqlite/Postgres) Basmaya geldi.
Zeka `views.py` dosyasına DRF mantığını yazıp sistemi terminalden bağlatır:

```bash
# Çizilen Entity Sınıflarını Otonom Sql Çevirisi Yap (Migration)
python manage.py makemigrations

# SQL'e İşle (Tabloları Yarat)
python manage.py migrate

# Yönetici Yarat! (Otonomi burayı bypass edebilir kendi script yazarsa)
# python manage.py createsuperuser

# Sunucuyu Kurumsal Olarak Ayağa Kaldır!
python manage.py runserver 0.0.0.0:8000
```
Bütün Zırhlar, CORS engelleri ve JWT asil kaskatları devrededir. Otonom ajan Django Spagetti bataklığına düşmeden mükemmel REST servisini hayata geçirdi!
