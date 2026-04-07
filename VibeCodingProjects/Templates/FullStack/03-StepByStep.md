# 3️⃣ FullStack (Monorepo) - Adım Adım İnşaa Süreci (Step-By-Step)

> **YAPAY ZEKA ÇALIŞMA ALGORİTMASI:** "Önce Backend'i kodlayayım Sonra Frontend'e Geçerim" Kafası Monorepo dünyasında İş Yapmaz. Sistemin Önce İş/Veribağlantısı Klasörleri (Packages) Dövülecek, En Son Uygulama (Apps) Arayüzleri Oturtulacaktır!!. Otonom Model Mimarın "Aşağıdan Yukarıya" Şablonunu Seyretmelidir.

---

## 🛠️ Aşama 1: Workspace (Çalışma Alanı) Kurgusunun Kurulması
1. Turborepo (Veya NPM workspaces/ Pnpm workspaces) Projesi Kök Klasörden Başlatılır `npx create-turbo@latest`.
2. Otonom yapay zeka `turbo.json` dosyasında Taskların (build, dev, lint) Parelel Başlaması veya Sirali (DependsOn) başlaması Ayarlarını Yapılandırır (Eğer DB migrate edilmeden Frontend Başlamasın Gibi Bir Zincir Varsa Oraya Kilit Otonom atılır!).

---

## 🗄️ Aşama 2: The Core Packages (Hücre Çekirdeği) Veritabanı Modülü
*(Veri Olmadan Frontendin Esamesi Okunmaz)*
1. `packages/db` Yaratılır. Otonom yapay zeka buraya `Prisma` Kurulumunu Gerçekleştirir.
2. `schema.prisma` içerisine (Tüm Projenin Çimentoları) Modeller Çizilir (User, Post vs). Ardından `npx prisma generate` Çalıştırılır Ve Typescript Interface'leri Fırından (Prisma Client) ÇIKARTILIR!
3. `package.json` ile `export { db }` Yapısında Veritabanı Modülü Dis Dünyaya Açılır!.

---

## 🧬 Aşama 3: The Validation (Kalkan) Kurgusu Modülü
1. Otonom AI gidip `packages/validations` Kurar! (Veya shared/dto vs).
2. İçerisinde (Zod vs ile) API Schema Kurallarını Dizilir.
   ```ts
   export const CreateUserSchema = z.object({ email: z.string().email(), password: z.string().min(8) });
   export type CreateUserInput = z.infer<typeof CreateUserSchema>;
   ```
   (Bu Dışarı İhraç -Export- Edilir!).

---

## 🌐 Aşama 4: The Backend (API Server) İnşası
1. `apps/backend` (Örn: Express.js, Nestjs vb) Kurgusu Başlar!!
2. Backendin `package.json`'unda `@repo/db` ve `@repo/validations` Otonomca Importlanir!.
3. Request Body, Frontendin bilip Onayladığı Zod şeması (`CreateUserSchema`) Tarafından Test edilir! Doğrulanıp `@repo/db` ile Veritabanına YAZILIR! Zirve Kod İzoleleşmesidir!

---

## 🔒 Aşama 5: The Frontend İnşası ve tRPC Bağı
1. `apps/frontend` (Örn Next.js Veya React) Ayaklandırılır!
2. Backend de Yazılan Tipler Ve Route'lar Frontend tarafından tRPC (VEYA Benzeri Generatörler) Sayesinde İthal edilir! 
3. Frontend'da Otonom Zeka İstek Atarken `const res = await api.user.create.mutate({ email: 'x', pass: 'x' })` Şeklinde Formülize Eder (Harf Hatası Yapsa IDE Ve Zeka Kizaracak İzin Vermeyecek!).

---

## ⚙️ Aşama 6: Polishing (Üst düzey Otomasyon ve Testler)
* **Pre-Commit Hookları (Kilitler):** Otonom yapay Zeka Monorepo Kurgularken Eğer Bir Klasörü (Backend) bozarsa Diğer Sitenin Yıkılıp Yıkılmadıgını Anlamak İçin Projenin Kalbine Husky + LintStaged Atacak Ve Commitlenmeden Önce BÜTÜN PROJELERIN `npm run typecheck` (TIp Güvenliği) Testinden Geçmesini Mükemmeliyetçi Teste TABİ TUTACAKTIR!!. Biri Patlarsa Proje Pushedilemez. 

Adımlar tamsa "04-FilesStructure" yönergelerine Geçeceksiniz.
