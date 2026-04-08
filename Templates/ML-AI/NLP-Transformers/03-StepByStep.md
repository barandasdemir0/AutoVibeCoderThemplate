# 📝 Step-by-Step | 📂 Files | 🐛 Debug | 📚 Resources — NLP Transformers

## Adımlar
1. [ ] `pip install transformers datasets evaluate accelerate`
2. [ ] Dataset hazırla (CSV: text, label) → `datasets.load_dataset('csv', data_files=...)`
3. [ ] Tokenizer: `AutoTokenizer.from_pretrained('bert-base-uncased')`
4. [ ] Tokenize: `dataset.map(tokenize_fn, batched=True)`
5. [ ] Model: `AutoModelForSequenceClassification.from_pretrained(..., num_labels=N)`
6. [ ] TrainingArguments + Trainer → `trainer.train()`
7. [ ] Evaluate: accuracy, F1, confusion matrix
8. [ ] Inference: `pipeline('text-classification', model=model, tokenizer=tokenizer)`
9. [ ] Gradio demo / FastAPI endpoint

## Dosya Açıklamaları
| Dosya | Ne İş Yapar |
|-------|-------------|
| `dataset.py` | HF Dataset yükleme, preprocessing |
| `tokenize.py` | Text → token ID'leri dönüştürme |
| `model.py` | Pretrained model yükleme, head ekleme |
| `trainer.py` | HF Trainer ile eğitim döngüsü |
| `peft.py` | LoRA/QLoRA ile büyük model fine-tune |
| `evaluate.py` | Metrik hesaplama (accuracy, F1, BLEU, ROUGE) |
| `predict.py` | Tek/batch inference pipeline |
| `gradio_app.py` | Web demo arayüzü |

## Debug Tips
- **Tokenizer hatası** → `tokenizer.encode('test')` ile kontrol, special tokens?
- **CUDA OOM** → batch_size küçült, gradient accumulation, LoRA/QLoRA kullan
- **F1 düşük** → Class imbalance? Weighted loss, oversampling
- **Slow** → `fp16=True` TrainingArguments'ta, `accelerate` kullan
- **"Token indices sequence length"** → `max_length` artır veya truncation

## Resources
| Kaynak | Link |
|--------|------|
| HuggingFace | https://huggingface.co |
| Transformers | https://huggingface.co/docs/transformers |
| HF Datasets | https://huggingface.co/docs/datasets |
| PEFT | https://huggingface.co/docs/peft |
| Gradio | https://gradio.app |
| HF Model Hub | https://huggingface.co/models |

## Experiment Günlüğü
| Tarih | Model | LR | Epochs | Batch | F1 | Acc | Notlar |
|-------|-------|----|--------|-------|----|-----|--------|
| [—]   | [—]   | [—]| [—]   | [—]   | [—]| [—] | [—]    |
