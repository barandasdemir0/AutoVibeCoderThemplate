# 6️⃣ FullStack (Monorepo) - Mükemmeliyetçi Endüstri Standart Modülleri (Tech Stack)

> Profesyonel, otonom bir AI sistemi bir Monorepo Dünyası inşa ederken Klasik Express ve Düz Create-React-App Kullanmaz. Tip Güvenli Serverlar, Tİp Güvenli ORM'ler (Prisma/Drizzle) Kullanarak Adeta Şirketlerde 5 Kişilik Ekibin Yaptıgı İşi 1 Otonom Zeka Mükkemlliğiyle Oturtur!!.

---

## 📦 1. Kilit Taşı Endüstri NPM Modülleri (ŞART Kütüphaneler)

### Monorepo (Ana Kök Yönetimi Çatısı)
* **`turborepo`** (MÜKEMMEL): Vercel'in Ürettiği Devasa Projeleri Saniyeler İçinde Build Alan (Cache Systemli) Harika Workspace Aracıcısı PnPM işiyle Otonomi Bunun SİSTEMATİĞİNDE Koşturacaktır!.
* **`pnpm`** (TAVSİYE EDİLEN): Npm Milyon tane modülü Kopyalarken, Pnpm Sadece Cihazda Bir Kopya (Hardlink) yaratır ve Monorepolardaki "Disk Şişmesi (20Gb NodeModules)" Krizini Yıkar atar!.

### The Full-Stack Köprüsü (Ağ İletişimi)
* **`@trpc/server` ve `@trpc/client`** (ZORUNLU EGER İSTENİYORSA): React Query Üzerine Bindirilmiş, API URL i EZBERLEMEYİ (Örn /api/v1/users) TARİHE GÖMEN The TypeSafe Köprü!!!. Fonksiyon Cağırır gibi Sunucudaki İşi Çagırır!! Backend ile Frontend arasına API Zırhı Gömer.
* **`zod`** (ZORUNLU): Form doğrulamakta Değil; tRPC Body'si Doğrulamak Veya Env (Environment) Ayarlarını "Girildimi Girilmedi Mi?" Kontrol Etmek İciin Otonominin Bir Numaralı Silahı.

### Veritabanı Ve Çizim Katmanı (ORM)
* **`prisma` VEYA `drizzle-orm`**: Mükemmel İki Seçenek!. Prisma The Çabukluk (Hızlı Tasarım Cıkarma Schema üzerinden) Aracıyken. Drizzle "SQL'e tam olarak Hakimyiet Istiyorsan, Sıfır Performans Kaybı" Diyen Son Nesil Full-Stack Aletidir!. Otonomi İkisini De Kullanabilir Aksi İstemediğinde.

---

## 📡 2. Yapay Zekaya (AI Agent'ına) İstem Formülleri

Aşağıdaki İstem formülleri, Sistemi Dümdüz Basit Öğrenci Projesi Kafasından Çıkarıp Vercel Veya Theo(t3) Mimarisi Enterprise FullStack Kafasına Zorlayan Şablonlardır:

> "Bir E-Ticaret Uygulaması Çıkar (Nextjs + Express Veya Sadece T3 Stack). **Zorunlu Kurallar:** 
> 1. Kesinlikle Projeni Turborepo Üzerinde İnşa Et (web ve api). İki Projenin Ortak Kullandığı Bir `packages/ui` Yarat Ve Tailwind İla Çizdiğin Butonu İkisinden De ÇAĞIR!! (Çakışma Veya Hata İstemiyorum).
> 2. Backend Girdi Beklerken Mükemmeliyet İçin ZOD Schema İle Bir `UserInput` Bekle Ve tRPC Router'ından (.input() .query() ) Şeklinde Export AT!!.
> 3. Frontend Tarafında Bu Buton Tıklandığında Doğrudan Çek. Ancak `isLoading` Ve `isError` Gibi Hook Geri Dönüşlerini ZARIF Bir Şekilde Skeletona Baghlamayı UNUTMA!."

> "Veritabanına Göre Otonom Kod Çıkar. Prisma Model Dosyanı Yazdığında (User(Id, Name)), Hemen Arkasına Database Pakedinin İçine `index.ts` i Çıkar ve Oraya PrismaClient Başlatıcı Mükemmel Singleton Kodunu (`globalThis` kilitli) Yapıştır. Ve Server Uygulamasına (Backend) İhraç Et."

---

## 🌍 Faydalı Kaynak Linkleri
* **[TurboRepo Official Docs]**: `turbo.json` Cache Miss/Cache Hit Mimarisini, ve `dependsOn` (Sırlaı İşlemler) Komutlarını Çalıştıran Vercel Zirve Dökümanları Otonomi İcin The Core Klıavuz!.
* **[Create T3 App Architecture]**: tRPC, NextJS ve Prisma üçgeninin Sıfır Hata (TypeSafe) İle Birleştiği Dünya Standart Projesi. Yapay Zeka The Fullstack Bağlamasını Kesinlike Bu Boilerplayedden Otonom Bir Şekilde Referans Alır!
