# 4️⃣ Frontend React - Test Dosya Mimarisi ve Co-Location Standardı

> **ZORUNLU DİZİLİM:** Projedeki test kodlarını gidip kök dizinde devasa bir `/tests` klasörünün içine yığarsanız (E2E hariç), 6 ay sonra o testin hangi Component'e ait olduğunu bulmak için projede kazı çalışması yaparsınız. React'teki mükemmel otonom standart "Co-Location" yani "Bitişik Dizilim"dir.

---

## 📂 En Kurumsal Yapı: Co-Location + İzole E2E

Sınama dosyaları kod ile GÖBEK BAĞLIDIR. Bir Card componentinin stili (`Card.module.css`), Mantığı (`Card.jsx`) ve Testi (`Card.test.jsx`) aynı yaprak klasörün altında yan yana durmak ZORUNDADIR.

```text
React-App/
├── src/
│   ├── components/
│   │   ├── ui/
│   │   │   └── Button/
│   │   │       ├── Button.jsx               # Bileşenin Kendisi
│   │   │       ├── Button.module.css
│   │   │       └── Button.test.jsx          # CO-LOCATION (RTL testleri) ✅
│   │   │
│   ├── features/
│   │   └── auth/
│   │       ├── components/
│   │       │   └── LoginForm/
│   │       │       ├── LoginForm.jsx
│   │       │       └── LoginForm.test.jsx   # İlgili klasörde beraber yatar ✅
│   │       │
│   │       └── api/
│   │           ├── authApi.js
│   │           └── authApi.test.js          # Sırf fetch yapıyor diye teste gerek yok deme,
│   │                                        # Interceptorları ve Hata fırlatmalarını test et!
│   │
│   ├── utils/
│   │   └── test-utils.jsx                   # Özel RTL Render Wrapper'ımız (Bkz: 02 Architecture)
│   │
│   ├── mocks/                               # SAHTE BACKEND (MSW)
│   │   ├── handlers.js                      # Intercepted Endpointler (rest.get('/users'))
│   │   ├── browser.js                       # Tarayıcı için setupWorker
│   │   └── server.js                        # Node (Vitest) env için setupServer
│   │
│   ├── vitest.setup.ts                      # Jest-Dom / MSW dinleyici kökü
│   └── main.jsx
│
├── e2e/             # 🚀 PLAYWRIGHT END-TO-END (BURASI AYRI!)
│   ├── tests/
│   │   ├── auth.e2e.test.js                 # Gerçek Chromium açılır, tıklana tıklana denenir
│   │   └── checkout.e2e.test.js
│   ├── page-objects/                        # (POM) Playwright kod tekrarını önleyen Otonom Modlar
│   │   └── LoginPage.js                     # await page.locator('input[name=username]') vs encapsülasyon
│   └── config/
│
├── playwright.config.ts                     # Headless ve Browser seçim ayarları
├── vitest.config.ts                         # Unit Test (RTL) ayarları
└── package.json
```

---

## ⚠️ Kritik Mimari Kurallar (Testing File Rulebook)

1. **E2E Dışarı, Unit İçeri:**
   * Unit ve Entagrasyon Testleri (Bileşene `<Button/>` diye doğrudan erişmesi gereken dosyalar) `src/` klasörü içinde varlığın hemen yanında (`.test.jsx` veya `.spec.jsx` diye) BULDURULUR.
   * End-To-End (Playwright) testlerinin yapısı uygulamayı bir localhost portundan "BlackBox" olarak gördüğü için, React yapısına karışmaz. Kök klasörde `e2e/` (veya `tests/`) dizininde Node testleri gibi dururlar. Kodun içine sokulmaları (co-locate) YASAKTIR.

2. **Dumb vs Smart Component Ayrımı Pratiği:**
   Unit teste yazarken Dumb (Aptal) komponentler (sadece UI çizenler) test edilmesi en kolay şeylerdir. Redux'a, React Query'ye bağlanmazlar. Çıplak componentlerdir. Eğer testine Provider giydirmeden hata almadığın parçalar varsa tebrikler, Clean UI Architecture kullanıyorsunuz demektir. Smart componentleri test etmek MSW vs Redux Provider zırhlarına GİRMEYİ zorunlu kıldığı için test dosyası kalabalık olacaktır.

3. **Page Object Model (POM) Zorunluluğu [E2E]:**
   Playwright içinde Otonom yapay zeka kod yazarken her `it` bloğuna `await page.locator('.btn-login')` DİZEMEZ! Uygulamada logon butonunun rengi veya id'si değiştiğinde 150 test aynı anda KIZARIR (Fail Verir).
   Hızlı Otonomi için E2E'lerin P.O.M mimarisinde, testlerin sayfa nesnesi nesnelerine (`await loginPage.login(user, pass)`) bağlandığı izole bir Page Objects altyapısı dizilmelidir.
