# 📂 Files Structure | Best Practices — NLP Transformers

## Files Structure
```
project/
├── data/ (raw/, processed/, splits/)
├── src/
│   ├── data/ (dataset.py, tokenize.py)
│   ├── models/ (model.py, config.py)
│   ├── training/ (trainer.py, peft.py)
│   ├── evaluation/ (evaluate.py)
│   └── inference/ (predict.py, gradio_app.py)
├── configs/, notebooks/, models/, logs/
├── train.py, predict.py, requirements.txt, README.md
```

## 📝 Best Practices

### Tokenization
- **padding='max_length'** eğitimde, **padding='longest'** inference'da
- **truncation=True** her zaman açık olsun
- **max_length**: BERT=512, GPT=2048+, gerektiği kadar küçült

### Training
- **Learning Rate**: BERT fine-tune → `2e-5` ile başla
- **Warmup**: İlk %10 step → warmup (`warmup_ratio=0.1`)
- **Weight Decay**: `0.01` (AdamW default)
- **fp16/bf16**: Hız + bellek kazanımı
- **Gradient Accumulation**: Büyük batch simüle et

### Evaluation
- **Classification**: Accuracy + F1 (macro) + Confusion Matrix
- **NER**: Entity-level F1 (seqeval)
- **Generation**: BLEU, ROUGE, perplexity

### Production
- **ONNX export**: 2-3x hızlı inference
- **Quantization**: INT8 ile model boyutu %75 küçülür
- **Batch inference**: Tek tek değil toplu işle
