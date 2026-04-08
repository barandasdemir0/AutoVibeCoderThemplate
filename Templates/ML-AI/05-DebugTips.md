# 5?? ML / AI Geliştirme - Model Çökmeleri, Eğitim Tıkanıkları ve Gradient Sızıntıları

> **ZORUNLU STANDART:** Hata mesajları Python çıktısında görünmese bile, model eğitilirken loss değeri uzun süre azalmıyorsa veya NaN oluyorsa bu sorunlar göz ardı edilmemelidir. Gerekli loglama ile önlem alınmalıdır.

---

## 1. Exploding ve Vanishing Değer Darboğazı

Model eğitimi sırasında loss değeri bir anda `Loss: NaN` oluyorsa sonsuza kayan bir bozukluk vardır. Otonom model bu felaketlere sebebiyet veremez.

1. **Learning rate faciası:**
   Öğrenme oranı aşırı yüksekse loss sağa sola sıçrar ve eğitim bozulur.
   **Doğrusu:** Güvenli bir başlangıç değeri kullanılır, örneğin `1e-3` veya `3e-4`. Adam/AdamW gibi optimizer'lar tercih edilir.

2. **CrossEntropy ile Softmax çakışması:**
   Çok sınıflı sınıflandırmada `nn.Softmax()` ile `nn.CrossEntropyLoss()` birlikte yanlış kullanılmamalıdır. `CrossEntropyLoss` zaten softmax içerir. Çıktı logits olarak bırakılır.

---

## 2. Eğitim Esnasında RAM Kitlemesi ve Graph Sızıntısı

Yapay sinir ağlarında hafıza yönetimi kritiktir.

1. **Loss biriktirirken graph sızıntısı:**
   ```python
   # YANLIŞ
   total_loss += loss
   ```
   **Doğrusu:**
   ```python
   total_loss += loss.item()
   ```

2. **Değerlendirme sırasında gradientleri kapatmamak:**
   Test sırasında `with torch.no_grad():` ve `model.eval()` kullanılmalıdır.

---

## 3. Eğitim Takibi (Model Monitoring) ve Kayıt Çarkı

Profesyonel sistem, sadece konsol çıktısı ile çalışmaz.
* **TensorBoard / WandB:** Loss ve accuracy gibi metrikler grafiksel olarak takip edilir.

---

## 4. Model Sunucu Tahmin İpuçları
* FastAPI üzerinde çalışan modelde GPU/CPU seçimi net olmalıdır.
* Büyük görseller için isteği küçültme veya ön işleme adımı uygulanır.
