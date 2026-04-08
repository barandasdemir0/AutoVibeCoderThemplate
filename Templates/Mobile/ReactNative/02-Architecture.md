# 2️⃣ React Native - Component Mimarisi (Atomic & Performans Odaklı İzolasyon)

> **MİMARİ KIRILMA UYARISI:** Bir Otonom veya insan, eğer bir React Native Ekran (Screen) sayfasının (`HomeScreen.tsx`) içine girip de Login kontrolü (Zustand/Context), Sunucudan Data Çekimi (Axios/useEffect), Sayfanın Güzellik CSS (StyleSheet) Tasarımları, Klavye dinleyicisi ve Form Doğrulama kodlarını BİRLİKTE (Art arda tek dosyada) YAZMIŞSA o Kod **Korkunç Bir ÇÖPTÜR**. Spagetti denir, refactor edilemez, test edilemez. Tüm katmanlar bıçak gibi ayrılmak zorundadır!

---

## 🏛️ 1. Akıllı ve Aptal (Smart vs Dumb) Bileşen Katı Kuralı

React dünyasının Altın Kuralı (Golden Rule) mobilde 10 kat daha mühimdir! Ekranın sürekli baştan çizilmesini (Re-render) engellemenin tek yolu sorumluluk ayırmaktır (Separation of Concerns).

### A. Dumb Component (Aptal UI Atomları/Molekülleri)
Otonom Zeka `src/components/ui/Button.tsx` (Veya TextField.tsx, Card.tsx) yazdığında, Bu bileşen (Component) HİÇBİR AĞ İSTEĞİ (Fetch/Axios) Yapamaz! Kendi içinden Redux veya Zustand Okuyamaz (Kesinlikle Yasaktır)! Sadece Ekrana çizim yapar ve ebeveyninden aldığı Props ları okur, `<Pressable>` kullanarak Tıklandığını Dışarı Ebeveyne Yollar (`onPress()`). 

```tsx
// ŞAHANE BİR DUMB COMPONENT (Sadece Çizer, Düşünmez)
import React, { memo } from 'react';
import { Pressable, Text, StyleSheet } from 'react-native';

interface Props {
  title: string;
  onPress: () => void;
  disabled?: boolean;
}

// Memory Tasarrufu için Otonomi React.memo() kullanır!
export const PrimaryButton = memo(({ title, onPress, disabled = false }: Props) => {
   return (
     <Pressable 
        onPress={onPress} 
        disabled={disabled}
        // iOS ve Android Opacity tıklama efekti (Feedback)
        style={({ pressed }) => [
           styles.btn, 
           disabled && styles.btnDisabled,
           pressed && styles.btnPressed
        ]}>
        <Text style={styles.text}>{title}</Text>
     </Pressable>
   );
});
```

### B. Smart Screen (Zeki Organizatör Sayfalar)
`app/(tabs)/home.tsx` gibi Tüm Ekranı kaplayan Layout'lar ve Page'ler (Smart Containerlar) Detaylı UI ÇİZMEZ!! Onlar Otonom Zekanın Trafik polisidir. API'den veriyi alır (Hooks vasıtasıyla), Yükleniyor durumunu kontrol eder, Dumb (Aptal) Componentinin içine veriyi Zerk (Inject) Eder.

```tsx
// DOĞRU SMART COMPONENT (Beyin burada, Beden (UI) dışarıda)
import { useGetProducts } from '@/hooks/queries/useGetProducts';
import { ProductList } from '@/components/lists/ProductList';

export default function HomeScreen() {
   // TanStack Query ile Data ve State otomatik yönetilir (Trafik polisi)
   const { data, isLoading, isError } = useGetProducts(); 

   if (isLoading) return <LoadingSkeleton />; // Ekrana Skeleton Componentini As!
   if (isError) return <ErrorView onRetry={...} />;

   // Dumb componente sadece veriyi PULLA (Fırlat)
   return <ProductList data={data} onPurchase={...} />;
}
```

---

## 🏗️ 2. Global State Yönetimi (Sınırlar ve Zincirleme Patlamalar)

Hafıza (RAM) mobil cihazlarda PC Web sürümündeki gibi sınırsız değildir. Uygulama Kullanıcının arka planında (Background) Günlerce Bırakılır. State patlaması Telefon kilitlenmesinin 1 numaralı nedenidir!

* **Otonom Redux (Toolkit) İptali:** Klasik Redux mobilde Aşırı "Boilerplate (Zorunlu Kurulum Kodu)" Ürettiği, `dispatch` ederken gereksiz re-render dalgalanmaları yarattığı için komünite tarafından Terk edilmektedir. (Sadece eski projelerin bakımında kullanılmaktadır).
* **Otonom Zeka Birincil Çözümü (Zustand):** Zustand Kurulup Uygulamada `Token (Auth)`, `UserTheme (Dark/Light)` ve `Cart (Sepet)` Saklanılacaktır! (Zustand; React Context gibi "Saramayı (Provider Wrapper)" tüm app'in En dışından yapıp küçücük bir bildirim değişse TÜM APPI RENDER ATMAYA ZORLAMAZ, Müthiş Performanslıdır. Sadece dinleyen (selector) obje render alır).
* **Kalıcı (Persist) Hafıza:** Mükemmel Otonom yapı (Sepet verisi silinmesin diye) `Persist Middleware` Kullanarak React Native'in `AsyncStorage`'ına Kalıcı Olarak Veriyi Kilitler! (Sectiği tema telefon kapatılıp açılsa bile orada kalır).

---

## 🚫 3. YASAKLI İŞLEMLER VE DARBOGAZLAR (React Native Anti-Patterns)

Yapay zeka sadece kod üreten değil, sistemin limitlerini koruyan bekçi köpeğidir. Bu yüzden şunlardan KESİNLİKLE SAKINACAKTIR:

1. **❌ Inline Functions İn Render (Performans Katledici ve Memory Sızıntısı):**
   ```tsx
   // FELAKET - Her Render'da (Ekranda değişiklikte) bu callback BAŞTAN YARATILIR MEMORY DÖKER!
   <PrimaryButton onPress={() => doSomething(user.id)} />
   ```
   *DOĞRUSU:* Eğer Fonksiyona Parametre Lazımsa Otonom yapay zeka Bunu Component Dışına Sarar veya `useCallback` Hook'u İçerisinde Mühürleyerek Bağımlılık (Dependency) dizisine sokar!

2. **❌ Zıplayan Listeler ve İçiçe Kaydırma Çökmeleri (VirtualizedList Warning):**
   Bir Sayfanın Etrafına "İçerik yukarıda kalsın" diye `ScrollView` koyup, Sonra o sayfanın içine Gidip `<FlatList>` GÖMEMEZSİN! Application anında konsolda "VirtualizedList: You have a large list that is slow to update" UYARISI ile Kıpkırmızı Uyarır. Liste Scrollü (kaydırma) ile Sayfa Scrollu içiçe girince sistem hangi ekseni kaydıracağına karar veremez ve Crash (Donma) yaşanır. Otonom ajan hiyerarşiyi (İç içe Flatlist vs) tasarlarken ZORUNLU dikkat edecektir!

3. **❌ Layout Tıkanıklıkları (InteractionManager İhlali):**
   Sayfa Ekrana Yüklenirken (Mount olurken), `useLayoutEffect` veya İlk `useEffect` içine Gidip de 10 MB'lik JSON verisini Parse edersen (veya SQLite Veritabanı sorgusu atarsan), Componentin Ekrana Gelmesi (Çizilmesi/Animation-in Transition) 3 Saniye Süreceği İçin Kullanıcıya "Takılma (Jank)" yaşatırsın! 
   *DOĞRUSU:* Ağır işlemler (Navigasyon animasyonları bitene kadar) Otonom zeka tarafından `InteractionManager.runAfterInteractions(() => { ... })` komutuna yollanır VEYA Background İplikçiklerine (Web workers for RN) havale edilir! 

Mimaride mutabıksanız "Adım Adım Geliştirme (Step by Step)" protokolüne geçiş yapılabilir. Otonom Model Mimariden Asla Ödün Vermez!
