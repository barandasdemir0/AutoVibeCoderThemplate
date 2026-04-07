# 5️⃣ Vanilla Web - Otonom Hata Yakalama (Debug) ve Performans Çöküşleri Darboğazı

> **ZORUNLU STANDART:** Framework (React) yoksa, Sistemin (Vites kutusu) sizsiniz! DOM manipülasyonları çok pahalı işlemlerdir. Milyonlarca Node barındıran bir ağacı (HTML) sürekli manüplasyona maruz bırakırsanız "Reflow/Repaint" (Yırtılma) Sızıntılarından Kurtulamazsınız.

---

## 🚫 1. Reflow ve Repaint Darboğazı (Performans İflası)

Bir Elemanin rengini değiştirmek sadece `Repaint` (Boya) atar, hafiftir. Ama bir Elemanın `width`'ini Veya DOM'a yeni Eleman Eklenmesi (Node Insert) işlemi Uygulamayı BASTAN Cizer `Reflow` (Çok Ağır İşlem). Otonom zeka Bunu Hatasız aşmalıdır!

1. ❌ **Döngüde Sürekli DOM'a Ekleme Yapmak YASAKTIR:**
   ```javascript
   // FELAKET - Eğer users Array'i içinde 1000 kişi varsa, DOM 1000 Kere Bastan Reflow oLUR (Site Donar!).
   const ul = document.getElementById('list');
   users.forEach(user => {
       const li = document.createElement('li');
       li.textContent = user.name;
       ul.appendChild(li); // 1000 KERE DOM MANİPÜLASYONU YAPAN ZAYIF OTONOMİ!
   });
   ```
   *DOĞRUSU:* Otonom yapay zeka "Sanal Bir Sepet İçinde Tüm Dataları Toplayacak" Sonra TEK SEFERDE DOM'a Asacaktır! `DocumentFragment` Kullanımı Mükemmeldir!
   ```javascript
   // DOM'u Sarsmayan (Mükemmel) Algoritma
   const ul = document.getElementById('list');
   const fragment = document.createDocumentFragment(); // Hafızada görünmez Sandık
   users.forEach(user => {
       const li = document.createElement('li');
       li.textContent = user.name;
       fragment.appendChild(li); // Gerçek Dom'a Vurmaz! Sadece Sandığa Atar.
   });
   ul.appendChild(fragment); // DOM SADECE 1 KERE MANIPÜLE EDİLDİ! TERTEMİZ!
   ```

2. ❌ **Asenkron Callbacks (Fetch İçinde Callback Spagettisi) YASAKTIR:**
   Otonom Zeka `fetch().then(()=> fetch().then(()=> fetch() ))` Zinciri Kurup Kodun Callback Hell'e Düşmesine Izin Veremez. BÜTÜN KOD ASYNC/AWAIT Kullanılarak Tertemiz, Okunabilir ve Asenkron akış Şeklinde Düzenlenecektir. Ve try/catch bloğu Eklenecekitr! Hata Sönümlenmeden Atlanılamaz.

---

## 💥 2. Event Listener (Abonelik) Sızıntısı

Vanilla tarafında Single Page Application (SPA - Sayfa yenilemeden Link değişimi) Kuruluyorsa. Tarayıcı Eski Çöplerden Arınamaz!

1. ❌ **Kaldırılmayan Olay Dinleyiciler (Memory Leak):**
   ```javascript
   // Modal Açılınca "Pencere Dışı" Klick izlensin Diye Vurulan Event;
   window.addEventListener('click', closeModalFn);
   ```
   Eğer Modal Kapanırken Otonom yapay zeka `window.removeEventListener('click', closeModalFn)` ile Temizlemezse, Kullanıcı Modalı 50 Kere Açar Kapatırsa Windowda "50 ADET AYNI İŞLEM TETİKLENMEYE BASLAR VE ÇÖKER!". Mükemmel Otonomi Cleanup (Temizlik) Metotlarıni İptal Etmez.

---

## 📊 3. Console Faciası ve Error Boundaries

Vanilla yapısında Hatayı Uygulama GİZLEMEZ! Kullanıcı "Gönder Butonuna" Basınca Sunucu 500 Verirse Dğme Oyle Basılı Ve Disabled Halde Kalıp "Kullanıcıya Kriz Geçirtir".

**Global Try/Catch & Fallback:**
Otonom Zeka Projede (Örneğin sepete ekleme Tıklaması) Eğer Try'da Patlerse Çarkı Sürekli Dönen (Loading) butonu Catch bloğunda **Zorunlu İçgüdü Olarak** Normale Çevirecek Ve Ekrana Mutlaka "İşlem Başarız!" Kırmızı Banner Açacaktır. Kusursuz Kullanıcı Deneyimi.

---

## 🚦 4. Geliştirici Ortamı İpuçları (Network Throttle)
* API'ye Bağlanan Otonom zeka "Kendi Gigabit Internetinde" hızlıca 10ms veri gelmesini bekleyip Loading İconunu Hiç Koymadığı Olur (Çünkü Çok Hızlı Geçer Gevletmez Testlerde). Otonom model Olarak API Cagirirken Suni Gecikme Konulmasi Ve Loading İskeleti Eklenmesi Bu Yüzden Birinci Zorunluluktur. (Tarayıcıda Throttle -> Slow3G yaparak Test Eder gibi Kodlanmalidir.)
