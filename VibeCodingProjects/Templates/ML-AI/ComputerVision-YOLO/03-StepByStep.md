# 📝 Step-by-Step | 📂 Files | 🐛 Debug | 📚 Resources — YOLO

## Adımlar
1. [ ] Veri topla (Roboflow, Google Images, kamera)
2. [ ] CVAT / LabelImg / Roboflow ile etiketle
3. [ ] YOLO format: `images/train/`, `labels/train/`, `data.yaml`
4. [ ] `pip install ultralytics`
5. [ ] `model = YOLO('yolov8n.pt'); model.train(data='data.yaml', epochs=100, imgsz=640)`
6. [ ] `model.val()` → mAP@50, mAP@50-95 kontrol
7. [ ] `model.predict(source='test/', save=True)`
8. [ ] `model.export(format='onnx')`
9. [ ] FastAPI endpoint → upload image → return detections

## Debug Tips
| Sorun | Çözüm |
|-------|-------|
| mAP düşük | Daha fazla veri, büyük model, augmentation |
| Yanlış tespit | conf threshold artır, NMS IoU ayarla |
| Etiket uyumsuz | Dosya adları images↔labels eşleşmeli |
| CUDA OOM | imgsz küçült, batch küçült |
| Slow inference | ONNX export, TensorRT, batch predict |

## Resources
| Kaynak | Link |
|--------|------|
| Ultralytics | https://docs.ultralytics.com |
| Roboflow | https://roboflow.com |
| OpenCV | https://docs.opencv.org |
| YOLO CLI | `yolo detect train/val/predict/export` |

## Experiment Günlüğü
| Tarih | Model | Epochs | imgsz | mAP@50 | mAP@50-95 | Notlar |
|-------|-------|--------|-------|--------|-----------|--------|
| [—]   | [—]   | [—]    | [—]   | [—]    | [—]       | [—]    |
