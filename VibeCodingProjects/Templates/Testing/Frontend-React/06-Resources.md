# 6️⃣ Frontend React - Test Altın Standart Paketleri (Ekosistem)

> Profesyonel, otonom bir AI sistemi bir C# projesi test ediyormuş gibi Frontend Appine yaklaşamaz. Tarayıcıda (DOM'da) çalışan Javascript'in kendi endüstriyel silahları vardır. Bu modüller Entegre edilmeden Otonom üretim YAPILAMAZ.

---

## 📦 1. Kilit Taşı Endüstriyel NPM Modülleri (ŞART Kütüphaneler)

### Test Runner & DOM Renderer (Çekirdekler)
* **`vitest`**: Eğer Vite kullanılıyorsa Jest YASAKLANMIŞTIR. Vite'in kendi nativ TypeScript destekli, Jest-uyumlu ancak kat kat hızlı test runner'i `Vitest` kullanılır. Otonom yapay zeka Jest komutları yazdığı (örneğin `jest.fn()`) tüm kodu doğrudan Vitest (`vi.fn()`) formatına çevirecek otonomiye DE SAHİP olmalıdır.
* **`@testing-library/react` (RTL)**: DOM üzerindeki manipülasyonlar ve Rendering işlemi için kullanılır. Componentleri Render atar ve Query'leri (getByRole vs) sağlar.
* **`@testing-library/user-event`**: Kullanıcı olayları sümülasyonudur. Event loopa birebir uygun davrandığı için `.type()`, `.click()`, `.hover()` operasyonlarında kullanılır (asenkron Promise tabanlı çalışır).
* **`@testing-library/jest-dom`**: Otonom zekanın `expect()` metotlarını Element bazlı (Görünüyor mu, HTML içinde mi) sorgulaması amacıyla genişleten custom matcherlar (Aksi takdirde string eşlemesine falan girmek gerekir).

### Network ve API Sahteleme (Ağ)
* **`msw` (Mock Service Worker)**: Mükemelin de üstü bir Ağ kesicidir. Axiosu Mocklayıp Sahte-Axios kodu yazmak "Ameleliktir". MSW, tarayıcıda veya Node ortamında çalışıp istek gidiyormuş gibi yaparak direkt "Ağ/Network" seviyesinde kesinti yapar! **Testlerde API Mocklama İşlemlerinin Vazgeçilmezidir.**

### End-To-End (Gerçek Kullanıcı Akışı)
* **`@playwright/test`**: Cypress'e göre çok daha yeni, Microsoft destekli ve "Tarayıcıları Bağımsız Paralel çalıştırabilen" Mükemmel E2E test sistemidir. Çok sayfalı Next.js veya React Router projelerinde Baştan Sona (Login -> Sipariş) süreçlerini Videoya ve Trace Viewer'a alarak CI/CD den gecirtir.

---

## 📡 2. Yapay Zekaya (AI Agent'ına) İstem Formülleri

Aşağıdaki istemler, size Flaky ve çamur testler değil, Gerçek "Aşılmaz Duvarlar" veren kalite çıktısı üretilmesini sağlayan otonomi formatlarıdır:

> "Bir E-Ticaret Sepet (Cart) Componenti için Unit ve Entegrasyon Testi yaz. **Zorunlu Kurallar:** 
> 1. Vitest ve React Testing Library kullanacaksın. 
> 2. Sepete Ekle Butonu testinde Butonu bulurken class id falan değil, Accessibility dostu `screen.getByRole('button', { name: /sepete ekle/i })` kalıbını ZORUNLU kullanacaksın.
> 3. Sepete Eklenen data Axios'a giderken `Axios.mock` KULLANMA! Bunun yerine `MSW (Mock Service Worker)` Rest kurgusunu `beforeAll` içine sar... Data gelene kadar ekranın Suspense (Skeleton) çizdiğini de `await waitFor` ile asert et!"

> "Uygulamanın Auth sürecini (Gerçek Backend ayakta varsayarak) test edecek bir Playwright senaryosu kurgula. **Rule:** Senaryo dümdüz 1 dosya olmasın, Page Object Model (POM) kurgusu inşa et, Element selectorlerini o Classta kapsülle."

---

## 🌍 Faydalı Kaynak Linkleri
* **[Kent C. Dodds - Common mistakes with React Testing Library]**: RTL'ın Yaratıcısı olan uzmandan "Bu kütüphaneyi yanlış kullanılıyorlar" isyanındaki en önemli blog postu. (Otonom AI'ın bu hataları yapması YASAKTIR: waitFor içinde setState vs kullanmak, async olmayan findBy yi queryBy gibi çekmek vs).
* **[MSW (Mock Service Worker) Official Docs]**: Network düzeyinde Intercept (Sahte İstek yakalama) mantığının resmi mimarisi.
