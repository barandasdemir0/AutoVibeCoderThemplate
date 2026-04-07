# 📋 Planning — Express + React (MERN Stack)

## 🎯 Proje
- **Backend:** Node.js + Express.js — MVC + Middleware
- **Frontend:** React + Vite
- **DB:** MongoDB (Mongoose ODM) veya PostgreSQL (Prisma)
- **Fullstack Name:** MERN (MongoDB, Express, React, Node)

## 🛠️ Tech Stack
| Katman | Backend | Frontend |
|--------|---------|----------|
| Runtime | Node.js | Vite |
| Framework | Express.js | React 18 |
| ORM/ODM | Mongoose / Prisma | — |
| Auth | JWT (jsonwebtoken) | Axios + Token |
| Validation | Joi / express-validator | React Hook Form |
| State | — | Redux/Zustand |

# 🏗️ Architecture
```
project/
├── server/
│   ├── src/
│   │   ├── config/ (db.js, env.js)
│   │   ├── models/ (User.js, Product.js — Mongoose schema)
│   │   ├── routes/ (authRoutes.js, productRoutes.js)
│   │   ├── controllers/ (authController.js, productController.js)
│   │   ├── services/ (userService.js — business logic)
│   │   ├── middleware/ (auth.js, errorHandler.js, validate.js)
│   │   ├── validators/ (productValidator.js — Joi schemas)
│   │   ├── utils/ (helpers.js)
│   │   └── app.js
│   ├── .env
│   └── package.json
├── client/
│   ├── src/ (components/, pages/, services/, hooks/, store/)
│   ├── package.json
│   └── vite.config.js
├── docker-compose.yml
└── README.md
```

## Mongoose (MongoDB) Best Practices
```javascript
// Schema + Virtuals + Methods
const userSchema = new mongoose.Schema({
    email: { type: String, required: true, unique: true, lowercase: true, trim: true },
    password: { type: String, required: true, select: false, minlength: 8 },
    role: { type: String, enum: ['user', 'admin'], default: 'user' },
}, { timestamps: true, toJSON: { virtuals: true } });

// Pre-save hook (password hash)
userSchema.pre('save', async function(next) {
    if (!this.isModified('password')) return next();
    this.password = await bcrypt.hash(this.password, 12);
});

// Instance method
userSchema.methods.comparePassword = async function(candidatePassword) {
    return bcrypt.compare(candidatePassword, this.password);
};

// Population (join benzeri)
const product = await Product.findById(id).populate('category').populate('createdBy', 'name email');
```

## Prisma (SQL alternatif) Best Practices
```javascript
// schema.prisma
model Product {
    id        Int      @id @default(autoincrement())
    name      String
    price     Decimal
    category  Category @relation(fields: [categoryId], references: [id])
    categoryId Int
}
// Query
const products = await prisma.product.findMany({ include: { category: true }, take: 20 });
```

# 📝 Steps | 🐛 Debug | 📚 Resources
## Steps: `npm init` → Express + Mongoose → models → controllers → routes → React SPA → Axios → JWT auth
## Debug: MongoDB auth → Atlas IP whitelist, CORS → `cors()`, body undefined → `express.json()`, populate → field path
## Resources: expressjs.com, mongoosejs.com, prisma.io, react.dev
