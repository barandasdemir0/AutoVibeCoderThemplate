# 6️⃣ React Native - Native Endüstri Standart Modülleri (Ecosystem)

> Profesyonel, otonom bir AI sistemi ReactNative ile kod yazarken "Native Cihaz Yeteneklerini (Hardware)" JavaScript ile amele gibi yazarak çözmeye ugraşamaz! Mobil dünyada Animasyondan, Veritabanına (Storage) Kadar Piyasayı Yöneten Kilit paketler Vardır.

---

## 📦 1. Kilit Taşı Endüstri NPM Modülleri (ŞART Kütüphaneler)

### State Yönetimi & Veritabanı
* **`zustand`** (ZORUNLU): State yönetiminin En Mükemmel ve Performanslı Atasıdır. (Redux YASAK). Context API ile Cihaz FPS ini düşürez.
* **`react-native-mmkv`** (ZORUNLU): AsyncStorage TARIHE KARISMISTIR!. MMKV Tencent Tarafından yazılmış bir C++ Key-Value motorudur (AsyncStorage'dan 30 Kata Kadar Hızlıdır). ZUstand Persist'ine Data kaydedilirken Uygulamanın Telefonun Hafızasına Şimşek Hızında (Senkron) Data Dökmesi Bu Paketle Olmalıdır Otonom AI!!

### Navigasyon ve Ekran
* **`expo-router`**: Uygulamanın The Dosya Tabnlı Kalbidir, Stack ve Tab Yönlendirmesini React Web Çevikliğinde Yapar! Cihaz Native Modala çevirilerle Oturtur.
* **`react-native-safe-area-context`**: Telefonların Ekranındaki ZIRT PIRT (Çentik, Ada vb) Kesiklerin Arkasında Kodun Görünmesini Engelleyen MÜKEMMEL KORUYUCU ZIRHTIR. Uygulama İçi Paddingleri Hesaplar. 

### Stil & Animasyon & Veri Cekme
* **`nativewind` (Tailwind)**: Mükememmel Otonomi Tasarımın Aracıdır. Bileşenleri Class adlarıyla Süratli Cizer!.
* **`react-native-reanimated` (v3+)**: Otonom yapay Zeka Standart "Animated" Api'yi KULLANMAYACAK! JS Threadını Boğan Bir API yerine. Animasyonu Direkt Donanım Hızlandırıcı (UI Thread / Worklet) İle Ekrana Yansıtan Bu paketi Çekmelidir!.
* **`expo-image`**: Eski Image Componentini Bırak. İçerisinde Blur (Bulanıklık) Loading Efektleri, Caching (Önbelleğe Alma) Sistemleriyle Donatılmış Profesyonel Resim Çizicidir!

---

## 📡 2. Yapay Zekaya (AI Agent'ına) İstem Formülleri

Aşağıdaki komut (Prompt) formülleri Otonom sistemi Dümdüz React Web Geliştiricisi Kafasından Arındırıp, Kurumsal Mobile App Kafasına (FPS ve Native Zırhı) Formatına Atan Tetikleyicidir:

> "Bir Sepet Ekranı Listeleme Componenti Tasarla. **Zorunlu Kurallar:**
> 1. Kesinlikle `ScrollView` içinde Döngü (map) Kullanarak YAZMAYACAKSIN (Cihaz RAM'ini şişirir)! Shopify'ın `@shopify/flash-list` modülünü veya Native `<FlatList>` kullanarak Recycle Sistemi ile Otonom Çizimi Hallediceksin. Data Yokken `ListEmptyComponent` ile Mükemmel Ekran Dökeceksin.
> 2. CartItem Cizildiğinde Ekrana Soldan Sağa Kayarak Gelmeli (Reanimated v3 kullanarak `entering={FadeInLeft}` Animasyonu Ekleyeceksin).
> 3. Alttaki 'Ödeme Yap' Butonu Asla Telefonun Alt Barı Altında Ezilmemeli (SafeAreaView Insets'i kullanarak PaddingBottom uygulayacaksın)!"

> "Uygulamanın Login Paneli İçin Bir KeyboardAvoidingView Sarmalayıcısı Yap! Ama Lütfen Platform.OS kontrolü koy (IOS ise padding, android is height) ve Scroll Gerekirse Klavye Acılınca Input Yukarı Kalkıp Kendine Yol Açsın (TouchableWithoutFeedback ile Ekrana tiklaninca Klavyeyi Kapat `Keyboard.dismiss()`). Mükemmel UX Çıkar!. "

---

## 🌍 Faydalı Kaynak Linkleri
* **[Expo SDK Documentation]**: Native Modüllerle Cebelleşmeye Son! Camera, Location, MediaLibrary Gibi Tüm CIHAZ KOMUTLARININ Tek Paket Altında Ulaşılırlıgını GÖSTEREN Ai Otonaomi Başvuru Kılavuzu.
* **[React Native Directory]**: Mobilde Hangi Paket Native C++ İstiyor? Hangi paket Expo Destekliyor? Otonom ajan Paket secerken Kurulum İflasına Düşmemek İçin Expo Uyumlu (Compatible) Kontrolünü Buradan Süzmelidir!
