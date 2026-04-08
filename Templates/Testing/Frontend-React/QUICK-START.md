# ⚡ Frontend React - OTONOM TEST MÜHENDİSLİĞİ (QUICK-START RULES)

> **DİKKAT YAPAY ZEKA:** EĞER BU PROJEDE FRONTEND İÇİN TEST YAZACAKSAN, DEVAM ATMADAN ÖNCE AŞAĞIDAKİ TDD (TEST DRIVEN) YAZILIM KANUNLARINI 1E1 ENTEGRE ETMEK ZORUNDASIN. BUNLARA UYACAĞINI ONAYLAMADAN ÜRETİME GEÇEMEZSİN. KODDA SENTEZLENMEMİŞ, JEST ÇÖPLÜĞÜ YARATAN BİR TEST GEÇERSİZDİR.

## 🚨 YASAKLAR LİSTESİ (ANTI-PATTERNS) - ASLA YAPMA!

1. ❌ **COMPONENT İÇİ DOM YAPISINI (HTML DETAILS) TEST ETMEK YASAKTIR:** 
   Otonom Zeka bir Unit test yazarken `<button class="red-btn">` diye ClassName yakalamayacak! `element.hasClass('red-btn')` gibi testler kırılgandır (Fragile). Yarın o class adı `blue-btn` olduğunda UI patlamamış dahi olsa test KIZARIR (Fail Verir).
   *DOĞRUSU:* React Testing Library (RTL) Felsefesi! Kullanıcının GÖRDÜĞÜNÜ VEYA YAPTIĞINI test et. `screen.getByRole('button', { name: "Oturum Aç" })` ile yakala.

2. ❌ **AXIOS VEYA FETCH İLE AĞA ÇIKMAK, GERÇEK VERİTABANINA DOKUNMAK YASAKTIR:** 
   Eğer Frontend içinde bir sayfa listelemesi (ProductList.jsx) test edilirken konsola `NetworkTimeout` hatası düşüyorsa, sistem gerçek Backend'e gidiyor demektir. Testi İPTAL ET! 
   Otonom Zeka KESİNLİKLE tüm Component-Level testlerde **MSW (Mock Service Worker)** kuracak, Backend'den sahte `[ {"id": 1, "name": "Apple"} ]` dönecek şekilde kalkanlayacak!

3. ❌ **ACT(...) UYARILARINI (ASENKRON YÖNETİMSİZLİĞİ) GİZLEMEK YASAKTIR:** 
   React RTL Testi sırasında konsolda "An update to Component was not wrapped in act" Kırmızı uyarısı varsa O Test ZAYIFTIR. Testi asenkron await'le beklememişsindir. Veri render edilmeden testi "Bitti" sanıp yeşile boyamışsındır!
   Zorunlu Çözüm: `waitFor()` veya `findByText` Kullan!

4. ❌ **E2E TESTLERİNİ APP KLASÖRÜNÜN İÇİNE KARIŞTIRMAK YASAKTIR:**
   Playwright ile yazılan E2E senaryolar (örn. `checkout.spec.ts`) React kodunun İçinde DEĞİL, en dış (Root) dizinde `/e2e` klasöründe tecrit edilecek.

5. ❌ **DUMB (APTAL) COMPONENTLERE GLOBAL KAPSÜL ATMAMAK YASAKTIR:**
   Eğer Redux/Zustand'a veya React Router'a bağlı (Link kullanan) bir bileşeni doğrudan `render(<Navbar />)` diye test edersen Context hatası verir! Tüm uygulamanın Testleri, senin baştan yarattığın (Içinde BrowserRouter ve ReduxStore barındıran) **CustomRender** metodu kullanılarak başlatılacak! (`import { render } from './test-utils'`)

---

## ✅ ZORUNLU TEST MİMARİ YAPISI (CO-LOCATION & ISOLATION)

Kod üretirken Testini Componentin YANINA as!

```text
/src
 ├── /features
 │    ├── /auth              
 │    │    ├── /components    
 │    │    │    ├── LoginForm.jsx
 │    │    │    └── LoginForm.test.jsx => ✅ CO-LOCATION BURADA!
 │    │    └── /utils         
 │    │         ├── validateEmail.js
 │    │         └── validateEmail.test.js
 ├── /mocks               => ✅ MSW ENDPOINTLERI VE SAHTE VERILER BURADA
 ├── /test-utils          => ✅ RTL CUSTOM RENDER METODU BURADA
 ├── vitest.setup.ts      => ✅ BEFOREALL / AFTEREACH (MOCK TEMİZLİĞİ) BURADA
```

---

## 🛠️ BAŞLAMADAN ÖNCE BİLMEN GEREKEN İLK ADIM

Eğer User sana "Formu test et" veya "Auth senaryosu yaz" diyorsa:
**BU DOSYA (QUICK-START)** seni bağlar. 

1. Başlangıçta Vite config üzerinden Test Coverage (`vitest --coverage`) yapılandır.
2. Sahte Data çekmesi için MSW Rest Endpoint'ini tak ve `handlers.js` içinden bağla.
3. User Event simülatörüyle formlara klavye ile Veri Cihazlan (`userEvent.type()`).
4. Ve Butona Bas (`userEvent.click()`).
5. Form Submit olduğunda Ekranda "Loading..." Skeletonun çıktığını Doğrula (`expect(screen.getByTestId('spinner')).toBeVisible()`).

**BİR SİSTEMİN KALİTESİ YAZILMIŞ KODDA DEĞİL, GELECEK HATALARI YAKALAYAN GÜÇLÜ OTONOM TESTLERDEDİR! BAŞLAYABİLİRSİN!**
