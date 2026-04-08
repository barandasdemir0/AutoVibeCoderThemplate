# 🐛 Debug Tips — HTML + CSS + Bootstrap

## ⚠️ Sık Hatalar

### Bootstrap çalışmıyor
→ CDN linkleri doğru mı? HTTPS mi?
→ `bootstrap.bundle.min.js` (Popper dahil) kullanıyorsan ayrıca Popper ekleme

### Grid bozuk
→ `row` içinde `col-*` var mı?
→ `container` wrapper eksik mi?
→ Toplam column sayısı 12'yi aşıyor mu?

### Modal açılmıyor
→ `data-bs-toggle="modal" data-bs-target="#myModal"` doğru mu?
→ Bootstrap JS yüklü mü?
→ Modal HTML'i body içinde mi?

### Responsive çalışmıyor
→ `<meta name="viewport">` eksik mi?
→ Doğru breakpoint prefix kullanıyor musun? (`col-md-6`)

### Custom CSS override etmiyor
→ `custom.css` Bootstrap CSS'den SONRA yüklenmeli
→ `!important` son çare olarak kullan
→ Daha spesifik selector yaz

### Tooltip/Popover görünmüyor
→ JS ile initialize et: `const tooltips = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]')); tooltips.map(el => new bootstrap.Tooltip(el));`

## 🔍 Araçlar
| Araç | Kullanım |
|------|----------|
| DevTools | Layout, box model inspect |
| Bootstrap Docs | Component referansı |
| Live Server | Hot reload |

## 📓 Debug Günlüğü
| Tarih | Hata | Çözüm |
|-------|------|--------|
| [—]   | [—]  | [—]    |
