# 🏗️ Architecture — PyTorch Model Eğitimi

## 🧱 Proje Yapısı
```
project/
├── data/
│   ├── raw/           → Ham veri
│   ├── processed/     → İşlenmiş veri
│   └── splits/        → train/val/test
├── src/
│   ├── data/
│   │   ├── dataset.py     → Custom Dataset
│   │   ├── dataloader.py  → DataLoader config
│   │   └── transforms.py  → Augmentation
│   ├── models/
│   │   ├── base_model.py  → nn.Module tanımı
│   │   └── components.py  → Custom layers/blocks
│   ├── training/
│   │   ├── trainer.py     → Training loop
│   │   ├── losses.py      → Custom loss fonksiyonları
│   │   └── metrics.py     → Evaluation metrics
│   ├── inference/
│   │   └── predict.py     → Model ile tahmin
│   └── utils/
│       ├── config.py      → Hyperparameters
│       └── helpers.py     → Utility fonksiyonlar
├── notebooks/          → Jupyter EDA & experiments
├── configs/            → YAML config dosyaları
├── checkpoints/        → Model ağırlıkları (.pt)
├── logs/               → TensorBoard / W&B logs
├── requirements.txt
└── train.py            → Ana eğitim scripti
```

## 📐 Training Pipeline
```
Data Loading → Preprocessing → Augmentation
    ↓
Model Forward Pass → Loss Calculation → Backpropagation
    ↓
Validation → Metrics → Checkpoint Saving
    ↓
Best Model → Export (ONNX/TorchScript) → Deploy
```

## Temel Pattern'ler
```python
# Dataset
class CustomDataset(Dataset):
    def __init__(self, data_path, transform=None):
        self.data = pd.read_csv(data_path)
        self.transform = transform
    def __len__(self): return len(self.data)
    def __getitem__(self, idx):
        sample = self.data.iloc[idx]
        if self.transform: sample = self.transform(sample)
        return sample

# Model
class MyModel(nn.Module):
    def __init__(self):
        super().__init__()
        self.layers = nn.Sequential(
            nn.Linear(784, 256), nn.ReLU(), nn.Dropout(0.3),
            nn.Linear(256, 10))
    def forward(self, x): return self.layers(x)

# Training Loop
for epoch in range(epochs):
    model.train()
    for batch in train_loader:
        optimizer.zero_grad()
        output = model(batch['input'])
        loss = criterion(output, batch['target'])
        loss.backward()
        optimizer.step()
```
