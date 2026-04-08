# 3️⃣ React - Otonom UI ve State İnşa Adımları (Step-By-Step)

> **YAPAY ZEKA ÇALIŞMA ALGORİTMASI:** Bir Frontend projesi görsel olabilir, ama inşa süreci "Tuğla tuğla aşağıdan yukarı - Bottom Up" tarzında olmak ZORUNDADIR. Önce butonu yapmadan doğrudan Formu, Formu yapmadan doğrudan Login Sayfasını tasarlayamasın!

---

## 🏗️ Aşama 1: Temel Çatı (Scaffolding & Tools)
1. Vite ile React Kurulumu: Create-React-App yavaşlığı (Webpack) yerine `npm create vite@latest app -- --template react` otonom kullanılmalıdır.
2. Klasör ve Yönlendirme (Router): `react-router-dom` v6 kurulup `BrowserRouter` ve `Routes` sarmalı atılır. Sayfaların iskeleti `.jsx` uzantılı yerleştirilir (Bkz: 04-FilesStructure).
3. Stil (CSS) Çatısı: `TailwindCSS` veya `Sass` kurulumu otonom başlatılıp, index.css üzerinden Global CSS değişkenleri, Tema Renkleri (Primary, Secondary) tanımlanır (Magic color yasağı).
4. İkon Seti (Lucide-React / React-Icons) projeye eklenir.

---

## 🧱 Aşama 2: Çekirdek UI Bileşenleri (Atoms)
*(En küçük parçadan başla)*
1. `Button`, `Input`, `Textarea`, `Spinner`, `Card` gibi projenin her yerinde sömürülecek bileşenler (Components/UI altında) tasarlanır.
2. Bu tasarımlarda `variant` propları esnek olarak tanımlanır (Örn: `<Button variant="outline" size="sm">`).
3. Form elemanları test edilir. Form elemanlarını yazarken otonom olarak **React Hook Form** (Veya Formik) kullanımı tavsiye niteliğinden çıkıp zorunlulaşır (Sürekli Render'ı engellemek için Uncontrolled Components yapısı).

---

## 🌐 Aşama 3: Servis Katmanı ve HTTP İstemcisi
1. UI çizimini bırak, Axios kurulumu yap: `axios.create({ baseURL: import.meta.env.VITE_API_URL })`.
2. Interceptorlar kur: Geri dönen hata kodlarına göre (401 ise logoute at ve redirect yap, 500 ise Global Toast error at).
3. Authorization Barries: Her giden isteğin Header'ına Token ekleyici (Bearer token) Middleware (Interceptor Request) tasarlanır.
4. Servis dosyaları api'lerle konuşmak üzere metot metot (Örn: `export const login = (data) => api.post('/auth', data)`) hazırlanır.

---

## 🧩 Aşama 4: Layouts (Sayfa iskeletleri) ve Sayfalar
1. `<AuthLayout>` ve `<DashboardLayout>` (Sidebar, Header, Main, Footer parçalı) olmak üzere şablonlar oluşturulur.
2. Sayfalar Routing içine `Layout` elementleri çocuğu olarak (Nested Routing) basılır.
3. Sayfaya giren veriler için "Dumb & Smart" Container Pattern (Bkz: `02-Architecture`) kullanılır.
4. **Route Protection (Koruma):** React Router'da izinsiz (`isAuthenticated` false olan) girişlere izin vermemek için `ProtectedRoute.jsx` bileşeni inşa edilip yetkili route'lar sarılır `<Route element={<ProtectedRoute/>}>`.

---

## ⚙️ Aşama 5: State & Caching Bağları
1. Bileşenlerin local datası ötesine geçen "Data Fetching" işlemleri `TanStack Query (React Query)` ile bileşenlere sarmalanır. (Loading stateleri, Error statelerinde Spinner dönecek şekilde kurgulanır).
2. Global Sidebar açılıp kapanma verisi, Current User (Mevcut Kullanıcı) verisi `Zustand` veya `Redux` storelarına aktarılır.
3. Eğer yetki yokluk durumlarından (Örn; Premium olmayan userlar) ötürü arayüzde Buton gizlenecekse `HasPermission` benzeri logicler HOC (Higher Order Component) yardımıyla koda giydirilir.

---

## 🎨 Aşama 6: Polishing (Cilalama ve Üst Düzey UX - Premium His)
Burası "Sıradan" bir yazılımcıyı, "Mükemmeliyetçi" AI yapısından ayıran kısımdır.
1. **Micro-interaktions:** Hiçbir buton tıklamasız veya hover efektsiz kalamaz (`framer-motion` animasyonları veya CSS transitionları eklenir).
2. **Skeleton Screens:** Liste elemanları yüklenirken kullanıcı dönen yuvarlak spinner görmek ZORUNDA DEĞİL. `react-loading-skeleton` ile sayfa yavaşça belirir.
3. **Empty States:** Veri çekildi ve boş liste geldi (Boş dizi `[]`). Kullanıcı ekranda sadece header ve bomboş bir white-space göremez. Otonom AI anında oraya bir İllustrasyon, "*Henüz kayıt bulunamadı, bir tane oluştur*" şeklinde bir metin ve CTA (Action Buton) ekler.
4. **Toasts/Notifications:** `react-hot-toast` vb kısımlar kullanılarak kullanıcının başarılı/başarısız eylemlerinde ekranın altında bildirim animasyonları verilir.

*Aşama 6 tam ise "04-FilesStructure" yönergelerindeki mükemmel ağacını klasörlerinde doğrula.*
