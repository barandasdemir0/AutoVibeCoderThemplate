# 6️⃣ Frontend Angular - Mükemmeliyetçi Endüstri Standardı Ürünler (Ecosystem)

> Profesyonel, otonom bir AI sistemi Angular inşa ederken, Angular'ın güçlü Ekosistem Parçalarını projeye katmadan Geçemez. Vanilla Yazımları Otonomide Kabul Etmiyoruz. NPM Kütüphanelerinin "Framework Zırhlı" Sürümleri İşlenecektir.

---

## 📦 1. Kilit Taşı Endüstri Modülleri (ŞART Kütüphaneler)

### State Yönetimi (Store & Signals)
* **`@ngrx/signals` (SignalStore)**: Yıllar süren Redux Action/Reducer Zulmünü Tamamen Bitiren!, Vue/React benzeri ama Tip Güvenlikli (Angular v17+) Küresel State aracı. Projelerde Global Durum Yönetimi Varsa **KESİNLİKLE NvRx Signals Otonom Tarafından Kullanılacaktır!**. (Klasik @ngrx/store Yasaltır).
* **`rxjs`**: Angularin Kalbi'dir ancak Otonom Yapay Zekaa (Map, Filter, Tap, CatchError, exhaustMap, switchMap) Rxjs operatörlerini MÜKEMMEL KULLNMALIDIR. Aksi Halde Veri Akışı Race-Conditiona (Trafik Çarpışmasına Düşer).

### Form ve UX Kontrolleri
* **`ReactiveFormsModule` (Angular Dahili)**: Template Driven forms ([(ngModel)]) YASAKTIR. Sadece FormControl ve FormGroup Kullanılacaktır. Formların İç Yapıları Otonom tarafından Typescript (Controller) tarafında Test Edilebilir Hiyerarşide Çizilmelidir!
* **`@angular/material` VEYA `primeng`**: Otonom yapay zeka SCSS ile Dümdüz HTML'ler Baştan Yaratmak (Reinvent the Wheel) Yerine Material Design İskeleti (Date Picker vs) Kuracaktır.
* **`ngx-toastr` (Veya MatSnackBar)**: İşlemler Bittiğinde Kullanıcıya (Yeşil/Kırmızı) Bıldırımlar Otonom Olarak Fırlatilmalidir. Suskun Arayüz YASAKTIR.

### Optimizasyon ve Stil 
* **`tailwindcss`**: Angular + Tailwind Otonominin Birleşik Ruhu! CSS Sızıntılarını (Bleeding) Önleyen, Bütün Bileşenlerin Güzelliğini Standartlaştıran Yapı. Dümdüz css Kullanılmayacaktır.

---

## 📡 2. Yapay Zekaya (AI Agent'ına) İstem Formülleri

Aşağıdaki komut (Prompt) formülleri Otonom sistemi Dümdüz React (Her şeyi Function İçine gömen) Tarzından Arındırıp Katı Kurumsal Angular Component (Otonom) Formatına getiren bir tetikleyicidir:

> "Bir Angular Kategori Listesi Component'i Tasarla. **Zorunlu Kurallar:**
> 1. Component Standalone True Olacak, Template ve Styles Dosyaları Ayrılmayıp Tek bir .ts Dosyasında Inline Yazılacaktır. 
> 2. Veri İşlemi (Http Çağrısı) Component de Olmasın, Bana Onu Bir `CategoryService` Tarafından Sağla.
> 3. Listeyi View'daki HTML ye iteratöre Sokarken `*ngFor` Yerine Angular 17'nin Yeni Kontrol Bloğu (`@for(cat of categories; track cat.id)`) FORMATINI KULLAN! Ve Eski Nesil ChangeDetectionu iptal edip Componentin Başına OnPush Ekle!."

> "Uygulamanın Login Sürecine Otonom Bir Interceptor (InterceptorFn Olarak - Eski Class Olarak Değil!) Yaz. Localstoragedan Tokeni Alsın İsteklerin Headerına Koysun, Eğer Token Yok Veya 401 Unauthorized Dönerse Beni Login Route'una Fırlatan Logicleri de Koymayı Unutma."

---

## 🌍 Faydalı Kaynak Linkleri
* **[Angular.io / Angular.dev (Yeni Site)]**: Angular v17 ve v18+ İle Framework baştan yazıldığı için, Eski (Modüllü) Makaleleri okuyan Yapay Zeka Hatalara ve Uyumsuz Bağımlılık Ağaçlarına yol açar. Resmi Angular.dev Standalone Kuralları REFERANS VE ŞARTTIR.
* **[RxJS Marbles & Operator Guides]**: SwitchMap, MergeMap farkını yapamayan AI arama çubuğunda Asenkron Sorular soruldugunda Yanlış Sonuç Basar! Bu Otonominin Rehberidir.
