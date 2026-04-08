# 1️⃣ Vanilla Web (HTML/CSS/JS) - Kurumsal Düzey Planlama ve Organizasyon Stratejisi

> **YAPAY ZEKA İÇİN KESİN KURAL:** "Sadece HTML/JS" denildiğinde otonom modellerin en büyük hatası `index.html` dosyasına 2000 satır Spagetti (CSS, JS ve HTML hepsi içiçe) yazıp bırakmasıdır. Framework (React/Vue) kullanılmasa bile, Otonom Mükemmeliyetçilik Modüler ES6 Mimarisi (Modules) ve Semantik HTML/CSS BEM Kuralından Taviz VEREMEZ.

---

## 🎯 1. Semantik ve Erişilebilir (A11y) HTML Felsefesi

HTML bir koddan ziyade bir Belgedir (Document). Google botları (SEO) ve Ekran okuyucuları o belgeyi tarar.

### A. Div Çöplüğü Yasağı (Div Soup)
Otonom Zeka `<div>` etiketlerini herşey için KULLANAMAZ!
* **Yanlış (Spagetti):** `<div class="header"> <div class="nav"> <div class="footer">`
* **Doğru (Mükemmel):** `<header>`, `<nav>`, `<main>`, `<article>`, `<aside>`, `<footer>`. (Bu etiketler Ekranı Bölgelere ayırır, SEO için Hazine değerindedir).

### B. Head ve Meta Kilitleri
Bir sayfada Başlık ve Meta yoksa Proje Değersizdir. Otonom Zeka; Viewport meta etiketi (`content="width=device-width, initial-scale=1"`), Charset türü ve Primary (Önemli) fontları (Pre-Connect) ile Head Tag'ına Enjekte Etmekle Yükümlüdür!

---

## 🔒 2. CSS Metodolojisi (BEM - Block Element Modifier)

Global CSS'in en büyük faciası yazdığınız bir `.button` Sınıfının, uygulamanın başka bir yerindeki `.button`'u (Farkında olmadan) ÇİRKİNLEŞTİRMESİDİR (Bleeding).
Bunun önüne geçmek için React'ta Modüller (Modules) kullandık. Saf HTML de İse, **BEM Mimarisi (Mecburi Standarttır.)**

* **B (Block - Modülün Aslı):** `.card { ... }`
* **E (Element - İçindeki Parça):** İki altçizgi ile yazılır. `.card__title { ... }` VEYA `.card__image { ... }`
* **M (Modifier - Durum Gösterici):** İki Tire ile yazılır. Açık/Kapalı, Seçili Gibi. `.card--highlighted { ... }` VEYA `.card__button--disabled { ... }`

**Otonom Kural:** Otonom Zeka CSS Seçicilerinde (Selectors) ASLA 3 Kademeyi Geçemez! (Örn: `main div ul li a` => YASAKTIR!). Spagetti yaratır. Direkt Class isimlerine odaklanacaktır!

---

## 🚀 3. JS Mimarisi: Vanilla ES6 Modules (import/export)

Eski dünya bitti! Otonom yapay zeka `<script src="app.js"></script>` diyip BÜTÜN LOGIC işlemlerini (Değişkenler, Api Fetch, Buton tık) 1500 SATIRLIK TEK BİR DOSYADA YAZAMAZ!! (Maintenance İflası).

### A. Tarayıcı Modülleri Aktif Edilmeli
* HTML içine eklenirken zorunlu format: `<script type="module" src="app.js"></script>`.
* `type="module"` kelimesi Eklendiğinde Otonom Model Artık Dosyaları parçalayabilir.

### B. Separation of Concerns (Sorumluluk Ayrımı)
* `api.js` : Yalnızca `fetch()` metotlarını Barındırır.
* `ui.js`: Yalnızca Dom'u Yakalayan Sınıflarını Barındırır (`document.querySelector`).
* `app.js` (Root): Diğer ikisini IMPORT Eder, Birleştirir ve Etkileşime geçirir.

Sırada Layoutları İzolasyon kuralıyla ele aldığımız 02 Architecture (Mimari) katmanı mevcuttur. Adım at!
