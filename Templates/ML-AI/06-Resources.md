# 6?? ML / AI Geliştirme - Kurumsal Native Data Science Ekosistemleri

> Profesyonel, otonom bir AI sistemi bilgisayarlı görü veya dil modeli eğitirken tekerleği sıfırdan icat etmez. Büyük ve derlenmiş paketler otonomun zırhıdır.

---

## 1. Kilit Taşı Endüstri Python Modülleri

### Yapay Zeka ve Neural Engine
* **torch (PyTorch):** Üniversiteden Ar-Ge merkezine kadar güçlü bir tercihtir. TensorFlow karmaşasından uzak, nesne yönelimli yapı sağlar.
* **transformers (HuggingFace):** NLP yapılıyorsa güçlü bir standarttır. Pre-trained modellerin üzerine ince ayar uygulanır.

### Veri Hazırlığı ve Analitik
* **pandas ve numpy:** CSV ve matris işlemleri için zorunlu araçlardır.
* **scikit-learn:** Klasik ML ve train/test split gibi işlemler için vazgeçilmezdir.

### Sunucu ve API Katmanı
* **fastapi ve uvicorn:** Modelin servis edilmesi için güçlü bir REST köprüsüdür.

---

## 2. Yapay Zekaya İstem Formülleri

Örnek komut kalıpları:

> "Bir kedi/köpek sınıflandırıcı görüntü işleme modeli eğitim dosyası yaz."

Zorunlu kurallar:
1. Veriyi `ImageFolder` ve `DataLoader` ile batch'ler halinde oku.
2. `torchvision.models` içinden transfer learning ile hazır bir ağ seç, son katmanı hedef sınıfa göre değiştir.
3. Eğitim bitince modeli `.pth` olarak `models/` altına kaydet.

> "Eğitilmiş BERT text-classification modelini FastAPI ile servis et."

Sunucu açılışında model lifecycle ile RAM'e alınır ve Docker komutları buna göre hazırlanır.

---

## 3. Faydalı Kaynak Linkleri
* **PyTorch Torchvision / Audio / Text Docs:** Normalize sabitleri ve temel model referansları.
* **FastAPI - ML Deployment Best Practices:** Modelin asenkron servisi ve giriş doğrulama rehberi.
