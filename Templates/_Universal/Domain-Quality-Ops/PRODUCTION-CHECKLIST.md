# ✅ PRODUCTION-CHECKLIST.md — Yayınlamadan Önce Son Kontrol

> Bu dosya, projenin production'a çıkmadan önce MUTLAKA geçmesi gereken kontrol listesidir.
> AI her projeyi bitirdiğinde bu listeyi çalıştıracak.

---

## 🔐 Güvenlik

- [ ] `.env` dosyası `.gitignore`'da mı?
- [ ] Hardcoded secret/password/API key yok mu?
- [ ] HTTPS zorlanıyor mu? (backend redirect)
- [ ] Input validation var mı? (SQL injection, XSS koruması)
- [ ] Rate limiting var mı? (brute-force koruması)
- [ ] CORS sadece izin verilen domain'lere açık mı?
- [ ] JWT secret en az 256-bit mi?
- [ ] Password hashing var mı? (bcrypt/Argon2 — plain text ASLA)
- [ ] File upload varsa: dosya tipi + boyut kontrolü var mı?
- [ ] Hassas endpoint'ler auth korumalı mı? (`[Authorize]`, `@login_required`)
- [ ] Error response'larda stack trace döndürülmüyor mu? (prod'da kapalı)

---

## ⚡ Performans

- [ ] Image'lar optimize mi? (lazy load, WebP, max boyut)
- [ ] API response'lar gzip/brotli mi?
- [ ] DB index'ler kritik sorgulara eklenmiş mi?
- [ ] N+1 query yok mu? (Include/select_related/eager loading)
- [ ] Cache stratejisi var mı? (sık okunan veri)
- [ ] Pagination var mı? (büyük listeler)
- [ ] Bundle size optimize mi? (tree-shaking, code splitting)
- [ ] CDN kullanılıyor mu? (static assets)

---

## 🎨 UX / UI

- [ ] Loading state var mı? (spinner/skeleton)
- [ ] Error state var mı? (kullanıcı dostu hata mesajı)
- [ ] Empty state var mı? ("Henüz veri yok" ekranı)
- [ ] Form validation feedback var mı? (inline hatalar)
- [ ] Responsive tasarım var mı? (mobile + tablet + desktop)
- [ ] Dark mode var mı? (veya en azından desteklenebilir yapı)
- [ ] Toast/snackbar bildirim sistemi var mı?
- [ ] 404 sayfası var mı?
- [ ] Splash/loading screen var mı? (mobil)
- [ ] Accessibility temel kontrolleri geçiyor mu? (semantic HTML, alt text)

---

## 🏗️ Kod Kalitesi

- [ ] Separation of Concerns uygulanmış mı? (Controller/Service/Repository ayrı)
- [ ] Naming convention tutarlı mı? (AI-RULES.md'ye göre)
- [ ] God class yok mu? (1000+ satır dosya)
- [ ] Dead code/unused import yok mu?
- [ ] Console.log / print / debug statement temizlenmiş mi?
- [ ] Her dosyanın başında yorum bloğu var mı?
- [ ] Magic number/string yok mu? (constants dosyasında mı)

---

## 🧪 Test

- [ ] Unit test var mı? (en az service katmanı)
- [ ] Integration test var mı? (API endpoint'ler)
- [ ] Auth akışı test edilmiş mi? (login, register, token)
- [ ] Edge case'ler test edilmiş mi? (null, empty, max length)
- [ ] Test coverage %60+ mı?

---

## 🐳 DevOps

- [ ] Dockerfile var mı?
- [ ] docker-compose.yml var mı? (multi-service)
- [ ] CI pipeline var mı? (push → test → build)
- [ ] CD pipeline var mı? (merge → deploy)
- [ ] Environment ayrımı var mı? (dev/staging/prod)
- [ ] Health check endpoint var mı? (`/api/health`)
- [ ] Log seviyesi prod'da Warning/Error mı?
- [ ] Backup stratejisi var mı? (DB)

---

## 📱 Mobil (Varsa)

### Android
- [ ] App icon set edilmiş mi? (mipmap: mdpi → xxxhdpi)
- [ ] Splash screen var mı?
- [ ] `minSdkVersion` uygun mu? (21+)
- [ ] ProGuard/R8 aktif mi? (release build)
- [ ] `android:usesCleartextTraffic="false"` mi?
- [ ] Keystore oluşturulmuş mu?
- [ ] `build.gradle` → `signingConfigs` ayarlanmış mı?
- [ ] Gereksiz permission kaldırılmış mı?

### iOS
- [ ] App icon set edilmiş mi? (Assets.xcassets)
- [ ] Launch screen var mı?
- [ ] Deployment target uygun mu? (iOS 14+)
- [ ] Info.plist permission açıklamaları yazılmış mı?
- [ ] Bundle identifier doğru mu?
- [ ] Signing certificate + provisioning profile var mı?

### Store Listing
- [ ] App name (max 30 karakter)
- [ ] Short description (max 80 karakter)
- [ ] Full description (max 4000 karakter)
- [ ] Screenshots hazırlanmış mı? (her boyut)
- [ ] Privacy policy URL var mı?
- [ ] Demo hesap var mı? (review için)

---

## 📄 Dokümantasyon

- [ ] `README.md` var mı? (kurulum, çalıştırma, mimari özet)
- [ ] API documentation var mı? (Swagger/OpenAPI/Postman)
- [ ] `.env.example` var mı? (gerekli key'lerin listesi)
- [ ] `CHANGELOG.md` var mı?
- [ ] Mimari diyagram var mı? (basit bile olsa)

---

## 🚀 Deploy Öncesi Son Adımlar

```
1. Tüm testleri çalıştır → hepsi geçiyor mu?
2. Production build yap → hata yok mu?
3. .env.production ayarla → doğru DB, doğru secret
4. Docker ile dene → local'de çalışıyor mu?
5. Staging'e deploy → çalışıyor mu?
6. Smoke test → kritik akışlar (login, CRUD) çalışıyor mu?
7. Production'a deploy
8. Health check → /api/health 200 mü?
9. Monitoring/alert kur (opsiyonel)
```

---

## AI İÇİN KURAL

```
Proje "bitti" demeden önce bu checklist'i çalıştır.
Her [ ] işareti ✅ olmadan production'a çıkma.
Geçemeyen maddeler varsa kullanıcıya bildir ve çöz.
```
