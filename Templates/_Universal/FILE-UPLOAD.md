# 📁 FILE-UPLOAD.md — Dosya Yükleme Rehberi

> Resim, video, doküman yükleme — güvenli, performanslı, best practice.

---

## ⚠️ Güvenlik Kuralları (ZORUNLU)
```
1. Dosya tipini kontrol et (sadece izin verilen: .jpg, .pdf, .mp4)
2. Dosya boyutu limiti koy (5MB resim, 50MB video)
3. Dosya adını değiştir (UUID + extension → zararsız)
4. Yükleme klasörünü public'ten ayır
5. Virus tarama (production'da)
6. MIME type kontrol (extension + magic bytes)
```

## .NET — IFormFile
```csharp
[HttpPost("upload")]
[RequestSizeLimit(10_000_000)] // 10MB
public async Task<IActionResult> Upload(IFormFile file)
{
    var allowed = new[] { ".jpg", ".jpeg", ".png", ".pdf" };
    var ext = Path.GetExtension(file.FileName).ToLower();
    if (!allowed.Contains(ext)) return BadRequest("Geçersiz dosya tipi");
    
    var fileName = $"{Guid.NewGuid()}{ext}";
    var path = Path.Combine("uploads", fileName);
    using var stream = new FileStream(path, FileMode.Create);
    await file.CopyToAsync(stream);
    return Ok(new { url = $"/uploads/{fileName}" });
}
```

## Python (FastAPI) — UploadFile
```python
from fastapi import UploadFile, File
import uuid, aiofiles

ALLOWED = {".jpg", ".jpeg", ".png", ".pdf"}
MAX_SIZE = 10 * 1024 * 1024  # 10MB

@app.post("/upload")
async def upload(file: UploadFile = File(...)):
    ext = Path(file.filename).suffix.lower()
    if ext not in ALLOWED: raise HTTPException(400, "Geçersiz dosya tipi")
    if file.size > MAX_SIZE: raise HTTPException(400, "Dosya çok büyük")
    
    filename = f"{uuid.uuid4()}{ext}"
    async with aiofiles.open(f"uploads/{filename}", "wb") as f:
        await f.write(await file.read())
    return {"url": f"/uploads/{filename}"}
```

## Node.js — Multer
```javascript
const multer = require('multer');
const storage = multer.diskStorage({
    destination: 'uploads/',
    filename: (req, file, cb) => cb(null, `${Date.now()}-${Math.random().toString(36).substr(2)}${path.extname(file.originalname)}`)
});
const upload = multer({
    storage, limits: { fileSize: 10 * 1024 * 1024 },
    fileFilter: (req, file, cb) => {
        const allowed = /jpeg|jpg|png|pdf/;
        const ext = allowed.test(path.extname(file.originalname).toLowerCase());
        const mime = allowed.test(file.mimetype);
        cb(null, ext && mime);
    }
});
app.post('/upload', upload.single('file'), (req, res) => {
    res.json({ url: `/uploads/${req.file.filename}` });
});
```

## Cloud Storage (Production'da Önerilen)
| Servis | Platform | Ne Zaman |
|--------|----------|----------|
| **Azure Blob** | .NET projeler | Enterprise |
| **AWS S3** | Genel | Büyük ölçek |
| **Firebase Storage** | Mobile (Flutter) | Basit, hızlı |
| **Cloudinary** | Resim/video | Otomatik optimize, CDN |
| **MinIO** | Self-hosted | S3 uyumlu, kendi sunucu |

## Frontend Upload UX
```javascript
// Progress bar ile upload
const formData = new FormData();
formData.append('file', selectedFile);
const response = await axios.post('/api/upload', formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
    onUploadProgress: (e) => { setProgress(Math.round((e.loaded * 100) / e.total)); }
});
```
