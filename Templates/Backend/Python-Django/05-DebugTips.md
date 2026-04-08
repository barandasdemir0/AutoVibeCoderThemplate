# 5️⃣ Python-Django - Enterprise Hata Ayıklama (Advanced Debugging & Profiling)

> **SENIOR DEBUGGING BİLDİRGESİ:** 
> 
> Python (Django) dilinin çalışma mantığı (Runtime) oldukça hızlı olsa da, Django ORM si o kadar yüksek seviyeli ve basittir ki; farkına bile varmadan Veritabanı Belleğini Şişiren ve sunucu CPU'sunu %100'e fırlatan Zehirli Sorgular asistan tarafından yazılabilir!
> 
> Otonom Zeka, kodu sadece çalışsın diye bırakmaz. O kod 5 Milyon satırlı veritabanında çalışırken sunucuyu kilitleyecekse o otonomi başarısızdır! İşte Enterprise Django Hata Avcıları...

---

## 🛑 1. The N+1 SELECT PROBLEMİ (Django'nun En Ölümcül Hastalığı)

Tıpkı PHP Laravel veya Java Spring'te olduğu gibi Otonom Mimariler ilişkisel (Foreign Key ve Many-To-Many) verileri çağırırken "Lazy Loading" tuzağına düşmemelidir!

### 🎭 A. Zehrin Zerk Edilmesi (Anti-Pattern) 

Bir yazar (Author) modeli ve ona ait kitaplar (Books) var diyelim.

```python
# ❌ ÖLÜMCÜL KULLANIM (Spagetti API View İçerisi)
@api_view(['GET'])
def list_books(request):
    books = Book.objects.all() # 1 Kere Çalıştı (Tüm kitapları aldı)
    
    data = []
    for book in books:
        # ÖLÜMCÜL NOKTA: book.author DEDİĞİNİZ AN, DJANGO SQL'E KOŞAR!
        # Eğer listede 500 kitap varsa, arka planda 500 TANE YAZAR SQL SORGUSU ATILIR!
        # O API 30 Saniyeden önce müşteriye geri ULAŞAMAZ. TIMEOUT!
        data.append({'title': book.title, 'author_name': book.author.name})
        
    return Response(data)
```

### 🛡️ B. Çözüm: "select_related" VE "prefetch_related" Zırhları!

Eğer Mimar YZ, View veya Serializer içinde bir ForeignKey Datası Dönecek İse, Veritabanına (ORM) anında Mühür Çakmalıdır! 

```python
# ✅ ZIRHLI MÜKEMMEL KULLANIM (Enterprise Otonomisi)
@api_view(['GET'])
def list_books(request):
    # Eğer İlişki 1-1 veya Foreign-Key (Örn: Modelin Kendi Sahibi) İse -> select_related (SQL JOIN)
    # Eğer İlişki Çoka-Çok İse (ManyToMany) -> prefetch_related (Python İçi Ram Mapping)
    
    books = Book.objects.select_related('author').all()
    # SQL JOIN YAPILDI! SADECE 1 (BİR) ADET SORGUDAN TÜM VERİ ÇEKİLDİ! Sunucu Hızı: 5 milisaniye.
    
    data = [{'title': b.title, 'author_name': b.author.name} for b in books]
    return Response(data)
```

---

## 🕳️ 2. Serializer Şişmelerinin Çökerttiği RAM Sorunu (N+1 in Serializers)

Django REST Framework (DRF) içerisinde Serializerlar sihirli çalışır. 
```python
class BookSerializer(serializers.ModelSerializer):
    author_name = serializers.CharField(source='author.name') # ZEHİR BURADA!
```
Eğer Controller (views.py) de `select_related('author')` demediysen, ModelSerializer `source='author.name'` yazdığın her kitaba tek tek SQL atarak N+1'i Otonom bir biçimde (Kendiliğinden) patlatır!

**Çözüm Prensibi:** Serializer İçinde `source=` veya `SerializerMethodField` Varsa, Otonomi otomatik olarak Aklına `prefetch_related / select_related` GETİRMEK ZORUNDADIR!

---

## 👁️ 3. DJANGO DEBUG TOOLBAR (Dev Ortamının Vazgeçilmez Gözü)

Hala "Terminalde Hızlı Dönüyor mu" diye bakarak Enterprise Proje yapılamaz. Arkaplanda atılan sql sorgularını ve RAM şişkinliklerini okumak için otonomi sisteme **Django Debug Toolbar (DDT)** kurmakla yükümlüdür (SADECE DEV Ortamında).

```bash
pip install django-debug-toolbar
```

**Settings.py Zırhı:**
```python
if DEBUG: # Production'da asla aktif edilemez Gizlilik Kalkanı!
    INSTALLED_APPS += ['debug_toolbar']
    MIDDLEWARE = ['debug_toolbar.middleware.DebugToolbarMiddleware'] + MIDDLEWARE
    INTERNAL_IPS = ['127.0.0.1']
```
Bu mühür, API Rotalarında "Hangi SQL ne kadar Sürede işlenmiş" saniyesi saniyesine yakalar!

---

## 🛑 4. Transaction Atomik (Database Locks) Zehirlenmeleri

Banka veya E-ticaret Sistemleri Kodlarken:
1. Müşteriden Para Çektin.
2. Siparişi Oluşturuyordun AMA Sunucunun Prizi Çıktı!
Sonuç: Müşterinin Parası Kayıp Ve Sipariş Yok (Sistem Dağıldı).

### OTONOM ATOMİK MÜHÜR!
Mimar kritik veritabanı yığını yaparken BÜTÜN View veya Service işlemlerini `transaction.atomic()` ile kalkanlandırır.

```python
from django.db import transaction
from django.core.exceptions import ValidationError

def create_order_with_payment(order_data):
    try:
        with transaction.atomic(): # İŞLEM MÜHÜRLENDİ ZIRHLANDI!
            payment = Payment.objects.create(...)
            # Eğer bir saniye sonra buradaki kod hata fırlatırsa 
            order = Order.objects.create(...) 
            
            # Geri Hata:
            if order.is_failed():
                raise ValidationError("Failed")
                
    except ValidationError:
        # Otonom Veritabanı Güvencesi:
        # Django, TRY CATCH içerisinde raise (iptal) yaşandığı an
        # Yaratılmış olan ÖDEME kaydını SQL'den OTONOM OLARAK SİLER!
        # SISTEM ZIRHLI VE TEMIZ KALIR.
        pass
```
Python (Django) Hızı "Kodun Yavaşlığı" İle Ölçülmez. Hatalı Geliştiricinin Mimari Zaaflarından dolayı şişen RAMlerle Ölçülür! Ajan Sistemin Çökmemesini Sağladı!!
