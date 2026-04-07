# 5️⃣ Frontend React - Otonom Test Hata Giderme ve Coverage İzleme (Debug)

> **ZORUNLU STANDART:** Testlerin Fail (Kırmızı) olması değil, Flaky (Bazen Kırmızı Bazen Yeşil) olması tehlikelidir. Yapay Zeka Testleri asenkron state (Fetch) süreçlerine mükemmel uyumlu halde, Deterministik yazmakla Mükelleftir.

---

## 🚫 1. Flaky Testler (Bazen Geçip Bazen Kalan Testler)

Asenkron test operasyonlarında React state batching süreci sebebiyle en sık karşılaşılan Otonom Hataları ve Çözümleri:

1. ❌ **Görünmeyen veya Henüz Mount Olmamış Elementi Zorlamak:**
   ```jsx
   // FELAKET - Veritabanından (Mock'dan) veri 100ms gecikmeyle geliyorken ekranda listeyi hemen aramak!
   render(<ProductList />);
   expect(screen.getByText('Iphone 15')).toBeInTheDocument(); // YANLIŞ: Patlar! Elements NotFound.
   ```
   *DOĞRUSU:* React Testing Library (RTL) Asenkron bekleyicisi (`findBy...`) veya `waitFor` atılmalıdır.
   ```jsx
   render(<ProductList />);
   // findBy query'si, element DOM'a düşene kadar Promise bekler. Bu OTONOM ZORUNLULUKTUR!
   expect(await screen.findByText('Iphone 15')).toBeInTheDocument(); 
   ```

2. ❌ **FireEvent ile UserEvent Karmaşası:**
   Otonom kod yazarken tuşa basma komutunda `fireEvent.change(input, { target: { value: 'a' }})` kullanmak "Birebir" tarayıcı hissini yakalamaz (Sadece Event Fırlatır, klavye basma sırasındaki onKeyDown, onKeyPress tetiklenmez).
   *DOĞRUSU:* Otonom Zeka `import userEvent from '@testing-library/user-event'` kullanarak `await userEvent.type(input, 'a')` demelidir. Tam Simulasyondur.

3. ❌ **Test Sızıntıları (Leaking State):**
   Test #1 Redux'daki State'i sepet = 1 yaptı. Test #2 başladığında Sepet 1'den başlarsa test fail olur. "Testler birbirinden %100 YALITILMALIDIR". Testlerde her `it()` bittikten sonra (`afterEach`) Redux Store resetlenmeli, MSW Handlerları clear edilmeli ve LocalStorage boşaltılmalıdır. Otonom yapay zeka `setupTests.js` içinde `afterEach(() => { cleanup(); vi.clearAllMocks(); })` yazmadan Test Kurgusunu BİTİREMEZ.

---

## 💥 2. React `act()` Warnings (Meşhur Render Uyarısı)

Eğer terminalde şu kırmızıyı görürsen:
`Warning: An update to Component inside a test was not wrapped in act(...)`

Bunun sebebi component'inizin testinizdeki Assert (test Bitti demesi) safhasından SONRA bir şeyleri hala State'e kaydediyor olmasıdır. (Örn: Fetch Promise'i Resolve olmuş, ama senin testin çoktan yeşil yanıp kapanmış ve react memory leak yaşatıyor).
**Otonom Çözüm:** State veya Fetch asenkron işlemlerinin son landığını (örn, Skeleton kaybolup Listbox geldiğini) the `waitFor(() => expect(...).toBeInTheDocument())` ile test bitiminden HEMEN ÖNCE teyitlemek. 

---

## 📊 3. Code Coverage (Test Kapsamı) Kurgusu

Yazılan testlerin "Projede ne kadarlık yeri test ettiğini" (Hiç girilmemiş if blogları vs var mı) ölçmek zorunludur.

1. **Vite + Istanbul/v8 Entegrasyonu:**
   Otonom AI, `vitest` command'ına `--coverage` parametresi atar ve Projenin bir klasöründe HTML tabanlı bir Coverage Raporu çıkartır.
2. **Kabul Sınırı (Threshold):** Mükemmeliyetçi üretimde `vitest.config.ts`'te `%80` kapsama standartı Getirilecektir. Eğer Kod Test Kapsamı %80'in altındaysa Continuous Integration (Pipeline) çökecek ve Deployment gerçekleşmeyecektir! (Daha yüksek yapma, TDD saplantılarına girip gereksiz CSS/Type satırlarını test etmeye çalışma).

Eğer Hatalardan Sağ Kurtulduysan Kaynak Modüllere(06) Bak.
