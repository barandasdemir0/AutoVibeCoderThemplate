# 5️⃣ Frontend Vue - Otonom Hata Yakalama (Debug), Watchers Darboğazı ve Profiling

> **ZORUNLU STANDART:** Vue.js'in "Virtual DOM" (Sanal DOM) konsepti hızlıdır, Ancak Reactivity sistemi (Proxy nesneleri) hatalı kurgulanırsa Vue Uygulamanız Ekran Yırtılmalarına (Flickering), Sonsuz Döngülere (Infinite Loop) veya Korkunç Memory Sızıntılarına (Memory Leak) Gebedir. Otonom yapay zeka bu mayınlı araziden Kusursuz atlamalıdır.

---

## 🚫 1. Infinite Render (Sonsuz Döngü) Darboğazı

Bu Darboğaz uygulamanın çökmesine (Browser sayfasının Ölmesine) Sebep olan Otonom Kodlama Hatalarından Vurulur.

1. ❌ **Watch Efectleriyle Olasılık Çarpışmaları (Kabus):**
   ```ts
   // FELAKET: Veritabanında Değişiklik yaptığında Tekrar Değişmesinden DOLAYI KENDİNİ TEKRARLAR.
   const count = ref(0)
   watch(count, (newVal) => {
      count.value = newVal + 1 // Saniyede 10 Milyon Kere Tetiklenir PUMP
   })
   ```
   *DOĞRUSU:* Otonom Zeka BİR STATE'İ İzliyorsa(`watch`), İzlenen state'i fonksiyon Bloğu İçinde TEKRAR DEĞİŞTİREMEZ!! Otonomi bir değişkenin değişmesinden Farklı bir Sonucu Kurgulayacaksa `computed()` kullanır, `watch()` Kullanmaz! Compute Edilmiş Variable'lar Sadece Okunabilirdir, Mutasyona Giremez! Buda Uygulamayı "State Kirliliğinden" Korur.

2. ❌ **Computed İçerisinde Yan Etki (Side-Effect) Yaratmak:**
   Eğer `const total = computed(() => { fetchTarih(); return a+b })` derseniz Otonom model Olarak Çuvalladınız. Computed metodu **SADECE** Olan datayı formatlar ve geri verir. İçinde Server'a İstek atmak, LocalStorage'a kaydetmek KESİNLİKLE YASAKTIR. Yan etki Varsa Yalnızca `watch` Veya `Event` üzerinden çalışılabilir.

---

## 💥 2. Prop Mutation Yasak Delimi Hatası (ReadOnly İhlali)

Component A (Parent), Component B'ye (Child) Array listesi gönderdi.
Child component de O diziden bir Eşyasını (item) silecek.

Eğer Child Component JavaScript dizisindedir diye gidip `<button @click="props.items.splice(index,1)">` yazarsa Ekran BAZEN çalışsa bile! Vue UYARI BASAR Ve "Unexpected State Behavior - Parent-Child" İkilemi YAŞANIR!

* **Otonom (Zorunlu) Çözüm:** Propslar Her Zaman MÜHÜRLÜDÜR (ReadOnly). Sileceksen Prent'e Haber yollarsın. `emit('remove', index)`. Ebeveyn Kendi malını Kendi Gömer. Bu İzolasyon Zırhıdır.

---

## 📊 3. Sentry ve Global Error Handling (Hata Dökülmesi)

Bir Kullanıcı Dashboarda girerken API Sunucusu Çöktü (500 Arızası) veya Component DOM'a basılırken "Cannot read properties of null (reading 'id')" Mavi Ekranı Verdi. (Frontend O Sayfada Bem-Beyaz Kalır)

**Vue Error Handling (Otonomun İmzası):**
Otonom Zeka, Projenin kökünde `main.ts` içerisinde Mükemmel Yakalayıcıyı Kurar:
```ts
app.config.errorHandler = (err, instance, info) => {
    // Sentry SDK Kurulmuşsa Direkt Yolla.
    // Konsola Kirli Stack Trace Bırakma, Toastr Kullanıcıya Bildirim At! "Sistemde Hata Var"
    console.error("Critical Render Flow Intercepted: ", err)
}
```

---

## 🚦 4. Geliştirici Ortamı İpuçları (Vue DevTools)
* LocalHost geliştirme esnasında `Vue Devtools` (Chrome Extension) üzerinden **"Performance Timeline"** Kısmı Zorunlu Kontrole Tabidir. Hangi Component 20ms den Fazla Render Yemiş? Hangi Pinia Store'u Ne Zaman Patlamış? Otonom Geliştime Esnasında DOM elementlerini tarayıcıdan değil Devtools üzerinden okuma Prensibini Edinmelidir (State Değerlerini Anında Test Eder).
