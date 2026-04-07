# 1️⃣ Native Mobil (SwiftUI / Kotlin) - Otonom Planlama ve The Native Gerçeği

> **YAPAY ZEKA İÇİN KESİN KURAL:** Eğer bir proje React Native veya Flutter ile YAZILMIYORSA ve Native (Apple İçin Swift, Android İçin Kotlin) isteniyorsa; bu uygulamanın donanımla (Hardware, AR, Watch, Kamera) Ciddi bir Entegrasyonu veya 120 FPS "Pure Native" Mükemmelliyetçilik hedefi vardır. Otonom yapay zeka Native dünyada "Web gibi düşünmeyi Bırakmalı", İlgili Ekosistemin Zeki (Tipe-Duyarlı) Çatısına geçmelidir!

---

## 🎯 1. Çekirdek Felsefe: Declarative (Bildirimsel) Arayüz Geçişi

Tıpkı React'de olduğu gibi, Native dünya Eski tip (Storyboard/XML) arayüz dizilimlerini BİTİRMİŞTİR.
Otonom Zeka Projeyi yazarken ASLA UIKit (iOS) Veyahut XML Binding (Android) KULLANMAYACAKTIR!!. Gelecek Declarative'dir:
* **iOS (Apple):** Sadece `SwiftUI` Kullanılacaktır.
* **Android:** Sadece `Jetpack Compose` Kullanılacaktır.

### Mükemmel Otonom (Modern) Çizim:
```swift
// SwiftUI Örneği (Kusursuz Tasarım)
struct UserView: View {
    let user: User // Props mantığı
    
    var body: some View {
        VStack(spacing: 16) {
            Image(user.avatarUrl)
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
            
            Text(user.username)
                .font(.headline)
        }
        .padding()
    }
}
```

---

## 🔒 2. Data Flow (Veri Akışı) ve Mutabilty (Değişebilirlik)

Cihaz dilleri (Swift/Kotlin) Derlemeli dillerdir (Compiled). JavaScript gibi Esnek Değildir!. Bir Değişkeni `var` ile Çizersen, O Değişkeni View (Ekran) içerisinde `user.name = "Ali"` diye DEĞİŞTİREMEZSİN (Ekran Yenilenmez, Structlar Değişmez).

* **SwiftUI (State Yönetimi):** Otonom yapay zeka Sadece UI İçinde değişen Bir Veriyse (Örn: ModalAçıkMı) `@State` kullanır Kendi içinde tutar. Ama Veri Ebeveynden (Dışardan) geliyorsa veya Data Modelden geliyorsa `@Binding`, `@StateObject` veya `@EnvironmentObject` Kullanmak ZORUNDADIR!
* **Kotlin Compose (State):** Otonomi Bir veriyi İzlerken (Recomposition Atması İçin) `val count by remember { mutableStateOf(0) }` Sarkısını Cekmek ZORUNDADIR! Klasik Değişken Atarsan Ekran Render EDİLMEZ!!

---

## 🚀 3. Thread Yönetimi (Main vs Background)

Native Dünyanın en Yasaklı Katliamı: "Ağ (Network) İsteğini Main (UI) Thread'de Yapmaktır!!".

* Senkron Bir API İsteği `fetch()` Ekranda Çizim Yapan Thread'ı (Ana Otoyolu) kitlerse (O 1 Saniye Boyunca) Cihaz Dondu zannedilir! İşletim Sistemi UYARI Verip "Uygulama Yanıt Vermiyor (ANR)" diyerek App'i ÇÖKERTİR!
* **Otonom Zeka Çözümü:** 
  - **IOS İçin:** Asenkron Bloklar `Task { await fetchUsers() }` veya Grand Central Dispatch `DispatchQueue.main.async` kullanılır.
  - **Android İçin:** Kotlin Coroutines Kullanır Kilitleri Açar! `suspend fun` İle Ağ işlemleri (`Dispatchers.IO`) Üzerinden arka Plana Yollanır. Ekrana Çizerken Dönüşümler Süratle Yapılır!

Sırada İzolasyon kalkanı olan Architecture Katmanı (02) Vardır.
