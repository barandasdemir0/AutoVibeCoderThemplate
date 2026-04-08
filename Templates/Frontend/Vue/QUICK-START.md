## SEQUENCE-ENGINE v1 (ZORUNLU)
Bu template ile calisirken sirayi bozmak YASAK:
1) QUICK-START.md
2) 01-Planning.md
3) 02-Architecture.md
4) 03-StepByStep.md
5) 04-FilesStructure.md
6) 05-DebugTips.md
7) 06-Resources.md

Kural:
- Her dosyadan sonra 3-5 maddelik "cikarim ozeti" yaz.
- Ozeti yazmadan sonraki dosyaya gecme.
- 7 dosya tamamlanmadan kod uretimine baslama.
- Bu akisin detay standardi: Templates/_Universal/TEMPLATE-SEQUENCE-ENGINE.md

---
# ⚡ Frontend Vue - OTONOM BEYİN (QUICK-START & MASTER RULES)

> **DİKKAT YAPAY ZEKA:** EGER BU PROJEDE FRONTEND İÇİN `VUE.JS` CALISTIRIYORSAN, AGAgIDAKİ (VUE 3) ENTERPRISE STANDARTLARINA %100 UYMAK ZORUNDASIN. BU BİR SKRİPT DİLİ DEGİL (ANY İLE DÖNEMEZSİN). TYPE GÜVENLİGİ VE VUE 2 KALINTISI (ESKI OPTION) İCEREN BİR UYGULAMA ÜRETİRSEN İGLEM İPTAL OLUR.

## YASAKLAR LİSTESİ (ANTI-PATTERNS) - ASLA YAPMA!

1. ❌ **OPTIONS API KULLANIMI KESİN YASAKTIR:** 
   Otonom Zeka `export default { data() { return {} }, methods: {} }` Formatında KOD YAZAMAZ!! (Vue 3 Devrimi Yaşandı). Sadece ve Yalnızca `<script setup lang="ts">` Etiketi Açılarak MÜKEMMEL Composition Api Mimarisinde Kod Dökülecektir!

2. ❌ **PROPS MUTASYONU YASAKTIR (EBEVEYNİ EZECEK HAMLELER):** 
   Eğer Ana sayfadan (Parents) Gelen Array Listesini `props` Olarak Alırsan. O ARRAYIN ITEMLARINI CHİLD COMPONENTİN İÇİNDE `props.list.push(newItem)` İLE DEGİSTİREMEZSİN (UYGULUMA CRASH OLUR - WARNING PATLAR). Veriyi Yalnızca Getirirken Tüketebilirsin (ReadOnly). Değiştirmek İstersen `defineEmits` Kullanılarak Yukariya "YeniveriyiKoy" Haberi Salınacaktır.

3. ❌ **LOKAL İg KURALLARINI (COMPOSABLES OLMADAN) KOD İÇİNE SIKISTIRMA YASAKTIR:** 
   Eğer O Component Axios İle Post atılan, Fetch Atılan, Timer Calıstırılan (Sürekli Güncellenen Mantıklar) Barındırıyosa Bunlar Component İçine Alt alta 300 Satır YIGILAMAZ! Componentin İşi Sadece (Return edilen Variableleri) Ekrana Basmaktır! Logik'ler Varsa Harici BIR DOSYAYA `useFetchData()` geklinde Extact(Deri Soyma) ile İzole Edilerk, Setup içine "Tertemizce" (Tek satır Import ile) Getirilecektir!

4. ❌ **ANY (TS) TİP KAÇAKLIGI, VE GLOBAL CSS (SCOPED'SUZ) YASAKTIR:**
   Typescript ile Vue geliştirirken `<script setup>` İçinde Her Değişkene Veya Fonksiyon Girdisine Parametre Tipi Verilecektir `const activeUsers = ref<User[]>([]);`. Otonom Kod Ayrıca Bir Güzellik (Style/Css) Yazarken Style Etiketine `<style scoped>` yazmadan geçemez! Yoksa Yazdığı Düğme Rengi Yüzünden Sitenin Navbarı Bozulur!! Global Kirlilik Yasak!

---

## ✅ ZORUNLU MİMARİ YAPISI (N-TIER ENTERPRISE)

```text
/vue-project/src
 ├── /composables       => HER SAYFADA TEKRARLAYAN MANTIK (Ağ İstekleri Hooks) BURADA!
 ├── /components        => (ÖRN: ui/) DUMB/GERI ZEKALI SADECE UI ÇİZEN BİLEGENLER BURADA!
 ├── /features          => ?ci MÜTHİg İZOLASYON (Tüm Ürün, Login, Sipariş Sınırları) BURADA!
 │    ├── /login           => Components, Services, Views kendi Folderinda Yasarlar.
 ├── /stores            => PİNİA DURUMLARI (Vuex Ölümü) BURADA
 └── /router            => ROUTES (KAPIDA AUTH GUARD CHECK ATILARAK) BAGLANIR!
```

---

## BAGLAMADAN ÖNCE BİLMEN GEREKEN İLK ADIM

Eğer User sana "Bir Admin paneli Gösterge (Dashboard) paneli Kur" dediyse dahi,
**BU DOSYA (QUICK-START)** seni bağlar. 

1. Setup Script `lang="ts"` ile Vue Componentini başlat. Tailwind Stillerini Kullan ve UI Güzelliğine Önem Ver!
2. `axios` Interceptorını Dosyala ve JWT Varsa Otomatik gidenlere yerleştir!. 
3. Componentini Asenkron data Çekecekse `await fetch()` dedirtiyorsan, O Layoutun (RouterView) kısmına `<Suspense>` Sargısı Göndermeyi UNUTMA! (Cünkü Vue Setupda Await demek Beklemek Demektir Beyaz Sayfa VERİR).
4. Saniyede Veya Harf Başına 1 İstek Atmak Yerine `@vueuse/core` Kutusunu Dahil Ederek Debounce, LocalStorage İsteklerini Zırhla MİMARİYİ UÇUR!!.

**VUE.JS COMPOSITION MİMARİSİ İLE "DÜZENİN VE ÇEVİKLİGİN" ADRESİDİR. OPTIONS KÖHNELİGİNE DÜGME! BAGLAYABİLİRSİN!**

