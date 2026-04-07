# Starter Blueprints — Mobile Templates

## ReactNative (Expo + Navigation + Context)
```
src/
├── constants/colors.js, strings.js
├── navigation/AppNavigator.js, AuthNavigator.js
├── context/AuthContext.js
├── services/api.js, authService.js
├── screens/LoginScreen.js, RegisterScreen.js, HomeScreen.js
├── components/Button.js, Input.js, Loading.js
└── utils/validators.js, storage.js (AsyncStorage)
package.json → expo, @react-navigation/native, axios, @react-native-async-storage
```

## Kotlin-MVVM (Compose + Hilt + Room + Retrofit)
```
app/src/main/java/com/{{package}}/
├── di/AppModule.kt, NetworkModule.kt, DatabaseModule.kt    → @Module @InstallIn
├── data/
│   ├── local/AppDatabase.kt, UserDao.kt
│   ├── remote/ApiService.kt, AuthApi.kt
│   ├── repository/UserRepositoryImpl.kt
│   └── model/User.kt, LoginRequest.kt, TokenResponse.kt
├── domain/
│   ├── model/User.kt                                        → Domain model
│   └── repository/UserRepository.kt                         → Interface
├── presentation/
│   ├── login/LoginScreen.kt, LoginViewModel.kt
│   ├── home/HomeScreen.kt, HomeViewModel.kt
│   ├── components/AppButton.kt, AppTextField.kt
│   └── theme/Color.kt, Theme.kt, Type.kt
├── util/TokenManager.kt, Resource.kt
└── MainActivity.kt, {{ProjectName}}App.kt
build.gradle → hilt, room, retrofit, compose, navigation-compose, datastore
```

## SwiftUI-iOS (MVVM + URLSession + Keychain)
```
{{ProjectName}}/
├── App/{{ProjectName}}App.swift    → @main
├── Models/User.swift               → Codable struct
├── Services/AuthService.swift, APIClient.swift
├── ViewModels/AuthViewModel.swift, HomeViewModel.swift → @Observable
├── Views/
│   ├── Auth/LoginView.swift, RegisterView.swift
│   ├── Home/HomeView.swift
│   └── Components/PrimaryButton.swift, InputField.swift
├── Utils/KeychainHelper.swift, Validators.swift
├── Resources/Assets.xcassets, Colors.xcassets
└── Info.plist
```
