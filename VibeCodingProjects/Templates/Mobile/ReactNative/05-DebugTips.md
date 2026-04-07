# 5️⃣ React Native - Debug, Native Cihaz Çökmeleri ve Bellek Sızıntısı Raporlaması

> **ZORUNLU STANDART:** Web geliştirmeden mobil'e geçenlerin EN ÇOK YAŞADIĞI FELAKET: Uygulama Local (Geliştirme) modda Akar, 60 FPS çalışır, Aşıksınızdır (Develop Mode JS Core). Ancak Uygulamayı Release Moda (APK/IPA Çıktısı - Hermes Engine) alıp Cihaza kurarsınız Uygulama Açıldığı An Siyah Ekran Verir Ve Kapanir! Otonom yapay zeka bu felaketi Nedenleriyle Önlemek Zorundadır!

---

## 🚫 1. Production Crashes (Cihaz Patlama Hataları)

Metro Bundler arkada hata Gizler. Cihaz Saff'tır Affetmez.

1. ❌ **React Native Image ve URI Hataları:**
   ```tsx
   // FELAKET - Eğer Image adresi Null gelirse veya yanlış gelirse Cihazda UYGULAMA DİREKT ÇÖKER! (Kapanır)
   <Image source={{ uri: user.profilePhoto }} />
   ```
   *DOĞRUSU:* Otonom yapay zeka Bir Resmi Veritabanından (Dışardan) yükletiyorsa KESİN OLARAK `Fallback` Mekanizması kuracak veya (Tavsiye Edilen) **`expo-image`** Kütüphanesini Kullanacaktır! O kütüphane Cacheler, kırık resimde çökmesini (Crash) Engeller. `placeholder` gösterir!

2. ❌ **Obje ve Array Haritalamasında .map()'in Null Patlaması:**
   Web'de Console'a hata basar devam eder. Mobilde EKRAN BEMBEYAZ YADA KIRMIZI OLUR.
   *DOĞRUSU:* Otonom Zeka `data.map()` yerine Kesinlikle `data?.map()` (Optional Chaining) Zorunluluğu KOYMAK ZORUNDADIR. Gelen Data Array Değilse Tarayıcı Yıkılır Hata Affedilmez.

---

## 💥 2. Z-Index vs Elevation (Platformlar Arası Bozukluk)

Apple İle Android Aynı Evren Değildir. Otonom yapay zeka UI Cizerken 2 Cihazda da Test Ediyormus Gibi Kodlamazsa BİRİSİ BATAR.

1. ❌ **Sabit Shadow (Gölge) ve Z-Index Kullanımı:**
   ```css
   /* iOS'ta Süper Gölge verir Ama Android'te HİÇBİR ŞEY GÖSTERMEZ. (Bozukluk) */
   shadowColor: '#000', shadowOffset: {width: 0, height: 2}, shadowOpacity: 0.8, zIndex: 10
   ```
   *DOĞRUSU:* Otonom model Olarak, Componentin Z-Index'ini Cihazın Üstünde Tutmak İçin Android'in `elevation` Mekanizması MUTLAKA Yanına Eklenecektir! `elevation: 5`. (NativeWind className'lerinde bu otomatik Handle edilir: `shadow-md` İkisinide Uyarlar, Bu Yüzden Utility Css ŞARTTIR).

---

## 📊 3. Sentry ve İzleme Katmanı (Log Yönetimi)

Uygulamanız Apple Store'da 5.000 Kişi kullanıyor. 40 Kişi Login sayfasında Donuyor. (Crash Analytics Yoksa Göremezsiniz).

**Professional Mobile Log Kurgusu:**
Otonom Zeka `sentry-expo` VEYA `Crashlytics` Paketini App.tsx / _layout.tsx Kök Dosyasına İnjekte Etmek İle Görevlendirilebilir! (Mükemmeliyetçilik).
Bir Hata (Promise Unhandled vs) oluştuğunda Kullanıcıya "Üzgünüz Uygulamada bir Aksaklık var" Modal'ı Sessizce Açılır.

---

## 🚦 4. Geliştirici Ortamı İpuçları (Hermes Debugger)
* React Native JS Motorunu (Hermes) kullanılarak Proje Derlendiğinde, Otonom geliştirici `useEffect`'in İçinde Açtiğı bir `setInterval` i Component Ölürken Silmeyi UNUTURSA, O Kod Sonsuza Dec Arka Planda Cihazın Şarjını Yemeye (Battery Drain) Devam Eder.
* Cihaz Belleğinde "Otonom zeka" Memory Sızıntılarına Karşı SürekLi DOM Elementleri Kadar "Asenkron Fonksiyon İzolelerini" Titiz Yapmalıdır! Bütün Subscribe ve Timer'lar Return Fonksiyonuyla ÖLDÜRÜLECEKTİR!
