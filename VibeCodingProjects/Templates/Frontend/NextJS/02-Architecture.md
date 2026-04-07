# 2️⃣ Next.js - Server Component ve Client Component Ayrımı (RSC)

> **MİMARİ KURALI:** Next.js App Router miamrisini ezen temel devrim React Server Components (RSC)'dir. Otonom yapay zeka bir yaprak (Leaf) componenti tasarlarken bunun Sunucuda mı İstemcide mi render edileceğini kuralına göre izole etmek ZORUNDADIR. Aksi halde uygulamanızın boyutu megabaytlara tırmanır.

---

## 🏛️ 1. İzolasyon Prensibi (Sunucu ve İstemciyi Ayırmak)

### A. Server Components (Kral Katman / Varsayılan Katman)
Eğer bir dosyada en üste `'use client'` YAZMIYORSAN, o component otomatik Server Component'tir. 
* **Sorumluluğu:** Veritabanına (Prisma, Drizzle) doğrudan bağlanır, API Key'ler taşır, Ağır kütüphanelerle (Markdown parser, Date formatter) işlem yapar. İşlemi bitince sonucu düz HTML'e çevirir ve Frontend'e yollar.
* **YAPAMAYACAĞI ŞEYLER:** Kullanıcı tıkını (onClick), TextInput'taki (onChange) eventleri DİNLEYEMEZ. React Hooklarını (useState, useEffect, useContext) KULLANAMAZ.

### B. Client Components (Interaktif Katman)
En tepeye `'use client'` eklenerek oluşturulan interaktif buton veya formlar.
* **Sorumluluğu:** Ekranda dinamik bir slider çevirmek, kullanıcının "Sepete Ekle" tuşuna basmasını dinlemek, Form yönetmek (react-hook-form ve zod ile).
* **YAPAMAYACAĞI ŞEYLER:** Prisma/DB fonksiyonlarına doğrudan DOKUNAMAZ (Eğer dokunursan Database şifren JS bundle ile herkese açık clienta gider).

---

## 🚫 2. Sık Yapılan En Kritik Hata (Poisoning)

Yanlış: Otonom AI, bir Page.tsx içine hem Veritabanı sorgusu (`await db.users.find()`) yazıp HEM DE bir buton tıklaması dinleyebilmesi için en üste `'use client'` ekler!
*SONUÇ:* Sayfadadaki DB komutu tarayıcıya renderlenemez. Tarayıcıda (Browser) fs modülü ve veritabanı yolları patlar, sistem HATA VERİR.

**DOĞRUSU (Interleaving Pattern / Props Passing):**
Veriyi Server Component'te (`page.tsx`) çekersin. Sadece butonu veya Slider'ı farklı bir client dosyasında (`SaveButton.tsx`) yazarsın. Veriyi ServerComponent'ten `SaveButton`'a SADECE PROP OLARAK YOLLARSIN. 

```tsx
// 1. Server Component (app/page.tsx)
import { db } from '@/lib/db'
import LikeButton from './LikeButton' // <-- Client component

export default async function Page() {
   // DB çağrısı Server'da gizlice yapılır.
   const product = await db.products.findFirst() 
   
   return (
       <div>
         <h1>{product.name}</h1>
         <LikeButton productId={product.id} />
       </div>
   )
}
```

```tsx
// 2. Client Component (app/LikeButton.tsx)
'use client'
import { useState } from 'react'

export default function LikeButton({ productId }) {
  const [likes, setLikes] = useState(0)
  return <button onClick={() => setLikes(e => e + 1)}>Like {productId}</button>
}
```

---

## 🏗️ 3. Data Transfer Objects (DTO) ve Server Boundaries

Server üzerinden Client'a gönderilecek (Prop olarak paslanan) tüm nesneler **SERIALIZABLE (Serileştirilebilir - düz Json uyumlu)** olmak ZORUNDADIR. 

MongoDB (Mongoose) veya Prisma kullanırken Server bileşeninden gelen objenin içinde gizli metodlar (Örn: Modelin kendi `user.save()` metodu veya `Date` instanceları) olursa bunu prop yapıp `<ClientForm user={user} />` derseniz Nextjs "**Warning: Only plain objects can be passed to Client Components**" diyerek ÇAKILIR.

**ÇÖZÜM:** Veri Client'a prop inmeden önce Plain JSON'a dönüştürülecek, `Object.assign({}, user)` veya `JSON.parse(JSON.stringify(user))` metodlarıyla sterilize edilecek ya da Maplenecektir.

---

## 🔌 4. Server Actions (Form İşlemleri)
Next.js v14+ versiyonunda API rotası açmadan direk HTML formlarından Database Update mantığı standarttır. 

```tsx
// app/actions/userActions.ts
'use server'

import { revalidatePath } from 'next/cache';
import db from '@/lib/db';

export async function createUser(formData: FormData) {
   const name = formData.get('name');
   // DB işlemi...
   await db.user.create({ data: { name } });

   // Anasayfa DB değiştiği için cache iptal olsun ve refreshlensin!
   revalidatePath('/'); 
}
```

Yapay zeka bunu `use server` eylem dosyasına yazdıktan sonra Frontend formunun action atribütüne direkt verecektir (`<form action={createUser}>`). Geleneksel Submit-Axios mantığının üzerine Otonom olarak bunu kodlamalısın.
