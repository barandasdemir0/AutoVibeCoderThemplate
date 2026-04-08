# 🏗️ Architecture | 📂 Files | 🐛 Debug | 📚 Resources — MERN Stack

## Dosya Açıklamaları
| Dosya | Ne İş Yapar |
|-------|-------------|
| `models/User.js` | Mongoose schema — DB yapısı, hooks, methods |
| `controllers/*.js` | Request işleme, service çağrısı, response dönme |
| `services/*.js` | İş mantığı (controller'dan ayrılmış) |
| `routes/*.js` | Express Router → URL → controller mapping |
| `middleware/auth.js` | JWT token doğrulama middleware |
| `middleware/errorHandler.js` | Global error handler (try/catch yerine) |
| `middleware/validate.js` | Joi/express-validator ile input doğrulama |
| `config/db.js` | MongoDB/PostgreSQL bağlantısı |
| `client/services/api.js` | Axios instance + token interceptor |
| `client/store/` | Redux/Zustand — auth + feature state |

## Express Middleware Best Practices
```javascript
// Async handler wrapper (try/catch kalıbı yerine)
const asyncHandler = fn => (req, res, next) => Promise.resolve(fn(req, res, next)).catch(next);

// Global error handler
app.use((err, req, res, next) => {
    const status = err.statusCode || 500;
    res.status(status).json({ success: false, message: err.message });
});

// Rate limiting
const rateLimit = require('express-rate-limit');
app.use('/api/', rateLimit({ windowMs: 15 * 60 * 1000, max: 100 }));
```

## Debug Tips
| Sorun | Çözüm |
|-------|-------|
| `req.body` undefined | `app.use(express.json())` eklendi mi? |
| MongoDB auth fail | Atlas → Network Access → IP ekle |
| CORS | `app.use(cors({ origin: 'http://localhost:5173' }))` |
| Populate boş | Field adı doğru mu? `ref: 'ModelName'` eşleşiyor mu? |
| JWT invalid | Secret key aynı mı? Token prefix `Bearer ` |

## Resources
| Kaynak | Link |
|--------|------|
| Express | https://expressjs.com |
| Mongoose | https://mongoosejs.com |
| Prisma | https://www.prisma.io |
| React | https://react.dev |
| JWT | https://jwt.io |

## CLI
```bash
# Server
npm init -y && npm i express mongoose dotenv cors helmet jsonwebtoken bcryptjs
npm i -D nodemon
# Client
npm create vite@latest client -- --template react
npm i axios react-router-dom @reduxjs/toolkit react-redux
# Run
npm run dev  (server: nodemon, client: vite)
```

## Debug Günlüğü
| Tarih | Katman | Hata | Çözüm |
|-------|--------|------|--------|
| [—]   | [—]    | [—]  | [—]    |
