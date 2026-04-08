# 4️⃣ ML / AI Geliştirme - Kurumsal MLOps File Structure (Klasör Standartı)

> **ZORUNLU DİZİLİM:** Projede sadece bir `script.py` varsa bu Kod Çöptür. Endüstri Standardı olan "Cookiecutter Data Science" mantığını temel alan Otonom yapay zeka Klasör İzolasyonu Projenizin Geleceğidir. Data Bambaşka, Model Bambaşka, UYGULAMA (APP) Bambaşka Dizinlerden Kontrol Edilir!!.

---

## 📂 En Kurumsal Yapı: The MLOps Enterprise Architecture

Bir Cihaza (Server) Hem Eğitim Yaptırıyor Hem De Tahmin Sağlayan (Full-Stack Data) yapısı:

```text
ML-AI-Project/
├── data/                    # VERİ KÖKÜ (Bu Klasör .gitignore a EKLENİLMELİDİR!)
│   ├── raw/                 # Saf Dışardan Gelen Csv/Gorsel (Buna Kesinlikle Degiştirilemez-ReadOnly)
│   ├── interim/             # Arasıra dönüştürülmüş Ara veriler
│   └── processed/           # Modele Doğrudan Beslenecek Temiz Ve Hazır (Tensorlanmış) Veriler
│
├── models/                  # EĞİTİLMİŞ AĞIRLIKLARIN (.pth, .onnx) TIKILDIĞI YER
│   └── v1_best_model.pth    # (Model Boyutu 100Mb vs ise BurasıDa Gite atılamaz DVC ile saklanır!)
│
├── notebooks/               # 🧪 (Sadece Deneyler) VERİ ANALİZİ ÇÖPLÜĞÜ MÜKEMMELLİĞİ!
│   └── 01-eda-analysis.ipynb# Data Scientistin Keşifleri Otonom AItestleri vs
│
├── src/                     # 🚀 ÇEKİRDEK İŞ/PYTHON KODLARI
│   ├── data/                # VERİ DÖNÜŞÜM MANİPÜLASYONU
│   │   └── make_dataset.py  # Data Okuyucu Pompalar.
│   │
│   ├── features/            # FEATURE ENGINEERING
│   │   └── build_features.py# NLP ise Tokenize Eden, Görselse Kesen fonksiyonlar.
│   │
│   ├── models/              # THE BEYIN CLASSLARI VE EĞİTİM MOTORU
│   │   ├── evaluate.py      # Final Validation Accuracy Basar (Confusion Matrix Raporcusu)
│   │   ├── networks.py      # Class CNN(nn.Module): Buradadır. Sadece Model Mimarisi.
│   │   └── train.py         # Main Çalıştırıcı (Model i Ve Datayı Birleştirip Vites Atar).
│   │
│   └── utils/               # Uygulama Matematik Hilesi, Seed Kilitleyciler.
│       └── metrics.py 
│
├── app/                     # 🚀 İNFERENCE THE SERVER / KULLANICI ARAYÜZÜ (FastAPI)
│   ├── api.py               # Uvicorn Çalıştırıcısı Ve Post(/Predict) Endpointsler
│   ├── schemas.py           # Zod Yok Burada Pydantic Var! (FastAPI ile Mükemmel Payload Kontrolü)
│   └── service.py           # Modelin (singleton) Olarak RAM'e Oturtuldugu Sınıf.
│
├── .gitignore               # The Data Ve Modelleri Çöpe (Gite yollanmayacak) Tutar.
├── config.yaml              # HİPER-PARAMETRELER: Learning_rate=0.01, Batch=64.
├── requirements.txt         # KURULUM THE KİTAPI (pip install -r)
└── Dockerfile               # Production Deploy Kalıbı.
```

---

## ⚠️ Kritik Mimari Kurallar (Files Rulebook)

1. **Jupyter Notebook The Legacy Katı:** Notebook (`.ipynb`) Dosyalarının İçine Otonom Yapay zeka Class Mimarisi Veya Eğitimi Komple Yıkamaz. Notebooklar **SADECE** Veriyi Anlamak (Graphs, Pandas analizi) İcin Kullanılabilir!. Sürdürülebilir Bir MLOps Projesinde Kaynak Kod YALNIZCA (Python `.py`) Cıktılarıyla Kurulabilir!!. Notebookları Main Kod olarak Verme Bitti!
2. **Hard Coded Path Yasakları:** Otonom Zeka Bir Veriyi Okurken `pandas.read_csv('C:/Users/Ali/Desktop/data.csv')` YAZAMAZ (Evrişimcinin Korkunç Hatası). Proje Rootundan Ve OS Paths libraryleri Kulanılarak (The Relative veya Absolute Dynamic Path İle): `os.path.join(ROOT_DIR, "data", "raw", "data.csv")` Formatıyla Otonom Kurallar İşlenir!! Proje Başka Bilgisayrada Crash olmaz!
3. **Pydantic İle FastAPI Koruması:** FastAPI Serverının İçerisinde Otonomi; Dışarıdan Gelen Parametreyi Doğrulamadan Modele (Süremez). Eğer Görüntü (Resim) Bekliyor İse, The Body içerisinde Mutlaka Multipart File Veya Pydantic Mimarisi Ile Kurumsal Olarak Kontrol Ceker!. Modeli Arındırır!.
