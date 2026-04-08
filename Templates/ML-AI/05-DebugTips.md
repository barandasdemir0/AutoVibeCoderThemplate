# 5️⃣ ML / AI Geliştirme - Model Çökmeleri, Eğitim Tıkanıkları ve Gradient Sızıntıları

> **ZORUNLU STANDART:** Hata Mesajları Python Cıktısında Vurulmasada Model Eğitilirken Eğer Loss (Kayıp) Değeri 5 Saat Boyunca Hiç Azalmıyorsa (Sabit Kalıyorsa), Model NaN atıyorsa Otonom Yapay Zeka Bu Çöküşleri Gözardı Edemez! Gerekli Loglama Kurgularıyla Derhal Önlemlerin Alınması Beklenmektedir.

---

## 🚫 1. Exploding Ve Vanishing Değer Darboğazı

Model Eğitimi Esnasında Loss Rakamları Bir Anda `Loss: NaN` İfadesine Döndüyse (Not a Number), Sonsuza Giden The Infinity Bozukluğu Vardır (Trafik Kazası). Otonom model Bu Felaketlere Sebebiyet Veremez.

1. ❌ **The Learning Rate (Öğrenme Oranı) Faciası:**
   Ağ Cok Dar Veya Genisken Ve Eger Modelin Öğrenme oranı `LR = 0.5` Gibi Absürt Yüksek Vurulmuşsa, Modelin Loss'u Eğitilemez Sağ sola Sıçrar Paramparça Olur!.
   *DOĞRUSU:* Otonomi Motoru Mutlaka Default Olarak The Güvenli (Örn: `1e-3` veya `3e-4`) Rakamlarına Set Etmelidir Ve **Adam/AdamW** Gibi Akıllı Optimizerlar Vitesine Takılarak Mükemmeliyeti Güvence Altına Almalıdır!.

2. ❌ **CrossEntropy VE YASAKLI Yumuştamcı (SoftMax):**
   Eğer Otonom AI Multi-Class Classification (10 Sınıflı Kategori Tahini) Yapıyorsa Modeli "PyTorch" Cekerken:
   *Modelin EN SON KATMANINA* `nn.Softmax()` Ekleyip, Sonra Da Eğitim Klasöründe `nn.CrossEntropyLoss()` ÇağırıyorSA BÜYÜY BİR FACIADIR! ÇÜNKÜ `CrossEntropyLoss` Kendinin İçiinde Zaten Softmax Yapar, Eger Sen 2 Kere Yaparsan Gradnyantlar Ölür! Otonom zeka The Matematik Kuralı Olarak PyTorch da Cıktıyı YALIN (Logits) Bırakır!!

---

## 💥 2. Eğitim Esnasında RAM Kitlemesi Ve Graph Sızıntısı

Yapay Sinir ağlarında Hafıza Optimizasyonu Ölümcüldür!! Eğer Döngü de Hata Yaparsanız The RAM Patlaması Yersiniz.

1. ❌ **Kayıpları Toplarken History (Graf) Sızıntısı:**
   ```python
   # YASAKTIR: PyTorch'da The loss Objesi Sadece Değer Degildir Bütün Arka Plan Baglantılarını Tutar (Gradients).
   total_loss += loss 
   ```
   *DOĞRUSU (Otonomi Standardı):* Sen Eğer Loss Degerini Yazdırmak veya Toplamak İstiyorsan Onu GRAFTAN KOPARACAKSIN `loss.item()`!!. Bu Hamle The Ramı "MB" Seviyelerinden 100Gb LARA Şişmesini Otonom Engelleyen Sır'dır!!:
   ```python
   total_loss += loss.item() # Yalnizca Float deger Alindi Temizlendi!!
   ```

2. ❌ **The Evaluation (Değerlendirme) Esnasında Gradienleri Kapamamak:**
   Eğer Eğitim Bitti Testleri deniyoruz Çöktü... Neden?
   BÜTÜN TEST CLASININ ETRAFINA Otonom Motor Mutluaka `with torch.no_grad():` YADA `model.eval()` KOMUTLARINI ETİKTETLEMEK ZORUNDADIR!!. Test Ederken Bellekte Neden Öğrenme Acık Kalsın RAM i Sömürsün!!.

---

## 📊 3. Eğitim Takibi (Model Monitoring) Ve Kayıt Çarkı

AI Ekibi Bir Kodu Calıstırıp 3 Gün Ekrana Bakarak (Siyah Cıktılar Cıkan CMD'ye) Beklemez! The Otonom Profesyonellik Loglama Ister!.
* **TensorBoard / WandB (Weights & Biases):** Otonom Zeka Loss ları, Accuracy i Yada Arasıra Resimleri Görsel Chartlara Dökebilecei The Kurumsal Tool Olan **TensorBaord** Kurgusunu Kurmalıdır (Eger Istendıyse)! Sadece Consol cıktısı Printlemek AmatörlerİÇin Geçerelidir. (Veya Progress bar İzin tqdm kütüphanesi Pompalanır Mükemmel UI)

---

## 🚦 4. Model Sunucu Tahmin (Server) İpuçları
* Eğer The Otonom Model Mimarisi FastAPI serverında Çalıştırılmışsa VEYA Sunucudan Beklerken. GPU ile mi CPu ıle Mi Calısacağı Çok önemlidir. İstek Başına Eger Resim 4MB iase Serverin Memorysi Zıplar! The Sunucuya "Resmi Girmeden Önce Yüzde 50 Küçült" Fonksiyonu Otonom Olarak Enjete edilir Ve Prediction Hızlandırılır.! (Zaman Kritik!).
