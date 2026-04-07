# 🏗️ Architecture — Kotlin Android (MVVM + Clean)

## 🧱 MVVM Yapısı
```
app/src/main/java/com/project/
├── di/              → Hilt modules (NetworkModule, DatabaseModule)
├── data/
│   ├── remote/      → API interface (Retrofit), DTO
│   ├── local/       → Room (Entity, DAO, Database)
│   ├── repository/  → Repository implementation
│   └── mapper/      → DTO ↔ Domain mapper
├── domain/
│   ├── model/       → Domain model
│   ├── repository/  → Repository interface
│   └── usecase/     → UseCase sınıfları
├── presentation/
│   ├── screens/     → Compose Screen'ler
│   ├── viewmodel/   → ViewModel (StateFlow)
│   ├── components/  → Reusable Composable'lar
│   └── navigation/  → NavHost, Routes
└── MainActivity.kt
```

## MVVM Akışı
```
View (Compose) → ViewModel (StateFlow) → UseCase → Repository → Remote/Local
```

## 🔐 Auth
```kotlin
// Retrofit Interceptor → Token header
class AuthInterceptor(private val prefs: SharedPreferences) : Interceptor {
    override fun intercept(chain: Interceptor.Chain): Response {
        val token = prefs.getString("token", null)
        val request = chain.request().newBuilder()
            .addHeader("Authorization", "Bearer $token")
            .build()
        return chain.proceed(request)
    }
}
```

## Hilt DI
```kotlin
@Module @InstallIn(SingletonComponent::class)
object NetworkModule {
    @Provides @Singleton
    fun provideRetrofit(): Retrofit = Retrofit.Builder()
        .baseUrl(BASE_URL)
        .addConverterFactory(GsonConverterFactory.create())
        .build()
}
```
