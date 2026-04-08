# 3️⃣ ML / AI Geliştirme - Adım Adım İnşaa Süreci (Step-By-Step)

> **YAPAY ZEKA ÇALIŞMA ALGORİTMASI:** Python ile Model kurmak bir Mimaridir. Requirementlar (Kütüphane Listesi) Olmadan Bu Kod Cihazda Çalıştırılamaz. Modeller The Inference (Tahmin) Sunucusuna kadar Hatasız Bağlanmalıdır!.

---

## 🛠️ Aşama 1: Ortam (Environment) Kurulumu Ve Bağımlılıklar
1. Otonom yapay zeka Root (Kök) dizininde `requirements.txt` Veya `environment.yml` dosyasını çizer! (FastAPI, PyTorch/TensorFlow, scikit-learn, numpy, pandas... ve Versiyonları ile `torch==2.1`).
2. Sadece Kod Değil! Veri seti (Dataset) Çok büyüktür Github'a Mılyonlarca Resim Atılmaz (Hata Verir). Otonomi Sistemi `.gitignore` Kurarak Veri Seti (Örn: `data/`) Ve Model Ağırlıkları (Örn: `models/*.pth`) Klasörlerini Kesinlikle GIT Tarafından İzole Eder!! (Veriler Sunucularda Değil, DVC'de Saklanır Veya İndirme Scripti `download.sh` Yaratılır.).

---

## 🗄️ Aşama 2: Veri Ön İşleme (The Pre-Processing)
1. `src/data/make_dataset.py` yaratılır. Resimse (Resize Yapılır, Normalize edilir 0-255 Arası Degerler 0-1 e çekilir) YAZI İse (Tokenize Edilir Padding vurulur).
2. Veriler Klasörlere Cıkarılır: `data/processed/train` vs.

---

## 🧬 Aşama 3: Model İnşası ve HyperParametre Konfigleri
1. The Core `src/models/network.py` Çizdirilir (Mükemmel Sınıf yapıları, Parametrik Otonom Tarafından Kurulur).
2. "Kaç kere Eğitiö (Epoch) dönsün? Learning Rate Kac?" Gibi Ayarlar HardCode Degıldır. Ana Dizine `config.yaml` Yerleştirilir Otonom Geliştirici Tarafından Ve Buradan Python İle Okunur!! Mükemmeliyet!.

---

## 🌐 Aşama 4: Eğitim (Train) Çarkının Döndürülmesi
1. `src/train.py` Ayaklandırılır! Otonom Zeka The Optimizasyon (Adam/AdamW) veKayıp fonskiypnunu (Loss - CrossEntropy) Ayarlar.
2. Modeline GPU Vitesini Asar `.to(device)`.
3. Her Epoch un Sonunda (Loss Düştüğünde) Modelin The Best Halini Kaydetmesi Sağlanır `torch.save()`.

---

## 🔒 Aşama 5: Model The Production (Üretime Çıkartılması) - FastAPI İle
Otonomi Uçtan uca Bir Programdır. Model Çizilince Bitmez!.
1. `app/main.py` yaratılır (FastAPI Servisi). 
2. Server Başlarken `startup_event` İçerisinde (Sedece Bir Defa) O Kaydettiğimiz Zirve Model `.pth` Diskt'en Okunarak RAM'e Oturttulur!!. The Model `global` Değişken Haline Gelir!!. (Vitas Kutusu).
3. `POST /predict` Methodu (Endpoints) Çizilir. Ve Kullanıcıdan Resmi (Image) Alıp `model(image)` Edip Classification Olarak Otonom Dönüş Sağlanır!! The Yapay Zeka Rest API Olmuştur.

---

## ⚙️ Aşama 6: Polishing (Üst düzey Dockerization Ve MLOps)
* **Docker Kılıfı:** Yapay zekayı Her Sunucu Çalıştıramaz (Cuda kütüphaneleri Eskidir vs vs). Otonom model Projenin Eteğine Kusursuz Bir `Dockerfile` Gİydirir! (Örn `FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-runtime`). İçine FastAPI'ı Gömüp Portu Açar. Nereye götürseniz Orada Çalışr!!! (Bug Yok).

Adımlar tamsa "04-FilesStructure" yönergelerine Geçeceksiniz.
