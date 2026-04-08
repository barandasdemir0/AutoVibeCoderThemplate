# 4️⃣ Vanilla Web - Kurumsal (Otonom) Klasör Hiyerarşisi

> **ZORUNLU DİZİLİM:** Çıplak bir (Frameworksüz) Web projesi üretiyorsanız Otonom AI Bütün Scriptleri ve Stilleri Dümdüz klasöre fırlatırsa 1 Ay Sonra O proje "Dokunanı Yakan" Spagetti Canavarına dönüşür. Otonom Klasör Yapısı (The Component Way) ile React Kalitesinde Proje Dizaynı Elde edilir!

---

## 📂 En Kurumsal Yapı: UI/Logic İzolasyon Modeli

Aşağıdaki yapı, Framework kullanmadan Dev Uygulamalara (SPA veya Multi-Page) Mükemmel bir Altyapı oluşturur.

```text
Vanilla-App/
├── index.html               # Uygulama Giriş HTML Dosyası (Sadece İskelet ve Zarf Taşır)
├── favicon.ico              # Zorunlu Web ikonu (404 basmaması İçin)
│
├── assets/                  # STATİK DOSYALAR
│   ├── images/              # bg.jpg, logo.png
│   └── fonts/               # Eğer Google font hariç local Font basılacaksa...
│
├── styles/                  # 🎨 CSS MİMARİSİ (BEM Standartlarına Göre Parçalanmış)
│   ├── main.css             # Root, Tüm Ana css'leri SADECE @import Eder (Derleyici Köprüsüdür!)
│   ├── base/               
│   │   ├── _reset.css       # Margin/Padding (box-sizing: border-box) Temizliği
│   │   └── _variables.css   # --primary-color: #f00 CSS Variable Theming!
│   ├── components/          # Gözüken Her Bileşenin Ayrılmış Sitili
│   │   ├── _card.css        # Sadece css: .card { ... } .card__title { ... }
│   │   ├── _button.css      # Sadece css: .btn { ... } .btn--primary { ... }
│   │   └── _navbar.css
│   └── layout/              # Genel Ekran Dağılımları
│       ├── _grid.css        # CSS Grid kalıpları (.row, .col-4)
│       └── _header.css
│
└── scripts/                 # 🚀 JS MİMARİSİ (ES6 MODULES - KESİN İZOLASYON)
    ├── app.js               # OTOYOL KÖPRÜSÜ (Tüm importların Init() Edildiği Dosya)
    │
    ├── config/              # UYGULAMA AYARLARI
    │   └── constants.js     # export const API_BASE_URL = "https://api.vibe.com" (HardCode Engeli!)
    │
    ├── services/            # DIŞ DÜNYA İLE İLETİŞİM
    │   ├── api.js           # API getJson() ve postJson() Wrapper Fonksiyonları
    │   └── storage.js       # LocalStorage setItem() Caching (Sepet saklama) Metodları
    │
    ├── ui/                  # EKRAN (DOM) ÇİZİM VE MANİPÜLASYONU
    │   ├── CardComponent.js # class Card { render(data) { return `<div...`} }
    │   ├── Modal.js         # Pop-up aç, kapat logiği (document.getElementById('modal').style...)
    │   └── Toast.js         # Hataları "Kullanıcıya Gösterme" UI Aracı (3 Saniye sonra silinen Div)
    │
    └── utils/               # YARDIMCI VE MATEMATİKSEL ARAÇLAR 
        ├── formatters.js    # export function formatCurrency(num) { return "$"+num }
        └── validators.js    # Form Regex (Email doğru mu) Karar Aracı (True/False Döner)
```

---

## ⚠️ Kritik Mimari Kurallar (Files Rulebook)

1. **`@import` Derleme Taktiği (CSS'in React'ı):** HTML dosyanıza gidip 15 Tane `<link rel="stylesheet">` etiketi ALT ALTA Eklemeyeceksiniz! (Ağ İsteği Çokluğu Tarayıcıyı Ağlatır). Otonom Model index.html içerisine SADECE `<link rel="stylesheet" href="styles/main.css">` koyacaktır. `main.css` dosyası içinden ise Bütün Diğer Ayrık CSS'ler `@import "base/_reset.css";` Şeklinde birleştirilecektir!
2. **Hard-Coded Metin Yasakları (Constants Klasörü):** Otonom Yapı Api İsteklerinde Fetch atarken veya Sayfa URL yönlendirmelerinde (Scriptin Ortalık yerlerinde) Elle `"https://amazon.com"` yazamaz! Bütün O "Sabit" Değişkenler `config/constants.js` dosyasında Tanımlanmalı ve Import edilerek Çağırılmak Zorundadır. Spagettiyi Yok Eden Hamledir!
3. **HTML DOM id Atama Zorunluluğu (Bağlantı Noktaları):** JS'in DOM'a erişmesi İçin, Otonom Model HTML etiketlerine `MÜKEMMEL SEÇİCİ ID` VEYA Data Attribute koymalıdır! `<div id="app-root">` gibi kökleri koymadan JavaScripte Componenti çizmeyi emredemezsiniz! JS bu Mühürler üzerinden HTML'e Sızar!
