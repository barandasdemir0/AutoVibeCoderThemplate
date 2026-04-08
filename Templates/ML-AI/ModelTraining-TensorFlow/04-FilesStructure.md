# 📂 Files Structure — TensorFlow

```
project/
├── data/
│   ├── raw/              → Ham veri dosyaları
│   ├── processed/        → İşlenmiş veri
│   └── splits/           → train/ val/ test/
├── src/
│   ├── data/
│   │   ├── dataset.py    → tf.data.Dataset pipeline oluşturma
│   │   │                   .from_tensor_slices, .map, .batch, .prefetch
│   │   └── augmentation.py → Veri artırma (tf.image, Albumentations)
│   ├── models/
│   │   ├── model.py      → Keras model tanımı (Sequential/Functional/Subclass)
│   │   │                   compile(), summary() burada
│   │   └── layers.py     → Custom Keras Layer (tf.keras.layers.Layer)
│   ├── training/
│   │   ├── train.py      → model.fit() ile eğitim
│   │   └── callbacks.py  → EarlyStopping, ModelCheckpoint, LRScheduler, TensorBoard
│   ├── evaluation/
│   │   ├── evaluate.py   → model.evaluate() + classification_report
│   │   └── metrics.py    → Custom metrikler
│   └── inference/
│       ├── predict.py    → model.predict() ile tahmin
│       └── export.py     → SavedModel, TFLite, ONNX, TF.js dışa aktarma
├── configs/default.yaml
├── notebooks/ (01_eda, 02_training, 03_evaluation)
├── checkpoints/
├── logs/                 → TensorBoard logları
├── train.py, evaluate.py, predict.py
├── requirements.txt
└── README.md
```

## Best Practices
1. **tf.data** kullan (NumPy array'den daha hızlı): `.prefetch(AUTOTUNE)`
2. **Mixed Precision**: `tf.keras.mixed_precision.set_global_policy('mixed_float16')`
3. **Callbacks**: Her zaman EarlyStopping + ModelCheckpoint
4. **model.summary()**: Her model tanımından sonra boyutları kontrol et
5. **Transfer Learning**: Büyük model → freeze → fine-tune
6. **Reproducibility**: `tf.random.set_seed(42)`, `np.random.seed(42)`
