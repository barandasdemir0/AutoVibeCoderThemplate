# 🏗️ Architecture — Django + React

## Monorepo Yapısı
```
project/
├── backend/
│   ├── config/              → settings.py, urls.py, wsgi.py
│   ├── apps/
│   │   ├── accounts/        → User model, auth views, serializers
│   │   ├── products/        → Product model, views, serializers
│   │   └── core/            → Ortak utils, permissions, mixins
│   ├── manage.py
│   └── requirements.txt
├── frontend/
│   ├── src/ (components/, features/, pages/, services/, hooks/, store/)
│   ├── package.json
│   └── vite.config.js
├── docker-compose.yml
└── README.md
```

## Django ORM Best Practices
```python
# Model — Fat Model, Thin View
class Product(models.Model):
    name = models.CharField(max_length=200)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    category = models.ForeignKey(Category, on_delete=models.CASCADE, related_name='products')
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self): return self.name
    
    @property
    def is_expensive(self): return self.price > 1000

# QuerySet optimizasyonu
Product.objects.select_related('category').prefetch_related('tags')  # N+1 önle
Product.objects.filter(price__gt=100).only('name', 'price')  # Sadece gerekli alanlar
```

## DRF Serializer + ViewSet
```python
class ProductSerializer(serializers.ModelSerializer):
    category_name = serializers.CharField(source='category.name', read_only=True)
    class Meta:
        model = Product
        fields = ['id', 'name', 'price', 'category', 'category_name']

class ProductViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.select_related('category').all()
    serializer_class = ProductSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    filterset_fields = ['category', 'price']
    search_fields = ['name']
    ordering_fields = ['price', 'created_at']
```

## JWT Auth (SimpleJWT)
```python
# settings.py
REST_FRAMEWORK = {'DEFAULT_AUTHENTICATION_CLASSES': ['rest_framework_simplejwt.authentication.JWTAuthentication']}
# urls.py
path('api/token/', TokenObtainPairView.as_view()),
path('api/token/refresh/', TokenRefreshView.as_view()),
```

# 📝 Steps | 🐛 Debug | 📚 Resources
## Steps: Django `startproject` → apps → models → migrate → serializers → viewsets → React SPA → Axios
## Debug: N+1 → `select_related`, CORS → `django-cors-headers`, 400 → serializer.errors
## Resources: Django (djangoproject.com), DRF (django-rest-framework.org), React (react.dev)
