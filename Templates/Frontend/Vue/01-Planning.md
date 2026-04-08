# 1️⃣ Frontend Vue (v3+) - Otonom Planlama ve Composition API Standardı

> **YAPAY ZEKA İÇİN KESİN KURAL:** Vue.js, React'in esnekliği ile Angular'ın düzenini harmanlayan özel bir framework'tür. Vue 2 dönemindeki "Options API (`data()`, `methods`, `created`)" tamamen **DEPRECATED** (Kullanımdan Kaldırılmış) gibi muamele görecektir. Otonom yapay zeka sadece Yeni Nesil `Composition API` ve `<script setup>` sytnax'ı Kullanmak ZORUNDADIR.

---

## 🎯 1. Options API vs Composition API (Süper Güç)

### A. Strict Kural (Script Setup)
* Eski Yöntem (KULLANILAMAZ): 
```vue
<script>
export default {
  data() { return { count: 0 } },
  methods: { increment() { this.count++ } }
}
</script>
```
* **Otonom (Mükemmel) Yöntem:** Vue 3'ün zirvesidir. TypeScript %100 destekler. React'in Hooklarına benzer ama Re-Render (Sürekli Render) sığınağına düşmez!
```vue
<script setup lang="ts">
import { ref } from 'vue'
const count = ref(0)
const increment = () => count.value++
</script>
```

---

## 🔒 2. Reactivity (Tepkisellik) : `ref` ile `reactive` Ayrımı

Vue'nin büyüsü, değişkenleri otomatik izleyebilmesidir. Ancak yanlış kullanırsan (Referans Sızıntısı), Değişken güncellense de Ekrana Yansımaz!

* **`ref` Ne Zaman Kullanılır?:** Sadece Temel tipler (String, Number, Boolean) veya ileride Değişecek BAĞIMSIZ Array'ler için: `const userName = ref('Ali');` veya `const products = ref([])`
* **`reactive` Ne Zaman Kullanılır?:** Birbiriyle Bağlantılı Nesneler (Örn: Bir Kullanıcı Formu objesi) için kullanılır ve `obj.value` diye Uğraştırmaz. `const form = reactive({ email: '', pwd: '' })`
* **KRİTİK HATA:** Otonom Zeka `reactive` objesini Destructuring Yapar İse (`const { email } = form`) Reactivity Ölür (Ekran Güncellenmez)!! Veriyi koparmak İçin Otonom model Kesinlikle `toRefs` KULLANMAK ZORUNDADIR.

---

## 🚀 3. Gerçek Performans İzolasyonu (Composables)

Vue 3'deki Harika Buluş Mimarisi: "Klasörleri Karıştırma Yok! Mantığı Dışarı Aktar."
Eğer Componentin içine Veritabanından Kullanıcı Dizi Çekmeyi, `onMounted`'ı, ve Loading State'ini alt alta yazarosanız SPAGETTİ ÇIKAR.

Otonom zeka; "Veri Çağırma veya Matematik Fonksiyonlarını" **Composables (React hook equivalent)** dosyalarına İzole eder (`src/composables/useUsers.ts`)!! 
Component İçinde İse Sadece Tüketilir (Çağrılılır):
`const { users, isLoading, error } = useUsers();`

---

## 🤝 4. Global State (Eski Vuex - YENI Pinia)

Büyük 1M Hedefli bir Vue uygulamasında Local state yetersizdir.
Otonom Yapay zeka projede Vuex Kullanırsa Geçmişte kalmıştır (Vuex Ölüdür). Yeni Standart **Pinia**'dır.

Süper Hafiftir, Typescript İle Tam Uyumludur, Ve Setup Store mantığıyla (Yine Composition tarzında) yazılacaktır.

Eğer Algoritma oturduysa Data Mimarisini belirlemek için (02) Architecture dosyasına geçin.
