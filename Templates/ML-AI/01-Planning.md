# 1?? ML / AI Geliştirme - Kurumsal ML-Ops ve Otonom Planlama Stratejisi

> **YAPAY ZEKA İÇİN KESİN KURAL:** Bir Jupyter Notebook (IPYNB) dosyasına 500 satır Keras veya PyTorch kodu yazıp, sonunda `.h5` veya `.pt` ağırlık dosyasını (modeli) masaüstüne fırlatmak yapay zeka geliştirmesi değildir. Bu amatör bir denemedir. Otonom yapay zeka, kurumsal AI projelerinde (MLOps standartlarıyla); tekrar üretilebilirlik, model sunumu ve versiyonlama zorunluluklarına göre projeyi inşa etmelidir.

---

## 1. Jupyter Notebook'tan Çıkış: The Pythonic MLOps Mimarisi

Data Scientist'ler kodlarını deney amaçlı notebook'larda yazar. Ancak üretim aşamasına geçerken bu kodlar spaghetti hale gelir.

### A. Modülerleştirme (Otonom Çıkarım)
Otonom yapı, eğitimi tamamlanmış veya eğitilecek bir modeli doğrudan mimari katmanlara izole eder:
* **data_loader.py**: Yalnızca veriyi tutar, temizler, null değerleri boşaltır ve dışarı tensor veya numpy atar.
* **model_arch.py**: Temel neural network burada yaşar. Sadece sınıf (örnek: `CNN(nn.Module)`) bulunur.
* **train.py**: Model ile veriyi birleştirir. Epoch ayarlarını ekler ve sadece eğitim için çalışır.

Bu üç sorumluluk tek bir dosyada birleştirilmez. Sürdürülebilirlik esastır.

---

## 2. Reproducibility ve Seed Kilitleri

Bugün %95 başarı veren bir model, rastgele başlangıçlar nedeniyle yarın %80'e düşebilir. Otonom bir sistem şansa dayanmaz.

* **Otonom Zeka Müdahalesi:** PyTorch veya TensorFlow kullanırken sistem, seed kilidini zorunlu olarak uygular.

```python
# OTONOM KORUMA KALKANI (SEEDING) - Bu ayar olmayan ML projesi çöptür!
import torch
import numpy as np
import random

def set_seed(seed=42):
    torch.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)
    np.random.seed(seed)
    random.seed(seed)
    torch.backends.cudnn.deterministic = True  # CUDNN (GPU) rastgeleliğini azaltır

set_seed(42)
```

Bu ayarı vermezsen sonuçlar asla deterministik olmaz.

---

## 3. Modelin Sunucuya Açılması (Machine Learning App Deployment)

Ağırlıkları elde ettin. Peki müşteriler buna nereden erişecek?
Yapay zeka modeli eğitimden sonra uygulamanın içine yığılmaz.

### Büyüleyici Otonomi Kuralları (Model Serving API)
* Model `model.pt` veya `model.onnx` olarak `weights/` klasörüne atılır.
* FastAPI kurulur. Python sunucusu gerekiyorsa Uvicorn + FastAPI ile dışarıdan gelen resmi veya metni alır, modeli RAM'e sunucu açılırken yalnızca bir kez `startup_event` ile yükler ve isteklere tahmin döner.
* Her istekte modeli yeniden yükleme amatörlüğüne düşülmez; bu RAM'i şişirir ve sunucuyu kapatır. Model tek seferde RAM'e alınır (singleton servis).

Mimari detaylar için 02 katmanına geç.
