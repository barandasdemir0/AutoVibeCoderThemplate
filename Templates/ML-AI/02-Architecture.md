# 2?? ML / AI Geliştirme - Model Mimarisi ve GPU/Lifecycle Yönetimi

> **MİMARİ KURALI:** Otonom yapay zeka bir script içinde data frame okuyor, görüntü boyutlandırıyor ve ardından modeli derleyip eğitiyorsa bu spagettidir. Eğitim, çıkarım ve doğrulama klasörden klasöre kesin olarak ayrılmalıdır.

---

## 1. Otonom Model Mimarisi (Object Oriented AI)

PyTorch kurumsal dünyanın güçlü tercihlerinden biridir. Otonom AI, modelleri sınıf olarak oluştururken fonksiyonlara hard-coded değerler gömmemelidir.

```python
import torch.nn as nn

# OTONOM KUSURSUZ MİMARİ
class VisionModel(nn.Module):
    def __init__(self, num_classes=10, dropout_rate=0.5):  # Hiper-parametreler dışarı açık
        super(VisionModel, self).__init__()
        self.conv1 = nn.Conv2d(3, 32, kernel_size=3)
        self.dropout = nn.Dropout(dropout_rate)
        self.fc = nn.Linear(32 * 26 * 26, num_classes)

    def forward(self, x):
        x = self.conv1(x)
        x = self.dropout(x)
        return self.fc(x.view(x.size(0), -1))
```

Bu yapı sayesinde başka bir projede yalnızca `num_classes=5` diyerek aynı modeli yeniden kullanabilirsin.

---

## 2. Veri Taşıyıcıları ve Batch Pumping

Yapay zeka modellerine veri toplu halde yüklenemez. 100 GB veriyi RAM'e yüklemeye çalışan amatör kod, OOM hatasıyla sistemi düşürür.

* **Otonom Zeka Kalkanı (The DataLoader):** PyTorch DataLoader ile veri batch'ler halinde RAM'e pompalanır. `num_workers=4` kullanımı, veri besleme darboğazını azaltır.

---

## 3. Yasaklı İşlemler (Machine Learning Anti-Patterns)

Otonom model aşağıdaki hatalardan kaçınır:

1. **Tensor'ları GPU'ya taşımayı unutmak:**
   ```python
   # FELAKET - Veri RAM'de kaldı, model GPU'da
   output = model(images)
   ```
   **Doğrusu:** `device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')` ile model ve veri aynı cihaza taşınır.

2. **Test verisi ile eğitim yapmak (data leakage):**
   Eğitim sırasında model test verisini görmemelidir. Veriyi baştan `Train (%80), Val (%10), Test (%10)` olarak ayır.

3. **Model ağırlıklarını yanlış export etmek:**
   Modeli tüm class ile birlikte kaydetmek yerine yalnızca `state_dict` kaydedilir:
   `torch.save(model.state_dict(), 'weights.pth')`.
