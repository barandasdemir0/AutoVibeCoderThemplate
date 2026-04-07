# 🐛 Debug Tips — TensorFlow

## Sık Hatalar
- **OOM**: `batch_size` küçült, `tf.keras.mixed_precision` aç
- **Loss NaN**: LR düşür, data normalize, `clipnorm` optimizer'da
- **Shape mismatch**: `model.summary()` kontrol, Input shape doğru mu?
- **GPU algılanmıyor**: `tf.config.list_physical_devices('GPU')` → CUDA/cuDNN kontrolü
- **Slow**: `tf.data.AUTOTUNE`, `num_parallel_calls`, GPU kullanım %'si kontrol

## Araçlar
| Araç | Komut |
|------|-------|
| TensorBoard | `tensorboard --logdir=logs` |
| model.summary() | Parametre sayısı, boyutlar |
| tf.debugging | `tf.debugging.assert_all_finite(tensor)` |
| Profiler | `tf.profiler` |

## Experiment Günlüğü
| Tarih | Model | LR | Epochs | Batch | Val Loss | Val Acc | Notlar |
|-------|-------|----|--------|-------|----------|---------|--------|
| [—]   | [—]   | [—]| [—]   | [—]   | [—]      | [—]     | [—]    |
