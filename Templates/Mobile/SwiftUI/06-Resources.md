# 6️⃣ Apple SwiftUI - Endüstri Standartı Kaynak Göstergeleri (Otonom Referans)

> **OTONOM ARAŞTIRMA MÜHRÜ:** SwiftUI, iOS 13 ten İtibaren Sürekli yeni (Büyük) güncellemeler ALAN (Özellikle iOS 15 ve 16'da büyük API değişimleri) bir çerçevedir. Geçmişteki (UIKit Kalıntısı) Storyboard kurguları Veya Alamofire gibi devasa Kütüphanelere olan eski ihtiyaç tamamen Ortadan kalkmıştır. Otonom ajan, projeye Bir Üçüncü Parti (3rd Party SPM Package) Eklemeden ÖNCE Aşağıdaki Saf Apple Yönergelerine ve Modern komünite kütüphanelerine Refetans Gözüyle Bakmak Zorundadır!

---

## 🏛️ 1. Çekirdek Ekosistem ve Engine (Navigasyon Doğruları)

Apple cihazlarının Ruhunu kavramak İçin (Uygulamanın Red Yememesi İçin) Kullanılacak Saf Kayanaklar:

- **Apple Human Interface Guidelines (HIG):** [https://developer.apple.com/design/human-interface-guidelines/](https://developer.apple.com/design/human-interface-guidelines/)
  - *Ne İşe Yarar:* En Hayati Başlangıç Noktasıdır! Bir butonun Boyutunun minimum kaç piksel (`44x44 pt`) Olacağı, NavigationBar in hangi Fontla kullanılacağı, Karanlık Modun (Dark Mode) Kontrast Değerlerinin Neler olacağı konusunda MÜHENDİSLİK (Apple Tasarım) Kurallarıdır. Tasarım Yaparken Otonomi İlk Olarak HIG Standartlarını Düşünür.
- **SwiftUI Tutorials & Documentation:** [https://developer.apple.com/tutorials/swiftui](https://developer.apple.com/tutorials/swiftui)
  - *Ne İşe Yarar:* State Flow mekanizmalarının ve (Örneğin `NavigationStack`, `ToolbarItems`) Modern çizim Olarak hangi API seviyelerine Karşılık geldiğini Gösterir. Otonomi "Deployment Target" iOS 14 Seçiliyse Gidip iOS 16'nın `NavigationStack` ini kullanamayacagını Buradan teyit eder.
- **Swift.org (Dil Spektleri - Async/Await):** [https://www.swift.org/documentation/](https://www.swift.org/documentation/)
  - ESKİ `DispatchQueue` Cehennemi yerine "Structured Concurrency" denilen ve Actor Pattern içeren (`@MainActor`), `TaskGroup` Mimarilerini Derinden kavrayıp Cihazin Çift Cekirdegını (Multicore M1\M2) Şenlendirmek için Resmi Dil sitesidir. Yüksek Data çeken Otonomlar İncelemelidir.

---

## 🌐 2. Modern Çözümler ve Ağ Kütüphaneleri (Zorunlu İhtiyaçlar Dışlanmıştır)

UI Tıkanıklıklarını Ve İmaj Yükleme Beklemelerini Bitirecek olan Kütüphaneler ve Standartlar (SPM Swift Package Manger Üzerinden Kurulum Zorunludur - CocoaPods Legacy dir):

- **SDWebImageSwiftUI (Modern Image Caching):** [https://github.com/SDWebImage/SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI)
  - *Sebep:* Çıplak `AsyncImage(url:)` Resmi indirdiğinde Ekranda Scroll (Kaydirma) yapıp geri Döndügünüzde Apple in Kendi Modulü Resmi TEKRAR INDIRMEYE KALKAR (Sifir Cache). Devasa E-Ticaret vb gibi projelerde Bu O.O.M (RAM Çöküşü) saglar. Otonomi, Kesinlikle Liste içinde resim çizerken Caching Yapabilen Bu SPM modulunu Entegre Eder. Veya URLCache modüllerini Yaratır.
- **URLSession (Native API - Alamofire Tükendi):** [https://developer.apple.com/documentation/foundation/urlsession](https://developer.apple.com/documentation/foundation/urlsession)
  - *Sebep:* Eskiden her projede 5MB'lik `Alamofire` olurdu. Bugün `try await URLSession.shared.data(from: url)` Tek Satiirlik async Fonksiyon Ile 0MB Ek Yük ile Ağ İslemleri Gerçeklesmektedir. Otonomi Harici İstek Eklemek Uğruna Spagettilestirme YAPMAZ! Saf Native Kullanir.

---

## 🖼️ 3. Çizim Zenginlikleri ve Lottie (Görsel Ziyaret)

- **Lottie iOS (Animasyon Havuzu):** [https://github.com/airbnb/lottie-ios](https://github.com/airbnb/lottie-ios)
  - Projede Döndürülen CİRKİN (Standart `ProgressView()` ve `CircularIndicator()`) Yerine Tasarımcinin Attığı Adobe Animasyonlarını Render Eden Gelişmiş SPM Kütüphanesidir. (Custom ViewModifier Kullanılarak SwiftUI Diline adapte edilmelidir, Lottie Native Olarak UIKit Temellidir `UIViewRepresentable` Köprusu Gerekir!)
- **SF Symbols (Apple Core İkonları):** [https://developer.apple.com/sf-symbols/](https://developer.apple.com/sf-symbols/)
  - Asset Kullanmadan, Vector Olcekli ve 6000'den Fazla O.S İkonu İçeren Resmi Apple Arşivi.

---

## 🚀 4. Otomasyon ve Bağımsız Test Süreçleri (TestFlight / CI CD)

Yapay zeka Sadece View Cizimi Bırakıp Gidemez, Deployment Asamasinda Bunlari Göz Önüne Alır:

- **Fastlane for iOS (Otomastizasyon Kulesi):** [https://docs.fastlane.tools/](https://docs.fastlane.tools/)
  - uygulamanin "Sertifikalarını (Provide Profile)", "Ekran Görüntülerini Cekmeyi (Automated Screenshots)", "Version Numarsını Yukseltmeyi" ve Testflight'a Binayı Fırlatmayı İceren Ruby tabanlı CI/CD aracidir. Otonomi Uygulama Tamamlandigında `.env` Ortamındaki Şifrelerle Birlikte AppStoreConnect Dağıtımını Gerceklestirir! 
- **XCTest ve XCUITest (Otonom Test Raporlari):** Saf Apple Test Ortamları. Logic Hatalarini onlemek Adına Zeka Mutlaka `XCTAssert` lari ile Repository Kontrolu Yapmalidir! Yalnizca Mimariler Pürüzsüz Olunce Ürün (A-Grade) Apple Store kalitesine cıkar.

Artık Tasarım ve Planlama Aksaması Tamamlandı, Otonomi Kurallar Çercevesinde Kod Blokları Üretimine Gecebilir. 
