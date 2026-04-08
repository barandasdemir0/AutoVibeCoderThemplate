# 📚 Resources — TensorFlow
| Kaynak | Link |
|--------|------|
| TensorFlow | https://www.tensorflow.org |
| Keras | https://keras.io |
| TF Hub | https://tfhub.dev |
| TFLite | https://www.tensorflow.org/lite |
| TF Datasets | https://www.tensorflow.org/datasets |

## Transfer Learning Snippet
```python
base = tf.keras.applications.EfficientNetV2S(include_top=False, weights='imagenet', input_shape=(224,224,3))
base.trainable = False
model = tf.keras.Sequential([base, GlobalAveragePooling2D(), Dropout(0.3), Dense(num_classes, activation='softmax')])
model.compile(optimizer=Adam(1e-3), loss='sparse_categorical_crossentropy', metrics=['accuracy'])
```
