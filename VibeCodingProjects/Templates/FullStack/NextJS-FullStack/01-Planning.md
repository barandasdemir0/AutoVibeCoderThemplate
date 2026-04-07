# 📋 Planning — Next.js Full Stack (Monolith)

## 🎯 Proje
- **Tip:** Full-stack tek proje (Server + Client birlikte)
- **Framework:** Next.js 14+ (App Router)
- **DB:** PostgreSQL + Prisma / MongoDB + Mongoose
- **Auth:** NextAuth.js v5 / Clerk

## 🛠️ Tech Stack
| Katman | Teknoloji |
|--------|-----------|
| Framework | Next.js 14+ (App Router) |
| Rendering | SSR + SSG + CSR (hybrid) |
| ORM | Prisma / Drizzle |
| Auth | NextAuth.js v5 |
| Styling | Tailwind CSS |
| UI Kit | shadcn/ui |
| Validation | Zod |
| State | React Context / Zustand (client) |
| Deploy | Vercel |

## ⭐ MVP
1. [ ] Next.js App Router proje
2. [ ] Prisma + DB bağlantısı
3. [ ] Server Components + Server Actions
4. [ ] NextAuth.js auth
5. [ ] CRUD (full-stack, API route yok — Server Actions)
6. [ ] Middleware (auth redirect)
7. [ ] Deploy (Vercel)

# 🏗️ Architecture
```
project/
├── src/
│   ├── app/
│   │   ├── layout.tsx, page.tsx, loading.tsx, error.tsx, not-found.tsx
│   │   ├── globals.css
│   │   ├── (auth)/ (login/page.tsx, register/page.tsx)
│   │   ├── dashboard/
│   │   │   ├── layout.tsx (sidebar + header)
│   │   │   ├── page.tsx
│   │   │   └── products/ (page.tsx, [id]/page.tsx, new/page.tsx)
│   │   └── api/ (yalnız gerekirse — webhook, external API)
│   │       └── webhooks/stripe/route.ts
│   ├── components/
│   │   ├── ui/ (Button, Input, Card, Modal — shadcn/ui)
│   │   ├── layout/ (Header, Sidebar, Footer)
│   │   └── forms/ (ProductForm, LoginForm)
│   ├── lib/
│   │   ├── db.ts          → Prisma client singleton
│   │   ├── auth.ts        → NextAuth config
│   │   ├── validations.ts → Zod schemas
│   │   └── utils.ts       → Helper functions
│   ├── actions/           → Server Actions (form submit, CRUD)
│   │   ├── auth.ts        → login, register, logout
│   │   └── products.ts    → create, update, delete
│   ├── types/ (index.ts)
│   └── hooks/ (useAuth.ts)
├── prisma/
│   ├── schema.prisma      → DB schema
│   └── seed.ts            → Test data
├── middleware.ts           → Auth redirect
├── .env
├── next.config.js
├── tailwind.config.ts
└── package.json
```

## Server Actions (API Routes Yerine)
```tsx
// actions/products.ts
'use server';
import { db } from '@/lib/db';
import { productSchema } from '@/lib/validations';
import { revalidatePath } from 'next/cache';

export async function createProduct(formData: FormData) {
    const data = productSchema.parse({
        name: formData.get('name'),
        price: Number(formData.get('price')),
    });
    await db.product.create({ data });
    revalidatePath('/dashboard/products');
}
```

## Prisma ORM Best Practices
```prisma
model User {
    id        String   @id @default(cuid())
    name      String
    email     String   @unique
    password  String
    role      Role     @default(USER)
    products  Product[]
    createdAt DateTime @default(now())
    @@map("users") // DB tablo adı
}

enum Role { USER ADMIN }
```

```typescript
// Prisma Client Singleton (lib/db.ts)
import { PrismaClient } from '@prisma/client';
const globalForPrisma = globalThis as unknown as { prisma: PrismaClient };
export const db = globalForPrisma.prisma || new PrismaClient();
if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = db;
```

## Best Practices
1. **Server Components default**: Sadece interaktif UI'da `'use client'`
2. **Server Actions**: Form submit, CRUD → API route GEREKMEZ
3. **Prisma Singleton**: Hot reload'da connection leak önle
4. **Zod Validation**: Server Action'da mutlaka validate et
5. **Middleware**: Auth redirect → `matcher` ile route koru
6. **revalidatePath()**: Data değişince cache'i temizle
7. **Loading UI**: `loading.tsx` → skeleton/spinner

# 📝 Steps | 🐛 Debug | 📚 Resources
## Steps: `npx create-next-app` → Prisma setup → models → Server Actions → NextAuth → UI → Deploy
## Debug: Hydration → `'use client'` kontrol, Server Action error → Zod validation, Prisma → `npx prisma db push`, Middleware → root'ta
## Resources: nextjs.org, prisma.io, next-auth.js.org, ui.shadcn.com, tailwindcss.com
