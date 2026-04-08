# 🐛 Debug Tips — SwiftUI iOS

## ⚠️ Sık Hatalar

### Preview crash
→ `#Preview` macro syntax kontrol et
→ Mock data ver preview'a
→ Xcode restart (temizle ve yeniden build)

### "Type does not conform to Codable"
→ Tüm property'ler Codable uyumlu mu?
→ Custom `init(from decoder:)` veya `CodingKeys` gerekebilir

### Navigation çalışmıyor
→ `NavigationStack` root view'da mı?
→ `navigationDestination(for:)` modifier doğru mu?

### State güncellenmiyor
→ `@Published` property'de `objectWillChange.send()` çağrılıyor mu?
→ `@StateObject` (ilk sahip) vs `@ObservedObject` (aktarılan) doğru mu?

### "Publishing changes from background thread"
→ `await MainActor.run { }` veya `@MainActor` ViewModel'e ekle

### Async/await hatası
→ `.task { }` modifier ile async çağrı yap View'da
→ `Task { }` kullan event handler'da

## 🔍 Araçlar
| Araç | Kullanım |
|------|----------|
| Xcode Debugger | Breakpoint, LLDB |
| Instruments | Memory, CPU, Network profiling |
| SwiftUI Previews | Anında UI görüntüleme |
| Console | `print()`, `os_log` |
| Accessibility Inspector | VoiceOver test |

## 📓 Debug Günlüğü
| Tarih | Hata | Çözüm |
|-------|------|--------|
| [—]   | [—]  | [—]    |
