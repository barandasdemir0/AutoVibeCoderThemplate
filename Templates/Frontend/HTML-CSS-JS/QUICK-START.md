## SEQUENCE-ENGINE v1 (ZORUNLU)
Bu template ile calisirken sirayi bozmak YASAK:
1) QUICK-START.md
2) 01-Planning.md
3) 02-Architecture.md
4) 03-StepByStep.md
5) 04-FilesStructure.md
6) 05-DebugTips.md
7) 06-Resources.md

Kural:
- Her dosyadan sonra 3-5 maddelik "cikarim ozeti" yaz.
- Ozeti yazmadan sonraki dosyaya gecme.
- 7 dosya tamamlanmadan kod uretimine baslama.
- Bu akisin detay standardi: Templates/_Universal/TEMPLATE-SEQUENCE-ENGINE.md

---
# ⚡ Vanilla Web (HTML/CSS/JS) - OTONOM BEYİN (QUICK-START & MASTER RULES)

> **DİKKAT YAPAY ZEKA:** EGER BU PROJEDE FRONTEND İÇİN FRAMEWORK KULLANMAYIP `VANILLA HTML/JS/CSS` İLE CALISTIRIYORSAN, AGAgIDAKİ "MODÜLER, BEM-TABANLI, VE MÜKEMMEL DOM" STANDARTLARINA %100 UYMAK ZORUNDASIN. FRAMEWORK OLMAMASI SPAGETTİ KOD VE 1995 STİLİ YIGINLAR YAZABİLECEGİN ANLAMINA GELMEZ. EGER TEK (1) DOSYAYA HER gEYİ GÖMERSEN İGLEM İPTAL OLUR.

## YASAKLAR LİSTESİ (ANTI-PATTERNS) - ASLA YAPMA!

1. ❌ **TEK DOSYAYA (INDEX.HTML İÇİNE) CSS VE JS GÖMMEK YASAKTIR:** 
   Otonom Zeka Eğer `<style>` etiketini Veya Tüm Scripti `index.html` İçine Gömüp Projeyi Test Edip "Bitti" derse BU VASATLIKTIR. 
   *DOGRUSU:* Otonomi Projeyi, `styles/` (CSS) ve `scripts/` (JS) ve Kök (HTML) klasörüne Fiziksel Olarak (Farklı dosyalarla) İZOLE ETMEKLE Mükelleftir. Dosyalar Bağlanırken `<script type="module" src="app.js">` ES6 Standardında İÇE AKTARILACAKTIR!.

2. ❌ **INLINE CSS (Satır İçi Still) KULLANIMI KESİN YASAKTIR:** 
   Ekranda Kırmızı bir Tuş mu Gerekiyor? Otonom AI; `<button style="color:red; background: blue">` YAZAMAZ (XSS ve Bakımszılık Yuvasi). 
   *DOGRUSU:* Eğer Projede Tailwind Yoksa: Bütun classlar Ayrı Css e eklenir `<button class="btn btn--danger">` (BEM Methodu) İle Tasarlanır. Veya "Tailwind CDN" Asılıp Yardımcı Classlar (Utility) İLE OTONOM Tasarımı Kurar.

3. ❌ **İÇ İÇE CSS SELECTOR (div ul li a) VE GLOBAL EVENT LISTENERLAR YASAKTIR:** 
   Eğer css i `.main-header ul .nav-item a:hover` geklinde 5 Katmanlı Yazarsan (Spagetti), Araya bişey Eklendiğinde Site Çöker Tıklamalar Boşla Düşer! Modülün Üzerine Sınıf (Class) Ata (Örn `.nav-link:hover`) VE Oraya Odaklan!. JS de Event Basarken Tıklayacağın Elementi DOM'da `getElementById` veya `querySelector` ile Hedef Alıp Asacaksın!. (Html SatırIçi `onClick="function()"` Kullanılamaz!!).

4. ❌ **HANTAL DÖNGÜ VE İZZİ (MEMORY/REFLOW) YASAKTIR:**
   DOM Elemanlarının İçini Arrayleri Dönüp Doldururken `element.innerHTML += "<li>"` geklinde Artı= Yaparsan Siteyi KİLİTLERSİN (Performans Katili). HTML'i Bir Arrayda Toplayıp (veya String) Tek Seferde (1 Kere) Dom'a Yapıştıracaksın (Reflow Zırhı).

---

## ✅ ZORUNLU MİMARİ YAPISI (N-TIER ENTERPRISE)

```text
/vanilla-project/
 ├── /assets            => GÖRSELLER (.png, .svg)
 ├── /styles            => GLOBAL SİSTEM ÇİZİCİLERİ (.css). BEM VEYA THEME VARIABLES BARINDIRIR.
 ├── /scripts           => ?ci JS COMPONENTLERİ VE SERVİS(HTTP) OTOYOLU.
 │    ├── /ui              => HTML'e MÜDAHALE EDEN SINIFLAR/MODULLER BURADA
 │    ├── /services        => FETCH İGLEMLERİ (Ağ Trafiği) BURADA
 │    └── app.js           => TYPE="MODULE" OLAN ANA ROOT ORKESTRASI!
 └── index.html         => BAGLAYICI SADECE DOM İSKELETİ BOILERPLATE
```

---

## BAGLAMADAN ÖNCE BİLMEN GEREKEN İLK ADIM

Eğer User sana "VanillaJS ile Todo Ugyulaması Veya Yönetim Paneli Çıkar" dediyse dahi,
**BU DOSYA (QUICK-START)** seni bağlar. 

1. Başlangıçta `<head>` Dosyasına Viewport ve Charset leri tam çek, Gerekli Fontları Googledan Önceden Bağla!. 
2. Tema Değiskenlerini CSS'e Bas (`:root { --primary... }`). HTML İçerisine Skeleton (Yükleme Spinnerlari vs) Ekle, Dom Hazır olduğunda Gizlemek Üzere Kurgula.
3. DOM Olaylarını JavaScript Module mimarisinden (`import { XYZ } from xyz.js`) formatıyla Başlar Başlamaz `DOMContentLoaded` Etkiliği Ile Mükemmel Tetiklet!.
4. Fetch İle gelen API yanıtlarında MÜKEMMEL UI KARTLARINA BÜRÜ (Mükemmeliyetçilik), Hata veren (Örn 404/500 API Crashlerinde) `alert()` Deme Animasyonlu Bir Ekrana "Uyarı / Error" Kutsunu Süzdür!.

**VANILLA WEB UYGULAMASI YAPMAK BİR SANATTIR, HAMALLIK/SPAGETTİ DEGİL. FRAMEWORK YOKSA DÜZEN SENİN KONTROLÜNDEDİR! BAGLAYABİLİRSİN!**

