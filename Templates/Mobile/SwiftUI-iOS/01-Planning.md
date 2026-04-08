# 1️⃣ Apple SwiftUI (Native iOS) - Kapsamlı Mobil Planlama & iOS Özgü (Platform-Specific) Sözleşme

> **OTONOM YAPAY ZEKA İÇİN KESİN KURAL:** Bu şablon, Cross-Platform Mac/Watch gereksinimlerinden tamamen ARINMIŞ, doğrudan %100 "Safkan iPhone & iPad (iOS/iPadOS)" donanımına inen bir mimariyi temsil eder. Otonom ajan, bu projenin temelini oluştururken doğrudan Apple'ın en son O.S teknolojilerini (SwiftData, Live Activities, FaceID/TouchID, WidgetKit) çekirdeğine yerleştirecek ve Web-benzeri hantal düşünceleri reddedecektir!

---

## 🎯 1. Çekirdek Altyapı Kararı: iOS Cihaz Donanımı Tam Erişim

Mobil dünyanın Web'den veya Çoklu-platform (React Native/Flutter) framework'lerden en büyük farkı; kameraya, sensörlere, bildirim merkezine (Dynamic Island) "C++ Köprüsü Olmadan" Direkt (Native) temas edilmesidir.

### Otonomi İçin iOS'a Has Süper Limitler:
* **SwiftData (Modern Persistence):** Eski ve C tabanlı hantal `CoreData` tamamen çöpe atılmıştır (Aksi istenmedikçe). Kurumsal iOS projelerinde (iOS 17+) veritabanı Otonom olarak %100 `@Model` tag'i kullanılarak `SwiftData` ile inşaa EDİLİR! Sadece bir Class'ın başına `@Model` yazıldığında sistem onu otomatik kalıcı (Persistent) yapar. Hata payı `Sıfır`dır.
* **WidgetKit & Dynamic Island:** Bir E-ticaret sipariş takip sistemi veya Zamanlayıcı (Timer) yapılıyorsa; Otonomi sadece uygulamanın UI'ını değil, arka planda çalışan "Canlı Etkinlik (Live Activity)" entegrasyonuyla `Dynamic Island` desteğini O.S'e bildirmek ZORUNDADIR. (Kullanıcı App'ten çıksa da ekranın üstünden Siparişini görmelidir).
* **Biyometrik Güvenlik (Local Authentication):** Modern iOS uygulamalarında her login işleminde Şifre İSTEMEK YASAKTIR! Ajan uygulamayı kurgularken Firebase/Sunucu entegrasyonu yanında `FaceID / TouchID` kullanım zırhını (LocalAuthentication framework) Login'in ayrılmaz bir parçası olarak kodlamak ZORUNDADIR.

---

## 🔒 2. iOS Arka Plan İşlemleri (Background Tasks & URLSession)

iOS işletim sistemi (O.S), pil tüketimini korumak için uygulamaları Arka Plana (Background) düştüğü 30. saniyede "Askıya Alır (Suspend)". 

* **Kural 1 (Background Fetch Yasağı):** Otonomi "Arkada sürekli timer ile veri çekeyim" şeklinde Cihazı sömüremeyecektir! Eğer arka planda veri çekilecekse `BGTaskScheduler` zorunlu kılınecek, sistem Pili doluyken "O.S'in uygun gördüğü saatte" veriyi kendisi tazeleyecektir.
* **Kural 2 (Silent Push Notifications - APNS):** Otonomi, veritabanının güncellenmesi gerektiğinde Cihazı polling (Sürekli sorma) Döngüsüne SOKAMAZ! Ajan, Firebase Cloud Messaging (FCM) veya APNS kullanarak cihaza "Sessiz Bildirim (Silent Push)" gönderir, Cihaz asılı kaldığı uykudan sadece O AN uyanıp Ekranı Günceller. Network Requestler ASLA boşa atılmaz!
* **Kural 3 (Large File Downloads):** Uygulama arka planındayken 100MB Film iniyorsa Uygulama Çöker! Bunu önlemek için `URLSessionConfiguration.background` kullanılacaktır. Cihaz indirmeyi Daemon (işletim sistemi servisi) seviyesinde gerçekleştirir.

---

## 🚀 3. Ekran Boyutları, iPadOS ve Çoklu Pencere (Multitasking)

iOS Sadece iPhone 15 den ibaret değildir; iPhone SE'nin ufak ekranı, iPad'in Split View (Ortadan ikiye bölünen ekran) özelliklerini Otonomi Yönetmek Mecburiyetindedir!

* **A. Size Classes Diktası:** 
Tasarım Çizilirken, Cihaz iPad (Regular Width) modelindeyse, Otonom araç "Dümdüz kocaman bir Vbox" GÖSTEREMEZ! Cihazı analiz etmeli ve Enjekte edilen `NavigationSplitView` (eski adıyla Master-Detail View) sayesinde ekranın Solunda Menü, Sağında İçerik Olacak şekilde Profesyonel (Adaptive) Mimariler Geliştirecektir. Telefonlarda (Compact width) kendiliğinden Tek Ekran yığılmasına geçer.
* **B. Klavye Binişleri (Keyboard Toolbar):**
Web Browserlar klavye açılınca otomatik itme yapsalar da SwiftUI iOS'ta Toolbar Accessory (Klavyenin üstüne eklenen Tamam/Done tuşu) atlanması Faciaya Yol Açar (Özellikle Sadece Rakam girilen NumberPad klavyelerinde)! Otonomi `.toolbar { ToolbarItemGroup(placement: .keyboard) { ... } }` kurgusunu ZORUNLU kullanır! Geri Alış (Dismiss Keyboard) refleksini eklemek mecburidir.
* **C. Hardware Back Button YOKTUR (NavGestiure Limitleri):**
Android'in Aksine iOS cihazlarda donanımsal Geri Tuşu yoktur. Geri çıkmak "Ekranın solundan sağa (Edge Swipe)" kaydırma hareketidir. Otonomi Gidip de sayfanın En tepesindeki barı gizleyip `navigationBarBackButtonHidden(true)` Dediği an O Yana Kaydırma İptal Olur ve UX Katledilir. Eğer Tuş gizlenecekse, Custom bir `DragGesture` sayfaya zerk edilerek Ekran Geçişi korunur!

Bu Native iOS Cihaz sınırlarına (Donanım/Battery/UI) riayet edecek Ajana direkt Mimari Ayrışma (02) dosyasına geçiş izni verilmiştir.
