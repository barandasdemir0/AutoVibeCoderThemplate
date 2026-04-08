# 5️⃣ React - İzleme, Loglama ve Render Darboğazlarını Giderme (Debug)

> **ZORUNLU STANDART:** React'teki en büyük felaket, 1 saniyede "İstemeden" gerçekleşen 15 adet Render işlemidir. Yapay zeka kodu yazarken sadece Ekranda Göründü'ye aldanmayacaktır. Uygulama arkada kasıyorsa (Memory Leak, Too Many Re-Renders) o proje patlar. Tüm hatalar ve render durumları kontrol altına alınmalıdır.

---

## 🚫 1. Too Many Re-Renders (Darboğaz) Problemi

En sık karşılaşılan, tarayıcının kilitlendiği `Maximum update depth exceeded` hatasının 3 temel sebebi vardır ve AI otonom olarak bunlardan KAÇINMALIDIR:

1. ❌ **Doğrudan State Güncelleyen Fonksiyon (onClick Hatası):**
   ```jsx
   // FELAKET - Bu buton sayfa mount edildiğinde sonsuz döngü yaratır ve patlar.
   <button onClick={setCount(count + 1)}>Arttır</button>
   
   // DOĞRUSU - Bir ok fonksiyonu ile (callback) sarmak
   <button onClick={() => setCount(prev => prev + 1)}>Arttır</button>
   ```

2. ❌ **useEffect içinde Dependecy Olarak State'in Kendisini Vermek:**
   Fetch verisinden sonra setState yapıp, `useEffect([data])` yazdığınızda döngü tetiklenir (Veri değişir -> Effect Çalışır -> State Değişir -> Effect Çalışır). Derhal kaldırılmalıdır.

3. ❌ **Derin Obje/Dizi Karşılaştırmaları (Bozuk UseEffect Referansları):**
   Props olarak bir `{ config }` objesini her seferinde yeni bir obje olarak (Inline object `{{ title: 'Test' }}`) yolluyorsanız React her saniye Re-Render atar. Sabit objeleri component'in DIŞINA (Top level) veya `useMemo` içine taşıyın.

---

## ✅ 2. Hata Sınırları Kurulumu (Error Boundaries)

Bir React komponenti çöktüğünde ("Cannot read property 'map' of undefined"), varsayılan olarak BÜTÜN UYGULAMA BEYAZ EKRANA DÜŞER.
AI, Production ready bir sistem kodlarken **buna kesinlikle izin veremez**.

**Çözüm; ErrorBoundary Sarmalları:**
React Router V6'daki `errorElement` veya geleneksel `<ErrorBoundary>` (react-error-boundary modülü önerilir) paketleriyle sistemin çöken component dışındaki yerleri (Sidebar vs.) hayatta tutulmalıdır.
```jsx
import { ErrorBoundary } from 'react-error-boundary'

function ErrorFallback({error, resetErrorBoundary}) {
  return (
    <div role="alert" className="p-4 bg-red-50 text-red-900 border border-red-200 rounded">
      <h2 className="font-bold">Bileşen Yüklenirken Hata Oluştu</h2>
      <pre className="text-sm p-2 bg-red-100 mt-2">{error.message}</pre>
      <button onClick={resetErrorBoundary} className="mt-4 px-4 py-2 bg-red-600 text-white rounded">Tekrar Dene</button>
    </div>
  )
}

// Uygulamayı veya modülü koruyun
<ErrorBoundary FallbackComponent={ErrorFallback}>
  <ComplexDashboardWidget />
</ErrorBoundary>
```

---

## 📊 3. Sentry İle Global İzleme (Monitoring)

Yapay zeka "Console.log" diyerek sistem takip edemez. Proje üretime (Production) alındığında clientların browserlarındaki React hataları Datadog veya Sentry Dashboard'ına otomatik gönderilmelidir.

**Mükemmeliyetçi Standard:** AI'dan Projeye `@sentry/react` paketini kurdurup, `main.jsx` de initialize etmesini isteyin:
```javascript
Sentry.init({
  dsn: import.meta.env.VITE_SENTRY_DSN,
  integrations: [new Sentry.BrowserTracing(), new Sentry.Replay()],
  tracesSampleRate: 1.0, // Her performans kaybını kaydet
  replaysSessionSampleRate: 0.1, // Hata anlarında kullanıcının ekranını videoya kaydet
});
```

---

## 🚦 4. Geliştirici Ortamı (DevTools)

Geliştirme sırasında performans sızıntılarını otonom test etmek için yapay zeka kodun içine şu kalıpları yerleştirin:

* **React Developer Tools Profiler:** Profiler kullanılarak hangi bileşen kaç ms sürede render edildi görülmelidir.
* **Console.log Cleanup (Önemli):** İşi biten hiçbir Debugging console log komutu github'a, hele hele production ortama GİDEMEZ. Vite pluginleri (`babel-plugin-transform-remove-console` muadili ayarlamalar) ile build işleminde temizlenmesi kuraldır.
