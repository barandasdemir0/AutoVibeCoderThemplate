# 📝 Steps | 📂 | 🐛 | 📚 — Next.js FullStack (03-06)
## Steps
1. [ ] `npx create-next-app@latest --ts --tailwind --app --src-dir`
2. [ ] Prisma: `npx prisma init` → schema → `db push`
3. [ ] `lib/db.ts` → Prisma singleton
4. [ ] Server Actions: `actions/products.ts` → CRUD
5. [ ] NextAuth: `lib/auth.ts` → `app/api/auth/[...nextauth]/route.ts`
6. [ ] Pages: layout, dashboard, products CRUD
7. [ ] `middleware.ts` → auth redirect
8. [ ] shadcn/ui components
9. [ ] Vercel deploy

## Best Practices
- Server Component default, `'use client'` sadece interaktif
- Server Actions > API Routes (form, mutation)
- Prisma singleton (hot reload leak önleme)
- Zod validation → Server Action'da mutlaka
- `revalidatePath()` → cache temizle
- `loading.tsx` → her route'a UX için

## Debug Günlüğü
| Tarih | Hata | Çözüm |
|-------|------|--------|
| [—]   | [—]  | [—]    |
