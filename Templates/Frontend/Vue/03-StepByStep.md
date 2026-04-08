# 3️⃣ Frontend Vue - Adım Adım App İnşası (Step-By-Step)

> **YAPAY ZEKA ÇALIŞMA ALGORİTMASI:** Bir Vue projesi Vite üzerinde hızla başlatılır Tıpkı Nuxt gibi. Fakat Router yapısı ve Pinia dükkanlarını en baştan yapılandırmazsanız projenin Ortasında (30 Sayfa Sonra) global objeleri Sayfalara bağlamak CİNNET Geçirtir.

---

## 🛠️ Aşama 1: Konfigürasyon ve Proje Setup (Vite)
1. **Kurulum:** Otonom Zeka `npm create vue@latest` tetikler ve özelliklerden (TypeScript, Vue Router, Pinia, ESLint, Prettier) KESİNLİKLE "Eveeet" diyerek tam techizatlı bir Boilerplate Alır.
2. `tsconfig.json` ayarlarında `"strict": true` açık kalır ve `@/*` alias tanımları `vite.config.ts`'te test Edererek yapılandırılır. Importlar Temiz Kalacaktır!
3. `main.ts` Dosyasına Pinia ve Router App.use() ile bağlanılır! App Ayağa Kalkar.

---

## 🎨 Aşama 2: Stil, CSS Altyapısı ve Layout İskeleti
1. Projeye hemen `TailwindCSS` (+ postcss, autoprefixer) kurulumu OTO tetikletilir. Ve `style.css`'in tepesine Tailwind Drictiveleri dizilir.
2. Sayfada `App.vue` içine gidilerek `<RouterView />` eklentisi Bir Kalıbın (Layout'un) İçine asılır.
3. `<Navbar />`, `<Sidebar />` Gibi ana Componentler `src/components/layout/` Adında Tasarlanıp `App.vue`'ya Yapıştırılır. Mimarinin Çatısı Dikildi!

---

## 🗄️ Aşama 3: API İstekleri (HTTP Client / Axios)
*(Vue fetchAPI kullanabilir fakat Enterprise'da Interceptor şarttır)*
1. `src/services/api.ts` açılır. Bir Axios instance oluşturulur `axios.create({ baseURL: 'api_url' })`.
2. Interceptor (Araya Girici) Eklenir!! Giden İsteklere JWT Token'ı LocalStorage'dan (veya Pinia'dan) okuyup Atar! Dönen Yanıtlarda İse EĞER 401 (Expire Error) ise Oto Logout tetikler. Bu Katman Frontendin Yıkılmaz Kalkanıdır, Her Fetch'de Elle yazmayacaksın.

---

## 🧬 Aşama 4: Router Koruması ve Sayfaların İnşası (Views)
1. Otonom yapay zeka Sayfaları `<template>` ile inşaa eder ( Örn `LoginView.vue`). Routing İşleminde Route Guard YAZMAKLA YÜKÜMLÜDÜR!!
   ```typescript
   // src/router/index.ts Koruması
   router.beforeEach((to, from, next) => {
       const authStore = useAuthStore() // Pinia State'i Okunur!
       if(to.meta.requiresAuth && !authStore.isAuthenticated) next('/login')
       else next()
   })
   ```
2. Tüm Componentler, Otonom Yapı tarafından (Vue 3 Standardı) `<script setup lang="ts">` Tag'ı ile kodlanacak.

---

## 🔒 Aşama 5: State Katmanı (Pinia Dükkanları)
1. Müşteri Sepeti (Cart) mi eklendi? Global Store (Pinia) `src/stores/cart.ts` Açılır! (Dumb Componentler yerine Sepet Verisi Burada Toplanır).
2. Otonom Yapay Zeka Pinia store'unu ESKIDE KALAN "Options" yontemi İle değil, YENİ "Setup" Yöntemi (Sanki Bir Hook gibi) Yazacaktır!
   ```typescript
   import { defineStore } from 'pinia'
   import { ref, computed } from 'vue'

   export const useCartStore = defineStore('cart', () => {
      const items = ref<Product[]>([]) // State
      const total = computed(() => items.value.length) // Getter
      function add(item: Product) { items.value.push(item) } // Action
      return { items, total, add }
   })
   ```

---

## ⚙️ Aşama 6: Polishing (Kalite Sanatı ve Suspense)
* Vue 3 Mimarisi, Arkası Gecikmeli Asenkron çalışan Bileşenlerde (Örn bir Composable İçinde Awatile Bekletilen) Ekran Beyaz Kalmasın diye `<Suspense>` Objesi Barındırır.
* Otonom geliştirici; Ekranda Tablo VEYA Grafik Çizerken Asenkron verinin Etrafına Layout tarafında `<Suspense><template #default>...<template #fallback><SkeletonLoader></Suspense>` YAZMAYI ŞART KOŞACAKTIR! O Yüzde Görülen Spinnerler Zoru Zoruna Değil, Native Vue Akışıyla Gelmelidir!

Mimaride mutabıksanız "04-FilesStructure" yönergelerindeki mükemmel ağaca geçiniz.
