# 1️⃣ FullStack (Monorepo) - Uçtan Uca Tip Güvenliği ve Planlama Otonomisi

> **YAPAY ZEKA İÇİN KESİN KURAL:** "Frontend için ayrı Klasör aç Backend için ayrı Klasör aç" Devri Kurumsal Full-Stack dünyasında Son Buldu! Otonom yapay zeka; Server (Sunucu) ve Client'ın (İstemcinin) Ortak (Paylaşımlı) Tipleri kullanarak Mükemmelleştiği birleşik yapıları (Monorepo) İnşa etmek zorundadır!. "Type Safety (Tip Güvenliği)" burada kutsaldır.

---

## 🎯 1. Monorepo (Tek Depo) Mimarisi ve Paket Yöneticiler

Backend, Frontend, ve Admin Panelini 3 ayrı Git projesi yaparsan, Backend'e eklenen `email` kolonunu Frontend'e bildirmeyi UNUTURSUN ve sistem Patlar.

### A. Otonom Klasör Şablonu (Workspaces)
* Otonom yapay zeka Root (Kök) dizinde bir **Turborepo** veya **Nx** Başlatıcısı kurabilir!. Veya saf "NPM/PNPM/Yarn Workspaces" kullanır:
* **`apps/`** => İçinde Frontend (ör: Next.js) ve Backend (ör: Express.js) barındırır.
* **`packages/`** => Frontend ve Backend'in **ORTAK KULLANDIĞI** TypeScript Typesları, DTO'lar Veya UI Kitlerini barındırır.

Bu Yönelim Sayesinde Frontend, Backendin `User` tablosunun yapısını import (`import { UserType } from '@repo/shared'`) edebilir! Mükemmel senkronizasyon SAĞLANMIŞ OLUR!.

---

## 🔒 2. End-To-End (Uçtan Uca) Tip Güvenliği (tRPC Devrimi)

REST API (Axios ile `/api/users` cağırmak) Ve GraphQL "Her İki tarafında ayrı döküman (Swagger) ve Schema yazmasını" gerektirir!!. "KörüKörüne" veri istenir, Yanlışsa (örn Backend `userName` yollarsa ama Frontend `name` bekliyorsa) CRASH Olur.

### Otonomi Seçimi (tRPC ve TypeScript Okyanusu): 
* Kural: Eğer uygulamanın Kökü (Backend ve Frontend) İkisi de Typescript ise; Otonom Model **tRPC (TypeScript Remote Procedure Call)** Kullanmaya Yönelmelidir!!.
* tRPC'de; Backend Bir `sayHello` fonksiyonu Yazar. Frontend o Fonksiyonu *KENDİ PROJESINDEN GELIYORMUŞ GIBI DOĞRUDAN ÇAĞIRIR*. Eğer Backend Metodun ismini Ciddi Olarak Değiştirirse (Örn `sayHi` yaparsa), 
**FRONTEND ANINDA ÇÖKER (TypeScript Hatası Verir) VE VSCODE ALTINI ÇİZER KIZARTIR!!!** Zeka Kırılmayı anında Görür ve Düzeltir! Prod'a Bozuk kod çıkması MATEMATIKSEL OLARAK İMKANSIZLAŞIR!.

---

## 🚀 3. Veritabanı Tip Uyumları (Prisma vs Drizzle ORM)

Otonom model bir "FullStack" Veritabanı tasarlıyorsa Gidip "Sequelize" gibi tipleri eksik kütüphanelerle UŞRAŞAMAZ!

* Otonom AI; Gelişen FullStack dünyasında Veritabanı Şemasını `schema.prisma` gibi bir dosyaya Cizer.
* Prisma Client çalıştırıldığında (Generate), Mükemmel Typescript Types'ları Otonom Üretilir. Backend Kod Yazarken Veritabanında Olmayan Bir Tablo Sütununu Cagırması (Yine Typescript Tarafından) ENGELLENİR! Zeka Sınırları Korunur!

Sırada İzolasyon kalkanı olan Architecture Katmanı (02) Vardır. Mevzuya geç.
