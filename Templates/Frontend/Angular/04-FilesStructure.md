# 4️⃣ Frontend Angular - Kurumsal Standalone Klasör Hiyerarşisi

> **ZORUNLU DİZİLİM:** Angular'da 15 Yıllık "CoreModule, SharedModule" çilesi resmi olarak bitmiştir. Angular v14+ projelerinde Klasör mimarisi Artık "Domain/Feature" tabanlı, daha Reaktif ve Standalone Bileşenlerle (Modülsüz) organize Edilmek ZORUNDADIR. Otonom yapay zeka CLI kullanırken `ng g c {name} --standalone` üretimi yapar. Tıpkı React gibi Temiz bir kök yaratırız.

---

## 📂 En Kurumsal Yapı: `/src/app` Hiyerarşisi

Otonom model aşağıdaki Klasör Sınırlarını İhlal Edemez. Angular Klasör yapısı SIKI KONTROL gerektirir!

```text
Angular-App/
├── src/
│   ├── assets/              # Sadece İkonlar, Resimler, i18n JSON TERCÜMELERİ
│   ├── environments/        # environment.ts (Prod/Dev API ayarları ve Keyler)
│   ├── styles/              # Global css (veya _variables.scss, _mixins.scss)
│   │
│   ├── app/                 # 🚀 ÇEKİRDEK PROJE DOSYALARI
│   │   ├── app.component.ts # Root (Giriş) HTML'i - (<router-outlet>)
│   │   ├── app.config.ts    # Bütün Providerların Yığıldığı dosya (Eski app.module) !!ÇOK ÖNEMLİ!!
│   │   ├── app.routes.ts    # Uygulama Düzeyi Router Çizelgesi
│   │   │
│   │   ├── core/            # 🛡️ GÜVENLİK VE AYARLAR (Bir Kere Import Edilir, Her Yerde Çalışır)
│   │   │   ├── interceptors/# auth.interceptor.ts, error.interceptor.ts (Ağ Kalkanları)
│   │   │   ├── guards/      # auth.guard.ts, admin.guard.ts (Sayfa Kilitleri)
│   │   │   ├── services/    # api.service.ts, theme.service.ts (Evrensel Tekil Servisler - Singleton)
│   │   │   └── models/      # Uygulama Çapında User, ApiResponse interface tipleri!
│   │   │
│   │   ├── shared/          # 🧩 ORTAK BİLEŞENLER (Daha Fazla Domaini Olmayanlar)
│   │   │   ├── ui/          # Butonlar, Badge'ler, Inputlar (Dumb Components)
│   │   │   ├── pipes/       # DateFormatPipe, CurrencyPipe
│   │   │   └── directives/  # HasRoleDirective vb. HTML Kuralcıları
│   │   │
│   │   ├── layout/          # SAYFA İSKELETLERİ (Headers, Sidebar vs)
│   │   │   ├── auth-layout/ # Sadece Login Sayfalarında Çıkan İskelet
│   │   │   └── main-layout/ # Admin/Dashboard paneli ve Sidebar barındıran Kalıp
│   │   │
│   │   └── features/        # 🚀 ODAK NOKTASI: UYGULAMA DOMAIN'LERİ
│   │       ├── auth/                    # O Domain'e Ait Ne Varsa Orada!
│   │       │   ├── components/          # (login-form.component, register.component)
│   │       │   ├── pages/               # (auth-page.component - Container Component)
│   │       │   ├── services/            # (auth.service.ts - Yalnızca bu Klasöre Özel HTTP isteği)
│   │       │   ├── models/              # (LoginCredentials, Token tipleri)
│   │       │   └── auth.routes.ts       # OTONOM KURAL: Modülün İç Rotalaması Kendine Has Olmalıdır!
│   │       │
│   │       ├── products/                # İkinci Bir Domain...
│   │       │   ├── components/ 
│   │       │   ├── services/
│   │       │   └── store/               # Eğer o modüle özel State Varsa (NgRx Signal Store)
│   │       │
│   │       └── orders/                  # Başka Bir Domain...
│   │
│   ├── main.ts              # Uygulamanın Bootstrap (Ayağa Kalkış) Edildiği Saf TS dosyası
│   └── styles.scss          # Ana Stiller
│
├── angular.json             # CLI ayarları, Builder ve Eklentiler (Tailwind/Material vs)
├── tsconfig.json            # Otonom Modelin Strict Kontrolunu yapacağı (noImplicitAny) ayarları
└── package.json
```

---

## ⚠️ Kritik Mimari Kurallar (Files Rulebook)

1. **Standalone App Config Kuralı:** Otonom Zeka Projeye HttpClientModule veya RouterModule eklerken gidip eski Usul Module yapmaya ÇALIŞAMAZ. Artık Bunlar `providers: [provideHttpClient(withInterceptors([authInterceptor])), provideRouter(routes)]` Şeklinde Doğrudan `app.config.ts` İçinden Basılacaktır. Uygulamanın Köşeleri Keskinleşmiştir!
2. **Circular Dependency (Döngüsel İçe Aktarım) İflası:** Angular Derleyicisi (Ivy Compiler), Product Service'i Order Klasöründen, Order Service'ini Product Klasöründen karşılıklı Import ettiğiniz (Otonomun Dikkatsiz davrandığı) anda ÇÖKER (Derlenmez). İzolasyon kuralları nettir; Features klasörleri yatay düzlemde BİRBİRLERİNE KARIŞAMAZLAR! Eğer Karışması gereken bir data varsa Ya O Veri `core/services` klasöründe ortaklanır, Ya da `RxJS BehaviorSubject / Signal` aracılığı ile Pub-Sub (Sinyal dinleme) Yoluyla Tepeden izlenir!
3. **Yüksek Performans Uyarısı:** `features` altındaki her Sayfa (ProductList vb) Ana `app.routes.ts` içerisine DİREKT olarak Komponent İthali şeklinde (Import Component) bağlanamaz. Otonom kurgu Orada Kesinlikle (LoadComponent) yani LazyLoading kullanmak zorundadır (Tarayıcı performansına etki etmemesi için bundle'ları ayırır).
