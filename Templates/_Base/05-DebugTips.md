# 🐛 Debug Tips

> Genel hata bulma stratejileri. Teknolojiye özel hatalar için ilgili şablona bak.

---

## 🔍 Genel Strateji

1. Hatayı **yeniden üret**
2. Hata mesajını **oku** (stack trace)
3. Sorunu **izole et**
4. **Logla** ve değişken değerlerini kontrol et
5. **Çöz** → Test et → Belgele

---

## 📋 Log Seviyeleri

| Seviye   | Kullanım                        |
|----------|---------------------------------|
| TRACE    | En detaylı (dev only)           |
| DEBUG    | Geliştirme sırasında            |
| INFO     | Normal akış                     |
| WARNING  | Beklenmedik ama yönetilebilir   |
| ERROR    | Hata, uygulama devam eder       |
| CRITICAL | Uygulama çöktü / çökebilir      |

---

## 🎯 Genel Debug Araçları

| Araç              | Platform   | Kullanım              |
|--------------------|-----------|----------------------|
| Browser DevTools   | Web       | Frontend debug        |
| Postman / Insomnia | API       | Endpoint test         |
| VS Code Debugger   | Tümü      | Breakpoint, watch     |
| Terminal / CLI     | Tümü      | Log takibi            |
| DB Client          | Backend   | Sorgu test            |

---

## ⚠️ Evrensel Hatalar

### Bağlantı Hataları
- Port zaten kullanımda → `netstat -ano | findstr :PORT`
- DB bağlanamıyor → connection string kontrol et
- CORS hatası → Backend'de izin ayarla

### Bağımlılık Hataları
- Paket bulunamadı → versiyon kontrolü yap
- Uyumsuz versiyonlar → lock dosyasını sil, yeniden yükle

### Performans
- N+1 sorgu problemi → eager loading / join kullan
- Memory leak → profiler ile kontrol et

---

## 📓 Debug Günlüğü

| Tarih | Hata | Neden | Çözüm |
|-------|------|-------|--------|
| [—]   | [—]  | [—]   | [—]    |
