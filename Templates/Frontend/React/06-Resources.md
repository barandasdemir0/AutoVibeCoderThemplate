# 6️⃣ React - İleri Seviye Kaynaklar ve Endüstriyel Paketler

> Profesyonel, otonom bir AI sistemi her Frontend problemini kendi "Vanilla React" mantığı ile (useEffect ve useState yığınları ile) çözmez. React ekosisteminin altın standart paketleri vardır. Kurumsal projelere bu paketler Entegre EDİLMEK ZORUNDADIR.

---

## 📦 1. Altın Standart NPM Modülleri (ŞART Kütüphaneler)

### State Yönetimi & Veri Senkronizasyonu (Veritabanı Okuma)
* **`@tanstack/react-query` (React Query)**: GET isteklerinin, `isLoading`, `error`, `isFetching` gibi durumlarını tamamen kendi yönetir. Ayrıca veriyi cache'ler. Bir proje React Query olmadan Data Fetch ediyorsa AI o projede HATA YAPIYORDUR.
* **`zustand`**: Global Store (Current User, Sidebar State, UI Teması) tutmak için. Redux Toolkit hantallığını (actions, reducers ayrımı) tek sayfada çözen modern, minimal hook tabanlı store yapıcısı.

### Form ve Validasyon Süreci
* **`react-hook-form`**: Onlarca state açıp `value={val} onChange={setVal}` yazmak (Controlled Components), Formlara basılan her tuşta tüm sayfayı RENDER EDER. Kasma yapar. Bu kütüphane refs yapısıyla performansı %300 arttırır.
* **`zod` ve `@hookform/resolvers/zod`**: Frontende kullanıcının girdiği e-posta gerçekten e-posta mı diye kontrol etmek için sunucuya gitmeyi BEKLEYEMEZSİN. Zod ile Frontend validationu bağlanmalı ve hatalar Input altlarına kırmızı basılmalıdır.

### Routing ve Navigasyon
* **`react-router-dom` (V6+)**: Standart. Mutlaka `<BrowserRouter>` değil, yeni özellikler olan `<RouterProvider router={router} />` objesi (createBrowserRouter) ile bağlanması mimarinin son sürüm (Loader & Actions destekli) olmasını sağlar.

### Stil, UI ve Sınıf Kombinasyonları
* **`tailwindcss`**: Otonom sistemlerin satır satır CSS yazıp ID çakıştırmaması için hızlı ve etkili Utility First CSS.
* **`clsx` ve `tailwind-merge`**: Sınıf (ClassName) kombinasyonlarında `<button className={\`text-red \${isActive ? 'bg-red' : 'bg-blue'}\`}>` gibi çirkin kodları engellemek için. İkisinin birleşimi olan `cn()` utility'si (Shadcn style) otonom yaratılmalıdır.
* **`lucide-react`**: Material İcons / Fontawesome hantallığı yerine premium, hızlı ikon paketi.

### UX (Kullanıcı Deneyimi) ve Animasyonlar
* **`framer-motion`**: Sayfaların donuk bir şekilde şak-şak açılması yerine, React render döngüsüne entegre Route transitionlar ve bileşen Fade-In'leri için standarttır.
* **`react-loading-skeleton`**: Kullanıcı bekletme sürecinde Skeletonlar sunmak için.
* **`sonner` veya `react-hot-toast`**: Sağdan, soldan çıkan premium Toast bildirim animasyonları için.

---

## 📡 2. Yapay Zekaya (AI Agent'ına) İstem Formülleri

Aşağıdaki istemler, sistemin size ekranda kasan değil, "Premium Akan" bir Front-end kalitesi sunmasını sağlar:

> "Bir React E-Ticaret Sepet Bileşeni yazmanı istiyorum. **Zorunlu Kurallar:**
> 1. Hiçbir useEffect kullanmayacaksın ve Sepete Ekle işlevlerini doğrudan componentin için DEĞİL, ayıracağın `useCart` (Zustand) veya `useQuery` içerisinden besleyeceksin.
> 2. Cart açıldığında bir `<Skeleton>` loading state göstereceksin.
> 3. Stil olarak sadece Tailwind kullan, inline style objesi kullanırsan görevi iptal edeceğim. Elementler Hoverlandığında `framer-motion` (whileHover) ile premium bir his yarat."

> "Şu an LoginForm'u kodluyorsun. Bana useState (`email, password`) zincirleri kurgulama. Formu `react-hook-form` ve `zodResolver` kullanarak oluştur. Hatalı e-posta formatı geldiğinde Butonun altında error mesajı (kırmızı, small text) otomatik renderlensin."

---

## 🌍 Faydalı Kaynak Linkleri
* **[Bulletproof React]**: Github üzerinde Alan-Agell'in tasarladığı, endüstride kalıplaşmış En İyi Mimari klasör rehberi. Component izolasyonu için ilham kayağıdır.
* **[Shadcn UI]**: Bağımsız NPM kurmak yerine, Radix Primitive + Tailwind + Framer motion birleşimi ile bileşenlerin direkt projeye kopyalanabilen yapısı (Otonom zeka için mükemmel bir rehberdir).
