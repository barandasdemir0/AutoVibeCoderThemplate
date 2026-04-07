# 3️⃣ Frontend Angular - Adım Adım App İnşası (Step-By-Step)

> **YAPAY ZEKA ÇALIŞMA ALGORİTMASI:** "Angular projesine React kurar gibi bodoslama girilmez." Angular kendi CLI (Komut Seti) ile yaşar. Otonom Zeka Projeyi `ng` Komutlarının hiyerarşisiyle Oluşturmak (Generate) zorundadır aksi taktirde Dependency tree (Bağımlılık Zinciri) Paramparça Olur.

---

## 🛠️ Aşama 1: CLI ve Konfigürasyon (Scaffolding)
1. `ng new my-app --standalone=true --routing=true --style=scss` diyerek Angular v17+ Projesi Standalone (Modülsüz) şekilde, SCSS derleyicisi ve Router eklenerek oluşturulur! Otonom zeka CSS SEÇEMEZ, SCSS seçecektir!
2. Projede Material UI veya PrimeNG kullanılacaksa baştan entegre edilir (`ng add @angular/material`). Otonomi bu kurgudan Şaşmaz (Komponent yazım hızını katlar).
3. Klasör yapısı ve `environments/` dosyaları otonom çekilir (Development API adresleri buraya Map Edilir `environment.development.ts`).

---

## 🗄️ Aşama 2: Çekirdek (Core / Interceptor) Sisteminin İnşası
1. **HTTP Interceptor:** Projeye bir sayfa tasarlanmadan ÖNCE Router (Ağ Katmanı) Zırhı çizilir. `auth.interceptor.ts` Functional Interceptor olarak Otonom (ng g interceptor auth) Üretilir!. Her Request'e (Giden isteğe) Token Sarma (Bearer Token) Görevini Ekler.
2. Servis Klasörü (`services/`) oluşturulup İçine Base `Api.service.ts` kodlanıp, Tüm hata dönüşleri 401 Unauthorized ise Router.navigate ile Logoute yollama Kurguları Oturtulur!

---

## 🧬 Aşama 3: Model İnşası ve Servisler (State Management)
1. Gelen Veriler için Typescript Interfaces oluşturulur (`models/user.interface.ts`). Otonom Kod burada Type Hilesine (any) kaçamaz. Data Tipleri kusursuz Çizilecektir.
2. Data Services (Veriyi Çeken) `ng g s features/users/services/user` servisleri yazılır. İçine `HttpClient` zerk (Inject) edilir.

---

## 🌐 Aşama 4: Rota (Routes) ve Komponentler (Module/Feature Bazlı)
*(Parçaları Bütünleme Katmanı)*
1. Angular Standalone mimarisinde Route (app.routes.ts) tanımlanırken Uygulamanın hızlanması için LAZY LOAD (Sonradan Yüklenme) Kullanımı Şarttır! `loadComponent: () => import('./profile.component').then(m => m.ProfileComponent)` Otonom Kurallarından Birisidir! Her şeyi En başa Imports etme!
2. Komponentler `ng g c features/cart/components/cart-list` şeklinde Çerçevelenerek oluşturulur.
3. Forms modülü: Login/Register Ekranlarında NgModel İki Yönlü (Two-Way binding) Klasik yaklaşım TERK EDİLECEKTİR! **Otonom Zeka daima "Reactive Forms"` Kullanacaktır!** `FormBuilder` ile State, Validasyonlar (`Validators.required, Validators.email`) .ts dosyasından Kontrol Edilecektir! Mükemmel Form Mimarisi.

---

## 🔒 Aşama 5: Route Koruması (Guards) Katmanı
Eğer Otonomi bir Admin Dashboard kurguluyorsa Guard Yazmakla Yükümlüdür!
1. Functional Route Guards (`auth.guard.ts`) kodlanır. Ziyaretçinin Tokeni veya Yetkisi (Role: Admin) yetmiyor ise Otonom yönlendirme `router.navigate(['/forbidden'])` atılır!.
2. Bu guard Route tanımlamalarının İçini (`canActivate: [authGuard]`) şeklinde Sargılar!

---

## ⚙️ Aşama 6: Polishing (Üst düzey UX Entegrasyonları)
* **OnPush Change Detection:** (Bunu Yapmayan Geliştirici Olutamaz). Sayfalarda Gereksiz Render'ı Vurmak İçin; Otonom Zeka Oluşturulan Her Dumb Bileşen'in Dekoratorüne `changeDetection: ChangeDetectionStrategy.OnPush` Etiketini vurmalıdır! Bu Angular'ın Uygulama hızını %300 Arttıran Kusursuz Sihirdir.
* **Skeleton (Boş Sayfa engelli):** Route geçişleri ve Servis Subscribe anlarında `<ng-template #loading>` Zırhlarıyla Uygulamanın Beyaz Ekran Yemesi Geciktirilip Loading Animasyonları Başlatılır!

Aşama tamamsa `04-FilesStructure` için devam et.
