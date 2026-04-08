# 🌍 Uygulama Dil Desteği ve i18n Best Practice'leri (Top 15 Google Play Pazarı)

Uygulamanın çok dilli (i18n/localization) altyapısını kurarken, Google Play'de en fazla alışveriş yapan ve gelir getiren ilk 15 ülke baz alınarak aşağıdaki dillerin sisteme eklenmesi zorunludur:

1. **İngilizce** (`en`) - ABD, İngiltere, Kanada vb. (Varsayılan genel dil ve Fallback)
2. **Japonca** (`ja`) - Japonya (En yüksek ARPU - kullanıcı başı gelir)
3. **Korece** (`ko`) - Güney Kore
4. **Almanca** (`de`) - Almanya, İsviçre
5. **Fransızca** (`fr`) - Fransa, Kanada
6. **İspanyolca** (`es`) - Meksika, İspanya, Latin Amerika
7. **Portekizce** (`pt` / `pt-BR`) - Brezilya (Çok yüksek hacim), Portekiz
8. **İtalyanca** (`it`) - İtalya
9. **Arapça** (`ar`) - Suudi Arabistan, BAE (RTL - Sağdan sola destek gerektirir)
10. **Geleneksel Çince** (`zh-TW` / `zh-HK`) - Tayvan, Hong Kong
11. **Türkçe** (`tr`) - Türkiye 
12. **Endonezce** (`id`) - Endonezya 
13. **Tayca** (`th`) - Tayland
14. **Hintçe** (`hi`) - Hindistan 
15. **Felemenkçe** (`nl`) - Hollanda 

---

### 🤖 Yapay Zeka (AI) Kurulum ve Mimari Talimatı (Best Practices):
Dilleri sadece projeye dosyalar halinde ekleyip geçme. Localization (i18n) mimarisini kurarken **endüstri standartlarına ve uygulama kalitesi için "Best Practice"lere (en iyi uygulamalar)** kesinlikle uygun bir yapı inşa et. Uygulaman gereken kurallar şunlardır:

#### 1. Kod Organizasyonu ve Key İsimlendirme Stratejisi
* Aygıt ekranında, UI (arayüz) içerisinde **ASLA hardcoded (sabit) string string'ler kullanma.** Tüm metinler çeviri dosyasından gelmeli.
* Çeviri anahtarlarını (key'leri) modüler ve hiyerarşik (Domain-Driven) olarak isimlendir. Örnek: `auth.login.buttonSubmit`, `home.welcomeMessage`. Düz, dağınık ve çorba olmuş isimlendirmelerden kaçın.

#### 2. Çoğul Ekleri, Cinsiyet ve Parametreler (Pluralization & Interpolation)
* Sadece basit metin eşleştirmeleri yapma. Değişken içeren metinlerde (Örn: `Hoş geldin, {name}!`) parametreli translation yapılarını kullan.
* Hedef dillerdeki çoğul durumları (0 kedi, 1 kedi, 5 kedi) dilin 'plural' kural setine göre düzgünce yönet (Zero, One, Other mantığıyla).

#### 3. Tarih, Saat, Para Birimi ve Sayı Formatları
* Sadece metinleri çevirmek yetmez. Ülkeye göre Tarih formatını (Örn: ABD için `AA/GG/YYYY`, TR için `GG.AA.YYYY`) ortamın locale'ine göre otomatik dönüştüren sistemleri (Flutter'da `intl` vb.) devreye al.
* Sayısal değerleri ve para birimlerini, uygulamanın çalıştığı bölgeye göre doğru ayıraç (nokta/virgül) formunda göster.

#### 4. Fallback (Yedek) Dil Mekanizması
* Sistemde bir anahtarın çevirisi (örneğin Tayca'da) unutulmuşsa, uygulama kesinlikle kırılmamalı veya "null / boş" string göstermemelidir. Fallback dilini **İngilizce (`en`)** olarak kur.

#### 5. Dinamik Dil Değiştirme (State Management) ve ZORUNLU UI BUTONU
* Kullanıcı ayarlar sayfasından dili değiştirdiğinde, uygulamanın kapatılıp tam kapatılmasına gerek kalmadan ekranın **anında (reactive olarak)** yeni dile geçişini sağlayacak state management altyapısını kur.
* 🚨 **KIRMIZI ÇİZGİ:** Projeye 'çoklu dil' (i18n) ekliyorsan, DİLİ GERÇEKTEN DEĞİŞTİREBİLMELERİ İÇİN arayüzün (UI) Header, AppBar veya Ayarlar kısmına çalışan bir **Dil Değiştirici Buton/Dropdown (Language Switcher UI)** koymak ZORUNDASIN. Kullanıcı manuel değiştiremedikten sonra kodun bir anlamı kalmaz!

#### 6. RTL (Sağdan Sola) Tam Desteği ve Responsive Layout
* Listede **Arapça (`ar`)** bulunduğu için uygulamanın RTL (Right-To-Left) desteği kritik standarttadır.
* Arayüzü tasarlarken veya kodlarken, sabit `left` ve `right` hizalamalarından (Padding/Margin dahil) uzak dur; bunun yerine `start` ve `end` (veya `leading/trailing`) terimlerini kullan. Bu sayede cihaz dili Arapça yapıldığında arayüz aynalanmış gibi sorunsuz tersine döner. Geri Dön okları gibi ikonların RTL durumunda ters yöne (Auto-directional) döndüğüne emin ol.
