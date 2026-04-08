# 📋 Planning — Flutter Test Suite (unit + widget + integration)

## 🎯
- **Unit:** flutter_test (built-in)
- **Widget:** flutter_test + WidgetTester
- **Integration:** integration_test (E2E on device)
- **Mock:** mockito + build_runner
- **Coverage:** `flutter test --coverage`

## Paketler
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.0.0
  build_runner: ^2.0.0
  integration_test:
    sdk: flutter
```

## Klasör Yapısı
```
test/
├── unit/
│   ├── models/
│   │   └── user_model_test.dart    → fromJson/toJson
│   ├── services/
│   │   └── auth_service_test.dart  → Mock API
│   └── providers/
│       └── cart_provider_test.dart
├── widget/
│   ├── login_screen_test.dart      → Widget render + tap
│   └── product_card_test.dart
└── fixtures/
    └── mock_data.dart
integration_test/
└── app_test.dart                   → Full E2E flow
```

## Unit Test
```dart
test('User.fromJson creates correctly', () {
    final json = {'id': 1, 'name': 'Baran', 'email': 'baran@test.com'};
    final user = User.fromJson(json);
    expect(user.name, 'Baran');
    expect(user.email, contains('@'));
});
```

## Widget Test
```dart
testWidgets('LoginScreen shows email field', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    expect(find.byType(TextFormField), findsNWidgets(2)); // email + password
    await tester.enterText(find.byKey(Key('email')), 'test@test.com');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
});
```

## Integration Test (E2E)
```dart
void main() {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testWidgets('full login flow', (tester) async {
        app.main();
        await tester.pumpAndSettle();
        await tester.enterText(find.byKey(Key('email')), 'test@test.com');
        await tester.enterText(find.byKey(Key('password')), 'Test1234!');
        await tester.tap(find.text('Giriş Yap'));
        await tester.pumpAndSettle();
        expect(find.text('Dashboard'), findsOneWidget);
    });
}
```

## Debug + Resources
- **pumpAndSettle timeout** → async işlem bitmiyor, mock'a geçiş
- **Key not found** → widget'a `Key('name')` ekle
- **Mock HTTP** → `HttpOverrides` veya `mockito`
- Flutter Testing: https://docs.flutter.dev/testing | Mockito: https://pub.dev/packages/mockito
