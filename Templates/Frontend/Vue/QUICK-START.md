# ⚡ Frontend Vue - OTONOM BEYİN (QUICK-START & MASTER RULES)

> **DİKKAT YAPAY ZEKA:** EĞER BU PROJEDE FRONTEND İÇİN `VUE.JS` ÇALIŞTIRIYORSAN, AŞAĞIDAKİ (VUE 3) ENTERPRISE STANDARTLARINA %100 UYMAK ZORUNDASIN. BU BİR SKRİPT DİLİ DEĞİL (ANY İLE DÖNEMEZSİN). TYPE GÜVENLİĞİ VE VUE 2 KALINTISI (ESKI OPTION) İCEREN BİR UYGULAMA ÜRETİRSEN İŞLEM İPTAL OLUR.

## 🚨 YASAKLAR LİSTESİ (ANTI-PATTERNS) - ASLA YAPMA!

1. ❌ **OPTIONS API KULLANIMI KESİN YASAKTIR:** 
   Otonom Zeka `export default { data() { return {} }, methods: {} }` Formatında KOD YAZAMAZ!! (Vue 3 Devrimi Yaşandı). Sadece ve Yalnızca `<script setup lang="ts">` Etiketi Açılarak MÜKEMMEL Composition Api Mimarisinde Kod Dökülecektir!

2. ❌ **PROPS MUTASYONU YASAKTIR (EBEVEYNİ EZECEK HAMLELER):** 
   Eğer Ana sayfadan (Parents) Gelen Array Listesini `props` Olarak Alırsan. O ARRAYIN ITEMLARINI CHİLD COMPONENTİN İÇİNDE `props.list.push(newItem)` İLE DEGİSTİREMEZSİN (UYGULUMA CRASH OLUR - WARNING PATLAR). Veriyi Yalnızca Getirirken Tüketebilirsin (ReadOnly). Değiştirmek İstersen `defineEmits` Kullanılarak Yukariya "YeniveriyiKoy" Haberi Salınacaktır.

3. ❌ **LOKAL İŞ KURALLARINI (COMPOSABLES OLMADAN) KOD İÇİNE SIKISTIRMA YASAKTIR:** 
   Eğer O Component Axios İle Post atılan, Fetch Atılan, Timer Calıstırılan (Sürekli Güncellenen Mantıklar) Barındırıyosa Bunlar Component İçine Alt alta 300 Satır YIĞILAMAZ! Componentin İşi Sadece (Return edilen Variableleri) Ekrana Basmaktır! Logik'ler Varsa Harici BIR DOSYAYA `useFetchData()` Şeklinde Extact(Deri Soyma) ile İzole Edilerk, Setup içine "Tertemizce" (Tek satır Import ile) Getirilecektir!

4. ❌ **ANY (TS) TİP KAÇAKLIĞI, VE GLOBAL CSS (SCOPED'SUZ) YASAKTIR:**
   Typescript ile Vue geliştirirken `<script setup>` İçinde Her Değişkene Veya Fonksiyon Girdisine Parametre Tipi Verilecektir `const activeUsers = ref<User[]>([]);`. Otonom Kod Ayrıca Bir Güzellik (Style/Css) Yazarken Style Etiketine `<style scoped>` yazmadan geçemez! Yoksa Yazdığı Düğme Rengi Yüzünden Sitenin Navbarı Bozulur!! Global Kirlilik Yasak!

---

## ✅ ZORUNLU MİMARİ YAPISI (N-TIER ENTERPRISE)

```text
/vue-project/src
 ├── /composables       => HER SAYFADA TEKRARLAYAN MANTIK (Ağ İstekleri Hooks) BURADA!
 ├── /components        => (ÖRN: ui/) DUMB/GERI ZEKALI SADECE UI ÇİZEN BİLEŞENLER BURADA!
 ├── /features          => 🚀 MÜTHİŞ İZOLASYON (Tüm Ürün, Login, Sipariş Sınırları) BURADA!
 │    ├── /login           => Components, Services, Views kendi Folderinda Yasarlar.
 ├── /stores            => PİNİA DURUMLARI (Vuex Ölümü) BURADA
 └── /router            => ROUTES (KAPIDA AUTH GUARD CHECK ATILARAK) BAGLANIR!
```

---

## 🛠️ BAŞLAMADAN ÖNCE BİLMEN GEREKEN İLK ADIM

Eğer User sana "Bir Admin paneli Gösterge (Dashboard) paneli Kur" dediyse dahi,
**BU DOSYA (QUICK-START)** seni bağlar. 

1. Setup Script `lang="ts"` ile Vue Componentini başlat. Tailwind Stillerini Kullan ve UI Güzelliğine Önem Ver!
2. `axios` Interceptorını Dosyala ve JWT Varsa Otomatik gidenlere yerleştir!. 
3. Componentini Asenkron data Çekecekse `await fetch()` dedirtiyorsan, O Layoutun (RouterView) kısmına `<Suspense>` Sargısı Göndermeyi UNUTMA! (Cünkü Vue Setupda Await demek Beklemek Demektir Beyaz Sayfa VERİR).
4. Saniyede Veya Harf Başına 1 İstek Atmak Yerine `@vueuse/core` Kutusunu Dahil Ederek Debounce, LocalStorage İsteklerini Zırhla MİMARİYİ UÇUR!!.

**VUE.JS COMPOSITION MİMARİSİ İLE "DÜZENİN VE ÇEVİKLİĞİN" ADRESİDİR. OPTIONS KÖHNELİĞİNE DÜŞME! BAŞLAYABİLİRSİN!**
