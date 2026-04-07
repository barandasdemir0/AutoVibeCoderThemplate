# 🎨 UX-UI-GUIDE.md — Kullanıcı Deneyimi & Arayüz Tasarım Rehberi

> Frontend ve Mobile projeler için UX/UI best practice kuralları.
> AI modeline bu dosyayı okutarak profesyonel UI oluşturmasını sağlayın.

---

## 🚨 0. MODERN UI KÜTÜPHANESİ ZORUNLULUĞU (KIRMIZI ÇİZGİ)
Web arayüzlerini sıfırdan "düz CSS" veya "çirkin temel HTML" ile YAPMAK YASAKTIR. Arayüzün "berbat" görünmemesi için HİÇBİR ZAMAN standart tarayıcı stillerine güvenilmeyecektir.
- **Zorunlu Kullanım:** Aksi belirtilmediği sürece web projelerinde **Tailwind CSS** (ve tercihen modern frameworklar için **Shadcn UI** veya UI kütüphaneleri: **MUI / Radix UI / Chakra UI**) KULLANILACAKTIR.
- Sadece `display: flex` ve sıradan renkler verip geçmek YASAKTIR! Arayüzün göze "harika ve premium" gözükmesi birinci önceliktir.

## 📐 UI Temel Kuralları

### 1. Spacing, Layout & Border Radius
```
8px Grid System → tüm spacing 8'in katı: 8, 16, 24, 32, 48, 64
Padding: 16px (mobil), 24px (tablet), 32px (desktop). Elementlerde DEVASA, ferah paddingler (örn. p-6, p-8) kullan. İç içe dar ve sıkışık arayüz tasarımlarından kaçın!
Border Radius: Tasarımı 'Premium' yapmak için köşeler her zaman yumuşatılmalı (örn: rounded-xl, 12px, 16px veya pill shape). Keskin 0px köşelerden kaçının.
```

### 2. Typography (Premium His)
```
Font ailesi: Modern ve pürüzsüz sans-serif fontlar (Örn: Inter, Plus Jakarta Sans, Outfit, Poppins).
Hiyerarşi ve Kontrast:
  H1: 36-48px, bold/extrabold, tight letter-spacing (-0.02em)
  H2: 24-32px, semibold
  Body: 15-16px, regular, relaxed line-height (1.6)
Sıradan tarayıcı fontları ASLA kullanılmayacak.
```

### 3. Renk Sistemi & Neumorphism / Glassmorphism
Sıradan "kırmızı, mavi, yeşil" yasaktır. Premium hissetirmelidir.
```css
Primary: HSL paletinden özel üretilmiş, marka kimliğine uygun hafif pastel/canlı arası renkler.
Gradients: Linear gradient'lar 45 veya 90 derece açıyla, birbirine yakın iki tonda (Mesela açık mordan koyu mora) kullanılmalı.
Hover: Ana rengin %10 daha koyusu veya saydamı.
Glassmorphism: Arka plan üzerine binen kartlarda backdrop-filter: blur(12px), rgba(255,255,255, 0.05) ve çok ince bir beyaz border (1px solid rgba(255,255,255,0.1)).
```

### 4. Dark Mode (Zorunlu Pürüzsüzlük)
```css
Saf siyah (#000000) kullanmak yasaktır. Gözü yorar. 
Dark mode için derin lacivert veya çok koyu gri kullanılmalı.
[data-theme="dark"] { --bg: #09090b; --surface: #18181b; --border: #27272a; --text: #fafafa; }
```

---

## 🧩 Component Best Practices

### Butonlar & Micro-Interactions (Framer Motion / CSS)
Hiçbir aksiyon elementi statik bırakılamaz. Akıcı ve canlı hissettirmelidir.
| Kural | Beklenti |
|------|----------|
| **Hover Efektleri** | Her buton/kart üzerine gelindiğinde ince bir animasyon (örn: `transform: scale(1.02) veya translateY(-2px); transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);`) tetiklemelidir. |
| **Active/Tap Efektleri** | Tıklanma anında (scale down, effect ripple) yapılmalıdır. |
| **Gölge (Shadows)** | Box-shadow'lar sert olmamalı. Birden fazla katmanlı, yumuşak dağınık gölgeler kullanılmalıdır (Örn: `box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);`). |

### Form UX
- **Real-time validation**: Kullanıcı yazdıkça hata göster
- **Error mesajı**: Inputun altında, kırmızı, açıklayıcı
- **Loading state**: Submit'te button → spinner + disabled
- **Success feedback**: Toast/snackbar
- **Tab order**: Mantıklı sıra (yukarıdan aşağıya, soldan sağa)
- **Autofocus**: İlk input'a otomatik focus

### Responsive Design
```
Mobile First → min-width breakpoint'ler
  xs: 0-575px    → tek kolon
  sm: 576-767px  → dar 2 kolon
  md: 768-991px  → tablet
  lg: 992-1199px → küçük desktop
  xl: 1200px+    → büyük desktop
```

---

## 📱 Mobile UX Kuralları

### Touch Targets
- Minimum dokunma alanı: **44x44px** (Apple), **48x48dp** (Google)
- Butonlar arası mesafe: en az 8px

### Navigation Patterns
| Pattern | Ne Zaman |
|---------|----------|
| Bottom Tab (5 max) | Ana sayfalar |
| Drawer/Hamburger | Çok sayfalar |
| Stack (push/pop) | Detay sayfaları |
| Modal | Hızlı aksiyon, form |

### Performance & State UX (Zorunlu Kusursuzluk)
- **Skeleton loading**: ASLA spinner/yuvarlak animasyon bekletmeyin. İçerikler yüklenirken sayfa düzenine tam uyan Shimmer (parlayan) gri skeleton kutular gösterin.
- **Empty States (Boş Durumlar)**: Veri yoksa boş sayfa göstermek yasaktır. Premium bir illüstrasyon, açıklayıcı bir metin ve "Yeni Ekle" gibi Call To Action (CTA) butonu gösterilecek.
- **Optimistic update**: Beğenme, kaydetme gibi işlemlerde sunucu yanıtını beklemeden anında UI güncellemesi yapılmalıdır (daha sonra arka planda API call atılır). İnternet hissiyatı silinmelidir.

---

## ✅ UX Checklist (Her Proje İçin)
- [ ] Loading state (skeleton/spinner) var mı?
- [ ] Error state (hata mesajı + retry butonu) var mı?
- [ ] Empty state (boş liste → "Henüz kayıt yok" + CTA) var mı?
- [ ] Success feedback (toast/snackbar) var mı?
- [ ] Responsive (mobil + tablet + desktop) test edildi mi?
- [ ] Accessibility (alt text, aria-label, keyboard nav) var mı?
- [ ] Dark mode desteği var mı?
- [ ] Touch target 44px+ mı? (mobile)
- [ ] Form validation (real-time) var mı?
- [ ] 404 / error page var mı?
