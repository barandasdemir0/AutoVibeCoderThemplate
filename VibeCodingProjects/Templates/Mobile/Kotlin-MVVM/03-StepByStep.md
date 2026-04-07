# 📝 Step-by-Step — Kotlin Android

## Adım 1: Proje
- [ ] Android Studio → New Project → Empty Compose Activity
- [ ] `build.gradle` → Hilt, Retrofit, Room, Navigation dependencies
- [ ] `minSdk 24`+

## Adım 2: DI (Hilt)
- [ ] `@HiltAndroidApp` Application class
- [ ] `NetworkModule` → Retrofit provide
- [ ] `DatabaseModule` → Room provide

## Adım 3: Data Layer
- [ ] `remote/ApiService.kt` → Retrofit interface
- [ ] `remote/dto/` → API response DTO
- [ ] `local/` → Room Entity, DAO, Database
- [ ] `repository/` → Repository impl

## Adım 4: Domain Layer
- [ ] `model/` → Domain model
- [ ] `usecase/` → GetUsersUseCase, CreateUserUseCase

## Adım 5: Presentation
- [ ] `viewmodel/UserViewModel.kt` → `@HiltViewModel`
- [ ] `screens/` → Compose UI
- [ ] `navigation/` → NavHost + routes

## Adım 6: Build
```bash
./gradlew assembleDebug
./gradlew assembleRelease
```

| Adım | Durum |
|------|-------|
| 1-6  | [ ]   |
