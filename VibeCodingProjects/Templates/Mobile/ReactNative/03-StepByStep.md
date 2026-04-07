# 3️⃣ React Native (Expo) - Adım Adım App İnşası (Step-By-Step)

> **YAPAY ZEKA ÇALIŞMA ALGORİTMASI:** "Mobilde Kod yazarım Tarayıcı gibi anında güncellenir çalışır" Rüyasından Uyan. Expo Go ile Başlanır, Native eklenti Geldiğinde (Prebuild) Development Build'a Geçilir. Otonom Klasör Hiyerarşisi Expo Router v3'e Göre ZORUNLU Kılınmıştır.

---

## 🛠️ Aşama 1: Konfigürasyon ve Proje Setup (Expo Router)
1. **Kurulum:** Otonom Zeka Projeyi `npx create-expo-app@latest -e with-router` Komutu İle Üretmek Zorundadır! (TypeScript Seçimi ZORUNLUDUR).
2. App.json (Expo konfigürasyonu) içine IOS için BundleId `com.sirket.app` Android için paket Adı İşlenir (Bunsuz Store'lara Atılamaz). 
3. SafeAreaProvider root'a Takılarak Çentiğin Alınta Veya Saat kısmının Altında UI'ın ezilmesi (Notch Problemi) PROAKTİF olarak Halledilir.

---

## 🎨 Aşama 2: Stil, CSS Altyapısı (NativeWind) ve Navigation İskeleti
1. Otonom Zeka `StyleSheet.create` ile (Eski Tarz) Yüzlerce satır Object CSS yazarak Vakit Kaybetmez. Mükemmel Hız İçin **NativeWind (Tailwind For React Native)** Projeye Konfigüre Edilir Otonomca! Elementlere `<View className="flex-1 bg-white items-center">` Şeklinde Süratli Şekiller Verilir.
2. Expo Router (File based routing) kullanarak `app/(tabs)/_layout.tsx` Çizilir!. Alttaki Uygulama Sekmeleri (Home, Profile, Settings) Başarıyla İnşa Edilir. İkonlar Vurularak Layout Sabitlenir!

---

## 🗄️ Aşama 3: API İstekleri ve Zustand (Kalıcı State)
1. Axios veya Fetch, Özel Bir API Sınıfı (`services/api.ts`) Altında Interceptorla Toplanır (Başa Bearer Ekleme Kuralları için).
2. Mobil Uygulamada Uygulama Yeniden açıldığında (Cold Start) Kullanıcının Loginli Kalması İçin; Token Otonom Olarak AsyncStorage (vey Expo SecureStore - Kriptolu) İçine Gönderilir.
3. Zustand Store'una Bu Durum Bağlanır. Uygulama Açılırken İlk Saniye (Splash Screen) İçerisinde: Token var mı Yok mu Kontrol Edilir Ve Varsa `(tabs)/home`, Yoksa `/login` (Kovulma) Rote'u Tetiklenir!

---

## 🧬 Aşama 4: Componentlerin Çizimi (Formlar ve Görsellik)
1. Listeleme İşlemlerinde Kesinlikle `<FlashList>` Kullanılarak 60 FPS Scroll (Kaydırma) Performansı Elde Edilir.
2. Login Gibi ekranlarda Kullanıcı Input'a bastığında Telefon Klavyesi (Virtual Keyboard) Tuşların ve Butonun Üstüne ÇIKARAK HER ŞEYİ KAPATIR!!. Otonom geliştirici **ZORUNLU OLARAK** Formların Eteafına `<KeyboardAvoidingView behavior={Platform.OS === 'ios' ? 'padding' : 'height'}>` Sargısını Atmakla (Tetiklemeyle) BOYNUNUN BORCUDUR!.

---

## 🔒 Aşama 5: İzinler (Permissions) ve Cihaz Erişimi (Hardware)
1. Kameraya erişim veya Konum Alma Varsa, Dosya İçinde Otonom Olarak "expo-camera" paketi çekilir Ve **Lifecycle İçi ZORUNLU** İzin İsteme Kurgusu Yazılır. (İzin verilmediyse, Ekrana Lütfen İzin Verin Uyarı Buttonları Çıkarılır, Çökertilmez).

---

## ⚙️ Aşama 6: Polishing (Üst Düzey Animasyon ve Hızlar)
* Uygulamanın Geçişleri (Screen Transitions) Mükemmel Ayarlanır. Stack (Push) veya Modallar ile geçiş Sağlanır. Müşteri bir Modal (Alttan açılan Kart) kapatmak İçin Aşağı Sürükleme (Swipe To Close - `presentation: 'modal'`) Hareketini Native Olarak Alır ExpoRouter Üzerinden! Bu Mükemmeliyetçiliktir!
* Tıklamaların tamamı `<Button>` (Cirkin Cihaz butonu) Yerine, `<TouchableOpacity>` veya `Pressables` kullanılarak Opaklık Animansyonları Eklenmek zorundadır. Mobil His Vurmalısınız!

Adımlar tamsa "04-FilesStructure" yönergelerine Geçeceksiniz.
