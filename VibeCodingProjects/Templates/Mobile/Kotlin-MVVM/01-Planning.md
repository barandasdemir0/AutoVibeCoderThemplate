# 📋 Planning — Kotlin Android (MVVM)

## 🎯 Proje
- **Proje Adı:** [—]  | **Platform:** Android
- **Açıklama:** [—]

## 🛠️ Tech Stack
| Katman | Teknoloji |
|--------|-----------|
| Dil | Kotlin |
| UI | Jetpack Compose / XML Views |
| Mimari | MVVM + Clean Architecture |
| DI | Hilt (Dagger) |
| Network | Retrofit + OkHttp |
| DB | Room (SQLite) |
| State | StateFlow / LiveData |
| Navigation | Navigation Component |
| Image | Coil / Glide |
| Test | JUnit + Espresso + MockK |

## 📦 Gradle Dependencies
```groovy
implementation 'androidx.lifecycle:lifecycle-viewmodel-compose'
implementation 'com.google.dagger:hilt-android'
implementation 'com.squareup.retrofit2:retrofit'
implementation 'com.squareup.retrofit2:converter-gson'
implementation 'androidx.room:room-runtime'
implementation 'io.coil-kt:coil-compose'
implementation 'androidx.navigation:navigation-compose'
```

## ⭐ MVP
1. [ ] MVVM yapısı + Hilt DI
2. [ ] Retrofit API entegrasyonu
3. [ ] Room local database
4. [ ] Jetpack Compose UI
5. [ ] Navigation
6. [ ] Auth (JWT token)
