# 🏗️ Architecture — YOLO Computer Vision

## Proje Yapısı
```
project/
├── datasets/
│   ├── images/ (train/, val/, test/)    → .jpg/.png resimler
│   ├── labels/ (train/, val/, test/)    → YOLO format .txt
│   └── data.yaml                         → Dataset config
├── src/
│   ├── train.py        → YOLO model eğitimi
│   ├── validate.py     → mAP, precision, recall değerlendirme
│   ├── predict.py      → Tek/batch resim tahmin
│   ├── export.py       → ONNX, TFLite, TorchScript dışa aktarma
│   ├── augmentation.py → Albumentations ile veri artırma
│   ├── stream.py       → Webcam/video real-time detection
│   └── utils/
│       ├── convert_labels.py → VOC/COCO → YOLO format dönüştürme
│       └── visualize.py      → Bounding box çizme, sonuç gösterme
├── api/
│   ├── app.py          → FastAPI inference endpoint
│   └── onnx_predict.py → ONNX Runtime ile hızlı inference
├── runs/               → YOLO otomatik output (weights, graphs)
├── weights/            → Pretrained + custom weights
├── notebooks/          → EDA, veri analizi
├── requirements.txt
└── README.md
```

## YOLO Workflow
```
Veri Toplama → Etiketleme → data.yaml → model.train() → model.val()
    → model.predict() → model.export() → API Deploy
```

## Best Practices
1. **Veri kalitesi > veri miktarı**: Doğru etiketlenmiş 500 resim > yanlış 5000
2. **Augmentation**: Mosaic, flip, rotate, HSV → YOLO varsayılan augmentation iyi
3. **Transfer Learning**: Pretrained model (yolov8n.pt) ile başla
4. **Model boyutu**: nano(n) → small(s) → medium(m) → large(l) → extra-large(x)
5. **Confidence threshold**: 0.25 (geliştirme) → 0.5-0.7 (production)
6. **Export**: ONNX (server), TFLite (mobil), TensorRT (edge GPU)
