# 6️⃣ PHP-Laravel - Endüstri Klasikleri (Tech Stack) ve Kapsamlı Kaynak Kılavuzu

> Profesyonel, otonom bir AI (Yapay Zeka) sistemi Laravel ortamında sıfırdan "Tekerleği Yeniden İcat Etmeye" (Re-inventing the wheel) kalkmaz. 
> Laravel'in Enterprise (Kurumsal) dünyadaki gücü, birinci şahıs (First-Party) ekosistem kütüphanelerinin (Sanctum, Horizon, Telescope) çekirdek MVC ile muazzam Spagetti-Aramayan entegrasyonuna dayanır.

---

## 📦 1. Kütüphane ve Framework Zırhları Çekirdeği

PHP "NPM Hell" (Paket Cehennemi) yaşamaz çünkü `composer` mimarisi Zırhlıdır. Otonom Ajan Sadece Enterprise Onaylı Paketleri entegre ederek kodu Kurumsal bir Çizgiye Ulaştırır.

### A. Kodun Kalite Mühürü (Static Analysis)
Tip güvenliği (Type Safety) zayıf olan PHP dilini mükemmel bir Otonomiye Sokar.
* **Larastan (`nunomaduro/larastan`):** Dünyadaki hiçbir Laravel projesi bu kalkan olmadan `Production` a çıkamaz! Kod içerisindeki tanımsız Değişkenleri ve Hatalı Objeleri derlemeden Otonom olarak tarar.
* **Laravel Pint (`laravel/pint`):** PHP kodunu otomatik olarak hizalar. Spagetti, dağınık girintiler YASAKLANIR!

### B. Mimaride Güvenlik Ve API Kalkanları
Otonom Zeka bir REST API Uygulama tasarlıyorsa aşağıdaki Paketleri mühürler!
* **Sanctum (`laravel/sanctum`):** Spa, Mobil veya API entegrasyonu İçin Kurumsal Token ve Auth Kalkanıdır. Stateless Mimari!
* **Rate-Limiting (RouteServiceProvider):** Brute force ve DDoS hack saldırılarını Rotalarda Engeller. 

### C. Resource ve DTO Yönetimi Zırhları
Veritabanı Entity modellerini Dış Dünyadan KORU!
* **API Resources (Native):** Laravel'in kendi kütüphanesidir. `make:resource` Mühürü İle Modeli Json olarak haritalandıran Mükemmel sistem.
* **Spatie Data Transfer Object (`spatie/data-transfer-object` Veya `spatie/laravel-data`):** Çok Katı ve Kurumsal (C# Kalibresindeki) Otonomi Takımlarının, Controller ve Service arasındaki Veri aktarımını %100 Tip Korumalı (Type-Safe) bir DTO Mimarisine gömdüğü En Büyük Laravel Silahı!

---

## 🤖 2. The Master Prompt Mühürü (Otonom Komut Şablonu!)

> **Aşağıdaki Kalkan Komutunu otonom Yapay Zeka ajanı projeyi başlarken ZORUNLU OKUMALIDIR. Aksi Halde Laravel Projeniz Anında Spagetti Kod Çöplüğüne Düşecektir!**
> 
> **Master Otonom Laravel Komutu:**
> 
> "Bana kurumsal bir PHP-Laravel REST API backend projesi yazacaksın.
> Sen otonom bir mimarsın. ŞU KURALLARA %100 UY: 
> 1) Kesinlikle PHP 8.x Type-Hinting kullan. Geri Dönüş Tipleri (Return Types) olmadan (Örn: `: JsonResponse`) YAZIM GÜÇLÜ OLAMAZ!
> 2) Mimari DÜZENİ Controller -> Service -> Model formatında ZORUNLU olarak oluştur. Controller dosyasının içerisine ASLA form validasyonu veya veritabanı kodu (Örn: `User::create()`) yazılmayacak! Bütün Form Validasyonları `Form Request` dosyalarında, veritabanı Zekası is `Services` dosyalarında MÜHÜRLENECEK!
> 3) Bütün Model İlişkilerinde (Relations) N+1 Problemini ZORUNLU OLARAK önle, veri çekerken `with()` kullan.
> 4) Global Exception Handler dosyalarını Otonom Kurgula. Hatalar HTML ÇIKTISI GÖSTEREMEZ, dışarı SADECE Formatsal JSON ÇIKTISI verilir!
> 5) Gelen İsteği (Payload) ZORUNLU olarak Form Request Mimarisiyle sınırla ve doğrula. BÜTÜN MİMARİ Mühürleri ONAYLANDI. İşlemi Başlat!"

---

## 🌍 3. Kuyruk ve Asenkron (Queue Worker) Lojistiği

PHP, Node.js veya Go-lang gibi doğal Asenkron çalışmaz. E-posta Gönderimi, Görüntü Işleme veya PDF oluşturma gibi Dev Süre Bekleten işlemler KESİNLİKLE API Response Çİzgisine sokulmaz. Sistemin Cevap verme Süresini Dondurursun!

Mimar, Otonom Görevleri (Jobs) Zırhlayarak Kuyruk (Queue) Mimarisine Atmalıdır:

```php
// Spagetti Mimari: Müşteri 5 saniye Yükleme Ekranı (Spinner) İzler!
public function register(Request $request) {
    $user = User::create($request->all());
    Mail::to($user)->send(new WelcomeEmail()); // KİLİTLENME BURADA!
    return response();
}

// ZIRHLI MÜKENDİSLİK:
public function register(RegisterRequest $request) {
    $user = $this->authService->registerUser($request->validated());
    
    // OTONOMİ DEVREDE! (Job Kuyruğa Atılır ve hemen Json Döner)
    SendWelcomeEmailJob::dispatch($user); 
    
    return ApiResponse::success($user, 201);
}
```

Bu otonomi için `php artisan queue:work` Mühürü Sunucu Üstünde (Örn: Supervisor Tarafından) Sürekli Dinlenir!

**Laravel ile Geliştirilen Devasa Platformlar BU KATMANLI VE ZIRHLI OTONOM KURALLARLA GÜVENLİ VE HATASIZ KALIR!**
