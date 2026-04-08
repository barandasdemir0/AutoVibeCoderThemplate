# 04-FilesStructure (Kurumsal Paket ve Dizin Hiyerarşisi)

> **MİMARİ ZORUNLULUK:** Java gibi Object-Oriented (Nesne Yönelimli) bir ekosistemde "Her şeyi anadizine yığmak" spagetti kodun en berbat halidir ve projeyi direkt çöpe çevirir. Bir Otonom Geliştirici, kodlamaya geçmeden önce Java'nın Paket (Package) limitlerini Domain bazlı, S.O.L.I.D standartlarında aşağıdaki gibi keskin duvarlarla ayıracaktır! 

---

## 📂 Ana Gövde: Java Paket Yapısı (Package Structure)

Projenin paket ana giriş noktası `app/src/main/java/com/sirketadi/projectadi/` şeklindedir. Otonomi, klasör yaratırken "Katman Odaklı (Layer-first)" ya da kurumsal projelerde vizyon sahibi "Özellik Odaklı (Feature-first)" gruplama yapar.

Aşağıdaki şema Kurumsal Seviye Çekirdek şemasıdır:

```text
/java/com/sirketadi/projeadi
  │
  ├── App.java                      # Uygulama Başlangıç Noktası (Global Application Context, Crashytics init)
  │
  ├── /models                       # [Kalkan Bölgesi] Asla Context veya Logic barındıramaz
  │    ├── /dto                     # Network/API için POJO sınıfları (Örn: FetchUserResponse.java)
  │    └── /entities                # LocalDB (Room) için Tablo tanımları (Örn: UserEntity.java)
  │
  ├── /controllers                  # [Beyin Bölgesi] (veya presenters) UI isteklerini işler
  │    ├── /auth                    # Özellik bazlı gruplama örneği (LoginController.java)
  │    ├── /home                    # (DashboardController.java)
  │    └── /profile
  │
  ├── /network                      # [Köprü Bölgesi] Veri sağlayıcı dış dünya arabirimi
  │    ├── ApiClient.java           # Sıkı Singleton konfigüre edilmiş Retrofit Provider objesi
  │    ├── ApiService.java          # Dinamik Rotaların Interfaceler ile yazıldığı Endpoint deposu
  │    └── /interceptors            # Ağ güvenliği için Token ekleyen custom interceptor'lar
  │
  ├── /adapters                     # [Montaj Bölgesi] Veri ile Görüntüyü birleştiren kaslar
  │    ├── /recyclerview            # Müşteriye sunulacak listelerin adaptörleri (ProductListAdapter.java)
  │    └── /viewpager               # Swipe (Kaydırarak) geçilen menü yöneticileri
  │
  ├── /utils                        # [Yardımcı Bölge] Uygulamanın her yerinden kullanılan saf statik metotlar
  │    ├── Constants.java           # URL'ler, Sabit ID'ler, String keyleri
  │    ├── DateHelper.java          # Tarih format çeviricileri
  │    └── NetworkMonitor.java      # İnternet koptu mu tetikleyicisi
  │
  └── /ui                           # [Sunum Bölgesi] Sadece Ekrana Çizim (Rendering) yapar
       ├── /auth                    # Özelliğe göre ayrılmış UI yapıları
       │    ├── LoginActivity.java
       │    └── RegisterActivity.java
       └── /main                    
            ├── MainActivity.java
            └── HomeFragment.java
```

---

## 🎨 Android Kaynak (Resource) Yapısı ve İsimlendirme Kuralları

Otonom ajan `/res` (Resources) klasöründe çalışırken asla sistemsiz (rastgele/başıboş) isim veremez. Naming Convetion (İsimlendirme) sıkılığı hayati önem taşır.

```text
/app/src/main/res
  │
  ├── /layout                       # Tasarımların Yeri (Zorunlu Önek Standardı)
  │    ├── activity_main.xml        # Tüm activityler "activity_" ile başlar!
  │    ├── fragment_home.xml        # Tüm fragmentler "fragment_" ile başlar!
  │    ├── item_product_card.xml    # RecyclerView (Satır) öğeleri "item_" ile başlar!
  │    └── dialog_warning.xml       # Custom pop-uplar "dialog_" ile başlar!
  │
  ├── /values                       # Temalar, Ölçüler ve Dil Kasetleri (Amelelik yapılmaz!)
  │    ├── colors.xml               # Asla hardcoded "#FF0000" kullanılamaz, buradan id ile (R.color.error) çekilir.
  │    ├── dimens.xml               # Padding, TextSize ölçüleri (örn: <dimen name="padding_standard">16dp</dimen>)
  │    ├── strings.xml              # Hardcoded stringleri YASAKLAYAN çeviri kalesi!
  │    ├── strings.xml (tr)         # (Çoklu dil dizini)
  │    ├── themes.xml               # Ana Tema Dayanağı (Day mode)
  │    └── themes.xml (night)       # Dark Mode Desteği olmadan premium ürün çıkartılamaz!
  │
  ├── /drawable                     # Sabit assetler
  │    ├── ic_home_24dp.xml         # PNG YASAKTIR. Sadece XML (Vector) ikonlar kullanılır (Kayıpsız).
  │    └── bg_rounded_button.xml    # Şekiller (Shapes), gölgeler..
  │
  ├── /menu                         # Toolbar, Navigation Drawer ayarları
  │    └── bottom_nav_menu.xml      # (Örn: Home, Search, Profile iconlarını dizdiğimiz menüler)
  │
  ├── /font                         # Tipografi Kalesi
  │    └── inter_regular.ttf        # Uygulama iğrenç standart fontlar kullanmaz, Google Fonts entegre edilir.
  │
  └── /mipmap                       # Uygulama Logonun boy boy (L, MDPI, XHDPI vb.) boyutları sadece BURADA tutulur!
```

---

## 🚨 Kritik Kurallar ve Kapsülleme (Encapsulation) Yasakları

1. **`Context` Taşınması Yasaktır:** `ui` (Sunum Bölgesi) içerisindeki bir Sınıf (`LoginActivity.java`), kalkıp da kendi özel statüsü olan "Activity Object"i, `models` içerisine parametre olarak (method çağrısı ile) GEÇİREMEZ. `models` ve `utils` aptaldır (P.O.J.O), Context kullanacak kadar akıllı olamaz!
2. **Sabit Dosya (`Constants.java`) Mührü:** Yapay zeka HTTP çağrıları yaparken `"https://api.vibe.com/users"` diyerek direkt sınıfların ortasına string yazamaz. `Constants.BASE_URL` şekline çekilerek `utils` içinde statikleştirilmek ve Tek elden yönetilmek zorundadır.
3. **Memory Management İhlali:** `adapters` içerisine yeni class üretilirken ViewHolder kuralı statik (`static class`) olarak koyulmazsa, binlerce satırlık veri telefonun hafızasını dakikalar içinde tüketip sistemi çökertecektir. Yapı mimarisi, Sınırların ve İşlevlerin temizliği (Clean Separation) esasına %100 dayanacaktır.
