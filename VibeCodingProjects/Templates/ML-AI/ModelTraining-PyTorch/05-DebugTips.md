# 🐛 Debug Tips — PyTorch

## ⚠️ Sık Hatalar

### CUDA out of memory
```python
torch.cuda.empty_cache()           # GPU belleği temizle
# Çözümler:
# 1. batch_size küçült
# 2. gradient accumulation kullan
# 3. mixed precision (torch.cuda.amp)
# 4. model.eval() + torch.no_grad() inference'da
```

### Loss NaN / Inf
→ Learning rate çok yüksek → `1e-4` veya `1e-5` dene
→ Gradient clipping: `torch.nn.utils.clip_grad_norm_(params, max_norm=1.0)`
→ Veri normalizasyonu eksik → [0,1] veya standardize et
→ `torch.autograd.detect_anomaly()` ile debug et

### Shape mismatch
```python
# Her katmandan sonra shape kontrol:
print(f"After conv1: {x.shape}")  # [batch, channels, H, W]
# Flatten: x = x.view(x.size(0), -1)
```

### Model öğrenmiyor (loss düşmüyor)
→ Learning rate çok düşük/yüksek
→ Veri doğru label'lanmış mı? Birkaç sample elle kontrol et
→ Model karmaşıklığı yeterli mi?
→ Optimizer: Adam genellikle iyi başlangıç

### Overfitting (train iyi, val kötü)
→ Data augmentation ekle
→ Dropout ekle
→ Regularization: weight decay
→ EarlyStopping callback
→ Daha fazla veri

### Underfitting (train de kötü)
→ Daha büyük model
→ Daha fazla epoch
→ Learning rate artır
→ Augmentation azalt

## 🔍 Debug Araçları

| Araç | Kullanım |
|------|----------|
| `print(tensor.shape)` | Boyut kontrolü |
| `torch.autograd.detect_anomaly()` | NaN/Inf gradient bul |
| TensorBoard | Loss curve, histogram, images |
| `torchsummary` | Model parametre özeti |
| `torch.profiler` | Performance bottleneck |
| W&B | Experiment tracking |
| `breakpoint()` / `pdb` | Python debugger |

## 📓 Experiment Günlüğü

| Tarih | Model | LR | Epochs | Batch | Train Loss | Val Loss | Val Acc | Notlar |
|-------|-------|-----|--------|-------|------------|----------|---------|--------|
| [—]   | [—]   | [—] | [—]    | [—]   | [—]        | [—]      | [—]     | [—]    |
