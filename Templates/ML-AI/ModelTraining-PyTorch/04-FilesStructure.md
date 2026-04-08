# 📂 Files Structure — PyTorch Model Eğitimi

```
project/
├── data/
│   ├── raw/                → Orijinal veri (CSV, images, vb.)
│   ├── processed/          → Temizlenmiş, normalize edilmiş veri
│   └── splits/             → train/ val/ test/ ayrımı
│
├── src/
│   ├── data/
│   │   ├── dataset.py      → torch.utils.data.Dataset implementasyonu
│   │   │                     Her sample'ı __getitem__ ile döndürür
│   │   ├── dataloader.py   → DataLoader factory (batch, shuffle, workers)
│   │   └── transforms.py   → Augmentation pipeline (Albumentations/torchvision)
│   │
│   ├── models/
│   │   ├── base_model.py   → Ana model sınıfı (nn.Module)
│   │   │                     forward() methodu burada tanımlanır
│   │   ├── components.py   → Tekrar kullanılan bloklar (ResBlock, Attention vb.)
│   │   └── losses.py       → Custom loss fonksiyonları (FocalLoss, DiceLoss vb.)
│   │
│   ├── training/
│   │   ├── trainer.py      → Training loop: epoch, batch, backward, step
│   │   │                     Validation, checkpoint kaydetme, logging
│   │   ├── callbacks.py    → EarlyStopping, LRScheduler, ModelCheckpoint
│   │   └── metrics.py      → Accuracy, F1, Precision, Recall hesaplama
│   │
│   ├── inference/
│   │   ├── predict.py      → Tek sample veya batch prediction
│   │   └── export.py       → ONNX / TorchScript export
│   │
│   └── utils/
│       ├── config.py       → Hyperparameter dataclass (lr, epochs, batch_size)
│       ├── seed.py         → Reproducibility (torch.manual_seed)
│       ├── visualization.py → Matplotlib grafikleri (loss curve, confusion matrix)
│       └── helpers.py      → Genel yardımcı fonksiyonlar
│
├── configs/
│   └── default.yaml        → Hyperparameter YAML dosyası
│
├── notebooks/
│   ├── 01_eda.ipynb        → Exploratory Data Analysis
│   ├── 02_training.ipynb   → İnteraktif eğitim deneyleri
│   └── 03_evaluation.ipynb → Sonuç analizi
│
├── checkpoints/            → Kayıtlı model ağırlıkları (.pt, .pth)
├── logs/                   → TensorBoard / W&B logları
├── outputs/                → Prediction sonuçları
│
├── train.py                → Ana eğitim entry point
├── evaluate.py             → Model değerlendirme scripti
├── predict.py              → Inference entry point
├── requirements.txt
├── README.md               → Proje açıklaması, kurulum, kullanım
└── .gitignore              → checkpoints/, data/raw/, logs/, __pycache__
```

## 📝 Her Dosya Ne İş Yapar?

| Dosya | Sorumluluk | Best Practice |
|-------|-----------|---------------|
| `dataset.py` | Veriyi yükle, dönüştür, döndür | `__getitem__` lazy loading, transform parametrik |
| `dataloader.py` | Batch, shuffle, paralel yükleme | `num_workers=4`, `pin_memory=True` (GPU) |
| `transforms.py` | Data augmentation pipeline | Train'de augment, val/test'te sadece normalize |
| `base_model.py` | Neural network mimarisi | Forward pass temiz, `__init__`'te katmanlar |
| `losses.py` | Kayıp fonksiyonları | Dengesiz veri → FocalLoss, segmentasyon → DiceLoss |
| `trainer.py` | Eğitim döngüsü | Epoch/step logging, gradient clipping, mixed precision |
| `metrics.py` | Değerlendirme metrikleri | Sklearn veya torchmetrics kullan |
| `config.py` | Tüm hyperparameter'lar | Dataclass + YAML override |
| `predict.py` | Tahmin pipeline'ı | Batch inference, GPU/CPU otomatik |
| `export.py` | Model dışa aktarma | ONNX (production), TorchScript (mobile) |

## 📝 Best Practices

1. **Reproducibility**: Seed'i her yerde set et (`torch`, `numpy`, `random`, `CUDA`)
2. **Veri ayrımı**: 80/10/10 veya 70/15/15 oranı, **stratified split** kullan
3. **Augmentation**: Sadece train set'e uygula, val/test → sadece resize+normalize
4. **Checkpoint**: Best validation loss/metric'e göre kaydet
5. **Logging**: Her epoch'ta train_loss, val_loss, metrics logla
6. **Mixed Precision**: `torch.cuda.amp.autocast()` ile 2x hız
7. **gradient clipping**: `torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)`
8. **Git**: `data/raw/`, `checkpoints/`, `logs/` → `.gitignore`'a ekle
