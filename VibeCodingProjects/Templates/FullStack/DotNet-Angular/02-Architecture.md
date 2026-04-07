# 🏗️ Architecture — .NET + Angular

## Monorepo Yapısı
```
project/
├── backend/
│   ├── src/
│   │   ├── Domain/              → Entity, Interface, ValueObject
│   │   ├── Application/         → CQRS/Service, DTO, Mapping, Validation
│   │   ├── Infrastructure/      → EF Core, Repository, External Services
│   │   └── WebAPI/              → Controller, Middleware, Program.cs
│   └── tests/
│       ├── Application.UnitTests/
│       ├── Infrastructure.IntegrationTests/
│       └── WebAPI.IntegrationTests/
├── frontend/
│   └── src/
│       ├── app/
│       │   ├── core/            → Guards, Interceptors, Services, Models
│       │   │   ├── guards/      → auth.guard.ts, role.guard.ts
│       │   │   ├── interceptors/ → token.interceptor.ts, error.interceptor.ts
│       │   │   ├── services/    → auth.service.ts, api.service.ts
│       │   │   └── models/      → user.model.ts, product.model.ts
│       │   ├── shared/          → Paylaşılan component, directive, pipe
│       │   │   ├── components/  → ConfirmDialog, LoadingSpinner, Pagination
│       │   │   ├── directives/  → highlight.directive.ts
│       │   │   └── pipes/       → currency-tr.pipe.ts
│       │   ├── features/        → Lazy-loaded feature modülleri
│       │   │   ├── auth/        → login/, register/, forgot-password/
│       │   │   ├── dashboard/   → dashboard.component.ts
│       │   │   ├── products/    → list/, detail/, form/
│       │   │   └── admin/       → user-management/, settings/
│       │   ├── app.component.ts
│       │   ├── app.routes.ts    → Lazy-loaded route tanımları
│       │   └── app.config.ts    → Providers (HttpClient, Guards)
│       ├── environments/        → environment.ts, environment.prod.ts
│       ├── assets/
│       └── styles/              → Global SCSS
├── docker-compose.yml
└── README.md
```

## .NET Clean Architecture Katmanları
```
WebAPI → Application → Domain (bağımlılık içe doğru)
WebAPI → Infrastructure → Application (DI ile)
Domain: Entity, Interface (hiçbir şeye bağımlı DEĞİL)
Application: DTO, Service/Handler, Mapping, Validation
Infrastructure: EF Core DbContext, Repository impl, Email, Cache
WebAPI: Controller, Middleware, DI registration
```

## Angular Lazy Loading + Standalone
```typescript
// app.routes.ts (Standalone)
export const routes: Routes = [
    { path: '', redirectTo: 'dashboard', pathMatch: 'full' },
    { path: 'login', loadComponent: () => import('./features/auth/login/login.component').then(m => m.LoginComponent) },
    { 
        path: 'dashboard', 
        canActivate: [authGuard],
        loadChildren: () => import('./features/dashboard/dashboard.routes').then(m => m.DASHBOARD_ROUTES) 
    },
    { 
        path: 'products', 
        canActivate: [authGuard],
        loadChildren: () => import('./features/products/products.routes').then(m => m.PRODUCT_ROUTES) 
    },
    { 
        path: 'admin', 
        canActivate: [authGuard, roleGuard],
        data: { roles: ['Admin'] },
        loadChildren: () => import('./features/admin/admin.routes').then(m => m.ADMIN_ROUTES) 
    },
];
```

## HTTP Interceptor (JWT Token)
```typescript
// core/interceptors/token.interceptor.ts
export const tokenInterceptor: HttpInterceptorFn = (req, next) => {
    const token = inject(AuthService).getToken();
    if (token) {
        req = req.clone({ setHeaders: { Authorization: `Bearer ${token}` } });
    }
    return next(req).pipe(
        catchError((error: HttpErrorResponse) => {
            if (error.status === 401) { inject(Router).navigate(['/login']); }
            return throwError(() => error);
        })
    );
};
```

## Angular Service + RxJS
```typescript
@Injectable({ providedIn: 'root' })
export class ProductService {
    private apiUrl = `${environment.apiUrl}/products`;
    constructor(private http: HttpClient) {}
    
    getAll(params?: { page: number; pageSize: number }): Observable<PagedResult<Product>> {
        return this.http.get<PagedResult<Product>>(this.apiUrl, { params: { ...params } });
    }
    getById(id: number): Observable<Product> { return this.http.get<Product>(`${this.apiUrl}/${id}`); }
    create(product: CreateProductDto): Observable<Product> { return this.http.post<Product>(this.apiUrl, product); }
    update(id: number, product: UpdateProductDto): Observable<void> { return this.http.put<void>(`${this.apiUrl}/${id}`, product); }
    delete(id: number): Observable<void> { return this.http.delete<void>(`${this.apiUrl}/${id}`); }
}
```

## Angular Reactive Forms + Validation
```typescript
// features/products/form/product-form.component.ts
export class ProductFormComponent {
    form = inject(FormBuilder).group({
        name: ['', [Validators.required, Validators.minLength(3), Validators.maxLength(200)]],
        price: [0, [Validators.required, Validators.min(0.01)]],
        categoryId: [null, Validators.required],
        description: ['', Validators.maxLength(2000)]
    });
    
    onSubmit() {
        if (this.form.invalid) { this.form.markAllAsTouched(); return; }
        this.productService.create(this.form.value).subscribe({
            next: () => { this.router.navigate(['/products']); this.toastr.success('Ürün oluşturuldu'); },
            error: (err) => this.toastr.error(err.error.message)
        });
    }
}
```
