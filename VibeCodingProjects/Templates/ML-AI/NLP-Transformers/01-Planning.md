# 📋 Planning — NLP Transformers

## 🎯 Proje
- **Proje Adı:** [—]
- **Tip:** Doğal Dil İşleme (Text Classification / NER / Summarization / Q&A / Chatbot)
- **Açıklama:** [—]

## 🛠️ Tech Stack
| Katman | Teknoloji |
|--------|-----------|
| Framework | Hugging Face Transformers |
| Model | BERT / GPT / T5 / LLaMA / Mistral |
| Tokenizer | AutoTokenizer (HF) |
| Fine-tune | Trainer API / PEFT (LoRA) |
| Veri | Datasets (HF), Pandas |
| Deploy | FastAPI, Gradio, ONNX |
| Experiment | W&B, TensorBoard |

## 📦 pip
```
transformers
datasets
tokenizers
accelerate
peft          # LoRA fine-tuning
bitsandbytes  # Quantization
evaluate
sentencepiece
gradio
fastapi uvicorn
torch
```

## ⭐ MVP
1. [ ] Dataset hazırla (text + label)
2. [ ] Pretrained model + tokenizer yükle
3. [ ] Tokenize → Dataset format
4. [ ] Fine-tune (Trainer API)
5. [ ] Evaluate (accuracy, F1)
6. [ ] Inference pipeline
7. [ ] Deploy (Gradio / FastAPI)
