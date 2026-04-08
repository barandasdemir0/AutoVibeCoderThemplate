# 📱 MOBILE-ADVANCED.md — Mobil Uygulama İleri Konular

---

## 📴 Offline-First Mimarisi (Zorunlu Kural)

Uygulamanın internet bağlantısı koptuğunda "Bağlantı Yok" sayfası göstermek YASAKTIR. Uygulama "Offline-First" olarak kurgulanmalıdır.

### Strateji (Zorunlu)
```
1. Okuma (Read): UI her zaman Local DB'yi (SQLite/Hive) dinler. Asla doğrudan API'yi beklemez (Reactiveness).
2. Yazma (Write): İnternet yokken yapılan işlemler (örn: form yollama) bir "Local Queue" (Background Sync) tablosuna yazılır.
3. Sync: İnternet geldiği anda (Connectivity listener), Queue'daki işlemler arka planda Backend'e iletilir (Conflict resolution).
```

### Flutter (Örnek Mantık)
```dart
// Hive (key-value cache)
final box = await Hive.openBox('products');
box.put('products', jsonEncode(products)); // Kaydet
final cached = jsonDecode(box.get('products')); // Oku

// sqflite (SQL local DB)
final db = await openDatabase('app.db', version: 1, onCreate: (db, v) {
    db.execute('CREATE TABLE products(id INTEGER PRIMARY KEY, name TEXT, price REAL, synced INTEGER DEFAULT 0)');
});

// Connectivity check
final result = await Connectivity().checkConnectivity();
if (result == ConnectivityResult.none) { /* offline mode */ }
```

### React Native
```javascript
// AsyncStorage (basit cache)
await AsyncStorage.setItem('products', JSON.stringify(products));
const cached = JSON.parse(await AsyncStorage.getItem('products'));

// NetInfo (connectivity)
import NetInfo from '@react-native-community/netinfo';
NetInfo.addEventListener(state => {
    if (state.isConnected) { syncQueue(); }
});

// WatermelonDB (offline-first SQLite)
```

### Android (Kotlin)
```kotlin
// Room + Repository pattern
@Dao
interface ProductDao {
    @Query("SELECT * FROM products") fun getAll(): Flow<List<Product>>
    @Insert(onConflict = OnConflictStrategy.REPLACE) suspend fun insertAll(products: List<Product>)
}
// NetworkBoundResource → API if online, DB if offline
```

---

## 🔄 Uygulama Yaşam Döngüsü (App Lifecycle)

### Flutter
```dart
class MyApp extends StatefulWidget {
    @override
    _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
    @override
    void initState() { super.initState(); WidgetsBinding.instance.addObserver(this); }
    
    @override
    void didChangeAppLifecycleState(AppLifecycleState state) {
        switch (state) {
            case AppLifecycleState.resumed:    // Ön plana geldi → sync, refresh
            case AppLifecycleState.paused:     // Arka plana gitti → kaydet, timer durdur
            case AppLifecycleState.inactive:   // Geçiş anı (telefon geldi)
            case AppLifecycleState.detached:   // Uygulama kapanıyor → cleanup
        }
    }
}
```

### Android (Kotlin)
```kotlin
// Activity Lifecycle: onCreate → onStart → onResume → onPause → onStop → onDestroy
// ViewModel survives config changes (rotation, etc.)
override fun onResume() { super.onResume(); viewModel.refreshData() }
override fun onPause() { super.onPause(); viewModel.saveState() }
```

### iOS (SwiftUI)
```swift
@main struct MyApp: App {
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup { ContentView() }
            .onChange(of: scenePhase) { phase in
                switch phase {
                case .active:     // Ön plan → refresh
                case .background: // Arka plan → kaydet
                case .inactive:   // Geçiş
                }
            }
    }
}
```

---

## 🔔 Push Notifications & Lifecycle (Zorunlu Akış)

Uygulama arka plandayken gelen bildirimlerin yönetimi hayati önem taşır.
### Lifecycle Kuralları:
1. **Foreground (Açık):** Bildirim sesli olarak düşmez, data payload'ı okunup UI anında güncellenir (örn: Chat ekranındayken mesaj gelmesi).
2. **Background (Arka Plan):** Sistem bildirimi gösterir. Tıklanınca uygulama açılır ve "Deep Link / Router" ile ilgili ID'li sayfaya yönlendirir.
3. **Terminated (Kapalı):** Bildirime tıklanarak açıldığında `getInitialMessage` çağrılıp açılış rotası değiştirilmelidir.

### Firebase Cloud Messaging (FCM) — Tüm platformlar
```
1. Firebase Console → Cloud Messaging aç
2. Client: Uygulama açılışında FCM Token al, Backend'e yolla, User tablosunda `DeviceTokens` arrayine ekle.
3. Backend: Cihaza göre hedeflenmiş bildirim yolla (FCM API v1).
```

### Flutter
```dart
final fcm = FirebaseMessaging.instance;
String? token = await fcm.getToken(); // Token'ı backend'e gönder
FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
    // Foreground notification → local_notifications ile göster
});
FirebaseMessaging.onBackgroundMessage(_bgHandler); // Background
```

### React Native
```javascript
import messaging from '@react-native-firebase/messaging';
const token = await messaging().getToken();
messaging().onMessage(async remoteMessage => { /* handle foreground */ });
messaging().setBackgroundMessageHandler(async remoteMessage => { /* background */ });
```

---

## 💾 Cache ve Local Storage Güvenliği (Kritik)

| Veri Tipi | Nerede Saklanmalı? | Kural |
|----------|----------|----------|
| **JWT, Refresh Token, API Keys** | `flutter_secure_storage` (Keystore/Keychain) veya Encrypted SharedPreferences | Asla düz metin saklanamaz. |
| **Kullanıcı Ayarları (Tema vb.)** | `shared_preferences` / `AsyncStorage` | Hassas olmayan veriler. |
| **Offline Veri (Products, Chat)** | `sqflite`, `Moor`, `Realm`, `WatermelonDB` | Pagination destekleyen SQL/NoSQL DB. |

| Strateji | Açıklama | Ne Zaman |
|----------|----------|----------|
| **Cache-First** | Önce cache, expire olunca API | Değişmeyen veri (config, kategoriler) |
| **Network-First** | Önce API, fail olursa cache | Güncel veri önemli (timeline) |
| **Stale-While-Revalidate** | Cache göster, arka planda API | Hız + güncellik (listeler) |
| **Cache-Only** | Sadece cache | Offline mode |
| **Network-Only** | Sadece API | Real-time veri (chat, stock) |
