# Starter Blueprint — Python Flask (Blueprint + Factory + SQLAlchemy)
## Mimari: Blueprint + Application Factory
## Klasör Yapısı
```
app/
├── __init__.py              → create_app() factory
├── config.py                → Config class (.env)
├── extensions.py            → db, migrate, jwt, cors init
├── models/user.py           → SQLAlchemy model
├── schemas/user.py          → Marshmallow schema
├── services/user_service.py → İş mantığı
├── api/auth.py              → Blueprint /api/auth
├── api/users.py             → Blueprint /api/users
├── utils/security.py        → password hash, JWT
└── utils/errors.py          → Custom exceptions
migrations/                  → Flask-Migrate
tests/test_auth.py
requirements.txt
.env.example
```
## Paketler: Flask, SQLAlchemy, Flask-Migrate, Flask-JWT-Extended, Flask-CORS, marshmallow
