# 2️⃣ React - Kusursuz Component Architecture ve İzolasyon

> **MİMARİ KURALI:** Eğer bir React sayfasında API'den veri çeken kod (`fetch/axios`), Veriye bağlı iş mantığı (`if data > 10`) ve Ekrana çizim kodu (`<div className="card">`) AYNI DOSYANIN İÇİNEYSE, o kod kötü koddur. Otonom yapay zeka bu 3 zarı (Data Fetching, Business Logic, Presentation UI) birbirinden BÖLMEK Zorundadır.

---

## 🏛️ 1. Container - Presentational Pattern (UI ve Logic Ayrımı)

Kurumsal React projelerinde 1 milyonluk trafiğin getirdiği kod kargaşasını yönetmenin anahtarı, Smart (Akıllı) ve Dumb (Aptal) bileşen mantığıdır.

### A. Container Component (Smart)
Sadece Data çeker, State yönetir, Servis fonksiyonlarını çağırır. Ancak Ekrana **HTML/Styling ÇİZMEZ**. Yaptığı her şeyi proplara doldurup Child bileşenlerine (Presentational) yollar.
```jsx
// UserListContainer.jsx
import { useQuery } from 'react-query';
import { fetchUsers } from '../services/userService';
import UserListView from './UserListView';

const UserListContainer = () => {
    // Sadece data fetch ve state
    const { data: users, isLoading, error } = useQuery('users', fetchUsers);
    const handleUserClick = (id) => console.log('User clicked:', id);

    // Ekrana veri ve aksiyonları paslama (UI ÇİZİMİ YOK)
    return <UserListView users={users} loading={isLoading} error={error} onAction={handleUserClick} />;
}
```

### B. Presentational Component (Dumb)
Hiçbir şekilde React Query, Axios veya Global Redux bağlamı taşımaz. Sadece kendisine dışarıdan gelen (Prop) veriyi HTML'e basar. Test etmesi kusursuz derecede kolaydır (Çünkü Dış bağımlılığı yoktur, MOCK data ile her an izole test edilir.)
```jsx
// UserListView.jsx
const UserListView = ({ users, loading, error, onAction }) => {
    if(loading) return <SkeletonLoader count={5} />;
    if(error) return <ErrorAlert message={error.message} />;
    
    return (
        <ul className="grid grid-cols-3 gap-4">
            {users.map(u => (
                <li key={u.id} className="card" onClick={() => onAction(u.id)}>
                    {u.name}
                </li>
            ))}
        </ul>
    );
};
```

---

## 🏗️ 2. Global State Engine (Zustand & Redux Toolkit)

Ağacın her yerine Props taşımak `Prop Drilling` denilen amansız bir zincir reaksiyonuna neden olur.

**Zorunluluk:** React'in kendi `Context API`'si, sık güncellenen veriler (Örn: canlı form data tracking, input değişimi) için kullanılamaz! Çünkü Context içindeki statelerden BİRİ değiştiğinde, onu Context'ten çeken TÜM BİLEŞENLER Yeniden Render olur (Büyük performans kaybı). Context sadece Tema (Dark/Light) veya Oturum (User Info) nadir değişen veriler için otonom kurgulanmalıdır.

**Küçük-Orta Ölçek (Zustand):**
AI için en az boilerplate ile State Yönetmek:
```javascript
import { create } from 'zustand'

export const useStore = create((set) => ({
  bears: 0,
  increasePopulation: () => set((state) => ({ bears: state.bears + 1 })),
  removeAllBears: () => set({ bears: 0 }),
}))
// Kullanım: const bears = useStore((state) => state.bears) // Sadece bears değişince render olur!
```

**Enterprise Ölçek (Redux Toolkit - RTK):** Çok kapsamlı, devasa Veritabanlı UI panellerde, asenkron `createAsyncThunk` destekli global slice kurguları mecburi yazılacaktır.

---

## 🚫 3. YASAKLI İŞLEMLER (React Anti-Patterns)

Otonom model bir UI kodu üretirken şunları IHLAL EDEMEZ:

1. ❌ **useEffect ile Data Fetching (Mount aşamasında Fetch):**
   React 18 ile birlikte `Strict Mode` açıkken useEffect component mount'ken 2 KERE çalışır (Race condition yaratır). Data fetch etmek için kütüphaneler (`SWR` veya `TanStack Query`) veya framework level (Next.js vs) destekler otonom sağlanmak zorundadır.

2. ❌ **useState içindeki Objelerde Mutasyon (Direct Mutation):**
   `state.user.name = "Ali"; setState(state);` YAPILAMAZ! React Shallow Compare yaptığı için adres değişmediğinden ui GÜNCELLENMEZ. Ekrana değerler yansımaz.
   *DOĞRUSU:* `setState({ ...state, user: { ...state.user, name: "Ali" } });` 

3. ❌ **Key olarak Index Vermek (`key={index}`):**
   Bir listeyi `.map()` ile dönerken `index`'i key olarak vermek performansı yıkar ve sıralama değiştiğinde inputları birbirine karıştırır. DAİMA DB'den dönen gerçek `.id` verilmelidir.

4. ❌ **Custom Hook kullanmaktan Kaçınmak:**
   Eğer componentin içinde 5'ten fazla `useState` ve `useEffect` biriktiyse, kod kirlenmiştir. Bunların hepsini `useProductForm()` adında izole bir custom hook dosyasına ayır ve componentin içine sadece `const { formData, errors, handleSubmit } = useProductForm();` bırak. Component TEMİZ kalsın.
