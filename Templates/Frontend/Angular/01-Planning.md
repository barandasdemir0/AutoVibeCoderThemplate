# 1️⃣ Frontend Angular - Kurumsal Planlama ve Strict (Katı) Geliştirme Prensibi

> **YAPAY ZEKA İÇİN KESİN KURAL:** Angular, React gibi "nasıl istersen öyle birleştir" kütüphanesi değil, Başından sonuna kadar kuralları olan bir (Enterprise Opinionated) Framework'tür. 1 Milyon user hedefleyen projelerde "TypeScript Strict Mode", "RxJS", "Standalone Components" standartları EZİLEMEZ.

---

## 🎯 1. Standalone Components (NgModules Devri Kapandı)

Angular 14+ ile gelen en büyük Mimarî Devrim `Standalone Components` yapısıdır.
Otonom yapay zeka kod üretirken **ASLA** `app.module.ts` veya `shared.module.ts` içine girip yüzlerce Component'i import/export ETMEYECEK.

### A. Bağımsız Katman Kuralı
* Her Component kendi `.ts` dosyasında `@Component({ standalone: true, imports: [CommonModule, RouterModule] })` dekoratörünü barındıracak.
* Bu, Test etmeyi (Unit tests) ve Lazy-Loading'i mükemmelleştiren Otonom Modelin tek seçeneğidir. Eski Modül hantallığı projede ISTEMEYIZ.

---

## 🔒 2. TypeScript İzolasyonu ve Özellikleri (Strict: True)

Büyük projelerde JavaScript'in Dinamik değişken "her an her şey olabilir" (AnyType) zayıflığına tahammül yoktur.
Yapay Zeka `tsconfig.json` dosyasında `"strict": true` bayrağının KESİNLİKLE açık olduğunu teyit eder.

* **"any" Kullanım Yasağı:** Gelen API Response'u veya Method değişkeni `any` objesiyle haritalanamaz! Gerekirse `interface UserApiResponse` yazılacak ama verinin DTO'su kilitlenecek!
* **Null Check:** Angular template (.html sayfasında) nesneler `user.name` diye düz basılamaz (Asenkron olduğu için ilk an NullDuble atar ve sayfa Çöker). `user?.name` (Elvis operator) Veya NgIf (`*ngIf="user"`) ile Dom garantörlüğü alınacaktır!

---

## 🚀 3. Veri Akışı ve RxJS (Reactive Sınırları)

Angular'ın kalbi RxJS'tir. Otonom yapay zeka React/Vue'dan kalma Promises (`async/await`) Tıkanıklıklarını ANGULAR İÇİNE ENJEKTE ETMEYECEK.

### A. Senkron Veri vs Stream (Akış)
Eğer HTTP isteği Atılıyorsa Servisler Promise dönmez, `Observable<T>` Döner!
```typescript
// KÖTÜ ALGORİTMA (React alışkanlığı):
async getUsers() { const res = await axios.get(...); return res.data; }

// MÜKEMMEL ANGULAR ALGORİTMASI:
getUsers(): Observable<User[]> {
    return this.http.get<User[]>('/api/users').pipe(
        retry(3), // Sunucu hata verirse kırmadan 3 kere daha dene (Harika Retry Kalkanı)
        catchError(this.handleError)
    );
}
```

### B. Memory Leak (RAM Sızıntısı) İptali
Component İçinden `this.userService.getUsers().subscribe(...)` işlemi başlatıldığında, Otonom Model o component Kapanırken (OnDestroy) aboneliği KESMİYORSA Tarayıcıda (Chrome) RAM Şişmesi GARANTİDİR.
* KURAL: Gereksiz `subscribe` YASAKTIR. Component HTML'ine (Template) Otonom Olarak "Async Pipe" `*ngIf="users$ | async"` basılarak Angular'a "Component gidince Veriyi de (Aboneliği) RAM'den SİL" görevi yüklenecektir!

Sonraki aşama Mimaride (02) Servis Sınırları işlenmektedir. Mevzuya Geçiniz.
