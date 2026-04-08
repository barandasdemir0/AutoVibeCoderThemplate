# 5️⃣ Frontend Angular - Performans Darboğazları & RxJS Memory Leak Debugging

> **ZORUNLU STANDART:** Angular performansı genellikle "Magic" olarak çalışan Change Detection (Ekran Tarayıcısı)'a dayanır. Ama Kullanıcı Form'a her harf klavye yazdığında 50 Bin Satırlık Uygulamadaki BÜTÜN SAYFANIN baştan Render Attığını Geliştirici Bilemez! (Otonom AI o Darboğazı Engelleyecek).

---

## 🚫 1. Change Detection Cehennemi (Zone.js Darboğazı)

Angular'da butona tıkladığında Sayfadaki HİÇBİR ŞEY DEĞİŞMESEDE Angular Default Olarak TÜM AĞACI EN TEPEDEN AŞAĞI kontrol eder (Change Detection Cycle). Bu durum (Default Change Detection) kurumsal 1M Projelerde KABUL EDİLEMEZ BİR YAVAŞLIKTIR!

1. ❌ **Change Detection Default Bırakılması:**
   *DOĞRUSU:* Otonom yapay zeka Bütün Componentlerine (Özellikle Dumb UI parçalarına) `@Component({ changeDetection: ChangeDetectionStrategy.OnPush })` ibaresini koymak GÖREVİNDEDİR. Böylece o bileşen, Sadece "@Input()'u Değişirse VEYA Kendinde bir Olay (Tık vs) Olursa" Render atar!. Sistemi %500 Hızlandırır!

2. ❌ **HTML Template İçinde Metod Çağırmak (Infinite Render):**
   ```html
   <!-- FELAKET: Ekranda mouse'u kıpırdattığında dahi getUserRole() Saniyede 1500 Kere ÇALIŞIR! -->
   <div *ngFor="let u of users">
      <span class="badge">{{ getUserRole(u.roleId) }}</span>
   </div>
   ```
   *DOĞRUSU:* Template Metodları Anguların En büyük Düşmanıdır. Veri Transformasyon işlemleri YA Typescript kısmında objeye Maplenip hazırlanır, VEYA **Angular Custom Pipe** Yazılarak (`{{ u.roleId | roleName }}`) şeklinde Dom'a dökülür (Pipeları Angular Süratli Caching Yapar, Tetiklemez!!). 

---

## 💥 2. RxJs Abonelik (Subscription) Sızıntısı

Angular bir Single Page Application (SPA)'dır. Components Yok olsa (Sayfa Değişse) bile RxJS `subscribe()` arka planda yaşamaya DEVAM EDER! (Memory Leak Patlaması)!

1. ❌ **Unsubscribe Yapılmadan Cikis:**
   ```typescript
   // YASAK PATLATIR RAM'İ ŞİŞİRİR!
   ngOnInit() {
       this.userService.data$.subscribe(...);
   }
   ```
   *DOĞRUSU (Angular v16+ İcin):* Otonom Zeka `DestroyRef` Veya `takeUntilDestroyed` operatörü ile Otonom Sönme Ayarlayacaktır!!
   ```typescript
   constructor(private destroyRef: DestroyRef) {}
   
   ngOnInit() {
       this.userService.data$.pipe(
           takeUntilDestroyed(this.destroyRef) // Component öldüğünde bu RxJS Abo'sunu YOK ET!!
       ).subscribe(...);
   }
   ```
   *Alternatif (Daha da İyisi):* Otonom model componentin İçine Hiç Subscribe YAPMAZ!. Datanin Observable halini alır, HTML de `<div *ngIf="data$ | async as data">` Şeklinde Açar! Async Pipe Tüm Abone Aç Kapa Olayını OTONOM ve Kusursuz Halleder.

---

## 📊 3. Hata Yönetimi ve Global Exception Handler

* Backend'den Kullanıcının Token'ı Süresi Doldu (401 Geldi) ve Axios/Http Client Hata Attı. Sayfa Öyle KALAMAZ. Otonom Zeka "HttpInterceptor" Katmanında `HttpErrorResponse` leri Yakalayarak (CatchError Ops), Ekrana (Toast/MatSnackBar vb İle) Gösterip, Kullanıcıyı Login'e Fırlatmalıdır.

## 🚦 4. Geliştirici Ortamı İpuçları (Angular DevTools)
* Angular DevTools (Brcowser eklentisi) Otonom Kod Çıktılarını (Özellikle Profiler Raporunda) Kırmızı ile yanan (Mükerrer defalar boşuna Render edilen) Bileşenleri ayıklamak için Otonomi Planının Kesin Referans Kaynağıdır. Eğer Component Ağacının Render süreleri 15ms'yi geçiyorsa AI Kodu Baştan YAZMALIDIR!
