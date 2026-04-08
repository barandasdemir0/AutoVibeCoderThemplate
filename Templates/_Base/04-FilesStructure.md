# 📂 Files Structure

> Genel dosya yapısı şablonu. Projeye özel teknoloji şablonundaki yapıyı temel al.

---

## 🗂️ Genel Proje Ağacı

```
ProjectName/
├── src/              → Kaynak kod
│   ├── models/       → Domain modelleri
│   ├── services/     → İş mantığı
│   ├── data/         → Veri erişim
│   ├── controllers/  → API / Route handler
│   └── utils/        → Yardımcı fonksiyonlar
├── tests/            → Test dosyaları
├── config/           → Yapılandırma
├── docs/             → Dokümantasyon
├── public/           → Statik dosyalar (web)
├── assets/           → Görseller, fontlar (mobil)
└── README.md
```

---

## 📋 Dosya Oluşturma Sırası

| Sıra | Dosya/Klasör    | Bağımlılık |
|------|-----------------|------------|
| 1    | Config dosyaları | —          |
| 2    | Models          | —          |
| 3    | Data/Repository | Models     |
| 4    | Services        | Data       |
| 5    | Controllers     | Services   |
| 6    | Tests           | Tümü       |

---

## 📝 İsimlendirme Kuralları

| Tür        | Format       | Örnek            |
|------------|-------------|------------------|
| Dosya      | [Konvansiyon]| [örnek.ext]      |
| Klasör     | kebab-case   | `user-service`   |
| Sınıf      | PascalCase   | `UserService`    |
| Fonksiyon  | camelCase    | `getUser()`      |
| Sabit      | UPPER_SNAKE  | `MAX_RETRY`      |

> ⚠️ İsimlendirme kuralları teknolojiye göre değişir. Teknoloji şablonundaki kurallara uy.
