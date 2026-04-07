# 2️⃣ React Native - Component Mimarisi (Atomic & Performans Odaklı İzolasyon)

> **MİMARİ KURALI:** Eğer bir React Native Sayfasında (`HomeScreen.tsx`) Login kontrolü (Zustand/Context), Sunucudan Data Çekimi (Axios) ve Sayfanın Güzellik CSS (StyleSheet) Tasarımları Birlikte İSE o Kod ÇÖPTÜR.

---

## 🏛️ 1. Akıllı ve Aptal (Smart vs Dumb) Bileşen Kuralı

### A. Dumb Component (UI Atomları)
Otonom Zeka `src/components/ui/Button.tsx` yazdığında, Buton HİÇBİR AĞ ISTEGI (Fetch) Yapamaz, Kendi içinden Redux Okuyamaz (YASAKTIR!!). Sadece `<Pressable>` kullanarak Tıklandığını Dışarı (Ebeveyne) Yollar (`onPress`). UI Atomları State barındırmaz (Aptaldır).

```tsx
// DOĞRU DUMB COMPONENT
export const PrimaryButton = ({ title, onPress, disabled }) => (
   <Pressable 
      onPress={onPress} 
      disabled={disabled}
      style={[styles.btn, disabled && styles.btnDisabled]}>
      <Text style={styles.text}>{title}</Text>
   </Pressable>
);
```

### B. Smart Screen (Zeki Sayfalar)
`app/(tabs)/home.tsx` gibi Sayfalar (Containerlar) UI Çizmez!! Onlar Otonom Zekanın Trafik polisidir. API'den TanStack Query (veya Hooks) ile veriyi alır, Dumb (Atom) Componentinin içine Zerk Eder.

```tsx
// DOĞRU SMART COMPONENT (EKRAN - UI ÇİZİMİ MİNİMUM)
export default function HomeScreen() {
   const { data, isLoading } = useGetProducts(); // Veri Çekilir

   if(isLoading) return <LoadingSkeleton />; // UI Atoma Paslanır

   return <ProductList data={data} onPurchase={(id) => buyProduct(id)} />
}
```

---

## 🏗️ 2. Global State Yönetimi (Zustand & Context API Sınırları)

Mobil uygulamalarda Web'deki gibi Sayfa URL değiştiğinde (Reload atıp) hafıza TAZELENMEZ. Uygulama Kullanıcının RAM'inde Günlerce Arka planda Bırakılır.

* **Otonom Redux İptali:** Klasik Redux mobilde Aşırı "Boilerplate (Gereksiz Çok kod)" Ürettiği için Terk edilmiştir. 
* **Otonom Zeka Çözümü (Zustand):** Zustand Kurulup Uygulamada `Token`, `UserTheme (Dark/Light)` ve `Cart` (Sepet) Saklanılacaktır! (Zustand; React Context gibi Ekranın Tamamını Render Atmaya ZORLAMAZ, Müthiş Performanslıdır). Mükemmel Otonom yapı `Persist Middleware` Kullanarak AsyncStorage'a (Telefona) Kalıcı Olarak Veriyi Kilitler! (Sectiği tema telefonda kalır).

---

## 🚫 3. YASAKLI İŞLEMLER (React Native Anti-Patterns)

Otonom model bir UI kodu üretirken şunlardan SAKINACAKTIR:

1. ❌ **Inline Functions İn Render (Performans Katledici):**
   ```tsx
   // FELAKET - Her harf (onChange) basıldığında Buton FONKSİYONU BAŞTAN YARATILIR MEMORY DÖKER!
   <Button onPress={() => doSomething(user.id)} />
   ```
   *DOĞRUSU:* Eğer Fonksiyona Parametre Lazımsa Otonom yapay zeka Bunu Component Dışına Sarar veya `useCallback` Hook'u İçerisinde Mühürleyerek Bağımlılık (Dependency) dizisine bağlar!

2. ❌ **Gereksiz `<ScrollView>` Yasağı:**
   Bir Sayfanın Etrafına Ana Düzen Olsun Diye `ScrollView` Varamazsın! İçine `FlatList` Geldiginde Application "VirtualizedList: You have a large list that is slow to update" UYARISI ile Kıpkırmızı Patalar (Sayfa Scrollü ile Liste Scrollu içiçe girer, Tarayıcı/Cihaz Çöker). Otonom dizilim ZORUNLUDUR!

3. ❌ **Sayfa Bekletme Süresi (useEffect'lerde Ağır İş):**
   `useLayoutEffect` veya İlk `useEffect` içine Gidipte 5 mb'lik JSON parse Cagirirsan, Componentin Ekrana Gelmesi (Çizilmesi) 3 Saniye Süreceği İşin "Mavi Ekran (Takılma)" yaşatırsın! Ağır işlemler Ya Component çizildikten (setTimeout veya InteractionManager.runAfterInteractions) sonra Tetiklenir!!
