# ⚡ React Native (Expo) - OTONOM BEYİN (QUICK-START & MASTER RULES)

> **DİKKAT YAPAY ZEKA:** EĞER BU PROJEDE MOBİL UYGULAMA İÇİN `REACT NATIVE (EXPO)` KULLANIYORSAN, AŞAĞIDAKİ (60 FPS NATIVE) ENTERPRISE STANDARTLARINA %100 UYMAK ZORUNDASIN. BU BİR WEB SİTESİ DEĞİL (CSS YAZIP GEÇEMEZSİN). TELEFONLARIN PİLLERİNİ/RAM'LERİNİ BİTİREN PERFORMANSSIZ SPAGETTİLER ÜRETİRSEN İŞLEM İPTAL OLUR.

## 🚨 YASAKLAR LİSTESİ (ANTI-PATTERNS) - ASLA YAPMA!

1. ❌ **WEBTEN KALMA (DIV, P, SPAN) HTML ELEMENTLERİNİ KULLANMAK YASAKTIR:** 
   Otonom Zeka Projenin İçine React Web'den Esinlenerek `<div>` veya `<p>` YAZAMAZ (Anında Patlar!). Her Şey RN Katmanıdır: Kutu `<View>`, Yazı `<Text>`, Liste `<FlatList>`, Resim `<Image>` veya Buton İçin `<Pressable>` Olmak ZORUNDADIR!

2. ❌ **LİSTELERDE (SCROLL) DÖNGÜ (.MAP) İLE YIĞINMA YAPMAK KESİN YASAKTIR:** 
   Mobil ekranda 200 Öğelik veriyi `<ScrollView>` içinde `data.map(item => <View>)` Diyerek CİZEMEZSİN! (Cihazın Memory'sine Ağır basar FPS 10 a düşer, Scroll kilitlenir!).
   *DOĞRUSU:* Otonomi Kesin Olarak `<FlatList>` ve Optimizasyonunu (keyExtractor) YA DA (Gelişmiş Zeka Kullanıyorsa) `@shopify/flash-list` İle Render Performansını (Görünmeyen listleri RAM'den Silerak) Uygulamak Zorundadır!

3. ❌ **KLAVYELERDE INPUT EZME (KEYBOARD OVERLAP) YASAKTIR:** 
   Eğer Otonom AI; Gidip Sayfanın En Altına Login (Input) Vurduğunda ve Müşteri Inputa Tıkladığında OS Klavyesi O İnput'U Örtüyorsa ve KULLANICI NE YAZDIĞINI GÖREMİYORSA BU PROJE ÇÖPTÜR!
   *DOĞRUSU:* Bütün Input ve Form Düzlemine Otonomca `<KeyboardAvoidingView>` (Platform'a Uygun) ve `ScrollView` Eklenecektir, Klavye Zıplatması Handle Edileçek!!

4. ❌ **SABİT PİXELLER İLE TASARIM (HARDCODE DIMENSIONS) YASAKTIR:**
   Otonomi `width: 400` veya Top Padding Vururken Ekrana Göre Hesap Yapmadan 50 Px Yazıp GeçeMEZ! Müşteri 13 Inç Tabletle Girerse Bozuk Küçük Uygulama Görür. Bütün Boyutlandırmalar Flexible (`flex-1`) Ve `%` Veya Grid Olarak Otonom Tasarlanacaktır! Ekran Kenarına Yaslanan İçerik (SafeAreaView Eksikliği) PROJEYI YIKAR!

5. ❌ **GERİ (BACK) TUŞU UYGULAMAYI VAKİTSİZ KAPATAMAZ (NAVİGASYON KIRILMASI YASAKTIR):**
   Android cihazlardaki donanımsal geri tuşuna (Hardware Back Button) yanlış yanıt verilip kullanıcının bir önceki iç menüye gitmek yerine uygulamadan TOPTAN ATILMASI kesinlikle YASAKTIR. Root navigasyonda veya kilit form sayfalarında `BackHandler` API'sini (veya React Navigation donanım yönetimi kurgularını) kullanarak geri tuşunu intercept et. Gerekirse önce modalleri kapat, en son ana menüde onay iste.

6. ❌ **FIREBASE EKSİK ENTEGRASYONU YASAKTIR:**
   Uygulama Firebase'e bağlanıyorsa `google-services.json` (Android) ve `GoogleService-Info.plist` (iOS) kurulumlarının eksiksiz yapılması ve proje içindeki config/initialization adımlarının platform odaklı hatasız tamamlanması ZORUNLUDUR. Web ve mobil projeleri tek Firebase'de aynı veritabanını okuyabilmelidir.

---

## ✅ ZORUNLU MİMARİ YAPISI (N-TIER ENTERPRISE)

```text
/expo-project
 ├── /app               => SADECE ROUTERLAR (Sayfa URL Rotaları) VE İSKELETLER BURADA!
 ├── /src
 │    ├── /components      => (ÖRN: ui/) DUMB/GERI ZEKALI SADECE UI ÇİZEN BİLEŞENLER BURADA!
 │    ├── /services        => REST API FETCH İŞLEMLERİ () BURADA!
 │    ├── /stores          => ZUSTAND GLOBAL DURUMLAR (Eğer Theme ve Sepet lazımsa) BURADA!
 │    └── /constants       => TEMA RENKLERİ VE SABİT ENDPOINT STRINGLERI BURADA!
```

---

## 🛠️ BAŞLAMADAN ÖNCE BİLMEN GEREKEN İLK ADIM

Eğer User sana "Login Olan Ve Feed Listesi Olan Bir Mobil Uygulama Çıkar" dediyse dahi,
**BU DOSYA (QUICK-START)** seni bağlar. 

1. Setup Dosyalarını Expo Router (With Tabs) Hazırlayarat Root (Giriş) İsketini Kurgula. 
2. SafeAreaProvider'ı Ve Uygulama Layoutunu Tüm Uygulamanın İçine Oturt Cihaz Çentini Savun.
3. Api Girdilerin İçin (NativeWind - Tailwind Kullanarak) Estetik Mobile Native Cihaz Kartları Dök!. (Web Stili İğrenç Css Ler Yapma, Border-Radiusu Kullan Göşeleri Yumuşat!).
4. Eğer Gecikmeli Bir İşlem varsa Kesinlikle (Alert ve IndicatorLoading) Cihaz Componenti İle "Tarayıcı Bekliyor..." Ciz. Otonom Tepkimleri Kullanıcıya HISSETTİR!.

**REACT NATIVE (EXPO) KUSURSUZ MOBİL EKOSİSTEMİN DOMİNANT LİDERİDİR, ONUN TWEAKLARINI (İNCE AYARLARINI) VE FPS HASSASİYETİNİ UNUTMA! BAŞLAYABİLİRSİN!**
