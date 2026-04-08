# 🏗️ Architecture — SwiftUI iOS (MVVM)

## 🧱 MVVM
```
App/
├── Models/        → Data structures (Codable)
├── Views/         → SwiftUI Views
├── ViewModels/    → ObservableObject sınıfları
├── Services/      → API, Auth, Storage
├── Repositories/  → Veri erişim soyutlama
├── Extensions/    → Swift extensions
├── Utils/         → Helpers
└── App.swift      → @main entry
```

## MVVM Akışı
```
View (@ObservedObject) ←→ ViewModel (ObservableObject, @Published)
                              ↓
                         Service / Repository → API / CoreData
```

## State Management
```swift
// ViewModel
class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    
    func fetchUsers() async {
        isLoading = true
        users = try await UserService.shared.getAll()
        isLoading = false
    }
}

// View
struct UserListView: View {
    @StateObject var vm = UserViewModel()
    var body: some View {
        List(vm.users) { user in Text(user.name) }
            .task { await vm.fetchUsers() }
    }
}
```

## Property Wrappers
| Wrapper | Ne Zaman |
|---------|----------|
| `@State` | View-local basit state |
| `@Binding` | Parent → Child two-way |
| `@StateObject` | ViewModel ilk oluşturma |
| `@ObservedObject` | ViewModel dışarıdan alınıyor |
| `@EnvironmentObject` | App-wide shared state |
| `@AppStorage` | UserDefaults wrapper |

## Navigation
```swift
NavigationStack {
    List(items) { item in
        NavigationLink(item.name, value: item)
    }
    .navigationDestination(for: Item.self) { item in
        ItemDetailView(item: item)
    }
}
```
