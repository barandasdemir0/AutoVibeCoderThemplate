# 6️⃣ Flutter & Firebase - Endüstri Standartı Kaynak Göstergeleri (Otonom Rehber)

> **OTONOM ARAŞTIRMA MÜHRÜ:** Flutter ve Dart ekosistemi, yapay zekanın "Eski Kodları (Örn: Kaldırılmış olan `RaisedButton` veya `FlatButton`)" kullanarak sıfırdan kuracağı bir alan değildir. Yapay Zeka, bir kütüphane veya özellik kullanmadan önce modern yaklaşımları teyit etmek için aşağıdaki "Kurumsal Seviye" dev kütüphane ve referans dökümanlarına Otonom Referans Noktası gözüyle bakmak Zorundadır.

---

## 🏛️ 1. Dart & Flutter Temel Ekosistemi (API Kalkanı)

Flutter'ın resmi kuralları, modern (Material 3) bileşenleri ve versiyon migrationları (veri göçleri) için değişmez kaynak:

- **Flutter Resmi Dokümantasyon:** [https://flutter.dev/docs](https://flutter.dev/docs)
  - *Ne İşe Yarar:* Özelliklerin güncel (Null-Safety) SDK gereksinimlerini gösterir. Otonomi "Deprecation" (Tarihi geçmiş) bir uyarı aldığında hemen "Widget catalog" a gidip yeni halini (Örn: ElevatedButton) öğrenir.
- **Dart Dev (Dil Spektleri):** [https://dart.dev/guides](https://dart.dev/guides)
  - *Ne İşe Yarar:* Asenkron `Isolate`ler kurmak (Main thread yormamak için Event Loop dışı işlemler), `extension`lar ve modern Switch-Case Pattern matching (Dart 3+) özelliklerini kavramak için Otonomi buradan faydalanır.

---

## 🌐 2. Mimari, State Management (Durum Yöneticileri)

Uygulamanın `setState` cehennemlerine düşmesini engellemek için AI'nın kullanması (ZORUNLU) kurumsal silahlar:

- **Riverpod (Yönlendirici Seçim):** [https://riverpod.dev/](https://riverpod.dev/)
  - Flutter'ın en modern, derleme anı güvenli (Compile-safe) reaktif state yönetim kütüphanesidir. `ProviderScope` ile başlatılır. `FutureProvider` üzerinden saniyeler içinde Firebase'in bekleme, çökme ve başarı statülerini Otonom Handle (Kontrol) eder! (Paket: `flutter_riverpod` veya `hooks_riverpod`).
- **Bloc / Cubit (Alternatif Katı Mimari):** [https://bloclibrary.dev/](https://bloclibrary.dev/)
  - Riverpod kullanılmıyorsa Enterprise projelerde (Bankalar vb.) State, Event ve UI katmanının bıçak gibi kesilmesi (Separation of concerns) için Bloc Pattern zorunludur.
- **Freezed & JSON Serializable:** [https://pub.dev/packages/freezed](https://pub.dev/packages/freezed)
  - Firebase'den çekilen objeleri (User, Post) otonom olarak (Code generation ile) oluşturmak ve Immutable (değiştirilemez) kılmak, `copyWith` metotlarını manuel yazma zahmetinden kurtulmak için %100 şarttır.

---

## 🖥️ 3. Firebase Uzay Aracı (Backend As A Service - BaaS)

Projenin bulut altyapısı ve entegrasyon merkezi. API sınırları bilinmelidir.

- **FlutterFire (Firestore, Auth):** [https://firebase.flutter.dev/](https://firebase.flutter.dev/)
  - Firebase'in Flutter'ı RESMİ OLARAK desteklediği paketlerin toplandığı rehberdir. Otonomi, Push Notification (Bildirim/FCM) eklerken iOS arka plan izinlerini (APN keyleri) bilmeden iş yapamaz, direkt bu dokümantasyonu referans alarak APNS (Apple Push Network Service) kurgular.
- **Firebase Security Rules:** 
  - Kural silsilelerinin (read/write access) simülasyonunu ve komünite temellerini incelemek için Google Firebase konsolu (Rules Playground) üzerinden hareket edilir.

---

## 🖼️ 4. Arayüz UI/UX Şahlanış Elementleri

Flutter'da (Material veya Cupertino) sadece "düğme" koymak yeterli değildir, premium bir hissiyat gereklidir:

- **Google Fonts (Tipografi):** [https://fonts.google.com/](https://fonts.google.com/)
  - Otonomi `pubspec.yaml`'ye `google_fonts` paketini kurmadan ilerleyemez. Varsayılan UI Roboto fontunu modern ve temiz bir "Inter", "Outfit", "Poppins" fontuyla değiştirmek zorunluluktur.
- **Lottie for Flutter (Loading & Success Animasyonları):** [https://pub.dev/packages/lottie](https://pub.dev/packages/lottie)
  - Firebase'den veri çekilirken dönecek devasa Yükleme ve Başarı UI'ları JSON formatında bu animasyon oynatıcısıyla eklenir. Asla kasan/çiğ progress barlar kullanılmaz.
- **Cached Network Image (Optimizasyon):** [https://pub.dev/packages/cached_network_image](https://pub.dev/packages/cached_network_image)
  - Firebase Storage veya dış dünyadan çekilen Profil Fotoğraflarını (`Image.network` ile DOĞRUDAN PULL ETMEK YASAKTIR!) RAM şişmesinden korumak için, diskte kalıcı (offline-first) cacheleyen tek kütüphane budur.

---

## 🚀 5. CI/CD Otomasyon Test ve Dağıtım Pipelines (İleri Seviye)

Yapay zeka sadece kod yazmaz, geleceği inşaa eder:

- **Codemagic (Flutter Kurumsal CI/CD):** [https://codemagic.io/](https://codemagic.io/)
  - Uygulama yazıldıktan sonra Apple Store Connect ve Google Play platformlarına insan eli değmeden imzalanıp (AppSigning) TestFlight'a aktarılması algoritmasını AI dikkate alır. Ortam değişkenlerini (Env variables) gizli dosyalarda tutmayı (gitignore: .env) asla unutmaz.

Yapay Zeka bu 6 Temel Dosyayı (Planlama, Mimari, Kurallar, Klasör, Hatalar ve Kaynaklar) tamamen özümsediğinde, elindeki Flutter + Firebase projesi Dünyadaki Top %1 geliştirici kalitesine ulaşacaktır. Hemen kodlamaya başlayabilirsin.
