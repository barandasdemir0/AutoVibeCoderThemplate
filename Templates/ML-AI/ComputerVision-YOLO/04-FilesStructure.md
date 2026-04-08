# 📂 Files | 🐛 Debug | 📚 Resources — YOLO (Supplementary)

## Dosya Açıklamaları
| Dosya | Ne İş Yapar? |
|-------|-------------|
| `data.yaml` | Dataset yolu, sınıf isimleri, sınıf sayısı |
| `train.py` | `model.train()` → eğitim başlatma |
| `predict.py` | `model.predict()` → resim/video tahmin |
| `export.py` | `model.export()` → ONNX/TFLite/TensorRT |
| `stream.py` | Webcam / RTSP real-time detection |
| `api/app.py` | FastAPI upload→predict→return JSON |
| `convert_labels.py` | VOC XML / COCO JSON → YOLO TXT |

## FastAPI Inference
```python
from fastapi import FastAPI, UploadFile
from ultralytics import YOLO

app = FastAPI()
model = YOLO('best.pt')

@app.post("/detect")
async def detect(file: UploadFile):
    contents = await file.read()
    results = model.predict(source=contents, conf=0.5)
    detections = []
    for r in results:
        for box in r.boxes:
            detections.append({
                'class': r.names[int(box.cls)],
                'confidence': float(box.conf),
                'bbox': box.xyxy[0].tolist()
            })
    return {"detections": detections}
```
