# 🏗️ Architecture — TensorFlow / Keras

## 🧱 Proje Yapısı
```
project/
├── data/ (raw/, processed/, splits/)
├── src/
│   ├── data/
│   │   ├── dataset.py      → tf.data.Dataset pipeline
│   │   │                     .map(), .batch(), .prefetch() zinciri
│   │   └── augmentation.py → tf.image veya Albumentations
│   ├── models/
│   │   ├── model.py         → Keras model tanımı
│   │   │                     Sequential/Functional/Subclass API
│   │   └── layers.py        → Custom Layer (tf.keras.layers.Layer)
│   ├── training/
│   │   ├── train.py         → model.compile() + model.fit()
│   │   └── callbacks.py     → EarlyStopping, Checkpoint, LRScheduler
│   ├── evaluation/
│   │   ├── evaluate.py      → model.evaluate(), confusion matrix
│   │   └── metrics.py       → Custom metrics
│   └── inference/
│       ├── predict.py       → model.predict()
│       └── export.py        → SavedModel, TFLite, TF.js
├── configs/ (default.yaml)
├── notebooks/ (eda, training, evaluation)
├── checkpoints/
├── logs/ (TensorBoard)
├── train.py, evaluate.py, predict.py
├── requirements.txt
└── README.md
```

## Keras 3 API Seçenekleri
| API | Ne Zaman? | Örnek |
|-----|-----------|-------|
| Sequential | Basit lineer model | `Sequential([Dense(128), Dense(10)])` |
| Functional | Dallanma, multi-input/output | `inputs = Input(); x = Dense(128)(inputs)` |
| Subclass | Karmaşık, custom logic | `class MyModel(Model): def call(self, x)` |

## tf.data Pipeline (Best Practice)
```python
dataset = tf.data.Dataset.from_tensor_slices((x_train, y_train))
dataset = (dataset
    .shuffle(buffer_size=10000)
    .map(preprocess_fn, num_parallel_calls=tf.data.AUTOTUNE)
    .batch(32)
    .prefetch(tf.data.AUTOTUNE))
```

## Callbacks
```python
callbacks = [
    tf.keras.callbacks.EarlyStopping(patience=10, restore_best_weights=True),
    tf.keras.callbacks.ModelCheckpoint('best.keras', save_best_only=True),
    tf.keras.callbacks.ReduceLROnPlateau(factor=0.5, patience=5),
    tf.keras.callbacks.TensorBoard(log_dir='logs/'),
]
model.fit(train_ds, validation_data=val_ds, epochs=100, callbacks=callbacks)
```
