# 🐛 Debug Tips — NLP Transformers

## Sık Hatalar
- **"CUDA OOM"** → batch_size↓, gradient_accumulation↑, LoRA, fp16
- **Tokenizer mismatch** → Model ve tokenizer aynı checkpoint'ten mi?
- **Label ID hatası** → `id2label`, `label2id` model config'de tanımlı mı?
- **"expected input_ids"** → Dataset column'ları: `input_ids`, `attention_mask`, `labels`
- **Slow training** → `fp16=True`, `dataloader_num_workers=4`

## Araçlar
| Araç | Kullanım |
|------|----------|
| `pipeline()` | Hızlı inference test |
| `model.print_trainable_parameters()` | PEFT kontrol |
| TensorBoard | Loss curve |
| `accelerate` | Multi-GPU |

## Debug Günlüğü
| Tarih | Hata | Çözüm |
|-------|------|--------|
| [—]   | [—]  | [—]    |
