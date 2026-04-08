# 📋 Planning — Node.js Test Suite (Jest + SuperTest)

## 🎯
- **Framework:** Jest (Facebook, en popüler)
- **HTTP Test:** SuperTest
- **Mock:** jest.mock / jest.fn
- **Coverage:** --coverage (built-in)
- **E2E:** Cypress / Playwright

## npm Paketleri
```bash
npm install -D jest supertest @types/jest ts-jest
```

## Klasör Yapısı
```
tests/
├── setup.js                  → DB bağlantı, cleanup
├── unit/
│   ├── user.service.test.js
│   └── product.service.test.js
├── integration/
│   ├── auth.test.js
│   ├── product.test.js
│   └── middleware.test.js
└── fixtures/
    ├── users.js
    └── products.js
```

## jest.config.js
```javascript
module.exports = {
    testEnvironment: 'node',
    setupFilesAfterSetup: ['./tests/setup.js'],
    coverageDirectory: 'coverage',
    collectCoverageFrom: ['src/**/*.js', '!src/app.js'],
};
```

## Unit Test
```javascript
const UserService = require('../src/services/user.service');
jest.mock('../src/models/user.model');
const User = require('../src/models/user.model');

describe('UserService', () => {
    afterEach(() => jest.clearAllMocks());
    
    it('should get user by id', async () => {
        const mockUser = { _id: '1', name: 'Test', email: 't@t.com' };
        User.findById.mockResolvedValue(mockUser);
        const result = await UserService.getById('1');
        expect(result).toEqual(mockUser);
        expect(User.findById).toHaveBeenCalledWith('1');
    });
    
    it('should throw when user not found', async () => {
        User.findById.mockResolvedValue(null);
        await expect(UserService.getById('999')).rejects.toThrow('Not found');
    });
});
```

## Integration Test (SuperTest)
```javascript
const request = require('supertest');
const app = require('../src/app');
let token;

beforeAll(async () => {
    await request(app).post('/api/auth/register').send({ email: 'test@t.com', password: 'Test1234!' });
    const res = await request(app).post('/api/auth/login').send({ email: 'test@t.com', password: 'Test1234!' });
    token = res.body.token;
});

describe('GET /api/products', () => {
    it('200 with auth', async () => {
        const res = await request(app).get('/api/products').set('Authorization', `Bearer ${token}`);
        expect(res.status).toBe(200);
        expect(res.body.success).toBe(true);
    });
    it('401 without auth', async () => {
        const res = await request(app).get('/api/products');
        expect(res.status).toBe(401);
    });
});
```

## Debug + Resources
- **"Cannot find module"** → jest.config paths, moduleNameMapper
- **async leak** → `--forceExit --detectOpenHandles`
- **DB cleanup** → afterAll: close connection
- Jest: https://jestjs.io | SuperTest: https://github.com/ladjs/supertest
