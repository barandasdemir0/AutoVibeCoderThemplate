# 1️⃣ React Native (Expo) - Kurumsal Mobile Planlama & Ölçeklenebilirlik

> **YAPAY ZEKA İÇİN KESİN KURAL:** React Native bir "Web Sitesini Küçültüp Ekrana Sığdırma" aracı DEĞİLDİR. Mobil dünya Web'den 10 Kat daha acımasızdır. Native (Yerel) performans kaybı, Hiyerarşik DOM çöküşleri ve Bridge/Re-render tıkanıklıkları (Jank) yaşamamak İçin Otonom Yapı PROJEYE EXPO EKO-SİSTEMİ (Expo Router) ile Başlamak ZORUNDADIR.

---

## 🎯 1. Çekirdek Altyapı: Bare Native Mi, Expo Mu?

Otonom zeka proje üretirken eski usül `npx react-native init` (Bare Workflow) KULLANMAYACAKTIR. React Native'in yaratıcısı Meta (Facebook) dahi artık yeni projelere Expo ile (Framework olarak) başlanmasını emretmektedir!

### Neden Expo (Otonomun Süper Silahı)?
* **File-Based Routing:** Tıpkı NextJS gibi Dosya Klasör isimlerinden (app/) Otomatik Navigasyon Yapar!. (React Navigation spagettisini Çöpe Atar).
* **EAS (Expo Application Services):** Native Modüller (`XCode` veya `Android Studio`) kurmaya gerek Kalmadan (Prebuild) ile Bulutta Build aldırabilir.
* **Over-The-Air (OTA) Updates:** Uygulama Apple Reddi Yemeden (Küçük Buglarda) Kullanıcının Uygulamasında Anında JS Güncellemesi Yapar!

---

## 🔒 2. Re-Render ve Thread Tıkanıklıkları (FPS Düşüşü Katliamı)

Browser (Web) yavaştır Ancak Hissedilmeyebilir. Mobil (60 FPS) ekranda bir Scroll yaparken JS Tıkanırsa Ekran "Takılır (Stuttering/Jank)".
Otonom Yapı, React Native'in `JS Thread` ve `UI Thread` şeklindeki İki Katmanlı (Köprü - Bridge mekanizmalı) Mimarisine Hakim Olacaktır!

* **Kural 1 (Animasyonlar):** Otonom Zeka JS içinden (setInterval ile) Animasyon yapamaz (JavaScript Threadni boğar). **Reanimated (v3)** kütüphanesini kullanarak animasyonlari "C++ & UI Thread" i Üzerine Atmayı BİLMEK ZORUNDADIR.
* **Kural 2 (FlatList):** Scroll View İçine Yüzlerce Element GÖMÜLEMEZ. Ekranda Liste çizerken Otonom Sistem Kesinlikle `FlashList` (Shopify) VEYA Optimize Edilmiş `<FlatList>` kullanarak Cihazın Ekranda Gözükmeyen Elemanları RAM'den (Recycle) Silmesini Temin Edecektir. Memory Yönetimi Şarttır.

---

## 🚀 3. Ekran Boyutları ve Geri Tuşu (Responsive & UX)

Mobil Telefonda "Klavye Açıldığında Inputun Ekrandan Dışarı Çıkması" veya Androiddeki Aşağı OK (Hardware Back Button)'a basıldığında Uygulamanın Ölesiye KAPANMASI otonomi sistemlerin klasik açığıdır!

Otonom model, Uygulamaları `<KeyboardAvoidingView>` Zırhı ile çizer Ve Android Geri Tuşunu İzlemek İçin (Routerın stack Navigation Geçmişini) Mükemmel Kullanarak Sayfa İçinde geri gidilmesini sağlar (Tepeden App Kapatmaz). Sayfalar (Dimensions) `useWindowDimensions()` hook'uyla Dinamik Hesaplanır. (Sabit `width: 400` vs IOS PRO MAX'te BOZUK GÖZÜKÜR!).

Sırada Optimizasyon kalkanları ve Katman dizilimi (02) var.
