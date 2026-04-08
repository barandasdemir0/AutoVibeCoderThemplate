# 🚀 SCALABILITY.md — Yüksek Trafik (100.000+ Kullanıcı) ve Ölçeklenebilirlik Rehberi

> Uygulamanın anlık binlerce isteği çökmeden karşılayabilmesi için AI modelin uyması gereken katı mimari kurallar.

---

## 🚦 1. Rate Limiting (Hız Sınırlandırması)
Her public ve private endpoint mutlaka Rate Limiting arkasında olmalıdır. DDoS veya brute-force ataklarını engellemek için kod katmanında zorunludur.

- **Public Endpointler (Login, Register):** Dakikada max 10 istek per IP.
- **Standart API Endpointleri:** Dakikada max 100 istek per IP (veya Token).
- **Global Kural:** Rate limit aşıldığında sistem HTTP 429 (Too Many Requests) dönmeli ve `Retry-After` header'ı eklenmelidir.

### Örnek Implementasyon Mantığı (Node.js/Express)
```javascript
import rateLimit from 'express-rate-limit';

export const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 dakika
  max: 10, // IP başına max 10 deneme
  message: { error: 'Çok fazla deneme yaptınız. Lütfen 15 dakika sonra tekrar deneyin.' }
});
```

---

## 💾 2. Veritabanı Connection Pooling
Gelen her HTTP isteği için veritabanına yeni bağlantı açıp kapatmak sistemi kilitler. Bağlantı havuzu (Connection Pool) zorunludur.

- **Kural:** DB kütüphanesinde (Prisma, TypeORM, EntityFramework, SQLAlchemy) pool size (havuz büyüklüğü) sunucunun CPU çekirdek sayısına ve expected trafiğe göre ayarlanmalıdır (Örn: Prisma için `?connection_limit=50`).
- **N+1 Sorgu Problemi:** Asla döngü (loop) içinde veritabanı sorgusu atılmayacaktır. Tüm sorgular `JOIN`, `Include` veya `GraphQL Dataloader` mantığıyla tek seferde çekilmelidir.

---

## ⚡ 3. Redis / Caching Entegrasyonu (Heavy Query)
`CACHING.md` rehberine ek olarak, yüksek trafikli sistemlerde kurallar:
- **Ana Sayfa & Sık Okunan Veriler:** DB'ye inmeden önce mutlaka Redis üzerinden geçmelidir.
- **Kural:** İstek süresi 200ms'yi aşan her veritabanı sorgusu (istatistik, rapor, kompleks joinler) Redis/Memcached üzerinde TTL (Time to Live) ile saklanmalıdır.
- **Cache Stampede Önlme:** Cache expire olduğunda binlerce kullanıcının aynı anda DB'ye yüklenmesini önlemek için "Mutex Lock" veya "Stale-While-Revalidate" pattern'i kullanılmalıdır.

---

## 📦 4. Pagination & Cursor-Based Fetching
Mobil ve Web arayüzlerine devasa veri gönderilemez.
- **Kural:** Liste dönen (Products, Users, vb.) her endpoint zorunlu olarak sayfalanmalıdır (Pagination).
- Büyük veri setleri (10.000+ satır) için Offset tabanlı (`LIMIT/OFFSET`) yerine **Cursor-based** (id'ye veya tarihe göre) sayfalama uygulanmalıdır (Örn: `WHERE id > last_cursor LIMIT 20`).

---

## 🛡️ 5. Güvenlik & DDoS Koruma (Altyapı Mantığı)
AI kodu yazarken altyapının arkasında çalışacağını varsaymalı:
- Uygulama proxy arkasında (Nginx/Cloudflare) çalışacağından IP adresini almak için `X-Forwarded-For` header'ı parse edilmeli (güvenilir kaynak yapılandırılarak).
- **Helmet:** Tüm response'lara güvenlik header'ları eklenmelidir (XSS, Clickjacking koruması).

---

## 🔄 6. Background Jobs (Asenkron İşlemler)
Kullanıcıya anında cevap dönmesi gerekmeyen işlemler HTTP cycle'ını yavaşlatmamalı.
- **E-posta gönderme, Resim işleme, PDF oluşturma PUSH bildirim atma:** AI bu işlemleri doğrudan Controller/Service içinde API yanıtını bekletecek şekilde YAZMAYACAKTIR. 
- **Zorunlu Kural:** Bu işlemler bir Message Queue'ya (RabbitMQ, Redis + BullMQ, Celery/Kafka) atılacak, kullanıcıya `202 Accepted` dönülecek, işlem arka planda worker'lar tarafından yapılacaktır.
