# 4️⃣ Flutter & Firebase - Katı Hiyerarşik Klasör Ağacı (Feature-Driven)

> **ZORUNLU DİZİLİM:** Mobilde state (Veri yönetimi) her yere dağılır (Push notification, App Lifecycle, UI State). 10+ sayfalık bir uygulamada klasik `lib/screens`, `lib/models` tarzı klasörleme tamamen "Spagetti Kod"a hizmet eder.
> Otonom model; kodu üretirken büyük ve sürdürülebilir **Feauture-Driven (Özellik Odaklı) Mimari** ağacını kullanmak ZORUNDADIR.

---

## 📂 En Kurumsal Yapı: Clean Architecture + Feature Modules

Tüm uygulama `lib/` dizini altında sadece 2 temel gruba bölünür: Uygulama Geneli (Core) ve Özellikler (Features). Otonom geliştirici bir sayfa yazarken, onun servisini de o sayfaya KOMSUDURACAKTIR.

```text
Flutter-Project/
├── android/                 # (Android spesifik build ayarları)
├── ios/                     # (iOS CocoaPods ayarları vb.)
├── lib/
│   ├── main.dart            # ProviderScope ve Theme bağlamalarının yapıldığı kök
│   │
│   ├── core/                # 🛠️ GLOBAL (EVRENSEL) KATMAN
│   │   ├── constants/       # MAGIC STRING YASAĞI, Bütün Color, Padding, API_URL burada
│   │   ├── exceptions/      # Proje geneli hata sınıfları (ServerException vb.)
│   │   ├── route/           # GoRouter tanımlamaları ve Route isimleri
│   │   ├── services/  (Ops) # Push Notification (FCM), Local Storage vb harici evrensel araçlar
│   │   ├── theme/           # ThemeData, Typography stilleri
│   │   ├── utils/           # Tarih formaterları, helper extension metodları
│   │   └── widgets/         # GLOBAL Atomic UI (Uygulamadaki her butonu MyCustomButton yapın)
│   │
│   └── features/            # 🚀 ODAK NOKTASI: UYGULAMA ÖZELLİKLERİ
│       ├── auth/
│       │   ├── data/                 # Veri Katmanı
│       │   │   ├── repositories/     # AuthRepository (Firebase çağrısı burada yapılır)
│       │   │   └── datasources/      # (Opsiyonel) Yerel/Uzak data ayrımı
│       │   │
│       │   ├── domain/               # İş / Nesne Katmanı
│       │   │   ├── models/           # UserModel (.fromJson nesneleri, Freezed)
│       │   │   └── usecases/         # (Eğer çok sert clean architecture isteniyorsa, LoginUseCase)
│       │   │
│       │   └── presentation/         # Arayüz ve State
│       │       ├── pages/            # LoginScreen.dart
│       │       ├── widgets/          # Login form elementleri (SADECE AUTH'A ÖZEL WIDGETLAR)
│       │       └── providers/        # Riverpod StateNotifierleri (Veya Bloc dosyaları)
│       │
│       ├── home/                # İkinci Bir Domain...
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │
│       └── profile/             # Başka Bir Domain...
│           ├── data/
│           ├── domain/
│           └── presentation/
│
├── .gitignore
├── pubspec.yaml             # SDK Sürümü, Font ve Kütüphanelerin Listesi
└── firebase.json            # FlutterFire config
```

---

## ⚠️ Kritik Mimari Kurallar (Mobile/Flutter Kalkanları)

1. **Parola ve Bağımlılık (Import) Kuralı:** Otonom model, `features/auth/presentation` altındaki bir sayfanın içinden `import 'package:app/features/profile/presentation/widgets/ProfileAvatar.dart'` GİBİ BİR YAZIM YAPAMAZ. İki Feature birbirine sunum katmanından (Widget olarak) bağlı kılınamaz. (Circular Dependency Hatası). Bir widget X ve Y özelliğinde ortaksa o Widget `core/widgets/` içine alınır.
2. **Kör Data Katmanı:** `features/auth/data` altındaki Firebase komutlarının yazdığı Repository.dart dosyasında, bir adet bile `package:flutter/material.dart` İMPORT EDİLEMEZ. Data katmanı Material UI veya BuildContext'i BİLEMEZ (Eğer bilirse Context Leak oluşur). Kırmızı Çizgidir.
3. **Sayfalar (Pages) Boş Olmalıdır:** `LoginScreen.dart` dosyasının Build içi sadece UI yapı taşlarını (Padding, Const, Column, SafeArea) dizmek içindir. Text Controller'ın validator formüllerini falan ayrı CustomWidgetlara çıkarabilir veya Service Helperlarına saklayabilirsiniz. Ne kadar az satır = O Kadar performans.
