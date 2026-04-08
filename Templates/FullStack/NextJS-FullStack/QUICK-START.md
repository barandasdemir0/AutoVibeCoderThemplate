## SEQUENCE-ENGINE v1 (ZORUNLU)
Bu template ile calisirken sirayi bozmak YASAK:
1) QUICK-START.md
2) 01-Planning.md
3) 02-Architecture.md
4) 03-StepByStep.md
5) 04-FilesStructure.md
6) 05-DebugTips.md
7) 06-Resources.md

Kural:
- Her dosyadan sonra 3-5 maddelik "cikarim ozeti" yaz.
- Ozeti yazmadan sonraki dosyaya gecme.
- 7 dosya tamamlanmadan kod uretimine baslama.
- Bu akisin detay standardi: Templates/_Universal/TEMPLATE-SEQUENCE-ENGINE.md

---
# ⚡ QUICK-START — Next.js Full Stack (Prisma + NextAuth + shadcn)

> AI'a sadece BU dosyayı + proje fikrini ver. Gerisini otonom yapacak.

---

## AI TALİMATI

Sen bir otonom AI geliştiricisisin. Kullanıcı sana bir proje fikri verecek. 
Hiçbir şey sormadan, aşağıdaki kurallara göre A'dan Z'ye projeyi tamamla.

---

## TECH STACK (SABİT)
- **Framework:** Next.js 14+ (App Router)
- **Dil:** TypeScript (strict)
- **DB:** PostgreSQL + Prisma ORM
- **Auth:** NextAuth.js v5 (Auth.js)
- **CSS:** Tailwind CSS + shadcn/ui
- **Validation:** Zod
- **Form:** React Hook Form + Zod resolver
- **Deploy:** Vercel
- **Test:** Jest / Vitest + React Testing Library

---

## MİMARİ (ZORUNLU)
```
src/
├── app/
│   ├── layout.tsx            → Root (providers, fonts, metadata)
│   ├── page.tsx              → Landing page
│   ├── loading.tsx           → Global loading
│   ├── error.tsx             → Global error
│   ├── not-found.tsx         → 404
│   ├── globals.css
│   ├── (auth)/
│   │   ├── login/page.tsx
│   │   └── register/page.tsx
│   ├── dashboard/
│   │   ├── layout.tsx
│   │   └── page.tsx
│   └── api/
│       └── auth/[...nextauth]/route.ts
├── actions/                  → Server Actions (mutations)
│   ├── auth.actions.ts       → signUp, signIn
│   └── [entity].actions.ts   → create, update, delete
├── components/
│   ├── ui/                   → shadcn/ui (auto-generated)
│   ├── layout/               → Header, Sidebar, Footer, MobileNav
│   └── [entity]/             → EntityForm, EntityList, EntityCard
├── lib/
│   ├── db.ts                 → Prisma client singleton
│   ├── auth.ts               → NextAuth config
│   ├── utils.ts              → cn() helper
│   └── validations.ts        → Zod schemas
├── hooks/
├── store/                    → Zustand (client-only state)
├── types/
├── middleware.ts             → Auth route protection
prisma/
├── schema.prisma             → DB schema
└── seed.ts                   → Seed data
.env
.env.example
```

---

## DOSYA ÜRETME SIRASI
```
1. npx create-next-app@latest ./ --ts --tailwind --app --src-dir
2. npm i prisma @prisma/client next-auth@beta zod @hookform/resolvers react-hook-form
3. npx prisma init → schema.prisma + .env (DATABASE_URL)
4. npx shadcn-ui@latest init → components/ui/
5. prisma/schema.prisma → User, Account, Session, [Entity] models
6. npx prisma db push (veya migrate dev)
7. src/lib/db.ts → Prisma client singleton (globalForPrisma)
8. src/lib/auth.ts → NextAuth config (Prisma adapter)
9. src/lib/validations.ts → Zod schemas (createEntity, updateEntity)
10. src/lib/utils.ts → cn() (clsx + twMerge)
11. src/app/api/auth/[...nextauth]/route.ts → NextAuth handler
12. src/middleware.ts → auth middleware + matcher
13. src/actions/auth.actions.ts → signUp server action
14. src/actions/[entity].actions.ts → CRUD server actions
15. shadcn components ekle → button, input, card, dialog, table, form
16. src/components/layout/ → Header, Sidebar, Footer
17. src/components/[entity]/ → EntityForm, EntityList, EntityCard
18. src/app/layout.tsx → SessionProvider + ThemeProvider + font + metadata
19. src/app/page.tsx → Landing
20. src/app/(auth)/ → Login, Register
21. src/app/dashboard/ → Dashboard layout + pages
22. prisma/seed.ts → Demo data
23. tests/ → Server action + component testleri
```

---

## ⚠️ ZORUNLU KURALLAR
```
✅ HER ZAMAN:
- Server Actions (mutations) → API Routes yerine
- Server Components (data fetch) → useEffect yerine
- Prisma: tek global instance (lib/db.ts)
- Zod: her mutation'da validate
- revalidatePath: mutation sonrası cache temizle
- TypeScript strict: Prisma type'larını kullan
- Metadata: her sayfada title + description
- Loading/Error UI: her route segment
- next/image + next/link
- next/font (Google Fonts)

❌ ASLA:
- Client component'te Prisma → server-only
- Raw SQL (zorunlu değilse) → Prisma ORM
- useEffect data fetch → Server Component async
- API Route (basit CRUD) → Server Actions
- Hardcoded DB URL → .env
```

---

## AUTH AKISI
```
1. middleware.ts: /dashboard/* → auth kontrol
2. Auth yoksa → /login redirect
3. Login: Server Action → Prisma'dan user bul → NextAuth signIn
4. Register: Server Action → hash password → Prisma create
5. Session: Server Component'te → auth() call
6. Logout: signOut() client-side
```

---

## PRISMA PATTERN
```prisma
// prisma/schema.prisma
model User {
  id        Int      @id @default(autoincrement())
  email     String   @unique
  name      String?
  password  String
  role      Role     @default(USER)
  posts     Post[]
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model Post {
  id        Int      @id @default(autoincrement())
  title     String
  content   String?
  published Boolean  @default(false)
  author    User     @relation(fields: [authorId], references: [id])
  authorId  Int
  createdAt DateTime @default(now())
}

enum Role { USER ADMIN }
```

---

## SIK HATALAR → ÇÖZÜM
| Hata | Çözüm |
|------|-------|
| `PrismaClient is not defined` | lib/db.ts → globalForPrisma singleton |
| `Invalid prisma.X.findMany() invocation` | schema kontrol → npx prisma generate |
| `Server Action: cannot read property` | Zod safeParse → error return |
| `auth() returns null` | middleware matcher doğru mu? session strategy? |
| `NEXTAUTH_URL missing` | .env → NEXTAUTH_URL=http://localhost:3000 |
| `Hydration error` | Client/Server component ayırımı kontrol |
| `Prisma migration drift` | npx prisma migrate reset (DEV only!) |
| `shadcn import error` | npx shadcn-ui@latest add [component] |

---

## BİTİRME CHECKLIST
```
- [ ] npm run dev çalışıyor
- [ ] npm run build hatasız (SSR + SSG)
- [ ] Auth (register + login + session + logout) çalışıyor
- [ ] CRUD Server Actions çalışıyor
- [ ] Prisma migration güncel
- [ ] Loading / Error / Not Found sayfaları var
- [ ] Server/Client component doğru ayrılmış
- [ ] Responsive (Tailwind)
- [ ] Dark mode (next-themes)
- [ ] SEO metadata her sayfada
- [ ] Zod validation her formda
- [ ] TypeScript strict hata yok
- [ ] .env.example var (DATABASE_URL, NEXTAUTH_SECRET, NEXTAUTH_URL)
- [ ] .gitignore var
- [ ] README.md var
- [ ] Vercel deploy hazır
```

