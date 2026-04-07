# 2️⃣ Frontend Angular - Smart (Akıllı) ve Dumb (Aptal) Bileşen Mimarisi

> **MİMARİ KURALI:** Eğer bir Angular Component dosyasında (`ProductList.ts`) hem HttpClient ile Server'a Select atan bir Kod (`this.http.get()`) Varsa ve hem de O Bileşenin HTML sinde CSS Class'ları, Tablolar ve Buton tasarımları Havada uçuşuyorsa, O YAPININ MİMARİSİ ÇÖPTÜR! Angular Service-Driven (Servis Odaklı) bir mimaridir.

---

## 🏛️ 1. İzolasyon: Container ve Sunum Katmanları (Presentation Pattern)

### A. Smart / Container Components (Ana Sayfa)
Bu bileşenler Veritabanına uzanan Servislerle muhataptır (`constructor(private userService: UserService)`). Ancak kendi HTML dosyalarında GÖRSEL ÇİZMEZLER! Tıpkı Bir Orkestra şefi gibi Data'yı Çeker, Async Pipe ile Dumb Bileşenlerin (Düğmeler, Tablolar) içine fırlatırlar!

```typescript
// users-container.component.ts (YALNIZCA DATA TRAFİĞİ)
@Component({
  selector: 'app-users-container',
  standalone: true,
  imports: [UserListComponents, AsyncPipe],
  template: `
     <!-- HTML YOK!! Sadece Data'yı Dumb Component'e PASLAMA VAR! -->
     <app-user-list 
         [users]="users$ | async" 
         (onDelete)="handleDelete($event)">
     </app-user-list>
  `
})
export class UsersContainerComponent {
    users$ = this.userService.getAll(); // RxJs Data Akışı
    
    constructor(private userService: UserService) {}

    handleDelete(userId: number) {
        this.userService.delete(userId).subscribe();
    }
}
```

### B. Dumb / Presentational Components (UI Atomları)
Bu Bileşen HİÇBİR Servisi Bilmez (`import UserService` YAPAMAZ YASAKTIR). Yalnızca kendine `@Input()` ile Gelen veriyi (Örn Users Dizisi) alıp Kusursuzca HTML'e (NgFor) çizer. Bir Butona Tıklandığında O Butonun İşlemini de YAPAMAZ! Tıklanıldığını Anlar ve Üst'e Haber yollar `@Output() onDelete = new EventEmitter<number>()`. Sadece Şekildir (HTML).

---

## 🏗️ 2. Global State Yönetimi (NgRx Signal Store - v17+)

Büyük Projede (Admin panelinde) Sağ Üstteki UserAvatar'ından Gelen Veriyi, Gidip Sipariş sayfasında da Kullanacaksak Veriyi Tekrar Feth ETME (DB'YE GİTME).
* **Klasik Çözüm (Service ile Subject):** `BehaviorSubject` içinde veriyi Tutar, Servisten her yerden Oku ve Değiştir. (Küçük projede yeterli).
* **Enterprise Otonom Çözüm (Signals):** `NgRx SignalStore` Otonom zeka Tarafından sisteme eklenecek. Angular Signals, RxJS'in gereksiz asenkron karmaşasını Bitiren (React useState gibi Synchronous okunabilen) son Otonom mimarisidir!!
  ```typescript
  // store.ts (v17+ Signals Store Örneği)
  export const UserStore = signalStore(
    withState({ user: null, loading: false }),
    withMethods((store) => ({
      updateUser(user: User) { patchState(store, { user }) }
    }))
  );
  ```

---

## 🚫 3. YASAKLI İŞLEMLER (Angular Anti-Patterns)

Otonom model kod üretirken şu "Framework-Bozan" komutlardan KAÇACAKTIR:

1. ❌ **Doğrudan DOM Manipülasyonu (NativeElement Hantallığı):**
   ```typescript
   // FELAKET - Tarayıcı (Window) nesnesine doğrudan erilir. SSR (Server Side Rendering) Çöker!
   document.getElementById('myBtn').style.color = 'red';
   ```
   *DOĞRUSU:* Angular Veri-Güdümlüdür (Data-Driven). Dom elementini değiştirmek SADECE Model ile veya `Renderer2` servisi ile Yapılır! `<button [ngClass]="{'is-red': hasError}">` KURALDIR.

2. ❌ **HTML (Template) İçinde Fonksiyon Çağırmak (Change Detection Katliamı):**
   ```html
   <!-- FELAKET: Ekranda mouse'u Kımıldattığında Bu Fonksiyon Saniyede 10 Kere Çalıştırıp Sistemi DONDURUR! -->
   <h1>{{ calculateHeavyPrice(obj) }}</h1>
   ```
   *DOĞRUSU:* Angular Change Detection (Sürekli Ekran yenileme tarayıcısı) çalışırken Template içindeki foksiyonları Hep Tetikler. Bu tür Veri (Data Hesaplama ve Transformasyonları) Kesinlikle **Custom Angular Pipe'ları** (`| currencyPrice`) Yazılarak Halledilmelidir. Otonom sistem Buna Riayet Edecektir!
