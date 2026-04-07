# 5️⃣ Native Mobil - Cihaz Çökmeleri (Crash), Memory Leak (Sızıntı) ve Profiling

> **ZORUNLU STANDART:** Native uygulama Geliştirirken Konsolda "Warning" Görmeyiz. Biz "SIGABRT" (Cihazın Kernelden Kapatılması) Veya "Index Out Of Bounds" Gibi Doğrudan Çökme Kararlı Hatalar Görürüz! Otonom yapay zeka, Kod üretirken BÜTÜN OPSİYONELLERİ (Optional Chaining) Pimi Çekilmiş Bomba Gibi Görecek ve GÜVENLİ (Safety) Açacaktır!.

---

## 🚫 1. Opsiyonel (Null Pointers) Zorunlu Açılışları (!) (Uygulama İntiharları)

Bu Hatayı Sadece Yeni Başlayan Yazılımcılar Ve Modeli Eğitilmemiş Yapay Zekalar Yapar: Swift Ve Kotlin `null-safety` Özelliği İçin Kurulmuştur!! Ancak Siz Gidip Garantisiz bir İşe "!" (Force Unwrap) Vurursanız Uygulama O saniye Kapanir (Crash Log Yemesi Garantidir).

1. ❌ **Force Unwrapping (!) Kullanımı KESİN YASAKTIR:**
   ```swift
   // FELAKET - Serverdan Ya İsim Gelmezse? VEYA Resim URL'i Null ise? APP ÇÖKER.
   let name: String = user.name! 
   let url = URL(string: user.avatarUrl)!
   ```
   *DOĞRUSU:* Otonom yapay zeka EĞER BİR NESNE (Olabilecekse de) `?` Opsiyonel Girdiyse ONU Güvenli Kalkan İle Sökecektir (`if let` veya `guard let` kullanıumu ZORUNLUDUR)!
   ```swift
   // KUSURSUZ GÜVENLİ OTONOM KOD
   guard let safeName = user.name, let url = URL(string: user.avatarUrl) else {
        return // Uygulama çökmek yerine Bu methodu Sessizce Terk Eder Veya Placeholder Döndürür!
   }
   // Güvenle Kullan (safeName, url)
   ```

---

## 💥 2. Memory Leak: Kapanmayan View Modeller (Retain Cycles)

Bir Kullanıcı Profil Sayfasını açtı. Profil Yüklenirken Geri Dönüp Anasayfaya Bastı. Yüklenme Bittiginde Profil Sayfası Kapatıldığı Halde RAM'de Kalır (Asla Silinmez Zombi Class olur) Ve Hatta Arka Planda API'den gelen veriyi "Silinmiş Sayfaya" Update Etmeye Calısırken Crash Atar!!

1. ❌ **Asenkron İçerisine Güçlü (Strong) Referans Gömmek:**
   ```swift
   // YASAKTIR: Task veya Asenkron Network Call içerisinde 'self' kelimesi Classı Bağlar Bırakmaz!
   networkData { result in 
       self.users = result 
   }
   ```
   *DOĞRUSU (Otonomi Standardı):* `[weak self]` ibaresini Ekleyerek Cihaza Şunu Emret: "Eğer O Ekran Kapatılmışsa, Bu veriyi Atta Gönder ve Beni Ram'den Temizle!"
   ```swift
   networkData { [weak self] result in
       guard let self = self else { return } // Zombi ise Öl.
       self.users = result 
   }
   ```

---

## 📊 3. Ağ (Network) Hata Güvenliği Ve Sentry İzleme Katmanı

Kullanıcının İnterneti Yok? Otonom Yapay zeka bunu Önden Tespit Eden Sınıflar (Reachability Veya NWPathMonitor) Yazmalıdır. Ayrıca Ağ Kopuksa, Veya Sunucu "500 Internal Error" Veriyorsa Uygulama Kullanıcıya Boş Bir "Mavi/Beyaz Ekran" GÖSTEREMEZ!
* `View` içerisinde otonom zeka bir Hata Olduğunda Gözükecek `<ErrorStateView>` Göstermek Zorundadir!.
* **Telemtry Kurulumları (Sentry/Instabug/Firebase Crashlytics):** Üretim Hattı Projesi İçin Sentry (Kaza Raporcusu) Projenin AppDelegate Veyahut App Mimarisine INIT Edilir!!. Crash anlarında Kullanıcı Etkilenmeden Developer'a Rapor Farlar.

---

## 🚦 4. Geliştirici Ortamı İpuçları (Instruments ve Memory Graph)
Otonom zeka Swift Yazarken veya Jetpack Compose Kodlarken; Projenin "Previews" Ekranlarında Mükemmel Render için Sadece `Debug` Değil Zaman zaman XCode üzerinden "Instruments -> Memory Leaks Profiler" Varsa Test Edilmelidir (Kendini Kanıtlamak Zorundadır Otonom Model!). UI Cizimi (Listeleme vs) 120Hz Ekranda Titreme Yapıyorsa Kod HANTALDIR!
