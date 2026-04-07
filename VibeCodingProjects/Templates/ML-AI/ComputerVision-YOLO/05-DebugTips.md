# 🐛 Debug Tips — YOLO CV
## Sık Hatalar & Çözümler
- **"No labels found"** → labels/ klasör yapısı images/ ile aynı mı?
- **mAP 0** → data.yaml path'leri doğru mu? nc (sınıf sayısı) doğru mu?
- **CUDA OOM** → `imgsz=416`, `batch=8`
- **Yavaş eğitim** → `workers=4`, GPU kullanım kontrol
- **Class imbalance** → Augmentation, oversampling, class weights

## Araçlar
TensorBoard, Ultralytics Hub, Roboflow, `yolo detect train/val/predict`

## 📓 Debug Günlüğü
| Tarih | Hata | Çözüm |
|-------|------|--------|
| [—]   | [—]  | [—]    |
