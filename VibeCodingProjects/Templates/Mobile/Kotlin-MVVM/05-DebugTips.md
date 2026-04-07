# 🐛 Debug Tips — Kotlin Android

## ⚠️ Sık Hatalar

### "Cannot create an instance of ViewModel"
→ `@HiltViewModel` annotation var mı?
→ `@Inject constructor()` tanımlı mı?
→ Activity'de `@AndroidEntryPoint` var mı?

### Room derleme hatası
→ Entity'de `@PrimaryKey` var mı?
→ DAO dönüş tipi `Flow<List<T>>` veya `suspend fun`?
→ `kapt` / `ksp` plugin aktif mi? (`build.gradle`)

### Retrofit "Expected BEGIN_OBJECT but was BEGIN_ARRAY"
→ API response tipi JSON array ama tek obje bekleniyor → `List<T>` kullan

### Compose: sonsuz recomposition
→ `remember { }` memoization kullan
→ `LaunchedEffect(key)` → side effects için

### Hilt "Missing binding"
→ Module'da `@Provides` veya `@Binds` ile tanımla
→ `@InstallIn(SingletonComponent::class)` doğru scope mu?

## 🔍 Araçlar
| Araç | Kullanım |
|------|----------|
| Logcat | `Log.d("TAG", "message")` |
| Layout Inspector | UI hiyerarşi |
| Android Profiler | Memory, CPU, Network |
| Database Inspector | Room DB inspect |

## 📓 Debug Günlüğü
| Tarih | Hata | Çözüm |
|-------|------|--------|
| [—]   | [—]  | [—]    |
