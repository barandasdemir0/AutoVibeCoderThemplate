# 3?? ML / AI Geliştirme - Adım Adım İnşa Süreci (Step-By-Step)

> **YAPAY ZEKA ÇALIŞMA ALGORİTMASI:** Python ile model kurmak bir mimaridir. Gereksinimler olmadan bu kod cihazda çalıştırılamaz. Modeller, inference sunucusuna kadar hatasız bağlanmalıdır.

---

## Aşama 1: Ortam Kurulumu ve Bağımlılıklar
1. Root dizininde `requirements.txt` veya `environment.yml` dosyası oluşturulur. İçinde FastAPI, PyTorch/TensorFlow, scikit-learn, numpy, pandas ve sürümler bulunur.
2. Veri seti büyükse Git'e yüklenmez. `.gitignore` ile `data/` ve `models/*.pth` klasörleri izole edilir. Gerekirse DVC ya da indirme scripti kullanılır.

---

## Aşama 2: Veri Ön İşleme (The Pre-Processing)
1. `src/data/make_dataset.py` oluşturulur. Görüntü ise resize ve normalize edilir; metin ise tokenize edilir ve padding uygulanır.
2. Veriler klasörlere ayrılır: `data/processed/train` gibi.

---

## Aşama 3: Model İnşası ve HyperParametre Konfigleri
1. Çekirdek model `src/models/network.py` içinde tanımlanır.
2. Epoch ve learning rate gibi ayarlar hardcode edilmez; kökte `config.yaml` içinde saklanır ve Python ile okunur.

---

## Aşama 4: Eğitim (Train) Döngüsü
1. `src/train.py` ayağa kaldırılır. Optimizasyon (Adam/AdamW) ve loss fonksiyonu kurulur.
2. Model GPU'ya `.to(device)` ile taşınır.
3. Her epoch sonunda en iyi model `torch.save()` ile kaydedilir.

---

## Aşama 5: Production'a Çıkarma - FastAPI ile
Otonomi uçtan uca çalışır; model eğitilince iş bitmez.
1. `app/main.py` oluşturulur.
2. Sunucu açılırken `startup_event` ile kayıtlı `.pth` model RAM'e bir kez yüklenir.
3. `POST /predict` endpoint'i kurulur ve kullanıcıdan gelen görüntü sınıflandırılır.

---

## Aşama 6: Polishing ve MLOps
* **Docker kılıfı:** Uygulamaya uygun bir Dockerfile hazırlanır. FastAPI konteyner içinde açılır ve port dışarı verilir.

Adımlar tamamlanınca 04-FilesStructure yönergelerine geçilir.
