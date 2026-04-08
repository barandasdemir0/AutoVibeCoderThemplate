# 🏗️ Architecture

> Teknolojiden bağımsız genel mimari şablon. Projeye özel desenleri burada belirle.

---

## 🧱 Mimari Desen

- **Seçilen:** [MVC / MVVM / MVT / Clean Architecture / Microservices / Layered / Monolith]
- **Neden:** [—]

---

## 📐 Katman Yapısı

```
Project/
├── Presentation/   → UI / API katmanı
├── Business/        → İş mantığı
├── DataAccess/      → Veri erişim
├── Models/          → Domain modelleri
└── Shared/          → Ortak yardımcılar
```

| Katman       | Sorumluluk                    |
|--------------|-------------------------------|
| Presentation | Kullanıcı arayüzü / API      |
| Business     | İş kuralları, validasyon      |
| DataAccess   | DB erişimi, repository        |
| Models       | Entity, DTO, Enum             |
| Shared       | Utility, constants, extension |

---

## 🔗 Katmanlar Arası İletişim

- Üst katman → Alt katmana bağımlı (ters bağımlılık yasak)
- Interface'ler üzerinden iletişim (loose coupling)
- Veri taşıma: DTO / ViewModel kullanılmalı

---

## 🎨 Tasarım Desenleri

| Desen                | Kullanım Yeri   |
|----------------------|-----------------|
| Repository Pattern   | DataAccess      |
| Dependency Injection | Tüm katmanlar   |
| Factory              | [—]             |
| Observer/Event       | [—]             |
| Strategy             | [—]             |

---

## 🔐 Güvenlik

- **Auth:** [JWT / Session / OAuth2 / API Key]
- **Authorization:** [Role / Policy / Permission]
- **Şifreleme:** [bcrypt / SHA256 / AES]

---

## 🗄️ Veritabanı

| Tablo      | Açıklama | İlişki      |
|------------|----------|-------------|
| [—]        | [—]      | [—]         |

---

> 💡 Mimari kararları erken al ama projeye esneklik bırak. SOLID / DRY / KISS prensiplerine uy.
