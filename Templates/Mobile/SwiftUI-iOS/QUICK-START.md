# ⚡ QUICK-START — SwiftUI iOS (MVVM)

> AI'a sadece BU dosyayı + proje fikrini ver. Gerisini otonom yapacak.

---

## 🤖 AI TALİMATI

Sen bir otonom AI geliştiricisisin. Kullanıcı sana bir proje fikri verecek. 
Hiçbir şey sormadan, aşağıdaki kurallara göre A'dan Z'ye projeyi tamamla.

---

## 📋 TECH STACK (SABİT)
- **Dil:** Swift 5.9+
- **UI:** SwiftUI
- **Mimari:** MVVM
- **Network:** URLSession + async/await (veya Alamofire)
- **Local:** UserDefaults + CoreData (veya SwiftData iOS 17+)
- **Navigation:** NavigationStack (iOS 16+)
- **DI:** Environment + Dependency Container
- **Image:** AsyncImage (veya Kingfisher)
- **Test:** XCTest + Swift Testing

---

## 📐 MİMARİ (ZORUNLU)
```
ProjectName/
├── App/
│   └── ProjectNameApp.swift       → @main entry
├── Models/
│   ├── User.swift                  → Codable struct
│   └── [Entity].swift
├── Views/
│   ├── SplashView.swift
│   ├── Auth/
│   │   ├── LoginView.swift
│   │   └── RegisterView.swift
│   ├── Home/
│   │   ├── HomeView.swift
│   │   └── [Entity]ListView.swift
│   ├── Detail/
│   │   └── [Entity]DetailView.swift
│   └── Components/
│       ├── AppButton.swift
│       ├── AppTextField.swift
│       ├── LoadingView.swift
│       ├── EmptyView.swift
│       └── ErrorView.swift
├── ViewModels/
│   ├── AuthViewModel.swift         → ObservableObject
│   ├── HomeViewModel.swift
│   └── [Entity]ViewModel.swift
├── Services/
│   ├── NetworkManager.swift        → URLSession wrapper
│   ├── AuthService.swift           → login, register, logout
│   └── [Entity]Service.swift       → CRUD
├── Repositories/
│   └── [Entity]Repository.swift    → Service abstraction
├── Extensions/
│   ├── Color+Extension.swift
│   ├── View+Extension.swift
│   └── String+Extension.swift
├── Utils/
│   ├── Constants.swift             → API URL, Keys
│   ├── KeychainHelper.swift        → Token güvenli saklama
│   └── Validators.swift
├── Resources/
│   ├── Assets.xcassets
│   └── Info.plist
└── Tests/
    ├── ViewModelTests/
    └── ServiceTests/
```

---

## 🔧 DOSYA ÜRETME SIRASI
```
1. ProjectNameApp.swift → @main + WindowGroup
2. Utils/Constants.swift → baseURL, storageKeys
3. Utils/KeychainHelper.swift → token kaydet/oku/sil
4. Extensions/ → Color, View, String
5. Models/ → User (Codable, Identifiable)
6. Services/NetworkManager.swift → URLSession generic request
7. Services/AuthService.swift → login, register
8. Services/[Entity]Service.swift → CRUD
9. ViewModels/AuthViewModel.swift → @Published, async/await
10. ViewModels/[Entity]ViewModel.swift
11. Views/Components/ → AppButton, AppTextField, Loading, Empty, Error
12. Views/Auth/ → LoginView, RegisterView
13. Views/Home/ → HomeView, ListView
14. Views/Detail/ → DetailView
15. Views/SplashView.swift → token kontrol → navigate
16. Tests/ → ViewModel + Service testleri
```

---

## ⚠️ ZORUNLU KURALLAR
```
✅ HER ZAMAN:
- Dosya adları PascalCase.swift
- MVVM: View → ViewModel → Service
- @StateObject (ilk oluşturma), @ObservedObject (dışarıdan)
- async/await + Task { } (combine yerine modern)
- Keychain (token) — UserDefaults ASLA token için
- Error: enum AppError: Error, LocalizedError
- Theme: Color("PrimaryColor") Assets'tan
- Loading: ProgressView()
- NavigationStack (NavigationView deprecated)
- .task { } (onAppear yerine async)

❌ ASLA:
- Force unwrap (!) → guard let / if let
- Global mutable state → ViewModel
- Storyboard → SwiftUI
- UIKit (zorunlu değilse) → SwiftUI eşdeğeri
- print() → os.Logger veya #if DEBUG guard
- Massive ViewModel → UseCase/Service'e böl
```

---

## 🔐 AUTH AKIŞI
```swift
// ViewModel
@MainActor class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var error: String?
    
    func login(email: String, password: String) async {
        isLoading = true
        do {
            let token = try await AuthService.shared.login(email: email, password: password)
            KeychainHelper.save(token, for: "auth_token")
            isAuthenticated = true
        } catch { self.error = error.localizedDescription }
        isLoading = false
    }
    
    func checkAuth() {
        isAuthenticated = KeychainHelper.read("auth_token") != nil
    }
}
```

---

## 🐛 SIK HATALAR → ÇÖZÜM
| Hata | Çözüm |
|------|-------|
| `Publishing changes from background` | @MainActor + Task { @MainActor in } |
| `NavigationLink deprecated` | NavigationStack + navigationDestination |
| `Preview crash` | Mock data + #Preview macro |
| `Keychain access error` | Entitlements → Keychain Sharing ekle |
| `async in View init` | .task { } modifier kullan |
| `ObservableObject not updating` | @Published var + objectWillChange |
| `Decode error` | CodingKeys + optional property |
| `Image not loading` | AsyncImage + placeholder |

---

## 🏁 BİTİRME CHECKLIST
```
- [ ] Proje Xcode'da build + run başarılı
- [ ] Auth (login + register + logout) çalışıyor
- [ ] API CRUD çalışıyor
- [ ] Loading / Error / Empty state var
- [ ] Dark mode çalışıyor (system automatic)
- [ ] iPhone + iPad uyumlu
- [ ] XCTest geçiyor
- [ ] Info.plist permissions açıklamalı
- [ ] App icon set edilmiş (Assets.xcassets)
- [ ] Launch screen var
- [ ] .gitignore var
- [ ] README.md var
```
