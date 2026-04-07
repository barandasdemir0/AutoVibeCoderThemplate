# 📂 Files — Kotlin | 🐛 Debug Tips | 📚 Resources

## Files Structure
```
app/src/main/java/com/project/
├── di/, data/ (remote/, local/, repository/, mapper/), domain/ (model/, usecase/, repository/)
├── presentation/ (screens/, viewmodel/, components/, navigation/)
└── MainActivity.kt
res/ (layout/, values/, drawable/)
```

## Debug Tips
- **"Cannot create instance of ViewModel"** → `@HiltViewModel` + `@Inject constructor` var mı?
- **Room compile error** → Entity `@PrimaryKey` eksik
- **Retrofit 404/500** → Postman'de API test et, URL kontrol
- **Compose recomposition** → `remember`, `derivedStateOf` kullan
- **Hilt "Missing binding"** → Module'da `@Provides` tanımlı mı?
- Debug aracı: **Logcat**, **Layout Inspector**, **Android Profiler**

## Resources
| Kaynak | Link |
|--------|------|
| Android Developers | https://developer.android.com |
| Jetpack Compose | https://developer.android.com/jetpack/compose |
| Hilt | https://dagger.dev/hilt |
| Room | https://developer.android.com/training/data-storage/room |
| Retrofit | https://square.github.io/retrofit |
