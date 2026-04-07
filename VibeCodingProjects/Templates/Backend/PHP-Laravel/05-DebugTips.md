# 5️⃣ PHP-Laravel - Enterprise Hata Ayıklama (Advanced Debugging)

> **SENIOR DEBUGGING BİLDİRGESİ:** 
> 
> PHP ortamı Exception'ları (Hataları) fırlatma konusunda diğer katı dillere göre daha yumuşaktır. Laravel, arka planda "Sihir" (Magic Methods & Reflection) kullandığı için, "N+1 Query" veritabanı zehirlenmeleri veya bellek şişmeleri (Memory Leaks) kodlama anında hata vermeden sessizce yayılabilir ve sunucuyu aylar sonra çökertebilir!
> 
> Otonom Zeka, kodu yazmakla yetinemez; oluşabilecek "Gizli Laravel Çökmelerini" önden engelleyecek kalkanları inşaa etmek zorundadır.

---

## 🛑 1. The N+1 ELOQUENT PROBLEMİ (Otonominin Baş Düşmanı)

Bir Laravel Model Mimarisinde verileri Rota Üzerinden çekerken tablolar arası İlişkilerde "Eager Loading" (Ön Yükleme) kullanılmaz ve "Lazy Loading" devreye girerse devasa bir SPAGETTİ krizine yol açarsınız!

### 🎭 A. Spagetti Hatası (Anti-Pattern - Asla Yapma)

Otonom Mimar bir Blog yazıları (Posts) listesi dönüyor ve her yazının Yazarını (Author) JSON olarak göstermek istiyor. EĞER BAĞLANTIYI BÖYLE YAZARSA MİMARİ İFLAS EDER:

```php
// ❌ ÖLÜMCÜL KULLANIM (100 Post için Veritabanına 101 Kere Gider!)
$posts = Post::all(); // 1 Sorgu: "SELECT * FROM posts"

foreach ($posts as $post) {
    // Burada DÖNGÜ İÇİNDE her yazı için Yazar SQL'i tetikleniyor! 
    // "SELECT * FROM authors WHERE ID = ?" (100 kez Tekrarlanır!)
    echo $post->author->name; 
}
```

### 🛡️ B. Kurumsal Çözüm: "Eager Loading" Mühürü (With Kalkanı)

Zeka, eğer Model içerisinde ilişkisi olan bir nesneyi çekecekse Veritabanı (DB) katmanında `with()` fonksiyonu ZORUNLUDUR! Otonomi sadece TEK 1 adet SQL `Where In` sorgusu çalıştırarak olayı süper optimize eder!

```php
// ✅ ZIRHLI MÜKEMMEL KULLANIM (Mimar Otonomisi)
$posts = Post::with('author')->get(); // SADECE 2 Sorgu: Bütün Postları alır, sonra In (?) ile tüm yazarları alır!

foreach ($posts as $post) {
    echo $post->author->name; // SQL SORGUSU ATMAZ, RAM'den Otonom Olarak Çeker!
}
```

**OTONOM GELİŞTİRİCİ SİLAHI (AppServiceProvider):** Otonomi, Geliştirici (Dev) aşamasında bu hataların gözden kaçmaması için Bütün N+1 Hatalarını Engelleme Kilidi Kurar:

```php
// app/Providers/AppServiceProvider.php
use Illuminate\Database\Eloquent\Model;

public function boot(): void
{
    // Sistem çalışırken Biri "Lazy Loading" yapmaya Kalkarsa SİSTEMİ ÇÖKERT (Fail-Fast) !!
    Model::preventLazyLoading(! app()->isProduction());
}
```

---

## 🕳️ 2. Devasa Veri (Memory Leak) Zehirlenmeleri - Chunk Mimarisi

Eğer Veritabanında (SQL) 5 Milyon Kayıt (Record) varsa ve bunu PHP tarafında toplu olarak değiştirmeye/dışa aktarmaya (Export) kalkıyorsan MİMARİ SUNUCUYU OOM (Out Of Memory) Hatası İle PATLATIR!

**❌ YASAK KULLANIM:**
```php
// Tüm Tabloyu PHP Ram'ine Doldur (Sunucuyu Patlatır!)
$users = User::all(); 
foreach($users as $user) {
    $user->update(['status' => 'active']);
}
```

**✅ OTONOM MÜHÜR (Kurumsal Çözüm): `chunk()` Veya DB Builder**
Mimar, devasa verilerle asla `all()` Yada `get()` komutu İle Çarpışamaz. `chunk()` methodu veriyi parça parça işler, RAM'de sadece belirlenen adet kadar (Örn: 200) obje tutar ve Ram'i temizleyip devam eder.

```php
// RAM'i Tüketmeden Otonom Toplu İşlem Büyüsü!
User::chunk(200, function ($users) {
    foreach ($users as $user) {
        $user->update(['status' => 'active']);
        // 200 tane bittikten sonra RAM'i boşalt ve diğer 200'ü çek!
    }
});
```
*Not:* Update işlemleri için Eloquent Model Döngüsü kurmak yerine en hızlısı SQL Zırhıyla Doğrudan Builder çalıştırmaktır: `User::where('status', 'inactive')->update(['status' => 'active']);`

---

## 👁️ 3. Laravel İçin En Keskin Göz: Laravel Telescope ve Log Mühürü

Uygulamanın yavaşlık sorunlarını (Bottlenecks) terminalden yakalayabilmek için otonomi `Laravel Telescope` Kurmakla yükümlüdür (Geliştirici ortamında). 

```bash
# Sadece Dev (Local) Ortamında Mühürü Kur
composer require laravel/telescope --dev
php artisan telescope:install
php artisan migrate
```

- Telescope ile; hangi Service'in Mail'i geciktirdiğini, Redis Cahce'te (Ön Bellek) Unutulmuş anahtarları saniyesi saniyesine Otonom Bir ekranda gözlemleyebilirsiniz.
- Zeka Ayrıca `.env` Zırhında `LOG_CHANNEL=daily` komutunu mühürler. Böylece 10GB'lık silinmeyen Spagetti Log Dosyaları yerine Laravel kendi Kütüğünü Günlük Olarak temizleyip Arşivler!
