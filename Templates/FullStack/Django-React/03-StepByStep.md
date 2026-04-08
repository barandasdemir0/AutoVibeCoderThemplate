# 📝 Step-by-Step | 📂 Files | 🐛 Debug | 📚 Resources — Django + React

## Adımlar
1. [ ] `django-admin startproject config backend && cd backend`
2. [ ] `python manage.py startapp accounts` + `startapp products`
3. [ ] Models → `makemigrations` → `migrate`
4. [ ] DRF Serializers + ViewSets + Router
5. [ ] SimpleJWT → Token endpoints
6. [ ] `npm create vite@latest frontend -- --template react`
7. [ ] React: pages, routing, API service, auth flow
8. [ ] CORS: `pip install django-cors-headers`
9. [ ] Docker Compose

## Dosya Açıklamaları
| Dosya | Ne İş Yapar |
|-------|-------------|
| `config/settings.py` | Django ayarları, INSTALLED_APPS, DB, AUTH, CORS |
| `apps/products/models.py` | ORM ile DB tablo tanımları |
| `apps/products/serializers.py` | DRF JSON ↔ Model dönüşümü |
| `apps/products/views.py` | ViewSet — CRUD endpoint mantığı |
| `apps/products/urls.py` | Router ile URL pattern'leri |
| `apps/core/permissions.py` | Custom permission sınıfları |

## Debug Tips
| Sorun | Çözüm |
|-------|-------|
| N+1 Query | `select_related` (FK), `prefetch_related` (M2M) |
| CORS | `django-cors-headers` + `CORS_ALLOWED_ORIGINS` |
| Serializer 400 | `serializer.errors` döndür, field validation kontrol |
| Migration conflict | `python manage.py makemigrations --merge` |

## Resources: Django (djangoproject.com), DRF (django-rest-framework.org), SimpleJWT, React
