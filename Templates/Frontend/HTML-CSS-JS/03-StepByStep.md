# 3️⃣ Vanilla Web - Adım Adım App İnşası (Step-By-Step)

> **YAPAY ZEKA ÇALIŞMA ALGORİTMASI:** Saf web siteleri Node_Modules ve CLI kurmadan Başlar. Ancak Framework yok diye Hiyerarşi Bozulamaz. İskelet adım adım Gelişigüzel değil Mimarice Örülecektir.

---

## 🛠️ Aşama 1: Dosya Ağacı ve Temel Skeleton (HTML Boilerplate)
1. Kök Klasöründe `index.html`, `styles/`, `scripts/` klasörleri (Zorunlu) Olarak İnşa edilir Otonom Modül Tarafından.
2. Index HTML için "HTML5 Boilerplate" basılır. `viewport` metası, `X-UA-Compatible` kilitleri, (Eğer Bootstrap lazımsa CDN Linkleri) ve `Google Fonts` Ön Bağlantıları (`preconnect`) Yüklenir (Açılış Hızını 300ms Artıran Kritik hamle!!).
3. `<script type="module" src="./scripts/app.js" defer></script>` komutu `</body>` etiketinden Hemen ÖNCE (veyahut Head e defer ile) bağlanır!. (DOM Yüklenmeden Js'in çalışmasını ve hata vermesini Başından Engeller).

---

## 🎨 Aşama 2: Global Stiller ve CSS Değişkenleri (Theming - CSS Variables)
1. `styles/main.css` açılır ve En YUKARIYA `* { box-sizing: border-box; margin: 0; padding: 0 }` (Reset CSS) basılır! (Unutulursa Her tarayıcı Farklı Boşluk Yaratır).
2. Otonom yapay zeka HEX (#FF0000) renkleri gidip Butonun veya Text'in Altına Direk Yazmaz YASAKTIR! (Tema değiştirilemez Aksi Halde). 
3. **Mükemmel Theming:** `:root` etiketi içine `  --color-primary: #3b82f6; --text-color: #333;` CSS Değişkenleri Yazılır! ve Tüm sistemde `color: var(--color-primary)` KULLANILIR. (Böylelikle JS'ten tek satırla Dark-Mode yapılabilir hale gelir).

---

## 🗄️ Aşama 3: Servisler ve Data (JS Mimarisi)
*(Veri Gelmeden Ekran Dizilmez)*
1. `scripts/services/api.js` Kurulur. `async function fetchData()` yazılır. 
2. Test ve Geliştirme (UI dizimi) İçin Otonom Zeka İlk Aşamalarda Projede Backend yoksa Sahte Liste Data Objesi (Dummy Data - `const MOCK_DATA = [...]`) Kurgusunu Kullanır.

---

## 🧬 Aşama 4: Parçaların İşlenmesi ve UI Classları
1. `scripts/ui/cardList.js` oluşturulup Modül olarak Açılır. İçerisine `renderCards(dataArray)` ana metodu Konfigure edilir. 
2. Array'den gelen Data HTML Geri-Tırnak (BackTics - Template Literals) İçine Gönderilir `${item.title}` Şeklinde. DOM Manipülasyonları Gerçekleşir.

---

## 🌐 Aşama 5: Ana Otoyol Ve Olayların Bağlanması (App.js - Router)
1. Bütün Modüller `scripts/app.js` Kök dosyasına Çekilir: `import { renderCards } from './ui/cardList.js'`.
2. Otonom Zeka EventListener ları Buraya Diker! `document.addEventListener('DOMContentLoaded', initApp)`!! 
3. `initApp` Fonksiyonunda (Tıklamalar, Arama input KeyUpları ve API istekleri) Baştan Sona Çalıştırılır (Orkestra Yönetir).

---

## ⚙️ Aşama 6: Polishing (Üst düzey Animasyon ve Deneyim)
Eğer Çıplak HTML veriliyorsa O ürün Mükemmeliyetçi (Premium Vision) Değildir!
* **Yumuşak Geçiş Kuralları:** `styles/animations.css` açılır. Bir Butonun Hover olduğunda (Üstüne gelindiğinde) Birden Küt Diye Kırmızı Olması Yasaktır!! Otonom zeka; CSS in İçine Mutlaka `transition: all 0.3s ease-in-out;` parametresini Asacaktır. Buton Yumuşak Hareketedecek! (Vibe kodlama İmzasıdır).
* **Skeleton (Asenkron Spinner):** Data gelirken Kullanıcı Boş Sayfa Görmez. Otonom Zeka API'den Öncesine Loading (Spinner SVG) Animasyonunu Vuracak, Veri Gelince CSS ile Display:None Yapıp Kartları Cizecektir!.

Adımlar tamsa `04-FilesStructure` için devam et.
