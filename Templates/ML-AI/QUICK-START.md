## SEQUENCE-ENGINE v1 (ZORUNLU)
Bu template ile çalışırken sırayı bozmak yasaktır:
1) QUICK-START.md
2) 01-Planning.md
3) 02-Architecture.md
4) 03-StepByStep.md
5) 04-FilesStructure.md
6) 05-DebugTips.md
7) 06-Resources.md

Kural:
- Her dosyadan sonra 3-5 maddelik "çıkarım özeti" yaz.
- Özeti yazmadan sonraki dosyaya geçme.
- 7 dosya tamamlanmadan kod üretimine başlama.
- Bu akışın detay standardı: Templates/_Universal/TEMPLATE-SEQUENCE-ENGINE.md

---
# ⚡ ML/AI & MODEL MLOPS - OTONOM BEYİN (QUICK-START & MASTER RULES)

> **DİKKAT YAPAY ZEKA:** Eğer bu projede ölçeklenebilir bir yazılım yerine makine öğrenmesi motoru çalıştırıyorsan, aşağıdaki GPU güvenliği, matematiksel izolasyon ve servisleşme kurallarına %100 uyman gerekir. Düzensiz notebook'lar veya API/DOCKER sunmayan çöpler üretirsen süreç iptal olur. Biz kurumsal ve servis edilebilir bir MLOps sistemi istiyoruz.

---

## 1. Yasaklar Listesi (Anti-Patterns)

1. **Spagetti yapı yasaktır:** Veriyi okuma, modeli sınıflandırma ve eğitimi tek bir `main.py` içinde toplama. Kod; `src/data/`, `src/models/` ve `src/train.py` gibi bölümlere ayrılmalıdır.
2. **Data leakage yasaktır:** Eğitim verisi ile test verisini karıştırma. Train/val/test ayrımı en baştan yapılmalıdır.
3. **Tensor'ları GPU'ya taşımayı unutmak yasaktır:** Model ve veri aynı device üzerinde çalışmalıdır.
4. **Modeli her istekte yeniden yüklemek yasaktır:** Model yalnızca `startup_event` ile bir kez RAM'e alınmalıdır.

---

## 2. Zorunlu Mimari Yapı

```text
ML-AI-Project/
├── data/                    # Veri kökü (.gitignore'a eklenmeli)
│   ├── raw/                 # Ham veri
│   ├── interim/             # Ara dönüştürülmüş veri
│   └── processed/           # Modele hazır veriler
│
├── models/                  # Eğitilmiş ağırlıklar (.pth, .onnx)
│
├── notebooks/               # Deneysel analizler
│
├── src/                     # Çekirdek Python kodları
│   ├── data/                # Veri işleme
│   ├── features/            # Feature engineering
│   ├── models/              # Model ve eğitim
│   └── utils/               # Seed, metrics, helpers
│
├── app/                     # Inference server / API katmanı
│   ├── api.py               # Uvicorn çalıştırıcısı
│   ├── schemas.py           # Pydantic payload kontrolü
│   └── service.py           # Model service
│
├── .gitignore
├── config.yaml
├── requirements.txt
└── Dockerfile
```

---

## 3. Başlangıç Kuralları

1. Notebook yerine kurumsal Python proje yapısını kur.
2. Eğitim için `src/train.py`, veri için `src/data/`, model için `src/models/` kullan.
3. API katmanını `app/` içinde tut ve modeli startup'ta tek sefer yükle.
4. Teslimden önce test, logging ve Docker adımlarını tamamla.

**MLOps; notebook karmaşası değil, tekrar üretilebilir ve servis edilebilir sistemdir.**