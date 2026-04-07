# 1️⃣ React - Mükemmeliyetçi Planlama (Component Based System)

> **YAPAY ZEKA İÇİN KESİN KURAL:** React bir "Framework" değil, UI Kütüphanesidir. Otonom yapıyla React kodu yazarken, "Bunu çalıştırayım yeter" mantığı ile tek bir sayfaya spagetti yığmak kesinlikle YASAKTIR. Uygulama, UI'ı State'den, Stili Logic'ten keskin sınırlarla ayırarak planlanmalıdır.

---

## 🎯 1. Proje Analizi ve İlk Yaklaşım

Projeye başlarken AI şu soruları cevaplamalı ve state haritasını çıkarmalıdır:
- **Routing İhtiyacı:** Sayfalar arası geçiş var mı? (`react-router-dom` v6 standardı kullanılacak).
- **Global State İhtiyacı:** Sadece ana sayfadaki bir veri mi? Yoksa Auth kullanıcısı ve Tema (Dark/Light) gibi her komponentin erişmesi gereken veriler mi var? (Büyük veri yığınları: Redux Toolkit, Daha spesifik / Küçük veriler: Zustand, Sadece local UI verisi: hook seviyesinde `useState`).
- **Veri Senkronizasyonu:** Sürekli değişen DB verisini mi okuyoruz? React'in built-in `useEffect` ini kullanıp State basmak yerine (Yasaklandı), `React Query (TanStack Query)` kullanılarak Server-State ve Caching yönetilmelidir.

---

## 💅 2. Stil Yönetimi ve "Inline CSS" Yasağı

React projelerinde Frontend geliştiricilerini delirten en büyük sorun, JSX'in stil ile karışmasıdır.
**KURAL:** Aksi User tarafından zorlanmadıkça `<div style={{ display:'flex', color:'red' }}>` formatında **INLINE STYLING KULLANILAMAZ.**

* CSS Modelleri:
  * **Seçenek 1 (Tailwind CSS):** Utility-first. Eğer kurulduysa, JSX classlarına gömülerek hızlı temiz UI çıkarılır. Ancak element çok şişerse `@apply` ile modülerleştirilir.
  * **Seçenek 2 (SCSS Modules):** `Button.module.scss` mantığı ile isim çakışmalarının önüne geçilir. Stil objesi olarak import edilir (`className={styles.btn}`). Modüllerle çalışmak enterprise zorunluluğudur.
  * **Seçenek 3 (Styled Components / Emotion):** CSS-in-JS kullanılacaksa en tepede değil, özellik dosyası altında izole yazılır.

---

## 🔄 3. State ve Side-Effect Stratejisi

React'te bir bileşen renderlandığında "Side-Effect" (İkincil Etki: Veritabanından veri çekme, event dinleme) stratejisi çok iyi kurulmalıdır.

### A. useEffect Cehennemini Önlemek
AI bir bileşen (Component) yüklendiğinde (`componentDidMount` muadili) API atmak için `useEffect` yazıyorsa, Dependency Array'lerini (`[]`) hatasız yönetmek ZORUNDADIR.
- Eğer bir fetch işlemi varsa, cleanup fonksiyonu (AbortController ile iptali) KESİN eklenmelidir. (Kullanıcı veriler gelirken sayfadan çıkarsa Memory Leak olur).
- *Modern React Çözümü:* `useEffect` içine data fetch yazmak Anti-pattern olmaya başladı. AI, **SWR** veya **TanStack Query** kurarak `const { data, isLoading } = useQuery(...)` kullanmayı otonom tercih etmelidir. 100k+ kullanıcıya hizmet veren projede caching hayatidir.

---

## 🧩 4. Atomic Design & Reusability (Tekrar Kullanım)

Eğer bir UI parçası 2 kereden fazla kullanılacaksa, onu bir component yapmak ZORUNDASINIZ.
* Bir Sayfa `LoginPage.jsx` 500 satır olursa iptal edin.
* Onu şu bileşenlere ayırın: `<AuthLayout>`, `<LoginForm>`, `<InputGroup>`, `<Button>`.
* **Prop Drilling Önlemi:** Bir veri, dede componentinden torununun-torununa 5 katman prop olarak geçemez (Prop Drilling Yasağı). Bunu yönetmek için `Context API` veya Global Store (Zustand/Redux) kullanılacaktır.

---

## 🚀 5. Performans Darboğazları (React Rendering)

1 milyon kullanıcılı sistemlerde Frontend'inizin cihazı dondurmaması için AI şunları optimize edecek:
* **Useless Renders (Gereksiz Render'lar):** Bir bileşen State değiştirdiğinde çocukları da renderlanır. Ağır listeler (Pagination içeren 100 satır veri) `React.memo` ile sarılmalıdır.
* **Ağır Fonksiyonlar:** İçerisinde sıralama/matematik hesabı çalıştıran Data filtrelemeleri `useMemo` ile Cache'lenmelidir.
* **Fonksiyon Referansları:** Child componente event (onClick metodu vb.) passedilirken referans kopmasını önlemek için `useCallback` zorunludur.

Eğer Component render'ı sırasındaki felsefe kafanda oturduysa Mimari / Katman dizilimi bölümüne (02) geçebilirsin.
