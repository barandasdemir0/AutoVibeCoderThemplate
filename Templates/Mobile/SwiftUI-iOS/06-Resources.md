# 📚 Resources — SwiftUI iOS

## 🔗 Dokümantasyon
| Kaynak | Link |
|--------|------|
| Apple SwiftUI | https://developer.apple.com/xcode/swiftui |
| Swift Language | https://swift.org/documentation |
| Apple Developer | https://developer.apple.com |
| Hacking with Swift | https://www.hackingwithswift.com |
| SwiftUI by Example | https://www.hackingwithswift.com/quick-start/swiftui |
| Stanford CS193p | https://cs193p.sites.stanford.edu |

## 📌 Snippets

### URLSession Async
```swift
func fetchUsers() async throws -> [User] {
    let (data, _) = try await URLSession.shared.data(from: URL(string: "\(baseURL)/users")!)
    return try JSONDecoder().decode([User].self, from: data)
}
```

### ObservableObject ViewModel
```swift
@MainActor
class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    
    func load() async {
        isLoading = true
        defer { isLoading = false }
        do { users = try await APIService.shared.fetchUsers() }
        catch { print("Error: \(error)") }
    }
}
```
