# 📱 MOBILE-PUBLISH.md — Mobil Uygulama Mağaza Yayınlama Rehberi

> Uygulamayı geliştirdikten sonra Play Store ve App Store'a yayınlama adımları.
> AI bu rehberi takip ederek deploy dosyalarını hazırlayacak.

---

## 🤖 Android — Google Play Store

### 1. App Signing (Keystore Oluşturma)

#### Flutter
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

#### Android Keystore Config
```properties
# android/key.properties (bu dosya .gitignore'da OLMALI)
storePassword=<KEYSTORE_PASSWORD>
keyPassword=<KEY_PASSWORD>
keyAlias=upload
storeFile=<KEYSTORE_PATH>/upload-keystore.jks
```

#### build.gradle Ayarları
```groovy
// android/app/build.gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### 2. Build Komutları

```bash
# Flutter
flutter build appbundle --release    # AAB (Play Store için — önerilen)
flutter build apk --release          # APK (direkt yükleme)
flutter build apk --split-per-abi    # ABI bazlı küçük APK'lar

# Kotlin/Java
./gradlew bundleRelease              # AAB
./gradlew assembleRelease            # APK

# React Native
cd android && ./gradlew bundleRelease
```

### 3. Play Console Checklist

| Adım | Detay |
|------|-------|
| Developer hesabı | $25 tek seferlik ücret |
| App oluştur | Apps → Create app |
| Store listing | Title (30), short desc (80), full desc (4000) |
| Screenshots | Phone: min 2 adet, 16:9 veya 9:16 |
| Feature graphic | 1024×500 PNG/JPG |
| App icon | 512×512 PNG (32-bit, no alpha) |
| Content rating | IARC rating questionnaire doldur |
| Privacy policy | GDPR uyumlu URL gerekli |
| Target audience | Yaş grubu seç |
| Data safety | Hangi verileri topladığını beyan et |
| App bundle | AAB dosyasını yükle |
| Release track | Internal → Closed → Open → Production |

### 4. Data Safety Form (Zorunlu)

```
Topladığın veri türlerini seç:
- [ ] Kişisel bilgi (isim, email)
- [ ] Konum
- [ ] Fotoğraf/video
- [ ] Dosyalar
- [ ] Cihaz bilgisi
- [ ] Çökme logları

Her biri için:
- Neden topladığını açıkla
- Paylaşıyor musun
- Kullanıcı silebilir mi
- Şifreleniyor mu
```

---

## 🍎 iOS — Apple App Store

### 1. Gereksinimler

| Gereksinim | Detay |
|-----------|-------|
| Apple Developer hesabı | $99/yıl |
| Mac bilgisayar | Xcode için zorunlu |
| Xcode | En son versiyon (App Store'dan) |
| iOS Deployment Target | iOS 14.0+ önerilen |

### 2. Certificate & Provisioning

```
1. Apple Developer Portal → Certificates, Identifiers & Profiles
2. Certificate oluştur:
   - iOS Distribution (App Store)
   - veya Apple Distribution (Universal)
3. App ID oluştur:
   - Bundle ID: com.company.appname
   - Capabilities: Push, Sign in with Apple, vb. seç
4. Provisioning Profile oluştur:
   - Type: App Store
   - App ID + Certificate seç
5. Xcode → Signing & Capabilities:
   - Automatic manage signing ✅ (basit)
   - veya Manual signing (custom)
```

### 3. Build & Upload

```bash
# Flutter
flutter build ipa --release
# Çıktı: build/ios/ipa/app.ipa

# Xcode ile:
# Product → Archive → Distribute App → App Store Connect

# Transporter app ile:
# .ipa dosyasını Transporter'a sürükle → Upload

# CLI ile:
xcrun altool --upload-app --type ios \
  --file build/ios/ipa/app.ipa \
  --apiKey <KEY_ID> --apiIssuer <ISSUER_ID>
```

### 4. App Store Connect Checklist

| Adım | Detay |
|------|-------|
| App oluştur | My Apps → + → New App |
| Bundle ID | Developer Portal'daki ile aynı |
| App name | Max 30 karakter |
| Subtitle | Max 30 karakter (opsiyonel) |
| Category | Primary + Secondary |
| Screenshots | iPhone 6.7" (1290×2796), 6.5", 5.5" |
| iPad screenshots | 12.9" (2048×2732) — varsa |
| App icon | 1024×1024 PNG (no alpha, no transparency) |
| Description | Detaylı açıklama |
| Keywords | 100 karakter, virgülle ayrılmış |
| Support URL | Destek sayfası |
| Privacy Policy URL | Zorunlu |
| Marketing URL | Opsiyonel |
| Build | Xcode/Transporter'dan yüklenen build'i seç |
| Review notes | Apple'a not (demo hesap bilgileri vb.) |

### 5. Apple Review Kuralları (Sık Ret Sebepleri)

```
❌ App crash ediyor → Tüm cihazlarda test et
❌ Login var ama demo hesap yok → Review notes'a demo hesap yaz
❌ Placeholder içerik var → Gerçek içerik koy (lorem ipsum YASAK)
❌ Gizlilik politikası eksik → Privacy Policy URL zorunlu
❌ In-app purchase Apple Pay dışında → StoreKit kullan
❌ Push notification açıklaması yok → Info.plist'te açıklama ekle
❌ Minimum fonksiyon → Sadece WebView → Ret alır
❌ Metadata uyumsuz → Screenshot ↔ gerçek app uyumlu olmalı
```

---

## 🚀 Fastlane ile Otomatik Deploy (Opsiyonel)

### Kurulum
```bash
# macOS
gem install fastlane
# veya
brew install fastlane
```

### Android Fastlane
```ruby
# android/fastlane/Fastfile
default_platform(:android)

platform :android do
  desc "Deploy to Play Store Internal"
  lane :internal do
    gradle(task: "clean bundleRelease")
    upload_to_play_store(
      track: 'internal',
      aab: '../build/app/outputs/bundle/release/app-release.aab'
    )
  end

  desc "Deploy to Play Store Production"
  lane :production do
    gradle(task: "clean bundleRelease")
    upload_to_play_store(
      track: 'production',
      aab: '../build/app/outputs/bundle/release/app-release.aab'
    )
  end
end
```

### iOS Fastlane
```ruby
# ios/fastlane/Fastfile
default_platform(:ios)

platform :ios do
  desc "Deploy to TestFlight"
  lane :beta do
    build_app(scheme: "Runner", export_method: "app-store")
    upload_to_testflight
  end

  desc "Deploy to App Store"
  lane :release do
    build_app(scheme: "Runner", export_method: "app-store")
    upload_to_app_store(
      force: true,
      skip_screenshots: true,
      skip_metadata: false
    )
  end
end
```

---

## 📱 App Icon & Splash Screen

### App Icon Boyutları

#### Android (mipmap)
| Boyut | Klasör | Piksel |
|-------|--------|--------|
| mdpi | mipmap-mdpi | 48×48 |
| hdpi | mipmap-hdpi | 72×72 |
| xhdpi | mipmap-xhdpi | 96×96 |
| xxhdpi | mipmap-xxhdpi | 144×144 |
| xxxhdpi | mipmap-xxxhdpi | 192×192 |
| Play Store | — | 512×512 |

#### iOS (Assets.xcassets)
| Boyut | Piksel |
|-------|--------|
| 2x | 120×120 |
| 3x | 180×180 |
| iPad 1x | 76×76 |
| iPad 2x | 152×152 |
| App Store | 1024×1024 |

### Flutter App Icon (Otomatik)
```yaml
# pubspec.yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.0

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"
  min_sdk_android: 21
```

```bash
dart run flutter_launcher_icons
```

### Flutter Splash Screen (Otomatik)
```yaml
# pubspec.yaml
dev_dependencies:
  flutter_native_splash: ^2.3.0

flutter_native_splash:
  color: "#1a1a2e"
  image: "assets/splash/logo.png"
  android: true
  ios: true
```

```bash
dart run flutter_native_splash:create
```

---

## 📋 AI İçin Yayınlama Protokolü

```
1. PRODUCTION-CHECKLIST.md çalıştır → tüm maddeler ✅
2. App icon + splash screen hazırla
3. Release build al (AAB/IPA)
4. Build crash-free mi test et
5. Store listing hazırla (screenshots, description)
6. Privacy policy oluştur
7. İlk yükleme → Internal/TestFlight (test)
8. Test geçti → Production'a yükle
9. Review bekle (Android: saat-gün, iOS: 1-5 gün)
10. Yayınlandı!
```
