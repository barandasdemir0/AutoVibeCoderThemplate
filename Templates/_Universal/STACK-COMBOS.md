# 🔗 STACK-COMBOS.md — Hangi Backend + Frontend + DB Kombinasyonu?

> Proje tipine, takım bilgisine ve ihtiyaca göre en uygun kombinasyonu seçin.

---

## 🏆 En İyi Kombinasyonlar (Best Practice)

### Enterprise / Kurumsal
| Backend | Frontend | DB | ORM | Ne Zaman? |
|---------|----------|----|-----|-----------|
| **.NET Web API** | **Angular** | SQL Server | EF Core | Büyük enterprise, finans, sağlık, kurumsal |
| **.NET Web API** | **React** | PostgreSQL | EF Core | Modern enterprise + hızlı UI |
| **Spring Boot** | **Angular** | PostgreSQL | JPA/Hibernate | Java ekosistemi, enterprise |

> 💡 **.NET + Angular** en yaygın enterprise combo'dur. İkisi de strongly-typed, DI native, büyük takımlara uygun.

### Startup / Modern
| Backend | Frontend | DB | ORM | Ne Zaman? |
|---------|----------|----|-----|-----------|
| **FastAPI** | **Vue/React** | PostgreSQL | SQLAlchemy | Python ekosistemi, ML entegrasyon |
| **Express** | **React** | MongoDB | Mongoose | MERN, hızlı prototip, startup |
| **Next.js** | (built-in) | PostgreSQL | Prisma | Tek proje, hızlı deploy, Vercel |

### PHP Ekosistemi
| Backend | Frontend | DB | ORM | Ne Zaman? |
|---------|----------|----|-----|-----------|
| **Laravel** | **Vue (Inertia)** | MySQL | Eloquent | PHP ekosistemi, monolith |
| **Laravel** | **React (API)** | PostgreSQL | Eloquent | Laravel + SPA ayrı |

### Mobile Backend
| Backend | Mobile | DB | Ne Zaman? |
|---------|--------|----|-----------|-
| **Firebase** | **Flutter** | Firestore | MVP, hızlı, gerçek zamanlı |
| **FastAPI** | **Flutter/RN** | PostgreSQL | Custom backend gerektiğinde |
| **.NET Web API** | **Kotlin/Swift** | SQL Server | Enterprise mobile |
| **Express** | **React Native** | MongoDB | JavaScript fullstack |

### ML/AI Backend
| Backend | Frontend | ML | Ne Zaman? |
|---------|----------|-----|-----------|
| **FastAPI** | **React** | PyTorch/TF | ML model serving |
| **FastAPI** | **Gradio** | HuggingFace | ML demo, prototip |
| **Flask** | **HTML/JS** | YOLO | Simple CV deploy |

---

## 🚫 YANLIŞ Kombinasyonlar (Kaçının)

| ❌ YAPMA | 📖 NEDEN |
|----------|---------|
| Django + Angular | Overkill, ikisi de full-featured |
| Spring Boot + Vue | Java + JS bağlam kayması, öğrenme yükü |
| Laravel + Angular | Enterprise Angular + basit Laravel uyumsuz |
| Firebase + SQL | Firebase → NoSQL, SQL beklemeyin |
| Express + SQL Server | Node.js ← → MSSQL zayıf ekosistem |

---

## 📊 Karar Ağacı

```
Projem ne?
├─ Web Uygulaması
│  ├─ Basit (blog, portfolio) → HTML-CSS-JS veya Next.js
│  ├─ Orta (CRUD, dashboard) → Django-React veya Laravel-Vue
│  ├─ Büyük (enterprise)
│  │  ├─ .NET ekosistemi → DotNet-Angular (kurumsal) veya DotNet-React (modern)
│  │  └─ Java ekosistemi → SpringBoot-Angular
│  └─ Real-time (chat, live) → Express-React + Socket.io
├─ Mobile
│  ├─ Cross-platform → Flutter (Firebase veya custom API)
│  ├─ iOS native → SwiftUI + FastAPI/Firebase
│  └─ Android native → Kotlin + FastAPI/Firebase
├─ ML/AI
│  ├─ Model eğitimi → PyTorch/TensorFlow (notebook)
│  ├─ CV (nesne tespiti) → YOLO + FastAPI
│  ├─ NLP → HuggingFace + FastAPI/Gradio
│  └─ Deploy → FastAPI + ONNX Runtime
└─ Full Stack (tek proje)
   └─ Next.js + Prisma + PostgreSQL
```
