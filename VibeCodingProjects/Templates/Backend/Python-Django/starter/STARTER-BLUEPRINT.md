# Starter Blueprint — Python Django (MVT + DRF + Django ORM)
## Mimari: MVT (Model-View-Template) + Django REST Framework
## Klasör Yapısı
```
config/                      → settings.py, urls.py, wsgi.py
apps/
├── accounts/
│   ├── models.py            → CustomUser (AbstractUser)
│   ├── serializers.py       → DRF serializers
│   ├── views.py             → APIView / ViewSet
│   ├── urls.py              → router
│   ├── services.py          → İş mantığı
│   └── tests.py
├── core/
│   ├── permissions.py       → Custom permissions
│   ├── pagination.py        → Custom pagination
│   └── exceptions.py        → Custom exception handler
manage.py
requirements.txt
.env.example
```
## Paketler: Django, djangorestframework, django-cors-headers, djangorestframework-simplejwt, python-dotenv, psycopg2-binary
## settings.py SIRA: INSTALLED_APPS'ta corsheaders → rest_framework → apps.accounts
## MIDDLEWARE SIRA: CorsMiddleware EN ÜSTTE
