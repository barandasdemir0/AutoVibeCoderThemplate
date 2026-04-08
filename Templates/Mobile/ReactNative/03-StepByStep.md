# 3️⃣ React Native - Adım Adım Kurulum ve Üretim Algoritması (Step By Step)

> **OTONOM EYLEM VE YÜRÜTME KILAVUZU:** React Native (Expo) projesi inşaa edilirken Yapay zeka ajanları (Otonom) aşağıdaki 15 Kritik Adımı "Harfiyen ve Sırasını Bozmadan" takip etmek mecburiyetindedir. Klasör yapılandırması yapılmadan Router kurmak veya Native paketleri eşitlemeden Component üretmek uygulamanın "Can't find variable" hatasıyla kırmızı ekranda kalmasına sebep olur.

---

## 🛠️ BÖLÜM 1: Çekirdek Kurulum ve Otonom Mimari İskeleti (Adım 1 - 4)

### Adım 1: Projenin Expo (Router) ile Ateşlenmesi
Otonom araç eski komutları unutur. Proje kökü, `npx create-expo-app@latest -e with-router` (veya güncel Expo Router şablonu) komutu etrafında tasarlanacaktır. Yükleme tamamlandıktan sonra gereksiz default "Welcome" ekranları temizlenir ve çekirdek (Root) yapı, sistemde Expo App dizinine (`app/`) mühürlenir.

### Adım 2: NativeWind (TailwindCSS) ve Temel UI Kütüphanelerinin Entegrasyonu
Klasik React Native `StyleSheet` yazımı, otonomi açısından binlerce satır kalabalık oluşturduğu için Terk edilmiştir. Zeka anında NativeWind (TailwindCSS'in RN versiyonu) entegrasyonu kurar:
* `babel.config.js` ve `tailwind.config.js` dosyaları platform (Mobil ekran birimleri) odaklı konfigüre edilir.
* Bu aşamada asla kod çizilmez, sadece UI kütüphaneleri (Zorunluysa Shadcn UI / NativeWind) çekirdek sisteme (dependencies) gömülür ve `npm install` tetiklenir.

### Adım 3: Çoklu Dil (i18n / Localization) Sisteminin Enjeksiyonu
Sistem sadece İngilizce değilse (Örn: TR, DE) hardcoded string kalmak YASAKTIR. `i18next` ve `react-i18next` kütüphaneleri dahil edilir. `/locales` (veya `/translations`) dizinine `en.json` ve `tr.json` eklenip İskelet Dil yapısı `main/layout`'a sarmalanır (Wrap edilir).

### Adım 4: Güçlü Dizin Ağacının Köklerinin Atılması
Ana klasörde `src/` klasörü üretilip içine `components/` (ui ve shared), `features/` (Özellik bazlı: auth, home, profile vb.), `hooks/` ve `store/` klasörleri fiziksel olarak açılır. "Eğer her dosya app/ (Router dizini) içinde durursa spagetti olur" prensibiyle mantık (`src/`) ve Rotasyon (`app/`) birbirinden kopartılır.

---

## 🧠 BÖLÜM 2: Veri Akışı, Ağlar ve Global State (Adım 5 - 8)

### Adım 5: Güvenli Ağ İstek Tünelleri (Axios & Interceptors)
React Native Fetch API yetersiz kalacağı için Otonom Sistem `Axios` kullanarak REST veya GraphQL ayarlarını yapar. Token yollamak veya gelen 401 Unauthenticated hatalarını savuşturup kullanıcıyı Logout (Çıkış) yapmak için `src/network/api.ts` içerisinde (Zorunlu) **Interceptor'lar** Kodlar. 

### Adım 6: TanStack Query (React Query) İle Veri Önbellekleme
Ekrana her gidip gelindiğinde 3 saniye loading beklemek, Mobilde projeyi çöp eder. Zeka, `axios` çağrılarını `TanStack Query (useQuery, useMutation)` hook'ları ile sarar. Veriler Stale Time ile önbellekte (Cache) tutulur, uygulama uçak kıvamında hızlanır (Offline destek başlar).

### Adım 7: Zustand State (Durum) Yöneticisinin Doğması
Proje Auth Token'larını veya "Kullanıcı Dark Mode mu seçti?" bilgilerini tutmak için `src/store/useBoundStore.ts` oluşturulur. AsyncStorage (Veya MMKV Database) ile Persist (Kalıcı) Middleware entegre edilerek, state'ler uygulamanın kalbine gömülür.

### Adım 8: Expo Router Deep Linking Analizi
Expo Router kurgulanırken `app/(tabs)` (Alt Menüler - Bottom Tabs) ve iç rotalar (Auth vs.) Stack dizilimine girilir. Bir arkadaş uygulamanızı paylaşmak için URL ("myapp://profile/12") gönderdiğinde Expo'nun bunu direk `/profile` a çekmesi için Rota ayarları netleştirilir.

---

## 🎨 BÖLÜM 3: Müşteri Yüzü (UI / UX), Component Çizimi ve İşleyiş (Adım 9 - 13)

### Adım 9: Universal (Core) Widget'ların Çizimi
Zeka spesifik ekranlar yapmadan önce Projenin Modüllerini oluşturur. Cihaz Karanlık moda geçtiğinde otomatik siyah olan (`className="dark:bg-slate-900"`) CustomButton'lar, Animasyonlu Inputlar `src/components/ui` içine stoklanır. UI'daki tutarlılık mühürlenir.

### Adım 10: Ekranların Otonom Şişirilmesi (Mounting)
Ekran klasörleri (Örn: `home.tsx`) çizilirken önce Data (Query) sorulur. Veri boş ise / yükleniyorsa bembeyaz ekran göstermek yerine mutlaka **Skeleton Loading** (React Native Skeleton Content Placeholder paketleri) gösterilir. Veri gelir gelmez Listeler (Performans için FLASTLIST Shopify) güncellenerek çizilir.

### Adım 11: Klavye Bindirmesi (Keyboard Behavior) Donanım Testleri
Login Formu kodluyorsan Keyboard çıkınca Inputlar görünmez kalmamalıdır! `KeyboardAvoidingView` ve `Platform.OS === 'ios' ? 'padding' : 'height'` ZORUNLU entegrasyonuyla klavyenin tepesine içerik itilir (Push edilir). 

### Adım 12: Kapsamlı Donanım İzinleri ve Manifest (Info.plist / AndroidManifest)
Zeka, Kamerayı, Lokasyonu açtırmak için `expo-location` ekler eklemez anında `app.json` dosyasına da bu iznin GEREKÇESİNİ açıklar ("Uygulamanız haritada gösterilmek için konuma ihtiyaç duyar"). Apple Store testine gönderildiğinde sırf bu string metni (Rationale) girilmediği için uygulama kalıcı red yemez.

### Adım 13: Cihaz Donanımı Tuş Savunması (Hardware Back Navigations)
Sadece Android cihazlarda olan "Gerçek Donanım Geri Tuşuna" basıldığında Eğer form dolduruluyorsa (kredi kartı ekranındaysa) uygulamanın kazara tümden kapanmasını engellemek için `BackHandler.addEventListener` (Veya useRouter ile sayfa engelleri) koruması ve uyarı pop-upları yerleştirilir.

---

## 🚀 BÖLÜM 4: Yayına Hazırlık ve Optimizasyon (Adım 14 - 15)

### Adım 14: Lint, Çöp Toplayıcı ve Dead Code (Ölü Kod) Elemesi
Ekranda sadece 1 kere kullanılan `console.log()` bırakmak RAM harcar (Production'da konsol dinlemek kötüdür). Zeka projenin tamamında kullanılmayan importları (`unused variables`) temizler ve Bundle (Paket) boyutunu inceltir.

### Adım 15: Over-The-Air Güncelleme Kodları ve Final (EAS) Sınavı
EAS (Expo Application Services) için `eas.json` yapısı oluşturulur. App ICON, SPLASH SCREEN (Yüklüyor logoları) `app.json` a gömülerek Release, Preview veya Development kanalları ayrıştırılır. Uygulama kusursuz otonom teslimata hazırdır. 
