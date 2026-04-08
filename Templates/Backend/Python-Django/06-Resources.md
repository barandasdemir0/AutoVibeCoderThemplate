# 6️⃣ Python-Django - Endüstri Klasikleri (Tech Stack) ve Kapsamlı Kaynak Kılavuzu

> Profesyonel, otonom bir AI (Yapay Zeka) sistemi Python-Django ortamında kodu SADECE Pür Vanilla API'ler (Ham Views) kullanarak yazmaz. Endüstri Node.JS pillerine göre daha oturmuş (Batteries Included) Python framework standartları, hız ve güvenliği kanıtlamış dev paketleriyle projenin etrafına Kalkanlar Örer.
>
> Spagetti kodu YASAKLADIK ve N-tier mimarisini Kurumsal Mühürü ile Zırhlıyoruz.

---

## 📦 1. Kütüphane ve Framework Zırhları Çekirdeği

Django dünyasında her iş için "PIP Install" yapmaya gerek yoktur. Mimar sadece The Enterprise Onaylı Kütüphaneleri Projeye dahil edecektir.

### A. Rest Mimari Çekirdeği (Sunum Kalkanı)
Vanilla Django ile `JsonResponse({})` dönerek E-Ticaret sitesi yazılmaz!

* **Zorunlu Kurulum:** `djangorestframework`
* **Neden?** Gelen JSON body'sini Doğrulama (Zod gibi), API rotası çizme ve JWT dahil her türlü Güvenlik duvarını sağlamak İçin.

### B. Mimaride Güvenlik Paketleri (Siber Koruma)
Otonom Zeka bir Uygulama yaratırken dışarıdan gelen (Mobil veya React) iletişim kilitlerini şu Kurumsal Devirlerle Yapar:

* **Django Cors Headers (`django-cors-headers`):** Sadece The Client'ın (Frontend uygulamalarının) IP veya Domainlerinden gelen paketlerin sisteme Girmesini Onaylayan Korsan Engelleyici Kilit!
* **Simple JWT (`djangorestframework-simplejwt`):** Eski OAUTH karmaşıklıklarından sıyrılmamızı sağlayan "Access Token" ve "Refresh Token" Pompası! Session İhtiyacını silip sistemi Limitsiz Ölçeklenebilir yapar.

### C. Performans ve Loglama Filtreleri (Celery & Redis)
Python default olarak Senkron ilerler. Eğer Müşteri Sisteme 5 MB Fotoğraf atıp bunu Küçültmeyi talep ederse ve kod Controller İçinde olursa Müşteri Ekranı 15 Saniye DONAR.

* **Celery (`celery`):** Asenkron görev Yöneticisinin Krallığı. İşiniz Varsa arka planda (Background Worker) yaptırmak ZORUNDASINIZ!
* **Redis (`redis`):** Sistemdeki yoğun Cache (Ön Bellek) okumalarını Veritabanına (PostgreSQL) Girmeden anında sunan In-Memory Çarpışma Engelleyici.

---

## 🤖 2. The Master Prompt Mühürü (Otonom Komut Şablonu!)

> **Aşağıdaki Şablon komutunu otonom Zekaya projeyi yazdırırken VERMEK ZORUNDASINIZ! Diğer türlü Django Projeniz 1 Saatte Function-Based Spagetti Çöplüğüne Dönüşecektir!**
> 
> **Master Otonom Django Komutu:**
> 
> "Bana kurumsal bir Python-Django REST API'si yazacaksın.
> Kuralların: 
> 1) Kesinlikle ve KESİNLİKLE API rotalama sistemi için Django REST Framework (DRF) Mühürü Kullanılacak. Geleneksel HTML Rendering/Yönlendirmesi KABUL EDİLEMEZ.
> 2) Mimari DÜZENİ ModelViewSet ve Serializer Mimarilerinden ZORUNLU olarak Oluşacak. Views.py dosyasının içerisine ASLA Şişman (Spagetti) SQL sorguları Veya Veri Doğrulama (Validation) yazılmayacak! Bütün Veritabanı ve Filtering Algoritmaları Models.py (Fat Model) VEYA Services.py dosyalarına Hapsolacak!
> 3) Bütün Model İlişkilerinde (Foreign Key) N+1 Hatalarını ENGELLEMEK için Controller'dan veri çekerken `select_related` VE `prefetch_related` Mühürlerini Kullanmayı Asla İhmal etme. 
> 4) Veriler Serialization (DTO Mimarisi) ile doğrulanmadan View Mantığı İşleme Almayacak. Global Exception Handler Yazılıp Bütün sistem Hataları Standart Müşteri JSON'ına dönüştürülecek! BÜTÜN MİMARİ Mühürleri ONAYLANDI. İşlemlere ve Kodlamaya Başla!"

---

## 🌍 3. Çöküş İzleme ve Environment Lojistiği (.env)

Django Projelerinde Kurumsal Olmayan Takımlar Gizli Kodları `settings.py` içerisine Düz String (PlainText) Olarak Yazar ve Github'a yollar. Otonom ajan BU SİBER GÜVENLİK İHLALİNİ YAPAMAZ!

Bunun Mühürü: `python-dotenv` Kütüphanesidir!

```python
# settings.py içerisine Environment Yüklenmesi
import os
from pathlib import Path
from dotenv import load_dotenv

# Base Dizin Yaratılır ve dotenv Çekilir
BASE_DIR = Path(__file__).resolve().parent.parent
load_dotenv(os.path.join(BASE_DIR, '.env'))

# ŞİFRELER ZIRHLANARAK DOSYADAN OKUNUR
SECRET_KEY = os.environ.get('SECRET_KEY', 'SİSTEM-ZIRH-PATLAK-VARSA-DEFAULT')
DEBUG = os.environ.get('DEBUG', 'False') == 'True' # Production Ortamı İçin Koruma Kalkanı!

# Database Lojistiği (Mimar Spagetti Koddan Arındırıp Sadece URL alır)
import dj_database_url
DATABASES = {
    'default': dj_database_url.config(default=os.environ.get('DATABASE_URL'))
}
```

Böylece Kurumsal Mimari Github'a İletilmez, Yalnızca İlgili Cloud Sunucusunda Kendini İnşaa Eder! Pillerimiz hazır, Kodlayıcı Başlasın!
