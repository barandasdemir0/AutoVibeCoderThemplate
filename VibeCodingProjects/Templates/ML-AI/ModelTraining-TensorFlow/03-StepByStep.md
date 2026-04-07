# 📝 Step-by-Step — TensorFlow

## Adımlar
1. [ ] `pip install tensorflow pandas numpy matplotlib`
2. [ ] EDA notebook → veri keşfi, dağılım, class balance
3. [ ] tf.data pipeline → load, preprocess, augment, batch, prefetch
4. [ ] Model tanımla → Keras Sequential/Functional
5. [ ] `model.compile(optimizer, loss, metrics)`
6. [ ] `model.fit(train_ds, validation_data=val_ds, callbacks=[...])`
7. [ ] `model.evaluate(test_ds)` → confusion matrix, classification report
8. [ ] `model.save('model.keras')` / TFLite export
9. [ ] Inference → `model.predict(new_data)`

# 📂 Files Structure
```
project/ → data/, src/(data, models, training, evaluation, inference), configs/, notebooks/, checkpoints/, logs/, train.py
```

# 🐛 Debug Tips
- **OOM**: batch_size küçült, `tf.data` prefetch, mixed precision (`tf.keras.mixed_precision`)
- **Loss NaN**: LR düşür, data normalization, gradient clipping (`optimizer.clipnorm=1.0`)
- **Shape error**: `model.summary()` ile boyutları kontrol et
- **Slow training**: `tf.data.AUTOTUNE`, GPU kontrol (`tf.config.list_physical_devices('GPU')`)
- **Overfitting**: Dropout, augmentation, EarlyStopping, regularization

# 📚 Resources
| Kaynak | Link |
|--------|------|
| TensorFlow | https://www.tensorflow.org |
| Keras | https://keras.io |
| TF Tutorials | https://www.tensorflow.org/tutorials |
| TF Hub | https://tfhub.dev |
| TFLite | https://www.tensorflow.org/lite |

### Snippets
```python
# Transfer Learning
base = tf.keras.applications.MobileNetV3Small(include_top=False, input_shape=(224,224,3))
base.trainable = False
model = tf.keras.Sequential([base, GlobalAveragePooling2D(), Dense(128, activation='relu'), Dense(num_classes, activation='softmax')])

# CLI
pip install tensorflow
python train.py
tensorboard --logdir=logs
```
