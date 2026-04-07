# ⚡ Frontend Angular - OTONOM BEYİN (QUICK-START & MASTER RULES)

> **DİKKAT YAPAY ZEKA:** EĞER BU PROJEDE FRONTEND İÇİN `ANGULAR` ÇALIŞTIRIYORSAN, AŞAĞIDAKİ RXJS-TİPLİ KATI KURUMSAL ENTERPRISE STANDARTLARINA %100 UYMAK ZORUNDASIN. BU BİR SKRİPT DİLİ DEĞİL (ANY İLE DÖNEMEZSİN). TYPE GÜVENLİĞİ VE İZOLASYONSUZ (SPAGETTİ HMTL) BİR UYGULAMA ÜRETİRSEN İŞLEM İPTAL OLUR.

## 🚨 YASAKLAR LİSTESİ (ANTI-PATTERNS) - ASLA YAPMA!

1. ❌ **NG-MODULE (ESKİ ANGULAR) KULLANIMI YASAKTIR:** 
   Otonom Zeka `app.module.ts` yaratıp içine Yüzlerce komponent basamaz. Angular v14+ itibariyle Framework **Standalone** Component yapısına geçmiştir. Her Bileşen kendi importlarından Sorumlu olacak (`@Component({ standalone: true })`).

2. ❌ **VERİ ÇEKERKEN (API FETCH) PROMISE (ASYNC/AWAIT) VE AXIOS YASAKTIR:** 
   Otonom AI; API İsteklerini GİDİPTE FETCH yada AXIOS ile YAZAMAZ (Burası React Değil!). Angular'ın dahili Sınır-Kalkanlı (Testable) modülü Olan **`HttpClient`** enjekte edilecek ve Methodlardan MÜKEMMEL BİR STREAM (`Observable<T>`) Döndürülecektir! Veriler Boruhattından (Pipes - map, catchError) CIKAR!

3. ❌ **HTML (TEMPLATE) İÇERİSİNDE FONKSİYON, HESAPLAMA ÇAĞRIMI YASAKTIR:** 
   Change Detection (Değişim Tarayıcısı) Mimarisi gereği Sayfada Farenin Oynamasıyla bile Ekran YENİLENİR! Eger Siz HTML in İçine `{{ getTotalPrice(order.items) }}` diye Bir FONKSIYON GÖMERSENİZ Ekran Saniyede Binlerce Kez O fonksiyonu Tekrarlatır ve Tarayıcı Çöker! (CPU Tüketimi Nereye Ulaşıyor!)
   *DOĞRUSU:* Otonomi bu hesaplamaları Ya Typescript Modeline Mapleyecek Yada ZORUNLU İSE (Performanslı Cachlenen) `Custom Pipe` Yazacaktır!

4. ❌ **"ANY" TİPİ VERMEK VE STATE YÖNETİMİNDE "MEMORY LEAK" SIZINTILARI YASAKTIR:**
   Otonom AI Benden Component Kapansa dahi `this.service.subcribe()` ile Kayıtlı kalan, O yüzden Siteyi Gezdikce Ram'i Tüketen bir yapı sunamaz!! Ya Otonom RXJS Aboneliklerini (`takeUntilDestroyed` veya `OnDestroy`) Cikaracak Veya Ekranda HTML in ICINE (Async Pipe) `*ngIf="value$ | async"` basarak ANGULARIN BU TEMİZLİĞİ YÖNETMESİNİ SAĞLAYACAKTIR (Mecburi).

---

## ✅ ZORUNLU MİMARİ YAPISI (N-TIER ENTERPRISE)

```text
/angular-project/src/app
 ├── /core              => BİR BİLEŞENE AİT OLMAYAN (Interceptor, Guards, BaseServisler) BURADA!
 ├── /shared            => HER YERDE TEKRARLAYAN (Button, Pipes, Formatlama) BURADA!
 ├── /features          => 🚀 MÜTHİŞ İZOLASYON (Tüm Ürün, Login, Sipariş Sınırları) BURADA!
 │    ├── /login           => Components, Services ve Models kendi Folderinda Yasarlar.
 └── app.routes.ts      => UYGULAMA ZORUNLU OLARAK LAZY LOAD (LOAD-COMPONENT) ILE BAGLANIR!
```

---

## 🛠️ BAŞLAMADAN ÖNCE BİLMEN GEREKEN İLK ADIM

Eğer User sana "Login Paneli Ve Veri Listesi Yaz" dediyse dahi,
**BU DOSYA (QUICK-START)** seni bağlar. 

1. Başlangıçta Angular Standalone Projesini Kur ve SCSS/Tailwind ayarlarını Pürüzsüzleştir. 
2. Ağ İletişimi (HttpClient) İçin `auth.interceptor.ts` (InterceptorFn Olarak) Yaz! Giden İsteğin Üzerine Token Bindir! Yoksa Tüm Rest API lerde Kirlilik Yaratırsın!
3. Componentleri Yazarken `@for` ve `@if` Gibi ANGULAR 17'nin Gelişmiş Control Flow (Hızlı) İfadelerini Test Et (Eski NgFor ve NgIF leri Kullanacaksan Modülleri İthal Etmeyi Unutma!).
4. Ekranda Yavaş Render Olan Element Çizmeyeceksin, Tüm Bileşenlerinin Kafasına `changeDetection: ChangeDetectionStrategy.OnPush` Zırhını Kullan!!.

**ANGULAR ENTERPRISE (KURUMLARIN) BİRLEŞİK GÜCÜDÜR, KENDİ KURALLARINLA DEĞİL ONUN MİMARİSİYLE ÖLÇEKLEN. BAŞLAYABİLİRSİN!**
