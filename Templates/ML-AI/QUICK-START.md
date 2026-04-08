# ⚡ ML/AI & MODEL MLOPS - OTONOM BEYİN (QUICK-START & MASTER RULES)

> **DİKKAT YAPAY ZEKA:** EĞER BU PROJEDE ÖLÇEKLENEBİLİR BİR YAZILIM YETERLİLİĞİNDEN ZİYADE BİR `MAKİNE ÖĞRENMESİ (AI)` VE `PYTHON VERİ EĞİTİM MOTORU` ÇALIŞTIRIYORSAN, AŞAĞIDAKİ (GPU GÜVENLİ, MATEMATİKSEL İZOLASYON) KURALLARINA %100 UYMAK ZORUNDASIN. İÇ KANAMASI GEÇİREN DÜZENSİZ NOTEBOOKLAR VEYA ARAYÜZ (API/DOCKER) SUNMAYAN ÇÖP MODELLER ÜRETİRSEN İŞLEM İPTAL OLUR. BİZ MÜKEMMEL BİR ÜRETİM (MLOPS) İSTİYORUZ!.

## 🚨 YASAKLAR LİSTESİ (ANTI-PATTERNS) - ASLA YAPMA!

1. ❌ **SPAGETTİ (HEPSİ BİR DOSYADA/NOTEBOOKTA BİTEEN) KARGAŞASI YASAKTIR:** 
   Otonom Zeka Gidip Veriyi Okuma, Modeli Sınıflandırma(Class) Ve Egitimi Bütünleşik `main.py` ye 500 SATIR Alt Alta YAZAMAZ!!! Bu Bir Kabustur! Modeller `src/models/` Dataseti `src/data/` Altında Dosyalardan İZOLE OLARAK importlanacaktır! MLOPS Felsefesi Zırhdır!.

2. ❌ **DATA SIZMASI (LEAKAGE) HİLESİ - HARFİYEN YASAKTIR:** 
   Öğrenci Kodu Gibi Gidip Modeli Bütün (10.000) Data Icerisinde EGİTİP, Sonra Test Adımında YİNE AYNI BÜTÜN DATA'dan Doğrulama ÇEKERSEN MODELIN ACURACCY'si (BASARISI) ŞANZIMAN GİBİ %100 Çıkar Fakat GERÇEK Müşteride Patlar!!! The Train Ve Test Spliti Baştan Yapıp Testi SAKLAMADAN Gelemezsin Otonomi PÜRFİKSİ!!.

3. ❌ **TENSOR (VERİ) MATRİSİNİN GPU (CUDA) UNUTULMASI YASAKTIR:** 
   Modelin .to(device) Veya .cuda() İLE EKran Kartına (GPU ya) Takmıssan Bütün Verileri (Batch leri) ve Target() Verileride CUDAYA ALMAK ZORUNDASIN! Aksi Taktirde (Expected tensor Cuda Device CPU found) Hatası Uretıcının (IDE mizin) Çarmagına GERILIR! PyTorch Affetmez Patalar!!.

4. ❌ **DEPLOYMENT (SUNUCU) İZOLASYON İHLALİ (LOAD MODEL SPAM) YASAKTIR:**
   Fastapi da Endpoint'in (Yanı Methodun) İcıne Kullanıcı Resim Gönderdi Diye `model = torch.load("model.pth")` Yazarsan.... Müşteri Her İstek Yolladığında Sunucu "3 Gb lık AĞIRLIĞI" Ram'e Baştan Tıkar. İkinci İstekte Sunucu Crash Olur OOM Hata Patlarır!!. Model SADE C E `startup_event` Ile 1 Kere Ram'e Bindirilir Methodun İçinde Sadece Tahimin (Inference) İşlemi Yapılır!!.

---

## ✅ ZORUNLU MİMARİ YAPISI (N-TIER ENTERPRISE)

```text
/my-ai-repo (THE MLOPS FORMATI)
 ├── /data                 => /raw, /processed Olarak Ayrılmış (Gitİgnore OLAN) Kaynak.
 ├── /notebooks            => KAFANA GÖRE Takılıp İstatıskleri (EDA) Resmettıgımız THE DENEY LABI.
 ├── /src                  => ÇEKİRDEK (MÜKEMMEL)
 │    ├── /data            => Loaders / Datasets.py (Dataları Ram'e Pompalar Batch Batch)
 │    └── /models          => networks.py (Orijinal CNN Veya LLM Sınıfı Kurguları!) Veya train.py EĞİTİCİ!
 ├── /app                  => THE PRODUCTION (SUNUCU): FASTAPI main.py Buradadır. 
 └── params.yaml           => BÜTÜN Eğitim LR(OgrebmeHızı), BatchSizeleri BURDAN AYARLANIR!!
```

---

## 🛠️ BAŞLAMADAN ÖNCE BİLMEN GEREKEN İLK ADIM

Eğer User sana "Bir Text Ureticisi Yada Resim Sınıflandırısı Pytorch Kullan Çiz" dediyse dahi,
**BU DOSYA (QUICK-START)** seni bağlar. 

1. Bağımlıklıklara İlgili Paketi (`torch`, `fastapi`, `uvicorn`) Cakarark İşe Başla! Ama Pip Paketlerini The `requirements.txt`'ye Kusurszca EKleyip Otonom Olarak CI/CD Ortamına Bırak!!!
2. Modelleri Kendi (Sıfırdan The Matematik) Çizmiyorsan Bİle , Kesin Transfer Learning (Huggingface Veya Torchvison Models) Çek!! Egitim Hızlansın CİHAZ YORULMASIN (Otonom Tasarruf ve GPU Ekonomisi!).
3. Data Loaderlarında Eger Bilgisayar Ram'in %100 Üne Çökmek Istemıyorsan Kesinlikle Batch Size leri Optimal The Rakamlarda (64. 128) Pompala! 
4. Sunucu Docker'a Bağla... Bütün Makina O Docker Kılıfında Cihaz Ayırt Etmeksizin (Dependency Hell Savaşmadan) API YAYINLAYABLILCEK HALE OTONOM GELSIN!!.

**YAPAY ZEKA DENEYLERİ MİMARİ VE SUNUCU(API) İLE BİRLEŞMEDİĞİ SÜRECE ÜRÜN DEĞİLDİR, SADECE BİR OKUL ÖDEVİDİR VE BİZ ÜRÜN İSTİYORUZ! BAŞLAYABİLİRSİN!**
