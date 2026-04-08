# 🏗️ Architecture — HTML + CSS + Bootstrap

## 🧱 Yapı
```
project/
├── index.html
├── pages/ (about.html, contact.html, dashboard.html)
├── css/
│   ├── custom.css     → Bootstrap override'ları
│   └── style.css      → Ek özel stiller
├── js/
│   └── main.js        → Vanilla JS
├── assets/ (images/, icons/)
└── README.md
```

## 📐 Bootstrap Grid
```html
<div class="container">
    <div class="row">
        <div class="col-12 col-md-6 col-lg-4">Kolon 1</div>
        <div class="col-12 col-md-6 col-lg-4">Kolon 2</div>
        <div class="col-12 col-md-12 col-lg-4">Kolon 3</div>
    </div>
</div>
```

## Breakpoints
| Breakpoint | Prefix | Min-width |
|------------|--------|-----------|
| X-Small | — | 0 |
| Small | sm | 576px |
| Medium | md | 768px |
| Large | lg | 992px |
| X-Large | xl | 1200px |
| XX-Large | xxl | 1400px |

## 🔗 Bootstrap + Custom CSS
```html
<!-- 1. Bootstrap CSS (CDN) -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- 2. Custom CSS (sonra yükle = override) -->
<link rel="stylesheet" href="css/custom.css">
<!-- 3. Bootstrap JS (body sonunda) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
```

## 🎨 Sık Kullanılan Components
| Component | Kullanım |
|-----------|----------|
| Navbar | `<nav class="navbar navbar-expand-lg">` |
| Card | `<div class="card">` |
| Modal | `<div class="modal">` + `data-bs-toggle` |
| Table | `<table class="table table-striped">` |
| Form | `<form>` + `form-control`, `form-label` |
| Button | `btn btn-primary`, `btn-outline-*` |
| Alert | `alert alert-success` |
| Badge | `badge bg-primary` |
| Pagination | `pagination` |
