# 2️⃣ Vanilla Web - DOM Manipülasyonu ve Pure Component (Kapsül) Mimarisi

> **MİMARİ KURALI:** Saf HTML/JS projelerinde "State (Durum)" yoktur. Değişken `a=5` olduğunda Ekranda "5" Yazmaz (React gibi değil). Manuel DOM güncellemeleri kaçınılmazdır. Ancak bu Güncellemeleri Otonom zeka "Oradan buradan" (`document.getElementById`) ile Gelişigüzel yapıyorsa PROJE SPAGETTİ ÇÖPÜNE DÖNER.

---

## 🏛️ 1. Gelişigüzel UI Güncellemelerinden Class-Based (Sınıf) Yapısına

Otonom model, büyük bir UI sistemi tasarlarken JS (Fonksiyon) yığınlarından KAÇMALIDIR. Object-Oriented (OOP) veya Pure Functional (Bileşen tarzı) yapılara geçmelidir.

### A. Facia Kodlama (Anti-Pattern)
```javascript
// HER ŞEY İÇ İÇE (BAKIMI ÇOK ZOR)
document.getElementById('saveBtn').addEventListener('click', async () => {
   const val = document.getElementById('inputH').value;
   const res = await fetch('/api', { body: val });
   document.getElementById('list').innerHTML += `<li>${res.v}</li>`;
});
```

### B. Mükemmel Otonom Component Kapsüllemesi (Encapsulation)
Vanilla JS'de Bir UI Parçasını (Örn: AlertBox) Tıpkı React bileşeni gibi Kapsülleriz.
```javascript
// ui/AlertBox.js
export class AlertBox {
    constructor(containerId) {
        // DOM Seçicisi kapsüllendi, dişarıya Çıkmaz!
        this.container = document.getElementById(containerId);
    }
    
    // UI Güncelleyen Metod!
    showError(msg) {
        this.container.innerHTML = `
            <div class="alert alert--error">
                <span class="alert__icon">⚠️</span>
                <p class="alert__text">${msg}</p>
            </div>
        `;
        // 3 Saniye Sonra Otonom Temizlik
        setTimeout(() => this.clear(), 3000);
    }

    clear() { this.container.innerHTML = ''; }
}

// app.js (Trafosfer ve Kullanım Noktasi)
import { AlertBox } from './ui/AlertBox.js';
const myAlert = new AlertBox('notification-root');
// Data Geldiğinde
myAlert.showError("Sunucu Hatası!");
```

---

## 🏗️ 2. Veri İstekleri (Fetch API) İzolasyonu ve Şekillenmesi

Vanilla kodunda `fetch()`'i try-catch içine sarmazsanız ağ kopukluğunda Sistem sessizce Ölür (Uncaught Promise).

* **Servis Otonomi Şartı:** Otonom Zeka projede `services/http.js` oluşturacak. Bu Tek sınıf, JSON Parse işlemlerini yapan, `response.ok`'u Doğrulayan ve BÜTÜN UYGULAMA İÇİN Tek bir İstikrar sağlayan noktadır!

```javascript
// services/http.js OTONOM ÇIKTISI!
export async function getJson(url) {
    try {
        const response = await fetch(url);
        if (!response.ok) throw new Error(`HTTP Error: ${response.status}`);
        return await response.json();
    } catch (e) {
        console.error("Fetch Intercepted:", e);
        return null; // Güvenli Sönümleme
    }
}
```

---

## 🚫 3. YASAKLI İŞLEMLER (Vanilla Web Anti-Patterns)

1. ❌ **Inline CSS ve HTML'e Event Gömmek (Cinayet):**
   ```html
   <!-- FELAKET (1995 Stili) - XSS Acıklarına Zemin Hazırlar! Bakımı Imkansız. -->
   <button onclick="saveData()" style="color:red;">Kaydet</button>
   ```
   *DOĞRUSU:* Otonom yapay zeka CSS'i external (Dış css dosyası) yazaar. Click eventlerini ise `app.js` üzerinden `.addEventListener('click', ...)` yöntemi ile DİNAMİK ASAR! (Seperation of Concerns - İlgi alanları ayrılığı Kuralıdır).

2. ❌ **InnerHTML += Düşmanlığı (Performance Killer):**
   Bir listede 10.000 Şehir Varsa ve Döngü İçinde `list.innerHTML += "<li>"` Yaparsanız Taryıcı Her döngüde DOM AĞACINI 10.000 Defa Yıkıp Yeniden ÇİZER! CPU %100 Olarak Patlar.
   *DOĞRUSU:* Otonom Zeka (Büyük Listelerde) Bir `String` değişkende Bütün HTML'i hazırlar (Birleştirir) Ve DÖNGÜ BİTİNCE Tek bir Kere `.innerHTML = stringVal` AtaYARAK Render işlemini Mükemmel hale Getirir! Veya `DocumentFragment` Kullanır.
