# 6️⃣ Frontend Vue - Mükemmeliyetçi Altın Standart Paketleri (Ecosystem)

> Profesyonel, otonom bir AI sistemi Vue 3 projesi geliştirirken "Hepsini ben yaparım" ilkesinden uzaklaşmak ZORUNDADIR. Global çapta test edilmiş kurumsal Vue Ekosistem (NPM) pakedlerini uygulamanın çekirdeğine entegre etmek ZORUNLUDUR. Vanilla kod yazımları Mükemmeliyetçilikte yer almaz.

---

## 📦 1. Kilit Taşı Endüstri NPM Modülleri (ŞART Kütüphaneler)

### State Yönetimi & Temel Taşlar
* **`pinia`** (ZORUNLU): Vuex'i mezara Gömen, The %100 Typescript Destekli, Otonom ve Çok daha Anlaşılır (Hafif) Central State Manager Pakedi. Option API'dan Arınmış, Composition API Setup Modelindedir.
* **`vue-router`** (ZORUNLU): SPA sayfalarının Tek sayfa Yönlendirme (Single Page Yönlendirme) Mimarisi. Middleware Router Guard (Navigasiyon Koruması) buranın İçine Dikkatlice Örülmelidir.
* **`@vueuse/core`**: "Tekerleği yeniden İcat ETME!" kütüphanesi. Bir kullanıcının Fare Lokasyonu mu lazım? Veya LocalStorage'a senkron (Reaktif) İzleyici Mi lazım? Otonom AI gidip bunu kendi eliyle Native API ile Yazmaz! `import { useLocalStorage } from '@vueuse/core'` Kalıbını MÜKEMMEL KULLANIR! VueUse Vue 3 Mimarisi İçin bir Galiptir.

### Data Fetching (Gelişmiş Veri Çekimi)
* **`@tanstack/vue-query`** (ÖNERİLEN): Eğer Düz Axios kullanıp Sayfa her açıldığında Kullanıcıları 50 Defa Baştan Çekiyorsan Sen Otonom Değilsin. ReactQuery'nin Harika Ported hali! Veriyi Ön-Bellekte Tutar (Caching), Arka Planda Sessizce Yeniler (Stale-While-Revalidate). Componentlere Müthiş bir Darboğazdan Siyrilma Sağlar!
* **`axios`**: Standart Rest API Network istemcisi (Fetch yerine tercih edilir, Çünkü Request/Response Interceptor zırhını takabiliriz).

### UI Çerçeveleri & CSS Mimarisi
* **`tailwindcss`**: Otonom yapay zeka Bütün elementleri `src/assets/style.scss` ye yazarsa orada Devasa bir Şişman CSS Çöplüğü Doğar (Dead-code). Tailwind Utility-First mimarisi İle kod Bileşene Özel Ve Temiz Olarak Yırtılır. 
* **UI Kit `shadcn-vue` VEYA `primevue`**: "Admin/Dashboard sayfası Tasarla" Dendiğinde Dümdüz Input, Button elementleriyle Tasarlanmayacaktır! Kurumsal düzeyde Harika Select componentleri, Table'lar Barındıran Endustri standardı Elementlerin Otonom (Unstyled/Tailwind kurgusu) Eklenimi Sağlanmalıdır!

---

## 📡 2. Yapay Zekaya (AI Agent'ına) İstem Formülleri

Aşağıdaki İstem formülleri, Sistemi basit bir Hello World kafasından Çekerek Enterprise Vue kafasına Zorlayan Şablonlardır:

> "Kullanıcının Ürün Filtrelediği Bir Component Geliştir. **Zorunlu Kurallar:** 
> 1. Kesinlikle Seçilmiş Kategori veya Arama Kelimesi Filtrelerini Component içinde (ref ile) sakla ancak Bunları Sunucu Axiosuna (Yada TanStack Query'e) yollamayı unutma!.
> 2. Kodu Yaratırken ASLA Option API Kullanma. `<script setup lang="ts">` Taglarını Çak!.
> 3. Kullanıcı Girdiği Harfi Sunucuya Yollarken (Arama inputu) Her Harf Vurusunda Server'a İstek Tüketme! (VueUse'dan Mükemmel `useDebounceFn` Hook'unu İthal Et, 500ms Gecikme Ver).
> 4. Eğer Ürünler Bulanamazsa Skeleton/EmptyState Ekranları Dökmeyi Es Geçme."

> "Uygulamada bir ShoppingCart Composables kurgula. Dümdüz Vue Refleri Yazmak Yerine, Verinin Pinia Store'unda saklanmasını Sağla ki Profil Ekranında da Sepet Tutarını Gösterelim (Setup Store modeli ile Kodla). Typescript Interfacelerini (Tip Atamalarını) CartItem [] Formatıyla Unutmadan Dökülecek."

---

## 🌍 Faydalı Kaynak Linkleri
* **[Vue 3 Official Composition API Docs]**: `ref`, `reactive`, `watchEffect` üçlüsünün Doğasını ve Hangi Senaryolarda Hangisinin Tetikleneceğini (Event Loop Tipi) Anlatan, AI Kurgusunun Bir numaralı Mimari Manifestosu.
* **[VueUse Documentation]**: Otonomi Motorunun "Ben Uğraşmam Zaten Eklentisi Yazıldı" dediği Fonksiyonel Kütüphane Kitabı. Her türlü Web-API'ını (Bluetooth, Clipboard, GeoLocation) reaktif Değişkene Bindirir.
