# 1️⃣ Frontend React - Test Planlama ve Strateji (Jest & Playwright)

> **YAPAY ZEKA İÇİN KESİN KURAL:** Test yazmak kodun kalitesini ölçmek değildir, kodun GELECEKTE bozulmasını engellemektir. React projelerinde "Snapshot test" çöplüğü fırlatmak yerine "User Interactions" (Kullanıcı etkileşimleri) ve E2E (Uçtan Uca) senaryolar otonom olarak kodlanmalıdır.

---

## 🎯 1. Test Piramidi ve React Uyarlaması

Bir React Front-end uygulamasını test ederken otonom geliştirici piramidi aşağıdaki yüzdelikte uygulayacaktır:

### A. Unit Tests (%60 Ağırlık) - Vitest / Jest
* **Odak Noktası:** Uygulamanın İş Mantığı (Business logic).
* **Neler Test Edilir?** Redux Reducer'lar, Zustand state güncellemeleri, Data mapleyen `Utils` (Hesaplama) fonksiyonları, Custom Hook'lar (örn. `useCart.js`).
* **Kural:** DOM'a, HTML'e dokunma! Sadece Girdi verirsen Çıktı ne olur bunu hesapla ve `expect(result).toBe(...)` ile eşle.

### B. Integration (Component) Tests (%30 Ağırlık) - React Testing Library (RTL)
* **Odak Noktası:** DOM ve Kullanıcı Davranışları.
* **Neler Test Edilir?** Butona tıklanıyor mu? Input'a değer girilince Error Text görünür oluyor mu? Data gelene kadar Skeleton basılıyor mu?
* **KURAL (YASAK):** Implementation Detail (Kod uygulamanın iç detayı) test EDİLEMEZ. Örneğin "Bu componentin state'i true oldu mu?" şeklindeki sorgular YASAKTIR. Kullanıcı sayfaya girdiğinde state bilmez, UI bilir. Test "Ekranda Hata yazısı belirdi mi?" `expect(screen.getByText('Error')).toBeVisible()` şeklinde yazılır!

### C. End-To-End (E2E) Tests (%10 Ağırlık) - Playwright VEYA Cypress
* **Odak Noktası:** Gerçek tarayıcıda kullanıcı deneyimi ve Akış (Flow).
* **Neler Test Edilir?** Login olma -> Sepete Ürün atma -> Satın Al butonuna basma -> Başarılı ödeme sayfasına geçiş. (Tam Tur Kritik Yol - Critical Path).

---

## 🔒 2. Mocking Stratejileri (Ağ Sahteleme)

React Component Testlerinde Gerçek Backend (API) kullanılamaz. Bütün dış bağlantılar "Kör Edilmelidir" (Mock).

1. **API İstekleri (MWS Doğrusu):** 
   Jest içerisinde `jest.mock('axios')` kullanarak spagetti test yazılmaz. Modern otonom Test Mimarisinde `MSW (Mock Service Worker)` kullanılır. Axios doğrudan ağa çıkar ama MSW tarayıcı ağ katmanının arasına girer ve API isteğine "Fake JSON (200 OK)" döner. Bu sayede test kodun network kütüphanesini değiştirmemiş olur.
2. **Global Provider'lar:**
   Eğer component'te Redux veya ThemeProvider kullanılıyorsa, `<Button>` tek başına render edilemez. AI, `CustomRender` fonksiyonu yazarak Redux Provider, Browser Router ve Theme Provider ile o componenti GİYDİREREK teste sokacaktır (RTL - RenderWithProviders pattern).

---

## 🚀 3. CI/CD'ye Otonom Adaptasyon

Testler sadece Local bilgisayarda yeşil (Pass) oluyorsa İŞE YARAMAZ. Otonom yapay zeka testi kurarken DevOps'u düşünür.

* Eğer Playwright kuruyorsan GitHub Actions (veya GitLab) YML test yollarını da (`npx playwright test`) entegre et. E2E testler "Headless" kurguyla çalışacak sekilde ayarlanmalıdır.
* Coverage: Testlerin Kapsamı %70'in altına düşüyorsa otonom test eksik yazılmış demektir. Coverage raporunu otonom zeka config (`vitest.config.ts`) üzerinde `coverage: { provider: 'v8', statements: 80 }` şeklinde ZORUNLU KILMALIDIR.

Testin planlaması Zihninde oturduysa Mimari ve Dosya dizimi kurallarına (02) geçiş yap.
