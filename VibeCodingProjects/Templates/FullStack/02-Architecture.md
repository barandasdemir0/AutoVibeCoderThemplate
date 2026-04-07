# 2️⃣ FullStack (Monorepo) - Micro-Package ve Sınır İzolasyon Mimarisi

> **MİMARİ KURALI:** Eğer Otonom yapay zeka Frontend projesinin içinden (Relative Path zıplayarak `../../../backend/src/models/user.ts`) Backend Klasörüne uzanıp Dosya İçe aktarıyorsa, O Monorepo DEĞİL ÇÖPLÜKTÜR!. Uygulamalar (Apps) Birbirlerine Bağımlı Olamazlar! Sadece Ortak (Shared) Kütüphaneler Aracılığı İle Birleşebilirler!

---

## 🏛️ 1. Bağımlılık (Dependency) Yönü

Bir Monorepodaki Kütüphaneler (Packages) Diğer Uygulamalara Doğru Açılamaz. Yani "Ortak Kütüphane, Backend'i Import Edemez, Frontend'i Edemez".
Otonom Zeka `import` Yönünü herzaman UYGULAMADAN -> PAKETE DOĞRU çizecektir (Tek Yönlü Ok)!

* `apps/frontend` ---> İçe aktarır ---> `packages/ui` (Ortak Düğmeler)
* `apps/backend` ---> İçe aktarır ---> `packages/db` (Ortak Prisma Tabloları)
* `apps/frontend` ---> İçe aktarır ---> `packages/db` (Tipler için)
* VE KESİNLİKLE: `apps/frontend` -❌-> `apps/backend` (BİRBİRİNE GİRMEZLER!)

## 🏗️ 2. Paketlerin (Packages) Tasarım Standardı (Micro-Modules)

Büyük Monorepo Kurgularında Her bir ortak kütüphane "Sanki Bir NPM pakedi Gibi Cihazda çalışır!!". Her Pakedin İÇİNDE Kendi Eşsiz `package.json` ı olur!!.
Otonom AI, Yeni bir Ortak (Shared) modül yaratacaksa (Örnek Data Doğrulama Validation Modülü):
1. `packages/validations` adında klasör açar.
2. İçine Kendi Local `package.json`'unu yazar ve ismine `@repo/validations` (Veya @sirket) Der!.
3. Arkasından Frontend Projesine Gider, Frontendin NPM configine `npm install @repo/validations` yazar VE KODDA Mükemmelce Çağırır:
`import { userSchema } from '@repo/validations'`. (Tıpkı bir kütüphaneyi DIŞARIDAN npm'den çekmiş hissiyatı verir).

---

## 🚫 3. YASAKLI İŞLEMLER (Monorepo Anti-Patterns)

1. ❌ **Ana Dizine (Root) Package Yığmak (Kök Şişmesi):**
   Eğer Frontend Redux kullanıyorsa, Ve Backend AWS SKD Kullanıyorsa; Otonom Zeka Bu 2 Paketi gidip Projenin EN KÖKTEN `package.json`'u olan Root'a "npm install" ile YÜKLEYEMEZ!. Kök Sadece (Prettier, Eslint, Typescript ve Turborepo) Gibi Ortak Geliştirme araçlarını Barındırır!. Uygulamanın Özellikleri KENDI APP'LERINE (`apps/frontend/package.json`) izole şekilde Cekilmelidir!.

2. ❌ **Farklı Versiyon Paket Kurulumu (Version Mismatch):**
   Backend klasörüne `Zod v3.10` Kurup, Frontend'de Gecen Yıldan Kalma (YapayZeka Eğitim hatası) `Zod v2.0` Kurulamaz! (Workspace Hataları Patlar ve Tip Gücü Kırılır!). Otonomi Uygulama Çapında Versiyon Tektiplemesine (Sync-pack vb) Dikkat ETMEZ SE ÇÖKER!.

3. ❌ **Kod Duplikasyonları (Kopyala Yapıştır Vebası):**
   Otonom AI Eğer Projede Şifreli bir JWT üretmek istiyosa Ve Frontend İçinde de Bir Parse İşlemi Yapıyorsa "İki yere aynı Util Klasörünü AYRI AYRI" Yazamaz!!!. Eger bir Kod Parçacığı (Regex/Tip), HEM Front HEM Backte çalışacak Cinsse o Modül ANINDA `packages/utils` kısmına Alınıp, İki Taraftan DA importlanacak Şekle Sokulur!! (Don't Repeat Yourself'in En Ağır Cihaz halidir).
