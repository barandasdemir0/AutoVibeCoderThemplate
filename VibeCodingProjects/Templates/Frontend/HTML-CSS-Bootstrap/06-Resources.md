# 📚 Resources — HTML + CSS + Bootstrap

## 🔗 Dokümantasyon
| Kaynak | Link |
|--------|------|
| Bootstrap 5 | https://getbootstrap.com/docs |
| Bootstrap Icons | https://icons.getbootstrap.com |
| Bootstrap Examples | https://getbootstrap.com/docs/5.3/examples |
| MDN Web Docs | https://developer.mozilla.org |

## 📌 Snippets

### Bootstrap Boilerplate
```html
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>[Sayfa]</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/custom.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="#">Logo</a>
            <button class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#nav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="nav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link active" href="#">Ana Sayfa</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Hakkında</a></li>
                </ul>
            </div>
        </div>
    </nav>
    <main class="container my-5">...</main>
    <footer class="bg-dark text-white text-center py-3">© 2026</footer>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
```

### Card Grid
```html
<div class="row g-4">
    <div class="col-12 col-md-6 col-lg-4">
        <div class="card h-100">
            <img src="..." class="card-img-top" alt="...">
            <div class="card-body">
                <h5 class="card-title">Başlık</h5>
                <p class="card-text">Açıklama</p>
                <a href="#" class="btn btn-primary">Detaylar</a>
            </div>
        </div>
    </div>
</div>
```

### Utility Classes Cheat Sheet
```
Spacing: p-3, m-2, mt-4, mb-3, mx-auto, py-5
Text: text-center, text-muted, fw-bold, fs-4
Display: d-flex, d-none, d-md-block
Flex: justify-content-center, align-items-center, gap-3
Colors: text-primary, bg-dark, text-white
Border: border, rounded, shadow
```
