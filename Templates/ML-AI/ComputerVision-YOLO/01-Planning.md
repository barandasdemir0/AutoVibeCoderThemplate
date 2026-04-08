# 📋 Planning — Computer Vision (YOLO Object Detection)

## 🎯 Proje
- **Proje Adı:** [—]
- **Tip:** Nesne Tespiti / Image Classification / Segmentation
- **Açıklama:** [—]

## 🛠️ Tech Stack
| Katman | Teknoloji |
|--------|-----------|
| Model | Ultralytics YOLOv8/v11 |
| CV Lib | OpenCV, PIL/Pillow |
| Annotation | LabelImg, Roboflow, CVAT |
| Veri | Pandas, NumPy |
| Deploy | FastAPI + ONNX, Gradio |
| GPU | CUDA |

## 📦 pip
```
ultralytics
opencv-python-headless
pillow
fastapi uvicorn
onnxruntime
gradio
roboflow
```

## ⭐ MVP
1. [ ] Veri toplama & etiketleme (annotation)
2. [ ] YOLO data format (images/ + labels/)
3. [ ] data.yaml config
4. [ ] Model eğitimi (`model.train()`)
5. [ ] Validation (`model.val()`)
6. [ ] Inference (`model.predict()`)
7. [ ] Export (ONNX/TFLite)

# 🏗️ Architecture
```
project/
├── datasets/
│   ├── images/ (train/, val/, test/)
│   ├── labels/ (train/, val/, test/) → YOLO format: class x y w h
│   └── data.yaml              → path, names, nc
├── src/
│   ├── train.py               → model.train(data='data.yaml', epochs=100)
│   ├── validate.py            → model.val()
│   ├── predict.py             → model.predict(source='image.jpg')
│   ├── export.py              → model.export(format='onnx')
│   ├── augmentation.py        → Albumentations pipeline
│   └── utils/
│       ├── annotation_tools.py → Label format dönüştürme
│       └── visualization.py    → Bounding box çizme
├── runs/                       → YOLO otomatik çıktı klasörü
├── weights/                    → Pretrained + trained weights
├── api/
│   └── app.py                  → FastAPI inference endpoint
├── requirements.txt
└── README.md
```

## YOLO Data Format
```
# labels/train/image001.txt (her satır bir obje)
# class_id center_x center_y width height (normalized 0-1)
0 0.45 0.52 0.12 0.08
1 0.73 0.31 0.15 0.22
```

## data.yaml
```yaml
path: ./datasets
train: images/train
val: images/val
test: images/test
nc: 2
names: ['hardhat', 'no_hardhat']
```

# 📝 Step-by-Step
1. [ ] Veri topla (web scraping, kamera, dataset)
2. [ ] Roboflow / LabelImg ile etiketle → YOLO format
3. [ ] `data.yaml` oluştur
4. [ ] `from ultralytics import YOLO; model = YOLO('yolov8n.pt')`
5. [ ] `model.train(data='data.yaml', epochs=100, imgsz=640)`
6. [ ] `model.val()` → mAP, precision, recall
7. [ ] `model.predict(source='test.jpg', save=True, conf=0.5)`
8. [ ] `model.export(format='onnx')` → production deploy

# 🐛 Debug Tips
- **mAP düşük**: Daha fazla veri, augmentation, daha büyük model (n→s→m→l)
- **Etiket hatası**: `labels/` dosya adları `images/` ile eşleşmeli
- **CUDA OOM**: `imgsz` küçült (640→416), batch küçült
- **Yanlış tespit**: `conf` threshold artır (0.5→0.7)
- **Slow inference**: `model.export(format='onnx')` + `onnxruntime`

# 📚 Resources
| Kaynak | Link |
|--------|------|
| Ultralytics YOLO | https://docs.ultralytics.com |
| Roboflow | https://roboflow.com |
| OpenCV | https://docs.opencv.org |
| CVAT | https://www.cvat.ai |
| LabelImg | https://github.com/HumanSignal/labelImg |

### YOLO CLI
```bash
yolo detect train data=data.yaml model=yolov8n.pt epochs=100
yolo detect val data=data.yaml model=runs/detect/train/weights/best.pt
yolo detect predict model=best.pt source=test_images/ conf=0.5
yolo export model=best.pt format=onnx
```
