# 📋 Planning — Angular Test Suite (Karma/Jest + Cypress)

## 🎯
- **Unit/Component:** Karma + Jasmine (default) veya Jest
- **E2E:** Cypress
- **HTTP Mock:** HttpClientTestingModule

## Klasör Yapısı
```
src/app/
├── features/
│   ├── products/
│   │   ├── product-list.component.ts
│   │   └── product-list.component.spec.ts    → Component test
│   └── auth/
│       ├── login.component.ts
│       └── login.component.spec.ts
├── core/
│   ├── services/
│   │   ├── auth.service.ts
│   │   └── auth.service.spec.ts              → Service test (HttpMock)
│   └── guards/
│       ├── auth.guard.ts
│       └── auth.guard.spec.ts
cypress/
├── e2e/
│   ├── auth.cy.ts
│   └── products.cy.ts
└── support/
    └── commands.ts
```

## Component Test
```typescript
describe('ProductListComponent', () => {
    let component: ProductListComponent;
    let fixture: ComponentFixture<ProductListComponent>;
    let productService: jasmine.SpyObj<ProductService>;
    
    beforeEach(async () => {
        const spy = jasmine.createSpyObj('ProductService', ['getAll']);
        await TestBed.configureTestingModule({
            imports: [ProductListComponent],
            providers: [{ provide: ProductService, useValue: spy }]
        }).compileComponents();
        fixture = TestBed.createComponent(ProductListComponent);
        component = fixture.componentInstance;
        productService = TestBed.inject(ProductService) as jasmine.SpyObj<ProductService>;
    });
    
    it('should load products on init', () => {
        const products = [{ id: 1, name: 'Laptop', price: 15000 }];
        productService.getAll.and.returnValue(of(products));
        fixture.detectChanges();
        expect(component.products.length).toBe(1);
    });
});
```

## Service Test (HttpClientTestingModule)
```typescript
describe('AuthService', () => {
    let service: AuthService;
    let httpMock: HttpTestingController;
    
    beforeEach(() => {
        TestBed.configureTestingModule({
            imports: [HttpClientTestingModule],
            providers: [AuthService]
        });
        service = TestBed.inject(AuthService);
        httpMock = TestBed.inject(HttpTestingController);
    });
    
    it('should login and return token', () => {
        service.login('test@test.com', 'pass').subscribe(res => {
            expect(res.token).toBeTruthy();
        });
        const req = httpMock.expectOne('/api/auth/login');
        expect(req.request.method).toBe('POST');
        req.flush({ token: 'mock-jwt-token' });
    });
    
    afterEach(() => httpMock.verify());
});
```

## Cypress E2E
```typescript
describe('Login Flow', () => {
    it('should login and redirect to dashboard', () => {
        cy.visit('/login');
        cy.get('[data-cy="email"]').type('admin@test.com');
        cy.get('[data-cy="password"]').type('Admin123!');
        cy.get('[data-cy="submit"]').click();
        cy.url().should('include', '/dashboard');
        cy.get('[data-cy="welcome"]').should('contain', 'Hoşgeldiniz');
    });
});
```

## Debug + Resources
- **"No provider for"** → TestBed'de providers eksik
- **HttpMock "no match"** → URL exact match, httpMock.verify() kontrol
- **async test** → fakeAsync + tick() veya waitForAsync
- Angular Testing: https://angular.dev/guide/testing | Cypress: https://cypress.io
