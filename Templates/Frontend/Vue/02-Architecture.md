# 2️⃣ Frontend Vue - Kusursuz Component Architecture (Composables ve İzole UI)

> **MİMARİ KURALI:** Eğer bir sayfada (`UserList.vue`) hem Axios/Fetch isteği, hem Listeleme Filtre matematiği, hem de HTML/Tailwind Tasarımı AYNI `<script setup>` Bloğundaysa (100 satırı aşmışsa) Otonom AI büyük bir HATA Yapıyordur. Parçalama ve Component Hiyerarşisi Kusursuz Kurulacaktır.

---

## 🏛️ 1. İş Mantığı Parçalanması (Composables - "useFunction")

Vue 3 Mimarisi React Hook'lara benzer ancak Component'in sürekli renderlanması Düşüncesinden sizi kurtarır.

### A. View Katmanı SADECE UI Gösterir (Aptal Katman)
Sayfa bileşeniniz (`.vue`) hiçbir şekilde uzun algoritmalar BARINDIRMAZ! Otonom zeka karmaşık logicleri ayrı bir TypeScript dosyasına çıkarır!

```vue
<!-- UserListView.vue -->
<script setup lang="ts">
import { useUsers } from '@/composables/useUsers'
import UserCard from '@/components/UserCard.vue'

// Bütün Server Awaitleri, Hata Yakalmaları, Loading Stateleri O Fonksiyonda Kapsüllendi (Encapsulated)
const { users, isLoading, error, fetchUsers } = useUsers()

fetchUsers() // Component başlarken Çek.
</script>

<template>
  <div v-if="isLoading">Yükleniyor...</div>
  <div v-else-if="error" class="text-red-500">{{ error }}</div>
  <div v-else class="grid grid-cols-3 gap-4">
      <UserCard v-for="user in users" :key="user.id" :user="user" />
  </div>
</template>
```

### B. Composable Katmanı (State'i ve Ağı Tutan Yer)
Otonom Yapay Zeka Component içine DB Yazmayı Bırakıp, İşi buraya Tüketmek Zorundadır!
```typescript
// composables/useUsers.ts
import { ref } from 'vue'
import { api } from '@/services/api' // Axios instance (Zorunlu)

export function useUsers() {
   const users = ref<User[]>([])
   const isLoading = ref(false)
   const error = ref<string|null>(null)

   const fetchUsers = async () => {
       isLoading.value = true
       error.value = null
       try {
           const response = await api.get('/users')
           users.value = response.data
       } catch(err) {
           error.value = "Kullanıcılar alınamadı!"
       } finally {
           isLoading.value = false
       }
   };

   return { users, isLoading, error, fetchUsers }
}
```

---

## 🏗️ 2. Veri Taşıyıcıları (Props) ve Alt Bileşen Olayları (Emits)

Ebeveyn bileşen (Ana Sayfa) çocuğuna Data'sını `:user="user"` diye Yollar. Bu Kural (One Way Data Flow - Tek Yönlü Akış) EZİLEMEZ.

* **Çocuk Veriyi Değiştiremez! (YASAK HATA):** Bir `UserCard` içine gelen Kullanıcının Adını Değiştirmek İsterse `props.user.name = "Ali"` diyemez!! Vue HATA FIRLATIR! Component Tıklamayı Anlar, `defineEmits(['updateUser'])` makrosu Eklemesi ile En Yukarıya "Güncelle" Olayını fırlatır! İşi (Data Sahibi Olan) Ebeveyn Halletmek zorundadır.

---

## 🚫 3. YASAKLI İŞLEMLER (Vue 3 Anti-Patterns)

Otonom model bir UI kodu üretirken şunları IHLAL EDEMEZ:

1. ❌ **V-IF ve V-FOR Aynı Tag Üzerinde Kullanılamaz:**
   ```html
   <!-- FELAKET - Vue'nin Render Loop'unu KİLİTLER VE LİNTER PATLAMASINA YOL AÇAR! -->
   <li v-for="user in users" v-if="user.isActive" :key="user.id">
   ```
   *DOĞRUSU:* Eğer sadece aktif kullanıcılar gösterilecekse, Otonom Model `<script setup>` içinde bir `computed(() => users.value.filter(...))` özelliği tanımlayacak Ve DÖNGÜYÜ Computation Üzerinden Döndürecektir. (Hem Süratli hem hatasızdır).

2. ❌ **Key Olarak V-FOR İçinde İndex Vurulması Yasaktır (`:key="index"`):**
   Aynı Reactaki gibi, Vue component leri de Yeniden Sıralandığında (Sort) Cache Mekanizması Index üzerinden Bozulup Inputları Karıştırır. KESİNLİKLE Db'den gelen orijinal `user.id` vb Vurulacaktır.

3. ❌ **Global CSS (Scoped Unutmak):**
   Bir Vue Componentinde `<style>` etiketi açıp Scoped takısını (`<style scoped>`) UNUTURSANIZ, Orada yazdığınız `h1 { color: red }` kodu, Uygulamanın Başka Bir Sayfasında dahi H1'leri Kırmızı Yapar! Stilleri Komponente hapsetmek Otonomi İçin Şarttır!
