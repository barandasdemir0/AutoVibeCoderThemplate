# 📝 Step-by-Step — SwiftUI iOS

## Adım 1: Xcode → New Project → App → SwiftUI
- [ ] Proje oluştur → Run → Simulator test

## Adım 2: Model & Service
- [ ] `Models/User.swift` → `struct User: Codable, Identifiable`
- [ ] `Services/APIService.swift` → URLSession async/await

## Adım 3: ViewModel
- [ ] `ViewModels/UserViewModel.swift` → `ObservableObject`
- [ ] `@Published` properties
- [ ] async fetch methods

## Adım 4: Views
- [ ] `Views/UserListView.swift` → List
- [ ] `Views/UserDetailView.swift` → Detail
- [ ] Components: `ButtonView`, `CardView`

## Adım 5: Navigation
- [ ] `NavigationStack` + `NavigationLink`
- [ ] Tab view: `TabView`

## Adım 6: Persistence
- [ ] Core Data / SwiftData / UserDefaults

## Adım 7: Build
- [ ] Archive → App Store Connect

| Adım | Durum |
|------|-------|
| 1-7  | [ ]   |

# 📂 Files Structure
```
App/ (Models/, Views/, ViewModels/, Services/, Repositories/, Extensions/, Utils/)
App.swift, ContentView.swift
AppTests/, AppUITests/
```

# 🐛 Debug Tips
- **Preview crash** → `#Preview` macro syntax kontrol, mock data ver
- **"Type does not conform to Codable"** → Tüm property'ler Codable mı?
- **Navigation çalışmıyor** → `NavigationStack` root'ta mı?
- **State güncellenmiyor** → `@Published` + `@StateObject` doğru mu?
- **Araçlar:** Xcode Debugger, Instruments, SwiftUI Previews, Console

# 📚 Resources
| Kaynak | Link |
|--------|------|
| Apple SwiftUI | https://developer.apple.com/xcode/swiftui |
| Swift | https://swift.org |
| Hacking with Swift | https://www.hackingwithswift.com |
| SwiftUI by Example | https://www.hackingwithswift.com/quick-start/swiftui |
