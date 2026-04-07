# ⚡ QUICK-START — Kotlin Android (MVVM + Clean + Compose)

> AI'a sadece BU dosyayı + proje fikrini ver. Gerisini otonom yapacak.

---

## 🤖 AI TALİMATI

Sen bir otonom AI geliştiricisisin. Kullanıcı sana bir proje fikri verecek. 
Hiçbir şey sormadan, aşağıdaki kurallara göre A'dan Z'ye projeyi tamamla.

---

## 📋 TECH STACK (SABİT)
- **Dil:** Kotlin
- **UI:** Jetpack Compose
- **Mimari:** MVVM + Clean Architecture
- **DI:** Hilt
- **Network:** Retrofit + OkHttp + Gson
- **Local DB:** Room
- **Navigation:** Compose Navigation
- **Async:** Coroutines + Flow
- **Image:** Coil
- **Test:** JUnit + Mockk + Turbine (Flow test)

---

## 📐 MİMARİ (ZORUNLU)
```
app/src/main/java/com/example/{{project_name}}/
├── di/                    → Hilt modules
│   ├── NetworkModule.kt   → Retrofit + OkHttp
│   ├── DatabaseModule.kt  → Room DB
│   └── RepositoryModule.kt→ Repository binding
├── data/
│   ├── remote/
│   │   ├── api/           → ApiService.kt (Retrofit interface)
│   │   └── dto/           → API response DTO'lar
│   ├── local/
│   │   ├── entity/        → Room Entity'ler
│   │   ├── dao/           → Room DAO'lar
│   │   └── AppDatabase.kt
│   ├── repository/        → Repository implementation
│   └── mapper/            → DTO ↔ Domain mapper
├── domain/
│   ├── model/             → Domain model (data class)
│   ├── repository/        → Repository interface
│   └── usecase/           → UseCase sınıfları
├── presentation/
│   ├── screens/           → Compose Screen'ler
│   │   ├── splash/        → SplashScreen.kt + SplashViewModel.kt
│   │   ├── login/         → LoginScreen.kt + LoginViewModel.kt
│   │   ├── home/          → HomeScreen.kt + HomeViewModel.kt
│   │   └── detail/        → DetailScreen.kt + DetailViewModel.kt
│   ├── components/        → Reusable Composable'lar
│   │   ├── AppButton.kt, AppTextField.kt, LoadingView.kt
│   │   └── EmptyView.kt, ErrorView.kt
│   ├── navigation/        → NavGraph.kt + Routes.kt
│   └── theme/             → Theme.kt, Color.kt, Type.kt
├── util/                  → Extension fonksiyonlar, Constants
└── MainActivity.kt
```

---

## 🔧 DOSYA ÜRETME SIRASI
```
1. build.gradle (app + project) → dependency'ler + Hilt plugin
2. AndroidManifest.xml → permissions (INTERNET, CAMERA vs.)
3. presentation/theme/ → Color.kt, Type.kt, Theme.kt (M3)
4. util/ → Constants.kt (BASE_URL, PREF_KEYS)
5. data/remote/api/ → ApiService.kt (Retrofit interface)
6. data/remote/dto/ → Response/Request DTO
7. data/local/entity/ → Room Entity
8. data/local/dao/ → Room DAO
9. data/local/ → AppDatabase.kt
10. domain/model/ → Domain data class
11. domain/repository/ → Repository interface
12. data/mapper/ → DTO ↔ Domain mapper
13. data/repository/ → Repository implementation
14. domain/usecase/ → UseCase
15. di/ → NetworkModule, DatabaseModule, RepositoryModule
16. presentation/components/ → AppButton, AppTextField, LoadingView, ErrorView, EmptyView
17. presentation/screens/ → SplashScreen → LoginScreen → HomeScreen → DetailScreen
18. presentation/screens/[screen]/ → ViewModel (her screen için)
19. presentation/navigation/ → Routes.kt + NavGraph.kt
20. MainActivity.kt → setContent { AppTheme { NavGraph() } }
21. test/ → ViewModel + UseCase + Repository testleri
```

---

## ⚠️ ZORUNLU KURALLAR
```
✅ HER ZAMAN:
- Dosya adları PascalCase.kt
- Compose fonksiyonları @Composable PascalCase
- State: StateFlow + collectAsStateWithLifecycle
- DI: @Inject constructor + @HiltViewModel
- Async: viewModelScope.launch + Dispatchers.IO
- Error handling: sealed class UiState<T> (Loading, Success, Error)
- Theme: MaterialTheme.colorScheme — hardcoded ASLA
- BuildConfig: API key + base url
- ProGuard: release build kuralları

❌ ASLA:
- Activity'de iş mantığı → ViewModel
- Coroutine GlobalScope → viewModelScope
- Hardcoded string → strings.xml
- Hardcoded renk → Color.kt
- findViewById → Compose
- Thread() → Coroutine
- println() → Timber veya Log
```

---

## 🔐 AUTH AKIŞI
```
1. SplashScreen → SharedPreferences token kontrol
2. Token var → HomeScreen
3. Token yok → LoginScreen
4. Login → API call → token kaydet → HomeScreen
5. Register → API call → token kaydet → HomeScreen
6. Logout → token sil → LoginScreen
7. AuthInterceptor: her request'e Bearer token ekle
8. 401 response → token sil → LoginScreen'e redirect
```

---

## 🎨 UI STANDARTLARI
```
- Material 3 (M3) tema
- Dynamic Color (Android 12+)
- Light + Dark mode
- LazyColumn/LazyGrid (RecyclerView yerine)
- Scaffold + TopAppBar + BottomNavigation
- Modifier.padding/fillMaxWidth (Dp sabitleri)
- CircularProgressIndicator loading
- Pull-to-refresh (Accompanist veya M3)
- Shimmer loading (placeholder)
- SnackBar bildirimler
- Navigation animation (Compose)
```

---

## 🐛 SIK HATALAR → ÇÖZÜM
| Hata | Çözüm |
|------|-------|
| `Hilt: MissingBinding` | @Provides veya @Binds eksik → Module kontrol |
| `Cannot create ViewModel` | @HiltViewModel + @Inject constructor |
| `Room: Cannot find implementation` | kapt 'room-compiler' ekle |
| `Flow not collected` | collectAsStateWithLifecycle kullan |
| `Compose recomposition loop` | remember + derivedStateOf kullan |
| `NetworkOnMainThread` | Dispatchers.IO kullan |
| `ProGuard: class not found` | proguard-rules.pro güncelle |
| `Nullable crash` | `?.let {}` + elvis `?:` operatörü |

---

## 🏁 BİTİRME CHECKLIST
```
- [ ] Proje build + run başarılı
- [ ] Auth (login + register + logout) çalışıyor
- [ ] API CRUD çalışıyor
- [ ] Room offline cache çalışıyor
- [ ] Loading / Error / Empty state var
- [ ] Dark mode çalışıyor
- [ ] Material 3 tema uygulanmış
- [ ] Unit test var (ViewModel + UseCase)
- [ ] ProGuard release build çalışıyor
- [ ] Gereksiz Log/println temizlendi
- [ ] .gitignore var
- [ ] README.md var
```
