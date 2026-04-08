# 2️⃣ Frontend React - Test Mimarisi ve Setup İzolasyonu (RTL & MWS)

> **MİMARİ KURALI:** Eğer bir React UI testini (`ProductCard.test.jsx`) yazmak için dosyanın içine Provider'ları (`Redux`, `ThemeProvider`, `BrowserRouter`) TEK TEK importlayıp etrafına sarıyorsan, bu test mimarin DEHŞET KÖTÜDÜR. 100 component testinde 100 kere aynı kod tekrarına (Don't Repeat Yourself - DRY ihlaline) düşmüş olursun. Otonom AI, bu Setup altyasını izole etmek ÜZERE KOD yazar.

---

## 🏛️ 1. Test Setup Katmanı ve Özel Render (Custom Render)

React Testing Library (RTL) saf haliyle Redux veya Vite/React-Router bağlamlarını BİLEMEZ. Componenti izole sandboxta üretirken "useNavigate() may be used only in the context of a <Router> component." diye patlar. 

* **Çözüm (Mecburi Mimari):** 
Otonom Yapay Zeka `test-utils.jsx` adında bir Wrapper (Sarmalayıcı) dosya yazar. Orijinal RTL'in `render` metodunu ezer ve kendi render metodunu export eder.

```tsx
// src/utils/test-utils.tsx
import React from 'react'
import { render } from '@testing-library/react'
import { Provider } from 'react-redux'
import { MemoryRouter } from 'react-router-dom'
import { store } from '../store'

const AllTheProviders = ({ children }) => {
  return (
    <Provider store={store}>
      <MemoryRouter> {/* Local state routing için MemoryRouter kullanılır, gerçeği DEĞİL */}
        {children}
      </MemoryRouter>
    </Provider>
  )
}

// Render metodunu override et
const customRender = (ui, options) => render(ui, { wrapper: AllTheProviders, ...options })

// RTL içindekileri yeniden export et ki testlerde `screen` vb import edebilelim
export * from '@testing-library/react'
export { customRender as render }
```

Artık test yazarken `import { render } from '@testing-library/react'` DEĞİL, `import { render } from '@/utils/test-utils'` yapılacak. Component doğrudan `<Button />` test edilecek, arka plan kendiliğinden sarılı olacak.

---

## 🏗️ 2. Mocking (Ağ Katmanını Sahteleme) Mimarisi 

Axios veya Fetch ile dışarıya `https://api.site.com/users` sorgusu atan bir Componenti "O an API kapalıysa test patlar" diyerek çöpe ATMAMALISINIZ. Testler Deterministik olmalıdır (Her zaman aynı sonucu vermeli).

### A. MSW (Mock Service Worker) Kurgusu
AI otonom kodlama sürecinde MSW Setup'ını şu şekilde izole edecektir:
1. `src/mocks/handlers.js` içine REST veya GraphQL isteklerine verilecek "Sahte JSON" cevapları yazılacak.
2. `src/mocks/server.js` içine bu handlerlar bağlanacak (`setupServer(...handlers)`).
3. Testin `setupTests.js` konfigürasyon (Boot) dosyasında:
   ```javascript
   beforeAll(() => server.listen()) // Tüm testlerden önce ağı dinlemeye başla
   afterEach(() => server.resetHandlers()) // Her testte cachei temizle
   afterAll(() => server.close()) // Bittiğinde kapat.
   ```
Bu sayede Frontend kodu, "Ben sahte DB ile konuşuyorum" demez, gerçek API'ye çıkıyorum zanneder ama MSW araya girerek cevabı 10ms içinde döner.

---

## 🚫 3. YASAKLI İŞLEMLER (React Testing Anti-Patterns)

Otonom model test kodu üretirken şu kalitesizlikleri ASLA YAPMAYACAKTIR:

1. ❌ **TestID'lere Boğmak (`data-testid` Suistimali):**
   ```jsx
   // KÖTÜ
   expect(screen.getByTestId('submit-btn')).toBeInTheDocument();
   ```
   Eğer HTML etiketinde `role="button"` veya text olarak `"Gönder"` varsa "TestId" veremezsin. Engelli kullanıcılar (Ekran okuyucular) TestId'i göremez.
   *DOĞRUSU:* `screen.getByRole('button', { name: /gönder/i })`. Bu sayede aynı zamanda uygulamanın Accessibility (Erişebilirlik) skorunu otonom test etmiş olursun!

2. ❌ **`act(...)` Warninglerinden Kaçmak İçin Testi Atlamak:**
   React "An update to Component inside a test was not wrapped in act(...)" fırlattığında, Otonom sistem bunu görmezden gelemez veya sırf geçsin diye önüne `await new Promise(...)` gibi ucuz hackler atamaz. Data fetching işleminin sonlanıp ekrana çizilmesini `waitFor(() => expect(...))` veya `findByRole` kullanarak BEKLEMELİDİR.

Zihinsel altyapın tamamsa Aşama 03-StepByStep sürecinden Test kurgusunu inşa et.
