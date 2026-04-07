# Starter Blueprints — Frontend Templates

## Angular (Module-Based + RxJS + HttpClient)
```
src/app/
├── core/
│   ├── services/auth.service.ts, api.service.ts
│   ├── guards/auth.guard.ts
│   ├── interceptors/token.interceptor.ts, error.interceptor.ts
│   └── models/user.model.ts
├── shared/
│   ├── components/button/, input/, loading/, error-state/
│   └── shared.module.ts
├── features/
│   ├── auth/login/, register/ (component + module)
│   └── home/home.component.ts
├── app-routing.module.ts
├── app.module.ts
└── app.component.ts
environment.ts → apiUrl
```

## Vue 3 (Composition API + Pinia + Vue Router)
```
src/
├── assets/main.css (CSS variables, reset)
├── router/index.js
├── stores/auth.js (Pinia)
├── services/api.js (axios instance)
├── views/LoginView.vue, RegisterView.vue, HomeView.vue, NotFound.vue
├── components/layout/NavBar.vue, AppButton.vue, AppInput.vue
├── composables/useAuth.js, useApi.js
├── App.vue
└── main.js
```

## NextJS (App Router + Server Actions + Prisma)
```
app/
├── layout.tsx → RootLayout (font, metadata, providers)
├── page.tsx → Home
├── (auth)/login/page.tsx, register/page.tsx
├── dashboard/page.tsx, layout.tsx
├── api/auth/[...nextauth]/route.ts
├── api/health/route.ts
components/ui/Button.tsx, Input.tsx, Card.tsx
lib/db.ts (Prisma), auth.ts (NextAuth), utils.ts
prisma/schema.prisma
styles/globals.css
.env.local.example
```

## HTML-CSS-JS (Vanilla — BEM + Semantic)
```
index.html, login.html, register.html, dashboard.html
css/style.css, variables.css, components.css
js/app.js, auth.js, api.js, utils.js
assets/images/, icons/
```

## HTML-CSS-Bootstrap (Bootstrap 5 + Responsive)
```
index.html → Bootstrap CDN, responsive navbar
pages/login.html, register.html, dashboard.html
css/custom.css → Bootstrap override
js/main.js, auth.js
```
