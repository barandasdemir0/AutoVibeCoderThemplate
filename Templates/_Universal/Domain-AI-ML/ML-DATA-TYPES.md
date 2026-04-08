# 🧠 ML-DATA-TYPES.md — Veri Tipine Göre Model Eğitimi Rehberi

---

## 📊 Veri Tipine Göre Yaklaşım

| Veri Tipi | Framework | Model | Preprocessing |
|-----------|-----------|-------|---------------|
| **Text (NLP)** | HuggingFace Transformers | BERT, GPT, T5 | Tokenization |
| **Image (Görüntü)** | PyTorch/TensorFlow, YOLO | CNN, ResNet, YOLO | Resize, Normalize, Augment |
| **Audio (Ses)** | torchaudio, librosa | Wav2Vec, Whisper | Mel spectrogram, MFCC |
| **Video** | PyTorch + OpenCV | 3D-CNN, SlowFast | Frame extraction, optical flow |
| **Tabular (Tablo)** | Scikit-learn, XGBoost | RF, XGBoost, LightGBM | Normalization, encoding |
| **Time Series** | PyTorch, Prophet | LSTM, Transformer | Window, normalize, lag features |

---

## 📝 TEXT (NLP) — Metin Tabanlı Model

### Pipeline
```
Raw Text → Cleaning (lowercase, stopwords, regex)
    → Tokenization (AutoTokenizer)
    → Encoding (input_ids, attention_mask)
    → Model (BERT/GPT) → Fine-tune
    → Inference (pipeline)
```

### Görevler
| Task | Model | HF Class | Metric |
|------|-------|----------|--------|
| Classification | BERT, DistilBERT | AutoModelForSequenceClassification | Accuracy, F1 |
| NER | BERT, RoBERTa | AutoModelForTokenClassification | Entity F1 |
| Summarization | T5, BART | AutoModelForSeq2SeqLM | ROUGE |
| Q&A | DeBERTa | AutoModelForQuestionAnswering | F1, EM |
| Generation | GPT-2, LLaMA | AutoModelForCausalLM | Perplexity |
| Translation | mBART | AutoModelForSeq2SeqLM | BLEU |

### Türkçe NLP
- Model: `dbmdz/bert-base-turkish-cased`, `savasy/bert-base-turkish-sentiment-cased`
- Tokenizer dikkat: Türkçe karakter desteği kontrol et

---

## 🖼️ IMAGE (Görüntü) — Bilgisayarlı Görme

### Pipeline
```
Images → Resize (224x224 / 640x640)
    → Normalize (mean, std)
    → Augmentation (flip, rotate, color jitter)
    → Model (CNN/YOLO) → Train
    → Inference
```

### Görevler
| Task | Model | Lib | Metric |
|------|-------|-----|--------|
| Classification | ResNet, EfficientNet | torchvision | Accuracy, F1 |
| Object Detection | YOLOv8, Faster R-CNN | Ultralytics | mAP@50 |
| Segmentation | U-Net, Mask R-CNN | segmentation_models_pytorch | IoU, Dice |
| Face Recognition | ArcFace, FaceNet | face_recognition | Accuracy |
| OCR | Tesseract, PaddleOCR | pytesseract | Character accuracy |

### Augmentation Best Practice
```python
import albumentations as A
transform = A.Compose([
    A.RandomResizedCrop(224, 224),
    A.HorizontalFlip(p=0.5),
    A.ColorJitter(brightness=0.2, contrast=0.2),
    A.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])
```

---

## 🔊 AUDIO (Ses) — Ses İşleme

### Pipeline
```
Audio (.wav/.mp3) → Resample (16kHz)
    → Mel Spectrogram / MFCC feature extraction
    → Model (Wav2Vec, Whisper, CNN)
    → Inference
```

### Görevler
| Task | Model | Lib |
|------|-------|-----|
| Speech-to-Text | Whisper, Wav2Vec | transformers, whisper |
| Audio Classification | CNN + Spectrogram | torchaudio |
| Speaker ID | ECAPA-TDNN | speechbrain |
| Music Generation | MusicGen | transformers |

```python
# Whisper ile ses → metin
import whisper
model = whisper.load_model("base")
result = model.transcribe("audio.mp3", language="tr")
print(result["text"])
```

---

## 🎥 VIDEO — Video İşleme

### Pipeline
```
Video → Frame extraction (OpenCV, 1-5 FPS)
    → Her frame'e image processing
    → Temporal model (3D CNN, SlowFast, LSTM)
    → veya: Frame-by-frame detection (YOLO per frame)
```

### Görevler
| Task | Yaklaşım |
|------|----------|
| Action Recognition | SlowFast, TimeSformer |
| Video Object Detection | YOLO per frame |
| Video Summarization | Key frame extraction |
| Real-time Detection | YOLO + OpenCV VideoCapture |

```python
# YOLO ile video detection
from ultralytics import YOLO
model = YOLO('best.pt')
results = model.predict(source='video.mp4', stream=True, save=True)
```

---

## 📈 TABULAR (Tablo Verisi) — Klasik ML

### Pipeline
```
CSV/DB → Pandas DataFrame
    → EDA (null, outlier, dağılım)
    → Feature Engineering (encoding, scaling)
    → Train/Test Split
    → Model (XGBoost, LightGBM, RandomForest)
    → Evaluate (accuracy, AUC, RMSE)
```

```python
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
model = RandomForestClassifier(n_estimators=100)
model.fit(X_train, y_train)
print(f"Accuracy: {model.score(X_test, y_test)}")
```
