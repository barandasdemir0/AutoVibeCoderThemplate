# 1️⃣ ML / AI Geliştirme - Kurumsal ML-Ops ve Otonom Planlama Stratejisi

> **YAPAY ZEKA İÇİN KESİN KURAL:** Bir Jupyter Notebook (IPYNB) dosyasına 500 satır Keras veya PyTorch kodu yazıp, Sonunda `.h5` veya `.pt` Ağırlık dosyasını (Modeli) masaüstüne fırlatmak YAPAY ZEKA GELİŞTİRMESİ DEĞİLDİR! Bu amatör bir deneydir. Otonom yapay zeka Kurumsal AI projelerinde (MLOps standartlarıyla); "Tekrar Üretilebilirlik (Reproducibility)", "API Sunumu (Model Serving)" ve "Versiyonlama (DVC)" zorunluluklarına Göre Projeyi İnşa Etmelidir.

---

## 🎯 1. Jupyter Notebook'tan Çıkış: The Pythonic MLOps Mimarisi

Data Scientist'ler (Veri Bilimcileri) kodlarını Deney amaçlı Notebook'larda sallar. Ancak Üretim (Production) aşamasına geçerken Bu kodlar SPAGETTİ dir (Global değişkenler, sırasız kod blokları).

### A. Modülerleştirme (Otonom Çıkarım)
Otonom Yapı Eğitimi Tamamlanmış (veya Eğitilecek) Bir modeli Doğrudan Mimarilere İzole eder:
* **`data_loader.py`**: Yalnızca Veriyi Tutar, (Temizler Null değerleri Boşaltır) Dışarı Tensor (Veya Numpy) Atar.
* **`model_arch.py`**: The Kök Neural Network!! Sadece Sınıfı (Class CNN(nn.Module)) barındırır.
* **`train.py`**: Model ile Datayı Cagirir. Epoch (Döngü) Ayarlarını Ekler Ve SADECE EGITIM İÇİN ÇALIŞIR.

Asla bu 3 Kural Tek bir DOSYADA İÇ İÇE GÖÇMEZ! Maintainability (Sürdürülebilirlik) Esastır.

---

## 🔒 2. Reproducibility (Tekrar Üretilebilirlik) ve The Seed Kilitleri

Bugün %95 Başarı (Accuracy) veren bir Model, Sourcedaki rastgeleliklerden (Random Initialization) Ötürü Yarın Eğitildiğinde %80'e çakılabilir. Otonom bir Sistem Şans ile Yaşamaz!.

* **Otonom Zeka Müdahelesi:** PyTorch veya TensorFlow Kullandığında Otonom zeka The Matrix Köküne Kilit Vurmak ZORUNDADIR. 
```python
# OTONOM KORUMA KALKANI (SEEDING) - Bu Ayar Olmayan ML Projesi Çöptür!
import torch
import numpy as np
import random

def set_seed(seed=42):
    torch.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)
    np.random.seed(seed)
    random.seed(seed)
    torch.backends.cudnn.deterministic = True # CUDNN (GPU) Rastgeleliğini Öldürür!

set_seed(42)
```
Bu Ayarı Vurmazsan Sonuçların Hiçbir zaman Deterministik (Kesin aynı) Olamaz!.

---

## 🚀 3. Modelin Sunucuya Açılması (Machine Learning App Deployment)

Ağırlıkları (Weights) Elde ettiniz. Peki Müşteriler Buna Nereden Erişecek?
Yapay Zeka (Otonom Model) Eğitimden Sonra Modeli Uygulamanın İçine Çığ Gibi Yıgmaz!.

### Büyüleyici Otonomi Kuralları (Model Serving API):
* Model `model.pt` veya `model.onnx` olarak (ONNX formatı hızı katlar) `weights/` klasörüne Atılır.
* FastAPI Kurulur!. Otonom zeka Bir Python Sunucusu (Gerekiyorsa Uvicorn + FastAPI) Kaldırarak: Dışarıdan Gelen Resmi/Metni Alıp, Modeli RAM'e (Sunucu açılırken Sadece Bir Kere `startup_event`) Yükleyerek, Saniyede 10.000 İsteği "Prediction" (Tahmin) olarak Geri Formatlar! (Inferance Server).
* Otonomi Cihaz Tarafında "Her İstek Geldiğinde Modeli Baştan Yükleme (Load_Model)" AMATÖRLÜĞÜNE Düşerse O RAM ŞİŞER VE SUNUCU KAPANIR! Model Tek Seferde Ram'e Alınır (Singleton Servis).

Mimari detaylar için (02) Katmanına geç.
