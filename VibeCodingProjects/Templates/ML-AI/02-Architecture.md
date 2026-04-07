# 2️⃣ ML / AI Geliştirme - Model Mimarisi ve GPU/Lifecycle Yönetimi

> **MİMARİ KURALI:** Eğer Otonom yapay zeka bir Script İçerisinde Data Frame (Pandas) Okuyor, Görüntüyü Boyutlandırıyor, Arkasından Modeli Derleyip Eğitiyorsa Bu Oksijensiz (Nefes Nefese) Bırakılmış Bir Spagettidir. Eğitim (Train), Çıkarım (Inference) ve Doğrulama (Eval) Klasörden Klasöre Kesin olarak Ayrılmalıdır!.

---

## 🏛️ 1. Otonom Model Mimarisi (Object Oriented AI)

PyTorch Kurumsal Dünyanın Zirvesidir. Otonom AI; Modelleri Sınıf (`Class`) Olarak yaratırken Fonksiyonlara Asla Hard-Code Rakam girmeyecektir!
```python
import torch.nn as nn

# OTONOM KUSURSUZ MİMARİ
class VisionModel(nn.Module):
    def __init__(self, num_classes=10, dropout_rate=0.5): # HYPER-PARAMETRELER DIŞARI AÇIK (Esnek)
        super(VisionModel, self).__init__()
        self.conv1 = nn.Conv2d(3, 32, kernel_size=3)
        self.dropout = nn.Dropout(dropout_rate)
        self.fc = nn.Linear(32 * 26 * 26, num_classes) # Parametrik SInıf sayisi

    def forward(self, x): # DAIMA FORWARD BÖYLE İLERLER!
        x = self.conv1(x)
        x = self.dropout(x)
        return self.fc(x.view(x.size(0), -1))
```
Böylece Otonom Model Başka Bir Projede Bu Modeli Aldıgıda (num_classes=5) diyerek Yenileyebilir!. Spagetti engellenmiştir.

---

## 🏗️ 2. Veri Taşıyıcıları Ve Batch (Mini-Gruplar) Pumping

Yapay zeka modellerine Veri "Hepsi birden" Yüklenemez. 100 GB Veriyi RAM'e (Memory) yüklemeye calişan Amatör/Eğitimsiz Kod EKRANA "OOM (Out Of Memory - Hafıza Boşaldı)" Hatası vurarak Makineyi Resetler!.

* **Otonom Zeka Kalkanı (The DataLoader):** Otonomi (Özellikle PyTorch Dataloader) Kullanarak Datasetini Batch'ler (Örn: 64 Tane Resim) Halinde RAM'e Pompalar! Mükemmel Performans Saglar! `num_workers=4` vererek İşlemcinin Çekirdeklerinden (Multi-Thread) istifade Eder Veri Besleme Darboğazını SÖKER ATAR.

---

## 🚫 3. YASAKLI İŞLEMLER (Machine Learning Anti-Patterns)

Otonom model AI kodunda şu Vebalardan Sakınacaktır:

1. ❌ **TensorLarı (Verileri) GPU'ya Aktarmayı (Cuda:) Unutmak:**
   ```python
   # FELAKET - Veri RAM'de kaldı, Model GPU'da. PyTorch HATA FIRLATIR VEYA İŞLEMİŞLEM CPU'YA GEÇER (Hantallaşır).
   output = model(images) 
   ```
   *DOĞRUSU:* Otonomi Motoru Cihazın Kalbine İnmelidir: `device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')`. Ardından Eğitime Girmeden Modeli `model.to(device)` Ve Veriyi `images.to(device)` Olarak Aynı Çekirdeğe Taşımalıdır!!! Bu Unutulamaz!.

2. ❌ **Test Verisi İle Eğitim Yapmak (Data Leakage - Sızıntı):**
   Eğer Eğitim Esnasında Model "Test (Görmemesi gereken final testini)" görürse, Başarı %99 çıkar ve Kendinizi Einstein Sanırsınız. Ancak Müşterinin elinde Model ZIRVALAR! Otonom Zeka Projenin en başında Veriyi **Kesin (Iron-Clad) Olarak Çizer:** `Train (%80), Val (%10), Test (%10)`. Test Verisi En sona kadar KLASÖRDE KİLİTLENDİRLİR (Erişim Yasaktır).

3. ❌ **Modelin Ağırlıklarından (Weights) Korkunç Export Almak:**
   Eğer PyTorch Modeli Otonom AI tarafından `torch.save(model, 'model.pth')` Olarak Bütün Class ile Beraber Exportlanırsa! Yarın Class'ın ismi Değişirse Model Açılamaz!!. KESİNLİKLE VE ZORUNLU OLARAK Sadece Ağırlıklar (State_Dict) Çıkarılır: `torch.save(model.state_dict(), 'weights.pth')`. Bu Altın Kuraldır!!.
