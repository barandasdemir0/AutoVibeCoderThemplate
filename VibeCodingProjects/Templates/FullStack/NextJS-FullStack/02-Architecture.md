# 🏗️ Architecture | 📂 Files | 🐛 Debug | 📚 Resources — Next.js Full Stack

## Dosya Açıklamaları
| Dosya | Ne İş Yapar |
|-------|-------------|
| `app/layout.tsx` | Root layout — tüm sayfalarda geçerli (head, body, providers) |
| `app/page.tsx` | Ana sayfa (/ route) |
| `app/loading.tsx` | Sayfa yüklenirken gösterilen skeleton/spinner |
| `app/error.tsx` | Hata durumunda gösterilen error boundary |
| `app/(auth)/login/page.tsx` | Route group — login sayfası |
| `app/dashboard/page.tsx` | Korumalı dashboard sayfası |
| `actions/*.ts` | Server Actions — form submit, CRUD (API route yerine) |
| `lib/db.ts` | Prisma client singleton instance |
| `lib/auth.ts` | NextAuth.js konfigürasyonu |
| `lib/validations.ts` | Zod schema tanımları (input validation) |
| `components/ui/` | shadcn/ui reusable bileşenler |
| `prisma/schema.prisma` | DB tablo şeması (Prisma) |
| `middleware.ts` | Auth redirect, route koruma |

## Debug Tips
| Sorun | Çözüm |
|-------|-------|
| Hydration mismatch | `'use client'` gerektiren component server'da mı? |
| Server Action error | Zod `.parse()` hatası → `.safeParse()` kullan |
| Prisma connection | `npx prisma db push` → `.env DATABASE_URL` kontrol |
| Middleware çalışmıyor | `middleware.ts` → `src/` dışında, proje root'unda |
| "Dynamic server usage" | `export const dynamic = 'force-dynamic'` |
| Cache stale | `revalidatePath('/')` Server Action sonunda |

## Resources
| Kaynak | Link |
|--------|------|
| Next.js | https://nextjs.org/docs |
| Prisma | https://www.prisma.io/docs |
| NextAuth.js | https://authjs.dev |
| shadcn/ui | https://ui.shadcn.com |
| Tailwind CSS | https://tailwindcss.com |
| Zod | https://zod.dev |
| Vercel | https://vercel.com |

## CLI
```bash
npx create-next-app@latest my-app --ts --tailwind --app --src-dir
npm i prisma @prisma/client next-auth zod
npx prisma init
npx prisma db push / migrate dev
npx shadcn-ui@latest init
npm run dev
```

## Debug Günlüğü
| Tarih | Hata | Çözüm |
|-------|------|--------|
| [—]   | [—]  | [—]    |
