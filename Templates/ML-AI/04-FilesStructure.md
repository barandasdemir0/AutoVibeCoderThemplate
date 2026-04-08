# 4?? ML / AI Geliştirme - Kurumsal MLOps File Structure (Klasör Standardı)

> **ZORUNLU DİZİLİM:** Projede sadece bir `script.py` varsa bu kod çöptür. Cookiecutter Data Science mantığını temel alan klasör izolasyonu, projenin geleceğidir. Veri başka, model başka, uygulama başka dizinlerden kontrol edilir.

---

## En Kurumsal Yapı: The MLOps Enterprise Architecture

```text
ML-AI-Project/
├── data/                    # Veri kökü (.gitignore'a eklenmeli)
│   ├── raw/                 # Ham kaynak veri (read-only)
│   ├── interim/             # Ara dönüştürülmüş veriler
│   └── processed/           # Modele hazır temiz veriler
│
├── models/                  # Eğitilmiş ağırlıklar (.pth, .onnx)
│   └── v1_best_model.pth
│
├── notebooks/               # Sadece deneysel analizler
│   └── 01-eda-analysis.ipynb
│
├── src/                     # Çekirdek Python kodları
│   ├── data/
│   │   └── make_dataset.py
│   ├── features/
│   │   └── build_features.py
│   ├── models/
│   │   ├── evaluate.py
│   │   ├── networks.py
│   │   └── train.py
│   └── utils/
│       └── metrics.py
│
├── app/                     # Inference server / kullanıcı arayüzü (FastAPI)
│   ├── api.py
│   ├── schemas.py
│   └── service.py
│
├── .gitignore
├── config.yaml
├── requirements.txt
└── Dockerfile
```

---

## Kritik Mimari Kurallar

1. **Notebook katı:** Notebook dosyaları modelin ana kaynağı değildir; yalnızca veri analizi için kullanılır.
2. **Hard-coded path yasağı:** Veri yolları sabit masaüstü yolu ile yazılmaz; dinamik path yapısı kullanılır.
3. **Pydantic ile FastAPI koruması:** Dışarıdan gelen parametreler doğrulanmadan modele aktarılmaz.
