# 🚀 STARTER-BLUEPRINT (Native Java-Android)

> **ZORUNLU OKUMA:** Bu proje fiziksel starter kodu (hazır klasör mimarisi) SAĞLAMAZ. Otonom ajan projenin kök dizinine aşağıdaki iskeleti sıfırdan kurmakla YÜKÜMLÜDÜR.

AI geliştirici, yeni bir Java-Android projesi istendiğinde çalışma dizinine (root) tam olarak şu iskelet yapısını manuel olarak üretecektir:

```text
/app/build.gradle               <-- Retrofit, Glide, Room gibi bağımlılıkları buraya ekle
/app/src/main/AndroidManifest.xml <-- İnternet yetkilerini gir!
/app/src/main/java/com/example/app
  ├── /models
  │    └── (POJO Classları)
  ├── /controllers
  │    └── (Mantık Sınıfları)
  ├── /adapters
  │    └── (Liste Adapter'leri)
  ├── /network
  │    ├── ApiClient.java
  │    └── ApiService.java
  ├── /ui
  │    ├── MainActivity.java
  │    └── ...
  └── App.java                  <-- Application Sınıfı

/app/src/main/res
  ├── /layout
  │    ├── activity_main.xml
  │    └── item_design.xml
  ├── /values
  │    ├── colors.xml           <-- Premium Material 3 renkleri koy!
  │    ├── strings.xml          <-- Sabit metinler (i18n)
  │    └── themes.xml
```

**Başlangıç Emirleri (Initial Actions):**
1. Paket yapısını yukarıdaki gibi kur.
2. Basit bir MVC/Retrofit test iskeletini inşa et.
3. XML dosyalarını çirkin bırakmadan modern Padding ve Material Widget'larla zenginleştir.
