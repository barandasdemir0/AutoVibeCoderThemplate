## SEQUENCE-ENGINE v1 (ZORUNLU)
Bu template ile calisirken sirayi bozmak YASAK:
1) QUICK-START.md
2) 01-Planning.md
3) 02-Architecture.md
4) 03-StepByStep.md
5) 04-FilesStructure.md
6) 05-DebugTips.md
7) 06-Resources.md

Kural:
- Her dosyadan sonra 3-5 maddelik "cikarim ozeti" yaz.
- Ozeti yazmadan sonraki dosyaya gecme.
- 7 dosya tamamlanmadan kod uretimine baslama.
- Bu akisin detay standardi: Templates/_Universal/TEMPLATE-SEQUENCE-ENGINE.md

---
# ⚡ QUICK-START — Flutter Test Suite (Unit + Widget + Integration)

> AI'a sadece BU dosyayı + proje fikrini ver. Gerisini otonom yapacak.

---

## AI TALİMATI

Sen bir otonom AI geliştiricisisin. Kullanıcı sana mevcut bir Flutter projesinin test ihtiyacını verecek.
Hiçbir şey sormadan, aşağıdaki kurallara göre kapsamlı test suite'i oluştur.

---

## TECH STACK (SABİT)
- **Unit Test:** flutter_test (built-in)
- **Widget Test:** flutter_test + WidgetTester
- **Integration Test:** integration_test (E2E on device)
- **Mock:** mockito + build_runner (@GenerateMocks)
- **Fake HTTP:** http_mock_adapter veya mockito
- **Coverage:** `flutter test --coverage` + lcov

---

## TEST MİMARİSİ (ZORUNLU)
```
test/
├── unit/
│   ├── models/
│   │   ├── user_model_test.dart       → fromJson, toJson, copyWith, equality
│   │   └── [entity]_model_test.dart
│   ├── services/
│   │   ├── auth_service_test.dart     → login, register, logout (mocked)
│   │   └── [entity]_service_test.dart
│   ├── repositories/
│   │   └── [entity]_repo_test.dart    → CRUD operations (mocked)
│   └── viewmodels/
│       ├── auth_viewmodel_test.dart   → state changes, error handling
│       └── [entity]_viewmodel_test.dart
├── widget/
│   ├── screens/
│   │   ├── login_screen_test.dart     → render, input, tap, validation
│   │   ├── home_screen_test.dart      → list, loading, empty, error
│   │   └── [entity]_screen_test.dart
│   └── widgets/
│       ├── app_button_test.dart       → tap, disabled, loading state
│       └── app_text_field_test.dart   → input, validation
├── fixtures/
│   ├── mock_data.dart                 → Fake model instances
│   └── mock_responses.dart            → Fake API JSON responses
├── helpers/
│   ├── test_helpers.dart              → pumpApp, mockProviders
│   └── mocks.dart                     → @GenerateMocks output
└── mocks.dart                         → mockito codegen entry

integration_test/
├── app_test.dart                      → Full E2E flow
├── auth_flow_test.dart                → Register → Login → Logout
└── [entity]_crud_test.dart            → Create → Read → Update → Delete
```

---

## TEST YAZMA SIRASI
```
1. pubspec.yaml → dev_dependencies (flutter_test, mockito, build_runner, integration_test)
2. test/fixtures/mock_data.dart → Fake model instances
3. test/fixtures/mock_responses.dart → Fake JSON responses
4. test/helpers/test_helpers.dart → pumpApp wrapper (MaterialApp + providers)
5. test/mocks.dart → @GenerateMocks annotations
6. dart run build_runner build → mock dosyaları oluştur
7. test/unit/models/ → Model testleri (fromJson, toJson, copyWith)
8. test/unit/services/ → Service testleri (mock http client)
9. test/unit/repositories/ → Repository testleri (mock service)
10. test/unit/viewmodels/ → ViewModel testleri (mock repository, state kontrol)
11. test/widget/widgets/ → Widget testleri (render, tap, state)
12. test/widget/screens/ → Screen testleri (full screen render)
13. integration_test/app_test.dart → Full E2E
14. flutter test --coverage → Coverage rapport
```

---

## TEST PATTERN'LERİ

### Unit Test — Model
```dart
group('UserModel', () {
  test('fromJson creates correctly', () {
    final json = {'id': '1', 'name': 'Baran', 'email': 'b@t.com'};
    final user = UserModel.fromJson(json);
    expect(user.name, 'Baran');
    expect(user.email, contains('@'));
  });

  test('toJson returns correct map', () {
    final user = UserModel(id: '1', name: 'Baran', email: 'b@t.com');
    final json = user.toJson();
    expect(json['name'], 'Baran');
    expect(json, isA<Map<String, dynamic>>());
  });

  test('copyWith creates new instance', () {
    final user = UserModel(id: '1', name: 'Baran', email: 'b@t.com');
    final updated = user.copyWith(name: 'Updated');
    expect(updated.name, 'Updated');
    expect(updated.email, user.email); // unchanged
    expect(identical(user, updated), isFalse);
  });

  test('equality works', () {
    final u1 = UserModel(id: '1', name: 'A', email: 'a@b.com');
    final u2 = UserModel(id: '1', name: 'A', email: 'a@b.com');
    expect(u1, equals(u2));
  });
});
```

### Unit Test — ViewModel (mock repository)
```dart
@GenerateMocks([UserRepository])
void main() {
  late MockUserRepository mockRepo;
  late UserViewModel viewModel;

  setUp(() {
    mockRepo = MockUserRepository();
    viewModel = UserViewModel(repository: mockRepo);
  });

  test('fetchUsers updates state', () async {
    when(mockRepo.getAll()).thenAnswer((_) async => [mockUser]);
    
    await viewModel.fetchUsers();
    
    expect(viewModel.users, hasLength(1));
    expect(viewModel.isLoading, isFalse);
    verify(mockRepo.getAll()).called(1);
  });

  test('fetchUsers handles error', () async {
    when(mockRepo.getAll()).thenThrow(Exception('Network error'));
    
    await viewModel.fetchUsers();
    
    expect(viewModel.error, isNotNull);
    expect(viewModel.users, isEmpty);
  });
}
```

### Widget Test
```dart
testWidgets('LoginScreen shows validation error', (tester) async {
  await tester.pumpWidget(createTestApp(const LoginScreen()));
  
  // Submit empty form
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();
  
  // Expect validation errors
  expect(find.text('Email boş olamaz'), findsOneWidget);
  expect(find.text('gifre boş olamaz'), findsOneWidget);
});

testWidgets('LoginScreen calls login on valid form', (tester) async {
  final mockVM = MockAuthViewModel();
  await tester.pumpWidget(createTestApp(LoginScreen(viewModel: mockVM)));
  
  await tester.enterText(find.byKey(const Key('email_field')), 'test@test.com');
  await tester.enterText(find.byKey(const Key('password_field')), 'Test1234!');
  await tester.tap(find.byKey(const Key('login_button')));
  await tester.pumpAndSettle();
  
  verify(mockVM.login('test@test.com', 'Test1234!')).called(1);
});
```

### Integration Test (E2E)
```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full auth flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Navigate to register
    await tester.tap(find.text('Kayıt Ol'));
    await tester.pumpAndSettle();

    // Fill register form
    await tester.enterText(find.byKey(const Key('name')), 'Test User');
    await tester.enterText(find.byKey(const Key('email')), 'test@example.com');
    await tester.enterText(find.byKey(const Key('password')), 'Test1234!');
    await tester.tap(find.byKey(const Key('register_button')));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify home screen
    expect(find.text('Ana Sayfa'), findsOneWidget);
  });
}
```

---

## ⚠️ ZORUNLU KURALLAR
```
✅ HER ZAMAN:
- Her model: fromJson, toJson, copyWith, equality testi
- Her service: success + error case
- Her ViewModel: state transition testleri
- Her screen: render + interaction + validation testi
- Mock kullan → gerçek API/DB'ye bağlanma (unit/widget)
- group() ile organize et
- setUp/tearDown kullan
- Key() ekle test edilecek widget'lara
- pumpAndSettle() async işlemler için

❌ ASLA:
- Gerçek Firebase/API çağrısı unit test'te → mock
- Test dosyasız "bitti" deme
- sleep() kullanma → pumpAndSettle
- Hardcoded timeout → Duration parametresi
- Test'te print → expect assertion
```

---

## SIK HATALAR → ÇÖZÜM
| Hata | Çözüm |
|------|-------|
| `pumpAndSettle timed out` | Sonsuz animasyon var → pump(Duration) kullan |
| `No MediaQuery widget ancestor` | MaterialApp wrap'le → test_helpers.dart |
| `MissingPluginException` | Platform channel mock'la → setMockMethodCallHandler |
| `Type 'Null' is not subtype` | when().thenReturn → doğru return type |
| `Key not found` | Widget'a Key('name') ekle |
| `No widget found by text` | Text doğru mu? Büyük/küçük harf? |
| `Cannot find mock` | dart run build_runner build çalıştır |
| `Provider not found` | test_helpers'da MultiProvider wrap'le |

---

## BİTİRME CHECKLIST
```
- [ ] flutter test → tüm testler geçiyor
- [ ] flutter test --coverage → coverage dosyası oluşuyor
- [ ] Coverage %60+ (model + service + viewmodel)
- [ ] Unit testler: model + service + repository + viewmodel
- [ ] Widget testler: en az login + home screen
- [ ] Integration test: en az auth flow
- [ ] Mock data fixtures mevcut
- [ ] test_helpers.dart → pumpApp wrapper mevcut
- [ ] Tüm test dosyaları _test.dart ile bitiyor
- [ ] build_runner mock generation çalışıyor
```

