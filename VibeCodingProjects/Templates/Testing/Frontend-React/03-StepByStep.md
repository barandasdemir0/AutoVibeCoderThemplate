# 3️⃣ Frontend React - Adım Adım Otonom Test Eğitimi (Step-By-Step)

> **YAPAY ZEKA ÇALIŞMA ALGORİTMASI:** "Component Yaptım -> Hemen Testini Yazayım" şeklinde düşünmeyin. Önce Test ortamı, konfigürasyonu ve Mock ortamı eksiksiz şekilde Scaffold edilmeli, ondan sonra yaprak bileşenleri test etmeye başlanmalıdır. Test-Driven Development (TDD) veya Sonradan Test stratejisi fark etmez, sıralama aşağıdaki gibi OTO. çalışacaktır.

---

## 🛠️ Aşama 1: Konfigürasyon ve Test Çatısının Kurulumu (Vitest & RTL)
1. Vite altyapılı bir projede Jest ağırdır ve HMR (Hot Module) uyumsuzluğu çeker. Otonom yapay zeka Test Runner olarak **Vitest**, DOM Renderer olarak **@testing-library/react** kurar. Dom simülasyonu (Browser API'leri) için `jsdom` dev-dep'e atılır.
2. `vitest.config.ts` dosyası otonom olarak oluşturulur ve `environment: 'jsdom'` ve Setup dosya yolu (`setupFiles: './vitest.setup.ts'`) belirtilir.
3. `vitest.setup.ts` dosyasına `@testing-library/jest-dom` import edilerek `toHaveTextContent()` gibi expect uzantıları entegre edilir.

---

## 🗄️ Aşama 2: Custom Render (Providers) ve Mock Data Hazırlığı
*(Test yazmadan önce bağımlılıkları yokedin)*
1. `test-utils.jsx` dosyası oluşturulup içine (Varsa) MuiTheme, TailwindTheme veya Redux/Zustand Store sarmalı enjekte edilir. React Testing Library `render` metodu bu dosyadan override (ezilerek) çıkarılır. (Bkz: `02-Architecture`).
2. Sahte (Fake/Mock) objelerin olduğu bir Test Data klasörü açılır (Örn. `__mocks__/data/users.json`). Testlerin hiçbirinde hard-coded uzun stringler olamaz, sahte data buradan çağırılır.

---

## 🧩 Aşama 3: Pure Functions (Unit Tests)
*(Bağımlılıksız en küçük parçadan başla)*
1. Uygulamanın `utils/` klasöründeki (Örneğin: Sepet toplamını hesaplayan `calculateTotal.js`) saf fonksiyonlar `describe` bloğuna alınır.
2. `it('should calculate total price correctly', () => { ... })` şeklinde sınır durumları (Edge cases: boş array gönderilmesi, null gitmesi, eksi eksi fiyat gitmesi) hepsi test edilip %100 Branch Coverage'e çıkartılır.

---

## 🖥️ Aşama 4: Component Tests (UI Integration)
*(Şimdi ekranda Çizim Testi (Renderer) yapma vakti)*
1. Component dosyası `LoginForm.jsx` ise, yanına hemen `LoginForm.test.jsx` (Co-location) oluşturulur.
2. **Setup:** Render atılır (`render(<LoginForm />)`). 
3. **Action:** Kullanıcı simülasyonu başlatılır. Modern yöntemle `fireEvent` kullanılmaz. Daha gerçekçi olduğu için `userEvent.setup()` başlatılır ve `await userEvent.type(emailInput, 'test@abc.com')` ile klavye harfleri tek tek basılır. İnsan hissi.
4. **Assertion:** `await screen.findByRole('button')` butona tıklanılır. Error yazısı çıktı mı veya Yönlendirme (Redirect) tetiklendi mi diye `expect(...).toBeInTheDocument()` ile sınanır.

---

## 🛡️ Aşama 5: MSW ile Ağın Sahtelenmesi
1. Eğer test edilen bileşen (örn: `ProductList.jsx`) yüklendiğinde React Query üzerinden (`useQuery`) Backend'e gidiyorsa otonom AI gidip Server'ı BAŞLATMAZ.
2. MSW başlatılarak `rest.get('/api/products', (req, res, ctx) => res(ctx.json([mockProducts])))` ile trafik yakalanır.
3. Uygulamanın Spinner Loading statüsünden -> Success -> Card render aşaması sırayla Test senaryosunda izlenir. Mükemmel.

---

## 🤖 Aşama 6: Playwright (E2E) Kapsamının Gelişimi
*(Birimler çalışıyor, peki tüm mekanizma hatasız kayıyor mu?)*
1. `npm init playwright@latest` çalıştırılır. E2E klasörü oluşturulur.
2. E2E test dosyasının amacı "Gerçek bir kullanıcı gibi" davranmaktır. RTL gibi izole component değil, `await page.goto('http://localhost:3000/login')` diyerek tarayıcı (Chromium/Webkit) tam sayfa açılır.
3. Kritik Yol testleri (Kayıt, Login, Ödeme tamamlama) Chromium, Firefox ve Webkit motorlarında Headless şekilde çalıştırılarak CI/CD pipeline'ından geçmesine yetecek senaryosu çizilir.

Hazırsanız `04-FilesStructure` dosyasına geçerek klasörleme mantığını yerleştirin.
