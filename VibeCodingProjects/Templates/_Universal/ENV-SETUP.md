# 🔧 ENV-SETUP.md — Ortam Kurulum Rehberi (Her Stack İçin)

> AI projeye başlamadan ÖNCE bu ortam hazır olmalı.
> Kullanıcıya "şunu kur" demek yerine bu dosyayı kontrol et.

---

## 🖥️ Technolojiye Göre Gerekli Kurulumlar

### .NET
```powershell
# Kontrol
dotnet --version        # 8.0+ olmalı
# Kurulum: https://dotnet.microsoft.com/download
# Araçlar
dotnet tool install --global dotnet-ef   # EF Core CLI
```

### Python
```bash
python --version        # 3.10+ olmalı
pip --version
# Sanal ortam ZORUNLU
python -m venv venv
venv\Scripts\activate   # Windows
source venv/bin/activate # Linux/Mac
```

### Node.js
```bash
node --version          # 18+ olmalı
npm --version           # 9+ olmalı
# Opsiyonel
npx --version
```

### Java
```bash
java --version          # 17+ olmalı (Spring Boot 3)
mvn --version           # Maven
# Kurulum: https://adoptium.net
```

### PHP
```bash
php --version           # 8.2+ olmalı
composer --version
# Kurulum: https://getcomposer.org
```

### Flutter
```bash
flutter doctor          # Tüm ortamı kontrol eder
flutter --version       # 3.x+
```

### Android (Kotlin)
```
Android Studio → SDK Manager → API 34+
Kotlin plugin aktif
Gradle 8+
```

### iOS (Swift)
```
Xcode 15+ → App Store'dan indir
xcrun simctl list      # Simulator kontrol
```

### Database
```bash
# PostgreSQL
psql --version
# MongoDB
mongod --version
# Redis
redis-cli ping
# SQLite → Python/Node ile birlikte gelir
```

### Docker
```bash
docker --version
docker-compose --version
```

---

## 📋 Her Proje İçin .gitignore Şablonu

```gitignore
# Dependencies
node_modules/
vendor/
venv/
.venv/
__pycache__/
*.pyc

# Environment
.env
.env.local
.env.production

# Build
dist/
build/
out/
bin/
obj/
target/

# IDE
.idea/
.vscode/
*.swp
*.suo
*.user
.DS_Store
Thumbs.db

# Logs
logs/
*.log

# Database
*.sqlite
*.db

# ML/AI
checkpoints/
runs/
wandb/
data/raw/
*.pt
*.pth
*.onnx
*.h5
*.tflite

# OS
.DS_Store
Thumbs.db
desktop.ini
```

---

## 🔑 .env Şablonu (Her Projeye Uyarla)

```env
# App
APP_NAME=MyProject
APP_ENV=development
APP_PORT=3000
APP_SECRET=change-this-to-a-random-64-char-string

# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=myproject
DB_USER=postgres
DB_PASSWORD=your-password-here
DATABASE_URL=postgresql://postgres:password@localhost:5432/myproject

# JWT
JWT_SECRET=your-jwt-secret-min-32-chars
JWT_EXPIRY=15m
JWT_REFRESH_EXPIRY=7d

# API Keys (ASLA commit'leme!)
OPENAI_API_KEY=sk-...
GEMINI_API_KEY=AI...
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PUBLIC_KEY=pk_test_...

# Email
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your@gmail.com
SMTP_PASS=app-password

# Frontend
VITE_API_URL=http://localhost:5000/api
NEXT_PUBLIC_API_URL=http://localhost:5000/api
```
